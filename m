From: akpm@linux-foundation.org
Subject: [merged] backlight-corgi_lcd-convert-corgi_lcd-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:54 -0700
Message-ID: <20130430185154.7135C31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:52092 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3D3Svz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:55 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so76921ves.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: corgi_lcd: convert corgi_lcd to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-corgi_lcd-convert-corgi_lcd-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: corgi_lcd: convert corgi_lcd to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/corgi_lcd.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-convert-corgi_lcd-to-dev_pm_ops drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-convert-corgi_lcd-to-dev_pm_ops
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -457,10 +457,10 @@ static const struct backlight_ops corgi_
 	.update_status  = corgi_bl_update_status,
 };
 
-#ifdef CONFIG_PM
-static int corgi_lcd_suspend(struct spi_device *spi, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int corgi_lcd_suspend(struct device *dev)
 {
-	struct corgi_lcd *lcd = spi_get_drvdata(spi);
+	struct corgi_lcd *lcd = dev_get_drvdata(dev);
 
 	corgibl_flags |= CORGIBL_SUSPENDED;
 	corgi_bl_set_intensity(lcd, 0);
@@ -468,20 +468,19 @@ static int corgi_lcd_suspend(struct spi_
 	return 0;
 }
 
-static int corgi_lcd_resume(struct spi_device *spi)
+static int corgi_lcd_resume(struct device *dev)
 {
-	struct corgi_lcd *lcd = spi_get_drvdata(spi);
+	struct corgi_lcd *lcd = dev_get_drvdata(dev);
 
 	corgibl_flags &= ~CORGIBL_SUSPENDED;
 	corgi_lcd_set_power(lcd->lcd_dev, FB_BLANK_UNBLANK);
 	backlight_update_status(lcd->bl_dev);
 	return 0;
 }
-#else
-#define corgi_lcd_suspend	NULL
-#define corgi_lcd_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(corgi_lcd_pm_ops, corgi_lcd_suspend, corgi_lcd_resume);
+
 static int setup_gpio_backlight(struct corgi_lcd *lcd,
 				struct corgi_lcd_platform_data *pdata)
 {
@@ -611,11 +610,10 @@ static struct spi_driver corgi_lcd_drive
 	.driver		= {
 		.name	= "corgi-lcd",
 		.owner	= THIS_MODULE,
+		.pm	= &corgi_lcd_pm_ops,
 	},
 	.probe		= corgi_lcd_probe,
 	.remove		= corgi_lcd_remove,
-	.suspend	= corgi_lcd_suspend,
-	.resume		= corgi_lcd_resume,
 };
 
 module_spi_driver(corgi_lcd_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

