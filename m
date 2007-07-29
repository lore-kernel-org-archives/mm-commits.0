From: akpm@linux-foundation.org
Subject: - allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch removed from -mm tree
Date: Sun, 29 Jul 2007 00:19:08 -0700
Message-ID: <200707290719.l6T7J8uM013437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35301 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759995AbXG2HU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:20:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hidehiro.kawai.ez@hitachi.com, nhorman@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix
has been removed from the -mm tree.  Its filename was
     allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix
From: Andrew Morton <akpm@linux-foundation.org>

arch/sparc64/kernel/binfmt_aout32.c:46: warning: initialization from incompatible pointer type

Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/binfmt_aout32.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/sparc64/kernel/binfmt_aout32.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix arch/sparc64/kernel/binfmt_aout32.c
--- a/arch/sparc64/kernel/binfmt_aout32.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix
+++ a/arch/sparc64/kernel/binfmt_aout32.c
@@ -36,7 +36,7 @@
 static int load_aout32_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout32_library(struct file*);
 static int aout32_core_dump(long signr, struct pt_regs * regs,
-			struct file *file, u32);
+			struct file *file, unsigned long);
 
 static struct linux_binfmt aout32_format = {
 	.lh	=	LIST_HEAD_INIT(aout32_format.lh),
@@ -88,7 +88,8 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout32_core_dump(long signr, struct pt_regs *regs, struct file *file, u32 limit)
+static int aout32_core_dump(long signr, struct pt_regs *regs, struct file *file,
+			unsigned long limit)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
parport_pc-locking-fix.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
kdebugh-forward-declare-struct-struct-notifier_block.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-mark_tsc_unstable-build-fix.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
git-dvb.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
libata-store-bus-addresses-versus-mm-for-testing-fix.patch
libata-store-bus-addresses-versus-mm-for-testing-fix-2.patch
fix-ide-ide-add-ide-set-pio-take3.patch
ide-bodge-things-around-to-make-arm-work.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
ax88796-printk-fixes.patch
ip_auto_config-fix-fix.patch
fib_trie-cleanup-fix.patch
git-ocfs2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
aacraid-rename-check_reset.patch
git-scsi-rc-fixes.patch
git-block-fix-headers_check.patch
git-block-whoops.patch
git-unionfs.patch
git-unionfs-fixup.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
git-watchdog.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-newsetup-fixup.patch
git-kgdb-fixup.patch
git-kgdb-arm-fix.patch
git-kgdb-mips-fix.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
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
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-sparc64-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch
ip2main-warning-fix.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
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
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
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
tpm_tis-debug.patch
w1-build-fix.patch
