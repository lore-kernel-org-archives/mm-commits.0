From: akpm@linux-foundation.org
Subject: [merged] backlight-s6e63m0-convert-s6e63m0-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:44 -0700
Message-ID: <20130430185144.70DAC5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:54520 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3D3Svp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:45 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so87798qad.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: s6e63m0: convert s6e63m0 to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-s6e63m0-convert-s6e63m0-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: s6e63m0: convert s6e63m0 to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-convert-s6e63m0-to-dev_pm_ops drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-convert-s6e63m0-to-dev_pm_ops
+++ a/drivers/video/backlight/s6e63m0.c
@@ -817,12 +817,12 @@ static int s6e63m0_remove(struct spi_dev
 	return 0;
 }
 
-#if defined(CONFIG_PM)
-static int s6e63m0_suspend(struct spi_device *spi, pm_message_t mesg)
+#ifdef CONFIG_PM_SLEEP
+static int s6e63m0_suspend(struct device *dev)
 {
-	struct s6e63m0 *lcd = spi_get_drvdata(spi);
+	struct s6e63m0 *lcd = dev_get_drvdata(dev);
 
-	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
+	dev_dbg(dev, "lcd->power = %d\n", lcd->power);
 
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
@@ -831,19 +831,18 @@ static int s6e63m0_suspend(struct spi_de
 	return s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
 }
 
-static int s6e63m0_resume(struct spi_device *spi)
+static int s6e63m0_resume(struct device *dev)
 {
-	struct s6e63m0 *lcd = spi_get_drvdata(spi);
+	struct s6e63m0 *lcd = dev_get_drvdata(dev);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
 	return s6e63m0_power(lcd, FB_BLANK_UNBLANK);
 }
-#else
-#define s6e63m0_suspend		NULL
-#define s6e63m0_resume		NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(s6e63m0_pm_ops, s6e63m0_suspend, s6e63m0_resume);
+
 /* Power down all displays on reboot, poweroff or halt. */
 static void s6e63m0_shutdown(struct spi_device *spi)
 {
@@ -856,12 +855,11 @@ static struct spi_driver s6e63m0_driver
 	.driver = {
 		.name	= "s6e63m0",
 		.owner	= THIS_MODULE,
+		.pm	= &s6e63m0_pm_ops,
 	},
 	.probe		= s6e63m0_probe,
 	.remove		= s6e63m0_remove,
 	.shutdown	= s6e63m0_shutdown,
-	.suspend	= s6e63m0_suspend,
-	.resume		= s6e63m0_resume,
 };
 
 module_spi_driver(s6e63m0_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

