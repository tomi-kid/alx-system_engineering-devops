# File: nginx_config.pp

exec { 'install_nginx':
  command => 'apt-get update && apt-get install nginx -y',
  path    => ['/usr/bin', '/usr/sbin'],
  creates => '/etc/nginx/sites-available/default',
}

file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => '
    server {
      listen 80 default_server;
      listen [::]:80 default_server;

      root /var/www/html;

      location / {
        return 200 "Hello World!\n";
      }

      location /redirect_me {
        return 301 https://www.example.com/;
      }
    }
  ',
  notify  => Service['nginx'],
}

service { 'nginx':
  ensure  => running,
  enable  => true,
}
