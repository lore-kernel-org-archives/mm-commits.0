From: akpm@linux-foundation.org
Subject: + backlight-add-new-lp8788-backlight-driver.patch added to -mm tree
Date: Fri, 21 Dec 2012 14:29:49 -0800
Message-ID: <20121221222949.AC015100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:36123 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2LUW3v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 17:29:51 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so528237yhl.3
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 14:29:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, milo.kim@ti.com, rpurdie@rpsys.net, sameo@linux.intel.com, thierry.reding@avionic-design.de


The patch titled
     Subject: backlight: add new lp8788 backlight driver
has been added to the -mm tree.  Its filename is
     backlight-add-new-lp8788-backlight-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: backlight: add new lp8788 backlight driver

TI LP8788 PMU supports regulators, battery charger, RTC, ADC, backlight
dri= ver and current sinks.  This patch enables LP8788 backlight module.

(Brightness mode)
The brightness is controlled by PWM input or I2C register.
All modes are supported in the driver.

(Platform data)
Configurable data can be defined in the platform side.
 name                  : backlight driver name. (default: "lcd-backlight")
 initial_brightness    : initial value of backlight brightness
 bl_mode               : brightness control by PWM or lp8788 register
 dim_mode              : dimming mode selection
 full_scale            : full scale current setting
 rise_time             : brightness ramp up step time
 fall_time             : brightness ramp down step time
 pwm_pol               : PWM polarity setting when bl_mode is PWM based
 period_ns             : platform specific PWM period value. unit is nano.

The default values are set in case no platform data is defined.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig     |    6 
 drivers/video/backlight/Makefile    |    1 
 drivers/video/backlight/lp8788_bl.c |  350 ++++++++++++++++++++++++++
 include/linux/mfd/lp8788.h          |   16 -
 4 files changed, 360 insertions(+), 13 deletions(-)

diff -puN drivers/video/backlight/Kconfig~backlight-add-new-lp8788-backlight-driver drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-add-new-lp8788-backlight-driver
+++ a/drivers/video/backlight/Kconfig
@@ -377,6 +377,12 @@ config BACKLIGHT_LP855X
 	  This supports TI LP8550, LP8551, LP8552, LP8553 and LP8556
 	  backlight driver.
 
+config BACKLIGHT_LP8788
+	tristate "Backlight driver for TI LP8788 MFD"
+	depends on BACKLIGHT_CLASS_DEVICE && MFD_LP8788
+	help
+	  This supports TI LP8788 backlight driver.
+
 config BACKLIGHT_OT200
 	tristate "Backlight driver for ot200 visualisation device"
 	depends on BACKLIGHT_CLASS_DEVICE && CS5535_MFGPT && GPIO_CS5535
diff -puN drivers/video/backlight/Makefile~backlight-add-new-lp8788-backlight-driver drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~backlight-add-new-lp8788-backlight-driver
+++ a/drivers/video/backlight/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_BACKLIGHT_LOCOMO)	+= locomo
 obj-$(CONFIG_BACKLIGHT_LM3630)	+= lm3630_bl.o
 obj-$(CONFIG_BACKLIGHT_LM3639)	+= lm3639_bl.o
 obj-$(CONFIG_BACKLIGHT_LP855X)	+= lp855x_bl.o
+obj-$(CONFIG_BACKLIGHT_LP8788)	+= lp8788_bl.o
 obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
 obj-$(CONFIG_BACKLIGHT_PANDORA)	+= pandora_bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
