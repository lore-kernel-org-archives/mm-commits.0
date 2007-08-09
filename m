From: akpm@linux-foundation.org
Subject: - git-nfsd-build-fixes.patch removed from -mm tree
Date: Thu, 09 Aug 2007 15:50:28 -0700
Message-ID: <200708092250.l79MoSDU023585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37456 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754319AbXHIWuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 18:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bfields@fieldses.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     git-nfsd build fixes
has been removed from the -mm tree.  Its filename was
     git-nfsd-build-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-nfsd build fixes
From: Andrew Morton <akpm@linux-foundation.org>

- fix this:

In file included from fs/nfsctl.c:12:
include/linux/nfsd/nfsd.h: In function 'nfs4_state_init':
include/linux/nfsd/nfsd.h:164: warning: 'return' with a value, in function returning void
include/linux/nfsd/nfsd.h: In function 'nfs4_state_start':
include/linux/nfsd/nfsd.h:166: warning: 'return' with a value, in function returning void

- tidy things up a bit in there.

Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nfsd/nfsd.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/nfsd/nfsd.h~git-nfsd-build-fixes include/linux/nfsd/nfsd.h
--- a/include/linux/nfsd/nfsd.h~git-nfsd-build-fixes
+++ a/include/linux/nfsd/nfsd.h
@@ -161,13 +161,13 @@ time_t nfs4_lease_time(void);
 void nfs4_reset_lease(time_t leasetime);
 int nfs4_reset_recoverydir(char *recdir);
 #else
-static inline void nfs4_state_init(void) {return 0; }
-static inline void nfsd4_free_slabs(void){}
-static inline void nfs4_state_start(void) {return 0; }
-static inline void nfs4_state_shutdown(void){}
-static inline time_t nfs4_lease_time(void){return 0;}
-static inline void nfs4_reset_lease(time_t leasetime){}
-static inline int nfs4_reset_recoverydir(char *recdir) {return 0;}
+static inline int nfs4_state_init(void) { return 0; }
+static inline void nfsd4_free_slabs(void) { }
+static inline void nfs4_state_start(void) { }
+static inline void nfs4_state_shutdown(void) { }
+static inline time_t nfs4_lease_time(void) { return 0;}
+static inline void nfs4_reset_lease(time_t leasetime) { }
+static inline int nfs4_reset_recoverydir(char *recdir) { return 0; }
 #endif
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fbcon-kill-compile-warning-fix.patch
fix-serial-buffer-memory-leak-fix.patch
mtdchar-build-fix.patch
remove-bdput-from-do_open-in-fs-block_devc-fix.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
git-dvb-fixup-2.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
ide-arm-hack.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
ax88796-printk-fixes.patch
natsemi-fix-netdev-error-acounting.patch
git-ixgbe-build-fix.patch
ip_auto_config-fix-fix.patch
fib_trie-cleanup-fix.patch
introduce-u16_max-and-u32_max-fix.patch
introduce-strtol_check_range-fix.patch
git-nfsd.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-unionfs-build-fix.patch
git-unionfs-fix-2.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
git-wireless.patch
disable-b44-and-bcm43xx.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
x86_64-get-mp_bus_to_node-as-early-v3-fix.patch
git-xfs.patch
git-kgdb-fixup.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
fix-some-x86-x86-64-acpi-cpufreq-driver-issues.patch
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
implement-cpu_physical_id-on-smp=n.patch
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
