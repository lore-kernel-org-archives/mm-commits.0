From: akpm@linux-foundation.org
Subject: - fs-affs-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:31 -0700
Message-ID: <200710162033.l9GKXV0d014800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52313 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965778AbXJPVsc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:48:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fs: affs convert to new aops
has been removed from the -mm tree.  Its filename was
     fs-affs-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: affs convert to new aops
From: Nick Piggin <npiggin@suse.de>

Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |  105 +++++++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 44 deletions(-)

diff -puN fs/affs/file.c~fs-affs-convert-to-new-aops fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-convert-to-new-aops
+++ a/fs/affs/file.c
@@ -395,25 +395,33 @@ static int affs_writepage(struct page *p
 {
 	return block_write_full_page(page, affs_get_block, wbc);
 }
+
 static int affs_readpage(struct file *file, struct page *page)
 {
 	return block_read_full_page(page, affs_get_block);
 }
-static int affs_prepare_write(struct file *file, struct page *page, unsigned from, unsigned to)
-{
-	return cont_prepare_write(page, from, to, affs_get_block,
-		&AFFS_I(page->mapping->host)->mmu_private);
+
+static int affs_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	*pagep = NULL;
+	return cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				affs_get_block,
+				&AFFS_I(mapping->host)->mmu_private);
 }
+
 static sector_t _affs_bmap(struct address_space *mapping, sector_t block)
 {
 	return generic_block_bmap(mapping,block,affs_get_block);
 }
+
 const struct address_space_operations affs_aops = {
 	.readpage = affs_readpage,
 	.writepage = affs_writepage,
 	.sync_page = block_sync_page,
-	.prepare_write = affs_prepare_write,
-	.commit_write = generic_commit_write,
+	.write_begin = affs_write_begin,
+	.write_end = generic_write_end,
 	.bmap = _affs_bmap
 };
 
@@ -603,54 +611,65 @@ affs_readpage_ofs(struct file *file, str
 	return err;
 }
 
-static int affs_prepare_write_ofs(struct file *file, struct page *page, unsigned from, unsigned to)
-{
-	struct inode *inode = page->mapping->host;
-	u32 size, offset;
-	u32 tmp;
+static int affs_write_begin_ofs(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned flags,
+				struct page **pagep, void **fsdata)
+{
+	struct inode *inode = mapping->host;
+	struct page *page;
+	pgoff_t index;
 	int err = 0;
 
-	pr_debug("AFFS: prepare_write(%u, %ld, %d, %d)\n", (u32)inode->i_ino, page->index, from, to);
-	offset = page->index << PAGE_CACHE_SHIFT;
-	if (offset + from > AFFS_I(inode)->mmu_private) {
-		err = affs_extent_file_ofs(inode, offset + from);
+	pr_debug("AFFS: write_begin(%u, %llu, %llu)\n", (u32)inode->i_ino, (unsigned long long)pos, (unsigned long long)pos + len);
+	if (pos > AFFS_I(inode)->mmu_private) {
+		/* XXX: this probably leaves a too-big i_size in case of
+		 * failure. Should really be updating i_size at write_end time
+		 */
+		err = affs_extent_file_ofs(inode, pos);
 		if (err)
 			return err;
 	}
-	size = inode->i_size;
+
+	index = pos >> PAGE_CACHE_SHIFT;
+	page = __grab_cache_page(mapping, index);
+	if (!page)
+		return -ENOMEM;
+	*pagep = page;
 
 	if (PageUptodate(page))
 		return 0;
 
-	if (from) {
-		err = affs_do_readpage_ofs(file, page, 0, from);
-		if (err)
-			return err;
-	}
-	if (to < PAGE_CACHE_SIZE) {
-		zero_user_page(page, to, PAGE_CACHE_SIZE - to, KM_USER0);
-		if (size > offset + to) {
-			if (size < offset + PAGE_CACHE_SIZE)
-				tmp = size & ~PAGE_CACHE_MASK;
-			else
-				tmp = PAGE_CACHE_SIZE;
-			err = affs_do_readpage_ofs(file, page, to, tmp);
-		}
+	/* XXX: inefficient but safe in the face of short writes */
+	err = affs_do_readpage_ofs(file, page, 0, PAGE_CACHE_SIZE);
+	if (err) {
+		unlock_page(page);
+		page_cache_release(page);
 	}
 	return err;
 }
 
-static int affs_commit_write_ofs(struct file *file, struct page *page, unsigned from, unsigned to)
+static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = mapping->host;
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *bh, *prev_bh;
 	char *data;
 	u32 bidx, boff, bsize;
+	unsigned from, to;
 	u32 tmp;
 	int written;
 
-	pr_debug("AFFS: commit_write(%u, %ld, %d, %d)\n", (u32)inode->i_ino, page->index, from, to);
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = pos + len;
+	/*
+	 * XXX: not sure if this can handle short copies (len < copied), but
+	 * we don't have to, because the page should always be uptodate here,
+	 * due to write_begin.
+	 */
+
+	pr_debug("AFFS: write_begin(%u, %llu, %llu)\n", (u32)inode->i_ino, (unsigned long long)pos, (unsigned long long)pos + len);
 	bsize = AFFS_SB(sb)->s_data_blksize;
 	data = page_address(page);
 
@@ -748,6 +767,9 @@ done:
 	if (tmp > inode->i_size)
 		inode->i_size = AFFS_I(inode)->mmu_private = tmp;
 
+	unlock_page(page);
+	page_cache_release(page);
+
 	return written;
 
 out:
@@ -761,8 +783,8 @@ const struct address_space_operations af
 	.readpage = affs_readpage_ofs,
 	//.writepage = affs_writepage_ofs,
 	//.sync_page = affs_sync_page_ofs,
-	.prepare_write = affs_prepare_write_ofs,
-	.commit_write = affs_commit_write_ofs
+	.write_begin = affs_write_begin_ofs,
+	.write_end = affs_write_end_ofs
 };
 
 /* Free any preallocated blocks. */
@@ -805,18 +827,13 @@ affs_truncate(struct inode *inode)
 	if (inode->i_size > AFFS_I(inode)->mmu_private) {
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
-		u32 size = inode->i_size - 1;
+		void *fsdata;
+		u32 size = inode->i_size;
 		int res;
 
-		page = grab_cache_page(mapping, size >> PAGE_CACHE_SHIFT);
-		if (!page)
-			return;
-		size = (size & (PAGE_CACHE_SIZE - 1)) + 1;
-		res = mapping->a_ops->prepare_write(NULL, page, size, size);
+		res = mapping->a_ops->write_begin(NULL, mapping, size, 0, 0, &page, &fsdata);
 		if (!res)
-			res = mapping->a_ops->commit_write(NULL, page, size, size);
-		unlock_page(page);
-		page_cache_release(page);
+			res = mapping->a_ops->write_end(NULL, mapping, size, 0, 0, page, fsdata);
 		mark_inode_dirty(inode);
 		return;
 	} else if (inode->i_size == AFFS_I(inode)->mmu_private)
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
