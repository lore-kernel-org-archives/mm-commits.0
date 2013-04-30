From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:10 -0700
Message-ID: <20130430185110.6F1A931C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:61698 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3SvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:11 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so86313vbe.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/ams369fg06.c: convert ams369fg06 to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/ams369fg06.c: convert ams369fg06 to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops
+++ a/drivers/video/backlight/ams369fg06.c
@@ -533,12 +533,12 @@ static int ams369fg06_remove(struct spi_
 	return 0;
 }
 
-#if defined(CONFIG_PM)
-static int ams369fg06_suspend(struct spi_device *spi, pm_message_t mesg)
+#ifdef CONFIG_PM_SLEEP
+static int ams369fg06_suspend(struct device *dev)
 {
-	struct ams369fg06 *lcd = spi_get_drvdata(spi);
+	struct ams369fg06 *lcd = dev_get_drvdata(dev);
 
-	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
+	dev_dbg(dev, "lcd->power = %d\n", lcd->power);
 
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
@@ -547,19 +547,19 @@ static int ams369fg06_suspend(struct spi
 	return ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
 }
 
-static int ams369fg06_resume(struct spi_device *spi)
+static int ams369fg06_resume(struct device *dev)
 {
-	struct ams369fg06 *lcd = spi_get_drvdata(spi);
+	struct ams369fg06 *lcd = dev_get_drvdata(dev);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
 	return ams369fg06_power(lcd, FB_BLANK_UNBLANK);
 }
-#else
-#define ams369fg06_suspend	NULL
-#define ams369fg06_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(ams369fg06_pm_ops, ams369fg06_suspend,
+			ams369fg06_resume);
+
 static void ams369fg06_shutdown(struct spi_device *spi)
 {
 	struct ams369fg06 *lcd = spi_get_drvdata(spi);
@@ -571,12 +571,11 @@ static struct spi_driver ams369fg06_driv
 	.driver = {
 		.name	= "ams369fg06",
 		.owner	= THIS_MODULE,
+		.pm	= &ams369fg06_pm_ops,
 	},
 	.probe		= ams369fg06_probe,
 	.remove		= ams369fg06_remove,
 	.shutdown	= ams369fg06_shutdown,
-	.suspend	= ams369fg06_suspend,
-	.resume		= ams369fg06_resume,
 };
 
 module_spi_driver(ams369fg06_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

