From: akpm@linux-foundation.org
Subject: + lis3lv02d-merge-with-leds-hp-disk.patch added to -mm tree
Date: Mon, 24 Nov 2008 13:22:52 -0800
Message-ID: <200811242122.mAOLMqsj023184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752957AbYKXVXD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 16:23:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, pavel@suse.cz


The patch titled
     LIS3LV02D: merge with leds-hp-disk
has been added to the -mm tree.  Its filename is
     lis3lv02d-merge-with-leds-hp-disk.patch

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
Subject: LIS3LV02D: merge with leds-hp-disk
From: Eric Piel <eric.piel@tremplin-utc.net>

Move the second part of the HP laptop disk protection functionality (a red
led) to the same driver.  From a purely Linux developer's point of view,
the led and the accelerometer have nothing related.  However, they
correspond to the same ACPI functionality, and so will always be used
together, moreover as they share the same ACPI PNP alias, there is no
other simple to allow to have same loaded at the same time if they are not
in the same module.  Also make it requires the led class to compile and
update the Kconfig text.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig       |   14 ++-
 drivers/hwmon/hp_accel.c    |   43 ++++++++-
 drivers/leds/Kconfig        |    7 -
 drivers/leds/Makefile       |    1 
 drivers/leds/leds-hp-disk.c |  155 ----------------------------------
 5 files changed, 52 insertions(+), 168 deletions(-)

diff -puN drivers/hwmon/Kconfig~lis3lv02d-merge-with-leds-hp-disk drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~lis3lv02d-merge-with-leds-hp-disk
+++ a/drivers/hwmon/Kconfig
@@ -851,6 +851,8 @@ config SENSORS_HDAPS
 config SENSORS_LIS3LV02D
 	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer"
 	depends on ACPI && INPUT
+	select NEW_LEDS
+	select LEDS_CLASS
 	default n
 	help
 	  This driver provides support for the LIS3LV02Dx accelerometer. In
@@ -862,10 +864,16 @@ config SENSORS_LIS3LV02D
 	  /sys/devices/platform/lis3lv02d.
 
 	  This driver also provides an absolute input class device, allowing
-	  the laptop to act as a pinball machine-esque joystick.
+	  the laptop to act as a pinball machine-esque joystick. On HP laptops,
+	  if the led infrastructure is activated, support for a led indicating
+	  disk protection will be provided as hp:red:hddprotection.
+
+	  This driver can also be built as modules.  If so, the core module
+	  will be called lis3lv02d and a specific module for HP laptops will be
+	  called hp_accel.
 
-	  This driver can also be built as a module.  If so, the module
-	  will be called lis3lv02d.
+	  Say Y here if you have an applicable laptop and want to experience
+	  the awesome power of lis3lv02d.
 
 config SENSORS_APPLESMC
 	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
diff -puN drivers/hwmon/hp_accel.c~lis3lv02d-merge-with-leds-hp-disk drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3lv02d-merge-with-leds-hp-disk
+++ a/drivers/hwmon/hp_accel.c
@@ -36,6 +36,7 @@
 #include <linux/freezer.h>
 #include <linux/version.h>
 #include <linux/uaccess.h>
+#include <linux/leds.h>
 #include <acpi/acpi_drivers.h>
 #include <asm/atomic.h>
 #include "lis3lv02d.h"
@@ -154,10 +155,34 @@ static struct dmi_system_id lis3lv02d_dm
  */
 };
 
