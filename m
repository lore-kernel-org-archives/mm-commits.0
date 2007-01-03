From: akpm@osdl.org
Subject: + sync_sb_inodes-propagate-errors.patch added to -mm tree
Date: Wed, 03 Jan 2007 14:57:01 -0800
Message-ID: <200701032257.l03Mv155001889@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58062 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbXACW5F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 17:57:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, guichaz@yahoo.fr


The patch titled
     sync_sb_inodes(): propagate errors
has been added to the -mm tree.  Its filename is
     sync_sb_inodes-propagate-errors.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sync_sb_inodes(): propagate errors
From: Andrew Morton <akpm@osdl.org>

Guillame points out that sync_sb_inodes() is failing to propagate error codes
back.  Fix that, and make several other void-returning functions not drop
reportable error codes.

Cc: Guillaume Chazarain <guichaz@yahoo.fr>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/fs-writeback.c         |   55 ++++++++++++++++++++++++++----------
 include/linux/writeback.h |    6 +--
 2 files changed, 44 insertions(+), 17 deletions(-)

diff -puN fs/fs-writeback.c~sync_sb_inodes-propagate-errors fs/fs-writeback.c
--- a/fs/fs-writeback.c~sync_sb_inodes-propagate-errors
+++ a/fs/fs-writeback.c
@@ -302,15 +302,18 @@ __writeback_single_inode(struct inode *i
  * on the writer throttling path, and we get decent balancing between many
  * throttled threads: we don't want them all piling up on __wait_on_inode.
  */
-static void
+static int
 sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 {
 	const unsigned long start = jiffies;	/* livelock avoidance */
+	int ret = 0;
 
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
 		list_splice_init(&sb->s_dirty, &sb->s_io);
 
 	while (!list_empty(&sb->s_io)) {
+		int err;
+
 		struct inode *inode = list_entry(sb->s_io.prev,
 						struct inode, i_list);
 		struct address_space *mapping = inode->i_mapping;
@@ -365,7 +368,9 @@ sync_sb_inodes(struct super_block *sb, s
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
@@ -386,7 +391,7 @@ sync_sb_inodes(struct super_block *sb, s
 		if (wbc->nr_to_write <= 0)
 			break;
 	}
-	return;		/* Leave any unwritten inodes on s_io */
+	return ret;		/* Leave any unwritten inodes on s_io */
 }
 
 /*
@@ -408,10 +413,10 @@ sync_sb_inodes(struct super_block *sb, s
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
@@ -429,9 +434,13 @@ restart:
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
@@ -443,6 +452,7 @@ restart:
 			break;
 	}
 	spin_unlock(&sb_lock);
+	return ret;
 }
 
 /*
@@ -456,7 +466,7 @@ restart:
  * We add in the number of potentially dirty inodes, because each inode write
  * can dirty pagecache in the underlying blockdev.
  */
-void sync_inodes_sb(struct super_block *sb, int wait)
+int sync_inodes_sb(struct super_block *sb, int wait)
 {
 	struct writeback_control wbc = {
 		.sync_mode	= wait ? WB_SYNC_ALL : WB_SYNC_HOLD,
@@ -465,14 +475,16 @@ void sync_inodes_sb(struct super_block *
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
@@ -508,13 +520,16 @@ static void set_sb_syncing(int val)
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
@@ -522,8 +537,12 @@ restart:
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
@@ -531,17 +550,25 @@ restart:
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
@@ -64,11 +64,11 @@ struct writeback_control {
 /*
  * fs/fs-writeback.c
  */	
-void writeback_inodes(struct writeback_control *wbc);
+int writeback_inodes(struct writeback_control *wbc);
 void wake_up_inode(struct inode *inode);
 int inode_wait(void *);
-void sync_inodes_sb(struct super_block *, int wait);
-void sync_inodes(int wait);
+int sync_inodes_sb(struct super_block *, int wait);
+int sync_inodes(int wait);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
_

Patches currently in -mm which might be from akpm@osdl.org are

start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again-fix.patch
kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs-fix.patch
pci-prevent-down_read-when-pci_devices-is-empty-fix.patch
atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
pci-avoid-taking-pci_bus_sem-early-in-boot.patch
down_write-preserve-local-irqs.patch
shrink_all_memory-fix-lru_pages-handling.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
sound-hda-detect-alc883-on-msi-k9a-platinum-motherboards.patch
git-agpgart.patch
cifs-sprintf-fix.patch
git-cpufreq.patch
fix-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-ieee1394.patch
git-input.patch
git-libata-all.patch
git-libata-all-fixup.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
git-ubi-mtd_read-arg-fix.patch
ubi-missing-include.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
add-memcpy_uncached_read.patch
add-i386-idle-notifier-take-3-fix.patch
fix-fake-numa-for-x86_64-machines-with-big-io-hole-fix.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
bluetooth-blacklist-lenovo-r60e.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
remove-invalidate_inode_pages.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
block_write_full_page-handle-enospc.patch
vmi-versus-hrtimers.patch
gtod-persistent-clock-support-i386.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
debugging-feature-proc-timer_list-warning-fix.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
fsaio-filesystem-aio-read-tidy.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
