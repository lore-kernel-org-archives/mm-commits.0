From: akpm@linux-foundation.org
Subject: + leds-driver-for-hp-harddisk-protection-led.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:55:20 -0700
Message-ID: <200810162255.m9GMtKj4001733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754348AbYJPWzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, burman.yan@gmail.com, eric.piel@tremplin-utc.net, rpurdie@rpsys.net, trenn@suse.de


The patch titled
     leds driver for HP harddisk protection LED
has been added to the -mm tree.  Its filename is
     leds-driver-for-hp-harddisk-protection-led.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds driver for HP harddisk protection LED
From: Pavel Machek <pavel@suse.cz>

HP notebooks contain accelerometer-based disk protection subsystem, and
LED that indicates hard disk is protected.  This is driver for the LED
part.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Yan Burman <burman.yan@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig        |    7 +
 drivers/leds/Makefile       |    1 
 drivers/leds/leds-hp-disk.c |  155 ++++++++++++++++++++++++++++++++++
 3 files changed, 163 insertions(+)

diff -puN drivers/leds/Kconfig~leds-driver-for-hp-harddisk-protection-led drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-driver-for-hp-harddisk-protection-led
+++ a/drivers/leds/Kconfig
@@ -125,6 +125,13 @@ config LEDS_CM_X270
 	help
 	  This option enables support for the CM-X270 LEDs.
 
+config LEDS_HP_DISK
+	tristate "LED Support for disk protection LED on HP notebooks"
+	depends on LEDS_CLASS && ACPI
+	help
+	  This option enable support for disk protection LED, found on
+	  newer HP notebooks.
+
 config LEDS_CLEVO_MAIL
 	tristate "Mail LED on Clevo notebook (EXPERIMENTAL)"
 	depends on LEDS_CLASS && X86 && SERIO_I8042 && DMI && EXPERIMENTAL
diff -puN drivers/leds/Makefile~leds-driver-for-hp-harddisk-protection-led drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-driver-for-hp-harddisk-protection-led
+++ a/drivers/leds/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-c
 obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
+obj-$(CONFIG_LEDS_HP_DISK)		+= leds-hp-disk.o
 
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
diff -puN /dev/null drivers/leds/leds-hp-disk.c
--- /dev/null
+++ a/drivers/leds/leds-hp-disk.c
@@ -0,0 +1,155 @@
+/*
+ *  leds-hp-disk.c - driver for HP "hard disk protection" LED
+ *
+ *  Copyright (C) 2008 Pavel Machek
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/dmi.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+#include <linux/kthread.h>
+#include <linux/version.h>
+#include <linux/leds.h>
+#include <acpi/acpi_drivers.h>
+
+#define DRIVER_NAME     "leds-hp-disk"
+#define ACPI_MDPS_CLASS "led"
+
+/* For automatic insertion of the module */
+static struct acpi_device_id hpled_device_ids[] = {
+	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, hpled_device_ids);
+
+struct acpi_hpled {
+	struct acpi_device	*device;   /* The ACPI device */
+};
+
+static struct acpi_hpled adev;
+
+static acpi_status hpled_acpi_write(acpi_handle handle, int reg)
+{
+	unsigned long ret; /* Not used when writting */
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
+
+#ifdef CONFIG_PM
+static int hpled_suspend(struct acpi_device *dev, pm_message_t state)
+{
+	led_classdev_suspend(&hpled_led);
+	return 0;
+}
+
+static int hpled_resume(struct acpi_device *dev)
+{
+	led_classdev_resume(&hpled_led);
+	return 0;
+}
+#endif
+
+static int hpled_add(struct acpi_device *device)
+{
+	int ret;
+
+	if (!device)
+		return -EINVAL;
+
+	adev.device = device;
+	strcpy(acpi_device_name(device), DRIVER_NAME);
+	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
+	acpi_driver_data(device) = &adev;
+
+	ret = led_classdev_register(NULL, &hpled_led);
+	return ret;
+}
+
+static int hpled_remove(struct acpi_device *device, int type)
+{
+	if (!device)
+		return -EINVAL;
+
+	led_classdev_unregister(&hpled_led);
+	return 0;
+}
+
+
+
+static struct acpi_driver leds_hp_driver = {
+	.name  = DRIVER_NAME,
+	.class = ACPI_MDPS_CLASS,
+	.ids   = hpled_device_ids,
+	.ops = {
+		.add     = hpled_add,
+		.remove  = hpled_remove,
+#ifdef CONFIG_PM
+		.suspend = hpled_suspend,
+		.resume  = hpled_resume,
+#endif
+	}
+};
+
+static int __init hpled_init_module(void)
+{
+	int ret;
+
+	if (acpi_disabled)
+		return -ENODEV;
+
+	ret = acpi_bus_register_driver(&leds_hp_driver);
+	if (ret < 0)
+		return ret;
+
+	printk(KERN_INFO DRIVER_NAME " driver loaded.\n");
+
+	return 0;
+}
+
+static void __exit hpled_exit_module(void)
+{
+	acpi_bus_unregister_driver(&leds_hp_driver);
+}
+
+MODULE_DESCRIPTION("Driver for HP disk protection LED");
+MODULE_AUTHOR("Pavel Machek <pavel@suse.cz>");
+MODULE_LICENSE("GPL");
+
+module_init(hpled_init_module);
+module_exit(hpled_exit_module);
_

Patches currently in -mm which might be from pavel@suse.cz are

origin.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
pm-document-use-of-rtc-in-pm_trace.patch
git-acpi.patch
leds-driver-for-hp-harddisk-protection-led.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch

