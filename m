From: akpm@linux-foundation.org
Subject: + ext4-convert-to-new-aops.patch added to -mm tree
Date: Tue, 29 May 2007 14:20:07 -0700
Message-ID: <200705292120.l4TLK715011751@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979AbXE2VUR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:20:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, pbadari@us.ibm.com


The patch titled
     ext4: convert to new aops
has been added to the -mm tree.  Its filename is
     ext4-convert-to-new-aops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext4: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Convert ext4 to use write_begin()/write_end() methods.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |  147 +++++++++++++++++++++++++++++-----------------
 1 files changed, 93 insertions(+), 54 deletions(-)

diff -puN fs/ext4/inode.c~ext4-convert-to-new-aops fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-convert-to-new-aops
+++ a/fs/ext4/inode.c
@@ -1146,34 +1146,50 @@ static int do_journal_get_write_access(h
 	return ext4_journal_get_write_access(handle, bh);
 }
 
-static int ext4_prepare_write(struct file *file, struct page *page,
-			      unsigned from, unsigned to)
+static int ext4_write_begin(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned flags,
+				struct page **pagep, void **fsdata)
 {
-	struct inode *inode = page->mapping->host;
+ 	struct inode *inode = mapping->host;
 	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
 	handle_t *handle;
 	int retries = 0;
+ 	struct page *page;
+ 	pgoff_t index;
+ 	unsigned from, to;
+
+ 	index = pos >> PAGE_CACHE_SHIFT;
+ 	from = pos & (PAGE_CACHE_SIZE - 1);
+ 	to = from + len;
 
 retry:
-	handle = ext4_journal_start(inode, needed_blocks);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto out;
+ 	page = __grab_cache_page(mapping, index);
+ 	if (!page)
+ 		return -ENOMEM;
+ 	*pagep = page;
+
+  	handle = ext4_journal_start(inode, needed_blocks);
+  	if (IS_ERR(handle)) {
+ 		unlock_page(page);
+ 		page_cache_release(page);
+  		ret = PTR_ERR(handle);
+  		goto out;
 	}
-	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
-		ret = nobh_prepare_write(page, from, to, ext4_get_block);
-	else
-		ret = block_prepare_write(page, from, to, ext4_get_block);
-	if (ret)
-		goto prepare_write_failed;
 
-	if (ext4_should_journal_data(inode)) {
+	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+							ext4_get_block);
+
+	if (!ret && ext4_should_journal_data(inode)) {
 		ret = walk_page_buffers(handle, page_buffers(page),
 				from, to, NULL, do_journal_get_write_access);
 	}
-prepare_write_failed:
-	if (ret)
+
+	if (ret) {
 		ext4_journal_stop(handle);
+ 		unlock_page(page);
+ 		page_cache_release(page);
+	}
+
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 out:
@@ -1185,12 +1201,12 @@ int ext4_journal_dirty_data(handle_t *ha
 	int err = jbd2_journal_dirty_data(handle, bh);
 	if (err)
 		ext4_journal_abort_handle(__FUNCTION__, __FUNCTION__,
-						bh, handle,err);
+						bh, handle, err);
 	return err;
 }
 
-/* For commit_write() in data=journal mode */
-static int commit_write_fn(handle_t *handle, struct buffer_head *bh)
+/* For write_end() in data=journal mode */
+static int write_end_fn(handle_t *handle, struct buffer_head *bh)
 {
 	if (!buffer_mapped(bh) || buffer_freed(bh))
 		return 0;
@@ -1205,78 +1221,100 @@ static int commit_write_fn(handle_t *han
  * ext4 never places buffers on inode->i_mapping->private_list.  metadata
  * buffers are managed internally.
  */
-static int ext4_ordered_commit_write(struct file *file, struct page *page,
-			     unsigned from, unsigned to)
+static int ext4_ordered_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext4_journal_current_handle();
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = file->f_mapping->host;
+	unsigned from, to;
 	int ret = 0, ret2;
 
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + len;
+
 	ret = walk_page_buffers(handle, page_buffers(page),
 		from, to, NULL, ext4_journal_dirty_data);
 
 	if (ret == 0) {
 		/*
-		 * generic_commit_write() will run mark_inode_dirty() if i_size
+		 * generic_write_end() will run mark_inode_dirty() if i_size
 		 * changes.  So let's piggyback the i_disksize mark_inode_dirty
 		 * into that.
 		 */
 		loff_t new_i_size;
 
-		new_i_size = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+		new_i_size = pos + copied;
 		if (new_i_size > EXT4_I(inode)->i_disksize)
 			EXT4_I(inode)->i_disksize = new_i_size;
-		ret = generic_commit_write(file, page, from, to);
+		copied = generic_write_end(file, mapping, pos, len, copied,
+							page, fsdata);
+		if (copied < 0)
+			ret = copied;
+	} else {
+		unlock_page(page);
+		page_cache_release(page);
 	}
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	return ret;
+	return ret ? ret : copied;
 }
 
-static int ext4_writeback_commit_write(struct file *file, struct page *page,
-			     unsigned from, unsigned to)
+static int ext4_writeback_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext4_journal_current_handle();
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = file->f_mapping->host;
 	int ret = 0, ret2;
 	loff_t new_i_size;
 
-	new_i_size = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	new_i_size = pos + copied;
 	if (new_i_size > EXT4_I(inode)->i_disksize)
 		EXT4_I(inode)->i_disksize = new_i_size;
 
-	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
-		ret = nobh_commit_write(file, page, from, to);
-	else
-		ret = generic_commit_write(file, page, from, to);
+	copied = generic_write_end(file, mapping, pos, len, copied,
+							page, fsdata);
+	if (copied < 0)
+		ret = copied;
 
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	return ret;
+	return ret ? ret : copied;
 }
 
