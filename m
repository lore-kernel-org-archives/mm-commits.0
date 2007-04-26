From: akpm@linux-foundation.org
Subject: - make-proc-acpi-wakeup-more-useful.patch removed from -mm tree
Date: Wed, 25 Apr 2007 23:59:13 -0700
Message-ID: <200704260659.l3Q6xDwa023124@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933217AbXDZHAm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 03:00:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, lenb@kernel.org, mjg59@srcf.ucam.org, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     make /proc/acpi/wakeup more useful
has been removed from the -mm tree.  Its filename was
     make-proc-acpi-wakeup-more-useful.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make /proc/acpi/wakeup more useful
From: David Brownell <david-b@pacbell.net>

This updates /proc/acpi/wakeup to be more informative, primarily by showing
the sysfs node associated with each wakeup-enabled device.  Example:

	Device	S-state	  Status   Sysfs node
	PCI0	  S4	 disabled  no-bus:pci0000:00
	PS2M	  S4	 disabled  pnp:00:05
	PS2K	  S4	 disabled  pnp:00:06
	UAR1	  S4	 disabled  pnp:00:08
	USB1	  S3	 disabled  pci:0000:00:03.0
	USB2	  S3	 disabled  pci:0000:00:03.1
	USB3	  S3	 disabled
	USB4	  S3	 disabled  pci:0000:00:03.3
	S139	  S4	 disabled
	LAN	  S4	 disabled  pci:0000:00:04.0
	MDM	  S4	 disabled
	AUD	  S4	 disabled  pci:0000:00:02.7
	SLPB	  S4	*enabled

Eventually this file should be removed, but until then it's almost the only
way we have to tell how the relevant ACPI tables are broken (and cope).  In
that example, two devices don't actually exist (USB3, S139), one can't issue
wakeup events (PCI0), and two seem harmlessly (?) confused (MDM and AUD are
the same PCI device, but it's the _modem_ that does wake-on-ring).

In particular, we need to be sure driver model nodes are properly hooked
up before we can get rid of this ACPI-only interface for wakeup events.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/proc.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/sleep/proc.c~make-proc-acpi-wakeup-more-useful drivers/acpi/sleep/proc.c
--- a/drivers/acpi/sleep/proc.c~make-proc-acpi-wakeup-more-useful
+++ a/drivers/acpi/sleep/proc.c
@@ -350,21 +350,31 @@ acpi_system_wakeup_device_seq_show(struc
 {
 	struct list_head *node, *next;
 
-	seq_printf(seq, "Device	Sleep state	Status\n");
+	seq_printf(seq, "Device\tS-state\t  Status   Sysfs node\n");
 
 	spin_lock(&acpi_device_lock);
 	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
 		struct acpi_device *dev =
 		    container_of(node, struct acpi_device, wakeup_list);
+		struct device *ldev;
 
 		if (!dev->wakeup.flags.valid)
 			continue;
 		spin_unlock(&acpi_device_lock);
-		seq_printf(seq, "%4s	%4d		%s%8s\n",
+
+		ldev = acpi_get_physical_device(dev->handle);
+		seq_printf(seq, "%s\t  S%d\t%c%-8s  ",
 			   dev->pnp.bus_id,
 			   (u32) dev->wakeup.sleep_state,
-			   dev->wakeup.flags.run_wake ? "*" : "",
+			   dev->wakeup.flags.run_wake ? '*' : ' ',
 			   dev->wakeup.state.enabled ? "enabled" : "disabled");
+		if (ldev)
+			seq_printf(seq, "%s:%s",
+				ldev->bus ? ldev->bus->name : "no-bus",
+				ldev->bus_id);
+		seq_printf(seq, "\n");
+		put_device(ldev);
+
 		spin_lock(&acpi_device_lock);
 	}
 	spin_unlock(&acpi_device_lock);
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-acpi.patch
define-platform-wakeup-hook-use-in-pci_enable_wake.patch
define-platform-wakeup-hook-use-in-pci_enable_wake-update.patch
define-platform-wakeup-hook-use-in-pci_enable_wake-fix.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
at91_cf-minor-fix.patch
scsi-newstyle-hotplug-coldplug-support.patch
usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
kconfig-mentioneds-hibernation-not-just-swsusp.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
parport-dev-driver-model-support-powerpc-fix.patch
layered-parport-code-uses-parport-dev.patch
pnpacpi-sets-pnpdev-devarchdata.patch
pnpacpi-sets-pnpdev-devarchdata-fix.patch
fix-hotplug-for-legacy-platform-drivers.patch
minor-spi_butterfly-cleanup.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-update-to-class-device-removal-patches.patch
rtc-kconfig-cleanup.patch
rtc-cmos-wakeup-interface.patch
acpi-wakeup-hooks-for-rtc-cmos.patch
workaround-rtc-related-acpi-table-bugs.patch
revert-rtc-add-rtc_merge_alarm.patch
remove-rtc_alm_set-mode-bugs.patch
