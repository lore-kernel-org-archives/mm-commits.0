From: akpm@linux-foundation.org
Subject: + mbp_nvidia_bl-rename-to-apple_bl.patch added to -mm tree
Date: Tue, 04 Jan 2011 14:37:24 -0800
Message-ID: <201101042237.p04MbO5X028182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238Ab1ADWi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 17:38:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, mourad@aquazul.com, rpurdie@linux.intel.com


The patch titled
     mbp_nvidia_bl: rename to apple_bl
has been added to the -mm tree.  Its filename is
     mbp_nvidia_bl-rename-to-apple_bl.patch

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
Subject: mbp_nvidia_bl: rename to apple_bl
From: Matthew Garrett <mjg@redhat.com>

It works on hardware other than Macbook Pros, and it works on GPUs other
than Nvidia.  It should even work on iMacs, so change the name to match
reality more precisely and include an alias so existing users don't get
confused.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Cc: Mourad De Clerck <mourad@aquazul.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig         |    6 
 drivers/video/backlight/Makefile        |    2 
 drivers/video/backlight/apple_bl.c      |  240 ++++++++++++++++++++++
 drivers/video/backlight/mbp_nvidia_bl.c |  239 ---------------------
 4 files changed, 244 insertions(+), 243 deletions(-)

diff -puN drivers/video/backlight/Kconfig~mbp_nvidia_bl-rename-to-apple_bl drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~mbp_nvidia_bl-rename-to-apple_bl
+++ a/drivers/video/backlight/Kconfig
@@ -236,11 +236,11 @@ config BACKLIGHT_MAX8925
 	  If you have a LCD backlight connected to the WLED output of MAX8925
 	  WLED output, say Y here to enable this driver.
 
-config BACKLIGHT_MACBOOK
-       tristate "MacBook Backlight Driver"
+config BACKLIGHT_APPLE
+       tristate "Apple Backlight Driver"
        depends on X86
        help
-         If you have an Apple Macbook say Y to enable a driver for its
+         If you have an Intel-based Apple say Y to enable a driver for its
 	 backlight
 
 config BACKLIGHT_TOSA
diff -puN drivers/video/backlight/Makefile~mbp_nvidia_bl-rename-to-apple_bl drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~mbp_nvidia_bl-rename-to-apple_bl
+++ a/drivers/video/backlight/Makefile
@@ -26,7 +26,7 @@ obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) +=
 obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
 obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
 obj-$(CONFIG_BACKLIGHT_MAX8925)	+= max8925_bl.o
-obj-$(CONFIG_BACKLIGHT_MACBOOK)	+= mbp_nvidia_bl.o
+obj-$(CONFIG_BACKLIGHT_APPLE)	+= apple_bl.o
 obj-$(CONFIG_BACKLIGHT_TOSA)	+= tosa_bl.o
 obj-$(CONFIG_BACKLIGHT_SAHARA)	+= kb3886_bl.o
 obj-$(CONFIG_BACKLIGHT_WM831X)	+= wm831x_bl.o
