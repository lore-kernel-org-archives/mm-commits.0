From: akpm@linux-foundation.org
Subject: + try-parent-numa_node-at-first-before-using-default-v2-fix.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:17:21 -0700
Message-ID: <200707192317.l6JNHLC3027957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38959 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765817AbXGSXR4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:17:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Yinghai.Lu@Sun.COM, ak@suse.de, clameter@sgi.com, cornelia.huck@de.ibm.com, davem@davemloft.net, greg@kroah.com, hch@infradead.org, rientjes@google.com, stefanr@s5r6.in-berlin.de, yinghai.lu@Sun.COM


The patch titled
     try-parent-numa_node-at-first-before-using-default-v2-fix
has been added to the -mm tree.  Its filename is
     try-parent-numa_node-at-first-before-using-default-v2-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: try-parent-numa_node-at-first-before-using-default-v2-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: David Miller <davem@davemloft.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg KH <greg@kroah.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/base/core.c~try-parent-numa_node-at-first-before-using-default-v2-fix drivers/base/core.c
--- a/drivers/base/core.c~try-parent-numa_node-at-first-before-using-default-v2-fix
+++ a/drivers/base/core.c
@@ -765,9 +765,8 @@ int device_add(struct device *dev)
 		goto Error;
 
 	/* use parent numa_node */
-	if (parent) {
+	if (parent)
 		set_dev_node(dev, dev_to_node(parent));
-	}
 
 	/* first, register with generic layer. */
 	kobject_set_name(&dev->kobj, "%s", dev->bus_id);
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
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
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
