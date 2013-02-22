From: akpm@linux-foundation.org
Subject: [merged] backlight-s6e63m0-use-spi_get_drvdata-and-spi_set_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:05 -0800
Message-ID: <20130222204105.A6D8231C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:39192 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795Ab3BVUlG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:06 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so103981qen.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: s6e63m0: use spi_get_drvdata and spi_set_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-s6e63m0-use-spi_get_drvdata-and-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: s6e63m0: use spi_get_drvdata and spi_set_drvdata

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-use-spi_get_drvdata-and-spi_set_drvdata drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-use-spi_get_drvdata-and-spi_set_drvdata
+++ a/drivers/video/backlight/s6e63m0.c
@@ -793,7 +793,7 @@ static int s6e63m0_probe(struct spi_devi
 		lcd->power = FB_BLANK_UNBLANK;
 	}
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 
 	dev_info(&spi->dev, "s6e63m0 panel driver has been probed.\n");
 
@@ -806,7 +806,7 @@ out_lcd_unregister:
 
 static int s6e63m0_remove(struct spi_device *spi)
 {
-	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
+	struct s6e63m0 *lcd = spi_get_drvdata(spi);
 
 	s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
 	device_remove_file(&spi->dev, &dev_attr_gamma_table);
@@ -820,7 +820,7 @@ static int s6e63m0_remove(struct spi_dev
 #if defined(CONFIG_PM)
 static int s6e63m0_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
+	struct s6e63m0 *lcd = spi_get_drvdata(spi);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
@@ -833,7 +833,7 @@ static int s6e63m0_suspend(struct spi_de
 
 static int s6e63m0_resume(struct spi_device *spi)
 {
-	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
+	struct s6e63m0 *lcd = spi_get_drvdata(spi);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
@@ -847,7 +847,7 @@ static int s6e63m0_resume(struct spi_dev
 /* Power down all displays on reboot, poweroff or halt. */
 static void s6e63m0_shutdown(struct spi_device *spi)
 {
-	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
+	struct s6e63m0 *lcd = spi_get_drvdata(spi);
 
 	s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