+static acpi_status hpled_acpi_write(acpi_handle handle, int reg)
+{
+	unsigned long long ret; /* Not used when writing */
+	union acpi_object in_obj[1];
+	struct acpi_object_list args = { 1, in_obj };
+
+	in_obj[0].type          = ACPI_TYPE_INTEGER;
+	in_obj[0].integer.value = reg;
+
+	return acpi_evaluate_integer(handle, "ALED", &args, &ret);
+}
+
+static void hpled_set(struct led_classdev *led_cdev,
+			       enum led_brightness value)
+{
+	hpled_acpi_write(adev.device->handle, !!value);
+}
+
+static struct led_classdev hpled_led = {
+	.name			= "hp:red:hddprotection",
+	.default_trigger	= "heartbeat",
+	.brightness_set		= hpled_set,
+};
 
 static int lis3lv02d_add(struct acpi_device *device)
 {
 	u8 val;
+	int ret;
 
 	if (!device)
 		return -EINVAL;
@@ -183,7 +208,17 @@ static int lis3lv02d_add(struct acpi_dev
 		adev.ac = lis3lv02d_axis_normal;
 	}
 
-	return lis3lv02d_init_device(&adev);
+	ret = led_classdev_register(NULL, &hpled_led);
+	if (ret)
+		return ret;
+
+	ret = lis3lv02d_init_device(&adev);
+	if (ret) {
+		led_classdev_unregister(&hpled_led);
+		return ret;
+	}
+
+	return ret;
 }
 
 static int lis3lv02d_remove(struct acpi_device *device, int type)
@@ -194,6 +229,8 @@ static int lis3lv02d_remove(struct acpi_
 	lis3lv02d_joystick_disable();
 	lis3lv02d_poweroff(device->handle);
 
+	led_classdev_unregister(&hpled_led);
+
 	return lis3lv02d_remove_fs();
 }
 
@@ -203,6 +240,7 @@ static int lis3lv02d_suspend(struct acpi
 {
 	/* make sure the device is off when we suspend */
 	lis3lv02d_poweroff(device->handle);
+	led_classdev_suspend(&hpled_led);
 	return 0;
 }
 
@@ -215,6 +253,7 @@ static int lis3lv02d_resume(struct acpi_
 	else
 		lis3lv02d_poweroff(device->handle);
 	mutex_unlock(&adev.lock);
+	led_classdev_resume(&hpled_led);
 	return 0;
 }
 #else
@@ -256,7 +295,7 @@ static void __exit lis3lv02d_exit_module
 	acpi_bus_unregister_driver(&lis3lv02d_driver);
 }
 
-MODULE_DESCRIPTION("Glue between LIS3LV02Dx and HP ACPI BIOS");
+MODULE_DESCRIPTION("Glue between LIS3LV02Dx and HP ACPI BIOS and support for disk protection LED.");
 MODULE_AUTHOR("Yan Burman, Eric Piel, Pavel Machek");
 MODULE_LICENSE("GPL");
 
diff -puN drivers/leds/Kconfig~lis3lv02d-merge-with-leds-hp-disk drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~lis3lv02d-merge-with-leds-hp-disk
+++ a/drivers/leds/Kconfig
@@ -119,13 +119,6 @@ config LEDS_GPIO
 	  outputs. To be useful the particular board must have LEDs
 	  and they must be connected to the GPIO lines.
 
-config LEDS_HP_DISK
-	tristate "LED Support for disk protection LED on HP notebooks"
-	depends on LEDS_CLASS && ACPI
-	help
-	  This option enable support for disk protection LED, found on
-	  newer HP notebooks.
-
 config LEDS_CLEVO_MAIL
 	tristate "Mail LED on Clevo notebook (EXPERIMENTAL)"
 	depends on LEDS_CLASS && X86 && SERIO_I8042 && DMI && EXPERIMENTAL
diff -puN drivers/leds/Makefile~lis3lv02d-merge-with-leds-hp-disk drivers/leds/Makefile
--- a/drivers/leds/Makefile~lis3lv02d-merge-with-leds-hp-disk
+++ a/drivers/leds/Makefile
@@ -23,7 +23,6 @@ obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
-obj-$(CONFIG_LEDS_HP_DISK)		+= leds-hp-disk.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
 
 # LED Triggers
