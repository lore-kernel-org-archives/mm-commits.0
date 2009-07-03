From: akpm@linux-foundation.org
Subject: + mfd-gpio-add-a-gpio-interface-to-the-ucb1400-mfd-chip-driver-via-gpiolib.patch added to -mm tree
Date: Fri, 03 Jul 2009 13:11:10 -0700
Message-ID: <200907032011.n63KBAAg031976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756006AbZGCULY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jul 2009 16:11:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marek.vasut@gmail.com, david-b@pacbell.net, eric.y.miao@gmail.com, rmk@arm.linux.org.uk, sameo@openedhand.com


The patch titled
     mfd/gpio: add a GPIO interface to the UCB1400 MFD chip driver via gpiolib
has been added to the -mm tree.  Its filename is
     mfd-gpio-add-a-gpio-interface-to-the-ucb1400-mfd-chip-driver-via-gpiolib.patch

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
Subject: mfd/gpio: add a GPIO interface to the UCB1400 MFD chip driver via gpiolib
From: Marek Vasut <marek.vasut@gmail.com>

Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: David Brownell <david-b@pacbell.net>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig        |   12 +++
 drivers/gpio/Makefile       |    1 
 drivers/gpio/ucb1400_gpio.c |  125 ++++++++++++++++++++++++++++++++++
 drivers/mfd/ucb1400_core.c  |   31 +++++++-
 include/linux/ucb1400.h     |   19 +++++
 5 files changed, 184 insertions(+), 4 deletions(-)

diff -puN drivers/gpio/Kconfig~mfd-gpio-add-a-gpio-interface-to-the-ucb1400-mfd-chip-driver-via-gpiolib drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~mfd-gpio-add-a-gpio-interface-to-the-ucb1400-mfd-chip-driver-via-gpiolib
+++ a/drivers/gpio/Kconfig
@@ -195,4 +195,16 @@ config GPIO_MC33880
 	  SPI driver for Freescale MC33880 high-side/low-side switch.
 	  This provides GPIO interface supporting inputs and outputs.
 
+comment "AC97 GPIO expanders:"
+
+config GPIO_UCB1400
+	bool "Philips UCB1400 GPIO"
+	depends on UCB1400_CORE
+	help
+	  This enables support for the Philips UCB1400 GPIO pins.
+	  The UCB1400 is an AC97 audio codec.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ucb1400_gpio.
+
 endif
diff -puN drivers/gpio/Makefile~mfd-gpio-add-a-gpio-interface-to-the-ucb1400-mfd-chip-driver-via-gpiolib drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~mfd-gpio-add-a-gpio-interface-to-the-ucb1400-mfd-chip-driver-via-gpiolib
+++ a/drivers/gpio/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_PL061)	+= pl061.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
+obj-$(CONFIG_GPIO_UCB1400)	+= ucb1400_gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
 obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
