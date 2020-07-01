From: akpm@linux-foundation.org
Subject: + mm-replace-hpage_nr_pages-with-thp_nr_pages.patch added
 to -mm tree
Date: Tue, 30 Jun 2020 18:39:41 -0700
Message-ID: <20200701013941.nOmHN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgGABjn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 21:39:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ziy@nvidia.com, william.kucharski@oracle.com, mike.kravetz@oracle.com, kirill.shutemov@linux.intel.com, david@redhat.com, willy@infradead.org


The patch titled
     Subject: mm: replace hpage_nr_pages with thp_nr_pages
has been added to the -mm tree.  Its filename is
     mm-replace-hpage_nr_pages-with-thp_nr_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-replace-hpage_nr_pages-with-thp_nr_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-replace-hpage_nr_pages-with-thp_nr_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: replace hpage_nr_pages with thp_nr_pages

The thp prefix is more frequently used than hpage and we should be
consistent between the various functions.

Link: http://lkml.kernel.org/r/20200629151959.15779-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h   |   13 +++++++++----
 include/linux/mm_inline.h |    6 +++---
 include/linux/pagemap.h   |    6 +++---
 mm/compaction.c           |    2 +-
 mm/filemap.c              |    2 +-
 mm/gup.c                  |    2 +-
 mm/internal.h             |    2 +-
 mm/memcontrol.c           |   10 +++++-----
 mm/memory_hotplug.c       |    7 +++----
 mm/mempolicy.c            |    2 +-
 mm/migrate.c              |   16 ++++++++--------
 mm/mlock.c                |    9 ++++-----
 mm/page_io.c              |    2 +-
 mm/page_vma_mapped.c      |    2 +-
 mm/rmap.c                 |    8 ++++----
 mm/swap.c                 |   16 ++++++++--------
 mm/swap_state.c           |    6 +++---
 mm/swapfile.c             |    2 +-
 mm/vmscan.c               |    6 +++---
 mm/workingset.c           |    6 +++---
 20 files changed, 64 insertions(+), 61 deletions(-)

--- a/include/linux/huge_mm.h~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/include/linux/huge_mm.h
@@ -271,9 +271,14 @@ static inline unsigned int thp_order(str
 	return 0;
 }
 
-static inline int hpage_nr_pages(struct page *page)
+/**
+ * thp_nr_pages - The number of regular pages in this huge page.
+ * @page: The head page of a huge page.
+ */
+static inline int thp_nr_pages(struct page *page)
 {
-	if (unlikely(PageTransHuge(page)))
+	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	if (PageHead(page))
 		return HPAGE_PMD_NR;
 	return 1;
 }
@@ -336,9 +341,9 @@ static inline unsigned int thp_order(str
 	return 0;
 }
 
-static inline int hpage_nr_pages(struct page *page)
+static inline int thp_nr_pages(struct page *page)
 {
-	VM_BUG_ON_PAGE(PageTail(page), page);
+	VM_BUG_ON_PGFLAGS(PageTail(page), page);
 	return 1;
 }
 
--- a/include/linux/mm_inline.h~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/include/linux/mm_inline.h
@@ -48,14 +48,14 @@ static __always_inline void update_lru_s
 static __always_inline void add_page_to_lru_list(struct page *page,
 				struct lruvec *lruvec, enum lru_list lru)
 {
-	update_lru_size(lruvec, lru, page_zonenum(page), hpage_nr_pages(page));
+	update_lru_size(lruvec, lru, page_zonenum(page), thp_nr_pages(page));
 	list_add(&page->lru, &lruvec->lists[lru]);
 }
 
 static __always_inline void add_page_to_lru_list_tail(struct page *page,
 				struct lruvec *lruvec, enum lru_list lru)
 {
-	update_lru_size(lruvec, lru, page_zonenum(page), hpage_nr_pages(page));
+	update_lru_size(lruvec, lru, page_zonenum(page), thp_nr_pages(page));
 	list_add_tail(&page->lru, &lruvec->lists[lru]);
 }
 
