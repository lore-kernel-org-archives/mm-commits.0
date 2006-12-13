From: akpm@osdl.org
Subject: - dio-centralize-completion-in-dio_complete.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:07 -0800
Message-ID: <200612130655.kBD6t7oG030612@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58020 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965063AbWLMG5I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:57:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach.brown@oracle.com, jmoyer@redhat.com, pbadari@us.ibm.com, suparna@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     dio: centralize completion in dio_complete()
has been removed from the -mm tree.  Its filename was
     dio-centralize-completion-in-dio_complete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dio: centralize completion in dio_complete()
From: Zach Brown <zach.brown@oracle.com>

There have been a lot of bugs recently due to the way direct_io_worker() tries
to decide how to finish direct IO operations.  In the worst examples it has
failed to call aio_complete() at all (hang) or called it too many times
(oops).

This set of patches cleans up the completion phase with the goal of removing
the complexity that lead to these bugs.  We end up with one path that
calculates the result of the operation after all off the bios have completed. 
We decide when to generate a result of the operation using that path based on
the final release of a refcount on the dio structure.

I tried to progress towards the final state in steps that were relatively easy
to understand.  Each step should compile but I only tested the final result of
having all the patches applied.  

I've tested these on low end PC drives with aio-stress, the direct IO tests I
could manage to get running in LTP, orasim, and some home-brew functional
tests.

In http://lkml.org/lkml/2006/9/21/103 IBM reports success with ext2 and ext3
running DIO LTP tests.  They found that XFS bug which has since been addressed
in the patch series.





This patch:

The mechanics which decide the result of a direct IO operation were duplicated
in the sync and async paths.

The async path didn't check page_errors which can manifest as silently
returning success when the final pointer in an operation faults and its
matching file region is filled with zeros.

The sync path and async path differed in whether they passed errors to the
caller's dio->end_io operation.  The async path was passing errors to it which
trips an assertion in XFS, though it is apparently harmless.

This centralizes the completion phase of dio ops in one place.  AIO will now
return EFAULT consistently and all paths fall back to the previously sync
behaviour of passing the number of bytes 'transferred' to the dio->end_io
callback, regardless of errors.

dio_await_completion() doesn't have to propogate EIO from non-uptodate bios
now that it's being propogated through dio_complete() via dio->io_error.  This
lets it return void which simplifies its sole caller.

Signed-off-by: Zach Brown <zach.brown@oracle.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/direct-io.c |   94 +++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 52 deletions(-)

diff -puN fs/direct-io.c~dio-centralize-completion-in-dio_complete fs/direct-io.c
--- a/fs/direct-io.c~dio-centralize-completion-in-dio_complete
+++ a/fs/direct-io.c
@@ -210,19 +210,46 @@ static struct page *dio_get_page(struct 
 	return dio->pages[dio->head++];
 }
 
-/*
- * Called when all DIO BIO I/O has been completed - let the filesystem
- * know, if it registered an interest earlier via get_block.  Pass the
- * private field of the map buffer_head so that filesystems can use it
- * to hold additional state between get_block calls and dio_complete.
+/**
+ * dio_complete() - called when all DIO BIO I/O has been completed
+ * @offset: the byte offset in the file of the completed operation
+ *
+ * This releases locks as dictated by the locking type, lets interested parties
+ * know that a DIO operation has completed, and calculates the resulting return
+ * code for the operation.
+ *
+ * It lets the filesystem know if it registered an interest earlier via
+ * get_block.  Pass the private field of the map buffer_head so that
+ * filesystems can use it to hold additional state between get_block calls and
+ * dio_complete.
  */
