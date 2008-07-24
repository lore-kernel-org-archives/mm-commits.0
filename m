From: akpm@linux-foundation.org
Subject: - lcd-add-platform_lcd-driver.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:55 -0700
Message-ID: <200807242332.m6ONWtxI011878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756872AbYGXXdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     lcd: add platform_lcd driver
has been removed from the -mm tree.  Its filename was
     lcd-add-platform_lcd-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lcd: add platform_lcd driver
From: Ben Dooks <ben-linux@fluff.org>

Add a platform_lcd driver to allow boards with simple lcd power controls
to register themselves easily.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig        |    7 
 drivers/video/backlight/Makefile       |    1 
 drivers/video/backlight/platform_lcd.c |  172 +++++++++++++++++++++++
 include/video/platform_lcd.h           |   21 ++
 4 files changed, 201 insertions(+)

diff -puN drivers/video/backlight/Kconfig~lcd-add-platform_lcd-driver drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~lcd-add-platform_lcd-driver
+++ a/drivers/video/backlight/Kconfig
@@ -53,6 +53,13 @@ config LCD_VGG2432A4
 	  If you have a VGG2432A4 panel based on the ILI9320 controller chip
 	  then say y to include a power driver for it.
 
+config LCD_PLATFORM
+	tristate "Platform LCD controls"
+	depends on LCD_CLASS_DEVICE
+	help
+	  This driver provides a platform-device registered LCD power
+	  control interface.
+
 #
 # Backlight
 #
diff -puN drivers/video/backlight/Makefile~lcd-add-platform_lcd-driver drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~lcd-add-platform_lcd-driver
+++ a/drivers/video/backlight/Makefile
@@ -3,6 +3,7 @@
 obj-$(CONFIG_LCD_CLASS_DEVICE)     += lcd.o
 obj-$(CONFIG_LCD_LTV350QV)	   += ltv350qv.o
 obj-$(CONFIG_LCD_ILI9320)	   += ili9320.o
+obj-$(CONFIG_LCD_PLATFORM)	   += platform_lcd.o
 obj-$(CONFIG_LCD_VGG2432A4)	   += vgg2432a4.o
 
 obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += backlight.o
