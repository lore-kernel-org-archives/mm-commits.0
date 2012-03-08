From: akpm@linux-foundation.org
Subject: [merged] net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:35 -0800
Message-ID: <20120308191735.8A2BAA06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:49291 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758316Ab2CHTRi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:38 -0500
Received: by laai8 with SMTP id i8so29469laa.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp@redfish-solutions.com, a.zummo@towertech.it, dilinger@queued.net, hpa@zytor.com, mingo@elte.hu, mjg@redhat.com, rpurdie@rpsys.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: net5501: platform driver for Soekris Engineering net5501 single-board computer
has been removed from the -mm tree.  Its filename was
     net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Philip Prindeville <philipp@redfish-solutions.com>
Subject: x86: net5501: platform driver for Soekris Engineering net5501 single-board computer

Platform driver for Soekris Engineering net5501 single-board computer. 
Probes well-known locations in ROM for BIOS signature to confirm correct
platform.  Registers 1 LED and 1 GPIO-based button (typically used for
soft reset).

[akpm@linux-foundation.org: remove Kconfig and Makefile detritus from drivers/leds/]
Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Andres Salomon <dilinger@queued.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                  |    6 +
 arch/x86/platform/geode/Makefile  |    1 
 arch/x86/platform/geode/net5501.c |  154 ++++++++++++++++++++++++++++
 drivers/leds/Kconfig              |   10 -
 drivers/leds/Makefile             |    1 
 drivers/leds/leds-net5501.c       |   97 -----------------
 6 files changed, 161 insertions(+), 108 deletions(-)

diff -puN arch/x86/Kconfig~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer arch/x86/Kconfig
--- a/arch/x86/Kconfig~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer
+++ a/arch/x86/Kconfig
@@ -2158,6 +2158,12 @@ config GEOS
 	---help---
 	  This option enables system support for the Traverse Technologies GEOS.
 
+config NET5501
+	bool "Soekris Engineering net5501 System Support (LEDS, GPIO, etc)"
+	select GPIOLIB
+	---help---
+	  This option enables system support for the Soekris Engineering net5501.
+
 endif # X86_32
 
 config AMD_NB
diff -puN arch/x86/platform/geode/Makefile~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer arch/x86/platform/geode/Makefile
--- a/arch/x86/platform/geode/Makefile~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer
+++ a/arch/x86/platform/geode/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_ALIX)		+= alix.o
+obj-$(CONFIG_NET5501)		+= net5501.o
 obj-$(CONFIG_GEOS)		+= geos.o
diff -puN /dev/null arch/x86/platform/geode/net5501.c
--- /dev/null
+++ a/arch/x86/platform/geode/net5501.c
@@ -0,0 +1,154 @@
+/*
+ * System Specific setup for Soekris net5501
+ * At the moment this means setup of GPIO control of LEDs and buttons
+ * on net5501 boards.
+ *
+ *
+ * Copyright (C) 2008-2009 Tower Technologies
+ * Written by Alessandro Zummo <a.zummo@towertech.it>
+ *
+ * Copyright (C) 2008 Constantin Baranov <const@mimas.ru>
+ * Copyright (C) 2011 Ed Wildgoose <kernel@wildgooses.com>
+ *                and Philip Prindeville <philipp@redfish-solutions.com>
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
+
+#include <asm/geode.h>
+
+#define BIOS_REGION_BASE		0xffff0000
+#define BIOS_REGION_SIZE		0x00010000
+
+static struct gpio_keys_button net5501_gpio_buttons[] = {
+	{
+		.code = KEY_RESTART,
+		.gpio = 24,
+		.active_low = 1,
+		.desc = "Reset button",
+		.type = EV_KEY,
+		.wakeup = 0,
+		.debounce_interval = 100,
+		.can_disable = 0,
+	}
+};
+static struct gpio_keys_platform_data net5501_buttons_data = {
+	.buttons = net5501_gpio_buttons,
+	.nbuttons = ARRAY_SIZE(net5501_gpio_buttons),
+	.poll_interval = 20,
+};
+
+static struct platform_device net5501_buttons_dev = {
+	.name = "gpio-keys-polled",
+	.id = 1,
+	.dev = {
+		.platform_data = &net5501_buttons_data,
+	}
+};
+
+static struct gpio_led net5501_leds[] = {
+	{
+		.name = "net5501:1",
+		.gpio = 6,
+		.default_trigger = "default-on",
+		.active_low = 1,
+	},
+};
+
+static struct gpio_led_platform_data net5501_leds_data = {
+	.num_leds = ARRAY_SIZE(net5501_leds),
+	.leds = net5501_leds,
+};
+
+static struct platform_device net5501_leds_dev = {
+	.name = "leds-gpio",
+	.id = -1,
+	.dev.platform_data = &net5501_leds_data,
+};
+
+static struct __initdata platform_device *net5501_devs[] = {
+	&net5501_buttons_dev,
+	&net5501_leds_dev,
+};
+
+static void __init register_net5501(void)
+{
+	/* Setup LED control through leds-gpio driver */
+	platform_add_devices(net5501_devs, ARRAY_SIZE(net5501_devs));
+}
+
+struct net5501_board {
+	u16	offset;
+	u16	len;
+	char	*sig;
+};
+
+static struct net5501_board __initdata boards[] = {
+	{ 0xb7b, 7, "net5501" },	/* net5501 v1.33/1.33c */
+	{ 0xb1f, 7, "net5501" },	/* net5501 v1.32i */
+};
+
+static bool __init net5501_present(void)
+{
+	int i;
+	unsigned char *rombase, *bios;
+	bool found = false;
+
+	rombase = ioremap(BIOS_REGION_BASE, BIOS_REGION_SIZE - 1);
+	if (!rombase) {
+		printk(KERN_ERR "%s: failed to get rombase\n", KBUILD_MODNAME);
+		return found;
+	}
+
+	bios = rombase + 0x20;	/* null terminated */
+
+	if (memcmp(bios, "comBIOS", 7))
+		goto unmap;
+
+	for (i = 0; i < ARRAY_SIZE(boards); i++) {
+		unsigned char *model = rombase + boards[i].offset;
+
+		if (!memcmp(model, boards[i].sig, boards[i].len)) {
+			printk(KERN_INFO "%s: system is recognized as \"%s\"\n",
+			       KBUILD_MODNAME, model);
+
+			found = true;
+			break;
+		}
+	}
+
+unmap:
+	iounmap(rombase);
+	return found;
+}
+
+static int __init net5501_init(void)
+{
+	if (!is_geode())
+		return 0;
+
+	if (!net5501_present())
+		return 0;
+
+	register_net5501();
+
+	return 0;
+}
+
+module_init(net5501_init);
+
+MODULE_AUTHOR("Philip Prindeville <philipp@redfish-solutions.com>");
+MODULE_DESCRIPTION("Soekris net5501 System Setup");
+MODULE_LICENSE("GPL");
diff -puN drivers/leds/Kconfig~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer
+++ a/drivers/leds/Kconfig
@@ -82,16 +82,6 @@ config LEDS_NET48XX
 	  This option enables support for the Soekris net4801 and net4826 error
 	  LED.
 
