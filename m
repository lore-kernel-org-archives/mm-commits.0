From: akpm@linux-foundation.org
Subject: [merged] backlight-ld9040-use-spi_get_drvdata-and-spi_set_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:02 -0800
Message-ID: <20130222204102.956755A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:58268 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795Ab3BVUlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:03 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so103910ggi.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ld9040: use spi_get_drvdata and spi_set_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-ld9040-use-spi_get_drvdata-and-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ld9040: use spi_get_drvdata and spi_set_drvdata

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/ld9040.c~backlight-ld9040-use-spi_get_drvdata-and-spi_set_drvdata drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~backlight-ld9040-use-spi_get_drvdata-and-spi_set_drvdata
+++ a/drivers/video/backlight/ld9040.c
@@ -755,7 +755,7 @@ static int ld9040_probe(struct spi_devic
 		lcd->power = FB_BLANK_UNBLANK;
 	}
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 
 	dev_info(&spi->dev, "ld9040 panel driver has been probed.\n");
 	return 0;
@@ -770,7 +770,7 @@ out_free_regulator:
 
 static int ld9040_remove(struct spi_device *spi)
 {
-	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
+	struct ld9040 *lcd = spi_get_drvdata(spi);
 
 	ld9040_power(lcd, FB_BLANK_POWERDOWN);
 	backlight_device_unregister(lcd->bd);
@@ -783,7 +783,7 @@ static int ld9040_remove(struct spi_devi
 #if defined(CONFIG_PM)
 static int ld9040_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
+	struct ld9040 *lcd = spi_get_drvdata(spi);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
@@ -796,7 +796,7 @@ static int ld9040_suspend(struct spi_dev
 
 static int ld9040_resume(struct spi_device *spi)
 {
-	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
+	struct ld9040 *lcd = spi_get_drvdata(spi);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
@@ -810,7 +810,7 @@ static int ld9040_resume(struct spi_devi
 /* Power down all displays on reboot, poweroff or halt. */
 static void ld9040_shutdown(struct spi_device *spi)
 {
-	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
+	struct ld9040 *lcd = spi_get_drvdata(spi);
 
 	ld9040_power(lcd, FB_BLANK_POWERDOWN);
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

