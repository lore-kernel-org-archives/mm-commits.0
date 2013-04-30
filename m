From: akpm@linux-foundation.org
Subject: [merged] backlight-lms501kf03-convert-lms501kf03-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:41 -0700
Message-ID: <20130430185141.7221631C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:33887 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3D3Svm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:42 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so86261ggc.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lms501kf03: convert lms501kf03 to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-lms501kf03-convert-lms501kf03-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lms501kf03: convert lms501kf03 to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms501kf03.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/video/backlight/lms501kf03.c~backlight-lms501kf03-convert-lms501kf03-to-dev_pm_ops drivers/video/backlight/lms501kf03.c
--- a/drivers/video/backlight/lms501kf03.c~backlight-lms501kf03-convert-lms501kf03-to-dev_pm_ops
+++ a/drivers/video/backlight/lms501kf03.c
@@ -387,13 +387,12 @@ static int lms501kf03_remove(struct spi_
 	return 0;
 }
 
-#if defined(CONFIG_PM)
-
-static int lms501kf03_suspend(struct spi_device *spi, pm_message_t mesg)
+#ifdef CONFIG_PM_SLEEP
+static int lms501kf03_suspend(struct device *dev)
 {
-	struct lms501kf03 *lcd = spi_get_drvdata(spi);
+	struct lms501kf03 *lcd = dev_get_drvdata(dev);
 
-	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
+	dev_dbg(dev, "lcd->power = %d\n", lcd->power);
 
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
@@ -402,19 +401,19 @@ static int lms501kf03_suspend(struct spi
 	return lms501kf03_power(lcd, FB_BLANK_POWERDOWN);
 }
 
-static int lms501kf03_resume(struct spi_device *spi)
+static int lms501kf03_resume(struct device *dev)
 {
-	struct lms501kf03 *lcd = spi_get_drvdata(spi);
+	struct lms501kf03 *lcd = dev_get_drvdata(dev);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
 	return lms501kf03_power(lcd, FB_BLANK_UNBLANK);
 }
-#else
-#define lms501kf03_suspend	NULL
-#define lms501kf03_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(lms501kf03_pm_ops, lms501kf03_suspend,
+			lms501kf03_resume);
+
 static void lms501kf03_shutdown(struct spi_device *spi)
 {
 	struct lms501kf03 *lcd = spi_get_drvdata(spi);
@@ -426,12 +425,11 @@ static struct spi_driver lms501kf03_driv
 	.driver = {
 		.name	= "lms501kf03",
 		.owner	= THIS_MODULE,
+		.pm	= &lms501kf03_pm_ops,
 	},
 	.probe		= lms501kf03_probe,
 	.remove		= lms501kf03_remove,
 	.shutdown	= lms501kf03_shutdown,
-	.suspend	= lms501kf03_suspend,
-	.resume		= lms501kf03_resume,
 };
 
 module_spi_driver(lms501kf03_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

