From: akpm@osdl.org
Subject: - dio-only-call-aio_complete-after-returning-eiocbqueued.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:17 -0800
Message-ID: <200612130655.kBD6tHPC030624@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57839 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965028AbWLMGzu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach.brown@oracle.com, jmoyer@redhat.com, pbadari@us.ibm.com, suparna@in.ibm.com, xfs-masters@oss.sgi.com, mm-commits@vger.kernel.org


The patch titled
     dio: only call aio_complete() after returning -EIOCBQUEUED
has been removed from the -mm tree.  Its filename was
     dio-only-call-aio_complete-after-returning-eiocbqueued.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dio: only call aio_complete() after returning -EIOCBQUEUED
From: Zach Brown <zach.brown@oracle.com>

The only time it is safe to call aio_complete() is when the ->ki_retry
function returns -EIOCBQUEUED to the AIO core.  direct_io_worker() has
historically done this by relying on its caller to translate positive return
codes into -EIOCBQUEUED for the aio case.  It did this by trying to keep
conditionals in sync.  direct_io_worker() knew when finished_one_bio() was
going to call aio_complete().  It would reverse the test and wait and free the
dio in the cases it thought that finished_one_bio() wasn't going to.

Not surprisingly, it ended up getting it wrong.  'ret' could be a negative
errno from the submission path but it failed to communicate this to
finished_one_bio().  direct_io_worker() would return < 0, it's callers
wouldn't raise -EIOCBQUEUED, and aio_complete() would be called.  In the
future finished_one_bio()'s tests wouldn't reflect this and aio_complete()
would be called for a second time which can manifest as an oops.

The previous cleanups have whittled the sync and async completion paths down
to the point where we can collapse them and clearly reassert the invariant
that we must only call aio_complete() after returning -EIOCBQUEUED. 
direct_io_worker() will only return -EIOCBQUEUED when it is not the last to
drop the dio refcount and the aio bio completion path will only call
aio_complete() when it is the last to drop the dio refcount. 
direct_io_worker() can ensure that it is the last to drop the reference count
by waiting for bios to drain.  It does this for sync ops, of course, and for
partial dio writes that must fall back to buffered and for aio ops that saw
errors during submission.

This means that operations that end up waiting, even if they were issued as
aio ops, will not call aio_complete() from dio.  Instead we return the return
code of the operation and let the aio core call aio_complete().  This is
purposely done to fix a bug where AIO DIO file extensions would call
aio_complete() before their callers have a chance to update i_size.

Now that direct_io_worker() is explicitly returning -EIOCBQUEUED its callers
no longer have to translate for it.  XFS needs to be careful not to free
resources that will be used during AIO completion if -EIOCBQUEUED is returned.
 We maintain the previous behaviour of trying to write fs metadata for O_SYNC
aio+dio writes.

Signed-off-by: Zach Brown <zach.brown@oracle.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: <xfs-masters@oss.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/direct-io.c              |   92 +++++++++++++---------------------
 fs/xfs/linux-2.6/xfs_aops.c |    2 
 mm/filemap.c                |    9 +--
 3 files changed, 40 insertions(+), 63 deletions(-)

