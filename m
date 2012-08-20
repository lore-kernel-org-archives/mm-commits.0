From: akpm@linux-foundation.org
Subject: + backlight-add-backlight-driver-for-lm3630-chip.patch added to -mm tree
Date: Mon, 20 Aug 2012 13:36:48 -0700
Message-ID: <20120820203649.2D27B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:64208 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2HTUgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 16:36:50 -0400
Received: by ialo24 with SMTP id o24so914338ial.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 13:36:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gshark.jeong@gmail.com, daniel.jeong@ti.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: add Backlight driver for lm3630 chip
has been added to the -mm tree.  Its filename is
     backlight-add-backlight-driver-for-lm3630-chip.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: backlight: add Backlight driver for lm3630 chip

This driver is a general version for LM3630 backlgiht driver chip of TI.

LM3630 :
The LM3630 is a current mode boost converter which supplies the power
and controls the current in two strings of up to 10 LEDs per string.
Programming is done over an I2C compatible interface.
www.ti.com

Signed-off-by: G.Shark Jeong <gshark.jeong@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig         |    7 
 drivers/video/backlight/Makefile        |    1 
 drivers/video/backlight/lm3630_bl.c     |  476 ++++++++++++++++++++++
 include/linux/platform_data/lm3630_bl.h |   57 ++
 4 files changed, 541 insertions(+)

diff -puN drivers/video/backlight/Kconfig~backlight-add-backlight-driver-for-lm3630-chip drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-add-backlight-driver-for-lm3630-chip
+++ a/drivers/video/backlight/Kconfig
@@ -352,6 +352,13 @@ config BACKLIGHT_AAT2870
 	  If you have a AnalogicTech AAT2870 say Y to enable the
 	  backlight driver.
 
+config BACKLIGHT_LM3630
+	tristate "Backlight Driver for LM3630"
+	depends on BACKLIGHT_CLASS_DEVICE && I2C
+	select REGMAP_I2C
+	help
+	  This supports TI LM3630 Backlight Driver
+
 config BACKLIGHT_LP855X
 	tristate "Backlight driver for TI LP855X"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C
diff -puN drivers/video/backlight/Makefile~backlight-add-backlight-driver-for-lm3630-chip drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~backlight-add-backlight-driver-for-lm3630-chip
+++ a/drivers/video/backlight/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_BACKLIGHT_HP700)	+= jornada
 obj-$(CONFIG_BACKLIGHT_HP680)	+= hp680_bl.o
 obj-$(CONFIG_BACKLIGHT_LM3533)	+= lm3533_bl.o
 obj-$(CONFIG_BACKLIGHT_LOCOMO)	+= locomolcd.o
+obj-$(CONFIG_BACKLIGHT_LM3630)	+= lm3630_bl.o
 obj-$(CONFIG_BACKLIGHT_LP855X)	+= lp855x_bl.o
 obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
 obj-$(CONFIG_BACKLIGHT_PANDORA)	+= pandora_bl.o
