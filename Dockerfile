FROM php:7.4-fpm

ENV TZ=Asia/Taipei
ENV COMPOSER_ALLOW_SUPERUSER=1
ARG DEBIAN_FRONTEND=noninteractive

# Install PHP and composer dependencies
RUN apt-get -y update && apt-get install -qq git curl libmcrypt-dev libjpeg-dev libpng-dev libfreetype6-dev libbz2-dev libzip-dev \
    libonig-dev libcurl4-openssl-dev autoconf libssl-dev pkg-config libmpdec-dev procps vim iputils-ping tmux htop unzip

# Clear out the local repository of retrieved package files
RUN apt-get remove -y --purge software-properties-common \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --version=2.5.1 --filename=composer

# Install needed extensions
RUN docker-php-ext-install pdo_mysql zip gd bcmath mbstring curl pcntl sockets opcache

# install redis
RUN pecl install redis && docker-php-ext-enable redis

# install decimal
RUN pecl install decimal && docker-php-ext-enable decimal

# install pcov
RUN pecl install pcov && docker-php-ext-enable pcov
