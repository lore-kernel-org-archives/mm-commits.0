From: akpm@linux-foundation.org
Subject: [merged] backlight-ams369fg06-use-spi_get_drvdata-and-spi_set_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:17 -0800
Message-ID: <20130222204117.9C3585A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:52029 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab3BVUlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:18 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so103992qen.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ams369fg06: use spi_get_drvdata and spi_set_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-ams369fg06-use-spi_get_drvdata-and-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ams369fg06: use spi_get_drvdata and spi_set_drvdata

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-use-spi_get_drvdata-and-spi_set_drvdata drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-use-spi_get_drvdata-and-spi_set_drvdata
+++ a/drivers/video/backlight/ams369fg06.c
@@ -513,7 +513,7 @@ static int ams369fg06_probe(struct spi_d
 		lcd->power = FB_BLANK_UNBLANK;
 	}
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 
 	dev_info(&spi->dev, "ams369fg06 panel driver has been probed.\n");
 
@@ -526,7 +526,7 @@ out_lcd_unregister:
 
 static int ams369fg06_remove(struct spi_device *spi)
 {
-	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
+	struct ams369fg06 *lcd = spi_get_drvdata(spi);
 
 	ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
 	backlight_device_unregister(lcd->bd);
@@ -538,7 +538,7 @@ static int ams369fg06_remove(struct spi_
 #if defined(CONFIG_PM)
 static int ams369fg06_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
+	struct ams369fg06 *lcd = spi_get_drvdata(spi);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
@@ -551,7 +551,7 @@ static int ams369fg06_suspend(struct spi
 
 static int ams369fg06_resume(struct spi_device *spi)
 {
-	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
+	struct ams369fg06 *lcd = spi_get_drvdata(spi);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
@@ -564,7 +564,7 @@ static int ams369fg06_resume(struct spi_
 
 static void ams369fg06_shutdown(struct spi_device *spi)
 {
-	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
+	struct ams369fg06 *lcd = spi_get_drvdata(spi);
 
 	ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

