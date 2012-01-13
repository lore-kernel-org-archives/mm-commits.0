From: akpm@linux-foundation.org
Subject: [merged] dio-optimize-cache-misses-in-the-submission-path-v2.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:36:57 -0800
Message-ID: <20120113203658.2AE515C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42927 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUhA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:37:00 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25473eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:36:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: dio: optimize cache misses in the submission path
has been removed from the -mm tree.  Its filename was
     dio-optimize-cache-misses-in-the-submission-path-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: dio: optimize cache misses in the submission path

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

[akpm@linux-foundation.org: coding-style fixes]
[sfr@canb.auug.org.au: using prefetch requires including prefetch.h]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |   46 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff -puN fs/direct-io.c~dio-optimize-cache-misses-in-the-submission-path-v2 fs/direct-io.c
--- a/fs/direct-io.c~dio-optimize-cache-misses-in-the-submission-path-v2
+++ a/fs/direct-io.c
@@ -36,6 +36,7 @@
 #include <linux/rwsem.h>
 #include <linux/uio.h>
 #include <linux/atomic.h>
+#include <linux/prefetch.h>
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
@@ -1087,8 +1088,8 @@ static inline int drop_refcount(struct d
  * individual fields and will generate much worse code. This is important
  * for the whole file.
  */
-ssize_t
-__blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
+static inline ssize_t
+do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
 	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
 	dio_submit_t submit_io,	int flags)
@@ -1097,7 +1098,6 @@ __blockdev_direct_IO(int rw, struct kioc
 	size_t size;
 	unsigned long addr;
 	unsigned blkbits = inode->i_blkbits;
-	unsigned bdev_blkbits = 0;
 	unsigned blocksize_mask = (1 << blkbits) - 1;
 	ssize_t retval = -EINVAL;
 	loff_t end = offset;
@@ -1110,12 +1110,14 @@ __blockdev_direct_IO(int rw, struct kioc
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
@@ -1126,11 +1128,13 @@ __blockdev_direct_IO(int rw, struct kioc
 		addr = (unsigned long)iov[seg].iov_base;
 		size = iov[seg].iov_len;
 		end += size;
-		if ((addr & blocksize_mask) || (size & blocksize_mask))  {
+		if (unlikely((addr & blocksize_mask) ||
+			     (size & blocksize_mask))) {
 			if (bdev)
-				 blkbits = bdev_blkbits;
+				blkbits = blksize_bits(
+					 bdev_logical_block_size(bdev));
 			blocksize_mask = (1 << blkbits) - 1;
-			if ((addr & blocksize_mask) || (size & blocksize_mask))  
+			if ((addr & blocksize_mask) || (size & blocksize_mask))
 				goto out;
 		}
 	}
@@ -1313,6 +1317,30 @@ __blockdev_direct_IO(int rw, struct kioc
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

origin.patch
linux-next.patch

