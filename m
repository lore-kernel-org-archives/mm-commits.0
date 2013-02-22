From: akpm@linux-foundation.org
Subject: [merged] backlight-add-an-as3711-pmic-backlight-driver.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:09 -0800
Message-ID: <20130222204209.AAA6D31C208@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:42556 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUmK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:10 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so103920ggi.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@gmx.de, jg1.han@samsung.com, magnus.damm@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: add an AS3711 PMIC backlight driver
has been removed from the -mm tree.  Its filename was
     backlight-add-an-as3711-pmic-backlight-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: backlight: add an AS3711 PMIC backlight driver

This is an initial commit of a backlight driver, using step-up DCDC power
supplies on AS3711 PMIC. Only one mode has actually been tested, several
further modes have been implemented "dry," but disabled to avoid accidental
hardware damage. Anyone wishing to use any of those modes will have to
modify the driver.

Tested on sh73a0-based kzm9g board.  Only one mode has been tested and is
enabled.  That mode copies the sample code from the manufacturer. 
Deviations from that code proved to be fatal for the hardware...

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig     |    7 
 drivers/video/backlight/Makefile    |    1 
 drivers/video/backlight/as3711_bl.c |  380 ++++++++++++++++++++++++++
 3 files changed, 388 insertions(+)

diff -puN drivers/video/backlight/Kconfig~backlight-add-an-as3711-pmic-backlight-driver drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-add-an-as3711-pmic-backlight-driver
+++ a/drivers/video/backlight/Kconfig
@@ -405,6 +405,13 @@ config BACKLIGHT_TPS65217
 	  If you have a Texas Instruments TPS65217 say Y to enable the
 	  backlight driver.
 
+config BACKLIGHT_AS3711
+	tristate "AS3711 Backlight"
+	depends on BACKLIGHT_CLASS_DEVICE && MFD_AS3711
+	help
+	  If you have an Austrian Microsystems AS3711 say Y to enable the
+	  backlight driver.
+
 endif # BACKLIGHT_CLASS_DEVICE
 
 endif # BACKLIGHT_LCD_SUPPORT
diff -puN drivers/video/backlight/Makefile~backlight-add-an-as3711-pmic-backlight-driver drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~backlight-add-an-as3711-pmic-backlight-driver
+++ a/drivers/video/backlight/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_BACKLIGHT_ADP5520)		+= adp5
 obj-$(CONFIG_BACKLIGHT_ADP8860)		+= adp8860_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP8870)		+= adp8870_bl.o
 obj-$(CONFIG_BACKLIGHT_APPLE)		+= apple_bl.o
+obj-$(CONFIG_BACKLIGHT_AS3711)		+= as3711_bl.o
 obj-$(CONFIG_BACKLIGHT_ATMEL_PWM)	+= atmel-pwm-bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH)	+= cr_bllcd.o
 obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE)	+= backlight.o
