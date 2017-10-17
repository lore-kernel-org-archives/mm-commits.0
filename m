From: akpm@linux-foundation.org
Subject: + mm-batch-radix-tree-operations-when-truncating-pages.patch
 added to -mm tree
Date: Tue, 17 Oct 2017 16:09:36 -0700
Message-ID: <59e68db0.I14xdhx2EG+fjhKq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59352 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932983AbdJQXJh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 19:09:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: batch radix tree operations when truncating pages
has been added to the -mm tree.  Its filename is
     mm-batch-radix-tree-operations-when-truncating-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-batch-radix-tree-operations-when-truncating-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-batch-radix-tree-operations-when-truncating-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: http://lkml.kernel.org/r/20171010151937.26984-8-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 
 mm/filemap.c            |   84 ++++++++++++++++++++++++++++++++++++++
 mm/truncate.c           |   20 ++++++++-
 3 files changed, 104 insertions(+), 2 deletions(-)

diff -puN include/linux/pagemap.h~mm-batch-radix-tree-operations-when-truncating-pages include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-batch-radix-tree-operations-when-truncating-pages
+++ a/include/linux/pagemap.h
@@ -623,6 +623,8 @@ int add_to_page_cache_lru(struct page *p
 extern void delete_from_page_cache(struct page *page);
 extern void __delete_from_page_cache(struct page *page, void *shadow);
 int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask);
+void delete_from_page_cache_batch(struct address_space *mapping, int count,
+				  struct page **pages);
 
 /*
  * Like add_to_page_cache_locked, but used to add newly allocated pages:
diff -puN mm/filemap.c~mm-batch-radix-tree-operations-when-truncating-pages mm/filemap.c
--- a/mm/filemap.c~mm-batch-radix-tree-operations-when-truncating-pages
+++ a/mm/filemap.c
@@ -304,6 +304,90 @@ void delete_from_page_cache(struct page
 }
 EXPORT_SYMBOL(delete_from_page_cache);
 
+/*
+ * page_cache_tree_delete_batch - delete several pages from page cache
+ * @mapping: the mapping to which pages belong
+ * @count: the number of pages to delete
+ * @pages: pages that should be deleted
+ *
+ * The function walks over mapping->page_tree and removes pages passed in
+ * @pages array from the radix tree. The function expects @pages array to
+ * sorted by page index. It tolerates holes in @pages array (radix tree
+ * entries at those indices are not modified). The function expects only THP
+ * head pages to be present in the @pages array and takes care to delete all
+ * corresponding tail pages from the radix tree as well.
+ *
+ * The function expects mapping->tree_lock to be held.
+ */
+static void
+page_cache_tree_delete_batch(struct address_space *mapping, int count,
+			     struct page **pages)
+{
+	struct radix_tree_iter iter;
+	void **slot;
+	int total_pages = 0;
+	int i = 0, tail_pages = 0;
+	struct page *page;
+	pgoff_t start;
+
+	start = pages[0]->index;
+	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
+		if (i >= count && !tail_pages)
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
+			if (page != pages[i])
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
+void delete_from_page_cache_batch(struct address_space *mapping, int count,
+				  struct page **pages)
+{
+	int i;
+	unsigned long flags;
+
+	if (!count)
+		return;
+
+	spin_lock_irqsave(&mapping->tree_lock, flags);
+	for (i = 0; i < count; i++) {
+		trace_mm_filemap_delete_from_page_cache(pages[i]);
+
+		unaccount_page_cache_page(mapping, pages[i]);
+	}
+	page_cache_tree_delete_batch(mapping, count, pages);
+	spin_unlock_irqrestore(&mapping->tree_lock, flags);
+
+	for (i = 0; i < count; i++)
+		page_cache_free_page(mapping, pages[i]);
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
+		 * in an extra array.
+		 */
+		struct page *pages[PAGEVEC_SIZE];
+		int batch_count = 0;
+
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
+			pages[batch_count++] = page;
 		}
+		for (i = 0; i < batch_count; i++)
+			truncate_cleanup_page(mapping, pages[i]);
+		delete_from_page_cache_batch(mapping, batch_count, pages);
+		for (i = 0; i < batch_count; i++)
+			unlock_page(pages[i]);
 		pagevec_remove_exceptionals(&pvec);
 		pagevec_release(&pvec);
 		cond_resched();
_

Patches currently in -mm which might be from jack@suse.cz are

mm-readahead-increase-maximum-readahead-window.patch
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

