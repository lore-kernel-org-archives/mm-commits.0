From: akpm@linux-foundation.org
Subject: [merged] backlight-add-lm3533-backlight-driver.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:33 -0700
Message-ID: <20120531191833.82291A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:38663 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041Ab2EaTSg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:36 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so134438vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhovold@gmail.com, FlorianSchandinat@gmx.de, arnd@arndb.de, broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org, jic23@cam.ac.uk, rob@landley.net, rpurdie@rpsys.net, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: add LM3533 backlight driver
has been removed from the -mm tree.  Its filename was
     backlight-add-lm3533-backlight-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: backlight: add LM3533 backlight driver

Add sub-driver for the backlights on National Semiconductor / TI LM3533
lighting power chips.

The chip provides 256 brightness levels and ambient-light-sensor and pwm
input control.

[akpm@linux-foundation.org: fix warning]
[akpm@linux-foundation.org: fix the type of `mode']
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Rob Landley <rob@landley.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533 |   48 +
 drivers/video/backlight/Kconfig                               |   12 
 drivers/video/backlight/Makefile                              |    1 
 drivers/video/backlight/lm3533_bl.c                           |  423 ++++++++++
 4 files changed, 484 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
@@ -0,0 +1,48 @@
+What:		/sys/class/backlight/<backlight>/als_channel
+Date:		May 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Get the ALS output channel used as input in
+		ALS-current-control mode (0, 1), where
+
+		0 - out_current0 (backlight 0)
+		1 - out_current1 (backlight 1)
+
+What:		/sys/class/backlight/<backlight>/als_en
+Date:		May 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Enable ALS-current-control mode (0, 1).
+
+What:		/sys/class/backlight/<backlight>/id
+Date:		April 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Get the id of this backlight (0, 1).
+
+What:		/sys/class/backlight/<backlight>/linear
+Date:		April 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Set the brightness-mapping mode (0, 1), where
+
+		0 - exponential mode
+		1 - linear mode
+
+What:		/sys/class/backlight/<backlight>/pwm
+Date:		April 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Set the PWM-input control mask (5 bits), where
+
+		bit 5 - PWM-input enabled in Zone 4
+		bit 4 - PWM-input enabled in Zone 3
+		bit 3 - PWM-input enabled in Zone 2
+		bit 2 - PWM-input enabled in Zone 1
+		bit 1 - PWM-input enabled in Zone 0
+		bit 0 - PWM-input enabled
diff -puN drivers/video/backlight/Kconfig~backlight-add-lm3533-backlight-driver drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-add-lm3533-backlight-driver
+++ a/drivers/video/backlight/Kconfig
@@ -184,6 +184,18 @@ config BACKLIGHT_GENERIC
 	  known as the Corgi backlight driver. If you have a Sharp Zaurus
 	  SL-C7xx, SL-Cxx00 or SL-6000x say y.
 
+config BACKLIGHT_LM3533
+	tristate "Backlight Driver for LM3533"
+	depends on BACKLIGHT_CLASS_DEVICE
+	depends on MFD_LM3533
+	help
+	  Say Y to enable the backlight driver for National Semiconductor / TI
+	  LM3533 Lighting Power chips.
+
+	  The backlights can be controlled directly, through PWM input, or by
+	  the ambient-light-sensor interface. The chip supports 256 brightness
+	  levels.
+
 config BACKLIGHT_LOCOMO
 	tristate "Sharp LOCOMO LCD/Backlight Driver"
 	depends on SHARP_LOCOMO
diff -puN drivers/video/backlight/Makefile~backlight-add-lm3533-backlight-driver drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~backlight-add-lm3533-backlight-driver
+++ a/drivers/video/backlight/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_BACKLIGHT_EP93XX)	+= ep93xx
 obj-$(CONFIG_BACKLIGHT_GENERIC)	+= generic_bl.o
 obj-$(CONFIG_BACKLIGHT_HP700)	+= jornada720_bl.o
 obj-$(CONFIG_BACKLIGHT_HP680)	+= hp680_bl.o
+obj-$(CONFIG_BACKLIGHT_LM3533)	+= lm3533_bl.o
 obj-$(CONFIG_BACKLIGHT_LOCOMO)	+= locomolcd.o
 obj-$(CONFIG_BACKLIGHT_LP855X)	+= lp855x_bl.o
 obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
diff -puN /dev/null drivers/video/backlight/lm3533_bl.c
--- /dev/null
+++ a/drivers/video/backlight/lm3533_bl.c
@@ -0,0 +1,423 @@
+/*
+ * lm3533-bl.c -- LM3533 Backlight driver
+ *
+ * Copyright (C) 2011-2012 Texas Instruments
+ *
+ * Author: Johan Hovold <jhovold@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under  the terms of the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/backlight.h>
+#include <linux/fb.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/lm3533.h>
+
+
+#define LM3533_HVCTRLBANK_COUNT		2
+#define LM3533_BL_MAX_BRIGHTNESS	255
+
+#define LM3533_REG_CTRLBANK_AB_BCONF	0x1a
+
+
+struct lm3533_bl {
+	struct lm3533 *lm3533;
+	struct lm3533_ctrlbank cb;
+	struct backlight_device *bd;
+	int id;
+};
+
+
+static inline int lm3533_bl_get_ctrlbank_id(struct lm3533_bl *bl)
+{
+	return bl->id;
+}
+
+static int lm3533_bl_update_status(struct backlight_device *bd)
+{
+	struct lm3533_bl *bl = bl_get_data(bd);
+	int brightness = bd->props.brightness;
+
+	if (bd->props.power != FB_BLANK_UNBLANK)
+		brightness = 0;
+	if (bd->props.fb_blank != FB_BLANK_UNBLANK)
+		brightness = 0;
+
+	return lm3533_ctrlbank_set_brightness(&bl->cb, (u8)brightness);
+}
+
+static int lm3533_bl_get_brightness(struct backlight_device *bd)
+{
+	struct lm3533_bl *bl = bl_get_data(bd);
+	u8 val;
+	int ret;
+
+	ret = lm3533_ctrlbank_get_brightness(&bl->cb, &val);
+	if (ret)
+		return ret;
+
+	return val;
+}
+
+static const struct backlight_ops lm3533_bl_ops = {
+	.get_brightness	= lm3533_bl_get_brightness,
+	.update_status	= lm3533_bl_update_status,
+};
+
+static ssize_t show_id(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", bl->id);
+}
+
+static ssize_t show_als_channel(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
+	unsigned channel = lm3533_bl_get_ctrlbank_id(bl);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", channel);
+}
+
+static ssize_t show_als_en(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
+	int ctrlbank = lm3533_bl_get_ctrlbank_id(bl);
+	u8 val;
+	u8 mask;
+	bool enable;
+	int ret;
+
+	ret = lm3533_read(bl->lm3533, LM3533_REG_CTRLBANK_AB_BCONF, &val);
+	if (ret)
+		return ret;
+
+	mask = 1 << (2 * ctrlbank);
+	enable = val & mask;
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", enable);
+}
+
+static ssize_t store_als_en(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
+	int ctrlbank = lm3533_bl_get_ctrlbank_id(bl);
+	int enable;
+	u8 val;
+	u8 mask;
+	int ret;
+
+	if (kstrtoint(buf, 0, &enable))
+		return -EINVAL;
+
+	mask = 1 << (2 * ctrlbank);
+
+	if (enable)
+		val = mask;
+	else
+		val = 0;
+
+	ret = lm3533_update(bl->lm3533, LM3533_REG_CTRLBANK_AB_BCONF, val,
+									mask);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static ssize_t show_linear(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
+	u8 val;
+	u8 mask;
+	int linear;
+	int ret;
+
+	ret = lm3533_read(bl->lm3533, LM3533_REG_CTRLBANK_AB_BCONF, &val);
+	if (ret)
+		return ret;
+
+	mask = 1 << (2 * lm3533_bl_get_ctrlbank_id(bl) + 1);
+
+	if (val & mask)
+		linear = 1;
+	else
+		linear = 0;
+
+	return scnprintf(buf, PAGE_SIZE, "%x\n", linear);
+}
+
+static ssize_t store_linear(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
+	unsigned long linear;
+	u8 mask;
+	u8 val;
+	int ret;
+
+	if (kstrtoul(buf, 0, &linear))
+		return -EINVAL;
+
+	mask = 1 << (2 * lm3533_bl_get_ctrlbank_id(bl) + 1);
+
+	if (linear)
+		val = mask;
+	else
+		val = 0;
+
+	ret = lm3533_update(bl->lm3533, LM3533_REG_CTRLBANK_AB_BCONF, val,
+									mask);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static ssize_t show_pwm(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
+	u8 val;
+	int ret;
+
+	ret = lm3533_ctrlbank_get_pwm(&bl->cb, &val);
+	if (ret)
+		return ret;
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", val);
+}
+
+static ssize_t store_pwm(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
+	u8 val;
+	int ret;
+
+	if (kstrtou8(buf, 0, &val))
+		return -EINVAL;
+
+	ret = lm3533_ctrlbank_set_pwm(&bl->cb, val);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static LM3533_ATTR_RO(als_channel);
+static LM3533_ATTR_RW(als_en);
+static LM3533_ATTR_RO(id);
+static LM3533_ATTR_RW(linear);
+static LM3533_ATTR_RW(pwm);
+
+static struct attribute *lm3533_bl_attributes[] = {
+	&dev_attr_als_channel.attr,
+	&dev_attr_als_en.attr,
+	&dev_attr_id.attr,
+	&dev_attr_linear.attr,
+	&dev_attr_pwm.attr,
+	NULL,
+};
+
+static umode_t lm3533_bl_attr_is_visible(struct kobject *kobj,
+					     struct attribute *attr, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
+	umode_t mode = attr->mode;
+
+	if (attr == &dev_attr_als_channel.attr ||
+					attr == &dev_attr_als_en.attr) {
+		if (!bl->lm3533->have_als)
+			mode = 0;
+	}
+
+	return mode;
+};
+
+static struct attribute_group lm3533_bl_attribute_group = {
+	.is_visible	= lm3533_bl_attr_is_visible,
+	.attrs		= lm3533_bl_attributes
+};
+
+static int __devinit lm3533_bl_setup(struct lm3533_bl *bl,
+					struct lm3533_bl_platform_data *pdata)
+{
+	int ret;
+
+	ret = lm3533_ctrlbank_set_max_current(&bl->cb, pdata->max_current);
+	if (ret)
+		return ret;
+
+	return lm3533_ctrlbank_set_pwm(&bl->cb, pdata->pwm);
+}
+
+static int __devinit lm3533_bl_probe(struct platform_device *pdev)
+{
+	struct lm3533 *lm3533;
+	struct lm3533_bl_platform_data *pdata;
+	struct lm3533_bl *bl;
+	struct backlight_device *bd;
+	struct backlight_properties props;
+	int ret;
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	lm3533 = dev_get_drvdata(pdev->dev.parent);
+	if (!lm3533)
+		return -EINVAL;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "no platform data\n");
+		return -EINVAL;
+	}
+
+	if (pdev->id < 0 || pdev->id >= LM3533_HVCTRLBANK_COUNT) {
+		dev_err(&pdev->dev, "illegal backlight id %d\n", pdev->id);
+		return -EINVAL;
+	}
+
+	bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+	if (!bl) {
+		dev_err(&pdev->dev,
+				"failed to allocate memory for backlight\n");
+		return -ENOMEM;
+	}
+
+	bl->lm3533 = lm3533;
+	bl->id = pdev->id;
+
+	bl->cb.lm3533 = lm3533;
+	bl->cb.id = lm3533_bl_get_ctrlbank_id(bl);
+	bl->cb.dev = NULL;			/* until registered */
+
+	memset(&props, 0, sizeof(props));
+	props.type = BACKLIGHT_RAW;
+	props.max_brightness = LM3533_BL_MAX_BRIGHTNESS;
+	props.brightness = pdata->default_brightness;
+	bd = backlight_device_register(pdata->name, pdev->dev.parent, bl,
+						&lm3533_bl_ops, &props);
+	if (IS_ERR(bd)) {
+		dev_err(&pdev->dev, "failed to register backlight device\n");
+		ret = PTR_ERR(bd);
+		goto err_free;
+	}
+
+	bl->bd = bd;
+	bl->cb.dev = &bl->bd->dev;
+
+	platform_set_drvdata(pdev, bl);
+
+	ret = sysfs_create_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to create sysfs attributes\n");
+		goto err_unregister;
+	}
+
+	backlight_update_status(bd);
+
+	ret = lm3533_bl_setup(bl, pdata);
+	if (ret)
+		goto err_sysfs_remove;
+
+	ret = lm3533_ctrlbank_enable(&bl->cb);
+	if (ret)
+		goto err_sysfs_remove;
+
+	return 0;
+
+err_sysfs_remove:
+	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
+err_unregister:
+	backlight_device_unregister(bd);
+err_free:
+	kfree(bl);
+
+	return ret;
+}
+
+static int __devexit lm3533_bl_remove(struct platform_device *pdev)
+{
+	struct lm3533_bl *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bd = bl->bd;
+
+	dev_dbg(&bd->dev, "%s\n", __func__);
+
+	bd->props.power = FB_BLANK_POWERDOWN;
+	bd->props.brightness = 0;
+
+	lm3533_ctrlbank_disable(&bl->cb);
+	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
+	backlight_device_unregister(bd);
+	kfree(bl);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int lm3533_bl_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct lm3533_bl *bl = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	return lm3533_ctrlbank_disable(&bl->cb);
+}
+
+static int lm3533_bl_resume(struct platform_device *pdev)
+{
+	struct lm3533_bl *bl = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	return lm3533_ctrlbank_enable(&bl->cb);
+}
+#else
+#define lm3533_bl_suspend	NULL
+#define lm3533_bl_resume	NULL
+#endif
+
+static void lm3533_bl_shutdown(struct platform_device *pdev)
+{
+	struct lm3533_bl *bl = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	lm3533_ctrlbank_disable(&bl->cb);
+}
+
+static struct platform_driver lm3533_bl_driver = {
+	.driver = {
+		.name	= "lm3533-backlight",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= lm3533_bl_probe,
+	.remove		= __devexit_p(lm3533_bl_remove),
+	.shutdown	= lm3533_bl_shutdown,
+	.suspend	= lm3533_bl_suspend,
+	.resume		= lm3533_bl_resume,
+};
+module_platform_driver(lm3533_bl_driver);
+
+MODULE_AUTHOR("Johan Hovold <jhovold@gmail.com>");
+MODULE_DESCRIPTION("LM3533 Backlight driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:lm3533-backlight");
_

Patches currently in -mm which might be from jhovold@gmail.com are

origin.patch

