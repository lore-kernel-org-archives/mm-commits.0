From: akpm@linux-foundation.org
Subject: - aacraid-rename-check_reset.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:05 -0700
Message-ID: <200708201913.l7KJD5lE018404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56895 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754319AbXHTTUd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:20:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@steeleye.com, aacraid@adaptec.com, mm-commits@vger.kernel.org


The patch titled
     aacraid: rename check_reset
has been removed from the -mm tree.  Its filename was
     aacraid-rename-check_reset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: aacraid: rename check_reset
From: Andrew Morton <akpm@linux-foundation.org>

Too generic, clashes with ISDN.

Acked-by: Mark Salyzyn <aacraid@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/aachba.c  |    8 ++++----
 drivers/scsi/aacraid/aacraid.h |    2 +-
 drivers/scsi/aacraid/commsup.c |    5 +++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/aacraid/aachba.c~aacraid-rename-check_reset drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c~aacraid-rename-check_reset
+++ a/drivers/scsi/aacraid/aachba.c
@@ -177,9 +177,9 @@ int check_interval = 24 * 60 * 60;
 module_param(check_interval, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(check_interval, "Interval in seconds between adapter health checks.");
 
-int check_reset = 1;
-module_param(check_reset, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(check_reset, "If adapter fails health check, reset the adapter.");
+int aac_check_reset = 1;
+module_param_named(check_reset, aac_check_reset, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(aac_check_reset, "If adapter fails health check, reset the adapter.");
 
 int expose_physicals = -1;
 module_param(expose_physicals, int, S_IRUGO|S_IWUSR);
@@ -1305,7 +1305,7 @@ int aac_get_adapter_info(struct aac_dev*
 			  (int)sizeof(dev->supplement_adapter_info.VpdInfo.Tsid),
 			  dev->supplement_adapter_info.VpdInfo.Tsid);
 		}
-		if (!check_reset ||
+		if (!aac_check_reset ||
 		  (dev->supplement_adapter_info.SupportedOptions2 &
 		  le32_to_cpu(AAC_OPTION_IGNORE_RESET))) {
 			printk(KERN_INFO "%s%d: Reset Adapter Ignored\n",
diff -puN drivers/scsi/aacraid/aacraid.h~aacraid-rename-check_reset drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h~aacraid-rename-check_reset
+++ a/drivers/scsi/aacraid/aacraid.h
@@ -1871,4 +1871,4 @@ extern int aac_reset_devices;
 extern int aac_commit;
 extern int update_interval;
 extern int check_interval;
-extern int check_reset;
+extern int aac_check_reset;
diff -puN drivers/scsi/aacraid/commsup.c~aacraid-rename-check_reset drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c~aacraid-rename-check_reset
+++ a/drivers/scsi/aacraid/commsup.c
@@ -1372,8 +1372,9 @@ int aac_check_health(struct aac_dev * aa
 
 	printk(KERN_ERR "%s: Host adapter BLINK LED 0x%x\n", aac->name, BlinkLED);
 
-	if (!check_reset || (aac->supplement_adapter_info.SupportedOptions2 &
-	  le32_to_cpu(AAC_OPTION_IGNORE_RESET)))
+	if (!aac_check_reset ||
+		(aac->supplement_adapter_info.SupportedOptions2 &
+			le32_to_cpu(AAC_OPTION_IGNORE_RESET)))
 		goto out;
 	host = aac->scsi_host_ptr;
 	if (aac->thread->pid != current->pid)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
free_irq-fix-debug_shirq-handling.patch
remove-bdput-from-do_open-in-fs-block_devc-fix.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-dma-up-fix.patch
git-dvb.patch
git-dvb-fixup-2.patch
adbhid-produce-all-capslock-key-events.patch
iforce-warning-fix.patch
git-kvm.patch
git-libata-all.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
ide-arm-hack.patch
git-mmc-fixup.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
git-ixgbe-build-fix.patch
git-net.patch
git-net-fixup.patch
git-backlight.patch
git-nfsd.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
git-scsi-misc.patch
git-unionfs.patch
git-unionfs-build-fix.patch
git-unionfs-fix-2.patch
git-watchdog.patch
git-wireless.patch
git-wireless-fixup.patch
net-add-ath5k-wireless-driver-fix.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
git-xfs.patch
git-kgdb-fixup.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
w1-build-fix.patch
