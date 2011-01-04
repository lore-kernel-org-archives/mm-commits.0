From: akpm@linux-foundation.org
Subject: + mbp_nvidia_bl-remove-dmi-dependency.patch added to -mm tree
Date: Tue, 04 Jan 2011 14:37:20 -0800
Message-ID: <201101042237.p04MbK3q028176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940Ab1ADWki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 17:40:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, mourad@aquazul.com, rpurdie@linux.intel.com


The patch titled
     mbp_nvidia_bl: remove DMI dependency
has been added to the -mm tree.  Its filename is
     mbp_nvidia_bl-remove-dmi-dependency.patch

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
Subject: mbp_nvidia_bl: remove DMI dependency
From: Matthew Garrett <mjg@redhat.com>

This driver only has to deal with two different classes of hardware, but
right now it needs new DMI entries for every new machine. It turns out
that there's an ACPI device that uniquely identifies Apples with backlights,
so this patch reworks the driver into an ACPI one, identifies the hardware
by checking the PCI vendor of the root bridge and strips out all the DMI
code. It also changes the config text to clarify that it works on devices
other than Macbook Pros and GPUs other than nvidia.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Cc: Mourad De Clerck <mourad@aquazul.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig         |    8 
 drivers/video/backlight/Makefile        |    2 
 drivers/video/backlight/mbp_nvidia_bl.c |  366 +++++-----------------
 3 files changed, 101 insertions(+), 275 deletions(-)

diff -puN drivers/video/backlight/Kconfig~mbp_nvidia_bl-remove-dmi-dependency drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~mbp_nvidia_bl-remove-dmi-dependency
+++ a/drivers/video/backlight/Kconfig
@@ -236,12 +236,12 @@ config BACKLIGHT_MAX8925
 	  If you have a LCD backlight connected to the WLED output of MAX8925
 	  WLED output, say Y here to enable this driver.
 
-config BACKLIGHT_MBP_NVIDIA
-       tristate "MacBook Pro Nvidia Backlight Driver"
+config BACKLIGHT_MACBOOK
+       tristate "MacBook Backlight Driver"
        depends on X86
        help
-         If you have an Apple Macbook Pro with Nvidia graphics hardware say Y
-	 to enable a driver for its backlight
+         If you have an Apple Macbook say Y to enable a driver for its
+	 backlight
 
 config BACKLIGHT_TOSA
 	tristate "Sharp SL-6000 Backlight Driver"
diff -puN drivers/video/backlight/Makefile~mbp_nvidia_bl-remove-dmi-dependency drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~mbp_nvidia_bl-remove-dmi-dependency
+++ a/drivers/video/backlight/Makefile
@@ -26,7 +26,7 @@ obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) +=
 obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
 obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
 obj-$(CONFIG_BACKLIGHT_MAX8925)	+= max8925_bl.o
-obj-$(CONFIG_BACKLIGHT_MBP_NVIDIA) += mbp_nvidia_bl.o
+obj-$(CONFIG_BACKLIGHT_MACBOOK)	+= mbp_nvidia_bl.o
 obj-$(CONFIG_BACKLIGHT_TOSA)	+= tosa_bl.o
 obj-$(CONFIG_BACKLIGHT_SAHARA)	+= kb3886_bl.o
 obj-$(CONFIG_BACKLIGHT_WM831X)	+= wm831x_bl.o
