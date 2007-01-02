From: akpm@osdl.org
Subject: + aio-streamline-read-events-after-woken-up.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:34:16 -0800
Message-ID: <200701022134.l02LYG0P030471@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34556 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932914AbXABVh4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:37:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenneth.w.chen@intel.com, bcrl@kvack.org, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com


The patch titled
     aio: streamline read events after woken up
has been added to the -mm tree.  Its filename is
     aio-streamline-read-events-after-woken-up.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: aio: streamline read events after woken up
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

The read event loop in the blocking path is also inefficient. For every
event it reap (if not blocking), it does the following in a loop:

      while (i < nr) {
            prepare_to_wait_exclusive
            aio_read_evt
            finish_wait
            ...
      }

Given the previous patch "aio: add per task aio wait event condition"
that we properly wake up event waiting process knowing that we have
enough events to reap, it's just plain waste of time to insert itself
into a wait queue, and then immediately remove itself from the wait
queue for *every* event reap iteration.

This patch factors out the wait queue insertion/deletion out of the event
reap loop, streamlines the event reaping after the process wakes up.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c      |   54 +++++++++++++++++++++++-------------------------
 fs/aio.c.orig |   43 ++++++++++++++++++++++++++++----------
 2 files changed, 58 insertions(+), 39 deletions(-)

diff -puN fs/aio.c~aio-streamline-read-events-after-woken-up fs/aio.c
--- a/fs/aio.c~aio-streamline-read-events-after-woken-up
+++ a/fs/aio.c
@@ -1172,42 +1172,40 @@ retry:
 	}
 
 	aio_init_wait(&wait);
+wait:
+	prepare_to_wait_exclusive(&ctx->wait, &wait.wait, TASK_INTERRUPTIBLE);
+	ret = aio_read_evt(ctx, &ent);
+	if (!ret) {
+		wait.nr_wait = min_nr - i;
+		schedule();
+		if (signal_pending(tsk))
+			ret = -EINTR;
+	}
+	finish_wait(&ctx->wait, &wait.wait);
+
+	if (ret < 0)
+		goto out_cleanup;
+
 	while (likely(i < nr)) {
-		do {
-			prepare_to_wait_exclusive(&ctx->wait, &wait.wait,
-						  TASK_INTERRUPTIBLE);
-			ret = aio_read_evt(ctx, &ent);
-			if (ret)
-				break;
-			if (min_nr <= i)
-				break;
-			ret = 0;
-			if (to.timed_out)	/* Only check after read evt */
-				break;
-			wait.nr_wait = min_nr - i;
-			schedule();
-			if (signal_pending(tsk)) {
-				ret = -EINTR;
+		if (ret) {
+			if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
+				dprintk("aio: lost an event due to EFAULT.\n");
+				ret = -EFAULT;
 				break;
 			}
-			/*ret = aio_read_evt(ctx, &ent);*/
-		} while (1) ;
-		finish_wait(&ctx->wait, &wait.wait);
-
-		if (unlikely(ret <= 0))
-			break;
+			event++;
+			i++;
+		}
 
-		ret = -EFAULT;
-		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
+		ret = aio_read_evt(ctx, &ent);
+		if (unlikely(!ret)) {
+			if (i < min_nr && !to.timed_out)
+				goto wait;
 			break;
 		}
-
-		/* Good, event copied to userland, update counts. */
-		event ++;
-		i ++;
 	}
 
+out_cleanup:
 	if (timeout)
 		clear_timeout(&to);
 out:
diff -puN fs/aio.c.orig~aio-streamline-read-events-after-woken-up fs/aio.c.orig
--- a/fs/aio.c.orig~aio-streamline-read-events-after-woken-up
+++ a/fs/aio.c.orig
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
