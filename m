From: akpm@linux-foundation.org
Subject: [merged]
 filemap-prepare-find-and-delete-operations-for-huge-pages.patch removed
 from -mm tree
Date: Wed, 27 Jul 2016 12:02:46 -0700
Message-ID: <57990556.+ViKrjBhvEDXyjNC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862AbcG0TCr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:02:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: prepare find and delete operations for huge pages
has been removed from the -mm tree.  Its filename was
     filemap-prepare-find-and-delete-operations-for-huge-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: filemap: prepare find and delete operations for huge pages

For now, we would have HPAGE_PMD_NR entries in radix tree for every huge
page. That's suboptimal and it will be changed to use Matthew's
multi-order entries later.

'add' operation is not changed, because we don't need it to implement
hugetmpfs: shmem uses its own implementation.

Link: http://lkml.kernel.org/r/1466021202-61880-25-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |  178 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 122 insertions(+), 56 deletions(-)

diff -puN mm/filemap.c~filemap-prepare-find-and-delete-operations-for-huge-pages mm/filemap.c
--- a/mm/filemap.c~filemap-prepare-find-and-delete-operations-for-huge-pages
+++ a/mm/filemap.c
@@ -114,14 +114,14 @@ static void page_cache_tree_delete(struc
 				   struct page *page, void *shadow)
 {
 	struct radix_tree_node *node;
+	int i, nr = PageHuge(page) ? 1 : hpage_nr_pages(page);
 
-	VM_BUG_ON(!PageLocked(page));
-
-	node = radix_tree_replace_clear_tags(&mapping->page_tree, page->index,
-								shadow);
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(PageTail(page), page);
+	VM_BUG_ON_PAGE(nr != 1 && shadow, page);
 
 	if (shadow) {
-		mapping->nrexceptional++;
+		mapping->nrexceptional += nr;
 		/*
 		 * Make sure the nrexceptional update is committed before
 		 * the nrpages update so that final truncate racing
@@ -130,31 +130,38 @@ static void page_cache_tree_delete(struc
 		 */
 		smp_wmb();
 	}
-	mapping->nrpages--;
-
-	if (!node)
-		return;
+	mapping->nrpages -= nr;
 
-	workingset_node_pages_dec(node);
-	if (shadow)
-		workingset_node_shadows_inc(node);
-	else
-		if (__radix_tree_delete_node(&mapping->page_tree, node))
+	for (i = 0; i < nr; i++) {
+		node = radix_tree_replace_clear_tags(&mapping->page_tree,
+				page->index + i, shadow);
+		if (!node) {
+			VM_BUG_ON_PAGE(nr != 1, page);
 			return;
+		}
 
-	/*
-	 * Track node that only contains shadow entries. DAX mappings contain
-	 * no shadow entries and may contain other exceptional entries so skip
-	 * those.
-	 *
-	 * Avoid acquiring the list_lru lock if already tracked.  The
-	 * list_empty() test is safe as node->private_list is
-	 * protected by mapping->tree_lock.
-	 */
-	if (!dax_mapping(mapping) && !workingset_node_pages(node) &&
-	    list_empty(&node->private_list)) {
-		node->private_data = mapping;
-		list_lru_add(&workingset_shadow_nodes, &node->private_list);
+		workingset_node_pages_dec(node);
+		if (shadow)
+			workingset_node_shadows_inc(node);
+		else
+			if (__radix_tree_delete_node(&mapping->page_tree, node))
+				continue;
+
+		/*
+		 * Track node that only contains shadow entries. DAX mappings
+		 * contain no shadow entries and may contain other exceptional
+		 * entries so skip those.
+		 *
+		 * Avoid acquiring the list_lru lock if already tracked.
+		 * The list_empty() test is safe as node->private_list is
+		 * protected by mapping->tree_lock.
+		 */
+		if (!dax_mapping(mapping) && !workingset_node_pages(node) &&
+				list_empty(&node->private_list)) {
+			node->private_data = mapping;
+			list_lru_add(&workingset_shadow_nodes,
+					&node->private_list);
+		}
 	}
 }
 
@@ -166,6 +173,7 @@ static void page_cache_tree_delete(struc
 void __delete_from_page_cache(struct page *page, void *shadow)
 {
 	struct address_space *mapping = page->mapping;
+	int nr = hpage_nr_pages(page);
 
 	trace_mm_filemap_delete_from_page_cache(page);
 	/*
@@ -178,6 +186,7 @@ void __delete_from_page_cache(struct pag
 	else
 		cleancache_invalidate_page(mapping, page);
 
+	VM_BUG_ON_PAGE(PageTail(page), page);
 	VM_BUG_ON_PAGE(page_mapped(page), page);
 	if (!IS_ENABLED(CONFIG_DEBUG_VM) && unlikely(page_mapped(page))) {
 		int mapcount;
@@ -209,9 +218,9 @@ void __delete_from_page_cache(struct pag
 
 	/* hugetlb pages do not participate in page cache accounting. */
 	if (!PageHuge(page))
-		__dec_zone_page_state(page, NR_FILE_PAGES);
+		__mod_zone_page_state(page_zone(page), NR_FILE_PAGES, -nr);
 	if (PageSwapBacked(page))
-		__dec_zone_page_state(page, NR_SHMEM);
+		__mod_zone_page_state(page_zone(page), NR_SHMEM, -nr);
 
 	/*
 	 * At this point page must be either written or cleaned by truncate.
@@ -235,9 +244,8 @@ void __delete_from_page_cache(struct pag
  */
 void delete_from_page_cache(struct page *page)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = page_mapping(page);
 	unsigned long flags;
-
 	void (*freepage)(struct page *);
 
 	BUG_ON(!PageLocked(page));
@@ -250,7 +258,13 @@ void delete_from_page_cache(struct page
 
 	if (freepage)
 		freepage(page);
-	put_page(page);
+
+	if (PageTransHuge(page) && !PageHuge(page)) {
+		page_ref_sub(page, HPAGE_PMD_NR);
+		VM_BUG_ON_PAGE(page_count(page) <= 0, page);
+	} else {
+		put_page(page);
+	}
 }
 EXPORT_SYMBOL(delete_from_page_cache);
 
@@ -1053,7 +1067,7 @@ EXPORT_SYMBOL(page_cache_prev_hole);
 struct page *find_get_entry(struct address_space *mapping, pgoff_t offset)
 {
 	void **pagep;
-	struct page *page;
+	struct page *head, *page;
 
 	rcu_read_lock();
 repeat:
@@ -1073,8 +1087,16 @@ repeat:
 			 */
 			goto out;
 		}
-		if (!page_cache_get_speculative(page))
+
+		head = compound_head(page);
+		if (!page_cache_get_speculative(head))
+			goto repeat;
+
+		/* The page was split under us? */
+		if (compound_head(page) != head) {
+			put_page(head);
 			goto repeat;
+		}
 
 		/*
 		 * Has the page moved?
@@ -1082,7 +1104,7 @@ repeat:
 		 * include/linux/pagemap.h for details.
 		 */
 		if (unlikely(page != *pagep)) {
-			put_page(page);
+			put_page(head);
 			goto repeat;
 		}
 	}
@@ -1118,12 +1140,12 @@ repeat:
 	if (page && !radix_tree_exception(page)) {
 		lock_page(page);
 		/* Has the page been truncated? */
-		if (unlikely(page->mapping != mapping)) {
+		if (unlikely(page_mapping(page) != mapping)) {
 			unlock_page(page);
 			put_page(page);
 			goto repeat;
 		}
-		VM_BUG_ON_PAGE(page->index != offset, page);
+		VM_BUG_ON_PAGE(page_to_pgoff(page) != offset, page);
 	}
 	return page;
 }
@@ -1255,7 +1277,7 @@ unsigned find_get_entries(struct address
 
 	rcu_read_lock();
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
-		struct page *page;
+		struct page *head, *page;
 repeat:
 		page = radix_tree_deref_slot(slot);
 		if (unlikely(!page))
@@ -1272,12 +1294,20 @@ repeat:
 			 */
 			goto export;
 		}
-		if (!page_cache_get_speculative(page))
+
+		head = compound_head(page);
+		if (!page_cache_get_speculative(head))
+			goto repeat;
+
+		/* The page was split under us? */
+		if (compound_head(page) != head) {
+			put_page(head);
 			goto repeat;
+		}
 
 		/* Has the page moved? */
 		if (unlikely(page != *slot)) {
-			put_page(page);
+			put_page(head);
 			goto repeat;
 		}
 export:
@@ -1318,7 +1348,7 @@ unsigned find_get_pages(struct address_s
 
 	rcu_read_lock();
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
-		struct page *page;
+		struct page *head, *page;
 repeat:
 		page = radix_tree_deref_slot(slot);
 		if (unlikely(!page))
@@ -1337,12 +1367,19 @@ repeat:
 			continue;
 		}
 
-		if (!page_cache_get_speculative(page))
+		head = compound_head(page);
+		if (!page_cache_get_speculative(head))
+			goto repeat;
+
+		/* The page was split under us? */
+		if (compound_head(page) != head) {
+			put_page(head);
 			goto repeat;
+		}
 
 		/* Has the page moved? */
 		if (unlikely(page != *slot)) {
-			put_page(page);
+			put_page(head);
 			goto repeat;
 		}
 
@@ -1379,7 +1416,7 @@ unsigned find_get_pages_contig(struct ad
 
 	rcu_read_lock();
 	radix_tree_for_each_contig(slot, &mapping->page_tree, &iter, index) {
-		struct page *page;
+		struct page *head, *page;
 repeat:
 		page = radix_tree_deref_slot(slot);
 		/* The hole, there no reason to continue */
@@ -1399,12 +1436,19 @@ repeat:
 			break;
 		}
 
-		if (!page_cache_get_speculative(page))
+		head = compound_head(page);
+		if (!page_cache_get_speculative(head))
+			goto repeat;
+
+		/* The page was split under us? */
+		if (compound_head(page) != head) {
+			put_page(head);
 			goto repeat;
+		}
 
 		/* Has the page moved? */
 		if (unlikely(page != *slot)) {
-			put_page(page);
+			put_page(head);
 			goto repeat;
 		}
 
@@ -1413,7 +1457,7 @@ repeat:
 		 * otherwise we can get both false positives and false
 		 * negatives, which is just confusing to the caller.
 		 */
-		if (page->mapping == NULL || page->index != iter.index) {
+		if (page->mapping == NULL || page_to_pgoff(page) != iter.index) {
 			put_page(page);
 			break;
 		}
@@ -1451,7 +1495,7 @@ unsigned find_get_pages_tag(struct addre
 	rcu_read_lock();
 	radix_tree_for_each_tagged(slot, &mapping->page_tree,
 				   &iter, *index, tag) {
-		struct page *page;
+		struct page *head, *page;
 repeat:
 		page = radix_tree_deref_slot(slot);
 		if (unlikely(!page))
@@ -1476,12 +1520,19 @@ repeat:
 			continue;
 		}
 
-		if (!page_cache_get_speculative(page))
+		head = compound_head(page);
+		if (!page_cache_get_speculative(head))
 			goto repeat;
 
+		/* The page was split under us? */
+		if (compound_head(page) != head) {
+			put_page(head);
+			goto repeat;
+		}
+
 		/* Has the page moved? */
 		if (unlikely(page != *slot)) {
-			put_page(page);
+			put_page(head);
 			goto repeat;
 		}
 
@@ -1525,7 +1576,7 @@ unsigned find_get_entries_tag(struct add
 	rcu_read_lock();
 	radix_tree_for_each_tagged(slot, &mapping->page_tree,
 				   &iter, start, tag) {
-		struct page *page;
+		struct page *head, *page;
 repeat:
 		page = radix_tree_deref_slot(slot);
 		if (unlikely(!page))
@@ -1543,12 +1594,20 @@ repeat:
 			 */
 			goto export;
 		}
-		if (!page_cache_get_speculative(page))
+
+		head = compound_head(page);
+		if (!page_cache_get_speculative(head))
 			goto repeat;
 
+		/* The page was split under us? */
+		if (compound_head(page) != head) {
+			put_page(head);
+			goto repeat;
+		}
+
 		/* Has the page moved? */
 		if (unlikely(page != *slot)) {
-			put_page(page);
+			put_page(head);
 			goto repeat;
 		}
 export:
@@ -2137,7 +2196,7 @@ void filemap_map_pages(struct fault_env
 	struct address_space *mapping = file->f_mapping;
 	pgoff_t last_pgoff = start_pgoff;
 	loff_t size;
-	struct page *page;
+	struct page *head, *page;
 
 	rcu_read_lock();
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter,
@@ -2156,12 +2215,19 @@ repeat:
 			goto next;
 		}
 
-		if (!page_cache_get_speculative(page))
+		head = compound_head(page);
+		if (!page_cache_get_speculative(head))
 			goto repeat;
 
+		/* The page was split under us? */
+		if (compound_head(page) != head) {
+			put_page(head);
+			goto repeat;
+		}
+
 		/* Has the page moved? */
 		if (unlikely(page != *slot)) {
-			put_page(page);
+			put_page(head);
 			goto repeat;
 		}
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