@@ -63,7 +63,7 @@ static __always_inline void del_page_fro
 				struct lruvec *lruvec, enum lru_list lru)
 {
 	list_del(&page->lru);
-	update_lru_size(lruvec, lru, page_zonenum(page), -hpage_nr_pages(page));
+	update_lru_size(lruvec, lru, page_zonenum(page), -thp_nr_pages(page));
 }
 
 /**
--- a/include/linux/pagemap.h~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/include/linux/pagemap.h
@@ -381,7 +381,7 @@ static inline struct page *find_subpage(
 	if (PageHuge(head))
 		return head;
 
-	return head + (index & (hpage_nr_pages(head) - 1));
+	return head + (index & (thp_nr_pages(head) - 1));
 }
 
 struct page *find_get_entry(struct address_space *mapping, pgoff_t offset);
@@ -730,7 +730,7 @@ static inline struct page *readahead_pag
 
 	page = xa_load(&rac->mapping->i_pages, rac->_index);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	rac->_batch_count = hpage_nr_pages(page);
+	rac->_batch_count = thp_nr_pages(page);
 
 	return page;
 }
@@ -753,7 +753,7 @@ static inline unsigned int __readahead_b
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		VM_BUG_ON_PAGE(PageTail(page), page);
 		array[i++] = page;
-		rac->_batch_count += hpage_nr_pages(page);
+		rac->_batch_count += thp_nr_pages(page);
 
 		/*
 		 * The page cache isn't using multi-index entries yet,
--- a/mm/compaction.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/compaction.c
@@ -1009,7 +1009,7 @@ isolate_migratepages_block(struct compac
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		mod_node_page_state(page_pgdat(page),
 				NR_ISOLATED_ANON + page_is_file_lru(page),
-				hpage_nr_pages(page));
+				thp_nr_pages(page));
 
 isolate_success:
 		list_add(&page->lru, &cc->migratepages);
--- a/mm/filemap.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/filemap.c
@@ -198,7 +198,7 @@ static void unaccount_page_cache_page(st
 	if (PageHuge(page))
 		return;
 
-	nr = hpage_nr_pages(page);
+	nr = thp_nr_pages(page);
 
 	__mod_lruvec_page_state(page, NR_FILE_PAGES, -nr);
 	if (PageSwapBacked(page)) {
--- a/mm/gup.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/gup.c
@@ -1663,7 +1663,7 @@ check_again:
 					mod_node_page_state(page_pgdat(head),
 							    NR_ISOLATED_ANON +
 							    page_is_file_lru(head),
-							    hpage_nr_pages(head));
+							    thp_nr_pages(head));
 				}
 			}
 		}
--- a/mm/internal.h~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/internal.h
@@ -369,7 +369,7 @@ extern void clear_page_mlock(struct page
 static inline void mlock_migrate_page(struct page *newpage, struct page *page)
 {
 	if (TestClearPageMlocked(page)) {
-		int nr_pages = hpage_nr_pages(page);
+		int nr_pages = thp_nr_pages(page);
 
 		/* Holding pmd lock, no change in irq context: __mod is safe */
 		__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
