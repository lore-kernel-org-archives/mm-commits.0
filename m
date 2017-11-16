From: akpm@linux-foundation.org
Subject: [merged]
 mm-batch-radix-tree-operations-when-truncating-pages.patch removed from -mm
 tree
Date: Thu, 16 Nov 2017 12:04:03 -0800
Message-ID: <20171116200403.DbRf8gcYE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47252 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933284AbdKPUEE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:04:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: batch radix tree operations when truncating pages
has been removed from the -mm tree.  Its filename was
     mm-batch-radix-tree-operations-when-truncating-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: batch radix tree operations when truncating pages

Currently we remove pages from the radix tree one by one.  To speed up
page cache truncation, lock several pages at once and free them in one go.
This allows us to batch radix tree operations in a more efficient way and
also save round-trips on mapping->tree_lock.  As a result we gain about
20% speed improvement in page cache truncation.

Data from a simple benchmark timing 10000 truncates of 1024 pages (on ext4
on ramdisk but the filesystem is barely visible in the profiles).  The
range shows 1% and 95% percentiles of the measured times:

4.14-rc2	4.14-rc2 + batched truncation
248-256		209-219
249-258		209-217
248-255		211-239
248-255		209-217
247-256		210-218

[jack@suse.cz: convert delete_from_page_cache_batch() to pagevec]
  Link: http://lkml.kernel.org/r/20171018111648.13714-1-jack@suse.cz
[akpm@linux-foundation.org: move struct pagevec forward declaration to top-of-file]
Link: http://lkml.kernel.org/r/20171010151937.26984-8-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    4 +
 mm/filemap.c            |   83 ++++++++++++++++++++++++++++++++++++++
 mm/truncate.c           |   20 ++++++++-
 3 files changed, 105 insertions(+), 2 deletions(-)

diff -puN include/linux/pagemap.h~mm-batch-radix-tree-operations-when-truncating-pages include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-batch-radix-tree-operations-when-truncating-pages
+++ a/include/linux/pagemap.h
@@ -16,6 +16,8 @@
 #include <linux/hardirq.h> /* for in_interrupt() */
 #include <linux/hugetlb_inline.h>
 
+struct pagevec;
+
 /*
  * Bits in mapping->flags.
  */
@@ -624,6 +626,8 @@ int add_to_page_cache_lru(struct page *p
 extern void delete_from_page_cache(struct page *page);
 extern void __delete_from_page_cache(struct page *page, void *shadow);
 int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask);
+void delete_from_page_cache_batch(struct address_space *mapping,
+				  struct pagevec *pvec);
 
 /*
  * Like add_to_page_cache_locked, but used to add newly allocated pages:
diff -puN mm/filemap.c~mm-batch-radix-tree-operations-when-truncating-pages mm/filemap.c
--- a/mm/filemap.c~mm-batch-radix-tree-operations-when-truncating-pages
+++ a/mm/filemap.c
@@ -304,6 +304,89 @@ void delete_from_page_cache(struct page
 }
 EXPORT_SYMBOL(delete_from_page_cache);
 
+/*
+ * page_cache_tree_delete_batch - delete several pages from page cache
+ * @mapping: the mapping to which pages belong
+ * @pvec: pagevec with pages to delete
+ *
+ * The function walks over mapping->page_tree and removes pages passed in @pvec
+ * from the radix tree. The function expects @pvec to be sorted by page index.
+ * It tolerates holes in @pvec (radix tree entries at those indices are not
+ * modified). The function expects only THP head pages to be present in the
+ * @pvec and takes care to delete all corresponding tail pages from the radix
+ * tree as well.
+ *
+ * The function expects mapping->tree_lock to be held.
+ */
+static void
+page_cache_tree_delete_batch(struct address_space *mapping,
+			     struct pagevec *pvec)
+{
+	struct radix_tree_iter iter;
+	void **slot;
+	int total_pages = 0;
+	int i = 0, tail_pages = 0;
+	struct page *page;
+	pgoff_t start;
+
+	start = pvec->pages[0]->index;
+	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
+		if (i >= pagevec_count(pvec) && !tail_pages)
+			break;
+		page = radix_tree_deref_slot_protected(slot,
+						       &mapping->tree_lock);
+		if (radix_tree_exceptional_entry(page))
+			continue;
+		if (!tail_pages) {
+			/*
+			 * Some page got inserted in our range? Skip it. We
+			 * have our pages locked so they are protected from
+			 * being removed.
+			 */
+			if (page != pvec->pages[i])
+				continue;
+			WARN_ON_ONCE(!PageLocked(page));
+			if (PageTransHuge(page) && !PageHuge(page))
+				tail_pages = HPAGE_PMD_NR - 1;
+			page->mapping = NULL;
+			/*
+			 * Leave page->index set: truncation lookup relies
+			 * upon it
+			 */
+			i++;
+		} else {
+			tail_pages--;
+		}
+		radix_tree_clear_tags(&mapping->page_tree, iter.node, slot);
+		__radix_tree_replace(&mapping->page_tree, iter.node, slot, NULL,
+				     workingset_update_node, mapping);
+		total_pages++;
+	}
+	mapping->nrpages -= total_pages;
+}
+
+void delete_from_page_cache_batch(struct address_space *mapping,
+				  struct pagevec *pvec)
+{
+	int i;
+	unsigned long flags;
+
+	if (!pagevec_count(pvec))
+		return;
+
+	spin_lock_irqsave(&mapping->tree_lock, flags);
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		trace_mm_filemap_delete_from_page_cache(pvec->pages[i]);
+
+		unaccount_page_cache_page(mapping, pvec->pages[i]);
+	}
+	page_cache_tree_delete_batch(mapping, pvec);
+	spin_unlock_irqrestore(&mapping->tree_lock, flags);
+
+	for (i = 0; i < pagevec_count(pvec); i++)
+		page_cache_free_page(mapping, pvec->pages[i]);
+}
+
 int filemap_check_errors(struct address_space *mapping)
 {
 	int ret = 0;
diff -puN mm/truncate.c~mm-batch-radix-tree-operations-when-truncating-pages mm/truncate.c
--- a/mm/truncate.c~mm-batch-radix-tree-operations-when-truncating-pages
+++ a/mm/truncate.c
@@ -294,6 +294,14 @@ void truncate_inode_pages_range(struct a
 	while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE),
 			indices)) {
+		/*
+		 * Pagevec array has exceptional entries and we may also fail
+		 * to lock some pages. So we store pages that can be deleted
+		 * in a new pagevec.
+		 */
+		struct pagevec locked_pvec;
+
+		pagevec_init(&locked_pvec, 0);
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
@@ -315,9 +323,17 @@ void truncate_inode_pages_range(struct a
 				unlock_page(page);
 				continue;
 			}
-			truncate_inode_page(mapping, page);
-			unlock_page(page);
+			if (page->mapping != mapping) {
+				unlock_page(page);
+				continue;
+			}
+			pagevec_add(&locked_pvec, page);
 		}
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

mm-readahead-increase-maximum-readahead-window.patch

