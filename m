From: akpm@linux-foundation.org
Subject: [merged] aio-remove-unused-field.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:39:34 -0800
Message-ID: <200912162039.nBGKdY7c013547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964996AbZLPUjw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:39:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, bcrl@kvack.org, jmoyer@redhat.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: remove unused field
has been removed from the -mm tree.  Its filename was
     aio-remove-unused-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: remove unused field
From: Shaohua Li <shaohua.li@intel.com>

Don't know the reason, but it appears ki_wait field of iocb never gets used.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c            |   40 ++--------------------------------------
 include/linux/aio.h |    4 ----
 2 files changed, 2 insertions(+), 42 deletions(-)

diff -puN fs/aio.c~aio-remove-unused-field fs/aio.c
--- a/fs/aio.c~aio-remove-unused-field
+++ a/fs/aio.c
@@ -711,10 +711,8 @@ static ssize_t aio_run_iocb(struct kiocb
 	 */
 	ret = retry(iocb);
 
-	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED) {
-		BUG_ON(!list_empty(&iocb->ki_wait.task_list));
+	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED)
 		aio_complete(iocb, ret, 0);
-	}
 out:
 	spin_lock_irq(&ctx->ctx_lock);
 
@@ -866,13 +864,6 @@ static void try_queue_kicked_iocb(struct
 	unsigned long flags;
 	int run = 0;
 
-	/* We're supposed to be the only path putting the iocb back on the run
-	 * list.  If we find that the iocb is *back* on a wait queue already
-	 * than retry has happened before we could queue the iocb.  This also
-	 * means that the retry could have completed and freed our iocb, no
-	 * good. */
-	BUG_ON((!list_empty(&iocb->ki_wait.task_list)));
-
 	spin_lock_irqsave(&ctx->ctx_lock, flags);
 	/* set this inside the lock so that we can't race with aio_run_iocb()
 	 * testing it and putting the iocb on the run list under the lock */
@@ -886,7 +877,7 @@ static void try_queue_kicked_iocb(struct
 /*
  * kick_iocb:
  *      Called typically from a wait queue callback context
- *      (aio_wake_function) to trigger a retry of the iocb.
+ *      to trigger a retry of the iocb.
  *      The retry is usually executed by aio workqueue
  *      threads (See aio_kick_handler).
  */
@@ -1520,31 +1511,6 @@ static ssize_t aio_setup_iocb(struct kio
 	return 0;
 }
 
-/*
- * aio_wake_function:
- * 	wait queue callback function for aio notification,
- * 	Simply triggers a retry of the operation via kick_iocb.
- *
- * 	This callback is specified in the wait queue entry in
- *	a kiocb.
- *
- * Note:
- * This routine is executed with the wait queue lock held.
- * Since kick_iocb acquires iocb->ctx->ctx_lock, it nests
- * the ioctx lock inside the wait queue lock. This is safe
- * because this callback isn't used for wait queues which
- * are nested inside ioctx lock (i.e. ctx->wait)
- */
-static int aio_wake_function(wait_queue_t *wait, unsigned mode,
-			     int sync, void *key)
-{
-	struct kiocb *iocb = container_of(wait, struct kiocb, ki_wait);
-
-	list_del_init(&wait->task_list);
-	kick_iocb(iocb);
-	return 1;
-}
-
 static void aio_batch_add(struct address_space *mapping,
 			  struct hlist_head *batch_hash)
 {
@@ -1642,8 +1608,6 @@ static int io_submit_one(struct kioctx *
 	req->ki_buf = (char __user *)(unsigned long)iocb->aio_buf;
 	req->ki_left = req->ki_nbytes = iocb->aio_nbytes;
 	req->ki_opcode = iocb->aio_lio_opcode;
-	init_waitqueue_func_entry(&req->ki_wait, aio_wake_function);
-	INIT_LIST_HEAD(&req->ki_wait.task_list);
 
 	ret = aio_setup_iocb(req);
 
diff -puN include/linux/aio.h~aio-remove-unused-field include/linux/aio.h
--- a/include/linux/aio.h~aio-remove-unused-field
+++ a/include/linux/aio.h
@@ -102,7 +102,6 @@ struct kiocb {
 	} ki_obj;
 
 	__u64			ki_user_data;	/* user's data for completion */
-	wait_queue_t		ki_wait;
 	loff_t			ki_pos;
 
 	void			*private;
@@ -140,7 +139,6 @@ struct kiocb {
 		(x)->ki_dtor = NULL;			\
 		(x)->ki_obj.tsk = tsk;			\
 		(x)->ki_user_data = 0;                  \
-		init_wait((&(x)->ki_wait));             \
 	} while (0)
 
 #define AIO_RING_MAGIC			0xa10a10a1
@@ -223,8 +221,6 @@ struct mm_struct;
 static inline void exit_aio(struct mm_struct *mm) { }
 #endif /* CONFIG_AIO */
 
-#define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
