From: akpm@linux-foundation.org
Subject: [merged] backlight-corgi_lcd-use-spi_get_drvdata-and-spi_set_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:26 -0800
Message-ID: <20130222204126.9909E31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:35134 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab3BVUl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:27 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so103978yhr.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: corgi_lcd: use spi_get_drvdata and spi_set_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-corgi_lcd-use-spi_get_drvdata-and-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: corgi_lcd: use spi_get_drvdata and spi_set_drvdata

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/corgi_lcd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-spi_get_drvdata-and-spi_set_drvdata drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-spi_get_drvdata-and-spi_set_drvdata
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -460,7 +460,7 @@ static const struct backlight_ops corgi_
 #ifdef CONFIG_PM
 static int corgi_lcd_suspend(struct spi_device *spi, pm_message_t state)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&spi->dev);
+	struct corgi_lcd *lcd = spi_get_drvdata(spi);
 
 	corgibl_flags |= CORGIBL_SUSPENDED;
 	corgi_bl_set_intensity(lcd, 0);
@@ -470,7 +470,7 @@ static int corgi_lcd_suspend(struct spi_
 
 static int corgi_lcd_resume(struct spi_device *spi)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&spi->dev);
+	struct corgi_lcd *lcd = spi_get_drvdata(spi);
 
 	corgibl_flags &= ~CORGIBL_SUSPENDED;
 	corgi_lcd_set_power(lcd->lcd_dev, FB_BLANK_UNBLANK);
@@ -577,7 +577,7 @@ static int corgi_lcd_probe(struct spi_de
 
 	lcd->kick_battery = pdata->kick_battery;
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 	corgi_lcd_set_power(lcd->lcd_dev, FB_BLANK_UNBLANK);
 	backlight_update_status(lcd->bl_dev);
 
@@ -594,7 +594,7 @@ err_unregister_lcd:
 
 static int corgi_lcd_remove(struct spi_device *spi)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&spi->dev);
+	struct corgi_lcd *lcd = spi_get_drvdata(spi);
 
 	lcd->bl_dev->props.power = FB_BLANK_UNBLANK;
 	lcd->bl_dev->props.brightness = 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

