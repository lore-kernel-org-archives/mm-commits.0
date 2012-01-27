From: akpm@linux-foundation.org
Subject: + alix2-supplement-driver-to-include-gpio-button-support.patch added to -mm tree
Date: Fri, 27 Jan 2012 14:26:45 -0800
Message-ID: <20120127222646.1BE4CA00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:54663 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab2A0W0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 17:26:47 -0500
Received: by qcsd17 with SMTP id d17so224540qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 14:26:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp@redfish-solutions.com, dilinger@queued.net, hpa@zytor.com, kernel@wildgooses.com, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de


The patch titled
     Subject: alix2: supplement driver to include GPIO button support
has been added to the -mm tree.  Its filename is
     alix2-supplement-driver-to-include-gpio-button-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Philip Prindeville <philipp@redfish-solutions.com>
Subject: alix2: supplement driver to include GPIO button support

GPIO 24 is used in reference designs as a soft-reset button, and the alix2
is no exception.  Add it as a gpio-button.

Use symbolic values to describe BIOS addresses.

Record the model number.

Signed-off-by: Philip A. Prindeville <philipp@redfish-solutions.com>
Acked-by: Ed Wildgoose <kernel@wildgooses.com>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/geode/alix.c |   78 +++++++++++++++++++++++++++----
 1 file changed, 68 insertions(+), 10 deletions(-)

diff -puN arch/x86/platform/geode/alix.c~alix2-supplement-driver-to-include-gpio-button-support arch/x86/platform/geode/alix.c
--- a/arch/x86/platform/geode/alix.c~alix2-supplement-driver-to-include-gpio-button-support
+++ a/arch/x86/platform/geode/alix.c
@@ -6,6 +6,7 @@
  *
  * Copyright (C) 2008 Constantin Baranov <const@mimas.ru>
  * Copyright (C) 2011 Ed Wildgoose <kernel@wildgooses.com>
+ *                and Philip Prindeville <philipp@redfish-solutions.com>
  *
  * TODO: There are large similarities with leds-net5501.c
  * by Alessandro Zummo <a.zummo@towertech.it>
@@ -24,14 +25,47 @@
 #include <linux/leds.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/input.h>
+#include <linux/gpio_keys.h>
+#include <linux/dmi.h>
 
 #include <asm/geode.h>
 
+#define BIOS_SIGNATURE_TINYBIOS		0xf0000
+#define BIOS_SIGNATURE_COREBOOT		0x500
+#define BIOS_REGION_SIZE		0x10000
+
 static bool force = 0;
 module_param(force, bool, 0444);
 /* FIXME: Award bios is not automatically detected as Alix platform */
 MODULE_PARM_DESC(force, "Force detection as ALIX.2/ALIX.3 platform");
 
+static struct gpio_keys_button alix_gpio_buttons[] = {
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
+static struct gpio_keys_platform_data alix_buttons_data = {
+	.buttons = alix_gpio_buttons,
+	.nbuttons = ARRAY_SIZE(alix_gpio_buttons),
+	.poll_interval = 20,
+};
+
+static struct platform_device alix_buttons_dev = {
+	.name = "gpio-keys-polled",
+	.id = 1,
+	.dev = {
+		.platform_data = &alix_buttons_data,
+	}
+};
+
 static struct gpio_led alix_leds[] = {
 	{
 		.name = "alix:1",
@@ -64,17 +98,22 @@ static struct platform_device alix_leds_
 	.dev.platform_data = &alix_leds_data,
 };
 
+static struct __initdata platform_device *alix_devs[] = {
+	&alix_buttons_dev,
+	&alix_leds_dev,
+};
+
 static void __init register_alix(void)
 {
 	/* Setup LED control through leds-gpio driver */
-	platform_device_register(&alix_leds_dev);
+	platform_add_devices(alix_devs, ARRAY_SIZE(alix_devs));
 }
 
-static int __init alix_present(unsigned long bios_phys,
+static bool __init alix_present(unsigned long bios_phys,
 				const char *alix_sig,
 				size_t alix_sig_len)
 {
-	const size_t bios_len = 0x00010000;
+	const size_t bios_len = BIOS_REGION_SIZE;
 	const char *bios_virt;
 	const char *scan_end;
 	const char *p;
@@ -84,7 +123,7 @@ static int __init alix_present(unsigned 
 		printk(KERN_NOTICE "%s: forced to skip BIOS test, "
 		       "assume system is ALIX.2/ALIX.3\n",
 		       KBUILD_MODNAME);
-		return 1;
+		return true;
 	}
 
 	bios_virt = phys_to_virt(bios_phys);
@@ -109,18 +148,36 @@ static int __init alix_present(unsigned 
 			*a = '\0';
 
 		tail = p + alix_sig_len;
-		if ((tail[0] == '2' || tail[0] == '3')) {
+		if ((tail[0] == '2' || tail[0] == '3' || tail[0] == '6')) {
 			printk(KERN_INFO
 			       "%s: system is recognized as \"%s\"\n",
 			       KBUILD_MODNAME, name);
-			return 1;
+			return true;
 		}
 	}
 
-	return 0;
+	return false;
+}
+
+static bool __init alix_present_dmi(void)
+{
+	char *vendor, *product;
+
+	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
+	if (!vendor || strcmp(vendor, "PC Engines"))
+		return false;
+
+	product = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!product || (strcmp(product, "ALIX.2D") && strcmp(product, "ALIX.6")))
+		return false;
+
+	printk(KERN_INFO "%s: system is recognized as \"%s %s\"\n",
+	       KBUILD_MODNAME, vendor, product);
+
+	return true;
 }
 
-static int __init alix_init(void)
+static int  __init alix_init(void)
 {
 	const char tinybios_sig[] = "PC Engines ALIX.";
 	const char coreboot_sig[] = "PC Engines\0ALIX.";
@@ -128,8 +185,9 @@ static int __init alix_init(void)
 	if (!is_geode())
 		return 0;
 
-	if (alix_present(0xf0000, tinybios_sig, sizeof(tinybios_sig) - 1) ||
-	    alix_present(0x500, coreboot_sig, sizeof(coreboot_sig) - 1))
+	if (alix_present(BIOS_SIGNATURE_TINYBIOS, tinybios_sig, sizeof(tinybios_sig) - 1) ||
+	    alix_present(BIOS_SIGNATURE_COREBOOT, coreboot_sig, sizeof(coreboot_sig) - 1) ||
+	    alix_present_dmi())
 		register_alix();
 
 	return 0;
_
Subject: Subject: alix2: supplement driver to include GPIO button support

Patches currently in -mm which might be from philipp@redfish-solutions.com are

geos-platform-driver-for-geos-and-geos2-single-board-computers.patch
alix2-supplement-driver-to-include-gpio-button-support.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch

