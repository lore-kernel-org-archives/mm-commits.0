From: akpm@linux-foundation.org
Subject: - pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:31:51 -0700
Message-ID: <200707230931.l6N9VpGZ016269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52038 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860AbXGWJct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, galak@gate.crashing.org, hch@infradead.org, linux@dominikbrodowski.net, miltonm@bga.com, olof@lixom.net, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix
has been removed from the -mm tree.  Its filename was
     pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix.patch

This patch was dropped because it was folded into pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch

------------------------------------------------------
Subject: pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Milton Miller <miltonm@bga.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/electra_cf.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/pcmcia/electra_cf.c~pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix drivers/pcmcia/electra_cf.c
--- a/drivers/pcmcia/electra_cf.c~pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix
+++ a/drivers/pcmcia/electra_cf.c
@@ -201,9 +201,7 @@ static int __devinit electra_cf_probe(st
 	if (!cf)
 		return -ENOMEM;
 
-	init_timer(&cf->timer);
-	cf->timer.function = electra_cf_timer;
-	cf->timer.data = (unsigned long) cf;
+	setup_timer(&cf->timer, electra_cf_timer, (unsigned long)cf);
 	cf->irq = NO_IRQ;
 
 	cf->ofdev = ofdev;
@@ -340,16 +338,14 @@ static int __devexit electra_cf_remove(s
 	return 0;
 }
 
-static struct of_device_id electra_cf_match[] =
-{
+static struct of_device_id electra_cf_match[] = {
 	{
 		.compatible   = "electra-cf",
 	},
 	{},
 };
 
-static struct of_platform_driver electra_cf_driver =
-{
+static struct of_platform_driver electra_cf_driver = {
 	.name	   = (char *)driver_name,
 	.match_table    = electra_cf_match,
 	.probe	  = electra_cf_probe,
@@ -371,4 +367,3 @@ module_exit(electra_cf_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR ("Olof Johansson <olof@lixom.net>");
 MODULE_DESCRIPTION("PA Semi Electra CF driver");
-
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
git-dvb.patch
adbhid-produce-all-capslock-key-events-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mtd.patch
mtd-potential-leak-in-rfd_ftl_add_mtd-fix.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
ip_auto_config-fix-fix.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-xfs.patch
git-xfs-fixup.patch
git-kgdb-fixup-2.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix.patch
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
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
