From: akpm@linux-foundation.org
Subject: [to-be-updated] btrfs-nowait-aio-support.patch removed from -mm
 tree
Date: Fri, 16 Jun 2017 13:00:25 -0700
Message-ID: <594438d9.tqECsCC38Vy7j1Ak%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44594 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbdFPUA0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 16:00:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgoldwyn@suse.com, adilger.kernel@dilger.ca, axboe@kernel.dk, clm@fb.com, darrick.wong@oracle.com, dsterba@suse.com, hch@lst.de, jack@suse.cz, jbacik@fb.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: nowait aio support
has been removed from the -mm tree.  Its filename was
     btrfs-nowait-aio-support.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: btrfs: nowait aio support

Return EAGAIN if any of the following checks fail
 + i_rwsem is not lockable
 + NODATACOW or PREALLOC is not set
 + Cannot nocow at the desired location
 + Writing beyond end of file which is not allocated

Link: http://lkml.kernel.org/r/20170615160002.17233-11-rgoldwyn@suse.de
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Acked-by: David Sterba <dsterba@suse.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Chris Mason <clm@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/file.c  |   33 +++++++++++++++++++++++++++------
 fs/btrfs/inode.c |    3 +++
 2 files changed, 30 insertions(+), 6 deletions(-)

diff -puN fs/btrfs/file.c~btrfs-nowait-aio-support fs/btrfs/file.c
--- a/fs/btrfs/file.c~btrfs-nowait-aio-support
+++ a/fs/btrfs/file.c
@@ -1881,12 +1881,29 @@ static ssize_t btrfs_file_write_iter(str
 	ssize_t num_written = 0;
 	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
 	ssize_t err;
-	loff_t pos;
-	size_t count;
+	loff_t pos = iocb->ki_pos;
+	size_t count = iov_iter_count(from);
 	loff_t oldsize;
 	int clean_page = 0;
 
-	inode_lock(inode);
+	if ((iocb->ki_flags & IOCB_NOWAIT) &&
+			(iocb->ki_flags & IOCB_DIRECT)) {
+		/* Don't sleep on inode rwsem */
+		if (!inode_trylock(inode))
+			return -EAGAIN;
+		/*
+		 * We will allocate space in case nodatacow is not set,
+		 * so bail
+		 */
+		if (!(BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
+					      BTRFS_INODE_PREALLOC)) ||
+		    check_can_nocow(BTRFS_I(inode), pos, &count) <= 0) {
+			inode_unlock(inode);
+			return -EAGAIN;
+		}
+	} else
+		inode_lock(inode);
+
 	err = generic_write_checks(iocb, from);
 	if (err <= 0) {
 		inode_unlock(inode);
@@ -1920,8 +1937,6 @@ static ssize_t btrfs_file_write_iter(str
 	 */
 	update_time_for_write(inode);
 
-	pos = iocb->ki_pos;
-	count = iov_iter_count(from);
 	start_pos = round_down(pos, fs_info->sectorsize);
 	oldsize = i_size_read(inode);
 	if (start_pos > oldsize) {
@@ -3083,13 +3098,19 @@ out:
 	return offset;
 }
 
+static int btrfs_file_open(struct inode *inode, struct file *filp)
+{
+	filp->f_mode |= FMODE_AIO_NOWAIT;
+	return generic_file_open(inode, filp);
+}
+
 const struct file_operations btrfs_file_operations = {
 	.llseek		= btrfs_file_llseek,
 	.read_iter      = generic_file_read_iter,
 	.splice_read	= generic_file_splice_read,
 	.write_iter	= btrfs_file_write_iter,
 	.mmap		= btrfs_file_mmap,
-	.open		= generic_file_open,
+	.open		= btrfs_file_open,
 	.release	= btrfs_release_file,
 	.fsync		= btrfs_sync_file,
 	.fallocate	= btrfs_fallocate,
diff -puN fs/btrfs/inode.c~btrfs-nowait-aio-support fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~btrfs-nowait-aio-support
+++ a/fs/btrfs/inode.c
@@ -8764,6 +8764,9 @@ static ssize_t btrfs_direct_IO(struct ki
 			dio_data.overwrite = 1;
 			inode_unlock(inode);
 			relock = true;
+		} else if (iocb->ki_flags & IOCB_NOWAIT) {
+			ret = -EAGAIN;
+			goto out;
 		}
 		ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
 						   offset, count);
_

Patches currently in -mm which might be from rgoldwyn@suse.com are