diff -puN /dev/null drivers/video/backlight/lm3630_bl.c
--- /dev/null
+++ a/drivers/video/backlight/lm3630_bl.c
@@ -0,0 +1,476 @@
+/*
+* Simple driver for Texas Instruments LM3630 Backlight driver chip
+* Copyright (C) 2012 Texas Instruments
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+*/
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/backlight.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/interrupt.h>
+#include <linux/regmap.h>
+#include <linux/platform_data/lm3630_bl.h>
+
+#define REG_CTRL	0x00
+#define REG_CONFIG	0x01
+#define REG_BRT_A	0x03
+#define REG_BRT_B	0x04
+#define REG_INT_STATUS	0x09
+#define REG_INT_EN	0x0A
+#define REG_FAULT	0x0B
+#define REG_PWM_OUTLOW	0x12
+#define REG_PWM_OUTHIGH	0x13
+#define REG_MAX		0x1F
+
+#define INT_DEBOUNCE_MSEC	10
+
+enum lm3630_leds {
+	BLED_ALL = 0,
+	BLED_1,
+	BLED_2
+};
+
+const char *bled_name[] = {
+	[BLED_ALL] = "lm3630_bled",	/*Bank1 controls all string */
+	[BLED_1] = "lm3630_bled1",	/*Bank1 controls bled1 */
+	[BLED_2] = "lm3630_bled2",	/*Bank1 or 2 controls bled2 */
+};
+
+struct lm3630_chip_data {
+	struct device *dev;
+	struct delayed_work work;
+	int irq;
+	struct workqueue_struct *irqthread;
+	struct lm3630_platform_data *pdata;
+	struct backlight_device *bled1;
+	struct backlight_device *bled2;
+	struct regmap *regmap;
+};
+
+/* initialize chip */
+static int __devinit lm3630_chip_init(struct lm3630_chip_data *pchip)
+{
+	int ret;
+	unsigned int reg_val;
+	struct lm3630_platform_data *pdata = pchip->pdata;
+
+	/*pwm control */
+	reg_val = ((pdata->pwm_active & 0x01) << 2)
+	    | (pdata->pwm_ctrl & 0x03);
+	ret = regmap_update_bits(pchip->regmap, REG_CONFIG, 0x07, reg_val);
+	if (ret < 0)
+		goto out;
+
+	/* bank control */
+	reg_val = ((pdata->bank_b_ctrl & 0x01) << 1)
+	    | (pdata->bank_a_ctrl & 0x07);
+	ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x07, reg_val);
+	if (ret < 0)
+		goto out;
+
+	ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
+	if (ret < 0)
+		goto out;
+
+	/* set initial brightness */
+	if (pdata->bank_a_ctrl != BANK_A_CTRL_DISABLE) {
+		ret = regmap_write(pchip->regmap,
+				   REG_BRT_A, pdata->init_brt_led1);
+		if (ret < 0)
+			goto out;
+	}
+
+	if (pdata->bank_b_ctrl != BANK_B_CTRL_DISABLE) {
+		ret = regmap_write(pchip->regmap,
+				   REG_BRT_B, pdata->init_brt_led2);
+		if (ret < 0)
+			goto out;
+	}
+	return ret;
+
+out:
+	dev_err(pchip->dev, "i2c failed to access register\n");
+	return ret;
+}
+
+/* interrupt handling */
+static void lm3630_delayed_func(struct work_struct *work)
+{
+	int ret;
+	unsigned int reg_val;
+	struct lm3630_chip_data *pchip =
+	    container_of(work, struct lm3630_chip_data, work.work);
+
+	ret = regmap_read(pchip->regmap, REG_INT_STATUS, &reg_val);
+	if (ret < 0) {
+		dev_err(pchip->dev,
+			"i2c failed to access REG_INT_STATUS Register\n");
+		return;
+	}
+
+	dev_info(pchip->dev, "REG_INT_STATUS Register is 0x%x\n", reg_val);
+}
+
+static irqreturn_t lm3630_isr_func(int irq, void *chip)
+{
+	int ret;
+	struct lm3630_chip_data *pchip = chip;
+	unsigned long delay = msecs_to_jiffies(INT_DEBOUNCE_MSEC);
+
+	queue_delayed_work(pchip->irqthread, &pchip->work, delay);
+
+	ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
+	if (ret < 0)
+		goto out;
+
+	return IRQ_HANDLED;
+out:
+	dev_err(pchip->dev, "i2c failed to access register\n");
+	return IRQ_HANDLED;
+}
+
+static int lm3630_intr_config(struct lm3630_chip_data *pchip)
+{
+	INIT_DELAYED_WORK(&pchip->work, lm3630_delayed_func);
+	pchip->irqthread = create_singlethread_workqueue("lm3630-irqthd");
+	if (!pchip->irqthread) {
+		dev_err(pchip->dev, "create irq thread fail...\n");
+		return -1;
+	}
+	if (request_threaded_irq
+	    (pchip->irq, NULL, lm3630_isr_func,
+	     IRQF_TRIGGER_FALLING | IRQF_ONESHOT, "lm3630_irq", pchip)) {
+		dev_err(pchip->dev, "request threaded irq fail..\n");
+		return -1;
+	}
+	return 0;
+}
+
+/* update and get brightness */
+static int lm3630_bank_a_update_status(struct backlight_device *bl)
+{
+	int ret;
+	struct lm3630_chip_data *pchip = bl_get_data(bl);
+	enum lm3630_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;
+
+	/* brightness 0 means disable */
+	if (!bl->props.brightness) {
+		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x04, 0x00);
+		if (ret < 0)
+			goto out;
+		return bl->props.brightness;
+	}
+
+	/* pwm control */
+	if (pwm_ctrl == PWM_CTRL_BANK_A || pwm_ctrl == PWM_CTRL_BANK_ALL) {
+		if (pchip->pdata->pwm_set_intensity)
+			pchip->pdata->pwm_set_intensity(bl->props.brightness -
+							1,
+							pchip->pdata->
+							pwm_period);
+		else
+			dev_err(pchip->dev,
+				"No pwm control func. in plat-data\n");
+	} else {
+
+		/* i2c control */
+		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
+		if (ret < 0)
+			goto out;
+		mdelay(1);
+		ret = regmap_write(pchip->regmap,
+				   REG_BRT_A, bl->props.brightness - 1);
+		if (ret < 0)
+			goto out;
+	}
+	return bl->props.brightness;
+out:
+	dev_err(pchip->dev, "i2c failed to access REG_CTRL\n");
+	return bl->props.brightness;
+}
+
+static int lm3630_bank_a_get_brightness(struct backlight_device *bl)
+{
+	unsigned int reg_val;
+	int brightness, ret;
+	struct lm3630_chip_data *pchip = bl_get_data(bl);
+	enum lm3630_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;
+
+	if (pwm_ctrl == PWM_CTRL_BANK_A || pwm_ctrl == PWM_CTRL_BANK_ALL) {
+		ret = regmap_read(pchip->regmap, REG_PWM_OUTHIGH, &reg_val);
+		if (ret < 0)
+			goto out;
+		brightness = reg_val & 0x01;
+		ret = regmap_read(pchip->regmap, REG_PWM_OUTLOW, &reg_val);
+		if (ret < 0)
+			goto out;
+		brightness = ((brightness << 8) | reg_val) + 1;
+	} else {
+		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
+		if (ret < 0)
+			goto out;
+		mdelay(1);
+		ret = regmap_read(pchip->regmap, REG_BRT_A, &reg_val);
+		if (ret < 0)
+			goto out;
+		brightness = reg_val + 1;
+	}
+	bl->props.brightness = brightness;
+	return bl->props.brightness;
+out:
+	dev_err(pchip->dev, "i2c failed to access register\n");
+	return 0;
+}
+
+static const struct backlight_ops lm3630_bank_a_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
+	.update_status = lm3630_bank_a_update_status,
+	.get_brightness = lm3630_bank_a_get_brightness,
+};
+
+static int lm3630_bank_b_update_status(struct backlight_device *bl)
+{
+	int ret;
+	struct lm3630_chip_data *pchip = bl_get_data(bl);
+	enum lm3630_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;
+
+	if (pwm_ctrl == PWM_CTRL_BANK_B || pwm_ctrl == PWM_CTRL_BANK_ALL) {
+		if (pchip->pdata->pwm_set_intensity)
+			pchip->pdata->pwm_set_intensity(bl->props.brightness -
+							1,
+							pchip->pdata->
+							pwm_period);
+		else
+			dev_err(pchip->dev,
+				"no pwm control func. in plat-data\n");
+	} else {
+		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
+		if (ret < 0)
+			goto out;
+		mdelay(1);
+		ret = regmap_write(pchip->regmap,
+				   REG_BRT_B, bl->props.brightness - 1);
+	}
+	return bl->props.brightness;
+out:
+	dev_err(pchip->dev, "i2c failed to access register\n");
+	return bl->props.brightness;
+}
+
+static int lm3630_bank_b_get_brightness(struct backlight_device *bl)
+{
+	unsigned int reg_val;
+	int brightness, ret;
+	struct lm3630_chip_data *pchip = bl_get_data(bl);
+	enum lm3630_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;
+
+	if (pwm_ctrl == PWM_CTRL_BANK_B || pwm_ctrl == PWM_CTRL_BANK_ALL) {
+		ret = regmap_read(pchip->regmap, REG_PWM_OUTHIGH, &reg_val);
+		if (ret < 0)
+			goto out;
+		brightness = reg_val & 0x01;
+		ret = regmap_read(pchip->regmap, REG_PWM_OUTLOW, &reg_val);
+		if (ret < 0)
+			goto out;
+		brightness = ((brightness << 8) | reg_val) + 1;
+	} else {
+		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
+		if (ret < 0)
+			goto out;
+		mdelay(1);
+		ret = regmap_read(pchip->regmap, REG_BRT_B, &reg_val);
+		if (ret < 0)
+			goto out;
+		brightness = reg_val + 1;
+	}
+	bl->props.brightness = brightness;
+
+	return bl->props.brightness;
+out:
+	dev_err(pchip->dev, "i2c failed to access register\n");
+	return bl->props.brightness;
+}
+
+static const struct backlight_ops lm3630_bank_b_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
+	.update_status = lm3630_bank_b_update_status,
+	.get_brightness = lm3630_bank_b_get_brightness,
+};
+
+static int lm3630_backlight_register(struct lm3630_chip_data *pchip,
+				     enum lm3630_leds ledno)
+{
+	const char *name = bled_name[ledno];
+	struct backlight_properties props;
+	struct lm3630_platform_data *pdata = pchip->pdata;
+
+	props.type = BACKLIGHT_RAW;
+	switch (ledno) {
+	case BLED_1:
+	case BLED_ALL:
+		props.brightness = pdata->init_brt_led1;
+		props.max_brightness = pdata->max_brt_led1;
+		pchip->bled1 =
+		    backlight_device_register(name, pchip->dev, pchip,
+					      &lm3630_bank_a_ops, &props);
+		if (IS_ERR(pchip->bled1))
+			return -EIO;
+		break;
+	case BLED_2:
+		props.brightness = pdata->init_brt_led2;
+		props.max_brightness = pdata->max_brt_led2;
+		pchip->bled2 =
+		    backlight_device_register(name, pchip->dev, pchip,
+					      &lm3630_bank_b_ops, &props);
+		if (IS_ERR(pchip->bled2))
+			return -EIO;
+		break;
+	}
+	return 0;
+}
+
+static void lm3630_backlight_unregister(struct lm3630_chip_data *pchip)
+{
+	if (pchip->bled1)
+		backlight_device_unregister(pchip->bled1);
+	if (pchip->bled2)
+		backlight_device_unregister(pchip->bled2);
+}
+
+static const struct regmap_config lm3630_regmap = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = REG_MAX,
+};
+
+static int __devinit lm3630_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
+{
+	struct lm3630_platform_data *pdata = client->dev.platform_data;
+	struct lm3630_chip_data *pchip;
+	int ret;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "fail : i2c functionality check...\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (pdata == NULL) {
+		dev_err(&client->dev, "fail : no platform data.\n");
+		return -ENODATA;
+	}
+
+	pchip = devm_kzalloc(&client->dev, sizeof(struct lm3630_chip_data),
+			     GFP_KERNEL);
+	if (!pchip)
+		return -ENOMEM;
+	pchip->pdata = pdata;
+	pchip->dev = &client->dev;
+
+	pchip->regmap = devm_regmap_init_i2c(client, &lm3630_regmap);
+	if (IS_ERR(pchip->regmap)) {
+		ret = PTR_ERR(pchip->regmap);
+		dev_err(&client->dev, "fail : allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+	i2c_set_clientdata(client, pchip);
+
+	/* chip initialize */
+	ret = lm3630_chip_init(pchip);
+	if (ret < 0) {
+		dev_err(&client->dev, "fail : init chip\n");
+		goto err_chip_init;
+	}
+
+	switch (pdata->bank_a_ctrl) {
+	case BANK_A_CTRL_ALL:
+		ret = lm3630_backlight_register(pchip, BLED_ALL);
+		pdata->bank_b_ctrl = BANK_B_CTRL_DISABLE;
+		break;
+	case BANK_A_CTRL_LED1:
+		ret = lm3630_backlight_register(pchip, BLED_1);
+		break;
+	case BANK_A_CTRL_LED2:
+		ret = lm3630_backlight_register(pchip, BLED_2);
+		pdata->bank_b_ctrl = BANK_B_CTRL_DISABLE;
+		break;
+	default:
+		break;
+	}
+
+	if (ret < 0)
+		goto err_bl_reg;
+
+	if (pdata->bank_b_ctrl && pchip->bled2 == NULL) {
+		ret = lm3630_backlight_register(pchip, BLED_2);
+		if (ret < 0)
+			goto err_bl_reg;
+	}
+
+	/* interrupt enable  : irq 0 is not allowed for lm3630 */
+	pchip->irq = client->irq;
+	if (pchip->irq)
+		lm3630_intr_config(pchip);
+
+	dev_info(&client->dev, "LM3630 backlight register OK.\n");
+	return 0;
+
+err_bl_reg:
+	dev_err(&client->dev, "fail : backlight register.\n");
+	lm3630_backlight_unregister(pchip);
+err_chip_init:
+	return ret;
+}
+
+static int __devexit lm3630_remove(struct i2c_client *client)
+{
+	int ret;
+	struct lm3630_chip_data *pchip = i2c_get_clientdata(client);
+
+	ret = regmap_write(pchip->regmap, REG_BRT_A, 0);
+	if (ret < 0)
+		dev_err(pchip->dev, "i2c failed to access register\n");
+
+	ret = regmap_write(pchip->regmap, REG_BRT_B, 0);
+	if (ret < 0)
+		dev_err(pchip->dev, "i2c failed to access register\n");
+
+	lm3630_backlight_unregister(pchip);
+	if (pchip->irq) {
+		free_irq(pchip->irq, pchip);
+		flush_workqueue(pchip->irqthread);
+		destroy_workqueue(pchip->irqthread);
+	}
+	return 0;
+}
+
+static const struct i2c_device_id lm3630_id[] = {
+	{LM3630_NAME, 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, lm3630_id);
+
+static struct i2c_driver lm3630_i2c_driver = {
+	.driver = {
+		   .name = LM3630_NAME,
+		   },
+	.probe = lm3630_probe,
+	.remove = __devexit_p(lm3630_remove),
+	.id_table = lm3630_id,
+};
+
+module_i2c_driver(lm3630_i2c_driver);
+
+MODULE_DESCRIPTION("Texas Instruments Backlight driver for LM3630");
+MODULE_AUTHOR("G.Shark Jeong <gshark.jeong@gmail.com>");
+MODULE_AUTHOR("Daniel Jeong <daniel.jeong@ti.com>");
+MODULE_LICENSE("GPL v2");
diff -puN /dev/null include/linux/platform_data/lm3630_bl.h
--- /dev/null
+++ a/include/linux/platform_data/lm3630_bl.h
@@ -0,0 +1,57 @@
+/*
+* Simple driver for Texas Instruments LM3630 LED Flash driver chip
+* Copyright (C) 2012 Texas Instruments
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+*/
+
+#ifndef __LINUX_LM3630_H
+#define __LINUX_LM3630_H
+
+#define LM3630_NAME "lm3630_bl"
+
+enum lm3630_pwm_ctrl {
+	PWM_CTRL_DISABLE = 0,
+	PWM_CTRL_BANK_A,
+	PWM_CTRL_BANK_B,
+	PWM_CTRL_BANK_ALL,
+};
+
+enum lm3630_pwm_active {
+	PWM_ACTIVE_HIGH = 0,
+	PWM_ACTIVE_LOW,
+};
+
+enum lm3630_bank_a_ctrl {
+	BANK_A_CTRL_DISABLE = 0x0,
+	BANK_A_CTRL_LED1 = 0x4,
+	BANK_A_CTRL_LED2 = 0x1,
+	BANK_A_CTRL_ALL = 0x5,
+};
+
+enum lm3630_bank_b_ctrl {
+	BANK_B_CTRL_DISABLE = 0,
+	BANK_B_CTRL_LED2,
+};
+
+struct lm3630_platform_data {
+
+	/* maximum brightness */
+	int max_brt_led1;
+	int max_brt_led2;
+
+	/* initial on brightness */
+	int init_brt_led1;
+	int init_brt_led2;
+	enum lm3630_pwm_ctrl pwm_ctrl;
+	enum lm3630_pwm_active pwm_active;
+	enum lm3630_bank_a_ctrl bank_a_ctrl;
+	enum lm3630_bank_b_ctrl bank_b_ctrl;
+	unsigned int pwm_period;
+	void (*pwm_set_intensity) (int brightness, int max_brightness);
+};
+
+#endif /* __LINUX_LM3630_H */
_

Patches currently in -mm which might be from gshark.jeong@gmail.com are

backlight-add-backlight-driver-for-lm3630-chip.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch

