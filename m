From: akpm@linux-foundation.org
Subject: [merged] writeback-integrated-background-writeback-work.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:25 -0800
Message-ID: <201101142247.p0EMlF7W004977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab1ANWrw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:47:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hch@lst.de, jengelh@medozas.de, mm-commits@vger.kernel.org


The patch titled
     writeback: integrated background writeback work
has been removed from the -mm tree.  Its filename was
     writeback-integrated-background-writeback-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: integrated background writeback work
From: Jan Kara <jack@suse.cz>

Check whether background writeback is needed after finishing each work.

When bdi flusher thread finishes doing some work check whether any kind of
background writeback needs to be done (either because
dirty_background_ratio is exceeded or because we need to start flushing
old inodes).  If so, just do background write back.

This way, bdi_start_background_writeback() just needs to wake up the
flusher thread.  It will do background writeback as soon as there is no
other work.

This is a preparatory patch for the next patch which stops background
writeback as soon as there is other work to do.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de> 
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   61 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 15 deletions(-)

diff -puN fs/fs-writeback.c~writeback-integrated-background-writeback-work fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-integrated-background-writeback-work
+++ a/fs/fs-writeback.c
@@ -84,13 +84,9 @@ static inline struct inode *wb_inode(str
 	return list_entry(head, struct inode, i_wb_list);
 }
 
-static void bdi_queue_work(struct backing_dev_info *bdi,
-		struct wb_writeback_work *work)
+/* Wakeup flusher thread or forker thread to fork it. Requires bdi->wb_lock. */
+static void bdi_wakeup_flusher(struct backing_dev_info *bdi)
 {
-	trace_writeback_queue(bdi, work);
-
-	spin_lock_bh(&bdi->wb_lock);
-	list_add_tail(&work->list, &bdi->work_list);
 	if (bdi->wb.task) {
 		wake_up_process(bdi->wb.task);
 	} else {
@@ -98,15 +94,26 @@ static void bdi_queue_work(struct backin
 		 * The bdi thread isn't there, wake up the forker thread which
 		 * will create and run it.
 		 */
-		trace_writeback_nothread(bdi, work);
 		wake_up_process(default_backing_dev_info.wb.task);
 	}
+}
+
+static void bdi_queue_work(struct backing_dev_info *bdi,
+			   struct wb_writeback_work *work)
+{
+	trace_writeback_queue(bdi, work);
+
+	spin_lock_bh(&bdi->wb_lock);
+	list_add_tail(&work->list, &bdi->work_list);
+	if (!bdi->wb.task)
+		trace_writeback_nothread(bdi, work);
+	bdi_wakeup_flusher(bdi);
 	spin_unlock_bh(&bdi->wb_lock);
 }
 
 static void
 __bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
-		bool range_cyclic, bool for_background)
+		      bool range_cyclic)
 {
 	struct wb_writeback_work *work;
 
@@ -126,7 +133,6 @@ __bdi_start_writeback(struct backing_dev
 	work->sync_mode	= WB_SYNC_NONE;
 	work->nr_pages	= nr_pages;
 	work->range_cyclic = range_cyclic;
-	work->for_background = for_background;
 
 	bdi_queue_work(bdi, work);
 }
@@ -144,7 +150,7 @@ __bdi_start_writeback(struct backing_dev
  */
 void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages)
 {
-	__bdi_start_writeback(bdi, nr_pages, true, false);
+	__bdi_start_writeback(bdi, nr_pages, true);
 }
 
 /**
@@ -152,13 +158,20 @@ void bdi_start_writeback(struct backing_
  * @bdi: the backing device to write from
  *
  * Description:
- *   This does WB_SYNC_NONE background writeback. The IO is only
- *   started when this function returns, we make no guarentees on
- *   completion. Caller need not hold sb s_umount semaphore.
+ *   This makes sure WB_SYNC_NONE background writeback happens. When
+ *   this function returns, it is only guaranteed that for given BDI
+ *   some IO is happening if we are over background dirty threshold.
+ *   Caller need not hold sb s_umount semaphore.
  */
 void bdi_start_background_writeback(struct backing_dev_info *bdi)
 {
-	__bdi_start_writeback(bdi, LONG_MAX, true, true);
+	/*
+	 * We just wake up the flusher thread. It will perform background
+	 * writeback as soon as there is no other work to do.
+	 */
+	spin_lock_bh(&bdi->wb_lock);
+	bdi_wakeup_flusher(bdi);
+	spin_unlock_bh(&bdi->wb_lock);
 }
 
 /*
@@ -718,6 +731,23 @@ static unsigned long get_nr_dirty_pages(
 		get_nr_dirty_inodes();
 }
 
+static long wb_check_background_flush(struct bdi_writeback *wb)
+{
+	if (over_bground_thresh()) {
+
+		struct wb_writeback_work work = {
+			.nr_pages	= LONG_MAX,
+			.sync_mode	= WB_SYNC_NONE,
+			.for_background	= 1,
+			.range_cyclic	= 1,
+		};
+
+		return wb_writeback(wb, &work);
+	}
+
+	return 0;
+}
+
 static long wb_check_old_data_flush(struct bdi_writeback *wb)
 {
 	unsigned long expired;
@@ -787,6 +817,7 @@ long wb_do_writeback(struct bdi_writebac
 	 * Check for periodic writeback, kupdated() style
 	 */
 	wrote += wb_check_old_data_flush(wb);
+	wrote += wb_check_background_flush(wb);
 	clear_bit(BDI_writeback_running, &wb->bdi->state);
 
 	return wrote;
@@ -873,7 +904,7 @@ void wakeup_flusher_threads(long nr_page
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
 		if (!bdi_has_dirty_io(bdi))
 			continue;
-		__bdi_start_writeback(bdi, nr_pages, false, false);
+		__bdi_start_writeback(bdi, nr_pages, false);
 	}
 	rcu_read_unlock();
 }
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch

