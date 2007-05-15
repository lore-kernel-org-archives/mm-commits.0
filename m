From: akpm@linux-foundation.org
Subject: + fs-introduce-some-page-buffer-invariants.patch added to -mm tree
Date: Tue, 15 May 2007 09:03:25 -0700
Message-ID: <200705151603.l4FG3PvY011867@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757352AbXEOQDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 12:03:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     fs: introduce some page/buffer invariants
has been added to the -mm tree.  Its filename is
     fs-introduce-some-page-buffer-invariants.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
+		WARN_ON(warn && !PageUptodate(page));
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
 
@@ -1137,8 +1156,9 @@ __getblk_slow(struct block_device *bdev,
  */
 void fastcall mark_buffer_dirty(struct buffer_head *bh)
 {
+	WARN_ON(!buffer_uptodate(bh));
 	if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))
-		__set_page_dirty_nobuffers(bh->b_page);
+		__set_page_dirty(bh->b_page, page_mapping(bh->b_page), 0);
 }
 
 /*
diff -puN mm/page-writeback.c~fs-introduce-some-page-buffer-invariants mm/page-writeback.c
--- a/mm/page-writeback.c~fs-introduce-some-page-buffer-invariants
+++ a/mm/page-writeback.c
@@ -826,6 +826,7 @@ int __set_page_dirty_nobuffers(struct pa
 		mapping2 = page_mapping(page);
 		if (mapping2) { /* Race with truncate? */
 			BUG_ON(mapping2 != mapping);
+			WARN_ON(!PageUptodate(page));
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

slob-implement-rcu-freeing.patch
mm-more-rmap-checking.patch
mm-more-rmap-checking-tidy.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
