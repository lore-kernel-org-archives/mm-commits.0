From: akpm@linux-foundation.org
Subject: + leds-add-driver-for-lm3530-als.patch added to -mm tree
Date: Thu, 20 Jan 2011 16:04:22 -0800
Message-ID: <201101210004.p0L04Mma010456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799Ab1AUAFE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 19:05:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shreshthakumar.sahu@stericsson.com, linus.walleij@stericsson.com, rpurdie@rpsys.net


The patch titled
     leds: add driver for LM3530 ALS
has been added to the -mm tree.  Its filename is
     leds-add-driver-for-lm3530-als.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: add driver for LM3530 ALS
From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

Simple backlight driver for National Semiconductor LM3530.  Presently only
manual mode is supported, PWM and ALS support to be added.

Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig       |   10 
 drivers/leds/Makefile      |    1 
 drivers/leds/leds-lm3530.c |  381 +++++++++++++++++++++++++++++++++++
 include/linux/led-lm3530.h |  108 +++++++++
 4 files changed, 500 insertions(+)

diff -puN drivers/leds/Kconfig~leds-add-driver-for-lm3530-als drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-add-driver-for-lm3530-als
+++ a/drivers/leds/Kconfig
@@ -34,6 +34,16 @@ config LEDS_ATMEL_PWM
 	  This option enables support for LEDs driven using outputs
 	  of the dedicated PWM controller found on newer Atmel SOCs.
 
+config LEDS_LM3530
+	tristate "LCD Backlight driver for LM3530"
+	depends on LEDS_CLASS
+	depends on I2C
+	help
+	  This option enables support for the LCD backlight using
+	  LM3530 ambient light sensor chip. This ALS chip can be
+	  controlled manually or using PWM input or using ambient
+	  light automatically.
+
 config LEDS_LOCOMO
 	tristate "LED Support for Locomo device"
 	depends on LEDS_CLASS
diff -puN drivers/leds/Makefile~leds-add-driver-for-lm3530-als drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-add-driver-for-lm3530-als
+++ a/drivers/leds/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_LEDS_88PM860X)		+= leds-88p
 obj-$(CONFIG_LEDS_ATMEL_PWM)		+= leds-atmel-pwm.o
 obj-$(CONFIG_LEDS_BD2802)		+= leds-bd2802.o
 obj-$(CONFIG_LEDS_LOCOMO)		+= leds-locomo.o
+obj-$(CONFIG_LEDS_LM3530)		+= leds-lm3530.o
 obj-$(CONFIG_LEDS_MIKROTIK_RB532)	+= leds-rb532.o
 obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c24xx.o
 obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
