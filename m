From: akpm@osdl.org
Subject: - dio-lock-refcount-operations.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:20 -0800
Message-ID: <200612130655.kBD6tKKu030632@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57935 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965050AbWLMG40 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach.brown@oracle.com, jmoyer@redhat.com, pbadari@us.ibm.com, suparna@in.ibm.com, xfs-masters@oss.sgi.com, mm-commits@vger.kernel.org


The patch titled
     dio: lock refcount operations
has been removed from the -mm tree.  Its filename was
     dio-lock-refcount-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dio: lock refcount operations
From: Zach Brown <zach.brown@oracle.com>

The wait_for_more_bios() function name was poorly chosen.  While looking to
clean it up it I noticed that the dio struct refcounting between the bio
completion and dio submission paths was racey.

The bio submission path was simply freeing the dio struct if
atomic_dec_and_test() indicated that it dropped the final reference.

The aio bio completion path was dereferencing its dio struct pointer *after
dropping its reference* based on the remaining number of references.

These two paths could race and result in the aio bio completion path
dereferencing a freed dio, though this was not observed in the wild.

This moves the refcount under the bio lock so that bio completion can drop
its reference and decide to wake all in one atomic step.

Once testing and waking is locked dio_await_one() can test its sleeping
condition and mark itself uninterruptible under the lock.  It gets simpler
and wait_for_more_bios() disappears.

The addition of the interrupt masking spin lock acquiry in dio_bio_submit()
looks alarming.  This lock acquiry existed in that path before the recent
dio completion patch set.  We shouldn't expect significant performance
regression from returning to the behaviour that existed before the
completion clean up work.

This passed 4k block ext3 O_DIRECT fsx and aio-stress on an SMP machine.

Signed-off-by: Zach Brown <zach.brown@oracle.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: <xfs-masters@oss.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/direct-io.c |   76 +++++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 31 deletions(-)

