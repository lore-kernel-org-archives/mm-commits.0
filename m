From: akpm@linux-foundation.org
Subject: [patch 002/102] block: invalidate the page cache when issuing
 BLKZEROOUT
Date: Tue, 11 Oct 2016 13:51:05 -0700
Message-ID: <57fd50b9.PZD4zubSUMUBdLwC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38529 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbcJKVAu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 17:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, darrick.wong@oracle.com, axboe@kernel.dk, bart.vanassche@sandisk.com, bfoster@redhat.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com, snitzer@redhat.com, tytso@mit.edu

From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: block: invalidate the page cache when issuing BLKZEROOUT

Patch series "fallocate for block devices", v11.

This is a patchset to fix page cache coherency with BLKZEROOUT and
implement fallocate for block devices.

The first patch is a fix to the existing BLKZEROOUT ioctl to invalidate
the page cache if the zeroing command to the underlying device succeeds. 
Without this patch we still have the pagecache coherence bug that's been
in the kernel forever.

The second patch changes the internal block device functions to reject
attempts to discard or zeroout that are not aligned to the logical block
size.  Previously, we only checked that the start/len parameters were
512-byte aligned, which caused kernel BUG_ONs for unaligned IOs to 4k-LBA
devices.

The third patch creates an fallocate handler for block devices, wires up
the FALLOC_FL_PUNCH_HOLE flag to zeroing-discard, and connects
FALLOC_FL_ZERO_RANGE to write-same so that we can have a consistent
fallocate interface between files and block devices.  It also allows the
combination of PUNCH_HOLE and NO_HIDE_STALE to invoke non-zeroing discard.

Test cases for the new block device fallocate are now in xfstests as
generic/349-351.


This patch (of 3):

Invalidate the page cache (as a regular O_DIRECT write would do) to avoid
returning stale cache contents at a later time.

Link: http://lkml.kernel.org/r/147518378313.22791.16649519283678515021.stgit@birch.djwong.org
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ioctl.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN block/ioctl.c~block-invalidate-the-page-cache-when-issuing-blkzeroout block/ioctl.c
--- a/block/ioctl.c~block-invalidate-the-page-cache-when-issuing-blkzeroout
+++ a/block/ioctl.c
@@ -225,7 +225,8 @@ static int blk_ioctl_zeroout(struct bloc
 		unsigned long arg)
 {
 	uint64_t range[2];
-	uint64_t start, len;
+	struct address_space *mapping;
+	uint64_t start, end, len;
 
 	if (!(mode & FMODE_WRITE))
 		return -EBADF;
@@ -235,18 +236,23 @@ static int blk_ioctl_zeroout(struct bloc
 
 	start = range[0];
 	len = range[1];
+	end = start + len - 1;
 
 	if (start & 511)
 		return -EINVAL;
 	if (len & 511)
 		return -EINVAL;
-	start >>= 9;
-	len >>= 9;
