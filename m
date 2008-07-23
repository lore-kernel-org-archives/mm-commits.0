From: akpm@linux-foundation.org
Subject: - pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:22:43 -0700
Message-ID: <200807232335.m6NNZLPb017969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754462AbYGWXgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:36:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, harbour@sfinx.od.ua, pavel@ucw.cz, rjw@sisk.pl, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup
has been removed from the -mm tree.  Its filename was
     pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup.patch

This patch was dropped because it was folded into pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup
From: Oleg Nesterov <oleg@tv-sign.ru>

The comment above __queue_work() is wrong, we don't need to disable
preemtion.

What it actually means is: the caller of __queue_work() must ensure
we can't race with CPU_DEAD, but preempt_disable() can't help for
queue_work_on(). CPU can die even before preempt_disable().

Remove preempt_disable() and update the comment.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Rus <harbour@sfinx.od.ua>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/workqueue.c~pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup kernel/workqueue.c
--- a/kernel/workqueue.c~pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup
+++ a/kernel/workqueue.c
@@ -140,7 +140,6 @@ static void insert_work(struct cpu_workq
 	wake_up(&cwq->more_work);
 }
 
-/* Preempt must be disabled. */
 static void __queue_work(struct cpu_workqueue_struct *cwq,
 			 struct work_struct *work)
 {
@@ -183,7 +182,8 @@ EXPORT_SYMBOL_GPL(queue_work);
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
  *
- * We queue the work to a specific CPU
+ * We queue the work to a specific CPU, the caller must ensure it
+ * can't go away.
  */
 int
 queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
@@ -192,9 +192,7 @@ queue_work_on(int cpu, struct workqueue_
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
 		BUG_ON(!list_empty(&work->entry));
-		preempt_disable();
 		__queue_work(wq_per_cpu(wq, cpu), work);
-		preempt_enable();
 		ret = 1;
 	}
 	return ret;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup.patch

