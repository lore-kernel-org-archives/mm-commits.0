From: akpm@linux-foundation.org
Subject: + backlight-add-driver-for-bachmanns-ot200.patch added to -mm tree
Date: Wed, 01 Feb 2012 12:35:00 -0800
Message-ID: <20120201203502.8021CA00EA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:50424 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab2BAUfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 15:35:06 -0500
Received: by eaae13 with SMTP id e13so24843eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 12:35:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: christian.gmeiner@gmail.com, dilinger@queued.net, lars@metafoo.de


The patch titled
     Subject: backlight: add driver for Bachmann's ot200
has been added to the -mm tree.  Its filename is
     backlight-add-driver-for-bachmanns-ot200.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: backlight: add driver for Bachmann's ot200

Add backlight driver for Bachmann's ot200 visualisation device.  The
driver uses MFGPT 7 of CS5535 silicon to regulate the backlight.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Andres Salomon <dilinger@queued.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig    |    7 +
 drivers/video/backlight/Makefile   |    2 
 drivers/video/backlight/ot200_bl.c |  175 +++++++++++++++++++++++++++
 3 files changed, 183 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/Kconfig~backlight-add-driver-for-bachmanns-ot200 drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-add-driver-for-bachmanns-ot200
+++ a/drivers/video/backlight/Kconfig
@@ -341,6 +341,13 @@ config BACKLIGHT_LP855X
 	  This supports TI LP8550, LP8551, LP8552, LP8553 and LP8556
 	  backlight driver.
 
+config BACKLIGHT_OT200
+	tristate "Backlight driver for ot200 visualisation device"
+	depends on BACKLIGHT_CLASS_DEVICE && CS5535_MFGPT
+	help
+	  To compile this driver as a module, choose M here: the module will be
+	  called ot200_bl.
+
 endif # BACKLIGHT_CLASS_DEVICE
 
 endif # BACKLIGHT_LCD_SUPPORT
diff -puN drivers/video/backlight/Makefile~backlight-add-driver-for-bachmanns-ot200 drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~backlight-add-driver-for-bachmanns-ot200
+++ a/drivers/video/backlight/Makefile
@@ -39,4 +39,4 @@ obj-$(CONFIG_BACKLIGHT_ADP8870)	+= adp88
 obj-$(CONFIG_BACKLIGHT_88PM860X) += 88pm860x_bl.o
 obj-$(CONFIG_BACKLIGHT_PCF50633)	+= pcf50633-backlight.o
 obj-$(CONFIG_BACKLIGHT_AAT2870) += aat2870_bl.o
