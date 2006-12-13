From: akpm@osdl.org
Subject: - optimize-o_direct-on-block-device-v3-tweak.patch removed from -mm tree
Date: Tue, 12 Dec 2006 23:14:55 -0800
Message-ID: <200612130714.kBD7EtIk031112@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59293 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932596AbWLMHRH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 02:17:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, hch@lst.de, kenneth.w.chen@intel.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     optimize-o_direct-on-block-device-v3 tweak
has been removed from the -mm tree.  Its filename was
     optimize-o_direct-on-block-device-v3-tweak.patch

This patch was dropped because it was folded into optimize-o_direct-on-block-device-v3.patch

------------------------------------------------------
Subject: optimize-o_direct-on-block-device-v3 tweak
From: Andrew Morton <akpm@osdl.org>

gcc generates crap code when you do this.  Saves seven bytes of text!

Cc: Ken Chen <kenneth.w.chen@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/block_dev.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~optimize-o_direct-on-block-device-v3-tweak fs/block_dev.c
--- a/fs/block_dev.c~optimize-o_direct-on-block-device-v3-tweak
+++ a/fs/block_dev.c
@@ -209,7 +209,10 @@ blkdev_direct_IO(int rw, struct kiocb *i
 	struct bio *bio;
 	atomic_t *bio_count = &iocb->ki_bio_count;
 	struct page *page;
-	struct pvec pvec = { .nr = 0, .idx = 0, };
+	struct pvec pvec;
+
+	pvec.nr = 0;
+	pvec.idx = 0;
 
 	if (pos & blocksize_mask)
 		return -EINVAL;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
x86-smp-export-smp_num_siblings-for-oprofile.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support.patch
optimize-o_direct-on-block-device-v3.patch
optimize-o_direct-on-block-device-v3-tweak.patch
add-retain_initrd-boot-option-tweak.patch
lockdep-fix-possible-races-while-disabling-lock-debugging-fix.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
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
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
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
squash-ipc-warnings.patch
squash-udf-warnings.patch

