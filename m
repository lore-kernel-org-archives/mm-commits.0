From: akpm@linux-foundation.org
Subject: [patch 004/102] block: implement (some of) fallocate for block
 devices
Date: Tue, 11 Oct 2016 13:51:11 -0700
Message-ID: <57fd50bf.px1rfOmJdNS/BSxf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38531 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752514AbcJKVAu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 17:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, darrick.wong@oracle.com, axboe@kernel.dk, bart.vanassche@sandisk.com, bfoster@redhat.com, hare@suse.com, hare@suse.de, hch@infradead.org, martin.petersen@oracle.com, snitzer@redhat.com, tytso@mit.edu

From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: block: implement (some of) fallocate for block devices

After much discussion, it seems that the fallocate feature flag
FALLOC_FL_ZERO_RANGE maps nicely to SCSI WRITE SAME; and the feature
FALLOC_FL_PUNCH_HOLE maps nicely to the devices that have been whitelisted
for zeroing SCSI UNMAP.  Punch still requires that FALLOC_FL_KEEP_SIZE is
set.  A length that goes past the end of the device will be clamped to the
device size if KEEP_SIZE is set; or will return -EINVAL if not.  Both
start and length must be aligned to the device's logical block size.

Since the semantics of fallocate are fairly well established already, wire
up the two pieces.  The other fallocate variants (collapse range, insert
range, and allocate blocks) are not supported.

Link: http://lkml.kernel.org/r/147518379992.22791.8849838163218235007.stgit@birch.djwong.org
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com> # tweaked header
Cc: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/open.c      |    3 +
 2 files changed, 79 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~block-implement-some-of-fallocate-for-block-devices fs/block_dev.c
--- a/fs/block_dev.c~block-implement-some-of-fallocate-for-block-devices
+++ a/fs/block_dev.c
@@ -30,6 +30,7 @@
 #include <linux/cleancache.h>
 #include <linux/dax.h>
 #include <linux/badblocks.h>
+#include <linux/falloc.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -1775,6 +1776,81 @@ static const struct address_space_operat
 	.is_dirty_writeback = buffer_check_dirty_writeback,
 };
 
+#define	BLKDEV_FALLOC_FL_SUPPORTED					\
+		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
+		 FALLOC_FL_ZERO_RANGE | FALLOC_FL_NO_HIDE_STALE)
+
+static long blkdev_fallocate(struct file *file, int mode, loff_t start,
+			     loff_t len)
+{
+	struct block_device *bdev = I_BDEV(bdev_file_inode(file));
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct address_space *mapping;
+	loff_t end = start + len - 1;
+	loff_t isize;
+	int error;
+
+	/* Fail if we don't recognize the flags. */
+	if (mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
+		return -EOPNOTSUPP;
+
+	/* Don't go off the end of the device. */
+	isize = i_size_read(bdev->bd_inode);
+	if (start >= isize)
+		return -EINVAL;
+	if (end >= isize) {
+		if (mode & FALLOC_FL_KEEP_SIZE) {
+			len = isize - start;
+			end = start + len - 1;
+		} else
+			return -EINVAL;
+	}
+
+	/*
+	 * Don't allow IO that isn't aligned to logical block size.
+	 */
+	if ((start | len) & (bdev_logical_block_size(bdev) - 1))
+		return -EINVAL;
+
+	/* Invalidate the page cache, including dirty pages. */
+	mapping = bdev->bd_inode->i_mapping;
+	truncate_inode_pages_range(mapping, start, end);
+
+	switch (mode) {
+	case FALLOC_FL_ZERO_RANGE:
+	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE:
+		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
+					    GFP_KERNEL, false);
+		break;
+	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
+		/* Only punch if the device can do zeroing discard. */
+		if (!blk_queue_discard(q) || !q->limits.discard_zeroes_data)
+			return -EOPNOTSUPP;
+		error = blkdev_issue_discard(bdev, start >> 9, len >> 9,
+					     GFP_KERNEL, 0);
+		break;
+	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
+		if (!blk_queue_discard(q))
+			return -EOPNOTSUPP;
+		error = blkdev_issue_discard(bdev, start >> 9, len >> 9,
+					     GFP_KERNEL, 0);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	if (error)
+		return error;
+
+	/*
+	 * Invalidate again; if someone wandered in and dirtied a page,
+	 * the caller will be given -EBUSY.  The third argument is
+	 * inclusive, so the rounding here is safe.
+	 */
+	return invalidate_inode_pages2_range(mapping,
+					     start >> PAGE_SHIFT,
+					     end >> PAGE_SHIFT);
+}
+
 const struct file_operations def_blk_fops = {
 	.open		= blkdev_open,
 	.release	= blkdev_close,
@@ -1789,6 +1865,7 @@ const struct file_operations def_blk_fop
 #endif
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
+	.fallocate	= blkdev_fallocate,
 };
 
 int ioctl_by_bdev(struct block_device *bdev, unsigned cmd, unsigned long arg)
diff -puN fs/open.c~block-implement-some-of-fallocate-for-block-devices fs/open.c
--- a/fs/open.c~block-implement-some-of-fallocate-for-block-devices
+++ a/fs/open.c
@@ -300,7 +300,8 @@ int vfs_fallocate(struct file *file, int
 	 * Let individual file system decide if it supports preallocation
 	 * for directories or not.
 	 */
-	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
+	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode) &&
+	    !S_ISBLK(inode->i_mode))
 		return -ENODEV;
 
 	/* Check for wrap through zero too */
_