-
+obj-$(CONFIG_BACKLIGHT_OT200) += ot200_bl.o
diff -puN /dev/null drivers/video/backlight/ot200_bl.c
--- /dev/null
+++ a/drivers/video/backlight/ot200_bl.c
@@ -0,0 +1,175 @@
+/*
+ * Copyright (C) 2012 Bachmann electronic GmbH
+ *	Christian Gmeiner <christian.gmeiner@gmail.com>
+ *
+ * Backlight driver for ot200 visualisation device from
+ * Bachmann electronic GmbH.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+#include <linux/gpio.h>
+#include <linux/cs5535.h>
+
+static struct cs5535_mfgpt_timer *pwm_timer;
+
+/* this array defines the mapping of brightness in % to pwm frequency */
+static const  u8 dim_table[101] = {0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,
+				   2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4,
+				   4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 9, 9,
+				   10, 10, 11, 11, 12, 12, 13, 14, 15, 15, 16,
+				   17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28,
+				   30, 31, 33, 35, 37, 39, 41, 43, 45, 47, 50,
+				   53, 55, 58, 61, 65, 68, 72, 75, 79, 84, 88,
+				   93, 97, 103, 108, 114, 120, 126, 133, 140,
+				   147, 155, 163};
+
+struct ot200_backlight_data {
+	int current_brightness;
+};
+
+#define GPIO_DIMM	27
+#define SCALE		1
+#define CMP1MODE	0x2	/* compare on GE; output high on compare
+				 * greater than or equal */
+#define PWM_SETUP	(SCALE | CMP1MODE << 6 | MFGPT_SETUP_CNTEN)
+#define MAX_COMP2	163
+
+static int ot200_backlight_update_status(struct backlight_device *bl)
+{
+	struct ot200_backlight_data *data = bl_get_data(bl);
+	int brightness = bl->props.brightness;
+
+	if (bl->props.state & BL_CORE_FBBLANK)
+		brightness = 0;
+
+	/* enable or disable PWM timer */
+	if (brightness == 0)
+		cs5535_mfgpt_write(pwm_timer, MFGPT_REG_SETUP, 0);
+	else if (brightness != 0 && data->current_brightness == 0) {
+		cs5535_mfgpt_write(pwm_timer, MFGPT_REG_COUNTER, 0);
+		cs5535_mfgpt_write(pwm_timer, MFGPT_REG_SETUP,
+			MFGPT_SETUP_CNTEN);
+	}
+
+	/* apply new brightness value */
+	cs5535_mfgpt_write(pwm_timer, MFGPT_REG_CMP1,
+		MAX_COMP2 - dim_table[brightness]);
+	data->current_brightness = brightness;
+
+	return 0;
+}
+
+static int ot200_backlight_get_brightness(struct backlight_device *bl)
+{
+	struct ot200_backlight_data *data = bl_get_data(bl);
+	return data->current_brightness;
+}
+
+static const struct backlight_ops ot200_backlight_ops = {
+	.update_status	= ot200_backlight_update_status,
+	.get_brightness	= ot200_backlight_get_brightness,
+};
+
+static int ot200_backlight_probe(struct platform_device *pdev)
+{
+	struct backlight_device *bl;
+	struct ot200_backlight_data *data;
+	struct backlight_properties props;
+	int retval = 0;
+
+	/* request gpio */
+	if (gpio_request(GPIO_DIMM, "ot200 backlight dimmer") < 0) {
+		dev_err(&pdev->dev, "failed to request GPIO %d\n", GPIO_DIMM);
+		return -ENODEV;
+	}
+
+	/* request timer */
+	pwm_timer = cs5535_mfgpt_alloc_timer(7, MFGPT_DOMAIN_ANY);
+	if (!pwm_timer) {
+		dev_err(&pdev->dev, "MFGPT 7 not available\n");
+		retval = -ENODEV;
+		goto error_mfgpt_alloc;
+	}
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		retval = -ENOMEM;
+		goto error_kzalloc;
+	}
+
+	/* setup gpio */
+	cs5535_gpio_set(GPIO_DIMM, GPIO_OUTPUT_ENABLE);
+	cs5535_gpio_set(GPIO_DIMM, GPIO_OUTPUT_AUX1);
+
+	/* setup timer */
+	cs5535_mfgpt_write(pwm_timer, MFGPT_REG_CMP1, 0);
+	cs5535_mfgpt_write(pwm_timer, MFGPT_REG_CMP2, MAX_COMP2);
+	cs5535_mfgpt_write(pwm_timer, MFGPT_REG_SETUP, PWM_SETUP);
+
+	data->current_brightness = 100;
+	props.max_brightness = 100;
+	props.brightness = 100;
+	props.type = BACKLIGHT_RAW;
+
+	bl = backlight_device_register(dev_name(&pdev->dev), &pdev->dev, data,
+					&ot200_backlight_ops, &props);
+	if (IS_ERR(bl)) {
+		dev_err(&pdev->dev, "failed to register backlight\n");
+		retval = PTR_ERR(bl);
+		goto error_backlight_device_register;
+	}
+
+	platform_set_drvdata(pdev, bl);
+
+	return 0;
+
+error_backlight_device_register:
+	kfree(data);
+error_kzalloc:
+	cs5535_mfgpt_free_timer(pwm_timer);
+error_mfgpt_alloc:
+	gpio_free(GPIO_DIMM);
+	return retval;
+}
+
+static int ot200_backlight_remove(struct platform_device *pdev)
+{
+	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct ot200_backlight_data *data = bl_get_data(bl);
+
+	backlight_device_unregister(bl);
+
+	/* on module unload set brightness to 100% */
+	cs5535_mfgpt_write(pwm_timer, MFGPT_REG_COUNTER, 0);
+	cs5535_mfgpt_write(pwm_timer, MFGPT_REG_SETUP, MFGPT_SETUP_CNTEN);
+	cs5535_mfgpt_write(pwm_timer, MFGPT_REG_CMP1,
+		MAX_COMP2 - dim_table[100]);
+
+	cs5535_mfgpt_free_timer(pwm_timer);
+	gpio_free(GPIO_DIMM);
+
+	kfree(data);
+	return 0;
+}
+
+static struct platform_driver ot200_backlight_driver = {
+	.driver		= {
+		.name	= "ot200-backlight",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= ot200_backlight_probe,
+	.remove		= ot200_backlight_remove,
+};
+
+module_platform_driver(ot200_backlight_driver);
+
+MODULE_DESCRIPTION("backlight driver for ot200 visualisation device");
+MODULE_AUTHOR("Christian Gmeiner <christian.gmeiner@gmail.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ot200-backlight");
_
Subject: Subject: backlight: add driver for Bachmann's ot200

Patches currently in -mm which might be from christian.gmeiner@gmail.com are

origin.patch
backlight-add-driver-for-bachmanns-ot200.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch

