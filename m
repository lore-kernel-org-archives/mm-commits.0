From: akpm@linux-foundation.org
Subject: + thp-reintroduce-split_huge_page.patch added to -mm tree
Date: Wed, 14 Oct 2015 14:13:58 -0700
Message-ID: <561ec596.HW66zLwTbwE59kw1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbbJNVOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Oct 2015 17:14:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: reintroduce split_huge_page()
has been added to the -mm tree.  Its filename is
     thp-reintroduce-split_huge_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-reintroduce-split_huge_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-reintroduce-split_huge_page.patch

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
Subject: thp: reintroduce split_huge_page()

This patch adds implementation of split_huge_page() for new
refcountings.

Unlike previous implementation, new split_huge_page() can fail if
somebody holds GUP pin on the page. It also means that pin on page
would prevent it from bening split under you. It makes situation in
many places much cleaner.

The basic scheme of split_huge_page():

  - Check that sum of mapcounts of all subpage is equal to page_count()
    plus one (caller pin). Foll off with -EBUSY. This way we can avoid
    useless PMD-splits.

  - Freeze the page counters by splitting all PMD and setup migration
    PTEs.

  - Re-check sum of mapcounts against page_count(). Page's counts are
    stable now. -EBUSY if page is pinned.

  - Split compound page.

  - Unfreeze the page by removing migration entries.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    7 
 include/linux/pagemap.h |   13 +
 mm/huge_memory.c        |  317 ++++++++++++++++++++++++++++++++++++++
 mm/internal.h           |   26 ++-
 mm/rmap.c               |   21 --
 5 files changed, 356 insertions(+), 28 deletions(-)

