From: akpm@linux-foundation.org
Subject: + fs-return-if-direct-write-will-trigger-writeback.patch added to -mm tree
Date: Thu, 15 Jun 2017 11:54:46 -0700
Message-ID: <5942d7f6.k5tul9CfMgsfUeH8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752583AbdFOSyr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 14:54:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgoldwyn@suse.com, adilger.kernel@dilger.ca, axboe@kernel.dk, clm@fb.com, darrick.wong@oracle.com, dsterba@suse.com, hch@lst.de, jack@suse.cz, jbacik@fb.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: return if direct write will trigger writeback
has been added to the -mm tree.  Its filename is
     fs-return-if-direct-write-will-trigger-writeback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-return-if-direct-write-will-trigger-writeback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-return-if-direct-write-will-trigger-writeback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: fs: return if direct write will trigger writeback

Find out if the write will trigger a wait due to writeback. If yes,
return -EAGAIN.

Return -EINVAL for buffered AIO: there are multiple causes of delay such
as page locks, dirty throttling logic, page loading from disk etc.  which
cannot be taken care of.

Link: http://lkml.kernel.org/r/20170615160002.17233-6-rgoldwyn@suse.de
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Chris Mason <clm@fb.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN mm/filemap.c~fs-return-if-direct-write-will-trigger-writeback mm/filemap.c
--- a/mm/filemap.c~fs-return-if-direct-write-will-trigger-writeback
+++ a/mm/filemap.c
@@ -2675,6 +2675,9 @@ inline ssize_t generic_write_checks(stru
 
 	pos = iocb->ki_pos;
 
+	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
+		return -EINVAL;
+
 	if (limit != RLIM_INFINITY) {
 		if (iocb->ki_pos >= limit) {
 			send_sig(SIGXFSZ, current, 0);
@@ -2743,9 +2746,17 @@ generic_file_direct_write(struct kiocb *
 	write_len = iov_iter_count(from);
 	end = (pos + write_len - 1) >> PAGE_SHIFT;
 
-	written = filemap_write_and_wait_range(mapping, pos, pos + write_len - 1);
-	if (written)
-		goto out;
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		/* If there are pages to writeback, return */
+		if (filemap_range_has_page(inode->i_mapping, pos,
+					   pos + iov_iter_count(from)))
+			return -EAGAIN;
+	} else {
+		written = filemap_write_and_wait_range(mapping, pos,
+							pos + write_len - 1);
+		if (written)
+			goto out;
+	}
 
 	/*
 	 * After a write we want buffered reads to be sure to go to disk to get
_

Patches currently in -mm which might be from rgoldwyn@suse.com are

fs-separate-out-kiocb-flags-setup-based-on-rwf_-flags.patch
fs-introduce-filemap_range_has_page.patch
fs-use-rwf_-flags-for-aio-operations.patch
fs-introduce-rwf_nowait-and-fmode_aio_nowait.patch
fs-return-if-direct-write-will-trigger-writeback.patch
fs-introduce-iomap_nowait.patch
block-return-on-congested-block-device.patch
ext4-nowait-aio-support.patch
xfs-nowait-aio-support.patch
btrfs-nowait-aio-support.patch