diff -puN fs/direct-io.c~dio-only-call-aio_complete-after-returning-eiocbqueued fs/direct-io.c
--- a/fs/direct-io.c~dio-only-call-aio_complete-after-returning-eiocbqueued
+++ a/fs/direct-io.c
@@ -226,6 +226,15 @@ static int dio_complete(struct dio *dio,
 {
 	ssize_t transferred = 0;
 
+	/*
+	 * AIO submission can race with bio completion to get here while
+	 * expecting to have the last io completed by bio completion.
+	 * In that case -EIOCBQUEUED is in fact not an error we want
+	 * to preserve through this call.
+	 */
+	if (ret == -EIOCBQUEUED)
+		ret = 0;
+
 	if (dio->result) {
 		transferred = dio->result;
 
@@ -251,24 +260,6 @@ static int dio_complete(struct dio *dio,
 	return ret;
 }
 
-/*
- * Called when a BIO has been processed.  If the count goes to zero then IO is
- * complete and we can signal this to the AIO layer.
- */
-static void dio_complete_aio(struct dio *dio)
-{
-	int ret;
-
-	ret = dio_complete(dio, dio->iocb->ki_pos, 0);
-
-	/* Complete AIO later if falling back to buffered i/o */
-	if (dio->result == dio->size ||
-		((dio->rw == READ) && dio->result)) {
-		aio_complete(dio->iocb, ret, 0);
-		kfree(dio);
-	}
-}
-
 static int dio_bio_complete(struct dio *dio, struct bio *bio);
 /*
  * Asynchronous IO callback. 
@@ -290,8 +281,11 @@ static int dio_bio_end_aio(struct bio *b
 	if (remaining == 1 && waiter_holds_ref)
 		wake_up_process(dio->waiter);
 
-	if (remaining == 0)
-		dio_complete_aio(dio);
+	if (remaining == 0) {
+		int ret = dio_complete(dio, dio->iocb->ki_pos, 0);
+		aio_complete(dio->iocb, ret, 0);
+		kfree(dio);
+	}
 
 	return 0;
 }
@@ -1082,47 +1076,33 @@ direct_io_worker(int rw, struct kiocb *i
 		mutex_unlock(&dio->inode->i_mutex);
 
 	/*
-	 * OK, all BIOs are submitted, so we can decrement bio_count to truly
-	 * reflect the number of to-be-processed BIOs.
-	 */
-	if (dio->is_async) {
-		int should_wait = 0;
-
-		if (dio->result < dio->size && (rw & WRITE)) {
-			dio->waiter = current;
-			should_wait = 1;
-		}
-		if (ret == 0)
-			ret = dio->result;
-
-		if (should_wait)
-			dio_await_completion(dio);
-
-		/* this can free the dio */
-		if (atomic_dec_and_test(&dio->refcount))
-			dio_complete_aio(dio);
+	 * The only time we want to leave bios in flight is when a successful
+	 * partial aio read or full aio write have been setup.  In that case
+	 * bio completion will call aio_complete.  The only time it's safe to
+	 * call aio_complete is when we return -EIOCBQUEUED, so we key on that.
+	 * This had *better* be the only place that raises -EIOCBQUEUED.
+	 */
+	BUG_ON(ret == -EIOCBQUEUED);
+	if (dio->is_async && ret == 0 && dio->result &&
+	    ((rw & READ) || (dio->result == dio->size)))
+		ret = -EIOCBQUEUED;
 
-		if (should_wait)
-			kfree(dio);
-	} else {
+	if (ret != -EIOCBQUEUED)
 		dio_await_completion(dio);
 
+	/*
+	 * Sync will always be dropping the final ref and completing the
+	 * operation.  AIO can if it was a broken operation described above
+	 * or in fact if all the bios race to complete before we get here.
+	 * In that case dio_complete() translates the EIOCBQUEUED into
+	 * the proper return code that the caller will hand to aio_complete().
+	 */
+	if (atomic_dec_and_test(&dio->refcount)) {
 		ret = dio_complete(dio, offset, ret);
+		kfree(dio);
+	} else
+		BUG_ON(ret != -EIOCBQUEUED);
 
-		/* We could have also come here on an AIO file extend */
-		if (!is_sync_kiocb(iocb) && (rw & WRITE) &&
-		    ret >= 0 && dio->result == dio->size)
-			/*
-			 * For AIO writes where we have completed the
-			 * i/o, we have to mark the the aio complete.
-			 */
-			aio_complete(iocb, ret, 0);
-
-		if (atomic_dec_and_test(&dio->refcount))
-			kfree(dio);
-		else
-			BUG();
-	}
 	return ret;
 }
 
diff -puN fs/xfs/linux-2.6/xfs_aops.c~dio-only-call-aio_complete-after-returning-eiocbqueued fs/xfs/linux-2.6/xfs_aops.c
--- a/fs/xfs/linux-2.6/xfs_aops.c~dio-only-call-aio_complete-after-returning-eiocbqueued
+++ a/fs/xfs/linux-2.6/xfs_aops.c
@@ -1406,7 +1406,7 @@ xfs_vm_direct_IO(
 			xfs_end_io_direct);
 	}
 
-	if (unlikely(ret <= 0 && iocb->private))
+	if (unlikely(ret != -EIOCBQUEUED && iocb->private))
 		xfs_destroy_ioend(iocb->private);
 	return ret;
 }
diff -puN mm/filemap.c~dio-only-call-aio_complete-after-returning-eiocbqueued mm/filemap.c
--- a/mm/filemap.c~dio-only-call-aio_complete-after-returning-eiocbqueued
+++ a/mm/filemap.c
@@ -1181,8 +1181,6 @@ generic_file_aio_read(struct kiocb *iocb
 		if (pos < size) {
 			retval = generic_file_direct_IO(READ, iocb,
 						iov, pos, nr_segs);
-			if (retval > 0 && !is_sync_kiocb(iocb))
-				retval = -EIOCBQUEUED;
 			if (retval > 0)
 				*ppos = pos + retval;
 		}
@@ -2047,15 +2045,14 @@ generic_file_direct_write(struct kiocb *
 	 * Sync the fs metadata but not the minor inode changes and
 	 * of course not the data as we did direct DMA for the IO.
 	 * i_mutex is held, which protects generic_osync_inode() from
-	 * livelocking.
+	 * livelocking.  AIO O_DIRECT ops attempt to sync metadata here.
 	 */
-	if (written >= 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
+	if ((written >= 0 || written == -EIOCBQUEUED) &&
+	    ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 		int err = generic_osync_inode(inode, mapping, OSYNC_METADATA);
 		if (err < 0)
 			written = err;
 	}
-	if (written == count && !is_sync_kiocb(iocb))
-		written = -EIOCBQUEUED;
 	return written;
 }
 EXPORT_SYMBOL(generic_file_direct_write);
_

Patches currently in -mm which might be from zach.brown@oracle.com are

origin.patch
optimize-o_direct-on-block-device-v3.patch
optimize-o_direct-on-block-device-v3-tweak.patch

