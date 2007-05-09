From: akpm@linux-foundation.org
Subject: - kblockd-use-flush_work.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:06 -0700
Message-ID: <200705092151.l49Lp6Ad002854@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758519AbXEIVwB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@suse.de, dhowells@redhat.com, macro@linux-mips.org, nickpiggin@yahoo.com.au, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     kblockd: use flush_work
has been removed from the -mm tree.  Its filename was
     kblockd-use-flush_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kblockd: use flush_work
From: Andrew Morton <akpm@osdl.org>

Switch the kblockd flushing from a global flush to a more specific
flush_work().

(akpm: bypassed maintainers, sorry.  There are other patches which depend on
this)

Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Jens Axboe <axboe@suse.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/as-iosched.c     |    2 +-
 block/ll_rw_blk.c      |    7 +++----
 include/linux/blkdev.h |    2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff -puN block/as-iosched.c~kblockd-use-flush_work block/as-iosched.c
--- a/block/as-iosched.c~kblockd-use-flush_work
+++ a/block/as-iosched.c
@@ -1306,7 +1306,7 @@ static void as_exit_queue(elevator_t *e)
 	struct as_data *ad = e->elevator_data;
 
 	del_timer_sync(&ad->antic_timer);
-	kblockd_flush();
+	kblockd_flush_work(&ad->antic_work);
 
 	BUG_ON(!list_empty(&ad->fifo_list[REQ_SYNC]));
 	BUG_ON(!list_empty(&ad->fifo_list[REQ_ASYNC]));
diff -puN block/ll_rw_blk.c~kblockd-use-flush_work block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~kblockd-use-flush_work
+++ a/block/ll_rw_blk.c
@@ -1712,7 +1712,6 @@ EXPORT_SYMBOL(blk_stop_queue);
 void blk_sync_queue(struct request_queue *q)
 {
 	del_timer_sync(&q->unplug_timer);
-	kblockd_flush();
 }
 EXPORT_SYMBOL(blk_sync_queue);
 
@@ -3632,11 +3631,11 @@ int kblockd_schedule_work(struct work_st
 
 EXPORT_SYMBOL(kblockd_schedule_work);
 
-void kblockd_flush(void)
+void kblockd_flush_work(struct work_struct *work)
 {
-	flush_workqueue(kblockd_workqueue);
+	flush_work(kblockd_workqueue, work);
 }
-EXPORT_SYMBOL(kblockd_flush);
+EXPORT_SYMBOL(kblockd_flush_work);
 
 int __init blk_dev_init(void)
 {
diff -puN include/linux/blkdev.h~kblockd-use-flush_work include/linux/blkdev.h
--- a/include/linux/blkdev.h~kblockd-use-flush_work
+++ a/include/linux/blkdev.h
@@ -854,7 +854,7 @@ static inline void put_dev_sector(Sector
 
 struct work_struct;
 int kblockd_schedule_work(struct work_struct *work);
-void kblockd_flush(void);
+void kblockd_flush_work(struct work_struct *work);
 
 #define MODULE_ALIAS_BLOCKDEV(major,minor) \
 	MODULE_ALIAS("block-major-" __stringify(major) "-" __stringify(minor))
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
git-ieee1394.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
move-page-writeback-acounting-out-of-macros.patch
ext2-reservations.patch
mm-implement-swap-prefetching.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