-config LEDS_NET5501
-	tristate "LED Support for Soekris net5501 series Error LED"
-	depends on LEDS_TRIGGERS
-	depends on X86 && GPIO_CS5535
-	select LEDS_TRIGGER_DEFAULT_ON
-	default n
-	help
-	  Add support for the Soekris net5501 board (detection, error led
-	  and GPIO).
-
 config LEDS_FSG
 	tristate "LED Support for the Freecom FSG-3"
 	depends on LEDS_CLASS
diff -puN drivers/leds/Makefile~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer drivers/leds/Makefile
--- a/drivers/leds/Makefile~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer
+++ a/drivers/leds/Makefile
@@ -13,7 +13,6 @@ obj-$(CONFIG_LEDS_LM3530)		+= leds-lm353
 obj-$(CONFIG_LEDS_MIKROTIK_RB532)	+= leds-rb532.o
 obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c24xx.o
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
-obj-$(CONFIG_LEDS_NET5501)		+= leds-net5501.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
diff -puN drivers/leds/leds-net5501.c~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer /dev/null
--- a/drivers/leds/leds-net5501.c
+++ /dev/null
@@ -1,97 +0,0 @@
-/*
- * Soekris board support code
- *
- * Copyright (C) 2008-2009 Tower Technologies
- * Written by Alessandro Zummo <a.zummo@towertech.it>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/io.h>
-#include <linux/string.h>
-#include <linux/leds.h>
-#include <linux/platform_device.h>
-#include <linux/gpio.h>
-#include <linux/module.h>
-
-#include <asm/geode.h>
-
-static const struct gpio_led net5501_leds[] = {
-	{
-		.name = "error",
-		.gpio = 6,
-		.default_trigger = "default-on",
-	},
-};
-
-static struct gpio_led_platform_data net5501_leds_data = {
-	.num_leds = ARRAY_SIZE(net5501_leds),
-	.leds = net5501_leds,
-};
-
-static struct platform_device net5501_leds_dev = {
-	.name = "leds-gpio",
-	.id = -1,
-	.dev.platform_data = &net5501_leds_data,
-};
-
-static void __init init_net5501(void)
-{
-	platform_device_register(&net5501_leds_dev);
-}
-
-struct soekris_board {
-	u16	offset;
-	char	*sig;
-	u8	len;
-	void	(*init)(void);
-};
-
-static struct soekris_board __initdata boards[] = {
-	{ 0xb7b, "net5501", 7, init_net5501 },	/* net5501 v1.33/1.33c */
-	{ 0xb1f, "net5501", 7, init_net5501 },	/* net5501 v1.32i */
-};
-
-static int __init soekris_init(void)
-{
-	int i;
-	unsigned char *rombase, *bios;
-
-	if (!is_geode())
-		return 0;
-
-	rombase = ioremap(0xffff0000, 0xffff);
-	if (!rombase) {
-		printk(KERN_INFO "Soekris net5501 LED driver failed to get rombase");
-		return 0;
-	}
-
-	bios = rombase + 0x20;	/* null terminated */
-
-	if (strncmp(bios, "comBIOS", 7))
-		goto unmap;
-
-	for (i = 0; i < ARRAY_SIZE(boards); i++) {
-		unsigned char *model = rombase + boards[i].offset;
-
-		if (strncmp(model, boards[i].sig, boards[i].len) == 0) {
-			printk(KERN_INFO "Soekris %s: %s\n", model, bios);
-
-			if (boards[i].init)
-				boards[i].init();
-			break;
-		}
-	}
-
-unmap:
-	iounmap(rombase);
-	return 0;
-}
-
-arch_initcall(soekris_init);