-static void dio_complete(struct dio *dio, loff_t offset, ssize_t bytes)
+static int dio_complete(struct dio *dio, loff_t offset, int ret)
 {
+	ssize_t transferred = 0;
+
+	if (dio->result) {
+		transferred = dio->result;
+
+		/* Check for short read case */
+		if ((dio->rw == READ) && ((offset + transferred) > dio->i_size))
+			transferred = dio->i_size - offset;
+	}
+
 	if (dio->end_io && dio->result)
-		dio->end_io(dio->iocb, offset, bytes, dio->map_bh.b_private);
+		dio->end_io(dio->iocb, offset, transferred,
+			    dio->map_bh.b_private);
 	if (dio->lock_type == DIO_LOCKING)
 		/* lockdep: non-owner release */
 		up_read_non_owner(&dio->inode->i_alloc_sem);
+
+	if (ret == 0)
+		ret = dio->page_errors;
+	if (ret == 0)
+		ret = dio->io_error;
+	if (ret == 0)
+		ret = transferred;
+
+	return ret;
 }
 
 /*
@@ -236,8 +263,7 @@ static void finished_one_bio(struct dio 
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	if (dio->bio_count == 1) {
 		if (dio->is_async) {
-			ssize_t transferred;
-			loff_t offset;
+			int ret;
 
 			/*
 			 * Last reference to the dio is going away.
@@ -245,24 +271,12 @@ static void finished_one_bio(struct dio 
 			 */
 			spin_unlock_irqrestore(&dio->bio_lock, flags);
 
-			/* Check for short read case */
-			transferred = dio->result;
-			offset = dio->iocb->ki_pos;
-
-			if ((dio->rw == READ) &&
-			    ((offset + transferred) > dio->i_size))
-				transferred = dio->i_size - offset;
-
-			/* check for error in completion path */
-			if (dio->io_error)
-				transferred = dio->io_error;
-
-			dio_complete(dio, offset, transferred);
+			ret = dio_complete(dio, dio->iocb->ki_pos, 0);
 
 			/* Complete AIO later if falling back to buffered i/o */
 			if (dio->result == dio->size ||
 				((dio->rw == READ) && dio->result)) {
-				aio_complete(dio->iocb, transferred, 0);
+				aio_complete(dio->iocb, ret, 0);
 				kfree(dio);
 				return;
 			} else {
@@ -434,10 +448,8 @@ static int dio_bio_complete(struct dio *
 /*
  * Wait on and process all in-flight BIOs.
  */
-static int dio_await_completion(struct dio *dio)
+static void dio_await_completion(struct dio *dio)
 {
-	int ret = 0;
-
 	if (dio->bio)
 		dio_bio_submit(dio);
 
@@ -448,13 +460,9 @@ static int dio_await_completion(struct d
 	 */
 	while (dio->bio_count) {
 		struct bio *bio = dio_await_one(dio);
-		int ret2;
-
-		ret2 = dio_bio_complete(dio, bio);
-		if (ret == 0)
-			ret = ret2;
+		/* io errors are propogated through dio->io_error */
+		dio_bio_complete(dio, bio);
 	}
-	return ret;
 }
 
 /*
@@ -1127,28 +1135,10 @@ direct_io_worker(int rw, struct kiocb *i
 			kfree(dio);
 		}
 	} else {
-		ssize_t transferred = 0;
-
 		finished_one_bio(dio);
-		ret2 = dio_await_completion(dio);
-		if (ret == 0)
-			ret = ret2;
-		if (ret == 0)
-			ret = dio->page_errors;
-		if (dio->result) {
-			loff_t i_size = i_size_read(inode);
+		dio_await_completion(dio);
 
-			transferred = dio->result;
-			/*
-			 * Adjust the return value if the read crossed a
-			 * non-block-aligned EOF.
-			 */
-			if (rw == READ && (offset + transferred > i_size))
-				transferred = i_size - offset;
-		}
-		dio_complete(dio, offset, transferred);
-		if (ret == 0)
-			ret = transferred;
+		ret = dio_complete(dio, offset, ret);
 
 		/* We could have also come here on an AIO file extend */
 		if (!is_sync_kiocb(iocb) && (rw & WRITE) &&
_

Patches currently in -mm which might be from zach.brown@oracle.com are

origin.patch
optimize-o_direct-on-block-device-v3.patch
optimize-o_direct-on-block-device-v3-tweak.patch

