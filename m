From: akpm@linux-foundation.org
Subject: [merged] acpi-remove-the-wakeuprun_wake_count-device-field.patch removed from -mm tree
Date: Mon, 14 Feb 2011 12:19:48 -0800
Message-ID: <201102142019.p1EKJmD3023017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137Ab1BNUlc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Feb 2011 15:41:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, jbarnes@virtuousgeek.org, lenb@kernel.org, mjg59@srcf.ucam.org, mm-commits@vger.kernel.org


The patch titled
     acpi: remove the wakeup.run_wake_count device field
has been removed from the -mm tree.  Its filename was
     acpi-remove-the-wakeuprun_wake_count-device-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: remove the wakeup.run_wake_count device field
From: Rafael J. Wysocki <rjw@sisk.pl>

The wakeup.run_wake_count ACPI device field is only used by the PCI
runtime PM code to "protect" devices from being prepared for generating
wakeup signals more than once in a row.  However, it really doesn't
provide any protection, because (1) all of the functions it is supposed to
protect use their own reference counters effectively ensuring that the
device will be set up for generating wakeup signals just once and (2) the
PCI runtime PM code uses wakeup.run_wake_count in a racy way, since
nothing prevents acpi_dev_run_wake() from being called concurrently from
two different threads for the same device.

Remove the wakeup.run_wake_count ACPI device field which is unnecessary,
confusing and used in a wrong way.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/button.c   |    2 --
 drivers/acpi/scan.c     |    1 -
 drivers/pci/pci-acpi.c  |   16 ++++------------
 include/acpi/acpi_bus.h |    1 -
 4 files changed, 4 insertions(+), 16 deletions(-)

diff -puN drivers/acpi/button.c~acpi-remove-the-wakeuprun_wake_count-device-field drivers/acpi/button.c
--- a/drivers/acpi/button.c~acpi-remove-the-wakeuprun_wake_count-device-field
+++ a/drivers/acpi/button.c
@@ -430,7 +430,6 @@ static int acpi_button_add(struct acpi_d
 		/* Button's GPE is run-wake GPE */
 		acpi_enable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number);
-		device->wakeup.run_wake_count++;
 		device_set_wakeup_enable(&device->dev, true);
 	}
 
@@ -453,7 +452,6 @@ static int acpi_button_remove(struct acp
 	if (device->wakeup.flags.valid) {
 		acpi_disable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number);
-		device->wakeup.run_wake_count--;
 		device_set_wakeup_enable(&device->dev, false);
 	}
 
diff -puN drivers/acpi/scan.c~acpi-remove-the-wakeuprun_wake_count-device-field drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~acpi-remove-the-wakeuprun_wake_count-device-field
+++ a/drivers/acpi/scan.c
@@ -797,7 +797,6 @@ static void acpi_bus_set_run_wake_flags(
 	acpi_status status;
 	acpi_event_status event_status;
 
-	device->wakeup.run_wake_count = 0;
 	device->wakeup.flags.notifier_present = 0;
 
 	/* Power button, Lid switch always enable wakeup */
diff -puN drivers/pci/pci-acpi.c~acpi-remove-the-wakeuprun_wake_count-device-field drivers/pci/pci-acpi.c
--- a/drivers/pci/pci-acpi.c~acpi-remove-the-wakeuprun_wake_count-device-field
+++ a/drivers/pci/pci-acpi.c
@@ -293,19 +293,11 @@ static int acpi_dev_run_wake(struct devi
 	}
 
 	if (enable) {
-		if (!dev->wakeup.run_wake_count++) {
-			acpi_enable_wakeup_device_power(dev, ACPI_STATE_S0);
-			acpi_enable_gpe(dev->wakeup.gpe_device,
-					dev->wakeup.gpe_number);
-		}
-	} else if (dev->wakeup.run_wake_count > 0) {
-		if (!--dev->wakeup.run_wake_count) {
-			acpi_disable_gpe(dev->wakeup.gpe_device,
-					 dev->wakeup.gpe_number);
-			acpi_disable_wakeup_device_power(dev);
-		}
+		acpi_enable_wakeup_device_power(dev, ACPI_STATE_S0);
+		acpi_enable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
 	} else {
-		error = -EALREADY;
+		acpi_disable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
+		acpi_disable_wakeup_device_power(dev);
 	}
 
 	return error;
diff -puN include/acpi/acpi_bus.h~acpi-remove-the-wakeuprun_wake_count-device-field include/acpi/acpi_bus.h
--- a/include/acpi/acpi_bus.h~acpi-remove-the-wakeuprun_wake_count-device-field
+++ a/include/acpi/acpi_bus.h
@@ -250,7 +250,6 @@ struct acpi_device_wakeup {
 	struct acpi_handle_list resources;
 	struct acpi_device_wakeup_flags flags;
 	int prepare_count;
-	int run_wake_count;
 };
 
 /* Device */
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
usb-yurex-recognize-generalkeys-wireless-presenter-as-generic-hid.patch

