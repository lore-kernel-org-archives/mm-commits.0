From: akpm@linux-foundation.org
Subject: + leds-new-pcengines-alix-led-driver-using-gpio-interface.patch added to -mm tree
Date: Thu, 07 Apr 2011 14:58:41 -0700
Message-ID: <201104072158.p37Lwfjv002520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961Ab1DGV7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 17:59:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@wildgooses.com, a.zummo@towertech.it, daniel@caiaq.de, rpurdie@rpsys.net


The patch titled
     leds: new PCEngines Alix LED driver using gpio interface
has been added to the -mm tree.  Its filename is
     leds-new-pcengines-alix-led-driver-using-gpio-interface.patch

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
Subject: leds: new PCEngines Alix LED driver using gpio interface
From: Ed Wildgoose <kernel@wildgooses.com>

This new driver replaces the old PCEngines Alix 2/3 LED driver with a new
driver that controls the LEDs through the leds-gpio driver.  The old
driver accessed GPIOs directly, which created a conflict and prevented
also loading the cs5535-gio driver to read other GPIOs on the Alix board. 
With this new driver, both are loaded and therefore it's possible to
access both the LEDs and onboard GPIOs

This driver is based on leds-net5501.c by Alessandro Zummo.

Additionally it relies on parts of the patch: 7f131cf3ed ("leds:
leds-alix2c - take port address from MSR") by Daniel Mack to perform
detection of the Alix board.

Signed-off-by: Ed Wildgoose <kernel@wildgooses.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Daniel Mack <daniel@caiaq.de> 
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig      |    2 
 drivers/leds/leds-alix2.c |  196 ++++++++----------------------------
 2 files changed, 46 insertions(+), 152 deletions(-)

diff -puN drivers/leds/Kconfig~leds-new-pcengines-alix-led-driver-using-gpio-interface drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-new-pcengines-alix-led-driver-using-gpio-interface
+++ a/drivers/leds/Kconfig
@@ -110,7 +110,7 @@ config LEDS_WRAP
 config LEDS_ALIX2
 	tristate "LED Support for ALIX.2 and ALIX.3 series"
 	depends on LEDS_CLASS
-	depends on X86 && !GPIO_CS5535 && !CS5535_GPIO
+	depends on X86 && LEDS_GPIO_PLATFORM && GPIO_CS5535
 	help
 	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
 	  You have to set leds-alix2.force=1 for boards with Award BIOS.
diff -puN drivers/leds/leds-alix2.c~leds-new-pcengines-alix-led-driver-using-gpio-interface drivers/leds/leds-alix2.c
--- a/drivers/leds/leds-alix2.c~leds-new-pcengines-alix-led-driver-using-gpio-interface
+++ a/drivers/leds/leds-alix2.c
@@ -1,119 +1,66 @@
 /*
  * LEDs driver for PCEngines ALIX.2 and ALIX.3
  *
- * Copyright (C) 2008 Constantin Baranov <const@mimas.ru>
+ * Copyright (C) 2011 Nippy Networks Ltd
+ * Written by Ed Wildgoose <kernel@wildgooses.com>
+ * Based on leds-net5501.c by Alessandro Zummo <a.zummo@towertech.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
  */
 
-#include <linux/err.h>
-#include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/string.h>
 #include <linux/leds.h>
-#include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/string.h>
-#include <linux/pci.h>
+#include <linux/gpio.h>
+
+#include <asm/geode.h>
 
 static int force = 0;
 module_param(force, bool, 0444);
 MODULE_PARM_DESC(force, "Assume system has ALIX.2/ALIX.3 style LEDs");
 
-#define MSR_LBAR_GPIO		0x5140000C
-#define CS5535_GPIO_SIZE	256
-
-static u32 gpio_base;
-
-static struct pci_device_id divil_pci[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_NS,  PCI_DEVICE_ID_NS_CS5535_ISA) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
-	{ } /* NULL entry */
-};
-MODULE_DEVICE_TABLE(pci, divil_pci);
-
-struct alix_led {
-	struct led_classdev cdev;
-	unsigned short port;
-	unsigned int on_value;
-	unsigned int off_value;
-};
-
-static void alix_led_set(struct led_classdev *led_cdev,
-			 enum led_brightness brightness)
-{
-	struct alix_led *led_dev =
-		container_of(led_cdev, struct alix_led, cdev);
-
-	if (brightness)
-		outl(led_dev->on_value, gpio_base + led_dev->port);
-	else
-		outl(led_dev->off_value, gpio_base + led_dev->port);
-}
-
-static struct alix_led alix_leds[] = {
+static struct gpio_led alix_leds[] = {
 	{
-		.cdev = {
-			.name = "alix:1",
-			.brightness_set = alix_led_set,
-		},
-		.port = 0x00,
-		.on_value = 1 << 22,
-		.off_value = 1 << 6,
+		.name = "alix:1",
+		.gpio = 6,
+		.default_trigger = "default-on",
+		.active_low = 1,
 	},
 	{
-		.cdev = {
-			.name = "alix:2",
-			.brightness_set = alix_led_set,
-		},
-		.port = 0x80,
-		.on_value = 1 << 25,
-		.off_value = 1 << 9,
+		.name = "alix:2",
+		.gpio = 25,
+		.default_trigger = "default-off",
+		.active_low = 1,
 	},
 	{
-		.cdev = {
-			.name = "alix:3",
-			.brightness_set = alix_led_set,
-		},
-		.port = 0x80,
-		.on_value = 1 << 27,
-		.off_value = 1 << 11,
+		.name = "alix:3",
+		.gpio = 27,
+		.default_trigger = "default-off",
+		.active_low = 1,
 	},
 };
 
-static int __init alix_led_probe(struct platform_device *pdev)
-{
-	int i;
-	int ret;
-
-	for (i = 0; i < ARRAY_SIZE(alix_leds); i++) {
-		alix_leds[i].cdev.flags |= LED_CORE_SUSPENDRESUME;
-		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
-		if (ret < 0)
-			goto fail;
-	}
-	return 0;
+static struct gpio_led_platform_data alix_leds_data = {
+	.num_leds = ARRAY_SIZE(alix_leds),
+	.leds = alix_leds,
+};
 
-fail:
-	while (--i >= 0)
-		led_classdev_unregister(&alix_leds[i].cdev);
-	return ret;
-}
+static struct platform_device alix_leds_dev = {
+	.name = "leds-gpio",
+	.id = -1,
+	.dev.platform_data = &alix_leds_data,
+};
 
-static int alix_led_remove(struct platform_device *pdev)
+static void __init register_alix(void)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
-		led_classdev_unregister(&alix_leds[i].cdev);
-	return 0;
+	platform_device_register(&alix_leds_dev);
 }
 