diff -puN /dev/null drivers/video/backlight/as3711_bl.c
--- /dev/null
+++ a/drivers/video/backlight/as3711_bl.c
@@ -0,0 +1,380 @@
+/*
+ * AS3711 PMIC backlight driver, using DCDC Step Up Converters
+ *
+ * Copyright (C) 2012 Renesas Electronics Corporation
+ * Author: Guennadi Liakhovetski, <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the version 2 of the GNU General Public License as
+ * published by the Free Software Foundation
+ */
+
+#include <linux/backlight.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/fb.h>
+#include <linux/kernel.h>
+#include <linux/mfd/as3711.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+
+enum as3711_bl_type {
+	AS3711_BL_SU1,
+	AS3711_BL_SU2,
+};
+
+struct as3711_bl_data {
+	bool powered;
+	const char *fb_name;
+	struct device *fb_dev;
+	enum as3711_bl_type type;
+	int brightness;
+	struct backlight_device *bl;
+};
+
+struct as3711_bl_supply {
+	struct as3711_bl_data su1;
+	struct as3711_bl_data su2;
+	const struct as3711_bl_pdata *pdata;
+	struct as3711 *as3711;
+};
+
+static struct as3711_bl_supply *to_supply(struct as3711_bl_data *su)
+{
+	switch (su->type) {
+	case AS3711_BL_SU1:
+		return container_of(su, struct as3711_bl_supply, su1);
+	case AS3711_BL_SU2:
+		return container_of(su, struct as3711_bl_supply, su2);
+	}
+	return NULL;
+}
+
+static int as3711_set_brightness_auto_i(struct as3711_bl_data *data,
+					unsigned int brightness)
+{
+	struct as3711_bl_supply *supply = to_supply(data);
+	struct as3711 *as3711 = supply->as3711;
+	const struct as3711_bl_pdata *pdata = supply->pdata;
+	int ret = 0;
+
+	/* Only all equal current values are supported */
+	if (pdata->su2_auto_curr1)
+		ret = regmap_write(as3711->regmap, AS3711_CURR1_VALUE,
+				   brightness);
+	if (!ret && pdata->su2_auto_curr2)
+		ret = regmap_write(as3711->regmap, AS3711_CURR2_VALUE,
+				   brightness);
+	if (!ret && pdata->su2_auto_curr3)
+		ret = regmap_write(as3711->regmap, AS3711_CURR3_VALUE,
+				   brightness);
+
+	return ret;
+}
+
+static int as3711_set_brightness_v(struct as3711 *as3711,
+				   unsigned int brightness,
+				   unsigned int reg)
+{
+	if (brightness > 31)
+		return -EINVAL;
+
+	return regmap_update_bits(as3711->regmap, reg, 0xf0,
+				  brightness << 4);
+}
+
+static int as3711_bl_su2_reset(struct as3711_bl_supply *supply)
+{
+	struct as3711 *as3711 = supply->as3711;
+	int ret = regmap_update_bits(as3711->regmap, AS3711_STEPUP_CONTROL_5,
+				     3, supply->pdata->su2_fbprot);
+	if (!ret)
+		ret = regmap_update_bits(as3711->regmap,
+					 AS3711_STEPUP_CONTROL_2, 1, 0);
+	if (!ret)
+		ret = regmap_update_bits(as3711->regmap,
+					 AS3711_STEPUP_CONTROL_2, 1, 1);
+	return ret;
+}
+
+/*
+ * Someone with less fragile or less expensive hardware could try to simplify
+ * the brightness adjustment procedure.
+ */
+static int as3711_bl_update_status(struct backlight_device *bl)
+{
+	struct as3711_bl_data *data = bl_get_data(bl);
+	struct as3711_bl_supply *supply = to_supply(data);
+	struct as3711 *as3711 = supply->as3711;
+	int brightness = bl->props.brightness;
+	int ret = 0;
+
+	dev_dbg(&bl->dev, "%s(): brightness %u, pwr %x, blank %x, state %x\n",
+		__func__, bl->props.brightness, bl->props.power,
+		bl->props.fb_blank, bl->props.state);
+
+	if (bl->props.power != FB_BLANK_UNBLANK ||
+	    bl->props.fb_blank != FB_BLANK_UNBLANK ||
+	    bl->props.state & (BL_CORE_SUSPENDED | BL_CORE_FBBLANK))
+		brightness = 0;
+
+	if (data->type == AS3711_BL_SU1) {
+		ret = as3711_set_brightness_v(as3711, brightness,
+					      AS3711_STEPUP_CONTROL_1);
+	} else {
+		const struct as3711_bl_pdata *pdata = supply->pdata;
+
+		switch (pdata->su2_feedback) {
+		case AS3711_SU2_VOLTAGE:
+			ret = as3711_set_brightness_v(as3711, brightness,
+						      AS3711_STEPUP_CONTROL_2);
+			break;
+		case AS3711_SU2_CURR_AUTO:
+			ret = as3711_set_brightness_auto_i(data, brightness / 4);
+			if (ret < 0)
+				return ret;
+			if (brightness) {
+				ret = as3711_bl_su2_reset(supply);
+				if (ret < 0)
+					return ret;
+				udelay(500);
+				ret = as3711_set_brightness_auto_i(data, brightness);
+			} else {
+				ret = regmap_update_bits(as3711->regmap,
+						AS3711_STEPUP_CONTROL_2, 1, 0);
+			}
+			break;
+		/* Manual one current feedback pin below */
+		case AS3711_SU2_CURR1:
+			ret = regmap_write(as3711->regmap, AS3711_CURR1_VALUE,
+					   brightness);
+			break;
+		case AS3711_SU2_CURR2:
+			ret = regmap_write(as3711->regmap, AS3711_CURR2_VALUE,
+					   brightness);
+			break;
+		case AS3711_SU2_CURR3:
+			ret = regmap_write(as3711->regmap, AS3711_CURR3_VALUE,
+					   brightness);
+			break;
+		default:
+			ret = -EINVAL;
+		}
+	}
+	if (!ret)
+		data->brightness = brightness;
+
+	return ret;
+}
+
+static int as3711_bl_get_brightness(struct backlight_device *bl)
+{
+	struct as3711_bl_data *data = bl_get_data(bl);
+
+	return data->brightness;
+}
+
+static const struct backlight_ops as3711_bl_ops = {
+	.update_status	= as3711_bl_update_status,
+	.get_brightness	= as3711_bl_get_brightness,
+};
+
+static int as3711_bl_init_su2(struct as3711_bl_supply *supply)
+{
+	struct as3711 *as3711 = supply->as3711;
+	const struct as3711_bl_pdata *pdata = supply->pdata;
+	u8 ctl = 0;
+	int ret;
+
+	dev_dbg(as3711->dev, "%s(): use %u\n", __func__, pdata->su2_feedback);
+
+	/* Turn SU2 off */
+	ret = regmap_write(as3711->regmap, AS3711_STEPUP_CONTROL_2, 0);
+	if (ret < 0)
+		return ret;
+
+	switch (pdata->su2_feedback) {
+	case AS3711_SU2_VOLTAGE:
+		ret = regmap_update_bits(as3711->regmap, AS3711_STEPUP_CONTROL_4, 3, 0);
+		break;
+	case AS3711_SU2_CURR1:
+		ctl = 1;
+		ret = regmap_update_bits(as3711->regmap, AS3711_STEPUP_CONTROL_4, 3, 1);
+		break;
+	case AS3711_SU2_CURR2:
+		ctl = 4;
+		ret = regmap_update_bits(as3711->regmap, AS3711_STEPUP_CONTROL_4, 3, 2);
+		break;
+	case AS3711_SU2_CURR3:
+		ctl = 0x10;
+		ret = regmap_update_bits(as3711->regmap, AS3711_STEPUP_CONTROL_4, 3, 3);
+		break;
+	case AS3711_SU2_CURR_AUTO:
+		if (pdata->su2_auto_curr1)
+			ctl = 2;
+		if (pdata->su2_auto_curr2)
+			ctl |= 8;
+		if (pdata->su2_auto_curr3)
+			ctl |= 0x20;
+		ret = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!ret)
+		ret = regmap_write(as3711->regmap, AS3711_CURR_CONTROL, ctl);
+
+	return ret;
+}
+
+static int as3711_bl_register(struct platform_device *pdev,
+			      unsigned int max_brightness, struct as3711_bl_data *su)
+{
+	struct backlight_properties props = {.type = BACKLIGHT_RAW,};
+	struct backlight_device *bl;
+
+	/* max tuning I = 31uA for voltage- and 38250uA for current-feedback */
+	props.max_brightness = max_brightness;
+
+	bl = backlight_device_register(su->type == AS3711_BL_SU1 ?
+				       "as3711-su1" : "as3711-su2",
+				       &pdev->dev, su,
+				       &as3711_bl_ops, &props);
+	if (IS_ERR(bl)) {
+		dev_err(&pdev->dev, "failed to register backlight\n");
+		return PTR_ERR(bl);
+	}
+
+	bl->props.brightness = props.max_brightness;
+
+	backlight_update_status(bl);
+
+	su->bl = bl;
+
+	return 0;
+}
+
+static int as3711_backlight_probe(struct platform_device *pdev)
+{
+	struct as3711_bl_pdata *pdata = dev_get_platdata(&pdev->dev);
+	struct as3711 *as3711 = dev_get_drvdata(pdev->dev.parent);
+	struct as3711_bl_supply *supply;
+	struct as3711_bl_data *su;
+	unsigned int max_brightness;
+	int ret;
+
+	if (!pdata || (!pdata->su1_fb && !pdata->su2_fb)) {
+		dev_err(&pdev->dev, "No platform data, exiting...\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * Due to possible hardware damage I chose to block all modes,
+	 * unsupported on my hardware. Anyone, wishing to use any of those modes
+	 * will have to first review the code, then activate and test it.
+	 */
+	if (pdata->su1_fb ||
+	    pdata->su2_fbprot != AS3711_SU2_GPIO4 ||
+	    pdata->su2_feedback != AS3711_SU2_CURR_AUTO) {
+		dev_warn(&pdev->dev,
+			 "Attention! An untested mode has been chosen!\n"
+			 "Please, review the code, enable, test, and report success:-)\n");
+		return -EINVAL;
+	}
+
+	supply = devm_kzalloc(&pdev->dev, sizeof(*supply), GFP_KERNEL);
+	if (!supply)
+		return -ENOMEM;
+
+	supply->as3711 = as3711;
+	supply->pdata = pdata;
+
+	if (pdata->su1_fb) {
+		su = &supply->su1;
+		su->fb_name = pdata->su1_fb;
+		su->type = AS3711_BL_SU1;
+
+		max_brightness = min(pdata->su1_max_uA, 31);
+		ret = as3711_bl_register(pdev, max_brightness, su);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (pdata->su2_fb) {
+		su = &supply->su2;
+		su->fb_name = pdata->su2_fb;
+		su->type = AS3711_BL_SU2;
+
+		switch (pdata->su2_fbprot) {
+		case AS3711_SU2_GPIO2:
+		case AS3711_SU2_GPIO3:
+		case AS3711_SU2_GPIO4:
+		case AS3711_SU2_LX_SD4:
+			break;
+		default:
+			ret = -EINVAL;
+			goto esu2;
+		}
+
+		switch (pdata->su2_feedback) {
+		case AS3711_SU2_VOLTAGE:
+			max_brightness = min(pdata->su2_max_uA, 31);
+			break;
+		case AS3711_SU2_CURR1:
+		case AS3711_SU2_CURR2:
+		case AS3711_SU2_CURR3:
+		case AS3711_SU2_CURR_AUTO:
+			max_brightness = min(pdata->su2_max_uA / 150, 255);
+			break;
+		default:
+			ret = -EINVAL;
+			goto esu2;
+		}
+
+		ret = as3711_bl_init_su2(supply);
+		if (ret < 0)
+			return ret;
+
+		ret = as3711_bl_register(pdev, max_brightness, su);
+		if (ret < 0)
+			goto esu2;
+	}
+
+	platform_set_drvdata(pdev, supply);
+
+	return 0;
+
+esu2:
+	backlight_device_unregister(supply->su1.bl);
+	return ret;
+}
+
+static int as3711_backlight_remove(struct platform_device *pdev)
+{
+	struct as3711_bl_supply *supply = platform_get_drvdata(pdev);
+
+	backlight_device_unregister(supply->su1.bl);
+	backlight_device_unregister(supply->su2.bl);
+
+	return 0;
+}
+
+static struct platform_driver as3711_backlight_driver = {
+	.driver		= {
+		.name	= "as3711-backlight",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= as3711_backlight_probe,
+	.remove		= as3711_backlight_remove,
+};
+
+module_platform_driver(as3711_backlight_driver);
+
+MODULE_DESCRIPTION("Backlight Driver for AS3711 PMICs");
+MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:as3711-backlight");
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

origin.patch
linux-next.patch

