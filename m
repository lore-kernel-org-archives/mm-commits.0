From: akpm@osdl.org
Subject: - fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch removed from -mm tree
Date: Wed, 03 Jan 2007 14:16:34 -0800
Message-ID: <200701032216.l03MGY7c000604@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55416 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151AbXACWSV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 17:18:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suparna@in.ibm.com, bcrl@kvack.org, drepper@redhat.com, hch@lst.de, mingo@elte.hu, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fsaio: enable wait bit based filtered wakeups to work for AIO
has been removed from the -mm tree.  Its filename was
     fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: fsaio: enable wait bit based filtered wakeups to work for AIO
From: Suparna Bhattacharya <suparna@in.ibm.com>

Enable wait bit based filtered wakeups to work for AIO.  Replaces the wait
queue entry in the kiocb with a wait bit structure, to allow enough space for
the wait bit key.  This adds an extra level of indirection in references to
the wait queue entry in the iocb.  Also, an extra check had to be added in
aio_wake_function to allow for other kinds of waiters which do not require
wait bit, based on the assumption that the key passed in would be NULL in such
cases.

Signed-off-by: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c            |   21 ++++++++++++++-------
 include/linux/aio.h |    7 ++++---
 kernel/wait.c       |   17 ++++++++++++++---
 3 files changed, 32 insertions(+), 13 deletions(-)

diff -puN fs/aio.c~fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio fs/aio.c
--- a/fs/aio.c~fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio
+++ a/fs/aio.c
@@ -713,13 +713,13 @@ static ssize_t aio_run_iocb(struct kiocb
 	 * cause the iocb to be kicked for continuation (through
 	 * the aio_wake_function callback).
 	 */
-	BUG_ON(current->io_wait != NULL);
-	current->io_wait = &iocb->ki_wait;
+	BUG_ON(!is_sync_wait(current->io_wait));
+	current->io_wait = &iocb->ki_wait.wait;
 	ret = retry(iocb);
 	current->io_wait = NULL;
 
 	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED) {
-		BUG_ON(!list_empty(&iocb->ki_wait.task_list));
+		BUG_ON(!list_empty(&iocb->ki_wait.wait.task_list));
 		aio_complete(iocb, ret, 0);
 	}
 out:
@@ -878,7 +878,7 @@ static void try_queue_kicked_iocb(struct
 	 * than retry has happened before we could queue the iocb.  This also
 	 * means that the retry could have completed and freed our iocb, no
 	 * good. */
-	BUG_ON((!list_empty(&iocb->ki_wait.task_list)));
+	BUG_ON((!list_empty(&iocb->ki_wait.wait.task_list)));
 
 	spin_lock_irqsave(&ctx->ctx_lock, flags);
 	/* set this inside the lock so that we can't race with aio_run_iocb()
@@ -1513,7 +1513,13 @@ static ssize_t aio_setup_iocb(struct kio
 static int aio_wake_function(wait_queue_t *wait, unsigned mode,
 			     int sync, void *key)
 {
-	struct kiocb *iocb = container_of(wait, struct kiocb, ki_wait);
+	struct wait_bit_queue *wait_bit
+		= container_of(wait, struct wait_bit_queue, wait);
+	struct kiocb *iocb = container_of(wait_bit, struct kiocb, ki_wait);
+
+	/* Assumes that a non-NULL key implies wait bit filtering */
+	if (key && !test_wait_bit_key(wait, key))
+		return 0;
 
 	list_del_init(&wait->task_list);
 	kick_iocb(iocb);
@@ -1568,8 +1574,9 @@ int fastcall io_submit_one(struct kioctx
 	req->ki_buf = (char __user *)(unsigned long)iocb->aio_buf;
 	req->ki_left = req->ki_nbytes = iocb->aio_nbytes;
 	req->ki_opcode = iocb->aio_lio_opcode;
-	init_waitqueue_func_entry(&req->ki_wait, aio_wake_function);
-	INIT_LIST_HEAD(&req->ki_wait.task_list);
+	init_waitqueue_func_entry(&req->ki_wait.wait, aio_wake_function);
+	INIT_LIST_HEAD(&req->ki_wait.wait.task_list);
+ 	req->ki_run_list.next = req->ki_run_list.prev = NULL;
 
 	ret = aio_setup_iocb(req);
 
diff -puN include/linux/aio.h~fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio include/linux/aio.h
--- a/include/linux/aio.h~fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio
+++ a/include/linux/aio.h
@@ -102,7 +102,7 @@ struct kiocb {
 	} ki_obj;
 
 	__u64			ki_user_data;	/* user's data for completion */
-	wait_queue_t		ki_wait;
+	struct wait_bit_queue	ki_wait;
 	loff_t			ki_pos;
 
 	atomic_t		ki_bio_count;	/* num bio used for this iocb */
@@ -135,7 +135,7 @@ struct kiocb {
 		(x)->ki_dtor = NULL;			\
 		(x)->ki_obj.tsk = tsk;			\
 		(x)->ki_user_data = 0;                  \
-		init_wait((&(x)->ki_wait));             \
+		init_wait_bit_task((&(x)->ki_wait), current);\
 	} while (0)
 
 #define AIO_RING_MAGIC			0xa10a10a1
@@ -237,7 +237,8 @@ do {									\
 	}								\
 } while (0)
 
-#define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
+#define io_wait_to_kiocb(io_wait) container_of(container_of(io_wait,	\
+	struct wait_bit_queue, wait), struct kiocb, ki_wait)
 
 #include <linux/aio_abi.h>
 
diff -puN kernel/wait.c~fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio kernel/wait.c
--- a/kernel/wait.c~fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio
+++ a/kernel/wait.c
@@ -139,7 +139,8 @@ EXPORT_SYMBOL(autoremove_wake_function);
 
 int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *arg)
 {
-	if (!test_wait_bit_key(wait, arg))
+	/* Assumes that a non-NULL key implies wait bit filtering */
+	if (arg && !test_wait_bit_key(wait, arg))
 		return 0;
 	return autoremove_wake_function(wait, mode, sync, arg);
 }
@@ -161,7 +162,12 @@ __wait_on_bit(wait_queue_head_t *wq, str
 		if (test_bit(q->key.bit_nr, q->key.flags))
 			ret = (*action)(q->key.flags, &q->wait);
 	} while (test_bit(q->key.bit_nr, q->key.flags) && !ret);
-	finish_wait(wq, &q->wait);
+	/*
+	 * AIO retries require the wait queue entry to remain queued
+	 * for async notification
+	 */
+	if (ret != -EIOCBRETRY)
+		finish_wait(wq, &q->wait);
 	return ret;
 }
 EXPORT_SYMBOL(__wait_on_bit);
@@ -190,7 +196,12 @@ __wait_on_bit_lock(wait_queue_head_t *wq
 				break;
 		}
 	} while (test_and_set_bit(q->key.bit_nr, q->key.flags));
-	finish_wait(wq, &q->wait);
+	/*
+	 * AIO retries require the wait queue entry to remain queued
+	 * for async notification
+	 */
+	if (ret != -EIOCBRETRY)
+		finish_wait(wq, &q->wait);
 	return ret;
 }
 EXPORT_SYMBOL(__wait_on_bit_lock);
_

Patches currently in -mm which might be from suparna@in.ibm.com are

aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-filesystem-aio-read-tidy.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
