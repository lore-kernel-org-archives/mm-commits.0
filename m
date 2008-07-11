From: akpm@linux-foundation.org
Subject: + fbdev-lcd-backlight-driver-using-atmel-pwm-driver.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:42:39 -0700
Message-ID: <200807111848.m6BImK70031160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755063AbYGKSsk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:48:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hans-christian.egtvedt@atmel.com, hskinnemoen@atmel.com, krzysztof.h1@poczta.fm, rpurdie@rpsys.net


The patch titled
     fbdev: LCD backlight driver using Atmel PWM driver
has been added to the -mm tree.  Its filename is
     fbdev-lcd-backlight-driver-using-atmel-pwm-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: LCD backlight driver using Atmel PWM driver
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

This patch adds a platform driver using the ATMEL PWM driver to control a
backlight which requires a PWM signal and optional GPIO signal for discrete
on/off signal.  It has been tested on Favr-32 board from EarthLCD.

The driver is configurable by supplying a struct with the platform data.  See
the include/linux/atmel-pwm-bl.h for details.

The board code for Favr-32 will be submitted to the AVR32 kernel list.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig        |   12 +
 drivers/video/backlight/Makefile       |    1 
 drivers/video/backlight/atmel-pwm-bl.c |  244 +++++++++++++++++++++++
 include/linux/atmel-pwm-bl.h           |   43 ++++
 4 files changed, 300 insertions(+)

diff -puN drivers/video/backlight/Kconfig~fbdev-lcd-backlight-driver-using-atmel-pwm-driver drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~fbdev-lcd-backlight-driver-using-atmel-pwm-driver
+++ a/drivers/video/backlight/Kconfig
@@ -87,6 +87,18 @@ config BACKLIGHT_ATMEL_LCDC
 	  If in doubt, it's safe to enable this option; it doesn't kick
 	  in unless the board's description says it's wired that way.
 
+config BACKLIGHT_ATMEL_PWM
+	tristate "Atmel PWM backlight control"
+	depends on BACKLIGHT_CLASS_DEVICE && ATMEL_PWM
+	default n
+	help
+	  Say Y here if you want to use the PWM peripheral in Atmel AT91 and
+	  AVR32 devices. This driver will need additional platform data to know
+	  which PWM instance to use and how to configure it.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called atmel-pwm-bl.
+
 config BACKLIGHT_CORGI
 	tristate "Generic (aka Sharp Corgi) Backlight Driver"
 	depends on BACKLIGHT_CLASS_DEVICE
diff -puN drivers/video/backlight/Makefile~fbdev-lcd-backlight-driver-using-atmel-pwm-driver drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~fbdev-lcd-backlight-driver-using-atmel-pwm-driver
+++ a/drivers/video/backlight/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_LCD_PLATFORM)	   += platfor
 obj-$(CONFIG_LCD_VGG2432A4)	   += vgg2432a4.o
 
 obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += backlight.o
+obj-$(CONFIG_BACKLIGHT_ATMEL_PWM)    += atmel-pwm-bl.o
 obj-$(CONFIG_BACKLIGHT_CORGI)	+= corgi_bl.o
 obj-$(CONFIG_BACKLIGHT_HP680)	+= hp680_bl.o
 obj-$(CONFIG_BACKLIGHT_LOCOMO)	+= locomolcd.o
