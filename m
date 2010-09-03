From: akpm@linux-foundation.org
Subject: + some-random-patch-from-jens.patch added to -mm tree
Date: Fri, 03 Sep 2010 14:41:56 -0700
Message-ID: <201009032141.o83LfueZ013848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757571Ab0ICVnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 17:43:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axboe@kernel.dk, fengguang.wu@intel.com, florian@mickler.org, lkml.collector@gmail.com, miklos@szeredi.hu, richard@rsk.demon.co.uk, rjw@sisk.pl


The patch titled
     some random patch from jens
has been added to the -mm tree.  Its filename is
     some-random-patch-from-jens.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: some random patch from jens
From: Jens Axboe <axboe@kernel.dk>

Fix some lockdep splat.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16400

Reported-by: Martin Pirker <lkml.collector@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Florian Mickler <florian@mickler.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c            |    7 ++++---
 include/linux/backing-dev.h |    2 +-
 include/linux/writeback.h   |    3 +--
 mm/page-writeback.c         |   19 ++++++++++++-------
 4 files changed, 18 insertions(+), 13 deletions(-)

diff -puN block/blk-core.c~some-random-patch-from-jens block/blk-core.c
--- a/block/blk-core.c~some-random-patch-from-jens
+++ a/block/blk-core.c
@@ -451,7 +451,7 @@ void blk_cleanup_queue(struct request_qu
 	 */
 	blk_sync_queue(q);
 
-	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
+	cancel_delayed_work_sync(&q->backing_dev_info.laptop_mode_work);
 	mutex_lock(&q->sysfs_lock);
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
@@ -515,8 +515,9 @@ struct request_queue *blk_alloc_queue_no
 		return NULL;
 	}
 
-	setup_timer(&q->backing_dev_info.laptop_mode_wb_timer,
-		    laptop_mode_timer_fn, (unsigned long) q);
+
+	INIT_DELAYED_WORK(&q->backing_dev_info.laptop_mode_work,
+				laptop_mode_work_fn);
 	init_timer(&q->unplug_timer);
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
 	INIT_LIST_HEAD(&q->timeout_list);
diff -puN include/linux/backing-dev.h~some-random-patch-from-jens include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~some-random-patch-from-jens
+++ a/include/linux/backing-dev.h
@@ -86,7 +86,7 @@ struct backing_dev_info {
 
 	struct device *dev;
 
-	struct timer_list laptop_mode_wb_timer;
+	struct delayed_work laptop_mode_work;
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debug_dir;
diff -puN include/linux/writeback.h~some-random-patch-from-jens include/linux/writeback.h
--- a/include/linux/writeback.h~some-random-patch-from-jens
+++ a/include/linux/writeback.h
@@ -87,8 +87,7 @@ static inline void inode_sync_wait(struc
 #ifdef CONFIG_BLOCK
 void laptop_io_completion(struct backing_dev_info *info);
 void laptop_sync_completion(void);
-void laptop_mode_sync(struct work_struct *work);
-void laptop_mode_timer_fn(unsigned long data);
+void laptop_mode_work_fn(struct work_struct *);
 #else
 static inline void laptop_sync_completion(void) { }
 #endif
diff -puN mm/page-writeback.c~some-random-patch-from-jens mm/page-writeback.c
--- a/mm/page-writeback.c~some-random-patch-from-jens
+++ a/mm/page-writeback.c
@@ -695,18 +695,20 @@ int dirty_writeback_centisecs_handler(ct
 }
 
 #ifdef CONFIG_BLOCK
-void laptop_mode_timer_fn(unsigned long data)
+void laptop_mode_work_fn(struct work_struct *work)
 {
-	struct request_queue *q = (struct request_queue *)data;
+	struct backing_dev_info *bdi;
 	int nr_pages = global_page_state(NR_FILE_DIRTY) +
 		global_page_state(NR_UNSTABLE_NFS);
 
+	bdi = container_of(work, struct backing_dev_info, laptop_mode_work.work);
+
 	/*
 	 * We want to write everything out, not just down to the dirty
 	 * threshold
 	 */
-	if (bdi_has_dirty_io(&q->backing_dev_info))
-		bdi_start_writeback(&q->backing_dev_info, nr_pages);
+	if (bdi_has_dirty_io(bdi))
+		bdi_start_writeback(bdi, nr_pages);
 }
 
 /*
@@ -714,9 +716,12 @@ void laptop_mode_timer_fn(unsigned long 
  * of all dirty data a few seconds from now.  If the flush is already scheduled
  * then push it back - the user is still using the disk.
  */
-void laptop_io_completion(struct backing_dev_info *info)
+void laptop_io_completion(struct backing_dev_info *bdi)
 {
-	mod_timer(&info->laptop_mode_wb_timer, jiffies + laptop_mode);
+	if (work_pending(&bdi->laptop_mode_work.work))
+		mod_timer(&bdi->laptop_mode_work.timer, jiffies + laptop_mode);
+	else
+		schedule_delayed_work(&bdi->laptop_mode_work, laptop_mode);
 }
 
 /*
@@ -731,7 +736,7 @@ void laptop_sync_completion(void)
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list)
-		del_timer(&bdi->laptop_mode_wb_timer);
+		__cancel_delayed_work(&bdi->laptop_mode_work);
 
 	rcu_read_unlock();
 }
_

Patches currently in -mm which might be from axboe@kernel.dk are

fs-inodec-work-around-bug.patch
some-random-patch-from-jens.patch
writeback-remove-nonblocking-encountered_congestion-references.patch
vfs-add-super-operation-writeback_inodes.patch
reiser4.patch

