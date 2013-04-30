From: akpm@linux-foundation.org
Subject: [merged] backlight-vgg2432a4-convert-vgg2432a4_driver-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:51 -0700
Message-ID: <20130430185251.70CE531C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:33794 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab3D3Sww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:52 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so86581vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: vgg2432a4: convert vgg2432a4_driver to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-vgg2432a4-convert-vgg2432a4_driver-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: vgg2432a4: convert vgg2432a4_driver to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management. Also, use of
pm_message_t is deprecated. Thus, it is removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ili9320.c   |   24 +++++++++---------------
 drivers/video/backlight/ili9320.h   |    2 +-
 drivers/video/backlight/vgg2432a4.c |   18 ++++++++----------
 3 files changed, 18 insertions(+), 26 deletions(-)

diff -puN drivers/video/backlight/ili9320.c~backlight-vgg2432a4-convert-vgg2432a4_driver-to-dev_pm_ops drivers/video/backlight/ili9320.c
--- a/drivers/video/backlight/ili9320.c~backlight-vgg2432a4-convert-vgg2432a4_driver-to-dev_pm_ops
+++ a/drivers/video/backlight/ili9320.c
@@ -270,27 +270,21 @@ int ili9320_remove(struct ili9320 *ili)
 }
 EXPORT_SYMBOL_GPL(ili9320_remove);
 
-#ifdef CONFIG_PM
-int ili9320_suspend(struct ili9320 *lcd, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+int ili9320_suspend(struct ili9320 *lcd)
 {
 	int ret;
 
-	dev_dbg(lcd->dev, "%s: event %d\n", __func__, state.event);
+	ret = ili9320_power(lcd, FB_BLANK_POWERDOWN);
 
-	if (state.event == PM_EVENT_SUSPEND) {
-		ret = ili9320_power(lcd, FB_BLANK_POWERDOWN);
-
-		if (lcd->platdata->suspend == ILI9320_SUSPEND_DEEP) {
-			ili9320_write(lcd, ILI9320_POWER1, lcd->power1 |
-				      ILI9320_POWER1_SLP |
-				      ILI9320_POWER1_DSTB);
-			lcd->initialised = 0;
-		}
-
-		return ret;
+	if (lcd->platdata->suspend == ILI9320_SUSPEND_DEEP) {
+		ili9320_write(lcd, ILI9320_POWER1, lcd->power1 |
+			      ILI9320_POWER1_SLP |
+			      ILI9320_POWER1_DSTB);
+		lcd->initialised = 0;
 	}
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(ili9320_suspend);
 
diff -puN drivers/video/backlight/ili9320.h~backlight-vgg2432a4-convert-vgg2432a4_driver-to-dev_pm_ops drivers/video/backlight/ili9320.h
--- a/drivers/video/backlight/ili9320.h~backlight-vgg2432a4-convert-vgg2432a4_driver-to-dev_pm_ops
+++ a/drivers/video/backlight/ili9320.h
@@ -76,5 +76,5 @@ extern void ili9320_shutdown(struct ili9
 
 /* PM */
 
-extern int ili9320_suspend(struct ili9320 *lcd, pm_message_t state);
+extern int ili9320_suspend(struct ili9320 *lcd);
 extern int ili9320_resume(struct ili9320 *lcd);
diff -puN drivers/video/backlight/vgg2432a4.c~backlight-vgg2432a4-convert-vgg2432a4_driver-to-dev_pm_ops drivers/video/backlight/vgg2432a4.c
--- a/drivers/video/backlight/vgg2432a4.c~backlight-vgg2432a4-convert-vgg2432a4_driver-to-dev_pm_ops
+++ a/drivers/video/backlight/vgg2432a4.c
@@ -205,18 +205,15 @@ static int vgg2432a4_lcd_init(struct ili
 	return ret;
 }
 
-#ifdef CONFIG_PM
-static int vgg2432a4_suspend(struct spi_device *spi, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int vgg2432a4_suspend(struct device *dev)
 {
-	return ili9320_suspend(spi_get_drvdata(spi), state);
+	return ili9320_suspend(dev_get_drvdata(dev));
 }
-static int vgg2432a4_resume(struct spi_device *spi)
+static int vgg2432a4_resume(struct device *dev)
 {
-	return ili9320_resume(spi_get_drvdata(spi));
+	return ili9320_resume(dev_get_drvdata(dev));
 }
-#else
-#define vgg2432a4_suspend	NULL
-#define vgg2432a4_resume	NULL
 #endif
 
 static struct ili9320_client vgg2432a4_client = {
@@ -249,16 +246,17 @@ static void vgg2432a4_shutdown(struct sp
 	ili9320_shutdown(spi_get_drvdata(spi));
 }
 
+static SIMPLE_DEV_PM_OPS(vgg2432a4_pm_ops, vgg2432a4_suspend, vgg2432a4_resume);
+
 static struct spi_driver vgg2432a4_driver = {
 	.driver = {
 		.name		= "VGG2432A4",
 		.owner		= THIS_MODULE,
+		.pm		= &vgg2432a4_pm_ops,
 	},
 	.probe		= vgg2432a4_probe,
 	.remove		= vgg2432a4_remove,
 	.shutdown	= vgg2432a4_shutdown,
-	.suspend	= vgg2432a4_suspend,
-	.resume		= vgg2432a4_resume,
 };
 
 module_spi_driver(vgg2432a4_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

