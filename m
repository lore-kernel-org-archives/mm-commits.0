From: akpm@linux-foundation.org
Subject: - sync_sb_inodes-propagate-errors.patch removed from -mm tree
Date: Tue, 08 Jan 2008 23:19:18 -0800
Message-ID: <200801090718.m097IwZV021856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48240 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbYAIHTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2008 02:19:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guichaz@yahoo.fr, mm-commits@vger.kernel.org


The patch titled
     sync_sb_inodes(): propagate errors
has been removed from the -mm tree.  Its filename was
     sync_sb_inodes-propagate-errors.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sync_sb_inodes(): propagate errors
From: Andrew Morton <akpm@linux-foundation.org>

Guillame points out that sync_sb_inodes() is failing to propagate error codes
back.  Fix that, and make several other void-returning functions not drop
reportable error codes.

Cc: Guillaume Chazarain <guichaz@yahoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |   54 ++++++++++++++++++++++++++----------
 include/linux/writeback.h |    6 ++--
 2 files changed, 43 insertions(+), 17 deletions(-)

diff -puN fs/fs-writeback.c~sync_sb_inodes-propagate-errors fs/fs-writeback.c
--- a/fs/fs-writeback.c~sync_sb_inodes-propagate-errors
+++ a/fs/fs-writeback.c
@@ -392,10 +392,11 @@ __writeback_single_inode(struct inode *i
  * on the writer throttling path, and we get decent balancing between many
  * throttled threads: we don't want them all piling up on inode_sync_wait.
  */
-static void
+static int
 sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 {
 	const unsigned long start = jiffies;	/* livelock avoidance */
+	int ret = 0;
 
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
 		queue_io(sb, wbc->older_than_this);
@@ -406,6 +407,7 @@ sync_sb_inodes(struct super_block *sb, s
 		struct address_space *mapping = inode->i_mapping;
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		long pages_skipped;
+		int err;
 
 		if (!bdi_cap_writeback_dirty(bdi)) {
 			redirty_tail(inode);
@@ -450,7 +452,9 @@ sync_sb_inodes(struct super_block *sb, s
 		BUG_ON(inode->i_state & I_FREEING);
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
-		__writeback_single_inode(inode, wbc);
+		err = __writeback_single_inode(inode, wbc);
+		if (!ret)
+			ret = err;
 		if (wbc->sync_mode == WB_SYNC_HOLD) {
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &sb->s_dirty);
@@ -473,7 +477,7 @@ sync_sb_inodes(struct super_block *sb, s
 	}
 	if (!list_empty(&sb->s_more_io))
 		wbc->more_io = 1;
-	return;		/* Leave any unwritten inodes on s_io */
+	return ret;		/* Leave any unwritten inodes on s_io */
 }
 
 /*
@@ -495,10 +499,10 @@ sync_sb_inodes(struct super_block *sb, s
  * sync_sb_inodes will seekout the blockdev which matches `bdi'.  Maybe not
  * super-efficient but we're about to do a ton of I/O...
  */
-void
-writeback_inodes(struct writeback_control *wbc)
+int writeback_inodes(struct writeback_control *wbc)
 {
 	struct super_block *sb;
+	int ret = 0;
 
 	might_sleep();
 	spin_lock(&sb_lock);
@@ -515,9 +519,13 @@ restart:
 			 */
 			if (down_read_trylock(&sb->s_umount)) {
 				if (sb->s_root) {
+					int err;
+
 					spin_lock(&inode_lock);
-					sync_sb_inodes(sb, wbc);
+					err = sync_sb_inodes(sb, wbc);
 					spin_unlock(&inode_lock);
+					if (!ret)
+						ret = err;
 				}
 				up_read(&sb->s_umount);
 			}
@@ -529,6 +537,7 @@ restart:
 			break;
 	}
 	spin_unlock(&sb_lock);
+	return ret;
 }
 
 /*
@@ -542,7 +551,7 @@ restart:
  * We add in the number of potentially dirty inodes, because each inode write
  * can dirty pagecache in the underlying blockdev.
  */
-void sync_inodes_sb(struct super_block *sb, int wait)
+int sync_inodes_sb(struct super_block *sb, int wait)
 {
 	struct writeback_control wbc = {
 		.sync_mode	= wait ? WB_SYNC_ALL : WB_SYNC_HOLD,
@@ -551,14 +560,16 @@ void sync_inodes_sb(struct super_block *
 	};
 	unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
 	unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
+	int ret;
 
 	wbc.nr_to_write = nr_dirty + nr_unstable +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused) +
 			nr_dirty + nr_unstable;
 	wbc.nr_to_write += wbc.nr_to_write / 2;		/* Bit more for luck */
 	spin_lock(&inode_lock);
-	sync_sb_inodes(sb, &wbc);
+	ret = sync_sb_inodes(sb, &wbc);
 	spin_unlock(&inode_lock);
+	return ret;
 }
 
 /*
@@ -592,13 +603,16 @@ static void set_sb_syncing(int val)
  * outstanding dirty inodes, the writeback goes block-at-a-time within the
  * filesystem's write_inode().  This is extremely slow.
  */
-static void __sync_inodes(int wait)
+static int __sync_inodes(int wait)
 {
 	struct super_block *sb;
+	int ret = 0;
 
 	spin_lock(&sb_lock);
 restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
+		int err;
+
 		if (sb->s_syncing)
 			continue;
 		sb->s_syncing = 1;
@@ -606,8 +620,12 @@ restart:
 		spin_unlock(&sb_lock);
 		down_read(&sb->s_umount);
 		if (sb->s_root) {
-			sync_inodes_sb(sb, wait);
-			sync_blockdev(sb->s_bdev);
+			err = sync_inodes_sb(sb, wait);
+			if (!ret)
+				ret = err;
+			err = sync_blockdev(sb->s_bdev);
+			if (!ret)
+				ret = err;
 		}
 		up_read(&sb->s_umount);
 		spin_lock(&sb_lock);
@@ -615,17 +633,25 @@ restart:
 			goto restart;
 	}
 	spin_unlock(&sb_lock);
+	return ret;
 }
 
-void sync_inodes(int wait)
+int sync_inodes(int wait)
 {
+	int ret;
+
 	set_sb_syncing(0);
-	__sync_inodes(0);
+	ret = __sync_inodes(0);
 
 	if (wait) {
+		int err;
+
 		set_sb_syncing(0);
-		__sync_inodes(1);
+		err = __sync_inodes(1);
+		if (!ret)
+			ret = err;
 	}
+	return ret;
 }
 
 /**
diff -puN include/linux/writeback.h~sync_sb_inodes-propagate-errors include/linux/writeback.h
--- a/include/linux/writeback.h~sync_sb_inodes-propagate-errors
+++ a/include/linux/writeback.h
@@ -68,10 +68,10 @@ struct writeback_control {
 /*
  * fs/fs-writeback.c
  */	
-void writeback_inodes(struct writeback_control *wbc);
+int writeback_inodes(struct writeback_control *wbc);
 int inode_wait(void *);
-void sync_inodes_sb(struct super_block *, int wait);
-void sync_inodes(int wait);
+int sync_inodes_sb(struct super_block *, int wait);
+int sync_inodes(int wait);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

pl2303-fix-mode-switching-regression-fix.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration-checkpatch-fixes.patch
timerfd-v3-new-timerfd-api-ia64-fix.patch
timerfd-v3-new-timerfd-api-m68k-fix.patch
timerfd-v3-new-timerfd-api-mips-fix.patch
timerfd-v3-new-timerfd-api-arch-fixes.patch
timerfd-v3-new-timerfd-api-powerpc-fix.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-agpgart-intel-agp-dont-zero-an-already-registered-resource-during-resume.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
kernel-auditc-warning-fix.patch
git-cifs.patch
git-cpufreq.patch
git-powerpc.patch
git-powerpc-fixup.patch
revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
intel-agp-enable-i915-recognition.patch
drm-convert-from-nopage-to-fault-checkpatch-fixes.patch
git-dvb.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
git-hid.patch
revert-git-hrt.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-versus-driver-tree.patch
git-kbuild.patch
git-kvm.patch
kvm-ist-kaput.patch
git-libata-all.patch
git-libata-all-fix-pata_winbond-borkage.patch
git-libata-all-wtf.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
git-md-accel.patch
git-mmc.patch
git-mtd.patch
git-net.patch
git-net-vs-git-lblnet.patch
git-net-vs-git-lblnet-2.patch
git-netdev-all.patch
git-net-vs-git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
backlight-omap1-backlight-driver.patch
git-battery.patch
bluetooth-uninlining.patch
net-sunrpc-schedc-revert-git-net-changes.patch
net-sunrpc-schedc-reapply-git-net-changes.patch
net-sunrpc-svcsockc-revert-git-nfs-changes.patch
git-nfsd.patch
net-sunrpc-svcsockc-reapply-git-nfs-changes.patch
serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh-checkpatch-fixes.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
git-sched.patch
git-sched-fixup.patch
git-sh.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
9p-util-fix-semaphore-handling.patch
git-watchdog.patch
git-watchdog-fixup.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-x86-makefile-revert-git-kvm-change.patch
git-x86.patch
arch-x86-makefile-reapply-git-kvm-change.patch
git-x86-fixup.patch
git-x86-fix-doubly-merged-patch.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-xtensa.patch
bonding-locking-fix.patch
usbtouchscreen-fix-buffer-overflow-make-more-egalax-work-checkpatch-fixes.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-add-proc-kpagecount-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix-2-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
mm-remove-fastcall-from-mm-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
alpha-atomic_add_return-should-return-int.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard-fix.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec-fix.patch
avoid-overflows-in-kernel-timec-fix.patch
export-iov_shorten-for-ext4s-use-fix.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
sync_sb_inodes-propagate-errors.patch
add-have_oprofile.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
ext4-mm-ext4_store_maxbytes_for_bitmaped_files-warning-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page-warning-fix.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
