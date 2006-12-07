From: akpm@osdl.org
Subject: - pcengines-wrap-led-support.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:36 -0800
Message-ID: <200612072304.kB7N4aWG030070@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52209 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163665AbWLGXEz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kris@krisk.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     PCEngines WRAP LED Support
has been removed from the -mm tree.  Its filename was
     pcengines-wrap-led-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PCEngines WRAP LED Support
From: Kristian Kielhofner <kris@krisk.org>

A driver for the PCEngines WRAP boards (http://www.pcengines.ch), which are
very similar to the Soekris net4801 (same NS SC1100 geode reference
design).

The LEDs on the WRAP are on different GPIO lines and I have modified and
copied the net48xx error led support for this.  It also includes support
for an "extra" led (in addition to error).  The three LEDs on the WRAP are
at GPIO lines 2,3,18 (WRAP LEDs from left to right).  This driver gives
access to the second and third LEDs by twiddling GPIO lines 3 & 18.

Because these boards are so similar to the net48xx, I basically sed-ed that
driver to form the basis for leds-wrap.c.  The only changes from
leds-net48xx.c are:

- #define WRAP_EXTRA_LED_GPIO

- name changes

- duplicate relevant sections to provide support for the "extra" led

- reverse the various *_led_set values.  The WRAP is "backwards" from the
  net48xx, and these needed to be updated for that.

[akpm@osdl.org: build fix]
Signed-off-by: Kristian Kielhofner <kris@krisk.org>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/leds/Kconfig     |    6 +
 drivers/leds/Makefile    |    1 
 drivers/leds/leds-wrap.c |  142 +++++++++++++++++++++++++++++++++++++
 3 files changed, 149 insertions(+)

diff -puN drivers/leds/Kconfig~pcengines-wrap-led-support drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~pcengines-wrap-led-support
+++ a/drivers/leds/Kconfig
@@ -76,6 +76,12 @@ config LEDS_NET48XX
 	  This option enables support for the Soekris net4801 and net4826 error
 	  LED.
 
+config LEDS_WRAP
+	tristate "LED Support for the WRAP series LEDs"
+	depends on LEDS_CLASS && SCx200_GPIO
+	help
+	  This option enables support for the PCEngines WRAP programmable LEDs.
+
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
diff -puN drivers/leds/Makefile~pcengines-wrap-led-support drivers/leds/Makefile
--- a/drivers/leds/Makefile~pcengines-wrap-led-support
+++ a/drivers/leds/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_LEDS_TOSA)			+= leds-tosa.o
 obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c24xx.o
 obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
+obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
diff -puN /dev/null drivers/leds/leds-wrap.c
--- /dev/null
+++ a/drivers/leds/leds-wrap.c
@@ -0,0 +1,142 @@
+/*
+ * LEDs driver for PCEngines WRAP
+ *
+ * Copyright (C) 2006 Kristian Kielhofner <kris@krisk.org>
+ *
+ * Based on leds-net48xx.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/err.h>
+#include <asm/io.h>
+#include <linux/scx200_gpio.h>
+
+#define DRVNAME "wrap-led"
+#define WRAP_ERROR_LED_GPIO	3
+#define	WRAP_EXTRA_LED_GPIO	18
+
+static struct platform_device *pdev;
+
+static void wrap_error_led_set(struct led_classdev *led_cdev,
+		enum led_brightness value)
+{
+	if (value)
+		scx200_gpio_set_low(WRAP_ERROR_LED_GPIO);
+	else
+		scx200_gpio_set_high(WRAP_ERROR_LED_GPIO);
+}
+
+static void wrap_extra_led_set(struct led_classdev *led_cdev,
+		enum led_brightness value)
+{
+	if (value)
+		scx200_gpio_set_low(WRAP_EXTRA_LED_GPIO);
+	else
+		scx200_gpio_set_high(WRAP_EXTRA_LED_GPIO);
+}
+
+static struct led_classdev wrap_error_led = {
+	.name		= "wrap:error",
+	.brightness_set	= wrap_error_led_set,
+};
+
+static struct led_classdev wrap_extra_led = {
+	.name           = "wrap:extra",
+	.brightness_set = wrap_extra_led_set,
+};
+
+#ifdef CONFIG_PM
+static int wrap_led_suspend(struct platform_device *dev,
+		pm_message_t state)
+{
+	led_classdev_suspend(&wrap_error_led);
+	led_classdev_suspend(&wrap_extra_led);
+	return 0;
+}
+
+static int wrap_led_resume(struct platform_device *dev)
+{
+	led_classdev_resume(&wrap_error_led);
+	led_classdev_resume(&wrap_extra_led);
+	return 0;
+}
+#else
+#define wrap_led_suspend NULL
+#define wrap_led_resume NULL
+#endif
+
+static int wrap_led_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	ret = led_classdev_register(&pdev->dev, &wrap_error_led);
+	if (ret == 0) {
+		ret = led_classdev_register(&pdev->dev, &wrap_extra_led);
+		if (ret < 0)
+			led_classdev_unregister(&wrap_error_led);
+	}
+	return ret;
+}
+
+static int wrap_led_remove(struct platform_device *pdev)
+{
+	led_classdev_unregister(&wrap_error_led);
+	led_classdev_unregister(&wrap_extra_led);
+	return 0;
+}
+
+static struct platform_driver wrap_led_driver = {
+	.probe		= wrap_led_probe,
+	.remove		= wrap_led_remove,
+	.suspend	= wrap_led_suspend,
+	.resume		= wrap_led_resume,
+	.driver		= {
+		.name		= DRVNAME,
+		.owner		= THIS_MODULE,
+	},
+};
+
+static int __init wrap_led_init(void)
+{
+	int ret;
+
+	if (!scx200_gpio_present()) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = platform_driver_register(&wrap_led_driver);
+	if (ret < 0)
+		goto out;
+
+	pdev = platform_device_register_simple(DRVNAME, -1, NULL, 0);
+	if (IS_ERR(pdev)) {
+		ret = PTR_ERR(pdev);
+		platform_driver_unregister(&wrap_led_driver);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static void __exit wrap_led_exit(void)
+{
+	platform_device_unregister(pdev);
+	platform_driver_unregister(&wrap_led_driver);
+}
+
+module_init(wrap_led_init);
+module_exit(wrap_led_exit);
+
+MODULE_AUTHOR("Kristian Kielhofner <kris@krisk.org>");
+MODULE_DESCRIPTION("PCEngines WRAP LED driver");
+MODULE_LICENSE("GPL");
+
_

Patches currently in -mm which might be from kris@krisk.org are

origin.patch

