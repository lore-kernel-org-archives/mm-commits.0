From: akpm@linux-foundation.org
Subject: - acpi-sbs-fix-retval-warning.patch removed from -mm tree
Date: Tue, 20 Nov 2007 12:00:51 -0800
Message-ID: <200711202000.lAKK0pBV020800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59676 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757937AbXKTUBu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 15:01:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, jgarzik@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ACPI sbs: fix retval warning
has been removed from the -mm tree.  Its filename was
     acpi-sbs-fix-retval-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI sbs: fix retval warning
From: Jeff Garzik <jeff@garzik.org>

drivers/acpi/sbs.c: In function `acpi_battery_add':
drivers/acpi/sbs.c:811: warning: ignoring return value of `device_create_file', declared with attribute warn_unused_result

Additional cleanups:
* use struct acpi_battery in acpi_battery_remove() to clean up function
calls, just like acpi_battery_add() already does.

* un-indent unregister call, as it mistakenly gives the impression that
it belongs inside the 'if' test

* remove unneeded braces

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sbs.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN drivers/acpi/sbs.c~acpi-sbs-fix-retval-warning drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~acpi-sbs-fix-retval-warning
+++ a/drivers/acpi/sbs.c
@@ -113,6 +113,7 @@ struct acpi_battery {
 	u16 spec;
 	u8 id;
 	u8 present:1;
+	u8 have_sysfs:1;
 };
 
 #define to_acpi_battery(x) container_of(x, struct acpi_battery, bat);
@@ -808,7 +809,8 @@ static int acpi_battery_add(struct acpi_
 	}
 	battery->bat.get_property = acpi_sbs_battery_get_property;
 	result = power_supply_register(&sbs->device->dev, &battery->bat);
-	device_create_file(battery->bat.dev, &alarm_attr);
+	if (device_create_file(battery->bat.dev, &alarm_attr) == 0)
+		battery->have_sysfs = 1;
 	printk(KERN_INFO PREFIX "%s [%s]: Battery Slot [%s] (battery %s)\n",
 	       ACPI_SBS_DEVICE_NAME, acpi_device_bid(sbs->device),
 	       battery->name, sbs->battery->present ? "present" : "absent");
@@ -817,14 +819,16 @@ static int acpi_battery_add(struct acpi_
 
 static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
 {
-	if (sbs->battery[id].bat.dev)
-		device_remove_file(sbs->battery[id].bat.dev, &alarm_attr);
-		power_supply_unregister(&sbs->battery[id].bat);
+	struct acpi_battery *battery = &sbs->battery[id];
+
+	if (battery->have_sysfs)
+		device_remove_file(battery->bat.dev, &alarm_attr);
+
+	power_supply_unregister(&battery->bat);
+
 #ifdef CONFIG_ACPI_PROCFS
-	if (sbs->battery[id].proc_entry) {
-		acpi_sbs_remove_fs(&(sbs->battery[id].proc_entry),
-				   acpi_battery_dir);
-	}
+	if (sbs->battery[id].proc_entry)
+		acpi_sbs_remove_fs(&battery->proc_entry, acpi_battery_dir);
 #endif
 }
 
_

Patches currently in -mm which might be from jeff@garzik.org are

git-arm.patch
powerpc-fix-typo-ifdef-ifndef.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_sisc-add-packard-bell-easynote-k5305-to-laptops.patch
libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch
ide-add-helper-__ide_setup_pci_device.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
drivers-net-chelsio-if-0-unused-functions.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
scsi-gdth-kill-unneeded-irq-argument.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-sym53c416-kill-pointless-irq-handler-loop-and-test.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
scsi-ncr5380-minor-irq-handler-cleanups.patch
iommu-sg-merging-add-device_dma_parameters-structure.patch
iommu-sg-merging-pci-add-device_dma_parameters-support.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch
usb-s3c2410_udc-minor-irq-handler-cleanups.patch
git-wireless.patch
tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-pointless-casts-from-void-pointers.patch
i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
i8k-inspiron-e1705-fix.patch
