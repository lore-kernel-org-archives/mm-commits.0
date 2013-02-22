From: akpm@linux-foundation.org
Subject: [merged] backlight-lms501kf03-use-spi_get_drvdata-and-spi_set_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:29 -0800
Message-ID: <20130222204129.9D3175A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:46083 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab3BVUla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:30 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so103499vbi.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lms501kf03: use spi_get_drvdata and spi_set_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-lms501kf03-use-spi_get_drvdata-and-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lms501kf03: use spi_get_drvdata and spi_set_drvdata

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms501kf03.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/lms501kf03.c~backlight-lms501kf03-use-spi_get_drvdata-and-spi_set_drvdata drivers/video/backlight/lms501kf03.c
--- a/drivers/video/backlight/lms501kf03.c~backlight-lms501kf03-use-spi_get_drvdata-and-spi_set_drvdata
+++ a/drivers/video/backlight/lms501kf03.c
@@ -370,7 +370,7 @@ static int lms501kf03_probe(struct spi_d
 		lcd->power = FB_BLANK_UNBLANK;
 	}
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 
 	dev_info(&spi->dev, "lms501kf03 panel driver has been probed.\n");
 
@@ -379,7 +379,7 @@ static int lms501kf03_probe(struct spi_d
 
 static int lms501kf03_remove(struct spi_device *spi)
 {
-	struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
+	struct lms501kf03 *lcd = spi_get_drvdata(spi);
 
 	lms501kf03_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->ld);
@@ -391,7 +391,7 @@ static int lms501kf03_remove(struct spi_
 
 static int lms501kf03_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
+	struct lms501kf03 *lcd = spi_get_drvdata(spi);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
@@ -404,7 +404,7 @@ static int lms501kf03_suspend(struct spi
 
 static int lms501kf03_resume(struct spi_device *spi)
 {
-	struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
+	struct lms501kf03 *lcd = spi_get_drvdata(spi);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
@@ -417,7 +417,7 @@ static int lms501kf03_resume(struct spi_
 
 static void lms501kf03_shutdown(struct spi_device *spi)
 {
-	struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
+	struct lms501kf03 *lcd = spi_get_drvdata(spi);
 
 	lms501kf03_power(lcd, FB_BLANK_POWERDOWN);
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

