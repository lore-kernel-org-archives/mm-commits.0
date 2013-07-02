From: akpm@linux-foundation.org
Subject: [obsolete] block-fix-possible-sleep-in-invalid-context.patch
 removed from -mm tree
Date: Tue, 02 Jul 2013 13:23:21 -0700
Message-ID: <51d336b9.7RBvPGA/XxJiigp7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab3GBUXW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jul 2013 16:23:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rjw@sisk.pl, axboe@kernel.dk, sthumma@codeaurora.org

Subject: [obsolete] block-fix-possible-sleep-in-invalid-context.patch removed from -mm tree
To: sthumma@codeaurora.org,axboe@kernel.dk,rjw@sisk.pl,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 02 Jul 2013 13:23:21 -0700


The patch titled
     Subject: block: Fix possible sleep in invalid context
has been removed from the -mm tree.  Its filename was
     block-fix-possible-sleep-in-invalid-context.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: block: Fix possible sleep in invalid context

When block runtime PM is enabled following warning is seen
while resuming the device.

BUG: sleeping function called from invalid context at
.../drivers/base/power/runtime.c:923
in_atomic(): 1, irqs_disabled(): 128, pid: 12, name: kworker/0:1
[<c0014448>] (unwind_backtrace+0x0/0x120) from
[<c03120e4>] (__pm_runtime_suspend+0x34/0xa0) from
[<c021c33c>] (blk_post_runtime_resume+0x4c/0x5c) from
[<c03297cc>] (scsi_runtime_resume+0x90/0xb4) from
[<c0310940>] (__rpm_callback+0x30/0x58) from
[<c0310980>] (rpm_callback+0x18/0x28) from
[<c0311ab0>] (rpm_resume+0x3dc/0x540) from
[<c03120a4>] (pm_runtime_work+0x8c/0x98) from
[<c007767c>] (process_one_work+0x238/0x3e4) from
[<c0077b90>] (worker_thread+0x1ac/0x2ac) from
[<c007cfdc>] (kthread+0x88/0x94) from
[<c000ece0>] (kernel_thread_exit+0x0/0x8)

Fix this by releasing spin_lock_irq() before calling
pm_runtime_autosuspend() in blk_post_runtime_resume().

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN block/blk-core.c~block-fix-possible-sleep-in-invalid-context block/blk-core.c
--- a/block/blk-core.c~block-fix-possible-sleep-in-invalid-context
+++ a/block/blk-core.c
@@ -3159,16 +3159,18 @@ EXPORT_SYMBOL(blk_pre_runtime_resume);
  */
 void blk_post_runtime_resume(struct request_queue *q, int err)
 {
-	spin_lock_irq(q->queue_lock);
 	if (!err) {
+		spin_lock_irq(q->queue_lock);
 		q->rpm_status = RPM_ACTIVE;
 		__blk_run_queue(q);
 		pm_runtime_mark_last_busy(q->dev);
+		spin_unlock_irq(q->queue_lock);
 		pm_request_autosuspend(q->dev);
 	} else {
+		spin_lock_irq(q->queue_lock);
 		q->rpm_status = RPM_SUSPENDED;
+		spin_unlock_irq(q->queue_lock);
 	}
-	spin_unlock_irq(q->queue_lock);
 }
 EXPORT_SYMBOL(blk_post_runtime_resume);
 #endif
_

Patches currently in -mm which might be from sthumma@codeaurora.org are

linux-next.patch
block-fix-possible-sleep-in-invalid-context-fix.patch