diff -puN include/linux/huge_mm.h~thp-reintroduce-split_huge_page include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-reintroduce-split_huge_page
+++ a/include/linux/huge_mm.h
@@ -90,8 +90,11 @@ extern bool is_vma_temporary_stack(struc
 
 extern unsigned long transparent_hugepage_flags;
 
-#define split_huge_page_to_list(page, list) BUILD_BUG()
-#define split_huge_page(page) BUILD_BUG()
+int split_huge_page_to_list(struct page *page, struct list_head *list);
+static inline int split_huge_page(struct page *page)
+{
+	return split_huge_page_to_list(page, NULL);
+}
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address);
diff -puN include/linux/pagemap.h~thp-reintroduce-split_huge_page include/linux/pagemap.h
--- a/include/linux/pagemap.h~thp-reintroduce-split_huge_page
+++ a/include/linux/pagemap.h
@@ -394,10 +394,21 @@ static inline struct page *read_mapping_
  */
 static inline pgoff_t page_to_pgoff(struct page *page)
 {
+	pgoff_t pgoff;
+
 	if (unlikely(PageHeadHuge(page)))
 		return page->index << compound_order(page);
-	else
+
+	if (likely(!PageTransTail(page)))
 		return page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+
+	/*
+	 *  We don't initialize ->index for tail pages: calculate based on
+	 *  head page
+	 */
+	pgoff = compound_head(page)->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff += page - compound_head(page);
+	return pgoff;
 }
 
 /*
diff -puN mm/huge_memory.c~thp-reintroduce-split_huge_page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-reintroduce-split_huge_page
+++ a/mm/huge_memory.c
@@ -2939,3 +2939,320 @@ void vma_adjust_trans_huge(struct vm_are
 			split_huge_pmd_address(next, nstart);
 	}
 }
+
+static void freeze_page_vma(struct vm_area_struct *vma, struct page *page,
+		unsigned long address)
+{
+	spinlock_t *ptl;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	int i;
+
+	pgd = pgd_offset(vma->vm_mm, address);
+	if (!pgd_present(*pgd))
+		return;
+	pud = pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		return;
+	pmd = pmd_offset(pud, address);
+	ptl = pmd_lock(vma->vm_mm, pmd);
+	if (!pmd_present(*pmd)) {
+		spin_unlock(ptl);
+		return;
+	}
+	if (pmd_trans_huge(*pmd)) {
+		if (page == pmd_page(*pmd))
+			__split_huge_pmd_locked(vma, pmd, address, true);
+		spin_unlock(ptl);
+		return;
+	}
+	spin_unlock(ptl);
+
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, address, &ptl);
+	for (i = 0; i < HPAGE_PMD_NR; i++, address += PAGE_SIZE, page++) {
+		pte_t entry, swp_pte;
+		swp_entry_t swp_entry;
+
+		if (!pte_present(pte[i]))
+			continue;
+		if (page_to_pfn(page) != pte_pfn(pte[i]))
+			continue;
+		flush_cache_page(vma, address, page_to_pfn(page));
+		entry = ptep_clear_flush(vma, address, pte + i);
+		swp_entry = make_migration_entry(page, pte_write(entry));
+		swp_pte = swp_entry_to_pte(swp_entry);
+		if (pte_soft_dirty(entry))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		set_pte_at(vma->vm_mm, address, pte + i, swp_pte);
+	}
+	pte_unmap_unlock(pte, ptl);
+}
+
+static void freeze_page(struct anon_vma *anon_vma, struct page *page)
+{
+	struct anon_vma_chain *avc;
+	pgoff_t pgoff = page_to_pgoff(page);
+
+	VM_BUG_ON_PAGE(!PageHead(page), page);
+
+	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff,
+			pgoff + HPAGE_PMD_NR - 1) {
+		unsigned long haddr;
+
+		haddr = __vma_address(page, avc->vma) & HPAGE_PMD_MASK;
+		mmu_notifier_invalidate_range_start(avc->vma->vm_mm,
+				haddr, haddr + HPAGE_PMD_SIZE);
+		freeze_page_vma(avc->vma, page, haddr);
+		mmu_notifier_invalidate_range_end(avc->vma->vm_mm,
+				haddr, haddr + HPAGE_PMD_SIZE);
+	}
+}
+
+static void unfreeze_page_vma(struct vm_area_struct *vma, struct page *page,
+		unsigned long address)
+{
+	spinlock_t *ptl;
+	pmd_t *pmd;
+	pte_t *pte, entry;
+	swp_entry_t swp_entry;
+	int i;
+
+	pmd = mm_find_pmd(vma->vm_mm, address);
+	if (!pmd)
+		return;
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, address, &ptl);
+	for (i = 0; i < HPAGE_PMD_NR; i++, address += PAGE_SIZE, page++) {
+		if (!page_mapped(page))
+			continue;
+		if (!is_swap_pte(pte[i]))
+			continue;
+
+		swp_entry = pte_to_swp_entry(pte[i]);
+		if (!is_migration_entry(swp_entry))
+			continue;
+		if (migration_entry_to_page(swp_entry) != page)
+			continue;
+
+		entry = pte_mkold(mk_pte(page, vma->vm_page_prot));
+		if (is_write_migration_entry(swp_entry))
+			entry = maybe_mkwrite(entry, vma);
+
+		flush_dcache_page(page);
+		set_pte_at(vma->vm_mm, address, pte + i, entry);
+
+		/* No need to invalidate - it was non-present before */
+		update_mmu_cache(vma, address, pte + i);
+	}
+	pte_unmap_unlock(pte, ptl);
+}
+
+static void unfreeze_page(struct anon_vma *anon_vma, struct page *page)
+{
+	struct anon_vma_chain *avc;
+	pgoff_t pgoff = page_to_pgoff(page);
+
+	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
+			pgoff, pgoff + HPAGE_PMD_NR - 1) {
+		unsigned long address = __vma_address(page, avc->vma);
+
+		mmu_notifier_invalidate_range_start(avc->vma->vm_mm,
+				address, address + HPAGE_PMD_SIZE);
+		unfreeze_page_vma(avc->vma, page, address);
+		mmu_notifier_invalidate_range_end(avc->vma->vm_mm,
+				address, address + HPAGE_PMD_SIZE);
+	}
+}
+
+static int total_mapcount(struct page *page)
+{
+	int i, ret;
+
+	ret = compound_mapcount(page);
+	for (i = 0; i < HPAGE_PMD_NR; i++)
+		ret += atomic_read(&page[i]._mapcount) + 1;
+
+	if (PageDoubleMap(page))
+		ret -= HPAGE_PMD_NR;
+
+	return ret;
+}
+
+static int __split_huge_page_tail(struct page *head, int tail,
+		struct lruvec *lruvec, struct list_head *list)
+{
+	int mapcount;
+	struct page *page_tail = head + tail;
+
+	mapcount = atomic_read(&page_tail->_mapcount) + 1;
+	VM_BUG_ON_PAGE(atomic_read(&page_tail->_count) != 0, page_tail);
+
+	/*
+	 * tail_page->_count is zero and not changing from under us. But
+	 * get_page_unless_zero() may be running from under us on the
+	 * tail_page. If we used atomic_set() below instead of atomic_add(), we
+	 * would then run atomic_set() concurrently with
+	 * get_page_unless_zero(), and atomic_set() is implemented in C not
+	 * using locked ops. spin_unlock on x86 sometime uses locked ops
+	 * because of PPro errata 66, 92, so unless somebody can guarantee
+	 * atomic_set() here would be safe on all archs (and not only on x86),
+	 * it's safer to use atomic_add().
+	 */
+	atomic_add(mapcount + 1, &page_tail->_count);
+
+	/* after clearing PageTail the gup refcount can be released */
+	smp_mb__after_atomic();
+
+	page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	page_tail->flags |= (head->flags &
+			((1L << PG_referenced) |
+			 (1L << PG_swapbacked) |
+			 (1L << PG_mlocked) |
+			 (1L << PG_uptodate) |
+			 (1L << PG_active) |
+			 (1L << PG_locked) |
+			 (1L << PG_unevictable)));
+	page_tail->flags |= (1L << PG_dirty);
+
+	clear_compound_head(page_tail);
+
+	if (page_is_young(head))
+		set_page_young(page_tail);
+	if (page_is_idle(head))
+		set_page_idle(page_tail);
+
+	/* ->mapping in first tail page is compound_mapcount */
+	VM_BUG_ON_PAGE(tail != 1 && page_tail->mapping != TAIL_MAPPING,
+			page_tail);
+	page_tail->mapping = head->mapping;
+
+	page_tail->index = head->index + tail;
+	page_cpupid_xchg_last(page_tail, page_cpupid_last(head));
+	lru_add_page_tail(head, page_tail, lruvec, list);
+
+	return mapcount;
+}
+
+static void __split_huge_page(struct page *page, struct list_head *list)
+{
+	struct page *head = compound_head(page);
+	struct zone *zone = page_zone(head);
+	struct lruvec *lruvec;
+	int i, tail_mapcount;
+
+	/* prevent PageLRU to go away from under us, and freeze lru stats */
+	spin_lock_irq(&zone->lru_lock);
+	lruvec = mem_cgroup_page_lruvec(head, zone);
+
+	/* complete memcg works before add pages to LRU */
+	mem_cgroup_split_huge_fixup(head);
+
+	tail_mapcount = 0;
+	for (i = HPAGE_PMD_NR - 1; i >= 1; i--)
+		tail_mapcount += __split_huge_page_tail(head, i, lruvec, list);
+	atomic_sub(tail_mapcount, &head->_count);
+
+	ClearPageCompound(head);
+	spin_unlock_irq(&zone->lru_lock);
+
+	unfreeze_page(page_anon_vma(head), head);
+
+	for (i = 0; i < HPAGE_PMD_NR; i++) {
+		struct page *subpage = head + i;
+		if (subpage == page)
+			continue;
+		unlock_page(subpage);
+
+		/*
+		 * Subpages may be freed if there wasn't any mapping
+		 * like if add_to_swap() is running on a lru page that
+		 * had its mapping zapped. And freeing these pages
+		 * requires taking the lru_lock so we do the put_page
+		 * of the tail pages after the split is complete.
+		 */
+		put_page(subpage);
+	}
+}
+
+/*
+ * This function splits huge page into normal pages. @page can point to any
+ * subpage of huge page to split. Split doesn't change the position of @page.
+ *
+ * Only caller must hold pin on the @page, otherwise split fails with -EBUSY.
+ * The huge page must be locked.
+ *
+ * If @list is null, tail pages will be added to LRU list, otherwise, to @list.
+ *
+ * Both head page and tail pages will inherit mapping, flags, and so on from
+ * the hugepage.
+ *
+ * GUP pin and PG_locked transferred to @page. Rest subpages can be freed if
+ * they are not mapped.
+ *
+ * Returns 0 if the hugepage is split successfully.
+ * Returns -EBUSY if the page is pinned or if anon_vma disappeared from under
+ * us.
+ */
+int split_huge_page_to_list(struct page *page, struct list_head *list)
+{
+	struct page *head = compound_head(page);
+	struct anon_vma *anon_vma;
+	int count, mapcount, ret;
+
+	VM_BUG_ON_PAGE(is_huge_zero_page(page), page);
+	VM_BUG_ON_PAGE(!PageAnon(page), page);
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
+	VM_BUG_ON_PAGE(!PageCompound(page), page);
+
+	/*
+	 * The caller does not necessarily hold an mmap_sem that would prevent
+	 * the anon_vma disappearing so we first we take a reference to it
+	 * and then lock the anon_vma for write. This is similar to
+	 * page_lock_anon_vma_read except the write lock is taken to serialise
+	 * against parallel split or collapse operations.
+	 */
+	anon_vma = page_get_anon_vma(head);
+	if (!anon_vma) {
+		ret = -EBUSY;
+		goto out;
+	}
+	anon_vma_lock_write(anon_vma);
+
+	/*
+	 * Racy check if we can split the page, before freeze_page() will
+	 * split PMDs
+	 */
+	if (total_mapcount(head) != page_count(head) - 1) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	freeze_page(anon_vma, head);
+	VM_BUG_ON_PAGE(compound_mapcount(head), head);
+
+	count = page_count(head);
+	mapcount = total_mapcount(head);
+	if (mapcount == count - 1) {
+		__split_huge_page(page, list);
+		ret = 0;
+	} else if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount > count - 1) {
+		pr_alert("total_mapcount: %u, page_count(): %u\n",
+				mapcount, count);
+		if (PageTail(page))
+			dump_page(head, NULL);
+		dump_page(page, "total_mapcount(head) > page_count(head) - 1");
+		BUG();
+	} else {
+		unfreeze_page(anon_vma, head);
+		ret = -EBUSY;
+	}
+
+out_unlock:
+	anon_vma_unlock_write(anon_vma);
+	put_anon_vma(anon_vma);
+out:
+	count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
+	return ret;
+}
diff -puN mm/internal.h~thp-reintroduce-split_huge_page mm/internal.h
--- a/mm/internal.h~thp-reintroduce-split_huge_page
+++ a/mm/internal.h
@@ -13,6 +13,7 @@
 
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/pagemap.h>
 
 extern int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *page_table, pmd_t *pmd,