diff -puN /dev/null drivers/video/backlight/lp8788_bl.c
--- /dev/null
+++ a/drivers/video/backlight/lp8788_bl.c
@@ -0,0 +1,350 @@
+/*
+ * TI LP8788 MFD - backlight driver
+ *
+ * Copyright 2012 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/backlight.h>
+#include <linux/err.h>
+#include <linux/mfd/lp8788.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/slab.h>
+
+/* register address */
+#define LP8788_BL_CONFIG		0x96
+#define LP8788_BL_BRIGHTNESS		0x97
+#define LP8788_BL_RAMP			0x98
+
+/* mask/shift bits */
+#define LP8788_BL_EN			BIT(0)	/* Addr 96h */
+#define LP8788_BL_PWM_EN		BIT(5)
+#define LP8788_BL_FULLSCALE_S		2
+#define LP8788_BL_DIM_MODE_S		1
+#define LP8788_BL_PWM_POLARITY_S	6
+#define LP8788_BL_RAMP_RISE_S		4	/* Addr 98h */
+
+#define BUF_SIZE			20
+#define MAX_BRIGHTNESS			127
+#define DEFAULT_BL_NAME			"lcd-backlight"
+
+struct lp8788_bl_config {
+	enum lp8788_bl_ctrl_mode bl_mode;
+	enum lp8788_bl_dim_mode dim_mode;
+	enum lp8788_bl_full_scale_current full_scale;
+	enum lp8788_bl_ramp_step rise_time;
+	enum lp8788_bl_ramp_step fall_time;
+	enum lp8788_bl_pwm_polarity pwm_pol;
+};
+
+struct lp8788_bl {
+	struct lp8788 *lp;
+	struct backlight_device *bl_dev;
+	struct lp8788_backlight_platform_data *pdata;
+	enum lp8788_bl_ctrl_mode mode;
+	struct pwm_device *pwm;
+};
+
+struct lp8788_bl_config default_bl_config = {
+	.bl_mode    = LP8788_BL_REGISTER_ONLY,
+	.dim_mode   = LP8788_DIM_EXPONENTIAL,
+	.full_scale = LP8788_FULLSCALE_1900uA,
+	.rise_time  = LP8788_RAMP_8192us,
+	.fall_time  = LP8788_RAMP_8192us,
+	.pwm_pol    = LP8788_PWM_ACTIVE_HIGH,
+};
+
+static inline bool is_brightness_ctrl_by_pwm(enum lp8788_bl_ctrl_mode mode)
+{
+	return (mode == LP8788_BL_COMB_PWM_BASED);
+}
+
+static inline bool is_brightness_ctrl_by_register(enum lp8788_bl_ctrl_mode mode)
+{
+	return (mode == LP8788_BL_REGISTER_ONLY ||
+		mode == LP8788_BL_COMB_REGISTER_BASED);
+}
+
+static int lp8788_backlight_configure(struct lp8788_bl *bl)
+{
+	struct lp8788_backlight_platform_data *pdata = bl->pdata;
+	struct lp8788_bl_config *cfg = &default_bl_config;
+	int ret;
+	u8 val;
+
+	/* update chip configuration if platform data exists,
+	   otherwise use the default settings */
+	if (pdata) {
+		cfg->bl_mode    = pdata->bl_mode;
+		cfg->dim_mode   = pdata->dim_mode;
+		cfg->full_scale = pdata->full_scale;
+		cfg->rise_time  = pdata->rise_time;
+		cfg->fall_time  = pdata->fall_time;
+		cfg->pwm_pol    = pdata->pwm_pol;
+	}
+
+	/* brightness ramp up/down */
+	val = (cfg->rise_time << LP8788_BL_RAMP_RISE_S) | cfg->fall_time;
+	ret = lp8788_write_byte(bl->lp, LP8788_BL_RAMP, val);
+	if (ret) {
+		/* no I2C needed in case of pwm control mode */
+		if (is_brightness_ctrl_by_pwm(cfg->bl_mode))
+			goto no_err;
+		else
+			return ret;
+	}
+
+	/* fullscale current setting */
+	val = (cfg->full_scale << LP8788_BL_FULLSCALE_S) |
+		(cfg->dim_mode << LP8788_BL_DIM_MODE_S);
+
+	/* brightness control mode */
+	switch (cfg->bl_mode) {
+	case LP8788_BL_REGISTER_ONLY:
+		val |= LP8788_BL_EN;
+		break;
+	case LP8788_BL_COMB_PWM_BASED:
+	case LP8788_BL_COMB_REGISTER_BASED:
+		val |= LP8788_BL_EN | LP8788_BL_PWM_EN |
+			(cfg->pwm_pol << LP8788_BL_PWM_POLARITY_S);
+		break;
+	default:
+		dev_err(bl->lp->dev, "invalid mode: %d\n", cfg->bl_mode);
+		return -EINVAL;
+	}
+
+	bl->mode = cfg->bl_mode;
+
+	return lp8788_write_byte(bl->lp, LP8788_BL_CONFIG, val);
+
+no_err:
+	return 0;
+}
+
+static void lp8788_pwm_ctrl(struct lp8788_bl *bl, int br, int max_br)
+{
+	unsigned int period;
+	unsigned int duty;
+	struct device *dev;
+	struct pwm_device *pwm;
+
+	if (!bl->pdata)
+		return;
+
+	period = bl->pdata->period_ns;
+	duty = br * period / max_br;
+	dev = bl->lp->dev;
+
+	/* request pwm device with the consumer name */
+	if (!bl->pwm) {
+		pwm = devm_pwm_get(dev, LP8788_DEV_BACKLIGHT);
+		if (IS_ERR(pwm)) {
+			dev_err(dev, "can not get pwm device\n");
+			return;
+		}
+
+		bl->pwm = pwm;
+	}
+
+	pwm_config(bl->pwm, duty, period);
+	if (duty)
+		pwm_enable(bl->pwm);
+	else
+		pwm_disable(bl->pwm);
+}
+
+static int lp8788_bl_update_status(struct backlight_device *bl_dev)
+{
+	struct lp8788_bl *bl = bl_get_data(bl_dev);
+	enum lp8788_bl_ctrl_mode mode = bl->mode;
+
+	if (bl_dev->props.state & BL_CORE_SUSPENDED)
+		bl_dev->props.brightness = 0;
+
+	if (is_brightness_ctrl_by_pwm(mode)) {
+		int brt = bl_dev->props.brightness;
+		int max = bl_dev->props.max_brightness;
+
+		lp8788_pwm_ctrl(bl, brt, max);
+	} else if (is_brightness_ctrl_by_register(mode)) {
+		u8 brt = bl_dev->props.brightness;
+
+		lp8788_write_byte(bl->lp, LP8788_BL_BRIGHTNESS, brt);
+	}
+
+	return 0;
+}
+
+static int lp8788_bl_get_brightness(struct backlight_device *bl_dev)
+{
+	struct lp8788_bl *bl = bl_get_data(bl_dev);
+	enum lp8788_bl_ctrl_mode mode = bl->mode;
+
+	if (is_brightness_ctrl_by_register(mode)) {
+		u8 val = 0;
+
+		lp8788_read_byte(bl->lp, LP8788_BL_BRIGHTNESS, &val);
+		bl_dev->props.brightness = val;
+	}
+
+	return bl_dev->props.brightness;
+}
+
+static const struct backlight_ops lp8788_bl_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
+	.update_status = lp8788_bl_update_status,
+	.get_brightness = lp8788_bl_get_brightness,
+};
+
+static int lp8788_backlight_register(struct lp8788_bl *bl)
+{
+	struct backlight_device *bl_dev;
+	struct backlight_properties props;
+	struct lp8788_backlight_platform_data *pdata = bl->pdata;
+	int init_brt;
+	char *name;
+
+	props.type = BACKLIGHT_PLATFORM;
+	props.max_brightness = MAX_BRIGHTNESS;
+
+	/* initial brightness */
+	if (pdata)
+		init_brt = min_t(int, pdata->initial_brightness,
+				props.max_brightness);
+	else
+		init_brt = 0;
+
+	props.brightness = init_brt;
+
+	/* backlight device name */
+	if (!pdata || !pdata->name)
+		name = DEFAULT_BL_NAME;
+	else
+		name = pdata->name;
+
+	bl_dev = backlight_device_register(name, bl->lp->dev, bl,
+				       &lp8788_bl_ops, &props);
+	if (IS_ERR(bl_dev))
+		return PTR_ERR(bl_dev);
+
+	bl->bl_dev = bl_dev;
+
+	return 0;
+}
+
+static void lp8788_backlight_unregister(struct lp8788_bl *bl)
+{
+	struct backlight_device *bl_dev = bl->bl_dev;
+
+	if (bl_dev)
+		backlight_device_unregister(bl_dev);
+}
+
+static ssize_t lp8788_get_bl_ctl_mode(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct lp8788_bl *bl = dev_get_drvdata(dev);
+	enum lp8788_bl_ctrl_mode mode = bl->mode;
+	char *strmode;
+
+	if (is_brightness_ctrl_by_pwm(mode))
+		strmode = "pwm based";
+	else if (is_brightness_ctrl_by_register(mode))
+		strmode = "register based";
+	else
+		strmode = "invalid mode";
+
+	return scnprintf(buf, BUF_SIZE, "%s\n", strmode);
+}
+
+static DEVICE_ATTR(bl_ctl_mode, S_IRUGO, lp8788_get_bl_ctl_mode, NULL);
+
+static struct attribute *lp8788_attributes[] = {
+	&dev_attr_bl_ctl_mode.attr,
+	NULL,
+};
+
+static const struct attribute_group lp8788_attr_group = {
+	.attrs = lp8788_attributes,
+};
+
+static int lp8788_backlight_probe(struct platform_device *pdev)
+{
+	struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
+	struct lp8788_bl *bl;
+	int ret;
+
+	bl = devm_kzalloc(lp->dev, sizeof(struct lp8788_bl), GFP_KERNEL);
+	if (!bl)
+		return -ENOMEM;
+
+	bl->lp = lp;
+	if (lp->pdata)
+		bl->pdata = lp->pdata->bl_pdata;
+
+	platform_set_drvdata(pdev, bl);
+
+	ret = lp8788_backlight_configure(bl);
+	if (ret) {
+		dev_err(lp->dev, "backlight config err: %d\n", ret);
+		goto err_dev;
+	}
+
+	ret = lp8788_backlight_register(bl);
+	if (ret) {
+		dev_err(lp->dev, "register backlight err: %d\n", ret);
+		goto err_dev;
+	}
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &lp8788_attr_group);
+	if (ret) {
+		dev_err(lp->dev, "register sysfs err: %d\n", ret);
+		goto err_sysfs;
+	}
+
+	backlight_update_status(bl->bl_dev);
+
+	return 0;
+
+err_sysfs:
+	lp8788_backlight_unregister(bl);
+err_dev:
+	return ret;
+}
+
+static int lp8788_backlight_remove(struct platform_device *pdev)
+{
+	struct lp8788_bl *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl_dev = bl->bl_dev;
+
+	bl_dev->props.brightness = 0;
+	backlight_update_status(bl_dev);
+	sysfs_remove_group(&pdev->dev.kobj, &lp8788_attr_group);
+	lp8788_backlight_unregister(bl);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver lp8788_bl_driver = {
+	.probe = lp8788_backlight_probe,
+	.remove = lp8788_backlight_remove,
+	.driver = {
+		.name = LP8788_DEV_BACKLIGHT,
+		.owner = THIS_MODULE,
+	},
+};
+module_platform_driver(lp8788_bl_driver);
+
+MODULE_DESCRIPTION("Texas Instruments LP8788 Backlight Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:lp8788-backlight");
diff -puN include/linux/mfd/lp8788.h~backlight-add-new-lp8788-backlight-driver include/linux/mfd/lp8788.h
--- a/include/linux/mfd/lp8788.h~backlight-add-new-lp8788-backlight-driver
+++ a/include/linux/mfd/lp8788.h
@@ -229,16 +229,6 @@ struct lp8788_charger_platform_data {
 };
 
 /*
- * struct lp8788_bl_pwm_data
- * @pwm_set_intensity     : set duty of pwm
- * @pwm_get_intensity     : get current duty of pwm
- */
-struct lp8788_bl_pwm_data {
-	void (*pwm_set_intensity) (int brightness, int max_brightness);
-	int (*pwm_get_intensity) (int max_brightness);
-};
-
-/*
  * struct lp8788_backlight_platform_data
  * @name                  : backlight driver name. (default: "lcd-backlight")
  * @initial_brightness    : initial value of backlight brightness
@@ -248,8 +238,8 @@ struct lp8788_bl_pwm_data {
  * @rise_time             : brightness ramp up step time
  * @fall_time             : brightness ramp down step time
  * @pwm_pol               : pwm polarity setting when bl_mode is pwm based
- * @pwm_data              : platform specific pwm generation functions
- *                          only valid when bl_mode is pwm based
+ * @period_ns             : platform specific pwm period value. unit is nano.
+		            Only valid when bl_mode is LP8788_BL_COMB_PWM_BASED
  */
 struct lp8788_backlight_platform_data {
 	char *name;
@@ -260,7 +250,7 @@ struct lp8788_backlight_platform_data {
 	enum lp8788_bl_ramp_step rise_time;
 	enum lp8788_bl_ramp_step fall_time;
 	enum lp8788_bl_pwm_polarity pwm_pol;
-	struct lp8788_bl_pwm_data pwm_data;
+	unsigned int period_ns;
 };
 
 /*
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch
backlight-add-new-lp8788-backlight-driver.patch

