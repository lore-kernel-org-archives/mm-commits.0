From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-batch-radix-tree-operations-when-truncating-pages-fix.patch removed from -mm tree
Date: Wed, 15 Nov 2017 17:05:41 -0800
Message-ID: <5a0ce465.mCZhjxNKwC4ybKLe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36214 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932186AbdKPBFm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:05:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert delete_from_page_cache_batch() to pagevec
has been removed from the -mm tree.  Its filename was
     mm-batch-radix-tree-operations-when-truncating-pages-fix.patch

This patch was dropped because it was folded into mm-batch-radix-tree-operations-when-truncating-pages.patch

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: convert delete_from_page_cache_batch() to pagevec

Use pagevec instead of page array - to be folded into the last patch of my
batched truncate series: "mm: Batch radix tree operations when truncating
pages".  Thanks!

Link: http://lkml.kernel.org/r/20171018111648.13714-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    6 +++--
 mm/filemap.c            |   43 ++++++++++++++++++--------------------
 mm/truncate.c           |   18 +++++++--------
 3 files changed, 34 insertions(+), 33 deletions(-)

diff -puN include/linux/pagemap.h~mm-batch-radix-tree-operations-when-truncating-pages-fix include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-batch-radix-tree-operations-when-truncating-pages-fix
+++ a/include/linux/pagemap.h
@@ -617,6 +617,8 @@ static inline int fault_in_pages_readabl
 	return 0;
 }
 
+struct pagevec;
+
 int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
@@ -624,8 +626,8 @@ int add_to_page_cache_lru(struct page *p
 extern void delete_from_page_cache(struct page *page);
 extern void __delete_from_page_cache(struct page *page, void *shadow);
 int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask);
-void delete_from_page_cache_batch(struct address_space *mapping, int count,
-				  struct page **pages);
+void delete_from_page_cache_batch(struct address_space *mapping,
+				  struct pagevec *pvec);
 
 /*
  * Like add_to_page_cache_locked, but used to add newly allocated pages:
diff -puN mm/filemap.c~mm-batch-radix-tree-operations-when-truncating-pages-fix mm/filemap.c
--- a/mm/filemap.c~mm-batch-radix-tree-operations-when-truncating-pages-fix
+++ a/mm/filemap.c
@@ -307,21 +307,20 @@ EXPORT_SYMBOL(delete_from_page_cache);
 /*
  * page_cache_tree_delete_batch - delete several pages from page cache
  * @mapping: the mapping to which pages belong
- * @count: the number of pages to delete
- * @pages: pages that should be deleted
+ * @pvec: pagevec with pages to delete
  *
- * The function walks over mapping->page_tree and removes pages passed in
- * @pages array from the radix tree. The function expects @pages array to
- * sorted by page index. It tolerates holes in @pages array (radix tree
- * entries at those indices are not modified). The function expects only THP
- * head pages to be present in the @pages array and takes care to delete all
- * corresponding tail pages from the radix tree as well.
+ * The function walks over mapping->page_tree and removes pages passed in @pvec
+ * from the radix tree. The function expects @pvec to be sorted by page index.
+ * It tolerates holes in @pvec (radix tree entries at those indices are not
+ * modified). The function expects only THP head pages to be present in the
+ * @pvec and takes care to delete all corresponding tail pages from the radix
+ * tree as well.
  *
  * The function expects mapping->tree_lock to be held.
  */
 static void
