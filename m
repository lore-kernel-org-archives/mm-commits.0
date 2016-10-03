From: akpm@linux-foundation.org
Subject: +
 block-require-write_same-and-discard-requests-align-to-logical-block-size.patch added to -mm tree
Date: Mon, 03 Oct 2016 14:23:17 -0700
Message-ID: <57f2cc45.rVcQyy/DV6Dc2ZH/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36756 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753535AbcJCVXS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2016 17:23:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, axboe@kernel.dk, bart.vanassche@sandisk.com, bfoster@redhat.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com, snitzer@redhat.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: block: require write_same and discard requests align to logical block size
has been added to the -mm tree.  Its filename is
     block-require-write_same-and-discard-requests-align-to-logical-block-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-require-write_same-and-discard-requests-align-to-logical-block-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-require-write_same-and-discard-requests-align-to-logical-block-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: block: require write_same and discard requests align to logical block size

Make sure that the offset and length arguments that we're using to
construct WRITE SAME and DISCARD requests are actually aligned to the
logical block size.  Failure to do this causes other errors in other parts
of the block layer or the SCSI layer because disks don't support partial
logical block writes.

Link: http://lkml.kernel.org/r/147518379026.22791.4437508871355153928.stgit@birch.djwong.org
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Mike Snitzer <snitzer@redhat.com> # tweaked header
Cc: Brian Foster <bfoster@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-lib.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN block/blk-lib.c~block-require-write_same-and-discard-requests-align-to-logical-block-size block/blk-lib.c
--- a/block/blk-lib.c~block-require-write_same-and-discard-requests-align-to-logical-block-size
+++ a/block/blk-lib.c
@@ -31,6 +31,7 @@ int __blkdev_issue_discard(struct block_
 	unsigned int granularity;
 	enum req_op op;
 	int alignment;
+	sector_t bs_mask;
 
 	if (!q)
 		return -ENXIO;
@@ -50,6 +51,10 @@ int __blkdev_issue_discard(struct block_
 		op = REQ_OP_DISCARD;
 	}
 
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if ((sector | nr_sects) & bs_mask)
+		return -EINVAL;
+
 	/* Zero-sector (unknown) and one-sector granularities are the same.  */
 	granularity = max(q->limits.discard_granularity >> 9, 1U);
 	alignment = (bdev_discard_alignment(bdev) >> 9) % granularity;
@@ -150,10 +155,15 @@ int blkdev_issue_write_same(struct block
 	unsigned int max_write_same_sectors;
 	struct bio *bio = NULL;
 	int ret = 0;
+	sector_t bs_mask;
 
 	if (!q)
 		return -ENXIO;
 
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if ((sector | nr_sects) & bs_mask)
+		return -EINVAL;
+
 	/* Ensure that max_write_same_sectors doesn't overflow bi_size */
 	max_write_same_sectors = UINT_MAX >> 9;
 
@@ -202,6 +212,11 @@ static int __blkdev_issue_zeroout(struct
 	int ret;
 	struct bio *bio = NULL;
 	unsigned int sz;
+	sector_t bs_mask;
+
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if ((sector | nr_sects) & bs_mask)
+		return -EINVAL;
 
 	while (nr_sects != 0) {
 		bio = next_bio(bio, min(nr_sects, (sector_t)BIO_MAX_PAGES),
_

Patches currently in -mm which might be from darrick.wong@oracle.com are

block-invalidate-the-page-cache-when-issuing-blkzeroout.patch
block-require-write_same-and-discard-requests-align-to-logical-block-size.patch
block-implement-some-of-fallocate-for-block-devices.patch

