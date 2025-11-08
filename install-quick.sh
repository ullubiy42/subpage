#!/bin/bash

# Marzban VPN Wizard - Quick Installer (архив должен быть в текущей папке)
# Использование: bash install-quick.sh

set -e

echo "🚀 Установка Marzban VPN Wizard"
echo "================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Запустите с правами root:"
    echo "   sudo bash install-quick.sh"
    exit 1
fi

# Check if archive exists
if [ ! -f "marzban-template.tar.gz" ]; then
    echo "❌ Файл marzban-template.tar.gz не найден!"
    echo ""
    echo "📥 Скачайте архив одной из команд:"
    echo "   wget https://9e21f7bf-1956-4553-87af-651893ebbcdc-00-2zzpa73u59f54.janeway.replit.dev/download/marzban-archive -O marzban-template.tar.gz"
    echo "   curl -o marzban-template.tar.gz https://9e21f7bf-1956-4553-87af-651893ebbcdc-00-2zzpa73u59f54.janeway.replit.dev/download/marzban-archive"
    echo ""
    echo "Затем запустите этот скрипт снова."
    exit 1
fi

MARZBAN_DIR="/var/lib/marzban/templates/subscription"
ASSETS_DIR="$MARZBAN_DIR/assets"

echo "📦 Распаковка архива..."
rm -rf /tmp/marzban-wizard
mkdir -p /tmp/marzban-wizard
tar -xzf marzban-template.tar.gz -C /tmp/marzban-wizard

echo "📂 Создание директорий..."
mkdir -p "$ASSETS_DIR"

echo "📋 Копирование файлов..."
cp /tmp/marzban-wizard/index.html "$MARZBAN_DIR/index.html"
cp /tmp/marzban-wizard/assets/bundle.js "$ASSETS_DIR/bundle.js"
cp /tmp/marzban-wizard/assets/style.css "$ASSETS_DIR/style.css"

echo "🔐 Настройка прав доступа..."
chmod 644 "$MARZBAN_DIR/index.html"
chmod 644 "$ASSETS_DIR/bundle.js"
chmod 644 "$ASSETS_DIR/style.css"

echo "🧹 Очистка временных файлов..."
rm -rf /tmp/marzban-wizard

echo ""
echo "✅ Установка завершена!"
echo ""
echo "📂 Установленные файлы:"
ls -lh "$MARZBAN_DIR/index.html"
ls -lh "$ASSETS_DIR/"
echo ""

# Restart Marzban
read -p "🔄 Перезапустить Marzban сейчас? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v marzban &> /dev/null; then
        marzban restart
        echo "✅ Marzban перезапущен!"
    else
        echo "⚠️  Команда 'marzban' не найдена. Перезапустите вручную:"
        echo "   cd /opt/marzban && docker compose restart"
    fi
else
    echo "⚠️  Не забудьте перезапустить Marzban:"
    echo "   marzban restart"
    echo "   или: cd /opt/marzban && docker compose restart"
fi

echo ""
echo "🎉 Готово! Откройте subscription URL для проверки."
