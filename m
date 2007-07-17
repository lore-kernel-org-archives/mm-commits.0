From: akpm@linux-foundation.org
Subject: - fs-introduce-some-page-buffer-invariants.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:40 -0700
Message-ID: <200707172301.l6HN1eBb011425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40281 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765425AbXGQXPu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs: introduce some page/buffer invariants
has been removed from the -mm tree.  Its filename was
     fs-introduce-some-page-buffer-invariants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: introduce some page/buffer invariants
From: Nick Piggin <npiggin@suse.de>

It is a bug to set a page dirty if it is not uptodate unless it has
buffers.  If the page has buffers, then the page may be dirty (some buffers
dirty) but not uptodate (some buffers not uptodate).  The exception to this
rule is if the set_page_dirty caller is racing with truncate or invalidate.

A buffer can not be set dirty if it is not uptodate.

If either of these situations occurs, it indicates there could be some data
loss problem.  Some of these warnings could be a harmless one where the
page or buffer is set uptodate immediately after it is dirtied, however we
should fix those up, and enforce this ordering.

Bring the order of operations for truncate into line with those of
invalidate.  This will prevent a page from being able to go !uptodate while
we're holding the tree_lock, which is probably a good thing anyway.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c         |   54 ++++++++++++++++++++++++++++--------------
 mm/page-writeback.c |    1 
 mm/truncate.c       |    2 -
 3 files changed, 39 insertions(+), 18 deletions(-)

diff -puN fs/buffer.c~fs-introduce-some-page-buffer-invariants fs/buffer.c
--- a/fs/buffer.c~fs-introduce-some-page-buffer-invariants
+++ a/fs/buffer.c
@@ -676,6 +676,39 @@ void mark_buffer_dirty_inode(struct buff
 EXPORT_SYMBOL(mark_buffer_dirty_inode);
 
 /*
+ * Mark the page dirty, and set it dirty in the radix tree, and mark the inode
+ * dirty.
+ *
+ * If warn is true, then emit a warning if the page is not uptodate and has
+ * not been truncated.
+ */
+static int __set_page_dirty(struct page *page,
+		struct address_space *mapping, int warn)
+{
+	if (unlikely(!mapping))
+		return !TestSetPageDirty(page);
+
+	if (TestSetPageDirty(page))
+		return 0;
+
+	write_lock_irq(&mapping->tree_lock);
+	if (page->mapping) {	/* Race with truncate? */
+		WARN_ON_ONCE(warn && !PageUptodate(page));
+
+		if (mapping_cap_account_dirty(mapping)) {
+			__inc_zone_page_state(page, NR_FILE_DIRTY);
+			task_io_account_write(PAGE_CACHE_SIZE);
+		}
+		radix_tree_tag_set(&mapping->page_tree,
+				page_index(page), PAGECACHE_TAG_DIRTY);
+	}
+	write_unlock_irq(&mapping->tree_lock);
+	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+
+	return 1;
+}
+
+/*
  * Add a page to the dirty page list.
  *
  * It is a sad fact of life that this function is called from several places
@@ -702,7 +735,7 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
  */
 int __set_page_dirty_buffers(struct page *page)
 {
-	struct address_space * const mapping = page_mapping(page);
+	struct address_space *mapping = page_mapping(page);
 
 	if (unlikely(!mapping))
 		return !TestSetPageDirty(page);
@@ -719,21 +752,7 @@ int __set_page_dirty_buffers(struct page
 	}
 	spin_unlock(&mapping->private_lock);
 
-	if (TestSetPageDirty(page))
-		return 0;
-
-	write_lock_irq(&mapping->tree_lock);
-	if (page->mapping) {	/* Race with truncate? */
-		if (mapping_cap_account_dirty(mapping)) {
-			__inc_zone_page_state(page, NR_FILE_DIRTY);
-			task_io_account_write(PAGE_CACHE_SIZE);
-		}
-		radix_tree_tag_set(&mapping->page_tree,
-				page_index(page), PAGECACHE_TAG_DIRTY);
-	}
-	write_unlock_irq(&mapping->tree_lock);
-	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
-	return 1;
+	return __set_page_dirty(page, mapping, 1);
 }
 EXPORT_SYMBOL(__set_page_dirty_buffers);
 
@@ -1132,8 +1151,9 @@ __getblk_slow(struct block_device *bdev,
  */
 void fastcall mark_buffer_dirty(struct buffer_head *bh)
 {
+	WARN_ON_ONCE(!buffer_uptodate(bh));
 	if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))
-		__set_page_dirty_nobuffers(bh->b_page);
+		__set_page_dirty(bh->b_page, page_mapping(bh->b_page), 0);
 }
 
 /*
diff -puN mm/page-writeback.c~fs-introduce-some-page-buffer-invariants mm/page-writeback.c
--- a/mm/page-writeback.c~fs-introduce-some-page-buffer-invariants
+++ a/mm/page-writeback.c
@@ -824,6 +824,7 @@ int __set_page_dirty_nobuffers(struct pa
 		mapping2 = page_mapping(page);
 		if (mapping2) { /* Race with truncate? */
 			BUG_ON(mapping2 != mapping);
+			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
 			if (mapping_cap_account_dirty(mapping)) {
 				__inc_zone_page_state(page, NR_FILE_DIRTY);
 				task_io_account_write(PAGE_CACHE_SIZE);
diff -puN mm/truncate.c~fs-introduce-some-page-buffer-invariants mm/truncate.c
--- a/mm/truncate.c~fs-introduce-some-page-buffer-invariants
+++ a/mm/truncate.c
@@ -100,9 +100,9 @@ truncate_complete_page(struct address_sp
 	if (PagePrivate(page))
 		do_invalidatepage(page, 0);
 
+	remove_from_page_cache(page);
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
-	remove_from_page_cache(page);
 	page_cache_release(page);	/* pagecache ref */
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-1.patch
mm-fault-feedback-2.patch
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
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
ocfs2-convert-to-new-aops.patch
fs-remove-some-aop_truncated_page.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
