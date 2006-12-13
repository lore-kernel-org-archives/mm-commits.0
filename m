From: akpm@osdl.org
Subject: - dio-remove-duplicate-bio-wait-code.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:15 -0800
Message-ID: <200612130655.kBD6tFKx030621@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57804 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965028AbWLMGzk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach.brown@oracle.com, jmoyer@redhat.com, pbadari@us.ibm.com, suparna@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     dio: remove duplicate bio wait code
has been removed from the -mm tree.  Its filename was
     dio-remove-duplicate-bio-wait-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dio: remove duplicate bio wait code
From: Zach Brown <zach.brown@oracle.com>

Now that we have a single refcount and waiting path we can reuse it in the
async 'should_wait' path.  It continues to rely on the fragile link between
the conditional in dio_complete_aio() which decides to complete the AIO and
the conditional in direct_io_worker() which decides to wait and free.

By waiting before dropping the reference we stop dio_bio_end_aio() from
calling dio_complete_aio() which used to wake up the waiter after seeing the
reference count drop to 0.  We hoist this wake up into dio_bio_end_aio() which
now notices when it's left a single remaining reference that is held by the
waiter.

Signed-off-by: Zach Brown <zach.brown@oracle.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/direct-io.c |   41 ++++++++++++-----------------------------
 1 file changed, 12 insertions(+), 29 deletions(-)

diff -puN fs/direct-io.c~dio-remove-duplicate-bio-wait-code fs/direct-io.c
--- a/fs/direct-io.c~dio-remove-duplicate-bio-wait-code
+++ a/fs/direct-io.c
@@ -257,7 +257,6 @@ static int dio_complete(struct dio *dio,
  */
 static void dio_complete_aio(struct dio *dio)
 {
-	unsigned long flags;
 	int ret;
 
 	ret = dio_complete(dio, dio->iocb->ki_pos, 0);
@@ -267,14 +266,6 @@ static void dio_complete_aio(struct dio 
 		((dio->rw == READ) && dio->result)) {
 		aio_complete(dio->iocb, ret, 0);
 		kfree(dio);
-	} else {
-		/*
-		 * Falling back to buffered
-		 */
-		spin_lock_irqsave(&dio->bio_lock, flags);
-		if (dio->waiter)
-			wake_up_process(dio->waiter);
-		spin_unlock_irqrestore(&dio->bio_lock, flags);
 	}
 }
 
@@ -285,6 +276,8 @@ static int dio_bio_complete(struct dio *
 static int dio_bio_end_aio(struct bio *bio, unsigned int bytes_done, int error)
 {
 	struct dio *dio = bio->bi_private;
+	int waiter_holds_ref = 0;
+	int remaining;
 
 	if (bio->bi_size)
 		return 1;
@@ -292,7 +285,12 @@ static int dio_bio_end_aio(struct bio *b
 	/* cleanup the bio */
 	dio_bio_complete(dio, bio);
 
-	if (atomic_dec_and_test(&dio->refcount))
+	waiter_holds_ref = !!dio->waiter;
+	remaining = atomic_sub_return(1, (&dio->refcount));
+	if (remaining == 1 && waiter_holds_ref)
+		wake_up_process(dio->waiter);
+
+	if (remaining == 0)
 		dio_complete_aio(dio);
 
 	return 0;
@@ -1097,30 +1095,15 @@ direct_io_worker(int rw, struct kiocb *i
 		if (ret == 0)
 			ret = dio->result;
 
+		if (should_wait)
+			dio_await_completion(dio);
+
 		/* this can free the dio */
 		if (atomic_dec_and_test(&dio->refcount))
 			dio_complete_aio(dio);
 
-		if (should_wait) {
-			unsigned long flags;
-			/*
-			 * Wait for already issued I/O to drain out and
-			 * release its references to user-space pages
-			 * before returning to fallback on buffered I/O
-			 */
-
-			spin_lock_irqsave(&dio->bio_lock, flags);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			while (atomic_read(&dio->refcount)) {
-				spin_unlock_irqrestore(&dio->bio_lock, flags);
-				io_schedule();
-				spin_lock_irqsave(&dio->bio_lock, flags);
-				set_current_state(TASK_UNINTERRUPTIBLE);
-			}
-			spin_unlock_irqrestore(&dio->bio_lock, flags);
-			set_current_state(TASK_RUNNING);
+		if (should_wait)
 			kfree(dio);
-		}
 	} else {
 		dio_await_completion(dio);
 
_

Patches currently in -mm which might be from zach.brown@oracle.com are

origin.patch
optimize-o_direct-on-block-device-v3.patch
optimize-o_direct-on-block-device-v3-tweak.patch