diff -puN /dev/null drivers/video/backlight/platform_lcd.c
--- /dev/null
+++ a/drivers/video/backlight/platform_lcd.c
@@ -0,0 +1,172 @@
+/* drivers/video/backlight/platform_lcd.c
+ *
+ * Copyright 2008 Simtec Electronics
+ *	Ben Dooks <ben@simtec.co.uk>
+ *
+ * Generic platform-device LCD power control interface.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+*/
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+#include <linux/lcd.h>
+
+#include <video/platform_lcd.h>
+
+struct platform_lcd {
+	struct device		*us;
+	struct lcd_device	*lcd;
+	struct plat_lcd_data	*pdata;
+
+	unsigned int		 power;
+	unsigned int		 suspended : 1;
+};
+
+static inline struct platform_lcd *to_our_lcd(struct lcd_device *lcd)
+{
+	return lcd_get_data(lcd);
+}
+
+static int platform_lcd_get_power(struct lcd_device *lcd)
+{
+	struct platform_lcd *plcd = to_our_lcd(lcd);
+
+	return plcd->power;
+}
+
+static int platform_lcd_set_power(struct lcd_device *lcd, int power)
+{
+	struct platform_lcd *plcd = to_our_lcd(lcd);
+	int lcd_power = 1;
+
+	if (power == FB_BLANK_POWERDOWN || plcd->suspended)
+		lcd_power = 0;
+
+	plcd->pdata->set_power(plcd->pdata, lcd_power);
+	plcd->power = power;
+
+	return 0;
+}
+
+static int platform_lcd_match(struct lcd_device *lcd, struct fb_info *info)
+{
+	struct platform_lcd *plcd = to_our_lcd(lcd);
+	struct plat_lcd_data *pdata = plcd->pdata;
+
+	if (pdata->match_fb)
+		return pdata->match_fb(pdata, info);
+
+	return plcd->us->parent == info->device;
+}
+
+static struct lcd_ops platform_lcd_ops = {
+	.get_power	= platform_lcd_get_power,
+	.set_power	= platform_lcd_set_power,
+	.check_fb	= platform_lcd_match,
+};
+
+static int __devinit platform_lcd_probe(struct platform_device *pdev)
+{
+	struct plat_lcd_data *pdata;
+	struct platform_lcd *plcd;
+	struct device *dev = &pdev->dev;
+	int err;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(dev, "no platform data supplied\n");
+		return -EINVAL;
+	}
+
+	plcd = kzalloc(sizeof(struct platform_lcd), GFP_KERNEL);
+	if (!plcd) {
+		dev_err(dev, "no memory for state\n");
+		return -ENOMEM;
+	}
+
+	plcd->us = dev;
+	plcd->pdata = pdata;
+	plcd->lcd = lcd_device_register("platform-lcd", dev,
+					plcd, &platform_lcd_ops);
+	if (IS_ERR(plcd->lcd)) {
+		dev_err(dev, "cannot register lcd device\n");
+		err = PTR_ERR(plcd->lcd);
+		goto err_mem;
+	}
+
+	platform_set_drvdata(pdev, plcd);
+	return 0;
+
+ err_mem:
+	kfree(plcd);
+	return err;
+}
+
+static int __devexit platform_lcd_remove(struct platform_device *pdev)
+{
+	struct platform_lcd *plcd = platform_get_drvdata(pdev);
+
+	lcd_device_unregister(plcd->lcd);
+	kfree(plcd);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int platform_lcd_suspend(struct platform_device *pdev, pm_message_t st)
+{
+	struct platform_lcd *plcd = platform_get_drvdata(pdev);
+
+	plcd->suspended = 1;
+	platform_lcd_set_power(plcd->lcd, plcd->power);
+
+	return 0;
+}
+
+static int platform_lcd_resume(struct platform_device *pdev)
+{
+	struct platform_lcd *plcd = platform_get_drvdata(pdev);
+
+	plcd->suspended = 0;
+	platform_lcd_set_power(plcd->lcd, plcd->power);
+
+	return 0;
+}
+#else
+#define platform_lcd_suspend NULL
+#define platform_lcd_resume NULL
+#endif
+
+static struct platform_driver platform_lcd_driver = {
+	.driver		= {
+		.name	= "platform-lcd",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= platform_lcd_probe,
+	.remove		= __devexit_p(platform_lcd_remove),
+	.suspend        = platform_lcd_suspend,
+	.resume         = platform_lcd_resume,
+};
+
+static int __init platform_lcd_init(void)
+{
+	return platform_driver_register(&platform_lcd_driver);
+}
+
+static void __exit platform_lcd_cleanup(void)
+{
+	platform_driver_unregister(&platform_lcd_driver);
+}
+
+module_init(platform_lcd_init);
+module_exit(platform_lcd_cleanup);
+
+MODULE_AUTHOR("Ben Dooks <ben-linux@fluff.org>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:platform-lcd");
diff -puN /dev/null include/video/platform_lcd.h
--- /dev/null
+++ a/include/video/platform_lcd.h
@@ -0,0 +1,21 @@
+/* include/video/platform_lcd.h
+ *
+ * Copyright 2008 Simtec Electronics
+ *	Ben Dooks <ben@simtec.co.uk>
+ *
+ * Generic platform-device LCD power control interface.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+*/
+
+struct plat_lcd_data;
+struct fb_info;
+
+struct plat_lcd_data {
+	void	(*set_power)(struct plat_lcd_data *, unsigned int power);
+	int	(*match_fb)(struct plat_lcd_data *, struct fb_info *);
+};
+
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
parport-fix-platform-driver-hotplug-coldplug.patch
sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-fixes-for-akpms-comments-on-gpiolib-addition.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
mfd-sm501-fix-gpio-number-calculation-for-upper-bank.patch
resource-add-resource_size.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