diff -puN /dev/null drivers/video/backlight/apple_bl.c
--- /dev/null
+++ a/drivers/video/backlight/apple_bl.c
@@ -0,0 +1,240 @@
+/*
+ *  Backlight Driver for Intel-based Apples
+ *
+ *  Copyright (c) Red Hat <mjg@redhat.com>
+ *  Based on code from Pommed:
+ *  Copyright (C) 2006 Nicolas Boichat <nicolas @boichat.ch>
+ *  Copyright (C) 2006 Felipe Alfaro Solana <felipe_alfaro @linuxmail.org>
+ *  Copyright (C) 2007 Julien BLACHE <jb@jblache.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This driver triggers SMIs which cause the firmware to change the
+ *  backlight brightness. This is icky in many ways, but it's impractical to
+ *  get at the firmware code in order to figure out what it's actually doing.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/backlight.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/pci.h>
+#include <linux/acpi.h>
+
+static struct backlight_device *apple_backlight_device;
+
+struct hw_data {
+	/* I/O resource to allocate. */
+	unsigned long iostart;
+	unsigned long iolen;
+	/* Backlight operations structure. */
+	const struct backlight_ops backlight_ops;
+	void (*set_brightness)(int);
+};
+
+static const struct hw_data *hw_data;
+
+#define DRIVER "apple_backlight: "
+
+/* Module parameters. */
+static int debug;
+module_param_named(debug, debug, int, 0644);
+MODULE_PARM_DESC(debug, "Set to one to enable debugging messages.");
+
+/*
+ * Implementation for machines with Intel chipset.
+ */
+static void intel_chipset_set_brightness(int intensity)
+{
+	outb(0x04 | (intensity << 4), 0xb3);
+	outb(0xbf, 0xb2);
+}
+
+static int intel_chipset_send_intensity(struct backlight_device *bd)
+{
+	int intensity = bd->props.brightness;
+
+	if (debug)
+		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
+		       intensity);
+
+	intel_chipset_set_brightness(intensity);
+	return 0;
+}
+
+static int intel_chipset_get_intensity(struct backlight_device *bd)
+{
+	int intensity;
+
+	outb(0x03, 0xb3);
+	outb(0xbf, 0xb2);
+	intensity = inb(0xb3) >> 4;
+
+	if (debug)
+		printk(KERN_DEBUG DRIVER "read brightness of %d\n",
+		       intensity);
+
+	return intensity;
+}
+
+static const struct hw_data intel_chipset_data = {
+	.iostart = 0xb2,
+	.iolen = 2,
+	.backlight_ops	= {
+		.options	= BL_CORE_SUSPENDRESUME,
+		.get_brightness	= intel_chipset_get_intensity,
+		.update_status	= intel_chipset_send_intensity,
+	},
+	.set_brightness = intel_chipset_set_brightness,
+};
+
+/*
+ * Implementation for machines with Nvidia chipset.
+ */
+static void nvidia_chipset_set_brightness(int intensity)
+{
+	outb(0x04 | (intensity << 4), 0x52f);
+	outb(0xbf, 0x52e);
+}
+
+static int nvidia_chipset_send_intensity(struct backlight_device *bd)
+{
+	int intensity = bd->props.brightness;
+
+	if (debug)
+		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
+		       intensity);
+
+	nvidia_chipset_set_brightness(intensity);
+	return 0;
+}
+
+static int nvidia_chipset_get_intensity(struct backlight_device *bd)
+{
+	int intensity;
+
+	outb(0x03, 0x52f);
+	outb(0xbf, 0x52e);
+	intensity = inb(0x52f) >> 4;
+
+	if (debug)
+		printk(KERN_DEBUG DRIVER "read brightness of %d\n",
+		       intensity);
+
+	return intensity;
+}
+
+static const struct hw_data nvidia_chipset_data = {
+	.iostart = 0x52e,
+	.iolen = 2,
+	.backlight_ops		= {
+		.options	= BL_CORE_SUSPENDRESUME,
+		.get_brightness	= nvidia_chipset_get_intensity,
+		.update_status	= nvidia_chipset_send_intensity
+	},
+	.set_brightness = nvidia_chipset_set_brightness,
+};
+
+static int __devinit apple_bl_add(struct acpi_device *dev)
+{
+	struct backlight_properties props;
+	struct pci_dev *host;
+	int intensity;
+
+	host = pci_get_bus_and_slot(0, 0);
+
+	if (!host) {
+		printk(KERN_ERR DRIVER "unable to find PCI host\n");
+		return -ENODEV;
+	}
+
+	if (host->vendor == PCI_VENDOR_ID_INTEL)
+		hw_data = &intel_chipset_data;
+	else if (host->vendor == PCI_VENDOR_ID_NVIDIA)
+		hw_data = &nvidia_chipset_data;
+
+	pci_dev_put(host);
+
+	if (!hw_data) {
+		printk(KERN_ERR DRIVER "unknown hardware\n");
+		return -ENODEV;
+	}
+
+	/* Check that the hardware responds - this may not work under EFI */
+
+	intensity = hw_data->backlight_ops.get_brightness(NULL);
+
+	if (!intensity) {
+		hw_data->set_brightness(1);
+		if (!hw_data->backlight_ops.get_brightness(NULL))
+			return -ENODEV;
+
+		hw_data->set_brightness(0);
+	}
+
+	if (!request_region(hw_data->iostart, hw_data->iolen,
+			    "Apple backlight"))
+		return -ENXIO;
+
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 15;
+	apple_backlight_device = backlight_device_register("apple_backlight",
+				  NULL, NULL, &hw_data->backlight_ops, &props);
+
+	if (IS_ERR(apple_backlight_device)) {
+		release_region(hw_data->iostart, hw_data->iolen);
+		return PTR_ERR(apple_backlight_device);
+	}
+
+	apple_backlight_device->props.brightness =
+		hw_data->backlight_ops.get_brightness(apple_backlight_device);
+	backlight_update_status(apple_backlight_device);
+
+	return 0;
+}
+
+static int __devexit apple_bl_remove(struct acpi_device *dev, int type)
+{
+	backlight_device_unregister(apple_backlight_device);
+
+	release_region(hw_data->iostart, hw_data->iolen);
+	hw_data = NULL;
+	return 0;
+}
+
+static const struct acpi_device_id apple_bl_ids[] = {
+	{"APP0002", 0},
+	{"", 0},
+};
+
+static struct acpi_driver apple_bl_driver = {
+	.name = "Apple backlight",
+	.ids = apple_bl_ids,
+	.ops = {
+		.add = apple_bl_add,
+		.remove = apple_bl_remove,
+	},
+};
+
+static int __init apple_bl_init(void)
+{
+	return acpi_bus_register_driver(&apple_bl_driver);
+}
+
+static void __exit apple_bl_exit(void)
+{
+	acpi_bus_unregister_driver(&apple_bl_driver);
+}
+
+module_init(apple_bl_init);
+module_exit(apple_bl_exit);
+
+MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
+MODULE_DESCRIPTION("Apple Backlight Driver");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(acpi, apple_bl_ids);
+MODULE_ALIAS("mbp_nvidia_bl");
diff -puN drivers/video/backlight/mbp_nvidia_bl.c~mbp_nvidia_bl-rename-to-apple_bl /dev/null
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ /dev/null
@@ -1,239 +0,0 @@
-/*
- *  Backlight Driver for Macbooks
- *
- *  Copyright (c) Red Hat <mjg@redhat.com>
- *  Based on code from Pommed:
- *  Copyright (C) 2006 Nicolas Boichat <nicolas @boichat.ch>
- *  Copyright (C) 2006 Felipe Alfaro Solana <felipe_alfaro @linuxmail.org>
- *  Copyright (C) 2007 Julien BLACHE <jb@jblache.org>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  published by the Free Software Foundation.
- *
- *  This driver triggers SMIs which cause the firmware to change the
- *  backlight brightness. This is icky in many ways, but it's impractical to
- *  get at the firmware code in order to figure out what it's actually doing.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/backlight.h>
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/pci.h>
-#include <linux/acpi.h>
-
-static struct backlight_device *mb_backlight_device;
-
-struct hw_data {
-	/* I/O resource to allocate. */
-	unsigned long iostart;
-	unsigned long iolen;
-	/* Backlight operations structure. */
-	const struct backlight_ops backlight_ops;
-	void (*set_brightness)(int);
-};
-
-static const struct hw_data *hw_data;
-
-#define DRIVER "mb_backlight: "
-
-/* Module parameters. */
-static int debug;
-module_param_named(debug, debug, int, 0644);
-MODULE_PARM_DESC(debug, "Set to one to enable debugging messages.");
-
-/*
- * Implementation for MacBooks with Intel chipset.
- */
-static void intel_chipset_set_brightness(int intensity)
-{
-	outb(0x04 | (intensity << 4), 0xb3);
-	outb(0xbf, 0xb2);
-}
-
-static int intel_chipset_send_intensity(struct backlight_device *bd)
-{
-	int intensity = bd->props.brightness;
-
-	if (debug)
-		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
-		       intensity);
-
-	intel_chipset_set_brightness(intensity);
-	return 0;
-}
-
-static int intel_chipset_get_intensity(struct backlight_device *bd)
-{
-	int intensity;
-
-	outb(0x03, 0xb3);
-	outb(0xbf, 0xb2);
-	intensity = inb(0xb3) >> 4;
-
-	if (debug)
-		printk(KERN_DEBUG DRIVER "read brightness of %d\n",
-		       intensity);
-
-	return intensity;
-}
-
-static const struct hw_data intel_chipset_data = {
-	.iostart = 0xb2,
-	.iolen = 2,
-	.backlight_ops	= {
-		.options	= BL_CORE_SUSPENDRESUME,
-		.get_brightness	= intel_chipset_get_intensity,
-		.update_status	= intel_chipset_send_intensity,
-	},
-	.set_brightness = intel_chipset_set_brightness,
-};
-
-/*
- * Implementation for MacBooks with Nvidia chipset.
- */
-static void nvidia_chipset_set_brightness(int intensity)
-{
-	outb(0x04 | (intensity << 4), 0x52f);
-	outb(0xbf, 0x52e);
-}
-
-static int nvidia_chipset_send_intensity(struct backlight_device *bd)
-{
-	int intensity = bd->props.brightness;
-
-	if (debug)
-		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
-		       intensity);
-
-	nvidia_chipset_set_brightness(intensity);
-	return 0;
-}
-
-static int nvidia_chipset_get_intensity(struct backlight_device *bd)
-{
-	int intensity;
-
-	outb(0x03, 0x52f);
-	outb(0xbf, 0x52e);
-	intensity = inb(0x52f) >> 4;
-
-	if (debug)
-		printk(KERN_DEBUG DRIVER "read brightness of %d\n",
-		       intensity);
-
-	return intensity;
-}
-
-static const struct hw_data nvidia_chipset_data = {
-	.iostart = 0x52e,
-	.iolen = 2,
-	.backlight_ops		= {
-		.options	= BL_CORE_SUSPENDRESUME,
-		.get_brightness	= nvidia_chipset_get_intensity,
-		.update_status	= nvidia_chipset_send_intensity
-	},
-	.set_brightness = nvidia_chipset_set_brightness,
-};
-
-static int __devinit mb_bl_add(struct acpi_device *dev)
-{
-	struct backlight_properties props;
-	struct pci_dev *host;
-	int intensity;
-
-	host = pci_get_bus_and_slot(0, 0);
-
-	if (!host) {
-		printk(KERN_ERR DRIVER "unable to find PCI host\n");
-		return -ENODEV;
-	}
-
-	if (host->vendor == PCI_VENDOR_ID_INTEL)
-		hw_data = &intel_chipset_data;
-	else if (host->vendor == PCI_VENDOR_ID_NVIDIA)
-		hw_data = &nvidia_chipset_data;
-
-	pci_dev_put(host);
-
-	if (!hw_data) {
-		printk(KERN_ERR DRIVER "unknown hardware\n");
-		return -ENODEV;
-	}
-
-	/* Check that the hardware responds - this may not work under EFI */
-
-	intensity = hw_data->backlight_ops.get_brightness(NULL);
-
-	if (!intensity) {
-		hw_data->set_brightness(1);
-		if (!hw_data->backlight_ops.get_brightness(NULL))
-			return -ENODEV;
-
-		hw_data->set_brightness(0);
-	}
-
-	if (!request_region(hw_data->iostart, hw_data->iolen,
-			    "Macbook backlight"))
-		return -ENXIO;
-
-	memset(&props, 0, sizeof(struct backlight_properties));
-	props.max_brightness = 15;
-	mb_backlight_device = backlight_device_register("mb_backlight", NULL,
-				    NULL, &hw_data->backlight_ops, &props);
-
-	if (IS_ERR(mb_backlight_device)) {
-		release_region(hw_data->iostart, hw_data->iolen);
-		return PTR_ERR(mb_backlight_device);
-	}
-
-	mb_backlight_device->props.brightness =
-		hw_data->backlight_ops.get_brightness(mb_backlight_device);
-	backlight_update_status(mb_backlight_device);
-
-	return 0;
-}
-
-static int __devexit mb_bl_remove(struct acpi_device *dev, int type)
-{
-	backlight_device_unregister(mb_backlight_device);
-
-	release_region(hw_data->iostart, hw_data->iolen);
-	hw_data = NULL;
-	return 0;
-}
-
-static const struct acpi_device_id mb_bl_ids[] = {
-	{"APP0002", 0},
-	{"", 0},
-};
-
-static struct acpi_driver mb_bl_driver = {
-	.name = "Macbook backlight",
-	.ids = mb_bl_ids,
-	.ops = {
-		.add = mb_bl_add,
-		.remove = mb_bl_remove,
-	},
-};
-
-static int __init mb_init(void)
-{
-	return acpi_bus_register_driver(&mb_bl_driver);
-}
-
-static void __exit mb_exit(void)
-{
-	acpi_bus_unregister_driver(&mb_bl_driver);
-}
-
-module_init(mb_init);
-module_exit(mb_exit);
