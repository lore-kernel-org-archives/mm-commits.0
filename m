From: akpm@linux-foundation.org
Subject: - acpi-send-switch-event-on-dock-events.patch removed from -mm tree
Date: Mon, 09 Jun 2008 02:48:31 -0700
Message-ID: <200806090948.m599mVob013925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758380AbYFIJtT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 05:49:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, dtor@mail.ru, kristen.c.accardi@intel.com, lenb@kernel.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     acpi: send switch event on dock events
has been removed from the -mm tree.  Its filename was
     acpi-send-switch-event-on-dock-events.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: send switch event on dock events
From: Matthew Garrett <mjg59@srcf.ucam.org>

Send a switch event on docking for consistency with docks that don't
present as a separate device.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig |    1 +
 drivers/acpi/dock.c  |   24 ++++++++++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/Kconfig~acpi-send-switch-event-on-dock-events drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~acpi-send-switch-event-on-dock-events
+++ a/drivers/acpi/Kconfig
@@ -160,6 +160,7 @@ config ACPI_FAN
 
 config ACPI_DOCK
 	tristate "Dock"
+	depends on INPUT
 	depends on EXPERIMENTAL
 	help
 	  This driver adds support for ACPI controlled docking stations
diff -puN drivers/acpi/dock.c~acpi-send-switch-event-on-dock-events drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-send-switch-event-on-dock-events
+++ a/drivers/acpi/dock.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/input.h>
 #include <linux/types.h>
 #include <linux/notifier.h>
 #include <linux/platform_device.h>
@@ -65,6 +66,7 @@ struct dock_station {
 	struct mutex hp_lock;
 	struct list_head dependent_devices;
 	struct list_head hotplug_devices;
+	struct input_dev *dock_input;
 };
 
 struct dock_dependent_device {
@@ -345,10 +347,13 @@ static void dock_event(struct dock_stati
 	char event_string[13];
 	char *envp[] = { event_string, NULL };
 
-	if (num == UNDOCK_EVENT)
+	if (num == UNDOCK_EVENT) {
+		input_report_switch(dock_station->dock_input, SW_DOCK, 0);
 		sprintf(event_string, "EVENT=undock");
-	else
+	} else {
+		input_report_switch(dock_station->dock_input, SW_DOCK, 1);
 		sprintf(event_string, "EVENT=dock");
+	}
 
 	/*
 	 * Indicate that the status of the dock station has
@@ -834,6 +839,19 @@ static int dock_add(acpi_handle handle)
 		goto dock_add_err;
 	}
 
+	/* Set up input device */
+	dock_station->dock_input = input_allocate_device();
+	dock_station->dock_input->name = "ACPI dock";
+	dock_station->dock_input->phys = "dock/input0";
+	dock_station->dock_input->id.bustype = BUS_HOST;
+	dock_station->dock_input->dev.parent = &dock_device->dev;
+	set_bit(EV_SW, dock_station->dock_input->evbit);
+	set_bit(SW_DOCK, dock_station->dock_input->swbit);
+	ret = input_register_device(dock_station->dock_input);
+
+	if (ret)
+		input_free_device(dock_station->dock_input);
+
 	printk(KERN_INFO PREFIX "%s\n", ACPI_DOCK_DRIVER_DESCRIPTION);
 
 	return 0;
@@ -881,6 +899,8 @@ static int dock_remove(void)
 	device_remove_file(&dock_device->dev, &dev_attr_flags);
 	platform_device_unregister(dock_device);
 
+	input_unregister_device(dock_station->dock_input);
+
 	/* free dock station memory */
 	kfree(dock_station);
 	dock_station = NULL;
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

isight_firmware-avoid-crash-on-loading-invalid-firmware.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
bay-exit-if-notify-handler-cannot-be-installed.patch
input-add-switch-for-dock-events.patch
acpi-send-switch-event-on-dock-events.patch
misc-add-hp-wmi-laptop-extras-driver.patch

