From: akpm@osdl.org
Subject: - aio-add-per-task-aio-wait-event-condition.patch removed from -mm tree
Date: Tue, 02 Jan 2007 17:10:10 -0800
Message-ID: <200701030110.l031AXxT003703@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54384 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbXACBRL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 20:17:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenneth.w.chen@intel.com, bcrl@kvack.org, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: add per task aio wait event condition
has been removed from the -mm tree.  Its filename was
     aio-add-per-task-aio-wait-event-condition.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: aio: add per task aio wait event condition
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

The AIO wake-up notification from aio_complete is really inefficient
in current AIO implementation in the presence of process waiting in
io_getevents().

For example, if app calls io_getevents with min_nr > 1, and aio event
queue doesn't have enough completed aio event, the process will block
in read_events().  However, aio_complete() will wake up the waiting
process for *each* complete I/O even though number of events that an
app is waiting for is much larger than 1.  This makes excessive and
unnecessary context switch because the waiting process will just reap
one single event and goes back to sleep again.  It is much more efficient
to wake up the waiting process when there are enough events for it to
reap.

This patch adds a wait condition to the wait queue and only wake-up
process when that condition meets.  And this condition is added on a
per task base for handling multi-threaded app that shares single ioctx.

To show the effect of this patch, here is an vmstat output before and
after the patch. The app does random O_DIRECT AIO on 60 disks. Context
switch is reduced from 13 thousand+ down to just 40+, an significant
improvement.

Before:
procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 0  0      0 3972608   7056  31312    0    0 14000     0 7840 13715  0  2 98  0
 0  0      0 3972608   7056  31312    0    0 14300     0 7793 13641  0  2 98  0
 0  0      0 3972608   7056  31312    0    0 14100     0 7885 13747  0  2 98  0

After:
 0  0      0 3972608   7056  31312    0    0 14000     0 7840    49  0  2 98  0
 0  0      0 3972608   7056  31312    0    0 13800     0 7793    53  0  2 98  0
 0  0      0 3972608   7056  31312    0    0 13800     0 7885    42  0  2 98  0

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c |   43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff -puN fs/aio.c~aio-add-per-task-aio-wait-event-condition fs/aio.c
--- a/fs/aio.c~aio-add-per-task-aio-wait-event-condition
+++ a/fs/aio.c
@@ -193,6 +193,17 @@ static int aio_setup_ring(struct kioctx 
 	kunmap_atomic((void *)((unsigned long)__event & PAGE_MASK), km); \
 } while(0)
 
+struct aio_wait_queue {
+	int		nr_wait;	/* wake-up condition */
+	wait_queue_t	wait;
+};
+
+static inline void aio_init_wait(struct aio_wait_queue *wait)
+{
+	wait->nr_wait = 0;
+	init_wait(&wait->wait);
+}
+
 /* ioctx_alloc
  *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
  */
@@ -295,13 +306,14 @@ static void aio_cancel_all(struct kioctx
 static void wait_for_all_aios(struct kioctx *ctx)
 {
 	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
+	struct aio_wait_queue wait;
 
 	spin_lock_irq(&ctx->ctx_lock);
 	if (!ctx->reqs_active)
 		goto out;
 
-	add_wait_queue(&ctx->wait, &wait);
+	aio_init_wait(&wait);
+	add_wait_queue(&ctx->wait, &wait.wait);
 	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	while (ctx->reqs_active) {
 		spin_unlock_irq(&ctx->ctx_lock);
@@ -310,7 +322,7 @@ static void wait_for_all_aios(struct kio
 		spin_lock_irq(&ctx->ctx_lock);
 	}
 	__set_task_state(tsk, TASK_RUNNING);
-	remove_wait_queue(&ctx->wait, &wait);
+	remove_wait_queue(&ctx->wait, &wait.wait);
 
 out:
 	spin_unlock_irq(&ctx->ctx_lock);
@@ -930,6 +942,7 @@ int fastcall aio_complete(struct kiocb *
 	unsigned long	flags;
 	unsigned long	tail;
 	int		ret;
+	int		nr_evt = 0;
 
 	/*
 	 * Special case handling for sync iocbs:
@@ -990,6 +1003,9 @@ int fastcall aio_complete(struct kiocb *
 	info->tail = tail;
 	ring->tail = tail;
 
+	nr_evt = ring->tail - ring->head;
+	if (nr_evt < 0)
+		nr_evt += info->nr;
 	put_aio_ring_event(event, KM_IRQ0);
 	kunmap_atomic(ring, KM_IRQ1);
 
@@ -998,8 +1014,13 @@ put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	ret = __aio_put_req(ctx, iocb);
 
-	if (waitqueue_active(&ctx->wait))
-		wake_up(&ctx->wait);
+	if (waitqueue_active(&ctx->wait)) {
+		struct aio_wait_queue *wait;
+		wait = container_of(ctx->wait.task_list.next,
+				    struct aio_wait_queue, wait.task_list);
+		if (nr_evt >= wait->nr_wait)
+			wake_up(&ctx->wait);
+	}
 
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 	return ret;
@@ -1092,7 +1113,7 @@ static int read_events(struct kioctx *ct
 {
 	long			start_jiffies = jiffies;
 	struct task_struct	*tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
+	struct aio_wait_queue	wait;
 	int			ret;
 	int			i = 0;
 	struct io_event		ent;
@@ -1150,10 +1171,11 @@ retry:
 		set_timeout(start_jiffies, &to, &ts);
 	}
 
+	aio_init_wait(&wait);
 	while (likely(i < nr)) {
-		add_wait_queue_exclusive(&ctx->wait, &wait);
 		do {
-			set_task_state(tsk, TASK_INTERRUPTIBLE);
+			prepare_to_wait_exclusive(&ctx->wait, &wait.wait,
+						  TASK_INTERRUPTIBLE);
 			ret = aio_read_evt(ctx, &ent);
 			if (ret)
 				break;
@@ -1162,6 +1184,7 @@ retry:
 			ret = 0;
 			if (to.timed_out)	/* Only check after read evt */
 				break;
+			wait.nr_wait = min_nr - i;
 			schedule();
 			if (signal_pending(tsk)) {
 				ret = -EINTR;
@@ -1169,9 +1192,7 @@ retry:
 			}
 			/*ret = aio_read_evt(ctx, &ent);*/
 		} while (1) ;
-
-		set_task_state(tsk, TASK_RUNNING);
-		remove_wait_queue(&ctx->wait, &wait);
+		finish_wait(&ctx->wait, &wait.wait);
 
 		if (unlikely(ret <= 0))
 			break;
_

Patches currently in -mm which might be from kenneth.w.chen@intel.com are

ia64-alignment-bug-in-ldscript.patch
aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
aio-add-per-task-aio-wait-event-condition.patch
aio-streamline-read-events-after-woken-up.patch
aio-remove-spurious-ring-head-index-modulo-info-nr.patch
aio-make-aio_ring_info-nr_pages-an-unsigned-int.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