diff -puN drivers/leds/leds-hp-disk.c~lis3lv02d-merge-with-leds-hp-disk /dev/null
--- a/drivers/leds/leds-hp-disk.c
+++ /dev/null
@@ -1,155 +0,0 @@
-/*
- *  leds-hp-disk.c - driver for HP "hard disk protection" LED
- *
- *  Copyright (C) 2008 Pavel Machek
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/dmi.h>
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/platform_device.h>
-#include <linux/interrupt.h>
-#include <linux/input.h>
-#include <linux/kthread.h>
-#include <linux/leds.h>
-#include <acpi/acpi_drivers.h>
-
-#define DRIVER_NAME     "leds-hp-disk"
-#define ACPI_MDPS_CLASS "led"
-
-/* For automatic insertion of the module */
-static struct acpi_device_id hpled_device_ids[] = {
-	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
-	{"", 0},
-};
-MODULE_DEVICE_TABLE(acpi, hpled_device_ids);
-
-struct acpi_hpled {
-	struct acpi_device	*device;   /* The ACPI device */
-};
-
-static struct acpi_hpled adev;
-
-static acpi_status hpled_acpi_write(acpi_handle handle, int reg)
-{
-	unsigned long long ret; /* Not used when writing */
-	union acpi_object in_obj[1];
-	struct acpi_object_list args = { 1, in_obj };
-
-	in_obj[0].type          = ACPI_TYPE_INTEGER;
-	in_obj[0].integer.value = reg;
-
-	return acpi_evaluate_integer(handle, "ALED", &args, &ret);
-}
-
-static void hpled_set(struct led_classdev *led_cdev,
-			       enum led_brightness value)
-{
-	hpled_acpi_write(adev.device->handle, !!value);
-}
-
-static struct led_classdev hpled_led = {
-	.name			= "hp:red:hddprotection",
-	.default_trigger	= "heartbeat",
-	.brightness_set		= hpled_set,
-};
-
-#ifdef CONFIG_PM
-static int hpled_suspend(struct acpi_device *dev, pm_message_t state)
-{
-	led_classdev_suspend(&hpled_led);
-	return 0;
-}
-
-static int hpled_resume(struct acpi_device *dev)
-{
-	led_classdev_resume(&hpled_led);
-	return 0;
-}
-#else
-#define hpled_suspend NULL
-#define hpled_resume NULL
-#endif
-
-static int hpled_add(struct acpi_device *device)
-{
-	int ret;
-
-	if (!device)
-		return -EINVAL;
-
-	adev.device = device;
-	strcpy(acpi_device_name(device), DRIVER_NAME);
-	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
-	device->driver_data = &adev;
-
-	ret = led_classdev_register(NULL, &hpled_led);
-	return ret;
-}
-
-static int hpled_remove(struct acpi_device *device, int type)
-{
-	if (!device)
-		return -EINVAL;
-
-	led_classdev_unregister(&hpled_led);
-	return 0;
-}
-
-
-
-static struct acpi_driver leds_hp_driver = {
-	.name  = DRIVER_NAME,
-	.class = ACPI_MDPS_CLASS,
-	.ids   = hpled_device_ids,
-	.ops = {
-		.add     = hpled_add,
-		.remove  = hpled_remove,
-		.suspend = hpled_suspend,
-		.resume  = hpled_resume,
-	}
-};
-
-static int __init hpled_init_module(void)
-{
-	int ret;
-
-	if (acpi_disabled)
-		return -ENODEV;
-
-	ret = acpi_bus_register_driver(&leds_hp_driver);
-	if (ret < 0)
-		return ret;
-
-	printk(KERN_INFO DRIVER_NAME " driver loaded.\n");
-
-	return 0;
-}
-
-static void __exit hpled_exit_module(void)
-{
-	acpi_bus_unregister_driver(&leds_hp_driver);
-}
-
-MODULE_DESCRIPTION("Driver for HP disk protection LED");
-MODULE_AUTHOR("Pavel Machek <pavel@suse.cz>");
-MODULE_LICENSE("GPL");
