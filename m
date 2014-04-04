From: akpm@linux-foundation.org
Subject: [merged] backing_dev-fix-hung-task-on-sync.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:29:18 -0700
Message-ID: <533f080e.7zUrfCzO2VYMfvIv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaDDT3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zento.linux.org.uk, tj@kernel.org, stable@vger.kernel.org, sonnyrao@chromium.org, semenzato@chromium.org, keescook@chromium.org, jack@suse.cz, gregkh@linuxfoundation.org, david@fromorbit.com, darrick.wong@oracle.com, bleung@chromium.org, axboe@kernel.dk, dbasehore@chromium.org

Subject: [merged] backing_dev-fix-hung-task-on-sync.patch removed from -mm tree
To: dbasehore@chromium.org,axboe@kernel.dk,bleung@chromium.org,darrick.wong@oracle.com,david@fromorbit.com,gregkh@linuxfoundation.org,jack@suse.cz,keescook@chromium.org,semenzato@chromium.org,sonnyrao@chromium.org,stable@vger.kernel.org,tj@kernel.org,viro@zento.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:18 -0700


The patch titled
     Subject: backing_dev: fix hung task on sync
has been removed from the -mm tree.  Its filename was
     backing_dev-fix-hung-task-on-sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Derek Basehore <dbasehore@chromium.org>
Subject: backing_dev: fix hung task on sync

bdi_wakeup_thread_delayed() used the mod_delayed_work() function to
schedule work to writeback dirty inodes.  The problem with this is that it
can delay work that is scheduled for immediate execution, such as the work
from sync_inodes_sb().  This can happen since mod_delayed_work() can now
steal work from a work_queue.  This fixes the problem by using
queue_delayed_work() instead.  This is a regression caused by 839a8e8660b6
("writeback: replace custom worker pool implementation with unbound
workqueue").

The reason that this causes a problem is that laptop-mode will change the
delay, dirty_writeback_centisecs, to 60000 (10 minutes) by default.  In
the case that bdi_wakeup_thread_delayed() races with sync_inodes_sb(),
sync will be stopped for 10 minutes and trigger a hung task.  Even if
dirty_writeback_centisecs is not long enough to cause a hung task, we
still don't want to delay sync for that long.

We fix the problem by using queue_delayed_work() when we want to schedule
writeback sometime in future.  This function doesn't change the timer if
it is already armed.

For the same reason, we also change bdi_writeback_workfn() to immediately
queue the work again in the case that the work_list is not empty.  The
same problem can happen if the sync work is run on the rescue worker.

[jack@suse.cz: update changelog, add comment, use bdi_wakeup_thread_delayed()]
Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zento.linux.org.uk>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Derek Basehore <dbasehore@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Sonny Rao <sonnyrao@chromium.org>
Cc: Luigi Semenzato <semenzato@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    8 ++++----
 mm/backing-dev.c  |    5 ++++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -puN fs/fs-writeback.c~backing_dev-fix-hung-task-on-sync fs/fs-writeback.c
--- a/fs/fs-writeback.c~backing_dev-fix-hung-task-on-sync
+++ a/fs/fs-writeback.c
@@ -1039,10 +1039,10 @@ void bdi_writeback_workfn(struct work_st
 		trace_writeback_pages_written(pages_written);
 	}
 
-	if (!list_empty(&bdi->work_list) ||
-	    (wb_has_dirty_io(wb) && dirty_writeback_interval))
-		queue_delayed_work(bdi_wq, &wb->dwork,
-			msecs_to_jiffies(dirty_writeback_interval * 10));
+	if (!list_empty(&bdi->work_list))
+		mod_delayed_work(bdi_wq, &wb->dwork, 0);
+	else if (wb_has_dirty_io(wb) && dirty_writeback_interval)
+		bdi_wakeup_thread_delayed(bdi);
 
 	current->flags &= ~PF_SWAPWRITE;
 }
diff -puN mm/backing-dev.c~backing_dev-fix-hung-task-on-sync mm/backing-dev.c
--- a/mm/backing-dev.c~backing_dev-fix-hung-task-on-sync
+++ a/mm/backing-dev.c
@@ -288,13 +288,16 @@ int bdi_has_dirty_io(struct backing_dev_
  * Note, we wouldn't bother setting up the timer, but this function is on the
  * fast-path (used by '__mark_inode_dirty()'), so we save few context switches
  * by delaying the wake-up.
+ *
+ * We have to be careful not to postpone flush work if it is scheduled for
+ * earlier. Thus we use queue_delayed_work().
  */
 void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
 {
 	unsigned long timeout;
 
 	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
-	mod_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
+	queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
 }
 
 /*
_

Patches currently in -mm which might be from dbasehore@chromium.org are

origin.patch

