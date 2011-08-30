From: akpm@linux-foundation.org
Subject: + dio-optimize-cache-misses-in-the-submission-path-v2.patch added to -mm tree
Date: Tue, 30 Aug 2011 16:51:47 -0700
Message-ID: <201108302351.p7UNpltW026482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753759Ab1H3Xwg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 19:52:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com


The patch titled
     dio: optimize cache misses in the submission path
has been added to the -mm tree.  Its filename is
     dio-optimize-cache-misses-in-the-submission-path-v2.patch

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
Subject: dio: optimize cache misses in the submission path
From: Andi Kleen <ak@linux.intel.com>

Some investigation of a transaction processing workload showed that a
major consumer of cycles in __blockdev_direct_IO is the cache miss while
accessing the block size.  This is because it has to walk the chain from
block_dev to gendisk to queue.

The block size is needed early on to check alignment and sizes.  It's only
done if the check for the inode block size fails.  But the costly block
device state is unconditionally fetched.

- Reorganize the code to only fetch block dev state when actually
  needed.

Then do a prefetch on the block dev early on in the direct IO path.  This
is worth it, because there is substantial code run before we actually
touch the block dev now.

- I also added some unlikelies to make it clear the compiler that block
  device fetch code is not normally executed.

This gave a small, but measurable improvement on a large database
benchmark (about 0.3%)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |   45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff -puN fs/direct-io.c~dio-optimize-cache-misses-in-the-submission-path-v2 fs/direct-io.c
--- a/fs/direct-io.c~dio-optimize-cache-misses-in-the-submission-path-v2
+++ a/fs/direct-io.c
@@ -1084,8 +1084,8 @@ static inline int drop_refcount(struct d
  * individual fields and will generate much worse code.
  * This is important for the whole file.
  */
-ssize_t
-__blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
+static inline ssize_t
+do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
 	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
 	dio_submit_t submit_io,	int flags)
@@ -1094,7 +1094,6 @@ __blockdev_direct_IO(int rw, struct kioc
 	size_t size;
 	unsigned long addr;
 	unsigned blkbits = inode->i_blkbits;
-	unsigned bdev_blkbits = 0;
 	unsigned blocksize_mask = (1 << blkbits) - 1;
 	ssize_t retval = -EINVAL;
 	loff_t end = offset;
@@ -1107,12 +1106,14 @@ __blockdev_direct_IO(int rw, struct kioc
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT;
 
-	if (bdev)
-		bdev_blkbits = blksize_bits(bdev_logical_block_size(bdev));
+	/* 
+	 * Avoid references to bdev if not absolutely needed to give
+	 * the early prefetch in the caller enough time.
+	 */
 
 	if (offset & blocksize_mask) {
 		if (bdev)
-			 blkbits = bdev_blkbits;
+			blkbits = blksize_bits(bdev_logical_block_size(bdev));
 		blocksize_mask = (1 << blkbits) - 1;
 		if (offset & blocksize_mask)
 			goto out;
@@ -1123,11 +1124,13 @@ __blockdev_direct_IO(int rw, struct kioc
 		addr = (unsigned long)iov[seg].iov_base;
 		size = iov[seg].iov_len;
 		end += size;
-		if ((addr & blocksize_mask) || (size & blocksize_mask))  {
+		if (unlikely((addr & blocksize_mask) || 
+			     (size & blocksize_mask)))  {
 			if (bdev)
-				 blkbits = bdev_blkbits;
+				 blkbits = blksize_bits(
+					 bdev_logical_block_size(bdev));
 			blocksize_mask = (1 << blkbits) - 1;
-			if ((addr & blocksize_mask) || (size & blocksize_mask))  
+			if ((addr & blocksize_mask) || (size & blocksize_mask))
 				goto out;
 		}
 	}
@@ -1310,6 +1313,30 @@ __blockdev_direct_IO(int rw, struct kioc
 out:
 	return retval;
 }
+
+ssize_t
+__blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
+	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
+	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
+	dio_submit_t submit_io,	int flags)
+{
+	/* 
+	 * The block device state is needed in the end to finally
+	 * submit everything.  Since it's likely to be cache cold
+	 * prefetch it here as first thing to hide some of the
+	 * latency.
+	 * 
+	 * Attempt to prefetch the pieces we likely need later.
+	 */
+	prefetch(&bdev->bd_disk->part_tbl);
+	prefetch(bdev->bd_queue);
+	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
+
+	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
+				     nr_segs, get_block, end_io,
+				     submit_io, flags);
+}
+
 EXPORT_SYMBOL(__blockdev_direct_IO);
 
 static __init int dio_init(void)
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

