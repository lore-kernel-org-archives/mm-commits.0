From: akpm@linux-foundation.org
Subject: [merged] bdi-avoid-oops-on-device-removal.patch removed from -mm
 tree
Date: Fri, 04 Apr 2014 12:29:20 -0700
Message-ID: <533f0810.nQG7QofEVpuqAdOT%akpm__6098.89682750708$1396639771$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaDDT3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org, dbasehore@chromium.org, axboe@kernel.dk, jack@suse.cz

Subject: [merged] bdi-avoid-oops-on-device-removal.patch removed from -mm tree
To: jack@suse.cz,axboe@kernel.dk,dbasehore@chromium.org,stable@vger.kernel.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:20 -0700


The patch titled
     Subject: bdi: avoid oops on device removal
has been removed from the -mm tree.  Its filename was
     bdi-avoid-oops-on-device-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: bdi: avoid oops on device removal

After 839a8e8660b67 ("writeback: replace custom worker pool implementation
with unbound workqueue") when device is removed while we are writing to it
we crash in bdi_writeback_workfn() -> set_worker_desc() because bdi->dev
is NULL.  This can happen because even though bdi_unregister() cancels all
pending flushing work, nothing really prevents new ones from being queued
from balance_dirty_pages() or other places.

Fix the problem by clearing BDI_registered bit in bdi_unregister() and
checking it before scheduling of any flushing work.

Fixes: 839a8e8660b6777e7fe4e80af1a048aebe2b5977

Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Derek Basehore <dbasehore@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c           |   23 ++++++++++++++++++-----
 include/linux/backing-dev.h |    2 +-
 mm/backing-dev.c            |   13 +++++++++----
 3 files changed, 28 insertions(+), 10 deletions(-)

diff -puN fs/fs-writeback.c~bdi-avoid-oops-on-device-removal fs/fs-writeback.c
--- a/fs/fs-writeback.c~bdi-avoid-oops-on-device-removal
+++ a/fs/fs-writeback.c
@@ -89,16 +89,29 @@ static inline struct inode *wb_inode(str
 #define CREATE_TRACE_POINTS
 #include <trace/events/writeback.h>
 
+static void bdi_wakeup_thread(struct backing_dev_info *bdi)
+{
+	spin_lock_bh(&bdi->wb_lock);
+	if (test_bit(BDI_registered, &bdi->state))
+		mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
+	spin_unlock_bh(&bdi->wb_lock);
+}
+
 static void bdi_queue_work(struct backing_dev_info *bdi,
 			   struct wb_writeback_work *work)
 {
 	trace_writeback_queue(bdi, work);
 
 	spin_lock_bh(&bdi->wb_lock);
+	if (!test_bit(BDI_registered, &bdi->state)) {
+		if (work->done)
+			complete(work->done);
+		goto out_unlock;
+	}
 	list_add_tail(&work->list, &bdi->work_list);
-	spin_unlock_bh(&bdi->wb_lock);
-
 	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
+out_unlock:
+	spin_unlock_bh(&bdi->wb_lock);
 }
 
 static void
@@ -114,7 +127,7 @@ __bdi_start_writeback(struct backing_dev
 	work = kzalloc(sizeof(*work), GFP_ATOMIC);
 	if (!work) {
 		trace_writeback_nowork(bdi);
-		mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
+		bdi_wakeup_thread(bdi);
 		return;
 	}
 
@@ -161,7 +174,7 @@ void bdi_start_background_writeback(stru
 	 * writeback as soon as there is no other work to do.
 	 */
 	trace_writeback_wake_background(bdi);
-	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
+	bdi_wakeup_thread(bdi);
 }
 
 /*
@@ -1017,7 +1030,7 @@ void bdi_writeback_workfn(struct work_st
 	current->flags |= PF_SWAPWRITE;
 
 	if (likely(!current_is_workqueue_rescuer() ||
-		   list_empty(&bdi->bdi_list))) {
+		   !test_bit(BDI_registered, &bdi->state))) {
 		/*
 		 * The normal path.  Keep writing back @bdi until its
 		 * work_list is empty.  Note that this path is also taken
diff -puN include/linux/backing-dev.h~bdi-avoid-oops-on-device-removal include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~bdi-avoid-oops-on-device-removal
+++ a/include/linux/backing-dev.h
@@ -95,7 +95,7 @@ struct backing_dev_info {
 	unsigned int max_ratio, max_prop_frac;
 
 	struct bdi_writeback wb;  /* default writeback info for this bdi */
-	spinlock_t wb_lock;	  /* protects work_list */
+	spinlock_t wb_lock;	  /* protects work_list & wb.dwork scheduling */
 
 	struct list_head work_list;
 
diff -puN mm/backing-dev.c~bdi-avoid-oops-on-device-removal mm/backing-dev.c
--- a/mm/backing-dev.c~bdi-avoid-oops-on-device-removal
+++ a/mm/backing-dev.c
@@ -297,7 +297,10 @@ void bdi_wakeup_thread_delayed(struct ba
 	unsigned long timeout;
 
 	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
-	queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
+	spin_lock_bh(&bdi->wb_lock);
+	if (test_bit(BDI_registered, &bdi->state))
+		queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
+	spin_unlock_bh(&bdi->wb_lock);
 }
 
 /*
@@ -310,9 +313,6 @@ static void bdi_remove_from_list(struct
 	spin_unlock_bh(&bdi_lock);
 
 	synchronize_rcu_expedited();
-
-	/* bdi_list is now unused, clear it to mark @bdi dying */
-	INIT_LIST_HEAD(&bdi->bdi_list);
 }
 
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
@@ -363,6 +363,11 @@ static void bdi_wb_shutdown(struct backi
 	 */
 	bdi_remove_from_list(bdi);
 
+	/* Make sure nobody queues further work */
+	spin_lock_bh(&bdi->wb_lock);
+	clear_bit(BDI_registered, &bdi->state);
+	spin_unlock_bh(&bdi->wb_lock);
+
 	/*
 	 * Drain work list and shutdown the delayed_work.  At this point,
 	 * @bdi->bdi_list is empty telling bdi_Writeback_workfn() that @bdi
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