diff -puN drivers/video/backlight/mbp_nvidia_bl.c~mbp_nvidia_bl-remove-dmi-dependency drivers/video/backlight/mbp_nvidia_bl.c
--- a/drivers/video/backlight/mbp_nvidia_bl.c~mbp_nvidia_bl-remove-dmi-dependency
+++ a/drivers/video/backlight/mbp_nvidia_bl.c
@@ -1,5 +1,5 @@
 /*
- *  Backlight Driver for Nvidia 8600 in Macbook Pro
+ *  Backlight Driver for Macbooks
  *
  *  Copyright (c) Red Hat <mjg@redhat.com>
  *  Based on code from Pommed:
@@ -19,23 +19,27 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/platform_device.h>
 #include <linux/backlight.h>
 #include <linux/err.h>
-#include <linux/dmi.h>
 #include <linux/io.h>
+#include <linux/pci.h>
+#include <linux/acpi.h>
 
-static struct backlight_device *mbp_backlight_device;
+static struct backlight_device *mb_backlight_device;
 
-/* Structure to be passed to the DMI_MATCH function. */
-struct dmi_match_data {
+struct hw_data {
 	/* I/O resource to allocate. */
 	unsigned long iostart;
 	unsigned long iolen;
 	/* Backlight operations structure. */
 	const struct backlight_ops backlight_ops;
+	void (*set_brightness)(int);
 };
 
+static const struct hw_data *hw_data;
+
+#define DRIVER "mb_backlight: "
+
 /* Module parameters. */
 static int debug;
 module_param_named(debug, debug, int, 0644);
@@ -44,16 +48,21 @@ MODULE_PARM_DESC(debug, "Set to one to e
 /*
  * Implementation for MacBooks with Intel chipset.
  */
+static void intel_chipset_set_brightness(int intensity)
+{
+	outb(0x04 | (intensity << 4), 0xb3);
+	outb(0xbf, 0xb2);
+}
+
 static int intel_chipset_send_intensity(struct backlight_device *bd)
 {
 	int intensity = bd->props.brightness;
 
 	if (debug)
-		printk(KERN_DEBUG "mbp_nvidia_bl: setting brightness to %d\n",
+		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
 		       intensity);
 
-	outb(0x04 | (intensity << 4), 0xb3);
-	outb(0xbf, 0xb2);
+	intel_chipset_set_brightness(intensity);
 	return 0;
 }
 
@@ -66,35 +75,41 @@ static int intel_chipset_get_intensity(s
 	intensity = inb(0xb3) >> 4;
 
 	if (debug)
-		printk(KERN_DEBUG "mbp_nvidia_bl: read brightness of %d\n",
+		printk(KERN_DEBUG DRIVER "read brightness of %d\n",
 		       intensity);
 
 	return intensity;
 }
 
-static const struct dmi_match_data intel_chipset_data = {
+static const struct hw_data intel_chipset_data = {
 	.iostart = 0xb2,
 	.iolen = 2,
 	.backlight_ops	= {
 		.options	= BL_CORE_SUSPENDRESUME,
 		.get_brightness	= intel_chipset_get_intensity,
 		.update_status	= intel_chipset_send_intensity,
-	}
+	},
+	.set_brightness = intel_chipset_set_brightness,
 };
 
 /*
  * Implementation for MacBooks with Nvidia chipset.
  */
+static void nvidia_chipset_set_brightness(int intensity)
+{
+	outb(0x04 | (intensity << 4), 0x52f);
+	outb(0xbf, 0x52e);
+}
+
 static int nvidia_chipset_send_intensity(struct backlight_device *bd)
 {
 	int intensity = bd->props.brightness;
 
 	if (debug)
-		printk(KERN_DEBUG "mbp_nvidia_bl: setting brightness to %d\n",
+		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
 		       intensity);
 
-	outb(0x04 | (intensity << 4), 0x52f);
-	outb(0xbf, 0x52e);
+	nvidia_chipset_set_brightness(intensity);
 	return 0;
 }
 
@@ -107,294 +122,105 @@ static int nvidia_chipset_get_intensity(
 	intensity = inb(0x52f) >> 4;
 
 	if (debug)
-		printk(KERN_DEBUG "mbp_nvidia_bl: read brightness of %d\n",
+		printk(KERN_DEBUG DRIVER "read brightness of %d\n",
 		       intensity);
 
 	return intensity;
 }
 
-static const struct dmi_match_data nvidia_chipset_data = {
+static const struct hw_data nvidia_chipset_data = {
 	.iostart = 0x52e,
 	.iolen = 2,
 	.backlight_ops		= {
 		.options	= BL_CORE_SUSPENDRESUME,
 		.get_brightness	= nvidia_chipset_get_intensity,
 		.update_status	= nvidia_chipset_send_intensity
-	}
+	},
+	.set_brightness = nvidia_chipset_set_brightness,
 };
 
-/*
- * DMI matching.
- */
-static /* const */ struct dmi_match_data *driver_data;
-
-static int mbp_dmi_match(const struct dmi_system_id *id)
+static int __devinit mb_bl_add(struct acpi_device *dev)
 {
-	driver_data = id->driver_data;
+	struct backlight_properties props;
+	struct pci_dev *host;
 
-	printk(KERN_INFO "mbp_nvidia_bl: %s detected\n", id->ident);
-	return 1;
-}
+	host = pci_get_bus_and_slot(0, 0);
 
-static const struct dmi_system_id __initdata mbp_device_table[] = {
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBook 1,1",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Computer, Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook1,1"),
-		},
-		.driver_data	= (void *)&intel_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBook 2,1",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook2,1"),
-		},
-		.driver_data	= (void *)&intel_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBook 3,1",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook3,1"),
-		},
-		.driver_data	= (void *)&intel_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBook 4,1",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook4,1"),
-		},
-		.driver_data	= (void *)&intel_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBook 4,2",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook4,2"),
-		},
-		.driver_data	= (void *)&intel_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookPro 1,1",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro1,1"),
-		},
-		.driver_data	= (void *)&intel_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookPro 1,2",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro1,2"),
-		},
-		.driver_data	= (void *)&intel_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookPro 2,1",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro2,1"),
-		},
-		.driver_data	= (void *)&intel_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookPro 2,2",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro2,2"),
-		},
-		.driver_data	= (void *)&intel_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookPro 3,1",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3,1"),
-		},
-		.driver_data	= (void *)&intel_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookPro 3,2",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3,2"),
-		},
-		.driver_data	= (void *)&intel_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookPro 4,1",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4,1"),
-		},
-		.driver_data	= (void *)&intel_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookAir 1,1",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir1,1"),
-		},
-		.driver_data	= (void *)&intel_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBook 5,1",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5,1"),
-		},
-		.driver_data	= (void *)&nvidia_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBook 5,2",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5,2"),
-		},
-		.driver_data	= (void *)&nvidia_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBook 6,1",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook6,1"),
-		},
-		.driver_data	= (void *)&nvidia_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookAir 2,1",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir2,1"),
-		},
-		.driver_data	= (void *)&nvidia_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookPro 5,1",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,1"),
-		},
-		.driver_data	= (void *)&nvidia_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookPro 5,2",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,2"),
-		},
-		.driver_data	= (void *)&nvidia_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookPro 5,3",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,3"),
-		},
-		.driver_data	= (void *)&nvidia_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookPro 5,4",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,4"),
-		},
-		.driver_data	= (void *)&nvidia_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookPro 5,5",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,5"),
-		},
-		.driver_data	= (void *)&nvidia_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookAir 3,1",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,1"),
-		},
-		.driver_data	= (void *)&nvidia_chipset_data,
-	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookAir 3,2",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,2"),
-		},
-		.driver_data	= (void *)&nvidia_chipset_data,
-	},
-	{ }
-};
+	if (!host) {
+		printk(KERN_ERR DRIVER "unable to find PCI host\n");
+		return -ENODEV;
+	}
 
-static int __init mbp_init(void)
-{
-	struct backlight_properties props;
-	if (!dmi_check_system(mbp_device_table))
+	if (host->vendor == PCI_VENDOR_ID_INTEL)
+		hw_data = &intel_chipset_data;
+	else if (host->vendor == PCI_VENDOR_ID_NVIDIA)
+		hw_data = &nvidia_chipset_data;
+
+	pci_dev_put(host);
+
+	if (!hw_data) {
+		printk(KERN_ERR DRIVER "unknown hardware\n");
 		return -ENODEV;
+	}
 
-	if (!request_region(driver_data->iostart, driver_data->iolen, 
-						"Macbook Pro backlight"))
+	if (!request_region(hw_data->iostart, hw_data->iolen,
+			    "Macbook backlight"))
 		return -ENXIO;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.max_brightness = 15;
-	mbp_backlight_device = backlight_device_register("mbp_backlight", NULL,
-							 NULL,
-							 &driver_data->backlight_ops,
-							 &props);
-	if (IS_ERR(mbp_backlight_device)) {
-		release_region(driver_data->iostart, driver_data->iolen);
-		return PTR_ERR(mbp_backlight_device);
+	mb_backlight_device = backlight_device_register("mb_backlight", NULL,
+				    NULL, &hw_data->backlight_ops, &props);
+
+	if (IS_ERR(mb_backlight_device)) {
+		release_region(hw_data->iostart, hw_data->iolen);
+		return PTR_ERR(mb_backlight_device);
 	}
 
-	mbp_backlight_device->props.brightness =
-		driver_data->backlight_ops.get_brightness(mbp_backlight_device);
-	backlight_update_status(mbp_backlight_device);
+	mb_backlight_device->props.brightness =
+		hw_data->backlight_ops.get_brightness(mb_backlight_device);
+	backlight_update_status(mb_backlight_device);
 
 	return 0;
 }
 
-static void __exit mbp_exit(void)
+static int __devexit mb_bl_remove(struct acpi_device *dev, int type)
 {
-	backlight_device_unregister(mbp_backlight_device);
+	backlight_device_unregister(mb_backlight_device);
 
-	release_region(driver_data->iostart, driver_data->iolen);
+	release_region(hw_data->iostart, hw_data->iolen);
+	hw_data = NULL;
+	return 0;
+}
+
+static const struct acpi_device_id mb_bl_ids[] = {
+	{"APP0002", 0},
+	{"", 0},
+};
+
+static struct acpi_driver mb_bl_driver = {
+	.name = "Macbook backlight",
+	.ids = mb_bl_ids,
+	.ops = {
+		.add = mb_bl_add,
+		.remove = mb_bl_remove,
+	},
+};
+
+static int __init mb_init(void)
+{
+	return acpi_bus_register_driver(&mb_bl_driver);
+}
+
+static void __exit mb_exit(void)
+{
+	acpi_bus_unregister_driver(&mb_bl_driver);
 }
 
-module_init(mbp_init);
-module_exit(mbp_exit);
+module_init(mb_init);
+module_exit(mb_exit);
 
 MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
-MODULE_DESCRIPTION("Nvidia-based Macbook Pro Backlight Driver");
+MODULE_DESCRIPTION("Macbook Backlight Driver");
 MODULE_LICENSE("GPL");
-MODULE_DEVICE_TABLE(dmi, mbp_device_table);
+MODULE_DEVICE_TABLE(acpi, mb_bl_ids);
_

Patches currently in -mm which might be from mjg@redhat.com are

linux-next.patch
acerhdf-add-support-for-aspire-1410-bios-v13314.patch
mbp_nvidia_bl-remove-dmi-dependency.patch
mbp_nvidia_bl-check-that-the-backlight-control-functions.patch
mbp_nvidia_bl-rename-to-apple_bl.patch
drivers-video-backlight-mbp_nvidia_blc-add-support-for-macbookpro71.patch

