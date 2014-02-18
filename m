From: akpm@linux-foundation.org
Subject: + backing_dev-fix-hung-task-on-sync.patch added to -mm tree
Date: Tue, 18 Feb 2014 12:29:08 -0800
Message-ID: <5303c294.w+TxjHX2eN+oa5o1%akpm__41459.4318288893$1392755458$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaBRU3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 15:29:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zento.linux.org.uk, tj@kernel.org, stable@vger.kernel.org, sonnyrao@chromium.org, semenzato@chromium.org, keescook@chromium.org, jack@suse.cz, gregkh@linuxfoundation.org, david@fromorbit.com, darrick.wong@oracle.com, bleung@chromium.org, axboe@kernel.dk, dbasehore@chromium.org

Subject: + backing_dev-fix-hung-task-on-sync.patch added to -mm tree
To: dbasehore@chromium.org,axboe@kernel.dk,bleung@chromium.org,darrick.wong@oracle.com,david@fromorbit.com,gregkh@linuxfoundation.org,jack@suse.cz,keescook@chromium.org,semenzato@chromium.org,sonnyrao@chromium.org,stable@vger.kernel.org,tj@kernel.org,viro@zento.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 12:29:08 -0800


The patch titled
     Subject: backing_dev: fix hung task on sync
has been added to the -mm tree.  Its filename is
     backing_dev-fix-hung-task-on-sync.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backing_dev-fix-hung-task-on-sync.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backing_dev-fix-hung-task-on-sync.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Derek Basehore <dbasehore@chromium.org>
Subject: backing_dev: fix hung task on sync

bdi_wakeup_thread_delayed() used mod_delayed_work() to schedule work to
writeback dirty inodes.  The problem with this is that it can delay work
that is scheduled for immediate execution, such as the work from
sync_inodes_sb().  This can happen since mod_delayed_work can now steal
work from a work_queue.  This fixes the problem by using
queue_delayed_work instead.  This is a regression from the move to the bdi
workqueue design.

The reason that this causes a problem is that laptop-mode will change the
delay, dirty_writeback_centisecs, to 60000 (10 minutes) by default.  In
the case that bdi_wakeup_thread_delayed races with sync_inodes_sb, sync
will be stopped for 10 minutes and trigger a hung task.  Even if
dirty_writeback_centisecs is not long enough to cause a hung task, we
still don't want to delay sync for that long.

For the same reason, this also changes bdi_writeback_workfn to immediately
queue the work again in the case that the work_list is not empty.  The
same problem can happen if the sync work is run on the rescue worker.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zento.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
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

 fs/fs-writeback.c |    5 +++--
 mm/backing-dev.c  |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/fs-writeback.c~backing_dev-fix-hung-task-on-sync fs/fs-writeback.c
--- a/fs/fs-writeback.c~backing_dev-fix-hung-task-on-sync
+++ a/fs/fs-writeback.c
@@ -1047,8 +1047,9 @@ void bdi_writeback_workfn(struct work_st
 		trace_writeback_pages_written(pages_written);
 	}
 
-	if (!list_empty(&bdi->work_list) ||
-	    (wb_has_dirty_io(wb) && dirty_writeback_interval))
+	if (!list_empty(&bdi->work_list))
+		mod_delayed_work(bdi_wq, &wb->dwork, 0);
+	else if (wb_has_dirty_io(wb) && dirty_writeback_interval)
 		queue_delayed_work(bdi_wq, &wb->dwork,
 			msecs_to_jiffies(dirty_writeback_interval * 10));
 
diff -puN mm/backing-dev.c~backing_dev-fix-hung-task-on-sync mm/backing-dev.c
--- a/mm/backing-dev.c~backing_dev-fix-hung-task-on-sync
+++ a/mm/backing-dev.c
@@ -294,7 +294,7 @@ void bdi_wakeup_thread_delayed(struct ba
 	unsigned long timeout;
 
 	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
-	mod_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
+	queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
 }
 
 /*
_

Patches currently in -mm which might be from dbasehore@chromium.org are

backing_dev-fix-hung-task-on-sync.patch

