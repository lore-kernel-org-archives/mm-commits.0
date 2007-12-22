From: akpm@linux-foundation.org
Subject: + w1-gpio-add-gpio-w1-bus-master-driver.patch added to -mm tree
Date: Fri, 21 Dec 2007 16:28:32 -0800
Message-ID: <200712220028.lBM0SW3h006668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36694 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbXLVAjt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 19:39:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, david-b@pacbell.net, johnpol@2ka.mipt.ru


The patch titled
     w1-gpio: add GPIO w1 bus master driver
has been added to the -mm tree.  Its filename is
     w1-gpio-add-gpio-w1-bus-master-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1-gpio: add GPIO w1 bus master driver
From: Ville Syrjala <syrjala@sci.fi>

Add a GPIO 1-wire bus master driver.  The driver used the GPIO API to
control the wire and the GPIO pin can be specified using platform data
similar to i2c-gpio.  The driver was tested with AT91SAM9260 + DS2401.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/w1/masters/00-INDEX |    2 
 Documentation/w1/masters/w1-gpio  |   33 +++++++
 drivers/w1/masters/Kconfig        |   10 ++
 drivers/w1/masters/Makefile       |    1 
 drivers/w1/masters/w1-gpio.c      |  125 ++++++++++++++++++++++++++++
 include/linux/w1-gpio.h           |   23 +++++
 6 files changed, 194 insertions(+)

diff -puN Documentation/w1/masters/00-INDEX~w1-gpio-add-gpio-w1-bus-master-driver Documentation/w1/masters/00-INDEX
--- a/Documentation/w1/masters/00-INDEX~w1-gpio-add-gpio-w1-bus-master-driver
+++ a/Documentation/w1/masters/00-INDEX
@@ -4,3 +4,5 @@ ds2482
 	- The Maxim/Dallas Semiconductor DS2482 provides 1-wire busses.
 ds2490
 	- The Maxim/Dallas Semiconductor DS2490 builds USB <-> W1 bridges.
+w1-gpio
+	- GPIO 1-wire bus master driver.
diff -puN /dev/null Documentation/w1/masters/w1-gpio
--- /dev/null
+++ a/Documentation/w1/masters/w1-gpio
@@ -0,0 +1,33 @@
+Kernel driver w1-gpio
+=====================
+
+Author: Ville Syrjala <syrjala@sci.fi>
+
+
+Description
+-----------
+
+GPIO 1-wire bus master driver. The driver uses the GPIO API to control the
+wire and the GPIO pin can be specified using platform data.
+
+
+Example (mach-at91)
+-------------------
+
+#include <linux/w1-gpio.h>
+
+static struct w1_gpio_platform_data foo_w1_gpio_pdata = {
+	.pin		= AT91_PIN_PB20,
+	.is_open_drain	= 1,
+};
+
+static struct platform_device foo_w1_device = {
+	.name			= "w1-gpio",
+	.id			= -1,
+	.dev.platform_data	= &foo_w1_gpio_pdata,
+};
+
+...
+	at91_set_GPIO_periph(foo_w1_gpio_pdata.pin, 1);
+	at91_set_multi_drive(foo_w1_gpio_pdata.pin, 1);
+	platform_device_register(&foo_w1_device);
diff -puN drivers/w1/masters/Kconfig~w1-gpio-add-gpio-w1-bus-master-driver drivers/w1/masters/Kconfig
--- a/drivers/w1/masters/Kconfig~w1-gpio-add-gpio-w1-bus-master-driver
+++ a/drivers/w1/masters/Kconfig
@@ -42,5 +42,15 @@ config W1_MASTER_DS1WM
 	  in HP iPAQ devices like h5xxx, h2200, and ASIC3-based like
 	  hx4700.
 
+config W1_MASTER_GPIO
+	tristate "GPIO 1-wire busmaster"
+	depends on GENERIC_GPIO
+	help
+	  Say Y here if you want to communicate with your 1-wire devices using
+	  GPIO pins. This driver uses the GPIO API to control the wire.
+
+	  This support is also available as a module.  If so, the module
+	  will be called w1-gpio.ko.
+
 endmenu
 
diff -puN drivers/w1/masters/Makefile~w1-gpio-add-gpio-w1-bus-master-driver drivers/w1/masters/Makefile
--- a/drivers/w1/masters/Makefile~w1-gpio-add-gpio-w1-bus-master-driver
+++ a/drivers/w1/masters/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_W1_MASTER_MATROX)		+= matro
 obj-$(CONFIG_W1_MASTER_DS2490)		+= ds2490.o
 obj-$(CONFIG_W1_MASTER_DS2482)		+= ds2482.o
 obj-$(CONFIG_W1_MASTER_DS1WM)		+= ds1wm.o
