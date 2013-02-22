From: akpm@linux-foundation.org
Subject: [merged] backlight-ltv350qv-use-spi_get_drvdata-and-spi_set_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:08 -0800
Message-ID: <20130222204108.9BE8E5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:42358 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804Ab3BVUlJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:09 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so103842qcr.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ltv350qv: use spi_get_drvdata and spi_set_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-ltv350qv-use-spi_get_drvdata-and-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ltv350qv: use spi_get_drvdata and spi_set_drvdata

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ltv350qv.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/ltv350qv.c~backlight-ltv350qv-use-spi_get_drvdata-and-spi_set_drvdata drivers/video/backlight/ltv350qv.c
--- a/drivers/video/backlight/ltv350qv.c~backlight-ltv350qv-use-spi_get_drvdata-and-spi_set_drvdata
+++ a/drivers/video/backlight/ltv350qv.c
@@ -252,7 +252,7 @@ static int ltv350qv_probe(struct spi_dev
 	if (ret)
 		goto out_unregister;
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 
 	return 0;
 
@@ -263,7 +263,7 @@ out_unregister:
 
 static int ltv350qv_remove(struct spi_device *spi)
 {
-	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+	struct ltv350qv *lcd = spi_get_drvdata(spi);
 
 	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->ld);
@@ -274,14 +274,14 @@ static int ltv350qv_remove(struct spi_de
 #ifdef CONFIG_PM
 static int ltv350qv_suspend(struct spi_device *spi, pm_message_t state)
 {
-	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+	struct ltv350qv *lcd = spi_get_drvdata(spi);
 
 	return ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 }
 
 static int ltv350qv_resume(struct spi_device *spi)
 {
-	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+	struct ltv350qv *lcd = spi_get_drvdata(spi);
 
 	return ltv350qv_power(lcd, FB_BLANK_UNBLANK);
 }
@@ -293,7 +293,7 @@ static int ltv350qv_resume(struct spi_de
 /* Power down all displays on reboot, poweroff or halt */
 static void ltv350qv_shutdown(struct spi_device *spi)
 {
-	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+	struct ltv350qv *lcd = spi_get_drvdata(spi);
 
 	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

