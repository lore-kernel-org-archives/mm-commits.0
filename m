From: akpm@linux-foundation.org
Subject: - pnpacpi-sets-pnpdev-devarchdata-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:05:01 -0700
Message-ID: <200704302005.l3UK56j0013723@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946752AbXD3UHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:07:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, ambx1@neo.rr.com, bjorn.helgaas@hp.com, dbrownell@users.sourceforge.net, greg@kroah.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pnpacpi-sets-pnpdev-devarchdata fix
has been removed from the -mm tree.  Its filename was
     pnpacpi-sets-pnpdev-devarchdata-fix.patch

This patch was dropped because it was folded into pnpacpi-sets-pnpdev-devarchdata.patch

------------------------------------------------------
Subject: pnpacpi-sets-pnpdev-devarchdata fix
From: David Brownell <david-b@pacbell.net>

Handle PNP devices that have the same IDs a bit more sanely ...  this at
least arranges multiple one-to-one mappings between PNP nodes and ACPI
nodes that all share the same PNP0c02 id.  (Maybe mapped to the wrong node
though...)

This remains a hack, since it masks failures where PNP0a03 (a PCI root
bridge) is handled by ACPI special case code (/sys/devices/pci0000:00 on my
systems instead of /sys/devices/pnp0/pnp00:0/pci0000:00!) not pure PNPACPI
logic.

I suspect that pnp_dev.number and some acpi_device field need to be
compared, (so the right PNP0c02 nodes hook up to each other, PNP0a03
likewise) but I'll leave that to someone who knows how those ACPI table
lookups "should" work.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/core.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/pnp/pnpacpi/core.c~pnpacpi-sets-pnpdev-devarchdata-fix drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~pnpacpi-sets-pnpdev-devarchdata-fix
+++ a/drivers/pnp/pnpacpi/core.c
@@ -243,6 +243,7 @@ static int __init acpi_pnp_match(struct 
 
 	/* true means it matched */
 	return acpi->flags.hardware_id
+		&& !acpi_get_physical_device(acpi->handle)
 		&& compare_pnp_id(pnp->id, acpi->pnp.hardware_id);
 }
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-implement-pm_opsvalid-for-everybody-fix.patch
git-acpi.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
at91_cf-minor-fix.patch
scsi-newstyle-hotplug-coldplug-support.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
kconfig-mentioneds-hibernation-not-just-swsusp.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-rs5c313-driver.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
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
