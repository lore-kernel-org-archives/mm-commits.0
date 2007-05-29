From: akpm@linux-foundation.org
Subject: + fs-new-cont-helpers.patch added to -mm tree
Date: Tue, 29 May 2007 14:20:11 -0700
Message-ID: <200705292120.l4TLKBlM011760@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161AbXE2VUS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:20:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, hirofumi@mail.parknet.co.jp


The patch titled
     fs: new cont helpers
has been added to the -mm tree.  Its filename is
     fs-new-cont-helpers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs: new cont helpers
From: Nick Piggin <npiggin@suse.de>

Rework the generic block "cont" routines to handle the new aops.  Supporting
cont_prepare_write would take quite a lot of code to support, so remove it
instead (and we later convert all filesystems to use it).

write_begin gets passed AOP_FLAG_CONT_EXPAND when called from
generic_cont_expand, so filesystems can avoid the old hacks they used.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |  198 ++++++++++++++++------------------
 include/linux/buffer_head.h |    5 
 include/linux/fs.h          |    1 
 mm/filemap.c                |    5 
 4 files changed, 105 insertions(+), 104 deletions(-)

diff -puN fs/buffer.c~fs-new-cont-helpers fs/buffer.c
--- a/fs/buffer.c~fs-new-cont-helpers
+++ a/fs/buffer.c
@@ -2125,14 +2125,14 @@ int block_read_full_page(struct page *pa
 }
 
 /* utility function for filesystems that need to do work on expanding
- * truncates.  Uses prepare/commit_write to allow the filesystem to
+ * truncates.  Uses filesystem pagecache writes to allow the filesystem to
  * deal with the hole.  
  */
-static int __generic_cont_expand(struct inode *inode, loff_t size,
-				 pgoff_t index, unsigned int offset)
+int generic_cont_expand_simple(struct inode *inode, loff_t size)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
+	void *fsdata;
 	unsigned long limit;
 	int err;
 
@@ -2145,140 +2145,134 @@ static int __generic_cont_expand(struct 
 	if (size > inode->i_sb->s_maxbytes)
 		goto out;
 
-	err = -ENOMEM;
-	page = grab_cache_page(mapping, index);
-	if (!page)
-		goto out;
-	err = mapping->a_ops->prepare_write(NULL, page, offset, offset);
-	if (err) {
-		/*
-		 * ->prepare_write() may have instantiated a few blocks
-		 * outside i_size.  Trim these off again.
-		 */
-		unlock_page(page);
-		page_cache_release(page);
-		vmtruncate(inode, inode->i_size);
+	err = pagecache_write_begin(NULL, mapping, size, 0,
+				AOP_FLAG_UNINTERRUPTIBLE|AOP_FLAG_CONT_EXPAND,
+				&page, &fsdata);
+	if (err)
 		goto out;
-	}
 
-	err = mapping->a_ops->commit_write(NULL, page, offset, offset);
+	err = pagecache_write_end(NULL, mapping, size, 0, 0, page, fsdata);
+	BUG_ON(err > 0);
 
-	unlock_page(page);
-	page_cache_release(page);
-	if (err > 0)
-		err = 0;
 out:
 	return err;
 }
 
 int generic_cont_expand(struct inode *inode, loff_t size)
 {
-	pgoff_t index;
 	unsigned int offset;
 
 	offset = (size & (PAGE_CACHE_SIZE - 1)); /* Within page */
 
 	/* ugh.  in prepare/commit_write, if from==to==start of block, we
-	** skip the prepare.  make sure we never send an offset for the start
-	** of a block
-	*/
+	 * skip the prepare.  make sure we never send an offset for the start
+	 * of a block.
+	 * XXX: actually, this should be handled in those filesystems by
+	 * checking for the AOP_FLAG_CONT_EXPAND flag.
+	 */
 	if ((offset & (inode->i_sb->s_blocksize - 1)) == 0) {
 		/* caller must handle this extra byte. */
-		offset++;
+		size++;
 	}
-	index = size >> PAGE_CACHE_SHIFT;
-
-	return __generic_cont_expand(inode, size, index, offset);
-}
-
-int generic_cont_expand_simple(struct inode *inode, loff_t size)
-{
-	loff_t pos = size - 1;
-	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-	unsigned int offset = (pos & (PAGE_CACHE_SIZE - 1)) + 1;
-
-	/* prepare/commit_write can handle even if from==to==start of block. */
-	return __generic_cont_expand(inode, size, index, offset);
+	return generic_cont_expand_simple(inode, size);
 }
 