-static struct platform_driver alix_led_driver = {
-	.remove = alix_led_remove,
-	.driver = {
-		.name = KBUILD_MODNAME,
-		.owner = THIS_MODULE,
-	},
-};
-
 static int __init alix_present(unsigned long bios_phys,
 				const char *alix_sig,
 				size_t alix_sig_len)
@@ -164,76 +111,23 @@ static int __init alix_present(unsigned 
 	return 0;
 }
 
-static struct platform_device *pdev;
-
-static int __init alix_pci_led_init(void)
+static int __init alix_init(void)
 {
-	u32 low, hi;
-
-	if (pci_dev_present(divil_pci) == 0) {
-		printk(KERN_WARNING KBUILD_MODNAME": DIVIL not found\n");
-		return -ENODEV;
-	}
-
-	/* Grab the GPIO I/O range */
-	rdmsr(MSR_LBAR_GPIO, low, hi);
-
-	/* Check the mask and whether GPIO is enabled (sanity check) */
-	if (hi != 0x0000f001) {
-		printk(KERN_WARNING KBUILD_MODNAME": GPIO not enabled\n");
-		return -ENODEV;
-	}
-
-	/* Mask off the IO base address */
-	gpio_base = low & 0x0000ff00;
-
-	if (!request_region(gpio_base, CS5535_GPIO_SIZE, KBUILD_MODNAME)) {
-		printk(KERN_ERR KBUILD_MODNAME": can't allocate I/O for GPIO\n");
-		return -ENODEV;
-	}
-
-	/* Set GPIO function to output */
-	outl(1 << 6, gpio_base + 0x04);
-	outl(1 << 9, gpio_base + 0x84);
-	outl(1 << 11, gpio_base + 0x84);
-
-	return 0;
-}
-
-static int __init alix_led_init(void)
-{
-	int ret = -ENODEV;
 	const char tinybios_sig[] = "PC Engines ALIX.";
 	const char coreboot_sig[] = "PC Engines\0ALIX.";
 
+	if (!is_geode())
+		return 0;
+
 	if (alix_present(0xf0000, tinybios_sig, sizeof(tinybios_sig) - 1) ||
 	    alix_present(0x500, coreboot_sig, sizeof(coreboot_sig) - 1))
-		ret = alix_pci_led_init();
+		register_alix();
 
-	if (ret < 0)
-		return ret;
-
-	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
-	if (!IS_ERR(pdev)) {
-		ret = platform_driver_probe(&alix_led_driver, alix_led_probe);
-		if (ret)
-			platform_device_unregister(pdev);
-	} else
-		ret = PTR_ERR(pdev);
-
-	return ret;
-}
