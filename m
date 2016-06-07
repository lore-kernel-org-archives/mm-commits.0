From: akpm@linux-foundation.org
Subject: + filemap-prepare-find-and-delete-operations-for-huge-pages.patch added to -mm tree
Date: Tue, 07 Jun 2016 14:04:26 -0700
Message-ID: <575736da.6+3iVfpIzETEL8Yt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422628AbcFGVE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 17:04:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, andreslc@google.com, aneesh.kumar@linux.vnet.ibm.com, cl@gentwo.org, dave.hansen@intel.com, hughd@google.com, jmarchan@redhat.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, quning@gmail.com, sasha.levin@oracle.com, vbabka@suse.cz, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: prepare find and delete operations for huge pages
has been added to the -mm tree.  Its filename is
     filemap-prepare-find-and-delete-operations-for-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/filemap-prepare-find-and-delete-operations-for-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/filemap-prepare-find-and-delete-operations-for-huge-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: filemap: prepare find and delete operations for huge pages

For now, we would have HPAGE_PMD_NR entries in radix tree for every huge
page. That's suboptimal and it will be changed to use Matthew's
multi-order entries later.

'add' operation is not changed, because we don't need it to implement
hugetmpfs: shmem uses its own implementation.

Link: http://lkml.kernel.org/r/1465297246-98985-20-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Ning Qu <quning@gmail.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
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

mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix.patch
thp-mlock-update-unevictable-lrutxt.patch
mm-do-not-pass-mm_struct-into-handle_mm_fault.patch
mm-introduce-fault_env.patch
mm-postpone-page-table-allocation-until-we-have-page-to-map.patch
rmap-support-file-thp.patch
mm-introduce-do_set_pmd.patch
thp-vmstats-add-counters-for-huge-file-pages.patch
thp-support-file-pages-in-zap_huge_pmd.patch
thp-handle-file-pages-in-split_huge_pmd.patch
thp-handle-file-cow-faults.patch
thp-skip-file-huge-pmd-on-copy_huge_pmd.patch
thp-prepare-change_huge_pmd-for-file-thp.patch
thp-run-vma_adjust_trans_huge-outside-i_mmap_rwsem.patch
thp-file-pages-support-for-split_huge_page.patch
thp-mlock-do-not-mlock-pte-mapped-file-huge-pages.patch
vmscan-split-file-huge-pages-before-paging-them-out.patch
page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim.patch
radix-tree-implement-radix_tree_maybe_preload_order.patch
filemap-prepare-find-and-delete-operations-for-huge-pages.patch
truncate-handle-file-thp.patch
mm-rmap-account-shmem-thp-pages.patch
shmem-prepare-huge=-mount-option-and-sysfs-knob.patch
shmem-add-huge-pages-support.patch
shmem-thp-respect-madv_nohugepage-for-file-mappings.patch
thp-extract-khugepaged-from-mm-huge_memoryc.patch
khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page.patch
shmem-make-shmem_inode_info-lock-irq-safe.patch
khugepaged-add-support-of-collapse-for-tmpfs-shmem-pages.patch
thp-introduce-config_transparent_huge_pagecache.patch
shmem-split-huge-pages-beyond-i_size-under-memory-pressure.patch
thp-update-documentation-vm-transhugefilesystems-proctxt.patch
a.patch

