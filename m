From: akpm@linux-foundation.org
Subject: + fs-affs-convert-to-new-aops.patch added to -mm tree
Date: Tue, 26 Jun 2007 22:05:37 -0700
Message-ID: <200706270505.l5R55bdk010317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60558 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753588AbXF0FF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 01:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, zippel@linux-m68k.org


The patch titled
     fs: affs convert to new aops
has been added to the -mm tree.  Its filename is
     fs-affs-convert-to-new-aops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs: affs convert to new aops
From: Nick Piggin <npiggin@suse.de>

Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |  102 ++++++++++++++++++++++++++---------------------
 1 file changed, 58 insertions(+), 44 deletions(-)

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
 
@@ -761,8 +780,8 @@ const struct address_space_operations af
 	.readpage = affs_readpage_ofs,
 	//.writepage = affs_writepage_ofs,
 	//.sync_page = affs_sync_page_ofs,
-	.prepare_write = affs_prepare_write_ofs,
-	.commit_write = affs_commit_write_ofs
+	.write_begin = affs_write_begin_ofs,
+	.write_end = affs_write_end_ofs
 };
 
 /* Free any preallocated blocks. */
@@ -805,18 +824,13 @@ affs_truncate(struct inode *inode)
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

mm-kill-validate_anon_vma-to-avoid-mapcount-bug.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-merge-nopfn-into-fault.patch
mm-merge-nopfn-into-fault-spufs-fix.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
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
fs-introduce-write_begin-write_end-and-perform_write-aops-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix-3.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix-4.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
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
ufs-convert-to-new-aops-fix.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
sysv-convert-to-new-aops-fix.patch
minix-convert-to-new-aops.patch
minix-convert-to-new-aops-fix.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
fix-read-truncate-race.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
