From: akpm@linux-foundation.org
Subject: - fs-restore-nobh.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:35 -0700
Message-ID: <200710162033.l9GKXZR5014806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42048 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934879AbXJPVzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:55:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fs: restore nobh
has been removed from the -mm tree.  Its filename was
     fs-restore-nobh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: restore nobh
From: Nick Piggin <npiggin@suse.de>

Implement nobh in new aops.  This is a bit tricky.  FWIW, nobh_truncate is
now implemented in a way that does not create blocks in sparse regions,
which is a silly thing for it to have been doing (isn't it?)

ext2 survives fsx and fsstress. jfs is converted as well... ext3
should be easy to do (but not done yet).

[akpm@linux-foundation.org: coding-style fixes]
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |  229 ++++++++++++++++++++++------------
 fs/ext2/inode.c             |   20 ++
 fs/jfs/inode.c              |    7 -
 include/linux/buffer_head.h |   10 +
 4 files changed, 178 insertions(+), 88 deletions(-)

diff -puN fs/buffer.c~fs-restore-nobh fs/buffer.c
--- a/fs/buffer.c~fs-restore-nobh
+++ a/fs/buffer.c
@@ -2369,7 +2369,7 @@ out_unlock:
 }
 
 /*
- * nobh_prepare_write()'s prereads are special: the buffer_heads are freed
+ * nobh_write_begin()'s prereads are special: the buffer_heads are freed
  * immediately, while under the page lock.  So it needs a special end_io
  * handler which does not touch the bh after unlocking it.
  */
@@ -2379,16 +2379,45 @@ static void end_buffer_read_nobh(struct 
 }
 
 /*
+ * Attach the singly-linked list of buffers created by nobh_write_begin, to
+ * the page (converting it to circular linked list and taking care of page
+ * dirty races).
+ */
+static void attach_nobh_buffers(struct page *page, struct buffer_head *head)
+{
+	struct buffer_head *bh;
+
+	BUG_ON(!PageLocked(page));
+
+	spin_lock(&page->mapping->private_lock);
+	bh = head;
+	do {
+		if (PageDirty(page))
+			set_buffer_dirty(bh);
+		if (!bh->b_this_page)
+			bh->b_this_page = head;
+		bh = bh->b_this_page;
+	} while (bh != head);
+	attach_page_buffers(page, head);
+	spin_unlock(&page->mapping->private_lock);
+}
+
+/*
  * On entry, the page is fully not uptodate.
  * On exit the page is fully uptodate in the areas outside (from,to)
  */
-int nobh_prepare_write(struct page *page, unsigned from, unsigned to,
+int nobh_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata,
 			get_block_t *get_block)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
 	const unsigned blocksize = 1 << blkbits;
 	struct buffer_head *head, *bh;
+	struct page *page;
+	pgoff_t index;
+	unsigned from, to;
 	unsigned block_in_page;
 	unsigned block_start, block_end;
 	sector_t block_in_file;
