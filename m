From: akpm@linux-foundation.org
Subject: [merged] leds-simple-driver-for-pwm-driven-leds.patch removed from -mm tree
Date: Wed, 18 Feb 2009 02:13:59 -0800
Message-ID: <200902181013.n1IADxfb006139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbZBRKOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 05:14:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: l.fu@pengutronix.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: simple driver for pwm driven LEDs
has been removed from the -mm tree.  Its filename was
     leds-simple-driver-for-pwm-driven-leds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: simple driver for pwm driven LEDs
From: Luotao Fu <l.fu@pengutronix.de>

Add a simple driver for pwm driver LEDs.  pwm_id and period can be defined
in board file.  It is developed for pxa, however it is probably generic
enough to be used on other platforms with pwm.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig     |    6 +
 drivers/leds/Makefile    |    1 
 drivers/leds/leds-pwm.c  |  153 +++++++++++++++++++++++++++++++++++++
 include/linux/leds_pwm.h |   21 +++++
 4 files changed, 181 insertions(+)

diff -puN drivers/leds/Kconfig~leds-simple-driver-for-pwm-driven-leds drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-simple-driver-for-pwm-driven-leds
+++ a/drivers/leds/Kconfig
@@ -197,6 +197,12 @@ config LEDS_DAC124S085
 	  This option enables support for DAC124S085 SPI DAC from NatSemi,
 	  which can be used to control up to four LEDs.
 
+config LEDS_PWM
+	tristate "PWM driven LED Support"
+	depends on LEDS_CLASS && HAVE_PWM
+	help
+	  This option enables support for pwm driven LEDs
+
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
diff -puN drivers/leds/Makefile~leds-simple-driver-for-pwm-driven-leds drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-simple-driver-for-pwm-driven-leds
+++ a/drivers/leds/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
+obj-$(CONFIG_LEDS_PWM)			+= leds-pwm.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff -puN /dev/null drivers/leds/leds-pwm.c
--- /dev/null
+++ a/drivers/leds/leds-pwm.c
@@ -0,0 +1,153 @@
+/*
+ * linux/drivers/leds-pwm.c
+ *
+ * simple PWM based LED control
+ *
+ * Copyright 2009 Luotao Fu @ Pengutronix (l.fu@pengutronix.de)
+ *
+ * based on leds-gpio.c by Raphael Assenat <raph@8d.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/fb.h>
+#include <linux/leds.h>
+#include <linux/err.h>
+#include <linux/pwm.h>
+#include <linux/leds_pwm.h>
+
+struct led_pwm_data {
+	struct led_classdev	cdev;
+	struct pwm_device	*pwm;
+	unsigned int 		active_low;
+	unsigned int		period;
+	unsigned int		max_brightness;
+};
+
+static void led_pwm_set(struct led_classdev *led_cdev,
+	enum led_brightness brightness)
+{
+	struct led_pwm_data *led_dat =
+		container_of(led_cdev, struct led_pwm_data, cdev);
+	unsigned int max = led_dat->max_brightness;
+	unsigned int period =  led_dat->period;
+
+	if (brightness == 0) {
+		pwm_config(led_dat->pwm, 0, period);
+		pwm_disable(led_dat->pwm);
+	} else {
+		pwm_config(led_dat->pwm, brightness * period / max, period);
+		pwm_enable(led_dat->pwm);
+	}
+}
+
+static int led_pwm_probe(struct platform_device *pdev)
+{
+	struct led_pwm_platform_data *pdata = pdev->dev.platform_data;
+	struct led_pwm *cur_led;
+	struct led_pwm_data *leds_data, *led_dat;
+	int i, ret = 0;
+
+	if (!pdata)
+		return -EBUSY;
+
+	leds_data = kzalloc(sizeof(struct led_pwm_data) * pdata->num_leds,
+				GFP_KERNEL);
+	if (!leds_data)
+		return -ENOMEM;
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		cur_led = &pdata->leds[i];
+		led_dat = &leds_data[i];
+
+		led_dat->pwm = pwm_request(cur_led->pwm_id,
+				cur_led->name);
+		if (IS_ERR(led_dat->pwm)) {
+			dev_err(&pdev->dev, "unable to request PWM %d\n",
+					cur_led->pwm_id);
+			goto err;
+		}
+
+		led_dat->cdev.name = cur_led->name;
+		led_dat->cdev.default_trigger = cur_led->default_trigger;
+		led_dat->active_low = cur_led->active_low;
+		led_dat->max_brightness = cur_led->max_brightness;
+		led_dat->period = cur_led->pwm_period_ns;
+		led_dat->cdev.brightness_set = led_pwm_set;
+		led_dat->cdev.brightness = LED_OFF;
+		led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
+
+		ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
+		if (ret < 0) {
+			pwm_free(led_dat->pwm);
+			goto err;
+		}
+	}
+
+	platform_set_drvdata(pdev, leds_data);
+
+	return 0;
+
+err:
+	if (i > 0) {
+		for (i = i - 1; i >= 0; i--) {
+			led_classdev_unregister(&leds_data[i].cdev);
+			pwm_free(leds_data[i].pwm);
+		}
+	}
+
+	kfree(leds_data);
+
+	return ret;
+}
+
+static int __devexit led_pwm_remove(struct platform_device *pdev)
+{
+	int i;
+	struct led_pwm_platform_data *pdata = pdev->dev.platform_data;
+	struct led_pwm_data *leds_data;
+
+	leds_data = platform_get_drvdata(pdev);
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		led_classdev_unregister(&leds_data[i].cdev);
+		pwm_free(leds_data[i].pwm);
+	}
+
+	kfree(leds_data);
+
+	return 0;
+}
+
+static struct platform_driver led_pwm_driver = {
+	.probe		= led_pwm_probe,
+	.remove		= __devexit_p(led_pwm_remove),
+	.driver		= {
+		.name	= "leds_pwm",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init led_pwm_init(void)
+{
+	return platform_driver_register(&led_pwm_driver);
+}
+
+static void __exit led_pwm_exit(void)
+{
+	platform_driver_unregister(&led_pwm_driver);
+}
+
+module_init(led_pwm_init);
+module_exit(led_pwm_exit);
+
+MODULE_AUTHOR("Luotao Fu <l.fu@pengutronix.de>");
+MODULE_DESCRIPTION("PWM LED driver for PXA");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-pwm");
diff -puN /dev/null include/linux/leds_pwm.h
--- /dev/null
+++ a/include/linux/leds_pwm.h
@@ -0,0 +1,21 @@
+/*
+ * PWM LED driver data - see drivers/leds/leds-pwm.c
+ */
+#ifndef __LINUX_LEDS_PWM_H
+#define __LINUX_LEDS_PWM_H
+
+struct led_pwm {
+	const char	*name;
+	const char	*default_trigger;
+	unsigned	pwm_id;
+	u8 		active_low;
+	unsigned 	max_brightness;
+	unsigned	pwm_period_ns;
+};
+
+struct led_pwm_platform_data {
+	int			num_leds;
+	struct led_pwm	*leds;
+};
+
+#endif
_

Patches currently in -mm which might be from l.fu@pengutronix.de are

linux-next.patch