diff -puN /dev/null drivers/leds/leds-lm3530.c
--- /dev/null
+++ a/drivers/leds/leds-lm3530.c
@@ -0,0 +1,381 @@
+/*
+ * Copyright (C) 2011 ST-Ericsson SA.
+ * Copyright (C) 2009 Motorola, Inc.
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Simple driver for National Semiconductor LM3530 Backlight driver chip
+ *
+ * Author: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
+ * based on leds-lm3530.c by Dan Murphy <D.Murphy@motorola.com>
+ */
+
+#include <linux/i2c.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/led-lm3530.h>
+#include <linux/types.h>
+
+#define LM3530_LED_DEV "lcd-backlight"
+#define LM3530_NAME "lm3530-led"
+
+#define LM3530_GEN_CONFIG		0x10
+#define LM3530_ALS_CONFIG		0x20
+#define LM3530_BRT_RAMP_RATE		0x30
+#define LM3530_ALS_ZONE_REG		0x40
+#define LM3530_ALS_IMP_SELECT		0x41
+#define LM3530_BRT_CTRL_REG		0xA0
+#define LM3530_ALS_ZB0_REG		0x60
+#define LM3530_ALS_ZB1_REG		0x61
+#define LM3530_ALS_ZB2_REG		0x62
+#define LM3530_ALS_ZB3_REG		0x63
+#define LM3530_ALS_Z0T_REG		0x70
+#define LM3530_ALS_Z1T_REG		0x71
+#define LM3530_ALS_Z2T_REG		0x72
+#define LM3530_ALS_Z3T_REG		0x73
+#define LM3530_ALS_Z4T_REG		0x74
+#define LM3530_REG_MAX			15
+
+/* General Control Register */
+#define LM3530_EN_I2C_SHIFT		(0)
+#define LM3530_RAMP_LAW_SHIFT		(1)
+#define LM3530_MAX_CURR_SHIFT		(2)
+#define LM3530_EN_PWM_SHIFT		(5)
+#define LM3530_PWM_POL_SHIFT		(6)
+#define LM3530_EN_PWM_SIMPLE_SHIFT	(7)
+
+#define LM3530_ENABLE_I2C		(1 << LM3530_EN_I2C_SHIFT)
+#define LM3530_ENABLE_PWM		(1 << LM3530_EN_PWM_SHIFT)
+#define LM3530_POL_LOW			(1 << LM3530_PWM_POL_SHIFT)
+#define LM3530_ENABLE_PWM_SIMPLE	(1 << LM3530_EN_PWM_SIMPLE_SHIFT)
+
+/* ALS Config Register Options */
+#define LM3530_ALS_AVG_TIME_SHIFT	(0)
+#define LM3530_EN_ALS_SHIFT		(3)
+#define LM3530_ALS_SEL_SHIFT		(5)
+
+#define LM3530_ENABLE_ALS		(3 << LM3530_EN_ALS_SHIFT)
+
+/* Brightness Ramp Rate Register */
+#define LM3530_BRT_RAMP_FALL_SHIFT	(0)
+#define LM3530_BRT_RAMP_RISE_SHIFT	(3)
+
+/* ALS Resistor Select */
+#define LM3530_ALS1_IMP_SHIFT		(0)
+#define LM3530_ALS2_IMP_SHIFT		(4)
+
+/* Zone Boundary Register defaults */
+#define LM3530_DEF_ZB_0			(0x33)
+#define LM3530_DEF_ZB_1			(0x66)
+#define LM3530_DEF_ZB_2			(0x99)
+#define LM3530_DEF_ZB_3			(0xCC)
+
+/* Zone Target Register defaults */
+#define LM3530_DEF_ZT_0			(0x19)
+#define LM3530_DEF_ZT_1			(0x33)
+#define LM3530_DEF_ZT_2			(0x4C)
+#define LM3530_DEF_ZT_3			(0x66)
+#define LM3530_DEF_ZT_4			(0x7F)
+
+struct lm3530_mode_map {
+	const char *mode;
+	enum lm3530_mode mode_val;
+};
+
+static struct lm3530_mode_map mode_map[] = {
+	{ "man", LM3530_BL_MODE_MANUAL },
+	{ "als", LM3530_BL_MODE_ALS },
+	{ "pwm", LM3530_BL_MODE_PWM },
+};
+
+/**
+ * struct lm3530_data
+ * @led_dev: led class device
+ * @client: i2c client
+ * @pdata: LM3530 platform data
+ * @mode: mode of operation - manual, ALS, PWM
+ */
+struct lm3530_data {
+	struct led_classdev led_dev;
+	struct i2c_client *client;
+	struct lm3530_platform_data *pdata;
+	enum lm3530_mode mode;
+};
+
+static const u8 lm3530_reg[LM3530_REG_MAX] = {
+	LM3530_GEN_CONFIG,
+	LM3530_ALS_CONFIG,
+	LM3530_BRT_RAMP_RATE,
+	LM3530_ALS_ZONE_REG,
+	LM3530_ALS_IMP_SELECT,
+	LM3530_BRT_CTRL_REG,
+	LM3530_ALS_ZB0_REG,
+	LM3530_ALS_ZB1_REG,
+	LM3530_ALS_ZB2_REG,
+	LM3530_ALS_ZB3_REG,
+	LM3530_ALS_Z0T_REG,
+	LM3530_ALS_Z1T_REG,
+	LM3530_ALS_Z2T_REG,
+	LM3530_ALS_Z3T_REG,
+	LM3530_ALS_Z4T_REG,
+};
+
+static int lm3530_get_mode_from_str(const char *str, int count)
+{
+	int i;
+
+	if (str[0] == '\n')
+		return -1;
+
+	for (i = 0; i < LM3530_BL_MODE_MAX; i++)
+		if (!strncmp(mode_map[i].mode, str, count))
+			return mode_map[i].mode_val;
+
+	return -1;
+}
+
+static int lm3530_init_registers(struct lm3530_data *drvdata)
+{
+	int ret = 0;
+	int i;
+	u8 gen_config;
+	u8 als_config = 0;
+	u8 brt_ramp;
+	u8 als_imp_sel = 0;
+	u8 brightness;
+	u8 reg_val[LM3530_REG_MAX];
+	struct lm3530_platform_data *pltfm = drvdata->pdata;
+	struct i2c_client *client = drvdata->client;
+
+	gen_config = (pltfm->brt_ramp_law << LM3530_RAMP_LAW_SHIFT) |
+			((pltfm->max_current & 7) << LM3530_MAX_CURR_SHIFT);
+
+	if (drvdata->mode == LM3530_BL_MODE_MANUAL ||
+	    drvdata->mode == LM3530_BL_MODE_ALS)
+		gen_config |= (LM3530_ENABLE_I2C);
+
+	if (drvdata->mode == LM3530_BL_MODE_ALS) {
+		als_config =
+			(pltfm->als_avrg_time << LM3530_ALS_AVG_TIME_SHIFT) |
+			(LM3530_ENABLE_ALS) |
+			(pltfm->als_input_mode << LM3530_ALS_SEL_SHIFT);
+
+		als_imp_sel =
+			(pltfm->als1_resistor_sel << LM3530_ALS1_IMP_SHIFT) |
+			(pltfm->als2_resistor_sel << LM3530_ALS2_IMP_SHIFT);
+	}
+
+	if (drvdata->mode == LM3530_BL_MODE_PWM)
+		gen_config |= (LM3530_ENABLE_PWM) |
+				(pltfm->pwm_pol_hi << LM3530_PWM_POL_SHIFT) |
+				(LM3530_ENABLE_PWM_SIMPLE);
+
+	brt_ramp = (pltfm->brt_ramp_fall << LM3530_BRT_RAMP_FALL_SHIFT) |
+			(pltfm->brt_ramp_rise << LM3530_BRT_RAMP_RISE_SHIFT);
+
+	brightness = pltfm->brt_val;
+
+	reg_val[0] = gen_config;	/* LM3530_GEN_CONFIG */
+	reg_val[1] = als_config;	/* LM3530_ALS_CONFIG */
+	reg_val[2] = brt_ramp;		/* LM3530_BRT_RAMP_RATE */
+	reg_val[3] = 0x00;		/* LM3530_ALS_ZONE_REG */
+	reg_val[4] = als_imp_sel;	/* LM3530_ALS_IMP_SELECT */
+	reg_val[5] = brightness;	/* LM3530_BRT_CTRL_REG */
+	reg_val[6] = LM3530_DEF_ZB_0;	/* LM3530_ALS_ZB0_REG */
+	reg_val[7] = LM3530_DEF_ZB_1;	/* LM3530_ALS_ZB1_REG */
+	reg_val[8] = LM3530_DEF_ZB_2;	/* LM3530_ALS_ZB2_REG */
+	reg_val[9] = LM3530_DEF_ZB_3;	/* LM3530_ALS_ZB3_REG */
+	reg_val[10] = LM3530_DEF_ZT_0;	/* LM3530_ALS_Z0T_REG */
+	reg_val[11] = LM3530_DEF_ZT_1;	/* LM3530_ALS_Z1T_REG */
+	reg_val[12] = LM3530_DEF_ZT_2;	/* LM3530_ALS_Z2T_REG */
+	reg_val[13] = LM3530_DEF_ZT_3;	/* LM3530_ALS_Z3T_REG */
+	reg_val[14] = LM3530_DEF_ZT_4;	/* LM3530_ALS_Z4T_REG */
+
+	for (i = 0; i < LM3530_REG_MAX; i++) {
+		ret = i2c_smbus_write_byte_data(client,
+				lm3530_reg[i], reg_val[i]);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static void lm3530_brightness_set(struct led_classdev *led_cdev,
+				     enum led_brightness brt_val)
+{
+	int err;
+	struct lm3530_data *drvdata =
+	    container_of(led_cdev, struct lm3530_data, led_dev);
+
+	switch (drvdata->mode) {
+	case LM3530_BL_MODE_MANUAL:
+
+		/* set the brightness in brightness control register*/
+		err = i2c_smbus_write_byte_data(drvdata->client,
+				LM3530_BRT_CTRL_REG, brt_val / 2);
+		if (err)
+			dev_err(&drvdata->client->dev,
+				"Unable to set brightness: %d\n", err);
+		break;
+	case LM3530_BL_MODE_ALS:
+		break;
+	case LM3530_BL_MODE_PWM:
+		break;
+	default:
+		break;
+	}
+}
+
+
+static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
+				   *attr, const char *buf, size_t size)
+{
+	int err;
+	struct i2c_client *client = container_of(
+					dev->parent, struct i2c_client, dev);
+	struct lm3530_data *drvdata = i2c_get_clientdata(client);
+	int mode;
+
+	mode = lm3530_get_mode_from_str(buf, size-1);
+	if (mode < 0) {
+		dev_err(dev, "Invalid mode\n");
+		return -EINVAL;
+	}
+
+	if (mode == LM3530_BL_MODE_MANUAL)
+		drvdata->mode = LM3530_BL_MODE_MANUAL;
+	else if (mode == LM3530_BL_MODE_ALS)
+		drvdata->mode = LM3530_BL_MODE_ALS;
+	else if (mode == LM3530_BL_MODE_PWM) {
+		dev_err(dev, "PWM mode not supported\n");
+		return -EINVAL;
+	}
+
+	err = lm3530_init_registers(drvdata);
+	if (err) {
+		dev_err(dev, "Setting %s Mode failed :%d\n", buf, err);
+		return err;
+	}
+
+	return sizeof(drvdata->mode);
+}
+
+static DEVICE_ATTR(mode, 0644, NULL, lm3530_mode_set);
+
+static int __devinit lm3530_probe(struct i2c_client *client,
+			   const struct i2c_device_id *id)
+{
+	struct lm3530_platform_data *pdata = client->dev.platform_data;
+	struct lm3530_data *drvdata;
+	int err = 0;
+
+	if (pdata == NULL) {
+		dev_err(&client->dev, "platform data required\n");
+		err = -ENODEV;
+		goto err_out;
+	}
+
+	/* BL mode */
+	if (pdata->mode > LM3530_BL_MODE_PWM) {
+		dev_err(&client->dev, "Illegal Mode request\n");
+		err = -EINVAL;
+		goto err_out;
+	}
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "I2C_FUNC_I2C not supported\n");
+		err = -EIO;
+		goto err_out;
+	}
+
+	drvdata = kzalloc(sizeof(struct lm3530_data), GFP_KERNEL);
+	if (drvdata == NULL) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	drvdata->mode = pdata->mode;
+	drvdata->client = client;
+	drvdata->pdata = pdata;
+	drvdata->led_dev.name = LM3530_LED_DEV;
+	drvdata->led_dev.brightness_set = lm3530_brightness_set;
+
+	i2c_set_clientdata(client, drvdata);
+
+	err = lm3530_init_registers(drvdata);
+	if (err < 0) {
+		dev_err(&client->dev, "Register Init failed: %d\n", err);
+		err = -ENODEV;
+		goto err_reg_init;
+	}
+
+	err = led_classdev_register((struct device *)
+				      &client->dev, &drvdata->led_dev);
+	if (err < 0) {
+		dev_err(&client->dev, "Register led class failed: %d\n", err);
+		err = -ENODEV;
+		goto err_class_register;
+	}
+
+	err = device_create_file(drvdata->led_dev.dev, &dev_attr_mode);
+	if (err < 0) {
+		dev_err(&client->dev, "File device creation failed: %d\n", err);
+		err = -ENODEV;
+		goto err_create_file;
+	}
+
+	return 0;
+
+err_create_file:
+	led_classdev_unregister(&drvdata->led_dev);
+err_class_register:
+err_reg_init:
+	kfree(drvdata);
+err_out:
+	return err;
+}
+
+static int __devexit lm3530_remove(struct i2c_client *client)
+{
+	struct lm3530_data *drvdata = i2c_get_clientdata(client);
+
+	device_remove_file(drvdata->led_dev.dev, &dev_attr_mode);
+	led_classdev_unregister(&drvdata->led_dev);
+	kfree(drvdata);
+	return 0;
+}
+
+static const struct i2c_device_id lm3530_id[] = {
+	{LM3530_NAME, 0},
+	{}
+};
+
+static struct i2c_driver lm3530_i2c_driver = {
+	.probe = lm3530_probe,
+	.remove = lm3530_remove,
+	.id_table = lm3530_id,
+	.driver = {
+		.name = LM3530_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init lm3530_init(void)
+{
+	return i2c_add_driver(&lm3530_i2c_driver);
+}
+
+static void __exit lm3530_exit(void)
+{
+	i2c_del_driver(&lm3530_i2c_driver);
+}
+
+module_init(lm3530_init);
+module_exit(lm3530_exit);
+
+MODULE_DESCRIPTION("Back Light driver for LM3530");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>");
diff -puN /dev/null include/linux/led-lm3530.h
--- /dev/null
+++ a/include/linux/led-lm3530.h
@@ -0,0 +1,108 @@
+/*
+ * Copyright (C) 2011 ST-Ericsson SA.
+ * Copyright (C) 2009 Motorola, Inc.
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Simple driver for National Semiconductor LM35330 Backlight driver chip
+ *
+ * Author: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
+ * based on leds-lm3530.c by Dan Murphy <D.Murphy@motorola.com>
+ */
+
+#ifndef _LINUX_LED_LM3530_H__
+#define _LINUX_LED_LM3530_H__
+
+#define LM3530_FS_CURR_5mA		(0) /* Full Scale Current */
+#define LM3530_FS_CURR_8mA		(1)
+#define LM3530_FS_CURR_12mA		(2)
+#define LM3530_FS_CURR_15mA		(3)
+#define LM3530_FS_CURR_19mA		(4)
+#define LM3530_FS_CURR_22mA		(5)
+#define LM3530_FS_CURR_26mA		(6)
+#define LM3530_FS_CURR_29mA		(7)
+
+#define LM3530_ALS_AVRG_TIME_32ms	(0) /* ALS Averaging Time */
+#define LM3530_ALS_AVRG_TIME_64ms	(1)
+#define LM3530_ALS_AVRG_TIME_128ms	(2)
+#define LM3530_ALS_AVRG_TIME_256ms	(3)
+#define LM3530_ALS_AVRG_TIME_512ms	(4)
+#define LM3530_ALS_AVRG_TIME_1024ms	(5)
+#define LM3530_ALS_AVRG_TIME_2048ms	(6)
+#define LM3530_ALS_AVRG_TIME_4096ms	(7)
+
+#define LM3530_RAMP_TIME_1ms		(0) /* Brigtness Ramp Time */
+#define LM3530_RAMP_TIME_130ms		(1) /* Max to 0 and vice versa */
+#define LM3530_RAMP_TIME_260ms		(2)
+#define LM3530_RAMP_TIME_520ms		(3)
+#define LM3530_RAMP_TIME_1s		(4)
+#define LM3530_RAMP_TIME_2s		(5)
+#define LM3530_RAMP_TIME_4s		(6)
+#define LM3530_RAMP_TIME_8s		(7)
+
+/* ALS Resistor Select */
+#define LM3530_ALS_IMPD_Z		(0x00) /* ALS Impedence */
+#define LM3530_ALS_IMPD_13_53kOhm	(0x01)
+#define LM3530_ALS_IMPD_9_01kOhm	(0x02)
+#define LM3530_ALS_IMPD_5_41kOhm	(0x03)
+#define LM3530_ALS_IMPD_2_27kOhm	(0x04)
+#define LM3530_ALS_IMPD_1_94kOhm	(0x05)
+#define LM3530_ALS_IMPD_1_81kOhm	(0x06)
+#define LM3530_ALS_IMPD_1_6kOhm		(0x07)
+#define LM3530_ALS_IMPD_1_138kOhm	(0x08)
+#define LM3530_ALS_IMPD_1_05kOhm	(0x09)
+#define LM3530_ALS_IMPD_1_011kOhm	(0x0A)
+#define LM3530_ALS_IMPD_941Ohm		(0x0B)
+#define LM3530_ALS_IMPD_759Ohm		(0x0C)
+#define LM3530_ALS_IMPD_719Ohm		(0x0D)
+#define LM3530_ALS_IMPD_700Ohm		(0x0E)
+#define LM3530_ALS_IMPD_667Ohm		(0x0F)
+
+enum lm3530_mode {
+	LM3530_BL_MODE_MANUAL = 0,	/* "man" */
+	LM3530_BL_MODE_ALS,		/* "als" */
+	LM3530_BL_MODE_PWM,		/* "pwm" */
+	LM3530_BL_MODE_MAX,
+};
+
+/* ALS input select */
+enum lm3530_als_mode {
+	LM3530_INPUT_AVRG = 0,	/* ALS1 and ALS2 input average */
+	LM3530_INPUT_ALS1,	/* ALS1 Input */
+	LM3530_INPUT_ALS2,	/* ALS2 Input */
+	LM3530_INPUT_CEIL,	/* Max of ALS1 and ALS2 */
+};
+
+/**
+ * struct lm3530_platform_data
+ * @mode: mode of operation i.e. Manual, ALS or PWM
+ * @als_input_mode: select source of ALS input - ALS1/2 or average
+ * @max_current: full scale LED current
+ * @pwm_pol_hi: PWM input polarity - active high/active low
+ * @als_avrg_time: ALS input averaging time
+ * @brt_ramp_law: brightness mapping mode - exponential/linear
+ * @brt_ramp_fall: rate of fall of led current
+ * @brt_ramp_rise: rate of rise of led current
+ * @als1_resistor_sel: internal resistance from ALS1 input to ground
+ * @als2_resistor_sel: internal resistance from ALS2 input to ground
+ * @brt_val: brightness value (0-255)
+ */
+struct lm3530_platform_data {
+	enum lm3530_mode mode;
+	enum lm3530_als_mode als_input_mode;
+
+	u8 max_current;
+	bool pwm_pol_hi;
+	u8 als_avrg_time;
+
+	bool brt_ramp_law;
+	u8 brt_ramp_fall;
+	u8 brt_ramp_rise;
+
+	u8 als1_resistor_sel;
+	u8 als2_resistor_sel;
+
+	u8 brt_val;
+};
+
+#endif	/* _LINUX_LED_LM3530_H__ */
_

Patches currently in -mm which might be from shreshthakumar.sahu@stericsson.com are

leds-add-driver-for-lm3530-als.patch

