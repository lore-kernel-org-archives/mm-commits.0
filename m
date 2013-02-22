From: akpm@linux-foundation.org
Subject: [merged] backlight-tosa-use-spi_get_drvdata-and-spi_set_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:23 -0800
Message-ID: <20130222204123.850DC31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:41491 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab3BVUlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:24 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so104126vch.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: tosa: use spi_get_drvdata and spi_set_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-tosa-use-spi_get_drvdata-and-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tosa: use spi_get_drvdata and spi_set_drvdata

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_lcd.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/tosa_lcd.c~backlight-tosa-use-spi_get_drvdata-and-spi_set_drvdata drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~backlight-tosa-use-spi_get_drvdata-and-spi_set_drvdata
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -193,7 +193,7 @@ static int tosa_lcd_probe(struct spi_dev
 		return ret;
 
 	data->spi = spi;
-	dev_set_drvdata(&spi->dev, data);
+	spi_set_drvdata(spi, data);
 
 	ret = devm_gpio_request_one(&spi->dev, TOSA_GPIO_TG_ON,
 				GPIOF_OUT_INIT_LOW, "tg #pwr");
@@ -220,13 +220,13 @@ static int tosa_lcd_probe(struct spi_dev
 err_register:
 	tosa_lcd_tg_off(data);
 err_gpio_tg:
-	dev_set_drvdata(&spi->dev, NULL);
+	spi_set_drvdata(spi, NULL);
 	return ret;
 }
 
 static int tosa_lcd_remove(struct spi_device *spi)
 {
-	struct tosa_lcd_data *data = dev_get_drvdata(&spi->dev);
+	struct tosa_lcd_data *data = spi_get_drvdata(spi);
 
 	lcd_device_unregister(data->lcd);
 
@@ -235,7 +235,7 @@ static int tosa_lcd_remove(struct spi_de
 
 	tosa_lcd_tg_off(data);
 
-	dev_set_drvdata(&spi->dev, NULL);
+	spi_set_drvdata(spi, NULL);
 
 	return 0;
 }
@@ -243,7 +243,7 @@ static int tosa_lcd_remove(struct spi_de
 #ifdef CONFIG_PM
 static int tosa_lcd_suspend(struct spi_device *spi, pm_message_t state)
 {
-	struct tosa_lcd_data *data = dev_get_drvdata(&spi->dev);
+	struct tosa_lcd_data *data = spi_get_drvdata(spi);
 
 	tosa_lcd_tg_off(data);
 
@@ -252,7 +252,7 @@ static int tosa_lcd_suspend(struct spi_d
 
 static int tosa_lcd_resume(struct spi_device *spi)
 {
-	struct tosa_lcd_data *data = dev_get_drvdata(&spi->dev);
+	struct tosa_lcd_data *data = spi_get_drvdata(spi);
 
 	tosa_lcd_tg_init(data);
 	if (POWER_IS_ON(data->lcd_power))
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

