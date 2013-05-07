From: akpm@linux-foundation.org
Subject: [merged] writeback-set-worker-desc-to-identify-writeback-workers-in-task-dumps.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:29 -0700
Message-ID: <20130507174729.A40E25A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:55925 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab3EGRrc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:47:32 -0400
Received: by mail-qc0-f202.google.com with SMTP id d1so85156qcz.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:47:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, axboe@kernel.dk, david@fromorbit.com, jack@suse.cz, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: set worker desc to identify writeback workers in task dumps
has been removed from the -mm tree.  Its filename was
     writeback-set-worker-desc-to-identify-writeback-workers-in-task-dumps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: writeback: set worker desc to identify writeback workers in task dumps

Writeback has been recently converted to use workqueue instead of its
private thread pool implementation.  One negative side effect of this
conversion is that there's no easy to tell which backing device a
writeback work item was working on at the time of task dump, be it
sysrq-t, BUG, WARN or whatever, which, according to our writeback
brethren, is important in tracking down issues with a lot of mounted file
systems on a lot of different devices.

This patch restores that information using the new worker description
facility.  bdi_writeback_workfn() calls set_work_desc() to identify which
bdi it's working on.  The description is printed out together with the
worqueue name and worker function as in the following example dump.

 WARNING: at fs/fs-writeback.c:1015 bdi_writeback_workfn+0x2b4/0x3c0()
 Modules linked in:
 Pid: 28, comm: kworker/u18:0 Not tainted 3.9.0-rc1-work+ #24 empty empty/S3992
 Workqueue: writeback bdi_writeback_workfn (flush-8:16)
  ffffffff820a3a98 ffff88015b927cb8 ffffffff81c61855 ffff88015b927cf8
  ffffffff8108f500 0000000000000000 ffff88007a171948 ffff88007a1716b0
  ffff88015b49df00 ffff88015b8d3940 0000000000000000 ffff88015b927d08
 Call Trace:
  [<ffffffff81c61855>] dump_stack+0x19/0x1b
  [<ffffffff8108f500>] warn_slowpath_common+0x70/0xa0
  [<ffffffff8108f54a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff81200144>] bdi_writeback_workfn+0x2b4/0x3c0
  [<ffffffff810b4c87>] process_one_work+0x1d7/0x660
  [<ffffffff810b5c72>] worker_thread+0x122/0x380
  [<ffffffff810bdfea>] kthread+0xea/0xf0
  [<ffffffff81c6cedc>] ret_from_fork+0x7c/0xb0

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fs-writeback.c~writeback-set-worker-desc-to-identify-writeback-workers-in-task-dumps fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-set-worker-desc-to-identify-writeback-workers-in-task-dumps
+++ a/fs/fs-writeback.c
@@ -1028,6 +1028,7 @@ int bdi_writeback_thread(void *data)
 	struct backing_dev_info *bdi = wb->bdi;
 	long pages_written;
 
+	set_worker_desc("flush-%s", dev_name(bdi->dev));
 	current->flags |= PF_SWAPWRITE;
 	set_freezable();
 	wb->last_active = jiffies;
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch

