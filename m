From: akpm@linux-foundation.org
Subject: + add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch added to -mm tree
Date: Thu, 19 Jul 2007 18:27:08 -0700
Message-ID: <200707200127.l6K1R8Vq000587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33669 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758829AbXGTB2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 21:28:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bjorn.helgaas@hp.com, rmk+lkml@arm.linux.org.uk, schmidt@digadd.de, yinghai.lu@sun.com


The patch titled
     add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix
has been added to the -mm tree.  Its filename is
     add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix
From: Andrew Morton <akpm@linux-foundation.org>

- ARRAY_SIZE is neater and tighter than the terminate-it-in-null thing.

- fix lots of broken whitespace

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Christian Schmidt <schmidt@digadd.de>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Yinghai Lu <yinghai.lu@sun.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/serial/8250_pci.c~add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix
+++ a/drivers/serial/8250_pci.c
@@ -1666,8 +1666,7 @@ static struct pciserial_board pci_boards
 };
 
 static const struct pci_device_id softmodem_blacklist[] = {
-     { PCI_VDEVICE ( AL, 0x5457 ), }, /* ALi Corporation M5457 AC'97 Modem */
-     { }
+	{ PCI_VDEVICE ( AL, 0x5457 ), }, /* ALi Corporation M5457 AC'97 Modem */
 };
 
 /*
@@ -1678,7 +1677,7 @@ static const struct pci_device_id softmo
 static int __devinit
 serial_pci_guess_board(struct pci_dev *dev, struct pciserial_board *board)
 {
-        const struct pci_device_id * blacklist;
+	const struct pci_device_id *blacklist;
 	int num_iomem, num_port, first_port = -1, i;
 	
 	/*
@@ -1697,10 +1696,12 @@ serial_pci_guess_board(struct pci_dev *d
 	 * Do not access blacklisted devices that are known not to
 	 * feature serial ports.
 	 */
-	for (blacklist = softmodem_blacklist; blacklist->vendor; blacklist++) {
-	        if ((dev->vendor == blacklist->vendor) &&
-	            (dev->device == blacklist->device))
-		        return -ENODEV;
+	for (blacklist = softmodem_blacklist;
+	     blacklist < softmodem_blacklist + ARRAY_SIZE(softmodem_blacklist);
+	     blacklist++) {
+		if (dev->vendor == blacklist->vendor &&
+		    dev->device == blacklist->device)
+			return -ENODEV;
 	}
 
 	num_iomem = num_port = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-fix-git-rejects.patch
acpi-add-reboot-mechanism-fix.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
git-dvb.patch
git-input.patch
adbhid-produce-all-capslock-key-events-fix.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mtd.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
git-scsi-misc.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
x86_64-clean-up-apicid_to_node-declaration.patch
clockevents-fix-resume-logic-xen-fix.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-xfs.patch
git-kgdb-fixup-2.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fix-swiotlb_sync_single_range.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
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
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