-static int ext4_journalled_commit_write(struct file *file,
-			struct page *page, unsigned from, unsigned to)
+static int ext4_journalled_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext4_journal_current_handle();
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = mapping->host;
 	int ret = 0, ret2;
 	int partial = 0;
-	loff_t pos;
+	unsigned from, to;
 
-	/*
-	 * Here we duplicate the generic_commit_write() functionality
-	 */
-	pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + len;
+
+	if (copied < len) {
+		if (!PageUptodate(page))
+			copied = 0;
+		page_zero_new_buffers(page, from+copied, to);
+	}
 
 	ret = walk_page_buffers(handle, page_buffers(page), from,
-				to, &partial, commit_write_fn);
+				to, &partial, write_end_fn);
 	if (!partial)
 		SetPageUptodate(page);
-	if (pos > inode->i_size)
-		i_size_write(inode, pos);
+	unlock_page(page);
+	page_cache_release(page);
+	if (pos+copied > inode->i_size)
+		i_size_write(inode, pos+copied);
 	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
 	if (inode->i_size > EXT4_I(inode)->i_disksize) {
 		EXT4_I(inode)->i_disksize = inode->i_size;
@@ -1284,10 +1322,11 @@ static int ext4_journalled_commit_write(
 		if (!ret)
 			ret = ret2;
 	}
+
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	return ret;
+	return ret ? ret : copied;
 }
 
 /*
@@ -1545,7 +1584,7 @@ static int ext4_journalled_writepage(str
 			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
 
 		err = walk_page_buffers(handle, page_buffers(page), 0,
-				PAGE_CACHE_SIZE, NULL, commit_write_fn);
+				PAGE_CACHE_SIZE, NULL, write_end_fn);
 		if (ret == 0)
 			ret = err;
 		EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
@@ -1705,8 +1744,8 @@ static const struct address_space_operat
 	.readpages	= ext4_readpages,
 	.writepage	= ext4_ordered_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= ext4_prepare_write,
-	.commit_write	= ext4_ordered_commit_write,
+	.write_begin	= ext4_write_begin,
+	.write_end	= ext4_ordered_write_end,
 	.bmap		= ext4_bmap,
 	.invalidatepage	= ext4_invalidatepage,
 	.releasepage	= ext4_releasepage,
@@ -1719,8 +1758,8 @@ static const struct address_space_operat
 	.readpages	= ext4_readpages,
 	.writepage	= ext4_writeback_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= ext4_prepare_write,
-	.commit_write	= ext4_writeback_commit_write,
+	.write_begin	= ext4_write_begin,
+	.write_end	= ext4_writeback_write_end,
 	.bmap		= ext4_bmap,
 	.invalidatepage	= ext4_invalidatepage,
 	.releasepage	= ext4_releasepage,
@@ -1733,8 +1772,8 @@ static const struct address_space_operat
 	.readpages	= ext4_readpages,
 	.writepage	= ext4_journalled_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= ext4_prepare_write,
-	.commit_write	= ext4_journalled_commit_write,
+	.write_begin	= ext4_write_begin,
+	.write_end	= ext4_journalled_write_end,
 	.set_page_dirty	= ext4_journalled_set_page_dirty,
 	.bmap		= ext4_bmap,
 	.invalidatepage	= ext4_invalidatepage,
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