diff -puN /dev/null drivers/gpio/ucb1400_gpio.c
--- /dev/null
+++ a/drivers/gpio/ucb1400_gpio.c
@@ -0,0 +1,125 @@
+/*
+ * Philips UCB1400 GPIO driver
+ *
+ * Author: Marek Vasut <marek.vasut@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/ucb1400.h>
+
+struct ucb1400_gpio_data *ucbdata;
+
+static int ucb1400_gpio_dir_in(struct gpio_chip *gc, unsigned off)
+{
+	struct ucb1400_gpio *gpio;
+	gpio = container_of(gc, struct ucb1400_gpio, gc);
+	ucb1400_gpio_set_direction(gpio->ac97, off, 0);
+	return 0;
+}
+
+static int ucb1400_gpio_dir_out(struct gpio_chip *gc, unsigned off, int val)
+{
+	struct ucb1400_gpio *gpio;
+	gpio = container_of(gc, struct ucb1400_gpio, gc);
+	ucb1400_gpio_set_direction(gpio->ac97, off, 1);
+	ucb1400_gpio_set_value(gpio->ac97, off, val);
+	return 0;
+}
+
+static int ucb1400_gpio_get(struct gpio_chip *gc, unsigned off)
+{
+	struct ucb1400_gpio *gpio;
+	gpio = container_of(gc, struct ucb1400_gpio, gc);
+	return ucb1400_gpio_get_value(gpio->ac97, off);
+}
+
+static void ucb1400_gpio_set(struct gpio_chip *gc, unsigned off, int val)
+{
+	struct ucb1400_gpio *gpio;
+	gpio = container_of(gc, struct ucb1400_gpio, gc);
+	ucb1400_gpio_set_value(gpio->ac97, off, val);
+}
+
+static int ucb1400_gpio_probe(struct platform_device *dev)
+{
+	struct ucb1400_gpio *ucb = dev->dev.platform_data;
+	int err = 0;
+
+	if (!(ucbdata && ucbdata->gpio_offset)) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	platform_set_drvdata(dev, ucb);
+
+	ucb->gc.label = "ucb1400_gpio";
+	ucb->gc.base = ucbdata->gpio_offset;
+	ucb->gc.ngpio = 10;
+	ucb->gc.owner = THIS_MODULE;
+
+	ucb->gc.direction_input = ucb1400_gpio_dir_in;
+	ucb->gc.direction_output = ucb1400_gpio_dir_out;
+	ucb->gc.get = ucb1400_gpio_get;
+	ucb->gc.set = ucb1400_gpio_set;
+	ucb->gc.can_sleep = 1;
+
+	err = gpiochip_add(&ucb->gc);
+	if (err)
+		goto err;
+
+	if (ucbdata && ucbdata->gpio_setup)
+		err = ucbdata->gpio_setup(&dev->dev, ucb->gc.ngpio);
+
+err:
+	return err;
+
+}
+
+static int ucb1400_gpio_remove(struct platform_device *dev)
+{
+	int err = 0;
+	struct ucb1400_gpio *ucb = platform_get_drvdata(dev);
+
+	if (ucbdata && ucbdata->gpio_teardown) {
+		err = ucbdata->gpio_teardown(&dev->dev, ucb->gc.ngpio);
+		if (err)
+			return err;
+	}
+
+	err = gpiochip_remove(&ucb->gc);
+	return err;
+}
+
+static struct platform_driver ucb1400_gpio_driver = {
+	.probe	= ucb1400_gpio_probe,
+	.remove	= ucb1400_gpio_remove,
+	.driver	= {
+		.name	= "ucb1400_gpio"
+	},
+};
+
+static int __init ucb1400_gpio_init(void)
+{
+	return platform_driver_register(&ucb1400_gpio_driver);
+}
+
+static void __exit ucb1400_gpio_exit(void)
+{
+	platform_driver_unregister(&ucb1400_gpio_driver);
+}
+
+void __init ucb1400_gpio_set_data(struct ucb1400_gpio_data *data)
+{
+	ucbdata = data;
+}
+
+module_init(ucb1400_gpio_init);
+module_exit(ucb1400_gpio_exit);
+
+MODULE_DESCRIPTION("Philips UCB1400 GPIO driver");
+MODULE_LICENSE("GPL");
diff -puN drivers/mfd/ucb1400_core.c~mfd-gpio-add-a-gpio-interface-to-the-ucb1400-mfd-chip-driver-via-gpiolib drivers/mfd/ucb1400_core.c
--- a/drivers/mfd/ucb1400_core.c~mfd-gpio-add-a-gpio-interface-to-the-ucb1400-mfd-chip-driver-via-gpiolib
+++ a/drivers/mfd/ucb1400_core.c
@@ -48,9 +48,11 @@ static int ucb1400_core_probe(struct dev
 	int err;
 	struct ucb1400 *ucb;
 	struct ucb1400_ts ucb_ts;
+	struct ucb1400_gpio ucb_gpio;
 	struct snd_ac97 *ac97;
 
 	memset(&ucb_ts, 0, sizeof(ucb_ts));
+	memset(&ucb_gpio, 0, sizeof(ucb_gpio));
 
 	ucb = kzalloc(sizeof(struct ucb1400), GFP_KERNEL);
 	if (!ucb) {
@@ -68,25 +70,44 @@ static int ucb1400_core_probe(struct dev
 		goto err0;
 	}
 
+	/* GPIO */
+	ucb_gpio.ac97 = ac97;
+	ucb->ucb1400_gpio = platform_device_alloc("ucb1400_gpio", -1);
+	if (!ucb->ucb1400_gpio) {
+		err = -ENOMEM;
+		goto err0;
+	}
+	err = platform_device_add_data(ucb->ucb1400_gpio, &ucb_gpio,
+					sizeof(ucb_gpio));
+	if (err)
+		goto err1;
+	err = platform_device_add(ucb->ucb1400_gpio);
+	if (err)
+		goto err1;
+
 	/* TOUCHSCREEN */
 	ucb_ts.ac97 = ac97;
 	ucb->ucb1400_ts = platform_device_alloc("ucb1400_ts", -1);
 	if (!ucb->ucb1400_ts) {
 		err = -ENOMEM;
-		goto err0;
+		goto err2;
 	}
 	err = platform_device_add_data(ucb->ucb1400_ts, &ucb_ts,
 					sizeof(ucb_ts));
 	if (err)
