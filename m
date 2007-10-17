From: akpm@linux-foundation.org
Subject: + reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes.patch added to -mm tree
Date: Wed, 17 Oct 2007 15:21:14 -0700
Message-ID: <200710172221.l9HMLE2V011276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59935 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758950AbXJQWV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 18:21:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@lst.de, jeffm@suse.com, mason@suse.com, vs@namesys.com


The patch titled
     reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#53: FILE: fs/reiserfs/bitmap.c:114:
$

ERROR: use tabs not spaces
#63: FILE: fs/reiserfs/bitmap.c:135:
$

ERROR: use tabs not spaces
#64: FILE: fs/reiserfs/bitmap.c:136:
$

ERROR: use tabs not spaces
#146: FILE: fs/reiserfs/journal.c:223:
$

ERROR: use tabs not spaces
#190: FILE: fs/reiserfs/journal.c:2312:
$

ERROR: use tabs not spaces
#191: FILE: fs/reiserfs/journal.c:2313:
$

ERROR: use tabs not spaces
#235: FILE: include/linux/reiserfs_fs.h:1738:
$

ERROR: "foo * bar" should be "foo *bar"
#235: FILE: include/linux/reiserfs_fs.h:1738:
+                        int bit_nr, int searchall, b_blocknr_t * next);

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: Chris Mason <mason@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/bitmap.c        |    6 +++---
 fs/reiserfs/journal.c       |    6 +++---
 include/linux/reiserfs_fs.h |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/reiserfs/bitmap.c~reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes fs/reiserfs/bitmap.c
--- a/fs/reiserfs/bitmap.c~reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes
+++ a/fs/reiserfs/bitmap.c
@@ -111,7 +111,7 @@ int is_reusable(struct super_block *s, b
 /* searches in journal structures for a given block number (bmap, off). If block
    is found in reiserfs journal it suggests next free block candidate to test. */
 static inline int is_block_in_journal(struct super_block *s, unsigned int bmap,
-                                      int off, int *next)
+				      int off, int *next)
 {
 	b_blocknr_t tmp;
 
@@ -132,8 +132,8 @@ static inline int is_block_in_journal(st
 /* it searches for a window of zero bits with given minimum and maximum lengths in one bitmap
  * block; */
 static int scan_bitmap_block(struct reiserfs_transaction_handle *th,
-                             unsigned int bmap_n, int *beg, int boundary,
-                             int min, int max, int unfm)
+			     unsigned int bmap_n, int *beg, int boundary,
+			     int min, int max, int unfm)
 {
 	struct super_block *s = th->t_super;
 	struct reiserfs_bitmap_info *bi = &SB_AP_BITMAP(s)[bmap_n];
diff -puN fs/reiserfs/journal.c~reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes
+++ a/fs/reiserfs/journal.c
@@ -220,7 +220,7 @@ static void allocate_bitmap_nodes(struct
 }
 
 static int set_bit_in_list_bitmap(struct super_block *p_s_sb,
-                                  b_blocknr_t block,
+				  b_blocknr_t block,
 				  struct reiserfs_list_bitmap *jb)
 {
 	unsigned int bmap_nr = block / (p_s_sb->s_blocksize << 3);
@@ -2309,8 +2309,8 @@ static int journal_read_transaction(stru
    from other places.
    Note: Do not use journal_getblk/sb_getblk functions here! */
 static struct buffer_head *reiserfs_breada(struct block_device *dev,
-                                           b_blocknr_t block, int bufsize,
-                                           b_blocknr_t max_block)
+					   b_blocknr_t block, int bufsize,
+					   b_blocknr_t max_block)
 {
 	struct buffer_head *bhlist[BUFNR];
 	unsigned int blocks = BUFNR;
diff -puN include/linux/reiserfs_fs.h~reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes
+++ a/include/linux/reiserfs_fs.h
@@ -1735,7 +1735,7 @@ int journal_mark_freed(struct reiserfs_t
 		       struct super_block *, b_blocknr_t blocknr);
 int journal_transaction_should_end(struct reiserfs_transaction_handle *, int);
 int reiserfs_in_journal(struct super_block *p_s_sb, unsigned int bmap_nr,
-                        int bit_nr, int searchall, b_blocknr_t * next);
+		        int bit_nr, int searchall, b_blocknr_t *next);
 int journal_begin(struct reiserfs_transaction_handle *,
 		  struct super_block *p_s_sb, unsigned long);
 int journal_join_abort(struct reiserfs_transaction_handle *,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold.patch
mm-dirty-balancing-for-tasks.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-do-not-take-callback_mutex.patch
writeback-dont-propagate-aop_writepage_activate.patch
softlockup-add-a-proc-tuning-parameter.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs.patch
core_pattern-fix-up-a-few-miscellaneous-bugs.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
deprecate-aout-elf-interpreters.patch
ext2-ext3-ext4-add-block-bitmap-validation.patch
binfmt_flat-warning-fixes.patch
i2o-fix-defined-but-not-used-build-warnings.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-right.patch
userc-ifdef-mq_bytes.patch
ext3-lighten-up-resize-transaction-requirements.patch
drivers-char-ip2-fix-used-uninitd-bug.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
ext2-reservations.patch
md-software-raid-autodetect-dev-list-not-array.patch
pnp-use-dev_info-dev_err-etc-in-core.patch
security-convert-lsm-into-a-static-interface.patch
ia64-fix-non-numa-build.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-cifs.patch
console-keyboard-events-and-accessibility.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-jg-warning-fixes.patch
git-jg-misc-powernow-fix.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
git-md-accel-fixup.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
qla2xxx-printk-fixes.patch
git-block-fixup.patch
sparc-support-for-new-termios.patch
git-unionfs.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-nfs-vs-git-unionfs.patch
git-v9fs-fixup.patch
git-watchdog-fixup.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
asm-i386-ioh-fix-constness.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
git-newsetup-fixup.patch
git-xfs.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
deprecate-smbfs-in-favour-of-cifs.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2-fix-3.patch
console-events-and-accessibility-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
stop-using-dma_xxbit_mask.patch
stop-using-dma_xxbit_mask-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
sync_sb_inodes-propagate-errors.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
reiserfs-fix-up-lockdep-warnings-checkpatch-fixes.patch
reiserfs-use-is_reusable-to-catch-corruption-checkpatch-fixes.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes.patch
reiserfs-remove-first_zero_hint-checkpatch-fixes.patch
reiserfs-ignore-on-disk-s_bmap_nr-value-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