--- a/mm/memcontrol.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/memcontrol.c
@@ -5521,7 +5521,7 @@ static int mem_cgroup_move_account(struc
 {
 	struct lruvec *from_vec, *to_vec;
 	struct pglist_data *pgdat;
-	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
+	unsigned int nr_pages = compound ? thp_nr_pages(page) : 1;
 	int ret;
 
 	VM_BUG_ON(from == to);
@@ -6620,7 +6620,7 @@ out:
  */
 int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 {
-	unsigned int nr_pages = hpage_nr_pages(page);
+	unsigned int nr_pages = thp_nr_pages(page);
 	struct mem_cgroup *memcg = NULL;
 	int ret = 0;
 
@@ -6850,7 +6850,7 @@ void mem_cgroup_migrate(struct page *old
 		return;
 
 	/* Force-charge the new page. The old one will be freed soon */
-	nr_pages = hpage_nr_pages(newpage);
+	nr_pages = thp_nr_pages(newpage);
 
 	page_counter_charge(&memcg->memory, nr_pages);
 	if (do_memsw_account())
@@ -7052,7 +7052,7 @@ void mem_cgroup_swapout(struct page *pag
 	 * ancestor for the swap instead and transfer the memory+swap charge.
 	 */
 	swap_memcg = mem_cgroup_id_get_online(memcg);
-	nr_entries = hpage_nr_pages(page);
+	nr_entries = thp_nr_pages(page);
 	/* Get references for the tail pages, too */
 	if (nr_entries > 1)
 		mem_cgroup_id_get_many(swap_memcg, nr_entries - 1);
@@ -7096,7 +7096,7 @@ void mem_cgroup_swapout(struct page *pag
  */
 int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
 {
-	unsigned int nr_pages = hpage_nr_pages(page);
+	unsigned int nr_pages = thp_nr_pages(page);
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
--- a/mm/memory_hotplug.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/memory_hotplug.c
@@ -1290,7 +1290,7 @@ static int
 do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long pfn;
-	struct page *page;
+	struct page *page, *head;
 	int ret = 0;
 	LIST_HEAD(source);
 
@@ -1298,15 +1298,14 @@ do_migrate_range(unsigned long start_pfn
 		if (!pfn_valid(pfn))
 			continue;
 		page = pfn_to_page(pfn);
+		head = compound_head(page);
 
 		if (PageHuge(page)) {
-			struct page *head = compound_head(page);
 			pfn = page_to_pfn(head) + compound_nr(head) - 1;
 			isolate_huge_page(head, &source);
 			continue;
 		} else if (PageTransHuge(page))
-			pfn = page_to_pfn(compound_head(page))
-				+ hpage_nr_pages(page) - 1;
+			pfn = page_to_pfn(head) + thp_nr_pages(page) - 1;
 
 		/*
 		 * HWPoison pages have elevated reference counts so the migration would
--- a/mm/mempolicy.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/mempolicy.c
@@ -1049,7 +1049,7 @@ static int migrate_page_add(struct page
 			list_add_tail(&head->lru, pagelist);
 			mod_node_page_state(page_pgdat(head),
 				NR_ISOLATED_ANON + page_is_file_lru(head),
-				hpage_nr_pages(head));
+				thp_nr_pages(head));
 		} else if (flags & MPOL_MF_STRICT) {
 			/*
 			 * Non-movable page may reach here.  And, there may be
--- a/mm/migrate.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/migrate.c
@@ -193,7 +193,7 @@ void putback_movable_pages(struct list_h
 			put_page(page);
 		} else {
 			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
-					page_is_file_lru(page), -hpage_nr_pages(page));
+					page_is_file_lru(page), -thp_nr_pages(page));
 			putback_lru_page(page);
 		}
 	}
@@ -386,7 +386,7 @@ static int expected_page_refs(struct add
 	 */
 	expected_count += is_device_private_page(page);
 	if (mapping)
-		expected_count += hpage_nr_pages(page) + page_has_private(page);
+		expected_count += thp_nr_pages(page) + page_has_private(page);
 
 	return expected_count;
 }
@@ -441,7 +441,7 @@ int migrate_page_move_mapping(struct add
 	 */
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
-	page_ref_add(newpage, hpage_nr_pages(page)); /* add cache reference */
+	page_ref_add(newpage, thp_nr_pages(page)); /* add cache reference */
 	if (PageSwapBacked(page)) {
 		__SetPageSwapBacked(newpage);
 		if (PageSwapCache(page)) {
@@ -474,7 +474,7 @@ int migrate_page_move_mapping(struct add
 	 * to one less reference.
 	 * We know this isn't the last reference.
 	 */
-	page_ref_unfreeze(page, expected_count - hpage_nr_pages(page));
+	page_ref_unfreeze(page, expected_count - thp_nr_pages(page));
 
 	xas_unlock(&xas);
 	/* Leave irq disabled to prevent preemption while updating stats */
@@ -591,7 +591,7 @@ static void copy_huge_page(struct page *
 	} else {
 		/* thp page */
 		BUG_ON(!PageTransHuge(src));
-		nr_pages = hpage_nr_pages(src);
+		nr_pages = thp_nr_pages(src);
 	}
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1238,7 +1238,7 @@ out:
 		 */
 		if (likely(!__PageMovable(page)))
 			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
-					page_is_file_lru(page), -hpage_nr_pages(page));
+					page_is_file_lru(page), -thp_nr_pages(page));
 	}
 
 	/*
@@ -1662,7 +1662,7 @@ static int add_page_for_migration(struct
 		list_add_tail(&head->lru, pagelist);
 		mod_node_page_state(page_pgdat(head),
 			NR_ISOLATED_ANON + page_is_file_lru(head),
-			hpage_nr_pages(head));
+			thp_nr_pages(head));
 	}
 out_putpage:
 	/*
@@ -2026,7 +2026,7 @@ static int numamigrate_isolate_page(pg_d
 
 	page_lru = page_is_file_lru(page);
 	mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON + page_lru,
-				hpage_nr_pages(page));
+				thp_nr_pages(page));
 
 	/*
 	 * Isolating the page has taken another reference, so the
--- a/mm/mlock.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/mlock.c
@@ -61,8 +61,7 @@ void clear_page_mlock(struct page *page)
 	if (!TestClearPageMlocked(page))
 		return;
 
-	mod_zone_page_state(page_zone(page), NR_MLOCK,
-			    -hpage_nr_pages(page));
+	mod_zone_page_state(page_zone(page), NR_MLOCK, -thp_nr_pages(page));
 	count_vm_event(UNEVICTABLE_PGCLEARED);
 	/*
 	 * The previous TestClearPageMlocked() corresponds to the smp_mb()
@@ -95,7 +94,7 @@ void mlock_vma_page(struct page *page)
 
 	if (!TestSetPageMlocked(page)) {
 		mod_zone_page_state(page_zone(page), NR_MLOCK,
-				    hpage_nr_pages(page));
+				    thp_nr_pages(page));
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 		if (!isolate_lru_page(page))
 			putback_lru_page(page);
@@ -192,7 +191,7 @@ unsigned int munlock_vma_page(struct pag
 	/*
 	 * Serialize with any parallel __split_huge_page_refcount() which
 	 * might otherwise copy PageMlocked to part of the tail pages before
-	 * we clear it in the head page. It also stabilizes hpage_nr_pages().
+	 * we clear it in the head page. It also stabilizes thp_nr_pages().
 	 */
 	spin_lock_irq(&pgdat->lru_lock);
 
@@ -202,7 +201,7 @@ unsigned int munlock_vma_page(struct pag
 		goto unlock_out;
 	}
 
-	nr_pages = hpage_nr_pages(page);
+	nr_pages = thp_nr_pages(page);
 	__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
 
 	if (__munlock_isolate_lru_page(page, true)) {
--- a/mm/page_io.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/page_io.c
@@ -274,7 +274,7 @@ static inline void count_swpout_vm_event
 	if (unlikely(PageTransHuge(page)))
 		count_vm_event(THP_SWPOUT);
 #endif
-	count_vm_events(PSWPOUT, hpage_nr_pages(page));
+	count_vm_events(PSWPOUT, thp_nr_pages(page));
 }
 
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
--- a/mm/page_vma_mapped.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/page_vma_mapped.c
@@ -61,7 +61,7 @@ static inline bool pfn_is_match(struct p
 		return page_pfn == pfn;
 
 	/* THP can be referenced by any subpage */
-	return pfn >= page_pfn && pfn - page_pfn < hpage_nr_pages(page);
+	return pfn >= page_pfn && pfn - page_pfn < thp_nr_pages(page);
 }
 
 /**
--- a/mm/rmap.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/rmap.c
@@ -1130,7 +1130,7 @@ void do_page_add_anon_rmap(struct page *
 	}
 
 	if (first) {
-		int nr = compound ? hpage_nr_pages(page) : 1;
+		int nr = compound ? thp_nr_pages(page) : 1;
 		/*
 		 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
 		 * these counters are not modified in interrupt context, and
@@ -1169,7 +1169,7 @@ void do_page_add_anon_rmap(struct page *
 void page_add_new_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address, bool compound)
 {
-	int nr = compound ? hpage_nr_pages(page) : 1;
+	int nr = compound ? thp_nr_pages(page) : 1;
 
 	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
 	__SetPageSwapBacked(page);
@@ -1860,7 +1860,7 @@ static void rmap_walk_anon(struct page *
 		return;
 
 	pgoff_start = page_to_pgoff(page);
-	pgoff_end = pgoff_start + hpage_nr_pages(page) - 1;
+	pgoff_end = pgoff_start + thp_nr_pages(page) - 1;
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
 			pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
@@ -1913,7 +1913,7 @@ static void rmap_walk_file(struct page *
 		return;
 
 	pgoff_start = page_to_pgoff(page);
-	pgoff_end = pgoff_start + hpage_nr_pages(page) - 1;
+	pgoff_end = pgoff_start + thp_nr_pages(page) - 1;
 	if (!locked)
 		i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap,
--- a/mm/swap.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/swap.c
@@ -241,7 +241,7 @@ static void pagevec_move_tail_fn(struct
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		ClearPageActive(page);
 		add_page_to_lru_list_tail(page, lruvec, page_lru(page));
-		(*pgmoved) += hpage_nr_pages(page);
+		(*pgmoved) += thp_nr_pages(page);
 	}
 }
 
@@ -312,7 +312,7 @@ void lru_note_cost(struct lruvec *lruvec
 void lru_note_cost_page(struct page *page)
 {
 	lru_note_cost(mem_cgroup_page_lruvec(page, page_pgdat(page)),
-		      page_is_file_lru(page), hpage_nr_pages(page));
+		      page_is_file_lru(page), thp_nr_pages(page));
 }
 
 static void __activate_page(struct page *page, struct lruvec *lruvec,
@@ -320,7 +320,7 @@ static void __activate_page(struct page
 {
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int lru = page_lru_base_type(page);
-		int nr_pages = hpage_nr_pages(page);
+		int nr_pages = thp_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec, lru);
 		SetPageActive(page);
@@ -499,7 +499,7 @@ void lru_cache_add_active_or_unevictable
 		 * lock is held(spinlock), which implies preemption disabled.
 		 */
 		__mod_zone_page_state(page_zone(page), NR_MLOCK,
-				    hpage_nr_pages(page));
+				    thp_nr_pages(page));
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 	}
 	lru_cache_add(page);
@@ -531,7 +531,7 @@ static void lru_deactivate_file_fn(struc
 {
 	int lru;
 	bool active;
-	int nr_pages = hpage_nr_pages(page);
+	int nr_pages = thp_nr_pages(page);
 
 	if (!PageLRU(page))
 		return;
@@ -579,7 +579,7 @@ static void lru_deactivate_fn(struct pag
 {
 	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
 		int lru = page_lru_base_type(page);
-		int nr_pages = hpage_nr_pages(page);
+		int nr_pages = thp_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
 		ClearPageActive(page);
@@ -598,7 +598,7 @@ static void lru_lazyfree_fn(struct page
 	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
 	    !PageSwapCache(page) && !PageUnevictable(page)) {
 		bool active = PageActive(page);
-		int nr_pages = hpage_nr_pages(page);
+		int nr_pages = thp_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec,
 				       LRU_INACTIVE_ANON + active);
@@ -971,7 +971,7 @@ static void __pagevec_lru_add_fn(struct
 {
 	enum lru_list lru;
 	int was_unevictable = TestClearPageUnevictable(page);
-	int nr_pages = hpage_nr_pages(page);
+	int nr_pages = thp_nr_pages(page);
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
--- a/mm/swapfile.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/swapfile.c
@@ -1368,7 +1368,7 @@ void put_swap_page(struct page *page, sw
 	unsigned char *map;
 	unsigned int i, free_entries = 0;
 	unsigned char val;
-	int size = swap_entry_size(hpage_nr_pages(page));
+	int size = swap_entry_size(thp_nr_pages(page));
 
 	si = _swap_info_get(entry);
 	if (!si)
--- a/mm/swap_state.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/swap_state.c
@@ -115,7 +115,7 @@ int add_to_swap_cache(struct page *page,
 	struct address_space *address_space = swap_address_space(entry);
 	pgoff_t idx = swp_offset(entry);
 	XA_STATE_ORDER(xas, &address_space->i_pages, idx, compound_order(page));
-	unsigned long i, nr = hpage_nr_pages(page);
+	unsigned long i, nr = thp_nr_pages(page);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageSwapCache(page), page);
@@ -157,7 +157,7 @@ unlock:
 void __delete_from_swap_cache(struct page *page, swp_entry_t entry)
 {
 	struct address_space *address_space = swap_address_space(entry);
-	int i, nr = hpage_nr_pages(page);
+	int i, nr = thp_nr_pages(page);
 	pgoff_t idx = swp_offset(entry);
 	XA_STATE(xas, &address_space->i_pages, idx);
 
@@ -250,7 +250,7 @@ void delete_from_swap_cache(struct page
 	xa_unlock_irq(&address_space->i_pages);
 
 	put_swap_page(page, entry);
-	page_ref_sub(page, hpage_nr_pages(page));
+	page_ref_sub(page, thp_nr_pages(page));
 }
 
 /* 
--- a/mm/vmscan.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/vmscan.c
@@ -1355,7 +1355,7 @@ static unsigned int shrink_page_list(str
 			case PAGE_ACTIVATE:
 				goto activate_locked;
 			case PAGE_SUCCESS:
-				stat->nr_pageout += hpage_nr_pages(page);
+				stat->nr_pageout += thp_nr_pages(page);
 
 				if (PageWriteback(page))
 					goto keep;
@@ -1863,7 +1863,7 @@ static unsigned noinline_for_stack move_
 		SetPageLRU(page);
 		lru = page_lru(page);
 
-		nr_pages = hpage_nr_pages(page);
+		nr_pages = thp_nr_pages(page);
 		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
 		list_move(&page->lru, &lruvec->lists[lru]);
 
@@ -2065,7 +2065,7 @@ static void shrink_active_list(unsigned
 			 * so we ignore them here.
 			 */
 			if ((vm_flags & VM_EXEC) && page_is_file_lru(page)) {
-				nr_rotated += hpage_nr_pages(page);
+				nr_rotated += thp_nr_pages(page);
 				list_add(&page->lru, &l_active);
 				continue;
 			}
--- a/mm/workingset.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/workingset.c
@@ -262,7 +262,7 @@ void *workingset_eviction(struct page *p
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
 	lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
-	workingset_age_nonresident(lruvec, hpage_nr_pages(page));
+	workingset_age_nonresident(lruvec, thp_nr_pages(page));
 	/* XXX: target_memcg can be NULL, go through lruvec */
 	memcgid = mem_cgroup_id(lruvec_memcg(lruvec));
 	eviction = atomic_long_read(&lruvec->nonresident_age);
@@ -365,7 +365,7 @@ void workingset_refault(struct page *pag
 		goto out;
 
 	SetPageActive(page);
-	workingset_age_nonresident(lruvec, hpage_nr_pages(page));
+	workingset_age_nonresident(lruvec, thp_nr_pages(page));
 	inc_lruvec_state(lruvec, WORKINGSET_ACTIVATE);
 
 	/* Page was active prior to eviction */
@@ -402,7 +402,7 @@ void workingset_activation(struct page *
 	if (!mem_cgroup_disabled() && !memcg)
 		goto out;
 	lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
-	workingset_age_nonresident(lruvec, hpage_nr_pages(page));
+	workingset_age_nonresident(lruvec, thp_nr_pages(page));
 out:
 	rcu_read_unlock();
 }
_

Patches currently in -mm which might be from willy@infradead.org are

vmalloc-convert-to-xarray.patch
mm-store-compound_nr-as-well-as-compound_order.patch
mm-move-page-flags-include-to-top-of-file.patch
mm-add-thp_order.patch
mm-add-thp_size.patch
mm-replace-hpage_nr_pages-with-thp_nr_pages.patch
mm-add-thp_head.patch
mm-introduce-offset_in_thp.patch