-page_cache_tree_delete_batch(struct address_space *mapping, int count,
-			     struct page **pages)
+page_cache_tree_delete_batch(struct address_space *mapping,
+			     struct pagevec *pvec)
 {
 	struct radix_tree_iter iter;
 	void **slot;
@@ -330,9 +329,9 @@ page_cache_tree_delete_batch(struct addr
 	struct page *page;
 	pgoff_t start;
 
-	start = pages[0]->index;
+	start = pvec->pages[0]->index;
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
-		if (i >= count && !tail_pages)
+		if (i >= pagevec_count(pvec) && !tail_pages)
 			break;
 		page = radix_tree_deref_slot_protected(slot,
 						       &mapping->tree_lock);
@@ -344,7 +343,7 @@ page_cache_tree_delete_batch(struct addr
 			 * have our pages locked so they are protected from
 			 * being removed.
 			 */
-			if (page != pages[i])
+			if (page != pvec->pages[i])
 				continue;
 			WARN_ON_ONCE(!PageLocked(page));
 			if (PageTransHuge(page) && !PageHuge(page))
@@ -366,26 +365,26 @@ page_cache_tree_delete_batch(struct addr
 	mapping->nrpages -= total_pages;
 }
 
-void delete_from_page_cache_batch(struct address_space *mapping, int count,
-				  struct page **pages)
+void delete_from_page_cache_batch(struct address_space *mapping,
+				  struct pagevec *pvec)
 {
 	int i;
 	unsigned long flags;
 
-	if (!count)
+	if (!pagevec_count(pvec))
 		return;
 
 	spin_lock_irqsave(&mapping->tree_lock, flags);
-	for (i = 0; i < count; i++) {
-		trace_mm_filemap_delete_from_page_cache(pages[i]);
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		trace_mm_filemap_delete_from_page_cache(pvec->pages[i]);
 
-		unaccount_page_cache_page(mapping, pages[i]);
+		unaccount_page_cache_page(mapping, pvec->pages[i]);
 	}
-	page_cache_tree_delete_batch(mapping, count, pages);
+	page_cache_tree_delete_batch(mapping, pvec);
 	spin_unlock_irqrestore(&mapping->tree_lock, flags);
 
-	for (i = 0; i < count; i++)
-		page_cache_free_page(mapping, pages[i]);
+	for (i = 0; i < pagevec_count(pvec); i++)
+		page_cache_free_page(mapping, pvec->pages[i]);
 }
 
 int filemap_check_errors(struct address_space *mapping)
diff -puN mm/truncate.c~mm-batch-radix-tree-operations-when-truncating-pages-fix mm/truncate.c
--- a/mm/truncate.c~mm-batch-radix-tree-operations-when-truncating-pages-fix
+++ a/mm/truncate.c
@@ -297,11 +297,11 @@ void truncate_inode_pages_range(struct a
 		/*
 		 * Pagevec array has exceptional entries and we may also fail
 		 * to lock some pages. So we store pages that can be deleted
-		 * in an extra array.
+		 * in a new pagevec.
 		 */
-		struct page *pages[PAGEVEC_SIZE];
-		int batch_count = 0;
+		struct pagevec locked_pvec;
 
+		pagevec_init(&locked_pvec, 0);
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
@@ -327,13 +327,13 @@ void truncate_inode_pages_range(struct a
 				unlock_page(page);
 				continue;
 			}
-			pages[batch_count++] = page;
+			pagevec_add(&locked_pvec, page);
 		}
-		for (i = 0; i < batch_count; i++)
-			truncate_cleanup_page(mapping, pages[i]);
-		delete_from_page_cache_batch(mapping, batch_count, pages);
-		for (i = 0; i < batch_count; i++)
-			unlock_page(pages[i]);
+		for (i = 0; i < pagevec_count(&locked_pvec); i++)
+			truncate_cleanup_page(mapping, locked_pvec.pages[i]);
+		delete_from_page_cache_batch(mapping, &locked_pvec);
+		for (i = 0; i < pagevec_count(&locked_pvec); i++)
+			unlock_page(locked_pvec.pages[i]);
 		pagevec_remove_exceptionals(&pvec);
 		pagevec_release(&pvec);
 		cond_resched();
_

Patches currently in -mm which might be from jack@suse.cz are

mm-implement-find_get_pages_range_tag.patch
btrfs-use-pagevec_lookup_range_tag.patch
ceph-use-pagevec_lookup_range_tag.patch
ext4-use-pagevec_lookup_range_tag.patch
f2fs-use-pagevec_lookup_range_tag.patch
f2fs-simplify-page-iteration-loops.patch
f2fs-use-find_get_pages_tag-for-looking-up-single-page.patch
gfs2-use-pagevec_lookup_range_tag.patch
nilfs2-use-pagevec_lookup_range_tag.patch
mm-use-pagevec_lookup_range_tag-in-__filemap_fdatawait_range.patch
mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch
mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch
ceph-use-pagevec_lookup_range_nr_tag.patch
mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag.patch
afs-use-find_get_pages_range_tag.patch
cifs-use-find_get_pages_range_tag.patch
mm-speedup-cancel_dirty_page-for-clean-pages.patch
mm-refactor-truncate_complete_page.patch
mm-factor-out-page-cache-page-freeing-into-a-separate-function.patch
mm-move-accounting-updates-before-page_cache_tree_delete.patch
mm-move-clearing-of-page-mapping-to-page_cache_tree_delete.patch
mm-factor-out-checks-and-accounting-from-__delete_from_page_cache.patch
mm-batch-radix-tree-operations-when-truncating-pages.patch
mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock-fix.patch

