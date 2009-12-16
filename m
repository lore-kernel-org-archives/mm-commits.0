From: akpm@linux-foundation.org
Subject: [merged] direct-io-cleanup-blockdev_direct_io-locking.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:39:40 -0800
Message-ID: <200912162039.nBGKdetj013553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935492AbZLPUka (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, aelder@sgi.com, david@fromorbit.com, jens.axboe@oracle.com, jmoyer@redhat.com, joel.becker@oracle.com, mfasheh@suse.com, pbadari@us.ibm.com, viro@zeniv.linux.org.uk, zach.


The patch titled
     direct-io: cleanup blockdev_direct_IO locking
has been removed from the -mm tree.  Its filename was
     direct-io-cleanup-blockdev_direct_io-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: direct-io: cleanup blockdev_direct_IO locking
From: Christoph Hellwig <hch@lst.de>

Currently the locking in blockdev_direct_IO is a mess, we have three
different locking types and very confusing checks for some of them.  The
most complicated one is DIO_OWN_LOCKING for reads, which happens to not
actually be used.

This patch gets rid of the DIO_OWN_LOCKING - as mentioned above the read
case is unused anyway, and the write side is almost identical to
DIO_NO_LOCKING.  The difference is that DIO_NO_LOCKING always sets the
create argument for the get_blocks callback to zero, but we can easily
move that to the actual get_blocks callbacks.  There are four users of the
DIO_NO_LOCKING mode: gfs already ignores the create argument and thus is
fine with the new version, ocfs2 only errors out if create were ever set,
and we can remove this dead code now, the block device code only ever uses
create for an error message if we are fully beyond the device which can
never happen, and last but not least XFS will need the new behavour for
writes.

Now we can replace the lock_type variable with a flags one, where no flag
means the DIO_NO_LOCKING behaviour and DIO_LOCKING is kept as the first
flag.  Separate out the check for not allowing to fill holes into a
separate flag, although for now both flags always get set at the same
time.

Also revamp the documentation of the locking scheme to actually make
sense.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alex Elder <aelder@sgi.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c              |  131 +++++++++++++---------------------
 fs/ocfs2/aops.c             |   34 +-------
 fs/xfs/linux-2.6/xfs_aops.c |   20 +----
 include/linux/fs.h          |   22 ++---
 4 files changed, 72 insertions(+), 135 deletions(-)

diff -puN fs/direct-io.c~direct-io-cleanup-blockdev_direct_io-locking fs/direct-io.c
--- a/fs/direct-io.c~direct-io-cleanup-blockdev_direct_io-locking
+++ a/fs/direct-io.c
@@ -53,13 +53,6 @@
  *
  * If blkfactor is zero then the user's request was aligned to the filesystem's
  * blocksize.
- *
- * lock_type is DIO_LOCKING for regular files on direct-IO-naive filesystems.
- * This determines whether we need to do the fancy locking which prevents
- * direct-IO from being able to read uninitialised disk blocks.  If its zero
- * (blockdev) this locking is not done, and if it is DIO_OWN_LOCKING i_mutex is
- * not held for the entire direct write (taken briefly, initially, during a
- * direct read though, but its never held for the duration of a direct-IO).
  */
 
 struct dio {
@@ -68,7 +61,7 @@ struct dio {
 	struct inode *inode;
 	int rw;
 	loff_t i_size;			/* i_size when submitted */
-	int lock_type;			/* doesn't change */
+	int flags;			/* doesn't change */
 	unsigned blkbits;		/* doesn't change */
 	unsigned blkfactor;		/* When we're using an alignment which
 					   is finer than the filesystem's soft
@@ -246,7 +239,8 @@ static int dio_complete(struct dio *dio,
 	if (dio->end_io && dio->result)
 		dio->end_io(dio->iocb, offset, transferred,
 			    dio->map_bh.b_private);
-	if (dio->lock_type == DIO_LOCKING)
+
+	if (dio->flags & DIO_LOCKING)
 		/* lockdep: non-owner release */
 		up_read_non_owner(&dio->inode->i_alloc_sem);
 
@@ -521,21 +515,24 @@ static int get_more_blocks(struct dio *d
 		map_bh->b_state = 0;
 		map_bh->b_size = fs_count << dio->inode->i_blkbits;
 
+		/*
+		 * For writes inside i_size on a DIO_SKIP_HOLES filesystem we
+		 * forbid block creations: only overwrites are permitted.
+		 * We will return early to the caller once we see an
+		 * unmapped buffer head returned, and the caller will fall
+		 * back to buffered I/O.
+		 *
+		 * Otherwise the decision is left to the get_blocks method,
+		 * which may decide to handle it or also return an unmapped
+		 * buffer head.
+		 */
 		create = dio->rw & WRITE;
-		if (dio->lock_type == DIO_LOCKING) {
+		if (dio->flags & DIO_SKIP_HOLES) {
 			if (dio->block_in_file < (i_size_read(dio->inode) >>
 							dio->blkbits))
 				create = 0;
-		} else if (dio->lock_type == DIO_NO_LOCKING) {
-			create = 0;
 		}
 
-		/*
-		 * For writes inside i_size we forbid block creations: only
-		 * overwrites are permitted.  We fall back to buffered writes
-		 * at a higher level for inside-i_size block-instantiating
-		 * writes.
-		 */
 		ret = (*dio->get_block)(dio->inode, fs_startblk,
 						map_bh, create);
 	}
@@ -1045,7 +1042,7 @@ direct_io_worker(int rw, struct kiocb *i
 	 * we can let i_mutex go now that its achieved its purpose
 	 * of protecting us from looking up uninitialized blocks.
 	 */
-	if ((rw == READ) && (dio->lock_type == DIO_LOCKING))
+	if (rw == READ && (dio->flags & DIO_LOCKING))
 		mutex_unlock(&dio->inode->i_mutex);
 
 	/*
@@ -1092,30 +1089,28 @@ direct_io_worker(int rw, struct kiocb *i
 
 /*
  * This is a library function for use by filesystem drivers.
- * The locking rules are governed by the dio_lock_type parameter.
  *
- * DIO_NO_LOCKING (no locking, for raw block device access)
- * For writes, i_mutex is not held on entry; it is never taken.
- *
- * DIO_LOCKING (simple locking for regular files)
- * For writes we are called under i_mutex and return with i_mutex held, even
- * though it is internally dropped.
- * For reads, i_mutex is not held on entry, but it is taken and dropped before
- * returning.
- *
- * DIO_OWN_LOCKING (filesystem provides synchronisation and handling of
- *	uninitialised data, allowing parallel direct readers and writers)
- * For writes we are called without i_mutex, return without it, never touch it.
- * For reads we are called under i_mutex and return with i_mutex held, even
- * though it may be internally dropped.
- *
- * Additional i_alloc_sem locking requirements described inline below.
+ * The locking rules are governed by the flags parameter:
+ *  - if the flags value contains DIO_LOCKING we use a fancy locking
+ *    scheme for dumb filesystems.
+ *    For writes this function is called under i_mutex and returns with
+ *    i_mutex held, for reads, i_mutex is not held on entry, but it is
+ *    taken and dropped again before returning.
+ *    For reads and writes i_alloc_sem is taken in shared mode and released
+ *    on I/O completion (which may happen asynchronously after returning to
+ *    the caller).
+ *
+ *  - if the flags value does NOT contain DIO_LOCKING we don't use any
+ *    internal locking but rather rely on the filesystem to synchronize
+ *    direct I/O reads/writes versus each other and truncate.
+ *    For reads and writes both i_mutex and i_alloc_sem are not held on
+ *    entry and are never taken.
  */
 ssize_t
 __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
 	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	int dio_lock_type)
+	int flags)
 {
 	int seg;
 	size_t size;
@@ -1126,8 +1121,6 @@ __blockdev_direct_IO(int rw, struct kioc
 	ssize_t retval = -EINVAL;
 	loff_t end = offset;
 	struct dio *dio;
-	int release_i_mutex = 0;
-	int acquire_i_mutex = 0;
 
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT_PLUG;
@@ -1168,43 +1161,30 @@ __blockdev_direct_IO(int rw, struct kioc
 	 */
 	memset(dio, 0, offsetof(struct dio, pages));
 
-	/*
-	 * For block device access DIO_NO_LOCKING is used,
-	 *	neither readers nor writers do any locking at all
-	 * For regular files using DIO_LOCKING,
-	 *	readers need to grab i_mutex and i_alloc_sem
-	 *	writers need to grab i_alloc_sem only (i_mutex is already held)
-	 * For regular files using DIO_OWN_LOCKING,
-	 *	neither readers nor writers take any locks here
-	 */
-	dio->lock_type = dio_lock_type;
-	if (dio_lock_type != DIO_NO_LOCKING) {
+	dio->flags = flags;
+	if (dio->flags & DIO_LOCKING) {
 		/* watch out for a 0 len io from a tricksy fs */
 		if (rw == READ && end > offset) {
-			struct address_space *mapping;
+			struct address_space *mapping =
+					iocb->ki_filp->f_mapping;
 
-			mapping = iocb->ki_filp->f_mapping;
-			if (dio_lock_type != DIO_OWN_LOCKING) {
-				mutex_lock(&inode->i_mutex);
-				release_i_mutex = 1;
-			}
+			/* will be released by direct_io_worker */
+			mutex_lock(&inode->i_mutex);
 
 			retval = filemap_write_and_wait_range(mapping, offset,
 							      end - 1);
 			if (retval) {
+				mutex_unlock(&inode->i_mutex);
 				kfree(dio);
 				goto out;
 			}
-
-			if (dio_lock_type == DIO_OWN_LOCKING) {
-				mutex_unlock(&inode->i_mutex);
-				acquire_i_mutex = 1;
-			}
 		}
 
-		if (dio_lock_type == DIO_LOCKING)
-			/* lockdep: not the owner will release it */
-			down_read_non_owner(&inode->i_alloc_sem);
+		/*
+		 * Will be released at I/O completion, possibly in a
+		 * different thread.
+		 */
+		down_read_non_owner(&inode->i_alloc_sem);
 	}
 
 	/*
@@ -1222,24 +1202,19 @@ __blockdev_direct_IO(int rw, struct kioc
 	/*
 	 * In case of error extending write may have instantiated a few
 	 * blocks outside i_size. Trim these off again for DIO_LOCKING.
-	 * NOTE: DIO_NO_LOCK/DIO_OWN_LOCK callers have to handle this by
-	 * it's own meaner.
+	 *
+	 * NOTE: filesystems with their own locking have to handle this
+	 * on their own.
 	 */
-	if (unlikely(retval < 0 && (rw & WRITE))) {
-		loff_t isize = i_size_read(inode);
-
-		if (end > isize && dio_lock_type == DIO_LOCKING)
-			vmtruncate(inode, isize);
+	if (dio->flags & DIO_LOCKING) {
+		if (unlikely((rw & WRITE) && retval < 0)) {
+			loff_t isize = i_size_read(inode);
+			if (end > isize)
+				vmtruncate(inode, isize);
+		}
 	}
 
-	if (rw == READ && dio_lock_type == DIO_LOCKING)
-		release_i_mutex = 0;
-
 out:
-	if (release_i_mutex)
-		mutex_unlock(&inode->i_mutex);
-	else if (acquire_i_mutex)
-		mutex_lock(&inode->i_mutex);
 	return retval;
 }
 EXPORT_SYMBOL(__blockdev_direct_IO);
diff -puN fs/ocfs2/aops.c~direct-io-cleanup-blockdev_direct_io-locking fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~direct-io-cleanup-blockdev_direct_io-locking
+++ a/fs/ocfs2/aops.c
@@ -547,6 +547,9 @@ bail:
  *
  * called like this: dio->get_blocks(dio->inode, fs_startblk,
  * 					fs_count, map_bh, dio->rw == WRITE);
+ *
+ * Note that we never bother to allocate blocks here, and thus ignore the
+ * create argument.
  */
 static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
 				     struct buffer_head *bh_result, int create)
@@ -563,14 +566,6 @@ static int ocfs2_direct_IO_get_blocks(st
 
 	inode_blocks = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
 
-	/*
-	 * Any write past EOF is not allowed because we'd be extending.
-	 */
-	if (create && (iblock + max_blocks) > inode_blocks) {
-		ret = -EIO;
-		goto bail;
-	}
-
 	/* This figures out the size of the next contiguous block, and
 	 * our logical offset */
 	ret = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno,
@@ -582,15 +577,6 @@ static int ocfs2_direct_IO_get_blocks(st
 		goto bail;
 	}
 
-	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)) && !p_blkno && create) {
-		ocfs2_error(inode->i_sb,
-			    "Inode %llu has a hole at block %llu\n",
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
-			    (unsigned long long)iblock);
-		ret = -EROFS;
-		goto bail;
-	}
-
 	/* We should already CoW the refcounted extent. */
 	BUG_ON(ext_flags & OCFS2_EXT_REFCOUNTED);
 	/*
@@ -601,20 +587,8 @@ static int ocfs2_direct_IO_get_blocks(st
 	 */
 	if (p_blkno && !(ext_flags & OCFS2_EXT_UNWRITTEN))
 		map_bh(bh_result, inode->i_sb, p_blkno);
-	else {
-		/*
-		 * ocfs2_prepare_inode_for_write() should have caught
-		 * the case where we'd be filling a hole and triggered
-		 * a buffered write instead.
-		 */
-		if (create) {
-			ret = -EIO;
-			mlog_errno(ret);
-			goto bail;
-		}
-
+	else
 		clear_buffer_mapped(bh_result);
-	}
 
 	/* make sure we don't map more than max_blocks blocks here as
 	   that's all the kernel will handle at this point. */
diff -puN fs/xfs/linux-2.6/xfs_aops.c~direct-io-cleanup-blockdev_direct_io-locking fs/xfs/linux-2.6/xfs_aops.c
--- a/fs/xfs/linux-2.6/xfs_aops.c~direct-io-cleanup-blockdev_direct_io-locking
+++ a/fs/xfs/linux-2.6/xfs_aops.c
@@ -1474,19 +1474,13 @@ xfs_vm_direct_IO(
 
 	bdev = xfs_find_bdev_for_inode(XFS_I(inode));
 
-	if (rw == WRITE) {
-		iocb->private = xfs_alloc_ioend(inode, IOMAP_UNWRITTEN);
-		ret = blockdev_direct_IO_own_locking(rw, iocb, inode,
-			bdev, iov, offset, nr_segs,
-			xfs_get_blocks_direct,
-			xfs_end_io_direct);
-	} else {
-		iocb->private = xfs_alloc_ioend(inode, IOMAP_READ);
-		ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
-			bdev, iov, offset, nr_segs,
-			xfs_get_blocks_direct,
-			xfs_end_io_direct);
-	}
+	iocb->private = xfs_alloc_ioend(inode, rw == WRITE ?
+					IOMAP_UNWRITTEN : IOMAP_READ);
+
+	ret = blockdev_direct_IO_no_locking(rw, iocb, inode, bdev, iov,
+					    offset, nr_segs,
+					    xfs_get_blocks_direct,
+					    xfs_end_io_direct);
 
 	if (unlikely(ret != -EIOCBQUEUED && iocb->private))
 		xfs_destroy_ioend(iocb->private);
diff -puN include/linux/fs.h~direct-io-cleanup-blockdev_direct_io-locking include/linux/fs.h
--- a/include/linux/fs.h~direct-io-cleanup-blockdev_direct_io-locking
+++ a/include/linux/fs.h
@@ -2264,9 +2264,11 @@ ssize_t __blockdev_direct_IO(int rw, str
 	int lock_type);
 
 enum {
-	DIO_LOCKING = 1, /* need locking between buffered and direct access */
-	DIO_NO_LOCKING,  /* bdev; no locking at all between buffered/direct */
-	DIO_OWN_LOCKING, /* filesystem locks buffered and direct internally */
+	/* need locking between buffered and direct access */
+	DIO_LOCKING	= 0x01,
+
+	/* filesystem does not support filling holes */
+	DIO_SKIP_HOLES	= 0x02,
 };
 
 static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
@@ -2275,7 +2277,8 @@ static inline ssize_t blockdev_direct_IO
 	dio_iodone_t end_io)
 {
 	return __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
-				nr_segs, get_block, end_io, DIO_LOCKING);
+				    nr_segs, get_block, end_io,
+				    DIO_LOCKING | DIO_SKIP_HOLES);
 }
 
 static inline ssize_t blockdev_direct_IO_no_locking(int rw, struct kiocb *iocb,
@@ -2284,16 +2287,7 @@ static inline ssize_t blockdev_direct_IO
 	dio_iodone_t end_io)
 {
 	return __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
-				nr_segs, get_block, end_io, DIO_NO_LOCKING);
-}