diff -puN fs/direct-io.c~dio-lock-refcount-operations fs/direct-io.c
--- a/fs/direct-io.c~dio-lock-refcount-operations
+++ a/fs/direct-io.c
@@ -121,8 +121,8 @@ struct dio {
 	int page_errors;		/* errno from get_user_pages() */
 
 	/* BIO completion state */
-	atomic_t refcount;		/* direct_io_worker() and bios */
 	spinlock_t bio_lock;		/* protects BIO fields below */
+	unsigned long refcount;		/* direct_io_worker() and bios */
 	struct bio *bio_list;		/* singly linked via bi_private */
 	struct task_struct *waiter;	/* waiting task (NULL if none) */
 
@@ -267,8 +267,8 @@ static int dio_bio_complete(struct dio *
 static int dio_bio_end_aio(struct bio *bio, unsigned int bytes_done, int error)
 {
 	struct dio *dio = bio->bi_private;
-	int waiter_holds_ref = 0;
-	int remaining;
+	unsigned long remaining;
+	unsigned long flags;
 
 	if (bio->bi_size)
 		return 1;
@@ -276,10 +276,11 @@ static int dio_bio_end_aio(struct bio *b
 	/* cleanup the bio */
 	dio_bio_complete(dio, bio);
 
-	waiter_holds_ref = !!dio->waiter;
-	remaining = atomic_sub_return(1, (&dio->refcount));
-	if (remaining == 1 && waiter_holds_ref)
+	spin_lock_irqsave(&dio->bio_lock, flags);
+	remaining = --dio->refcount;
+	if (remaining == 1 && dio->waiter)
 		wake_up_process(dio->waiter);
+	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
 	if (remaining == 0) {
 		int ret = dio_complete(dio, dio->iocb->ki_pos, 0);
@@ -308,7 +309,7 @@ static int dio_bio_end_io(struct bio *bi
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	bio->bi_private = dio->bio_list;
 	dio->bio_list = bio;
-	if ((atomic_sub_return(1, &dio->refcount) == 1) && dio->waiter)
+	if (--dio->refcount == 1 && dio->waiter)
 		wake_up_process(dio->waiter);
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 	return 0;
@@ -345,11 +346,17 @@ dio_bio_alloc(struct dio *dio, struct bl
 static void dio_bio_submit(struct dio *dio)
 {
 	struct bio *bio = dio->bio;
+	unsigned long flags;
 
 	bio->bi_private = dio;
-	atomic_inc(&dio->refcount);
+
+	spin_lock_irqsave(&dio->bio_lock, flags);
+	dio->refcount++;
+	spin_unlock_irqrestore(&dio->bio_lock, flags);
+
 	if (dio->is_async && dio->rw == READ)
 		bio_set_pages_dirty(bio);
+
 	submit_bio(dio->rw, bio);
 
 	dio->bio = NULL;
@@ -365,13 +372,6 @@ static void dio_cleanup(struct dio *dio)
 		page_cache_release(dio_get_page(dio));
 }
 
-static int wait_for_more_bios(struct dio *dio)
-{
-	assert_spin_locked(&dio->bio_lock);
-
-	return (atomic_read(&dio->refcount) > 1) && (dio->bio_list == NULL);
-}
-
 /*
  * Wait for the next BIO to complete.  Remove it and return it.  NULL is
  * returned once all BIOs have been completed.  This must only be called once
@@ -384,16 +384,21 @@ static struct bio *dio_await_one(struct 
 	struct bio *bio = NULL;
 
 	spin_lock_irqsave(&dio->bio_lock, flags);
-	while (wait_for_more_bios(dio)) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (wait_for_more_bios(dio)) {
-			dio->waiter = current;
-			spin_unlock_irqrestore(&dio->bio_lock, flags);
-			io_schedule();
-			spin_lock_irqsave(&dio->bio_lock, flags);
-			dio->waiter = NULL;
-		}
-		set_current_state(TASK_RUNNING);
+
+	/*
+	 * Wait as long as the list is empty and there are bios in flight.  bio
+	 * completion drops the count, maybe adds to the list, and wakes while
+	 * holding the bio_lock so we don't need set_current_state()'s barrier
+	 * and can call it after testing our condition.
+	 */
+	while (dio->refcount > 1 && dio->bio_list == NULL) {
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		dio->waiter = current;
+		spin_unlock_irqrestore(&dio->bio_lock, flags);
+		io_schedule();
+		/* wake up sets us TASK_RUNNING */
+		spin_lock_irqsave(&dio->bio_lock, flags);
+		dio->waiter = NULL;
 	}
 	if (dio->bio_list) {
 		bio = dio->bio_list;
@@ -951,6 +956,7 @@ direct_io_worker(int rw, struct kiocb *i
 	struct dio *dio)
 {
 	unsigned long user_addr; 
+	unsigned long flags;
 	int seg;
 	ssize_t ret = 0;
 	ssize_t ret2;
@@ -981,8 +987,8 @@ direct_io_worker(int rw, struct kiocb *i
 	dio->iocb = iocb;
 	dio->i_size = i_size_read(inode);
 
-	atomic_set(&dio->refcount, 1);
 	spin_lock_init(&dio->bio_lock);
+	dio->refcount = 1;
 	dio->bio_list = NULL;
 	dio->waiter = NULL;
 
@@ -1092,12 +1098,20 @@ direct_io_worker(int rw, struct kiocb *i
 
 	/*
 	 * Sync will always be dropping the final ref and completing the
-	 * operation.  AIO can if it was a broken operation described above
-	 * or in fact if all the bios race to complete before we get here.
-	 * In that case dio_complete() translates the EIOCBQUEUED into
-	 * the proper return code that the caller will hand to aio_complete().
+	 * operation.  AIO can if it was a broken operation described above or
+	 * in fact if all the bios race to complete before we get here.  In
+	 * that case dio_complete() translates the EIOCBQUEUED into the proper
+	 * return code that the caller will hand to aio_complete().
+	 *
+	 * This is managed by the bio_lock instead of being an atomic_t so that
+	 * completion paths can drop their ref and use the remaining count to
+	 * decide to wake the submission path atomically.
 	 */
-	if (atomic_dec_and_test(&dio->refcount)) {
+	spin_lock_irqsave(&dio->bio_lock, flags);
+	ret2 = --dio->refcount;
+	spin_unlock_irqrestore(&dio->bio_lock, flags);
+	BUG_ON(!dio->is_async && ret2 != 0);
+	if (ret2 == 0) {
 		ret = dio_complete(dio, offset, ret);
 		kfree(dio);
 	} else
_

Patches currently in -mm which might be from zach.brown@oracle.com are

origin.patch
optimize-o_direct-on-block-device-v3.patch
optimize-o_direct-on-block-device-v3-tweak.patch

