From: akpm@osdl.org
Subject: + reiser4-vs-git-block.patch added to -mm tree
Date: Wed, 03 Jan 2007 15:25:08 -0800
Message-ID: <200701032325.l03NPW8W002654@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59752 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbXACX0B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 18:26:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, edward@namesys.com, jens.axboe@oracle.com, vs@namesys.com


The patch titled
     reiser4-vs-git-block
has been added to the -mm tree.  Its filename is
     reiser4-vs-git-block.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiser4-vs-git-block
From: Andrew Morton <akpm@osdl.org>

Attempt to fix reiser4 for git-block changes.  And for some changes I made to
fs-writeback.c return values.

Cc: Vladimir Saveliev <vs@namesys.com>
Cc: Edward Shishkin <edward@namesys.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/flush_queue.c  |    3 ---
 fs/reiser4/page_cache.c   |    8 --------
 fs/reiser4/status_flags.c |    2 --
 fs/reiser4/super_ops.c    |   10 ++++++----
 fs/reiser4/vfs_ops.c      |    1 -
 5 files changed, 6 insertions(+), 18 deletions(-)

diff -puN fs/reiser4/page_cache.c~reiser4-vs-git-block fs/reiser4/page_cache.c
--- a/fs/reiser4/page_cache.c~reiser4-vs-git-block
+++ a/fs/reiser4/page_cache.c
@@ -569,14 +569,6 @@ static struct address_space_operations f
 	.writepage = reiser4_writepage,
 	/* this is called to read formatted node */
 	.readpage = formatted_readpage,
-	/* ->sync_page() method of fake inode address space operations. Called
-	   from wait_on_page() and lock_page().
-
-	   This is most annoyingly misnomered method. Actually it is called
-	   from wait_on_page_bit() and lock_page() and its purpose is to
-	   actually start io by jabbing device drivers.
-	 */
-	.sync_page = block_sync_page,
 	/* Write back some dirty pages from this mapping. Called from sync.
 	   called during sync (pdflush) */
 	.writepages = writepages_fake,
diff -puN fs/reiser4/flush_queue.c~reiser4-vs-git-block fs/reiser4/flush_queue.c
--- a/fs/reiser4/flush_queue.c~reiser4-vs-git-block
+++ a/fs/reiser4/flush_queue.c
@@ -236,9 +236,6 @@ static int wait_io(flush_queue_t * fq, i
 
 		super = reiser4_get_current_sb();
 
-		/* FIXME: this is instead of blk_run_queues() */
-		blk_run_address_space(reiser4_get_super_fake(super)->i_mapping);
-
 		if (!(super->s_flags & MS_RDONLY))
 			wait_event(fq->wait, atomic_read(&fq->nr_submitted) == 0);
 
diff -puN fs/reiser4/super_ops.c~reiser4-vs-git-block fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-vs-git-block
+++ a/fs/reiser4/super_ops.c
@@ -394,15 +394,16 @@ static void reiser4_clear_inode(struct i
  * mapping - dirty pages get into atoms. Writeout is called to flush some
  * atoms.
  */
-static void reiser4_sync_inodes(struct super_block *super,
+static int reiser4_sync_inodes(struct super_block *super,
 				struct writeback_control *wbc)
 {
 	reiser4_context *ctx;
 	long to_write;
+	int ret;
 
 	if (wbc->for_kupdate)
 		/* reiser4 has its own means of periodical write-out */
-		return;
+		return 0;
 
 	to_write = wbc->nr_to_write;
 	assert("vs-49", wbc->older_than_this == NULL);
@@ -410,14 +411,14 @@ static void reiser4_sync_inodes(struct s
 	ctx = reiser4_init_context(super);
 	if (IS_ERR(ctx)) {
 		warning("vs-13", "failed to init context");
-		return;
+		return PTR_ERR(ctx);
 	}
 
 	/*
 	 * call reiser4_writepages for each of dirty inodes to turn dirty pages
 	 * into transactions if they were not yet.
 	 */
-	generic_sync_sb_inodes(super, wbc);
+	ret = generic_sync_sb_inodes(super, wbc);
 
 	/* flush goes here */
 	wbc->nr_to_write = to_write;
@@ -426,6 +427,7 @@ static void reiser4_sync_inodes(struct s
 	/* avoid recursive calls to ->sync_inodes */
 	context_set_commit_async(ctx);
 	reiser4_exit_context(ctx);
+	return ret;
 }
 
 /**
diff -puN fs/reiser4/status_flags.c~reiser4-vs-git-block fs/reiser4/status_flags.c
--- a/fs/reiser4/status_flags.c~reiser4-vs-git-block
+++ a/fs/reiser4/status_flags.c
@@ -63,7 +63,6 @@ int reiser4_status_init(reiser4_block_nr
 	}
 	lock_page(page);
 	submit_bio(READ, bio);
-	blk_run_address_space(reiser4_get_super_fake(sb)->i_mapping);
 	wait_on_page_locked(page);
 	if (!PageUptodate(page)) {
 		warning("green-2007",
@@ -158,7 +157,6 @@ int reiser4_status_write(__u64 status, _
 	lock_page(get_super_private(sb)->status_page);	// Safe as nobody should touch our page.
 	/* We can block now, but we have no other choice anyway */
 	submit_bio(WRITE, bio);
-	blk_run_address_space(reiser4_get_super_fake(sb)->i_mapping);
 	return 0;		// We do not wait for io to finish.
 }
 
diff -puN fs/reiser4/vfs_ops.c~reiser4-vs-git-block fs/reiser4/vfs_ops.c
--- a/fs/reiser4/vfs_ops.c~reiser4-vs-git-block
+++ a/fs/reiser4/vfs_ops.c
@@ -168,7 +168,6 @@ void reiser4_writeout(struct super_block
 		/* do not put more requests to overload write queue */
 		if (wbc->nonblocking &&
 		    bdi_write_congested(mapping->backing_dev_info)) {
-			blk_run_address_space(mapping);
 			wbc->encountered_congestion = 1;
 			break;
 		}
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
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
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
reiser4-vs-git-block.patch
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