diff -puN /dev/null drivers/video/backlight/atmel-pwm-bl.c
--- /dev/null
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -0,0 +1,244 @@
+/*
+ * Copyright (C) 2008 Atmel Corporation
+ *
+ * Backlight driver using Atmel PWM peripheral.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/fb.h>
+#include <linux/clk.h>
+#include <linux/gpio.h>
+#include <linux/backlight.h>
+#include <linux/atmel_pwm.h>
+#include <linux/atmel-pwm-bl.h>
+
+struct atmel_pwm_bl {
+	const struct atmel_pwm_bl_platform_data	*pdata;
+	struct backlight_device			*bldev;
+	struct platform_device			*pdev;
+	struct pwm_channel			pwmc;
+	int					gpio_on;
+};
+
+static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
+{
+	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
+	int intensity = bd->props.brightness;
+	int pwm_duty;
+
+	if (bd->props.power != FB_BLANK_UNBLANK)
+		intensity = 0;
+	if (bd->props.fb_blank != FB_BLANK_UNBLANK)
+		intensity = 0;
+
+	if (pwmbl->pdata->pwm_active_low)
+		pwm_duty = pwmbl->pdata->pwm_duty_min + intensity;
+	else
+		pwm_duty = pwmbl->pdata->pwm_duty_max - intensity;
+
+	if (pwm_duty > pwmbl->pdata->pwm_duty_max)
+		pwm_duty = pwmbl->pdata->pwm_duty_max;
+	if (pwm_duty < pwmbl->pdata->pwm_duty_min)
+		pwm_duty = pwmbl->pdata->pwm_duty_min;
+
+	if (!intensity) {
+		if (pwmbl->gpio_on != -1) {
+			gpio_set_value(pwmbl->gpio_on,
+					0 ^ pwmbl->pdata->on_active_low);
+		}
+		pwm_channel_writel(&pwmbl->pwmc, PWM_CUPD, pwm_duty);
+		pwm_channel_disable(&pwmbl->pwmc);
+	} else {
+		pwm_channel_enable(&pwmbl->pwmc);
+		pwm_channel_writel(&pwmbl->pwmc, PWM_CUPD, pwm_duty);
+		if (pwmbl->gpio_on != -1) {
+			gpio_set_value(pwmbl->gpio_on,
+					1 ^ pwmbl->pdata->on_active_low);
+		}
+	}
+
+	return 0;
+}
+
+static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
+{
+	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
+	u8 intensity;
+
+	if (pwmbl->pdata->pwm_active_low) {
+		intensity = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
+			pwmbl->pdata->pwm_duty_min;
+	} else {
+		intensity = pwmbl->pdata->pwm_duty_max -
+			pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
+	}
+
+	return intensity;
+}
+
+static int atmel_pwm_bl_init_pwm(struct atmel_pwm_bl *pwmbl)
+{
+	unsigned long pwm_rate = pwmbl->pwmc.mck;
+	unsigned long prescale = DIV_ROUND_UP(pwm_rate,
+			(pwmbl->pdata->pwm_frequency *
+			 pwmbl->pdata->pwm_compare_max)) - 1;
+
+	/*
+	 * Prescale must be power of two and maximum 0xf in size because of
+	 * hardware limit. PWM speed will be:
+	 *	PWM module clock speed / (2 ^ prescale).
+	 */
+	prescale = fls(prescale);
+	if (prescale > 0xf)
+		prescale = 0xf;
+
+	pwm_channel_writel(&pwmbl->pwmc, PWM_CMR, prescale);
+	pwm_channel_writel(&pwmbl->pwmc, PWM_CDTY,
+			pwmbl->pdata->pwm_duty_min +
+			pwmbl->bldev->props.brightness);
+	pwm_channel_writel(&pwmbl->pwmc, PWM_CPRD,
+			pwmbl->pdata->pwm_compare_max);
+
+	dev_info(&pwmbl->pdev->dev, "Atmel PWM backlight driver "
+			"(%lu Hz)\n", pwmbl->pwmc.mck /
+			pwmbl->pdata->pwm_compare_max /
+			(1 << prescale));
+
+	return pwm_channel_enable(&pwmbl->pwmc);
+}
+
+static struct backlight_ops atmel_pwm_bl_ops = {
+	.get_brightness = atmel_pwm_bl_get_intensity,
+	.update_status  = atmel_pwm_bl_set_intensity,
+};
+
+static int atmel_pwm_bl_probe(struct platform_device *pdev)
+{
+	const struct atmel_pwm_bl_platform_data *pdata;
+	struct backlight_device *bldev;
+	struct atmel_pwm_bl *pwmbl;
+	int retval;
+
+	pwmbl = kzalloc(sizeof(struct atmel_pwm_bl), GFP_KERNEL);
+	if (!pwmbl)
+		return -ENOMEM;
+
+	pwmbl->pdev = pdev;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		retval = -ENODEV;
+		goto err_free_mem;
+	}
+
+	if (pdata->pwm_compare_max < pdata->pwm_duty_max ||
+			pdata->pwm_duty_min > pdata->pwm_duty_max ||
+			pdata->pwm_frequency == 0) {
+		retval = -EINVAL;
+		goto err_free_mem;
+	}
+
+	pwmbl->pdata = pdata;
+	pwmbl->gpio_on = pdata->gpio_on;
+
+	retval = pwm_channel_alloc(pdata->pwm_channel, &pwmbl->pwmc);
+	if (retval)
+		goto err_free_mem;
+
+	if (pwmbl->gpio_on != -1) {
+		retval = gpio_request(pwmbl->gpio_on, "gpio_atmel_pwm_bl");
+		if (retval) {
+			pwmbl->gpio_on = -1;
+			goto err_free_pwm;
+		}
+
+		/* Turn display off by defatult. */
+		retval = gpio_direction_output(pwmbl->gpio_on,
+				0 ^ pdata->on_active_low);
+		if (retval)
+			goto err_free_gpio;
+	}
+
+	bldev = backlight_device_register("atmel-pwm-bl",
+			&pdev->dev, pwmbl, &atmel_pwm_bl_ops);
+	if (IS_ERR(bldev)) {
+		retval = PTR_ERR(bldev);
+		goto err_free_gpio;
+	}
+
+	pwmbl->bldev = bldev;
+
+	platform_set_drvdata(pdev, pwmbl);
+
+	/* Power up the backlight by default at middle intesity. */
+	bldev->props.power = FB_BLANK_UNBLANK;
+	bldev->props.max_brightness = pdata->pwm_duty_max - pdata->pwm_duty_min;
+	bldev->props.brightness = bldev->props.max_brightness / 2;
+
+	retval = atmel_pwm_bl_init_pwm(pwmbl);
+	if (retval)
+		goto err_free_bl_dev;
+
+	atmel_pwm_bl_set_intensity(bldev);
+
+	return 0;
+
+err_free_bl_dev:
+	platform_set_drvdata(pdev, NULL);
+	backlight_device_unregister(bldev);
+err_free_gpio:
+	if (pwmbl->gpio_on != -1)
+		gpio_free(pwmbl->gpio_on);
+err_free_pwm:
+	pwm_channel_free(&pwmbl->pwmc);
+err_free_mem:
+	kfree(pwmbl);
+	return retval;
+}
+
+static int __exit atmel_pwm_bl_remove(struct platform_device *pdev)
+{
+	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
+
+	if (pwmbl->gpio_on != -1) {
+		gpio_set_value(pwmbl->gpio_on, 0);
+		gpio_free(pwmbl->gpio_on);
+	}
+	pwm_channel_disable(&pwmbl->pwmc);
+	pwm_channel_free(&pwmbl->pwmc);
+	backlight_device_unregister(pwmbl->bldev);
+	platform_set_drvdata(pdev, NULL);
+	kfree(pwmbl);
+
+	return 0;
+}
+
+static struct platform_driver atmel_pwm_bl_driver = {
+	.driver = {
+		.name = "atmel-pwm-bl",
+	},
+	/* REVISIT add suspend() and resume() */
+	.remove = __exit_p(atmel_pwm_bl_remove),
+};
+
+static int __init atmel_pwm_bl_init(void)
+{
+	return platform_driver_probe(&atmel_pwm_bl_driver, atmel_pwm_bl_probe);
+}
+module_init(atmel_pwm_bl_init);
+
+static void __exit atmel_pwm_bl_exit(void)
+{
+	platform_driver_unregister(&atmel_pwm_bl_driver);
+}
+module_exit(atmel_pwm_bl_exit);
+
+MODULE_AUTHOR("Hans-Christian egtvedt <hans-christian.egtvedt@atmel.com>");
+MODULE_DESCRIPTION("Atmel PWM backlight driver");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/atmel-pwm-bl.h
--- /dev/null
+++ a/include/linux/atmel-pwm-bl.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (C) 2007 Atmel Corporation
+ *
+ * Driver for the AT32AP700X PS/2 controller (PSIF).
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#ifndef __INCLUDE_ATMEL_PWM_BL_H
+#define __INCLUDE_ATMEL_PWM_BL_H
+
+/**
+ * struct atmel_pwm_bl_platform_data
+ * @pwm_channel: which PWM channel in the PWM module to use.
+ * @pwm_frequency: PWM frequency to generate, the driver will try to be as
+ *	close as the prescaler allows.
+ * @pwm_compare_max: value to use in the PWM channel compare register.
+ * @pwm_duty_max: maximum duty cycle value, must be less than or equal to
+ *	pwm_compare_max.
+ * @pwm_duty_min: minimum duty cycle value, must be less than pwm_duty_max.
+ * @pwm_active_low: set to one if the low part of the PWM signal increases the
+ *	brightness of the backlight.
+ * @gpio_on: GPIO line to control the backlight on/off, set to -1 if not used.
+ * @on_active_low: set to one if the on/off signal is on when GPIO is low.
+ *
+ * This struct must be added to the platform device in the board code. It is
+ * used by the atmel-pwm-bl driver to setup the GPIO to control on/off and the
+ * PWM device.
+ */
+struct atmel_pwm_bl_platform_data {
+	unsigned int pwm_channel;
+	unsigned int pwm_frequency;
+	unsigned int pwm_compare_max;
+	unsigned int pwm_duty_max;
+	unsigned int pwm_duty_min;
+	unsigned int pwm_active_low;
+	int gpio_on;
+	unsigned int on_active_low;
+};
+
+#endif /* __INCLUDE_ATMEL_PWM_BL_H */
_

Patches currently in -mm which might be from hans-christian.egtvedt@atmel.com are

linux-next.patch
atmel_pwm-set-up-only-one-pwm-clock-when-allocating-a-clock.patch
fbdev-lcd-backlight-driver-using-atmel-pwm-driver.patch

