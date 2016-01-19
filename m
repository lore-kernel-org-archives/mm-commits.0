From: akpm@linux-foundation.org
Subject: [merged] thp-reintroduce-split_huge_page.patch removed from -mm
 tree
Date: Tue, 19 Jan 2016 12:02:55 -0800
Message-ID: <569e966f.D8q/m7ksn2nOudqv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbcASUC4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: reintroduce split_huge_page()
has been removed from the -mm tree.  Its filename was
     thp-reintroduce-split_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 mm/huge_memory.c        |  374 +++++++++++++++++++++++++++++++++++++-
 mm/internal.h           |   26 ++
 mm/rmap.c               |   40 ----
 5 files changed, 415 insertions(+), 45 deletions(-)

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
@@ -16,6 +16,7 @@
 #include <linux/swap.h>
 #include <linux/shrinker.h>
 #include <linux/mm_inline.h>
+#include <linux/swapops.h>
 #include <linux/dax.h>
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
@@ -2726,9 +2727,6 @@ static void __split_huge_pmd_locked(stru
 	write = pmd_write(*pmd);
 	young = pmd_young(*pmd);
 
-	/* leave pmd empty until pte is filled */
-	pmdp_huge_clear_flush_notify(vma, haddr, pmd);
-
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pmd_populate(mm, &_pmd, pgtable);
 
@@ -2778,7 +2776,36 @@ static void __split_huge_pmd_locked(stru
 	}
 
 	smp_wmb(); /* make pte visible before pmd */
+	/*
+	 * Up to this point the pmd is present and huge and userland has the
+	 * whole access to the hugepage during the split (which happens in
+	 * place). If we overwrite the pmd with the not-huge version pointing
+	 * to the pte here (which of course we could if all CPUs were bug
+	 * free), userland could trigger a small page size TLB miss on the
+	 * small sized TLB while the hugepage TLB entry is still established in
+	 * the huge TLB. Some CPU doesn't like that.
+	 * See http://support.amd.com/us/Processor_TechDocs/41322.pdf, Erratum
+	 * 383 on page 93. Intel should be safe but is also warns that it's
+	 * only safe if the permission and cache attributes of the two entries
+	 * loaded in the two TLB is identical (which should be the case here).
+	 * But it is generally safer to never allow small and huge TLB entries
+	 * for the same virtual address to be loaded simultaneously. So instead
+	 * of doing "pmd_populate(); flush_pmd_tlb_range();" we first mark the
+	 * current pmd notpresent (atomically because here the pmd_trans_huge
+	 * and pmd_trans_splitting must remain set at all times on the pmd
+	 * until the split is complete for this pmd), then we flush the SMP TLB
+	 * and finally we write the non-huge version of the pmd entry with
+	 * pmd_populate.
+	 */
+	pmdp_invalidate(vma, haddr, pmd);
 	pmd_populate(mm, pmd, pgtable);
+
+	if (freeze) {
+		for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
+			page_remove_rmap(page + i, false);
+			put_page(page + i);
+		}
+	}
 }
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
@@ -2863,3 +2890,344 @@ void vma_adjust_trans_huge(struct vm_are
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
+	int i, nr = HPAGE_PMD_NR;
+
+	/* Skip pages which doesn't belong to the VMA */
+	if (address < vma->vm_start) {
+		int off = (vma->vm_start - address) >> PAGE_SHIFT;
+		page += off;
+		nr -= off;
+		address = vma->vm_start;
+	}
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
+	for (i = 0; i < nr; i++, address += PAGE_SIZE, page++) {
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
+		page_remove_rmap(page, false);
+		put_page(page);
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
+	int i, nr = HPAGE_PMD_NR;
+
+	/* Skip pages which doesn't belong to the VMA */
+	if (address < vma->vm_start) {
+		int off = (vma->vm_start - address) >> PAGE_SHIFT;
+		page += off;
+		nr -= off;
+		address = vma->vm_start;
+	}
+
+	pmd = mm_find_pmd(vma->vm_mm, address);
+	if (!pmd)
+		return;
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, address, &ptl);
+	for (i = 0; i < nr; i++, address += PAGE_SIZE, page++) {
+		if (!is_swap_pte(pte[i]))
+			continue;
+
+		swp_entry = pte_to_swp_entry(pte[i]);
+		if (!is_migration_entry(swp_entry))
+			continue;
+		if (migration_entry_to_page(swp_entry) != page)
+			continue;
+
+		get_page(page);
+		page_add_anon_rmap(page, vma, address, false);
+
+		entry = pte_mkold(mk_pte(page, vma->vm_page_prot));
+		entry = pte_mkdirty(entry);
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
+	/*
+	 * After clearing PageTail the gup refcount can be released.
+	 * Page flags also must be visible before we make the page non-compound.
+	 */
+	smp_wmb();
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
 
 /*
  * The set of flags that only affect watermark checking and reclaim
@@ -265,10 +266,27 @@ static inline void mlock_migrate_page(st
 
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
@@ -567,27 +567,6 @@ void page_unlock_anon_vma_read(struct an
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
@@ -1155,20 +1134,12 @@ void do_page_add_anon_rmap(struct page *
 	bool compound = flags & RMAP_COMPOUND;
 	bool first;
 
-	if (PageTransCompound(page)) {
+	if (compound) {
+		atomic_t *mapcount;
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
-		if (compound) {
-			atomic_t *mapcount;
-
-			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
-			mapcount = compound_mapcount_ptr(page);
-			first = atomic_inc_and_test(mapcount);
-		} else {
-			/* Anon THP always mapped first with PMD */
-			first = 0;
-			VM_BUG_ON_PAGE(!page_mapcount(page), page);
-			atomic_inc(&page->_mapcount);
-		}
+		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
+		mapcount = compound_mapcount_ptr(page);
+		first = atomic_inc_and_test(mapcount);
 	} else {
 		first = atomic_inc_and_test(&page->_mapcount);
 	}
@@ -1182,7 +1153,6 @@ void do_page_add_anon_rmap(struct page *
 		 * disabled.
 		 */
 		if (compound) {
-			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 			__inc_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
 		}
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

