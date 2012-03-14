From: akpm@linux-foundation.org
Subject: [merged] geos-platform-driver-for-geos-and-geos2-single-board-computers.patch removed from -mm tree
Date: Wed, 14 Mar 2012 14:24:30 -0700
Message-ID: <20120314212433.56D5DA076E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:58917 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757051Ab2CNVYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Mar 2012 17:24:38 -0400
Received: by laai8 with SMTP id i8so95996laa.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Mar 2012 14:24:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp@redfish-solutions.com, a.zummo@towertech.it, dilinger@queued.net, ed@wildgooses.com, mjg@redhat.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: geos: platform driver for Geos and Geos2 single-board computers
has been removed from the -mm tree.  Its filename was
     geos-platform-driver-for-geos-and-geos2-single-board-computers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Philip A. Prindeville" <philipp@redfish-solutions.com>
Subject: geos: platform driver for Geos and Geos2 single-board computers

Platform driver for Traverse Technologies Geos and Geos2 single-board
computers.  Uses SMBIOS to identify platform.  Based on progressive
revisions of the leds-net5501 driver that was rewritten by Ed Wildgoose as
a platform driver.

Supports GPIO-based LEDs (3) and 1 polled button which is typically used
for a soft reset.

Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>
Reviewed-by: Ed Wildgoose <ed@wildgooses.com>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                 |    7 +
 arch/x86/platform/geode/Makefile |    1 
 arch/x86/platform/geode/geos.c   |  128 +++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+)

diff -puN arch/x86/Kconfig~geos-platform-driver-for-geos-and-geos2-single-board-computers arch/x86/Kconfig
--- a/arch/x86/Kconfig~geos-platform-driver-for-geos-and-geos2-single-board-computers
+++ a/arch/x86/Kconfig
@@ -2157,6 +2157,13 @@ config NET5501
 	---help---
 	  This option enables system support for the Soekris Engineering net5501.
 
+config GEOS
+	bool "Traverse Technologies GEOS System Support (LEDS, GPIO, etc)"
+	select GPIOLIB
+	depends on DMI
+	---help---
+	  This option enables system support for the Traverse Technologies GEOS.
+
 endif # X86_32
 
 config AMD_NB
diff -puN arch/x86/platform/geode/Makefile~geos-platform-driver-for-geos-and-geos2-single-board-computers arch/x86/platform/geode/Makefile
--- a/arch/x86/platform/geode/Makefile~geos-platform-driver-for-geos-and-geos2-single-board-computers
+++ a/arch/x86/platform/geode/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_ALIX)		+= alix.o
+obj-$(CONFIG_GEOS)		+= geos.o
 obj-$(CONFIG_NET5501)		+= net5501.o
diff -puN /dev/null arch/x86/platform/geode/geos.c
--- /dev/null
+++ a/arch/x86/platform/geode/geos.c
@@ -0,0 +1,128 @@
+/*
+ * System Specific setup for Traverse Technologies GEOS.
+ * At the moment this means setup of GPIO control of LEDs.
+ *
+ * Copyright (C) 2008 Constantin Baranov <const@mimas.ru>
+ * Copyright (C) 2011 Ed Wildgoose <kernel@wildgooses.com>
+ *                and Philip Prindeville <philipp@redfish-solutions.com>
+ *
+ * TODO: There are large similarities with leds-net5501.c
+ * by Alessandro Zummo <a.zummo@towertech.it>
+ * In the future leds-net5501.c should be migrated over to platform
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include <linux/leds.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/input.h>
+#include <linux/gpio_keys.h>
+#include <linux/dmi.h>
+
+#include <asm/geode.h>
+
+static struct gpio_keys_button geos_gpio_buttons[] = {
+	{
+		.code = KEY_RESTART,
+		.gpio = 3,
+		.active_low = 1,
+		.desc = "Reset button",
+		.type = EV_KEY,
+		.wakeup = 0,
+		.debounce_interval = 100,
+		.can_disable = 0,
+	}
+};
+static struct gpio_keys_platform_data geos_buttons_data = {
+	.buttons = geos_gpio_buttons,
+	.nbuttons = ARRAY_SIZE(geos_gpio_buttons),
+	.poll_interval = 20,
+};
+
+static struct platform_device geos_buttons_dev = {
+	.name = "gpio-keys-polled",
+	.id = 1,
+	.dev = {
+		.platform_data = &geos_buttons_data,
+	}
+};
+
+static struct gpio_led geos_leds[] = {
+	{
+		.name = "geos:1",
+		.gpio = 6,
+		.default_trigger = "default-on",
+		.active_low = 1,
+	},
+	{
+		.name = "geos:2",
+		.gpio = 25,
+		.default_trigger = "default-off",
+		.active_low = 1,
+	},
+	{
+		.name = "geos:3",
+		.gpio = 27,
+		.default_trigger = "default-off",
+		.active_low = 1,
+	},
+};
+
+static struct gpio_led_platform_data geos_leds_data = {
+	.num_leds = ARRAY_SIZE(geos_leds),
+	.leds = geos_leds,
+};
+
+static struct platform_device geos_leds_dev = {
+	.name = "leds-gpio",
+	.id = -1,
+	.dev.platform_data = &geos_leds_data,
+};
+
+static struct __initdata platform_device *geos_devs[] = {
+	&geos_buttons_dev,
+	&geos_leds_dev,
+};
+
+static void __init register_geos(void)
+{
+	/* Setup LED control through leds-gpio driver */
+	platform_add_devices(geos_devs, ARRAY_SIZE(geos_devs));
+}
+
+static int __init geos_init(void)
+{
+	const char *vendor, *product;
+
+	if (!is_geode())
+		return 0;
+
+	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
+	if (!vendor || strcmp(vendor, "Traverse Technologies"))
+		return 0;
+
+	product = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!product || strcmp(product, "Geos"))
+		return 0;
+
+	printk(KERN_INFO "%s: system is recognized as \"%s %s\"\n",
+	       KBUILD_MODNAME, vendor, product);
+
+	register_geos();
+
+	return 0;
+}
+
+module_init(geos_init);
+
+MODULE_AUTHOR("Philip Prindeville <philipp@redfish-solutions.com>");
+MODULE_DESCRIPTION("Traverse Technologies Geos System Setup");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from philipp@redfish-solutions.com are

linux-next.patch

