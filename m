From: akpm@linux-foundation.org
Subject: + xfs-nowait-aio-support.patch added to -mm tree
Date: Thu, 15 Jun 2017 11:54:55 -0700
Message-ID: <5942d7ff.6qXq6Y1N+jY1zhXu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59434 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752630AbdFOSy4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 14:54:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgoldwyn@suse.com, adilger.kernel@dilger.ca, axboe@kernel.dk, clm@fb.com, darrick.wong@oracle.com, dsterba@suse.com, hch@lst.de, jack@suse.cz, jbacik@fb.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: xfs: nowait aio support
has been added to the -mm tree.  Its filename is
     xfs-nowait-aio-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xfs-nowait-aio-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xfs-nowait-aio-support.patch

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
Subject: xfs: nowait aio support

If IOCB_NOWAIT is set, bail if the i_rwsem is not lockable immediately.

IF IOMAP_NOWAIT is set, return EAGAIN in xfs_file_iomap_begin if it needs
allocation either due to file extension, writing to a hole, or COW or
waiting for other DIOs to finish.

Return -EAGAIN if we don't have extent list in memory.

Link: http://lkml.kernel.org/r/20170615160002.17233-10-rgoldwyn@suse.de
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_file.c  |   20 +++++++++++++++-----
 fs/xfs/xfs_iomap.c |   22 ++++++++++++++++++++++
 2 files changed, 37 insertions(+), 5 deletions(-)

diff -puN fs/xfs/xfs_file.c~xfs-nowait-aio-support fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~xfs-nowait-aio-support
+++ a/fs/xfs/xfs_file.c
@@ -541,8 +541,11 @@ xfs_file_dio_aio_write(
 		iolock = XFS_IOLOCK_SHARED;
 	}
 
-	xfs_ilock(ip, iolock);
-
+	if (!xfs_ilock_nowait(ip, iolock)) {
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EAGAIN;
+		xfs_ilock(ip, iolock);
+	}
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
 	if (ret)
 		goto out;
@@ -553,9 +556,15 @@ xfs_file_dio_aio_write(
 	 * otherwise demote the lock if we had to take the exclusive lock
 	 * for other reasons in xfs_file_aio_write_checks.
 	 */
-	if (unaligned_io)
-		inode_dio_wait(inode);
-	else if (iolock == XFS_IOLOCK_EXCL) {
+	if (unaligned_io) {
+		/* If we are going to wait for other DIO to finish, bail */
+		if (iocb->ki_flags & IOCB_NOWAIT) {
+			if (atomic_read(&inode->i_dio_count))
+				return -EAGAIN;
+		} else {
+			inode_dio_wait(inode);
+		}
+	} else if (iolock == XFS_IOLOCK_EXCL) {
 		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
 		iolock = XFS_IOLOCK_SHARED;
 	}
@@ -892,6 +901,7 @@ xfs_file_open(
 		return -EFBIG;
 	if (XFS_FORCED_SHUTDOWN(XFS_M(inode->i_sb)))
 		return -EIO;
+	file->f_mode |= FMODE_AIO_NOWAIT;
 	return 0;
 }
 
diff -puN fs/xfs/xfs_iomap.c~xfs-nowait-aio-support fs/xfs/xfs_iomap.c
--- a/fs/xfs/xfs_iomap.c~xfs-nowait-aio-support
+++ a/fs/xfs/xfs_iomap.c
@@ -995,6 +995,11 @@ xfs_file_iomap_begin(
 		lockmode = xfs_ilock_data_map_shared(ip);
 	}
 
+	if ((flags & IOMAP_NOWAIT) && !(ip->i_df.if_flags & XFS_IFEXTENTS)) {
+		error = -EAGAIN;
+		goto out_unlock;
+	}
+
 	ASSERT(offset <= mp->m_super->s_maxbytes);
 	if ((xfs_fsize_t)offset + length > mp->m_super->s_maxbytes)
 		length = mp->m_super->s_maxbytes - offset;
@@ -1016,6 +1021,15 @@ xfs_file_iomap_begin(
 
 	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
 		if (flags & IOMAP_DIRECT) {
+			/*
+			 * A reflinked inode will result in CoW alloc.
+			 * FIXME: It could still overwrite on unshared extents
+			 * and not need allocation.
+			 */
+			if (flags & IOMAP_NOWAIT) {
+				error = -EAGAIN;
+				goto out_unlock;
+			}
 			/* may drop and re-acquire the ilock */
 			error = xfs_reflink_allocate_cow(ip, &imap, &shared,
 					&lockmode);
@@ -1033,6 +1047,14 @@ xfs_file_iomap_begin(
 
 	if ((flags & IOMAP_WRITE) && imap_needs_alloc(inode, &imap, nimaps)) {
 		/*
+		 * If nowait is set bail since we are going to make
+		 * allocations.
+		 */
+		if (flags & IOMAP_NOWAIT) {
+			error = -EAGAIN;
+			goto out_unlock;
+		}
+		/*
 		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
 		 * pages to keep the chunks of work done where somewhat symmetric
 		 * with the work writeback does. This is a completely arbitrary
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

