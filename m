From: akpm@linux-foundation.org
Subject: + dio-merge-direct_io_walker-into-__blockdev_direct_io.patch added to -mm tree
Date: Tue, 30 Aug 2011 16:53:48 -0700
Message-ID: <201108302353.p7UNrmHw026558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753759Ab1H3Xyb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 19:54:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com


The patch titled
     dio: merge direct_io_walker() into __blockdev_direct_IO()
has been added to the -mm tree.  Its filename is
     dio-merge-direct_io_walker-into-__blockdev_direct_io.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dio: merge direct_io_walker() into __blockdev_direct_IO()
From: Andi Kleen <ak@linux.intel.com>

This doesn't change anything for the compiler, but hch thought it would
make the code clearer.

I moved the reference counting into its own little inline.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |  271 ++++++++++++++++++++++-------------------------
 1 file changed, 132 insertions(+), 139 deletions(-)

diff -puN fs/direct-io.c~dio-merge-direct_io_walker-into-__blockdev_direct_io fs/direct-io.c
--- a/fs/direct-io.c~dio-merge-direct_io_walker-into-__blockdev_direct_io
+++ a/fs/direct-io.c
@@ -1037,136 +1037,10 @@ out:
 	return ret;
 }
 
-static inline ssize_t
-direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode, 
-	const struct iovec *iov, loff_t offset, unsigned long nr_segs, 
-	unsigned blkbits, get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io, struct dio *dio, struct dio_submit *sdio)
+static inline int drop_refcount(struct dio *dio)
 {
-	unsigned long user_addr; 
+	int ret2;
 	unsigned long flags;
-	int seg;
-	ssize_t ret = 0;
-	ssize_t ret2;
-	size_t bytes;
-	struct buffer_head map_bh = { 0, };
-
-	dio->inode = inode;
-	dio->rw = rw;
-	sdio->blkbits = blkbits;
-	sdio->blkfactor = inode->i_blkbits - blkbits;
-	sdio->block_in_file = offset >> blkbits;
-
-	sdio->get_block = get_block;
-	dio->end_io = end_io;
-	sdio->submit_io = submit_io;
-	sdio->final_block_in_bio = -1;
-	sdio->next_block_for_io = -1;
-
-	dio->iocb = iocb;
-	dio->i_size = i_size_read(inode);
-
-	spin_lock_init(&dio->bio_lock);
-	dio->refcount = 1;
-
-	/*
-	 * In case of non-aligned buffers, we may need 2 more
-	 * pages since we need to zero out first and last block.
-	 */
-	if (unlikely(sdio->blkfactor))
-		sdio->pages_in_io = 2;
-
-	for (seg = 0; seg < nr_segs; seg++) {
-		user_addr = (unsigned long)iov[seg].iov_base;
-		sdio->pages_in_io +=
-			((user_addr+iov[seg].iov_len +PAGE_SIZE-1)/PAGE_SIZE
-				- user_addr/PAGE_SIZE);
-	}
-
-	for (seg = 0; seg < nr_segs; seg++) {
-		user_addr = (unsigned long)iov[seg].iov_base;
-		sdio->size += bytes = iov[seg].iov_len;
-
-		/* Index into the first page of the first block */
-		sdio->first_block_in_page = (user_addr & ~PAGE_MASK) >> blkbits;
-		sdio->final_block_in_request = sdio->block_in_file +
-						(bytes >> blkbits);
-		/* Page fetching state */
-		sdio->head = 0;
-		sdio->tail = 0;
-		sdio->curr_page = 0;
-
-		sdio->total_pages = 0;
-		if (user_addr & (PAGE_SIZE-1)) {
-			sdio->total_pages++;
-			bytes -= PAGE_SIZE - (user_addr & (PAGE_SIZE - 1));
-		}
-		sdio->total_pages += (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
-		sdio->curr_user_address = user_addr;
-	
-		ret = do_direct_IO(dio, sdio, &map_bh);
-
-		dio->result += iov[seg].iov_len -
-			((sdio->final_block_in_request - sdio->block_in_file) <<
-					blkbits);
-
-		if (ret) {
-			dio_cleanup(dio, sdio);
-			break;
-		}
-	} /* end iovec loop */
-
-	if (ret == -ENOTBLK) {
-		/*
-		 * The remaining part of the request will be
-		 * be handled by buffered I/O when we return
-		 */
-		ret = 0;
-	}
-	/*
-	 * There may be some unwritten disk at the end of a part-written
-	 * fs-block-sized block.  Go zero that now.
-	 */
-	dio_zero_block(dio, sdio, 1, &map_bh);
-
-	if (sdio->cur_page) {
-		ret2 = dio_send_cur_page(dio, sdio, &map_bh);
-		if (ret == 0)
-			ret = ret2;
-		page_cache_release(sdio->cur_page);
-		sdio->cur_page = NULL;
-	}
-	if (sdio->bio)
-		dio_bio_submit(dio, sdio);
-
-	/*
-	 * It is possible that, we return short IO due to end of file.
-	 * In that case, we need to release all the pages we got hold on.
-	 */
-	dio_cleanup(dio, sdio);
-
-	/*
-	 * All block lookups have been performed. For READ requests
-	 * we can let i_mutex go now that its achieved its purpose
-	 * of protecting us from looking up uninitialized blocks.
-	 */
-	if (rw == READ && (dio->flags & DIO_LOCKING))
-		mutex_unlock(&dio->inode->i_mutex);
-
-	/*
-	 * The only time we want to leave bios in flight is when a successful
-	 * partial aio read or full aio write have been setup.  In that case
-	 * bio completion will call aio_complete.  The only time it's safe to
-	 * call aio_complete is when we return -EIOCBQUEUED, so we key on that.
-	 * This had *better* be the only place that raises -EIOCBQUEUED.
-	 */
-	BUG_ON(ret == -EIOCBQUEUED);
-	if (dio->is_async && ret == 0 && dio->result &&
-	    ((rw & READ) || (dio->result == sdio->size)))
-		ret = -EIOCBQUEUED;
-
-	if (ret != -EIOCBQUEUED)
-		dio_await_completion(dio);
 
 	/*
 	 * Sync will always be dropping the final ref and completing the
@@ -1182,14 +1056,7 @@ direct_io_worker(int rw, struct kiocb *i
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	ret2 = --dio->refcount;
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
-
-	if (ret2 == 0) {
-		ret = dio_complete(dio, offset, ret, false);
-		kmem_cache_free(dio_cache, dio);
-	} else
-		BUG_ON(ret != -EIOCBQUEUED);
-
-	return ret;
+	return ret2;
 }
 
 /*
@@ -1233,6 +1100,9 @@ __blockdev_direct_IO(int rw, struct kioc
 	loff_t end = offset;
 	struct dio *dio;
 	struct dio_submit sdio = { 0, };
+	unsigned long user_addr; 
+	size_t bytes;
+	struct buffer_head map_bh = { 0, };
 
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT;
@@ -1310,9 +1180,132 @@ __blockdev_direct_IO(int rw, struct kioc
 	dio->is_async = !is_sync_kiocb(iocb) && !((rw & WRITE) &&
 		(end > i_size_read(inode)));
 
-	retval = direct_io_worker(rw, iocb, inode, iov, offset,
-				nr_segs, blkbits, get_block, end_io,
-				  submit_io, dio, &sdio);
+	retval = 0;
+
+	dio->inode = inode;
+	dio->rw = rw;
+	sdio.blkbits = blkbits;
+	sdio.blkfactor = inode->i_blkbits - blkbits;
+	sdio.block_in_file = offset >> blkbits;
+
+	sdio.get_block = get_block;
+	dio->end_io = end_io;
+	sdio.submit_io = submit_io;
+	sdio.final_block_in_bio = -1;
+	sdio.next_block_for_io = -1;
+
+	dio->iocb = iocb;
+	dio->i_size = i_size_read(inode);
+
+	spin_lock_init(&dio->bio_lock);
+	dio->refcount = 1;
+
+	/*
+	 * In case of non-aligned buffers, we may need 2 more
+	 * pages since we need to zero out first and last block.
+	 */
+	if (unlikely(sdio.blkfactor))
+		sdio.pages_in_io = 2;
+
+	for (seg = 0; seg < nr_segs; seg++) {
+		user_addr = (unsigned long)iov[seg].iov_base;
+		sdio.pages_in_io +=
+			((user_addr+iov[seg].iov_len +PAGE_SIZE-1)/PAGE_SIZE
+				- user_addr/PAGE_SIZE);
+	}
+
+	for (seg = 0; seg < nr_segs; seg++) {
+		user_addr = (unsigned long)iov[seg].iov_base;
+		sdio.size += bytes = iov[seg].iov_len;
+
+		/* Index into the first page of the first block */
+		sdio.first_block_in_page = (user_addr & ~PAGE_MASK) >> blkbits;
+		sdio.final_block_in_request = sdio.block_in_file +
+						(bytes >> blkbits);
+		/* Page fetching state */
+		sdio.head = 0;
+		sdio.tail = 0;
+		sdio.curr_page = 0;
+
+		sdio.total_pages = 0;
+		if (user_addr & (PAGE_SIZE-1)) {
+			sdio.total_pages++;
+			bytes -= PAGE_SIZE - (user_addr & (PAGE_SIZE - 1));
+		}
+		sdio.total_pages += (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
+		sdio.curr_user_address = user_addr;
+	
+		retval = do_direct_IO(dio, &sdio, &map_bh);
+
+		dio->result += iov[seg].iov_len -
+			((sdio.final_block_in_request - sdio.block_in_file) <<
+					blkbits);
+
+		if (retval) {
+			dio_cleanup(dio, &sdio);
+			break;
+		}
+	} /* end iovec loop */
+
+	if (retval == -ENOTBLK) {
+		/*
+		 * The remaining part of the request will be
+		 * be handled by buffered I/O when we return
+		 */
+		retval = 0;
+	}
+	/*
+	 * There may be some unwritten disk at the end of a part-written
+	 * fs-block-sized block.  Go zero that now.
+	 */
+	dio_zero_block(dio, &sdio, 1, &map_bh);
+
+	if (sdio.cur_page) {
+		ssize_t ret2;
+
+		ret2 = dio_send_cur_page(dio, &sdio, &map_bh);
+		if (retval == 0)
+			retval = ret2;
+		page_cache_release(sdio.cur_page);
+		sdio.cur_page = NULL;
+	}
+	if (sdio.bio)
+		dio_bio_submit(dio, &sdio);
+
+	/*
+	 * It is possible that, we return short IO due to end of file.
+	 * In that case, we need to release all the pages we got hold on.
+	 */
+	dio_cleanup(dio, &sdio);
+
+	/*
+	 * All block lookups have been performed. For READ requests
+	 * we can let i_mutex go now that its achieved its purpose
+	 * of protecting us from looking up uninitialized blocks.
+	 */
+	if (rw == READ && (dio->flags & DIO_LOCKING))
+		mutex_unlock(&dio->inode->i_mutex);
+
+	/*
+	 * The only time we want to leave bios in flight is when a successful
+	 * partial aio read or full aio write have been setup.  In that case
+	 * bio completion will call aio_complete.  The only time it's safe to
+	 * call aio_complete is when we return -EIOCBQUEUED, so we key on that.
+	 * This had *better* be the only place that raises -EIOCBQUEUED.
+	 */
+	BUG_ON(retval == -EIOCBQUEUED);
+	if (dio->is_async && retval == 0 && dio->result &&
+	    ((rw & READ) || (dio->result == sdio.size)))
+		retval = -EIOCBQUEUED;
+
+	if (retval != -EIOCBQUEUED)
+		dio_await_completion(dio);
+
+	if (drop_refcount(dio) == 0) {
+		retval = dio_complete(dio, offset, retval, false);
+		kmem_cache_free(dio_cache, dio);
+	} else
+		BUG_ON(retval != -EIOCBQUEUED);
 
 out:
 	return retval;
_

Patches currently in -mm which might be from ak@linux.intel.com are

linux-next.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-fix-a-wrong-comment.patch
dio-rearrange-fields-in-dio-dio_submit-to-avoid-holes.patch
dio-use-a-slab-cache-for-struct-dio.patch
dio-separate-map_bh-from-dio-v2.patch
dio-inline-the-complete-submission-path-v2.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-remove-unnecessary-dio-argument-from-dio_pages_present.patch
dio-remove-unused-dio-parameter-from-dio_bio_add_page.patch
vfs-cache-request_queue-in-struct-block_device.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch

