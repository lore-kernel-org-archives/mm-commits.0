From: akpm@linux-foundation.org
Subject: - ocfs2-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:33 -0700
Message-ID: <200710162033.l9GKXXuF014803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43474 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966203AbXJPVsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:48:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mark.fasheh@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ocfs2: convert to new aops
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ocfs2: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Plug ocfs2 into the ->write_begin and ->write_end aops.

A bunch of custom code is now gone - the iovec iteration stuff during write
and the ocfs2 splice write actor.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   14 +-
 fs/ocfs2/aops.h |    8 -
 fs/ocfs2/file.c |  266 ++--------------------------------------------
 3 files changed, 22 insertions(+), 266 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-convert-to-new-aops fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-convert-to-new-aops
+++ a/fs/ocfs2/aops.c
@@ -1724,9 +1724,9 @@ out:
 	return ret;
 }
 
-int ocfs2_write_begin(struct file *file, struct address_space *mapping,
-		      loff_t pos, unsigned len, unsigned flags,
-		      struct page **pagep, void **fsdata)
+static int ocfs2_write_begin(struct file *file, struct address_space *mapping,
+			     loff_t pos, unsigned len, unsigned flags,
+			     struct page **pagep, void **fsdata)
 {
 	int ret;
 	struct buffer_head *di_bh = NULL;
@@ -1877,9 +1877,9 @@ out_write_size:
 	return copied;
 }
 