-/*
- * For moronic filesystems that do not allow holes in file.
- * We may have to extend the file.
- */
-
-int cont_prepare_write(struct page *page, unsigned offset,
-		unsigned to, get_block_t *get_block, loff_t *bytes)
+int cont_expand_zero(struct file *file, struct address_space *mapping,
+			loff_t pos, loff_t *bytes)
 {
-	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
-	struct page *new_page;
-	pgoff_t pgpos;
-	long status;
-	unsigned zerofrom;
 	unsigned blocksize = 1 << inode->i_blkbits;
+	struct page *page;
+	void *fsdata;
+	pgoff_t index, curidx;
+	loff_t curpos;
+	unsigned zerofrom, offset, len;
+	int err = 0;
 
-	while(page->index > (pgpos = *bytes>>PAGE_CACHE_SHIFT)) {
-		status = -ENOMEM;
-		new_page = grab_cache_page(mapping, pgpos);
-		if (!new_page)
-			goto out;
-		/* we might sleep */
-		if (*bytes>>PAGE_CACHE_SHIFT != pgpos) {
-			unlock_page(new_page);
-			page_cache_release(new_page);
-			continue;
-		}
-		zerofrom = *bytes & ~PAGE_CACHE_MASK;
+	index = pos >> PAGE_CACHE_SHIFT;
+	offset = pos & ~PAGE_CACHE_MASK;
+
+	while (index > (curidx = (curpos = *bytes)>>PAGE_CACHE_SHIFT)) {
+		zerofrom = curpos & ~PAGE_CACHE_MASK;
 		if (zerofrom & (blocksize-1)) {
 			*bytes |= (blocksize-1);
 			(*bytes)++;
 		}
-		status = __block_prepare_write(inode, new_page, zerofrom,
-						PAGE_CACHE_SIZE, get_block);
-		if (status)
-			goto out_unmap;
-		zero_user_page(new_page, zerofrom, PAGE_CACHE_SIZE - zerofrom,
-				KM_USER0);
-		generic_commit_write(NULL, new_page, zerofrom, PAGE_CACHE_SIZE);
-		unlock_page(new_page);
-		page_cache_release(new_page);
-	}
+		len = PAGE_CACHE_SIZE - zerofrom;
 
-	if (page->index < pgpos) {
-		/* completely inside the area */
-		zerofrom = offset;
-	} else {
-		/* page covers the boundary, find the boundary offset */
-		zerofrom = *bytes & ~PAGE_CACHE_MASK;
+		err = pagecache_write_begin(file, mapping, curpos, len,
+						AOP_FLAG_UNINTERRUPTIBLE,
+						&page, &fsdata);
+		if (err)
+			goto out;
+		zero_user_page(page, zerofrom, len, KM_USER0);
+		err = pagecache_write_end(file, mapping, curpos, len, len,
+						page, fsdata);
+		if (err < 0)
+			goto out;
+		BUG_ON(err != len);
+		err = 0;
+	}
 
+	/* page covers the boundary, find the boundary offset */
+	if (index == curidx) {
+		zerofrom = curpos & ~PAGE_CACHE_MASK;
 		/* if we will expand the thing last block will be filled */
-		if (to > zerofrom && (zerofrom & (blocksize-1))) {
+		if (offset <= zerofrom) {
+			goto out;
+		}
+		if (zerofrom & (blocksize-1)) {
 			*bytes |= (blocksize-1);
 			(*bytes)++;
 		}
+		len = offset - zerofrom;
 
-		/* starting below the boundary? Nothing to zero out */
-		if (offset <= zerofrom)
-			zerofrom = offset;
-	}
-	status = __block_prepare_write(inode, page, zerofrom, to, get_block);
-	if (status)
-		goto out1;
-	if (zerofrom < offset) {
-		zero_user_page(page, zerofrom, offset - zerofrom, KM_USER0);
-		__block_commit_write(inode, page, zerofrom, offset);
+		err = pagecache_write_begin(file, mapping, curpos, len,
+						AOP_FLAG_UNINTERRUPTIBLE,
+						&page, &fsdata);
+		if (err)
+			goto out;
+		zero_user_page(page, zerofrom, len, KM_USER0);
+		err = pagecache_write_end(file, mapping, curpos, len, len,
+						page, fsdata);
+		if (err < 0)
+			goto out;
+		BUG_ON(err != len);
+		err = 0;
 	}
-	return 0;
-out1:
-	ClearPageUptodate(page);
-	return status;
-
-out_unmap:
-	ClearPageUptodate(new_page);
-	unlock_page(new_page);
-	page_cache_release(new_page);
 out:
-	return status;
+	return err;
+}
+
+/*
+ * For moronic filesystems that do not allow holes in file.
+ * We may have to extend the file.
+ */
+int cont_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata,
+			get_block_t *get_block, loff_t *bytes)
+{
+	struct inode *inode = mapping->host;
+	unsigned blocksize = 1 << inode->i_blkbits;
+	unsigned zerofrom;
+	int err;
+
+	err = cont_expand_zero(file, mapping, pos, bytes);
+	if (err)
+		goto out;
+
+	zerofrom = *bytes & ~PAGE_CACHE_MASK;
+	if (pos+len > *bytes && zerofrom & (blocksize-1)) {
+		*bytes |= (blocksize-1);
+		(*bytes)++;
+	}
+
+	*pagep = NULL;
+	err = block_write_begin(file, mapping, pos, len,
+				flags, pagep, fsdata, get_block);
+out:
+	return err;
 }
 
 int block_prepare_write(struct page *page, unsigned from, unsigned to,
@@ -3102,7 +3096,7 @@ EXPORT_SYMBOL(block_read_full_page);
 EXPORT_SYMBOL(block_sync_page);
 EXPORT_SYMBOL(block_truncate_page);
 EXPORT_SYMBOL(block_write_full_page);
-EXPORT_SYMBOL(cont_prepare_write);
+EXPORT_SYMBOL(cont_write_begin);
 EXPORT_SYMBOL(end_buffer_read_sync);
 EXPORT_SYMBOL(end_buffer_write_sync);
 EXPORT_SYMBOL(file_fsync);
diff -puN include/linux/buffer_head.h~fs-new-cont-helpers include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~fs-new-cont-helpers
+++ a/include/linux/buffer_head.h
@@ -214,8 +214,9 @@ int generic_write_end(struct file *, str
 				struct page *, void *);
 void page_zero_new_buffers(struct page *page, unsigned from, unsigned to);
 int block_prepare_write(struct page*, unsigned, unsigned, get_block_t*);
-int cont_prepare_write(struct page*, unsigned, unsigned, get_block_t*,
-				loff_t *);
+int cont_write_begin(struct file *, struct address_space *, loff_t,
+			unsigned, unsigned, struct page **, void **,
+			get_block_t *, loff_t *);
 int generic_cont_expand(struct inode *inode, loff_t size);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
 int block_commit_write(struct page *page, unsigned from, unsigned to);
diff -puN include/linux/fs.h~fs-new-cont-helpers include/linux/fs.h
--- a/include/linux/fs.h~fs-new-cont-helpers
+++ a/include/linux/fs.h
@@ -392,6 +392,7 @@ enum positive_aop_returns {
 };
 
 #define AOP_FLAG_UNINTERRUPTIBLE	0x0001 /* will not do a short write */
+#define AOP_FLAG_CONT_EXPAND		0x0002 /* called from cont_expand */
 
 /*
  * oh the beauties of C type declarations.
diff -puN mm/filemap.c~fs-new-cont-helpers mm/filemap.c
--- a/mm/filemap.c~fs-new-cont-helpers
+++ a/mm/filemap.c
@@ -1736,6 +1736,7 @@ size_t iov_iter_copy_from_user_atomic(st
 
 	return copied;
 }
+EXPORT_SYMBOL(iov_iter_copy_from_user_atomic);
 
 /*
  * This has the same sideeffects and return value as
@@ -1762,6 +1763,7 @@ size_t iov_iter_copy_from_user(struct pa
 	kunmap(page);
 	return copied;
 }
+EXPORT_SYMBOL(iov_iter_copy_from_user);
 
 static void __iov_iter_advance_iov(struct iov_iter *i, size_t bytes)
 {
@@ -1793,12 +1795,14 @@ void iov_iter_advance(struct iov_iter *i
 	__iov_iter_advance_iov(i, bytes);
 	i->count -= bytes;
 }
+EXPORT_SYMBOL(iov_iter_advance);
 
 int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
 {
 	char __user *buf = i->iov->iov_base + i->iov_offset;
 	return fault_in_pages_readable(buf, bytes);
 }
+EXPORT_SYMBOL(iov_iter_fault_in_readable);
 
 /*
  * Return the count of just the current iov_iter segment.
@@ -1811,6 +1815,7 @@ size_t iov_iter_single_seg_count(struct 
 	else
 		return min(i->count, iov->iov_len - i->iov_offset);
 }
+EXPORT_SYMBOL(iov_iter_single_seg_count);
 
 /*
  * Performs necessary checks before doing a write
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
git-arm-master.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