@@ -2397,8 +2426,23 @@ int nobh_prepare_write(struct page *page
 	int ret = 0;
 	int is_mapped_to_disk = 1;
 
-	if (page_has_buffers(page))
-		return block_prepare_write(page, from, to, get_block);
+	index = pos >> PAGE_CACHE_SHIFT;
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + len;
+
+	page = __grab_cache_page(mapping, index);
+	if (!page)
+		return -ENOMEM;
+	*pagep = page;
+	*fsdata = NULL;
+
+	if (page_has_buffers(page)) {
+		unlock_page(page);
+		page_cache_release(page);
+		*pagep = NULL;
+		return block_write_begin(file, mapping, pos, len, flags, pagep,
+					fsdata, get_block);
+	}
 
 	if (PageMappedToDisk(page))
 		return 0;
@@ -2413,8 +2457,10 @@ int nobh_prepare_write(struct page *page
 	 * than the circular one we're used to.
 	 */
 	head = alloc_page_buffers(page, blocksize, 0);
-	if (!head)
-		return -ENOMEM;
+	if (!head) {
+		ret = -ENOMEM;
+		goto out_release;
+	}
 
 	block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
 
@@ -2483,15 +2529,12 @@ int nobh_prepare_write(struct page *page
 	if (is_mapped_to_disk)
 		SetPageMappedToDisk(page);
 
-	do {
-		bh = head;
-		head = head->b_this_page;
-		free_buffer_head(bh);
-	} while (head);
+	*fsdata = head; /* to be released by nobh_write_end */
 
 	return 0;
 
 failed:
+	BUG_ON(!ret);
 	/*
 	 * Error recovery is a bit difficult. We need to zero out blocks that
 	 * were newly allocated, and dirty them to ensure they get written out.
@@ -2499,64 +2542,57 @@ failed:
 	 * the handling of potential IO errors during writeout would be hard
 	 * (could try doing synchronous writeout, but what if that fails too?)
 	 */
-	spin_lock(&page->mapping->private_lock);
-	bh = head;
-	block_start = 0;
-	do {
-		if (PageUptodate(page))
-			set_buffer_uptodate(bh);
-		if (PageDirty(page))
-			set_buffer_dirty(bh);
+	attach_nobh_buffers(page, head);
+	page_zero_new_buffers(page, from, to);
 
-		block_end = block_start+blocksize;
-		if (block_end <= from)
-			goto next;
-		if (block_start >= to)
-			goto next;
+out_release:
+	unlock_page(page);
+	page_cache_release(page);
+	*pagep = NULL;
 
-		if (buffer_new(bh)) {
-			clear_buffer_new(bh);
-			if (!buffer_uptodate(bh)) {
-				zero_user_page(page, block_start, bh->b_size, KM_USER0);
-				set_buffer_uptodate(bh);
-			}
-			mark_buffer_dirty(bh);
-		}
-next:
-		block_start = block_end;
-		if (!bh->b_this_page)
-			bh->b_this_page = head;
-		bh = bh->b_this_page;
-	} while (bh != head);
-	attach_page_buffers(page, head);
-	spin_unlock(&page->mapping->private_lock);
+	if (pos + len > inode->i_size)
+		vmtruncate(inode, inode->i_size);
 
 	return ret;
 }
-EXPORT_SYMBOL(nobh_prepare_write);
+EXPORT_SYMBOL(nobh_write_begin);
 
-/*
- * Make sure any changes to nobh_commit_write() are reflected in
- * nobh_truncate_page(), since it doesn't call commit_write().
- */
-int nobh_commit_write(struct file *file, struct page *page,
-		unsigned from, unsigned to)
+int nobh_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
 {
 	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	struct buffer_head *head = NULL;
+	struct buffer_head *bh;
 
-	if (page_has_buffers(page))
-		return generic_commit_write(file, page, from, to);
+	if (!PageMappedToDisk(page)) {
+		if (unlikely(copied < len) && !page_has_buffers(page))
+			attach_nobh_buffers(page, head);
+		if (page_has_buffers(page))
+			return generic_write_end(file, mapping, pos, len,
+						copied, page, fsdata);
+	}
 
 	SetPageUptodate(page);
 	set_page_dirty(page);
-	if (pos > inode->i_size) {
-		i_size_write(inode, pos);
+	if (pos+copied > inode->i_size) {
+		i_size_write(inode, pos+copied);
 		mark_inode_dirty(inode);
 	}
-	return 0;
+
+	unlock_page(page);
+	page_cache_release(page);
+
+	head = fsdata;
+	while (head) {
+		bh = head;
+		head = head->b_this_page;
+		free_buffer_head(bh);
+	}
+
+	return copied;
 }
-EXPORT_SYMBOL(nobh_commit_write);
+EXPORT_SYMBOL(nobh_write_end);
 
 /*
  * nobh_writepage() - based on block_full_write_page() except
@@ -2609,44 +2645,79 @@ out:
 }
 EXPORT_SYMBOL(nobh_writepage);
 
-/*
- * This function assumes that ->prepare_write() uses nobh_prepare_write().
- */
-int nobh_truncate_page(struct address_space *mapping, loff_t from)
+int nobh_truncate_page(struct address_space *mapping,
+			loff_t from, get_block_t *get_block)
 {
-	struct inode *inode = mapping->host;
-	unsigned blocksize = 1 << inode->i_blkbits;
 	pgoff_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
-	unsigned to;
+	unsigned blocksize;
+	sector_t iblock;
+	unsigned length, pos;
+	struct inode *inode = mapping->host;
 	struct page *page;
-	const struct address_space_operations *a_ops = mapping->a_ops;
-	int ret = 0;
+	struct buffer_head map_bh;
+	int err;
 
-	if ((offset & (blocksize - 1)) == 0)
-		goto out;
+	blocksize = 1 << inode->i_blkbits;
+	length = offset & (blocksize - 1);
+
+	/* Block boundary? Nothing to do */
+	if (!length)
+		return 0;
+
+	length = blocksize - length;
+	iblock = (sector_t)index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
 
-	ret = -ENOMEM;
 	page = grab_cache_page(mapping, index);
+	err = -ENOMEM;
 	if (!page)
 		goto out;
 
-	to = (offset + blocksize) & ~(blocksize - 1);
-	ret = a_ops->prepare_write(NULL, page, offset, to);
-	if (ret == 0) {
-		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
-				KM_USER0);
-		/*
-		 * It would be more correct to call aops->commit_write()
-		 * here, but this is more efficient.
-		 */
-		SetPageUptodate(page);
-		set_page_dirty(page);
+	if (page_has_buffers(page)) {
+has_buffers:
+		unlock_page(page);
+		page_cache_release(page);
+		return block_truncate_page(mapping, from, get_block);
+	}
+
+	/* Find the buffer that contains "offset" */
+	pos = blocksize;
+	while (offset >= pos) {
+		iblock++;
+		pos += blocksize;
 	}
+
+	err = get_block(inode, iblock, &map_bh, 0);
+	if (err)
+		goto unlock;
+	/* unmapped? It's a hole - nothing to do */
+	if (!buffer_mapped(&map_bh))
+		goto unlock;
+
+	/* Ok, it's mapped. Make sure it's up-to-date */
+	if (!PageUptodate(page)) {
+		err = mapping->a_ops->readpage(NULL, page);
+		if (err) {
+			page_cache_release(page);
+			goto out;
+		}
+		lock_page(page);
+		if (!PageUptodate(page)) {
+			err = -EIO;
+			goto unlock;
+		}
+		if (page_has_buffers(page))
+			goto has_buffers;
+	}
+	zero_user_page(page, offset, length, KM_USER0);
+	set_page_dirty(page);
+	err = 0;
+
+unlock:
 	unlock_page(page);
 	page_cache_release(page);
 out:
-	return ret;
+	return err;
 }
 EXPORT_SYMBOL(nobh_truncate_page);
 
diff -puN fs/ext2/inode.c~fs-restore-nobh fs/ext2/inode.c
--- a/fs/ext2/inode.c~fs-restore-nobh
+++ a/fs/ext2/inode.c
@@ -659,6 +659,20 @@ ext2_write_begin(struct file *file, stru
 	return __ext2_write_begin(file, mapping, pos, len, flags, pagep,fsdata);
 }
 
+static int
+ext2_nobh_write_begin(struct file *file, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, void **fsdata)
+{
+	/*
+	 * Dir-in-pagecache still uses ext2_write_begin. Would have to rework
+	 * directory handling code to pass around offsets rather than struct
+	 * pages in order to make this work easily.
+	 */
+	return nobh_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+							ext2_get_block);
+}
+
 static int ext2_nobh_writepage(struct page *page,
 			struct writeback_control *wbc)
 {
@@ -710,7 +724,8 @@ const struct address_space_operations ex
 	.readpages		= ext2_readpages,
 	.writepage		= ext2_nobh_writepage,
 	.sync_page		= block_sync_page,
-	/* XXX: todo */
+	.write_begin		= ext2_nobh_write_begin,
+	.write_end		= nobh_write_end,
 	.bmap			= ext2_bmap,
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
@@ -927,7 +942,8 @@ void ext2_truncate (struct inode * inode
 	if (mapping_is_xip(inode->i_mapping))
 		xip_truncate_page(inode->i_mapping, inode->i_size);
 	else if (test_opt(inode->i_sb, NOBH))
-		nobh_truncate_page(inode->i_mapping, inode->i_size);
+		nobh_truncate_page(inode->i_mapping,
+				inode->i_size, ext2_get_block);
 	else
 		block_truncate_page(inode->i_mapping,
 				inode->i_size, ext2_get_block);
diff -puN fs/jfs/inode.c~fs-restore-nobh fs/jfs/inode.c
--- a/fs/jfs/inode.c~fs-restore-nobh
+++ a/fs/jfs/inode.c
@@ -279,8 +279,7 @@ static int jfs_write_begin(struct file *
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
 {
-	*pagep = NULL;
-	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+	return nobh_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 				jfs_get_block);
 }
 
@@ -306,7 +305,7 @@ const struct address_space_operations jf
 	.writepages	= jfs_writepages,
 	.sync_page	= block_sync_page,
 	.write_begin	= jfs_write_begin,
-	.write_end	= generic_write_end,
+	.write_end	= nobh_write_end,
 	.bmap		= jfs_bmap,
 	.direct_IO	= jfs_direct_IO,
 };
@@ -359,7 +358,7 @@ void jfs_truncate(struct inode *ip)
 {
 	jfs_info("jfs_truncate: size = 0x%lx", (ulong) ip->i_size);
 
-	block_truncate_page(ip->i_mapping, ip->i_size, jfs_get_block);
+	nobh_truncate_page(ip->i_mapping, ip->i_size, jfs_get_block);
 
 	IWRITE_LOCK(ip, RDWRLOCK_NORMAL);
 	jfs_truncate_nolock(ip, ip->i_size);
diff -puN include/linux/buffer_head.h~fs-restore-nobh include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~fs-restore-nobh
+++ a/include/linux/buffer_head.h
@@ -226,9 +226,13 @@ sector_t generic_block_bmap(struct addre
 int generic_commit_write(struct file *, struct page *, unsigned, unsigned);
 int block_truncate_page(struct address_space *, loff_t, get_block_t *);
 int file_fsync(struct file *, struct dentry *, int);
-int nobh_prepare_write(struct page*, unsigned, unsigned, get_block_t*);
-int nobh_commit_write(struct file *, struct page *, unsigned, unsigned);
-int nobh_truncate_page(struct address_space *, loff_t);
+int nobh_write_begin(struct file *, struct address_space *,
+				loff_t, unsigned, unsigned,
+				struct page **, void **, get_block_t*);
+int nobh_write_end(struct file *, struct address_space *,
+				loff_t, unsigned, unsigned,
+				struct page *, void *);
+int nobh_truncate_page(struct address_space *, loff_t, get_block_t *);
 int nobh_writepage(struct page *page, get_block_t *get_block,
                         struct writeback_control *wbc);
 
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