@@ -270,10 +271,27 @@ static inline void mlock_migrate_page(st
 
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-extern unsigned long vma_address(struct page *page,
-				 struct vm_area_struct *vma);
-#endif
+/*
+ * At what user virtual address is page expected in @vma?
+ */
+static inline unsigned long
+__vma_address(struct page *page, struct vm_area_struct *vma)
+{
+	pgoff_t pgoff = page_to_pgoff(page);
+	return vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+}
+
+static inline unsigned long
+vma_address(struct page *page, struct vm_area_struct *vma)
+{
+	unsigned long address = __vma_address(page, vma);
+
+	/* page should be within @vma mapping range */
+	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
+
+	return address;
+}
+
 #else /* !CONFIG_MMU */
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
diff -puN mm/rmap.c~thp-reintroduce-split_huge_page mm/rmap.c
--- a/mm/rmap.c~thp-reintroduce-split_huge_page
+++ a/mm/rmap.c
@@ -565,27 +565,6 @@ void page_unlock_anon_vma_read(struct an
 	anon_vma_unlock_read(anon_vma);
 }
 
-/*
- * At what user virtual address is page expected in @vma?
- */
-static inline unsigned long
-__vma_address(struct page *page, struct vm_area_struct *vma)
-{
-	pgoff_t pgoff = page_to_pgoff(page);
-	return vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
-}
-
-inline unsigned long
-vma_address(struct page *page, struct vm_area_struct *vma)
-{
-	unsigned long address = __vma_address(page, vma);
-
-	/* page should be within @vma mapping range */
-	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
-
-	return address;
-}
-
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 static void percpu_flush_tlb_batch_pages(void *data)
 {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-make-compound_head-robust-fix.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-support-madvisemadv_free-fix-3.patch