-		goto err1;
+		goto err3;
 	err = platform_device_add(ucb->ucb1400_ts);
 	if (err)
-		goto err1;
+		goto err3;
 
 	return 0;
 
-err1:
+err3:
 	platform_device_put(ucb->ucb1400_ts);
+err2:
+	platform_device_unregister(ucb->ucb1400_gpio);
+err1:
+	platform_device_put(ucb->ucb1400_gpio);
 err0:
 	kfree(ucb);
 err:
@@ -98,6 +119,8 @@ static int ucb1400_core_remove(struct de
 	struct ucb1400 *ucb = dev_get_drvdata(dev);
 
 	platform_device_unregister(ucb->ucb1400_ts);
+	platform_device_unregister(ucb->ucb1400_gpio);
+
 	kfree(ucb);
 	return 0;
 }
diff -puN include/linux/ucb1400.h~mfd-gpio-add-a-gpio-interface-to-the-ucb1400-mfd-chip-driver-via-gpiolib include/linux/ucb1400.h
--- a/include/linux/ucb1400.h~mfd-gpio-add-a-gpio-interface-to-the-ucb1400-mfd-chip-driver-via-gpiolib
+++ a/include/linux/ucb1400.h
@@ -26,6 +26,7 @@
 #include <sound/ac97_codec.h>
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
+#include <linux/gpio.h>
 
 /*
  * UCB1400 AC-link registers
@@ -78,6 +79,17 @@
 #define UCB_ID			0x7e
 #define UCB_ID_1400             0x4304
 
+struct ucb1400_gpio_data {
+	int gpio_offset;
+	int (*gpio_setup)(struct device *dev, int ngpio);
+	int (*gpio_teardown)(struct device *dev, int ngpio);
+};
+
+struct ucb1400_gpio {
+	struct gpio_chip	gc;
+	struct snd_ac97		*ac97;
+};
+
 struct ucb1400_ts {
 	struct input_dev	*ts_idev;
 	struct task_struct	*ts_task;
@@ -91,6 +103,7 @@ struct ucb1400_ts {
 
 struct ucb1400 {
 	struct platform_device	*ucb1400_ts;
+	struct platform_device	*ucb1400_gpio;
 };
 
 static inline u16 ucb1400_reg_read(struct snd_ac97 *ac97, u16 reg)
@@ -143,4 +156,10 @@ static inline void ucb1400_adc_disable(s
 unsigned int ucb1400_adc_read(struct snd_ac97 *ac97, u16 adc_channel,
 			      int adcsync);
 
+#ifdef CONFIG_GPIO_UCB1400
+void __init ucb1400_gpio_set_data(struct ucb1400_gpio_data *data);
+#else
+static inline void ucb1400_gpio_set_data(struct ucb1400_gpio_data *data) {}
+#endif
+
 #endif
_

Patches currently in -mm which might be from marek.vasut@gmail.com are

linux-next.patch
mfd-gpio-add-a-gpio-interface-to-the-ucb1400-mfd-chip-driver-via-gpiolib.patch