-int ocfs2_write_end(struct file *file, struct address_space *mapping,
-		    loff_t pos, unsigned len, unsigned copied,
-		    struct page *page, void *fsdata)
+static int ocfs2_write_end(struct file *file, struct address_space *mapping,
+			   loff_t pos, unsigned len, unsigned copied,
+			   struct page *page, void *fsdata)
 {
 	int ret;
 	struct inode *inode = mapping->host;
@@ -1896,6 +1896,8 @@ int ocfs2_write_end(struct file *file, s
 const struct address_space_operations ocfs2_aops = {
 	.readpage	= ocfs2_readpage,
 	.writepage	= ocfs2_writepage,
+	.write_begin	= ocfs2_write_begin,
+	.write_end	= ocfs2_write_end,
 	.bmap		= ocfs2_bmap,
 	.sync_page	= block_sync_page,
 	.direct_IO	= ocfs2_direct_IO,
diff -puN fs/ocfs2/aops.h~ocfs2-convert-to-new-aops fs/ocfs2/aops.h
--- a/fs/ocfs2/aops.h~ocfs2-convert-to-new-aops
+++ a/fs/ocfs2/aops.h
@@ -44,14 +44,6 @@ int walk_page_buffers(	handle_t *handle,
 			int (*fn)(	handle_t *handle,
 					struct buffer_head *bh));
 
-int ocfs2_write_begin(struct file *file, struct address_space *mapping,
-		      loff_t pos, unsigned len, unsigned flags,
-		      struct page **pagep, void **fsdata);
-
-int ocfs2_write_end(struct file *file, struct address_space *mapping,
-		    loff_t pos, unsigned len, unsigned copied,
-		    struct page *page, void *fsdata);
-
 int ocfs2_write_end_nolock(struct address_space *mapping,
 			   loff_t pos, unsigned len, unsigned copied,
 			   struct page *page, void *fsdata);
diff -puN fs/ocfs2/file.c~ocfs2-convert-to-new-aops fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-convert-to-new-aops
+++ a/fs/ocfs2/file.c
@@ -1881,143 +1881,13 @@ out:
 	return ret;
 }
 
-static inline void
-ocfs2_set_next_iovec(const struct iovec **iovp, size_t *basep, size_t bytes)
-{
-	const struct iovec *iov = *iovp;
-	size_t base = *basep;
-
-	do {
-		int copy = min(bytes, iov->iov_len - base);
-
-		bytes -= copy;
-		base += copy;
-		if (iov->iov_len == base) {
-			iov++;
-			base = 0;
-		}
-	} while (bytes);
-	*iovp = iov;
-	*basep = base;
-}
-
-static struct page * ocfs2_get_write_source(char **ret_src_buf,
-					    const struct iovec *cur_iov,
-					    size_t iov_offset)
-{
-	int ret;
-	char *buf = cur_iov->iov_base + iov_offset;
-	struct page *src_page = NULL;
-	unsigned long off;
-
-	off = (unsigned long)(buf) & ~PAGE_CACHE_MASK;
-
-	if (!segment_eq(get_fs(), KERNEL_DS)) {
-		/*
-		 * Pull in the user page. We want to do this outside
-		 * of the meta data locks in order to preserve locking
-		 * order in case of page fault.
-		 */
-		ret = get_user_pages(current, current->mm,
-				     (unsigned long)buf & PAGE_CACHE_MASK, 1,
-				     0, 0, &src_page, NULL);
-		if (ret == 1)
-			*ret_src_buf = kmap(src_page) + off;
-		else
-			src_page = ERR_PTR(-EFAULT);
-	} else {
-		*ret_src_buf = buf;
-	}
-
-	return src_page;
-}
-
-static void ocfs2_put_write_source(struct page *page)
-{
-	if (page) {
-		kunmap(page);
-		page_cache_release(page);
-	}
-}
-
-static ssize_t ocfs2_file_buffered_write(struct file *file, loff_t *ppos,
-					 const struct iovec *iov,
-					 unsigned long nr_segs,
-					 size_t count,
-					 ssize_t o_direct_written)
-{
-	int ret = 0;
-	ssize_t copied, total = 0;
-	size_t iov_offset = 0, bytes;
-	loff_t pos;
-	const struct iovec *cur_iov = iov;
-	struct page *user_page, *page;
-	char * uninitialized_var(buf);
-	char *dst;
-	void *fsdata;
-
-	/*
-	 * handle partial DIO write.  Adjust cur_iov if needed.
-	 */
-	ocfs2_set_next_iovec(&cur_iov, &iov_offset, o_direct_written);
-
-	do {
-		pos = *ppos;
-
-		user_page = ocfs2_get_write_source(&buf, cur_iov, iov_offset);
-		if (IS_ERR(user_page)) {
-			ret = PTR_ERR(user_page);
-			goto out;
-		}
-
-		/* Stay within our page boundaries */
-		bytes = min((PAGE_CACHE_SIZE - ((unsigned long)pos & ~PAGE_CACHE_MASK)),
-			    (PAGE_CACHE_SIZE - ((unsigned long)buf & ~PAGE_CACHE_MASK)));
-		/* Stay within the vector boundary */
-		bytes = min_t(size_t, bytes, cur_iov->iov_len - iov_offset);
-		/* Stay within count */
-		bytes = min(bytes, count);
-
-		page = NULL;
-		ret = ocfs2_write_begin(file, file->f_mapping, pos, bytes, 0,
-					&page, &fsdata);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
-
-		dst = kmap_atomic(page, KM_USER0);
-		memcpy(dst + (pos & (loff_t)(PAGE_CACHE_SIZE - 1)), buf, bytes);
-		kunmap_atomic(dst, KM_USER0);
-		flush_dcache_page(page);
-		ocfs2_put_write_source(user_page);
-
-		copied = ocfs2_write_end(file, file->f_mapping, pos, bytes,
-					 bytes, page, fsdata);
-		if (copied < 0) {
-			mlog_errno(copied);
-			ret = copied;
-			goto out;
-		}
-
-		total += copied;
-		*ppos = pos + copied;
-		count -= copied;
-
-		ocfs2_set_next_iovec(&cur_iov, &iov_offset, copied);
-	} while(count);
-
-out:
-	return total ? total : ret;
-}
-
 static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 				    const struct iovec *iov,
 				    unsigned long nr_segs,
 				    loff_t pos)
 {
 	int ret, direct_io, appending, rw_level, have_alloc_sem  = 0;
-	int can_do_direct, sync = 0;
+	int can_do_direct;
 	ssize_t written = 0;
 	size_t ocount;		/* original count */
 	size_t count;		/* after file limit checks */
@@ -2033,12 +1903,6 @@ static ssize_t ocfs2_file_aio_write(stru
 	if (iocb->ki_left == 0)
 		return 0;
 
-	ret = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
-	if (ret)
-		return ret;
-
-	count = ocount;
-
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 
 	appending = file->f_flags & O_APPEND ? 1 : 0;
@@ -2082,33 +1946,23 @@ relock:
 		rw_level = -1;
 
 		direct_io = 0;
-		sync = 1;
 		goto relock;
 	}
 
-	if (!sync && ((file->f_flags & O_SYNC) || IS_SYNC(inode)))
-		sync = 1;
-
-	/*
-	 * XXX: Is it ok to execute these checks a second time?
-	 */
-	ret = generic_write_checks(file, ppos, &count, S_ISBLK(inode->i_mode));
-	if (ret)
-		goto out;
-
-	/*
-	 * Set pos so that sync_page_range_nolock() below understands
-	 * where to start from. We might've moved it around via the
-	 * calls above. The range we want to actually sync starts from
-	 * *ppos here.
-	 *
-	 */
-	pos = *ppos;
-
 	/* communicate with ocfs2_dio_end_io */
 	ocfs2_iocb_set_rw_locked(iocb, rw_level);
 
 	if (direct_io) {
+		ret = generic_segment_checks(iov, &nr_segs, &ocount,
+					     VERIFY_READ);
+		if (ret)
+			goto out_dio;
+
+		ret = generic_write_checks(file, ppos, &count,
+					   S_ISBLK(inode->i_mode));
+		if (ret)
+			goto out_dio;
+
 		written = generic_file_direct_write(iocb, iov, &nr_segs, *ppos,
 						    ppos, count, ocount);
 		if (written < 0) {
@@ -2116,14 +1970,8 @@ relock:
 			goto out_dio;
 		}
 	} else {
-		written = ocfs2_file_buffered_write(file, ppos, iov, nr_segs,
-						    count, written);
-		if (written < 0) {
-			ret = written;
-			if (ret != -EFAULT || ret != -ENOSPC)
-				mlog_errno(ret);
-			goto out;
-		}
+		written = generic_file_aio_write_nolock(iocb, iov, nr_segs,
+							*ppos);
 	}
 
 out_dio:
@@ -2153,97 +2001,12 @@ out_sems:
 	if (have_alloc_sem)
 		up_read(&inode->i_alloc_sem);
 
-	if (written > 0 && sync) {
-		ssize_t err;
-
-		err = sync_page_range_nolock(inode, file->f_mapping, pos, count);
-		if (err < 0)
-			written = err;
-	}
-
 	mutex_unlock(&inode->i_mutex);
 
 	mlog_exit(ret);
 	return written ? written : ret;
 }
 
-static int ocfs2_splice_write_actor(struct pipe_inode_info *pipe,
-				    struct pipe_buffer *buf,
-				    struct splice_desc *sd)
-{
-	int ret, count;
-	ssize_t copied = 0;
-	struct file *file = sd->u.file;
-	unsigned int offset;
-	struct page *page = NULL;
-	void *fsdata;
-	char *src, *dst;
-
-	ret = buf->ops->confirm(pipe, buf);
-	if (ret)
-		goto out;
-
-	offset = sd->pos & ~PAGE_CACHE_MASK;
-	count = sd->len;
-	if (count + offset > PAGE_CACHE_SIZE)
-		count = PAGE_CACHE_SIZE - offset;
-
-	ret = ocfs2_write_begin(file, file->f_mapping, sd->pos, count, 0,
-				&page, &fsdata);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	src = buf->ops->map(pipe, buf, 1);
-	dst = kmap_atomic(page, KM_USER1);
-	memcpy(dst + offset, src + buf->offset, count);
-	kunmap_atomic(dst, KM_USER1);
-	buf->ops->unmap(pipe, buf, src);
-
-	copied = ocfs2_write_end(file, file->f_mapping, sd->pos, count, count,
-				 page, fsdata);
-	if (copied < 0) {
-		mlog_errno(copied);
-		ret = copied;
-		goto out;
-	}
-out:
-
-	return copied ? copied : ret;
-}
-
-static ssize_t __ocfs2_file_splice_write(struct pipe_inode_info *pipe,
-					 struct file *out,
-					 loff_t *ppos,
-					 size_t len,
-					 unsigned int flags)
-{
-	int ret, err;
-	struct address_space *mapping = out->f_mapping;
-	struct inode *inode = mapping->host;
-	struct splice_desc sd = {
-		.total_len = len,
-		.flags = flags,
-		.pos = *ppos,
-		.u.file = out,
-	};
-
-	ret = __splice_from_pipe(pipe, &sd, ocfs2_splice_write_actor);
-	if (ret > 0) {
-		*ppos += ret;
-
-		if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
-			err = generic_osync_inode(inode, mapping,
-						  OSYNC_METADATA|OSYNC_DATA);
-			if (err)
-				ret = err;
-		}
-	}
-
-	return ret;
-}
-
 static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 				       struct file *out,
 				       loff_t *ppos,
@@ -2273,8 +2036,7 @@ static ssize_t ocfs2_file_splice_write(s
 		goto out_unlock;
 	}
 
-	/* ok, we're done with i_size and alloc work */
-	ret = __ocfs2_file_splice_write(pipe, out, ppos, len, flags);
+	ret = generic_file_splice_write_nolock(pipe, out, ppos, len, flags);
 
 out_unlock:
 	ocfs2_rw_unlock(inode, 1);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
