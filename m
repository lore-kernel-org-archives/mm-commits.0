From: akpm@linux-foundation.org
Subject: + usb-sierra-add-tru-install-c-support-fix.patch added to -mm tree
Date: Wed, 18 Jul 2007 16:14:06 -0700
Message-ID: <200707182314.l6INE63U001626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54998 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759034AbXGRXOP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 19:14:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, linux@sierrawireless.com


The patch titled
     usb-sierra-add-tru-install-c-support-fix
has been added to the -mm tree.  Its filename is
     usb-sierra-add-tru-install-c-support-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb-sierra-add-tru-install-c-support-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Greg KH <greg@kroah.com>
Cc: Kevin Lloyd <linux@sierrawireless.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/sierra.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/usb/serial/sierra.c~usb-sierra-add-tru-install-c-support-fix drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~usb-sierra-add-tru-install-c-support-fix
+++ a/drivers/usb/serial/sierra.c
@@ -45,7 +45,7 @@ enum devicetype {
 	DEVICE_INSTALLER =	2,
 };
 
-int sierra_set_power_state(struct usb_device *udev, __u16 swiState)
+static int sierra_set_power_state(struct usb_device *udev, __u16 swiState)
 {
 	int result;
 	dev_dbg(&udev->dev, "%s", "SET POWER STATE");
@@ -60,7 +60,7 @@ int sierra_set_power_state(struct usb_de
 	return result;
 }
 
-int sierra_set_ms_mode(struct usb_device *udev, __u16 eSocMode)
+static int sierra_set_ms_mode(struct usb_device *udev, __u16 eSocMode)
 {
 	int result;
 	dev_dbg(&udev->dev, "%s", "DEVICE MODE SWITCH");
@@ -75,7 +75,8 @@ int sierra_set_ms_mode(struct usb_device
 	return result;
 }
 
-int sierra_probe(struct usb_interface *iface, const struct usb_device_id *id)
+static int sierra_probe(struct usb_interface *iface,
+			const struct usb_device_id *id)
 {
 	int result;
 	struct usb_device *udev;
@@ -83,10 +84,10 @@ int sierra_probe(struct usb_interface *i
 	udev = usb_get_dev(interface_to_usbdev(iface));
 
 	/* Check if in installer mode */
-	if (id->driver_info == DEVICE_INSTALLER){
+	if (id->driver_info == DEVICE_INSTALLER) {
 		dev_dbg(&udev->dev, "%s", "FOUND DEVICE(SW)\n");
 		result = sierra_set_ms_mode(udev, SWIMS_SET_MODE_Modem);
-		/*We do not want to bind to the device when in installer mode*/
+		/* We don't want to bind to the device when in installer mode */
 		return -EIO;
 	}
 
@@ -565,7 +566,7 @@ static int sierra_startup(struct usb_ser
 
 	dbg("%s", __FUNCTION__);
 
-	/*Set Device mode to D0 */
+	/* Set Device mode to D0 */
 	sierra_set_power_state(serial->dev, 0x0000);
 
 	/* Now setup per port private data */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-2-fix.patch
mm-fault-feedback-2-fix-2.patch
readahead-split-ondemand-readahead-interface-into-two-functions-fix.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
add-sys-kernel-notes-fix.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks-fix.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
dequeue_huge_page-warning-fix.patch
git-acpi.patch
git-acpi-fix-git-rejects.patch
acpi-add-reboot-mechanism-fix.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-cifs.patch
revert-gregkh-driver-block-device.patch
driver-core-check-return-code-of-sysfs_create_link.patch
revert-saa7134-fix-thread-shutdown-handling.patch
git-dvb.patch
git-dvb-saa7134-tvaudio-fix.patch
git-input.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mips-fixup.patch
git-mtd.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
git-scsi-misc.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
usb-sierra-add-tru-install-c-support-fix.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
i386-add-cpu_relax-to-cmos_lock.patch
x86_64-flush_tlb_kernel_range-warning-fix.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
x86_64-get-mp_bus_to_node-as-early.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-xfs.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
file-capabilities-clear-caps-cleanup-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-new-i82975x-driver-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
