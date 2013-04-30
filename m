From: akpm@linux-foundation.org
Subject: [merged] backlight-tosa-convert-tosa-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:48 -0700
Message-ID: <20130430185248.70F4631C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:57350 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab3D3Swt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:49 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so86372ggc.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: tosa: convert tosa to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-tosa-convert-tosa-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tosa: convert tosa to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_bl.c  |   18 ++++++++----------
 drivers/video/backlight/tosa_lcd.c |   18 ++++++++----------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff -puN drivers/video/backlight/tosa_bl.c~backlight-tosa-convert-tosa-to-dev_pm_ops drivers/video/backlight/tosa_bl.c
--- a/drivers/video/backlight/tosa_bl.c~backlight-tosa-convert-tosa-to-dev_pm_ops
+++ a/drivers/video/backlight/tosa_bl.c
@@ -134,28 +134,27 @@ static int tosa_bl_remove(struct i2c_cli
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int tosa_bl_suspend(struct i2c_client *client, pm_message_t pm)
+#ifdef CONFIG_PM_SLEEP
+static int tosa_bl_suspend(struct device *dev)
 {
-	struct tosa_bl_data *data = i2c_get_clientdata(client);
+	struct tosa_bl_data *data = dev_get_drvdata(dev);
 
 	tosa_bl_set_backlight(data, 0);
 
 	return 0;
 }
 
-static int tosa_bl_resume(struct i2c_client *client)
+static int tosa_bl_resume(struct device *dev)
 {
-	struct tosa_bl_data *data = i2c_get_clientdata(client);
+	struct tosa_bl_data *data = dev_get_drvdata(dev);
 
 	backlight_update_status(data->bl);
 	return 0;
 }
-#else
-#define tosa_bl_suspend NULL
-#define tosa_bl_resume NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(tosa_bl_pm_ops, tosa_bl_suspend, tosa_bl_resume);
+
 static const struct i2c_device_id tosa_bl_id[] = {
 	{ "tosa-bl", 0 },
 	{ },
@@ -165,11 +164,10 @@ static struct i2c_driver tosa_bl_driver
 	.driver = {
 		.name		= "tosa-bl",
 		.owner		= THIS_MODULE,
+		.pm		= &tosa_bl_pm_ops,
 	},
 	.probe		= tosa_bl_probe,
 	.remove		= tosa_bl_remove,
-	.suspend	= tosa_bl_suspend,
-	.resume		= tosa_bl_resume,
 	.id_table	= tosa_bl_id,
 };
 
diff -puN drivers/video/backlight/tosa_lcd.c~backlight-tosa-convert-tosa-to-dev_pm_ops drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~backlight-tosa-convert-tosa-to-dev_pm_ops
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -240,19 +240,19 @@ static int tosa_lcd_remove(struct spi_de
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int tosa_lcd_suspend(struct spi_device *spi, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int tosa_lcd_suspend(struct device *dev)
 {
-	struct tosa_lcd_data *data = spi_get_drvdata(spi);
+	struct tosa_lcd_data *data = dev_get_drvdata(dev);
 
 	tosa_lcd_tg_off(data);
 
 	return 0;
 }
 
-static int tosa_lcd_resume(struct spi_device *spi)
+static int tosa_lcd_resume(struct device *dev)
 {
-	struct tosa_lcd_data *data = spi_get_drvdata(spi);
+	struct tosa_lcd_data *data = dev_get_drvdata(dev);
 
 	tosa_lcd_tg_init(data);
 	if (POWER_IS_ON(data->lcd_power))
@@ -262,20 +262,18 @@ static int tosa_lcd_resume(struct spi_de
 
 	return 0;
 }
-#else
-#define tosa_lcd_suspend	NULL
-#define tosa_lcd_resume NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(tosa_lcd_pm_ops, tosa_lcd_suspend, tosa_lcd_resume);
+
 static struct spi_driver tosa_lcd_driver = {
 	.driver = {
 		.name		= "tosa-lcd",
 		.owner		= THIS_MODULE,
+		.pm		= &tosa_lcd_pm_ops,
 	},
 	.probe		= tosa_lcd_probe,
 	.remove		= tosa_lcd_remove,
-	.suspend	= tosa_lcd_suspend,
-	.resume		= tosa_lcd_resume,
 };
 
 module_spi_driver(tosa_lcd_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