+obj-$(CONFIG_W1_MASTER_GPIO)		+= w1-gpio.o
diff -puN /dev/null drivers/w1/masters/w1-gpio.c
--- /dev/null
+++ a/drivers/w1/masters/w1-gpio.c
@@ -0,0 +1,125 @@
+/*
+ * w1-gpio - GPIO w1 bus master driver
+ *
+ * Copyright (C) 2007 Ville Syrjala <syrjala@sci.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/w1-gpio.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+
+#include <asm/gpio.h>
+
+static void w1_gpio_write_bit_dir(void *data, u8 bit)
+{
+	struct w1_gpio_platform_data *pdata = data;
+
+	if (bit)
+		gpio_direction_input(pdata->pin);
+	else
+		gpio_direction_output(pdata->pin, 0);
+}
+
+static void w1_gpio_write_bit_val(void *data, u8 bit)
+{
+	struct w1_gpio_platform_data *pdata = data;
+
+	gpio_set_value(pdata->pin, bit);
+}
+
+static u8 w1_gpio_read_bit(void *data)
+{
+	struct w1_gpio_platform_data *pdata = data;
+
+	return gpio_get_value(pdata->pin);
+}
+
+static int __init w1_gpio_probe(struct platform_device *pdev)
+{
+	struct w1_bus_master *master;
+	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	int err;
+
+	if (!pdata)
+		return -ENXIO;
+
+	master = kzalloc(sizeof(struct w1_bus_master), GFP_KERNEL);
+	if (!master)
+		return -ENOMEM;
+
+	err = gpio_request(pdata->pin, "w1");
+	if (err)
+		goto free_master;
+
+	master->data = pdata;
+	master->read_bit = &w1_gpio_read_bit;
+
+	if (pdata->is_open_drain) {
+		gpio_direction_output(pdata->pin, 1);
+		master->write_bit = &w1_gpio_write_bit_val;
+	} else {
+		gpio_direction_input(pdata->pin);
+		master->write_bit = &w1_gpio_write_bit_dir;
+	}
+
+	err = w1_add_master_device(master);
+	if (err)
+		goto free_gpio;
+
+	platform_set_drvdata(pdev, master);
+
+	return 0;
+
+ free_gpio:
+	gpio_free(pdata->pin);
+ free_master:
+	kfree(master);
+
+	return err;
+}
+
+static int __exit w1_gpio_remove(struct platform_device *pdev)
+{
+	struct w1_bus_master *master = platform_get_drvdata(pdev);
+	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+
+	w1_remove_master_device(master);
+	gpio_free(pdata->pin);
+	kfree(master);
+
+	return 0;
+}
+
+static struct platform_driver w1_gpio_driver = {
+	.driver = {
+		.name	= "w1-gpio",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= w1_gpio_probe,
+	.remove	= __exit_p(w1_gpio_remove),
+};
+
+static int __init w1_gpio_init(void)
+{
+	return platform_driver_register(&w1_gpio_driver);
+}
+
+static void __exit w1_gpio_exit(void)
+{
+	platform_driver_unregister(&w1_gpio_driver);
+}
+
+module_init(w1_gpio_init);
+module_exit(w1_gpio_exit);
+
+MODULE_DESCRIPTION("GPIO w1 bus master driver");
+MODULE_AUTHOR("Ville Syrjala <syrjala@sci.fi>");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/w1-gpio.h
--- /dev/null
+++ a/include/linux/w1-gpio.h
@@ -0,0 +1,23 @@
+/*
+ * w1-gpio interface to platform code
+ *
+ * Copyright (C) 2007 Ville Syrjala <syrjala@sci.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ */
+#ifndef _LINUX_W1_GPIO_H
+#define _LINUX_W1_GPIO_H
+
+/**
+ * struct w1_gpio_platform_data - Platform-dependent data for w1-gpio
+ * @pin: GPIO pin to use
+ * @is_open_drain: GPIO pin is configured as open drain
+ */
+struct w1_gpio_platform_data {
+	unsigned int pin;
+	unsigned int is_open_drain:1;
+};
+
+#endif /* _LINUX_W1_GPIO_H */
_

Patches currently in -mm which might be from syrjala@sci.fi are

git-alsa.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
