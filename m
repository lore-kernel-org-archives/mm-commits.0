From: akpm@linux-foundation.org
Subject: [merged] backlight-ld9040-convert-ld9040-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:38 -0700
Message-ID: <20130430185138.7229931C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46968 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3D3Svj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:39 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so86503vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ld9040: convert ld9040 to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-ld9040-convert-ld9040-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ld9040: convert ld9040 to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN drivers/video/backlight/ld9040.c~backlight-ld9040-convert-ld9040-to-dev_pm_ops drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~backlight-ld9040-convert-ld9040-to-dev_pm_ops
+++ a/drivers/video/backlight/ld9040.c
@@ -775,12 +775,12 @@ static int ld9040_remove(struct spi_devi
 	return 0;
 }
 
-#if defined(CONFIG_PM)
-static int ld9040_suspend(struct spi_device *spi, pm_message_t mesg)
+#ifdef CONFIG_PM_SLEEP
+static int ld9040_suspend(struct device *dev)
 {
-	struct ld9040 *lcd = spi_get_drvdata(spi);
+	struct ld9040 *lcd = dev_get_drvdata(dev);
 
-	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
+	dev_dbg(dev, "lcd->power = %d\n", lcd->power);
 
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
@@ -789,19 +789,18 @@ static int ld9040_suspend(struct spi_dev
 	return ld9040_power(lcd, FB_BLANK_POWERDOWN);
 }
 
-static int ld9040_resume(struct spi_device *spi)
+static int ld9040_resume(struct device *dev)
 {
-	struct ld9040 *lcd = spi_get_drvdata(spi);
+	struct ld9040 *lcd = dev_get_drvdata(dev);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
 	return ld9040_power(lcd, FB_BLANK_UNBLANK);
 }
-#else
-#define ld9040_suspend		NULL
-#define ld9040_resume		NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(ld9040_pm_ops, ld9040_suspend, ld9040_resume);
+
 /* Power down all displays on reboot, poweroff or halt. */
 static void ld9040_shutdown(struct spi_device *spi)
 {
@@ -814,12 +813,11 @@ static struct spi_driver ld9040_driver =
 	.driver = {
 		.name	= "ld9040",
 		.owner	= THIS_MODULE,
+		.pm	= &ld9040_pm_ops,
 	},
 	.probe		= ld9040_probe,
 	.remove		= ld9040_remove,
 	.shutdown	= ld9040_shutdown,
-	.suspend	= ld9040_suspend,
-	.resume		= ld9040_resume,
 };
 
 module_spi_driver(ld9040_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

