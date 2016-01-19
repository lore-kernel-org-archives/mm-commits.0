From: akpm@linux-foundation.org
Subject: [merged] rmap-add-argument-to-charge-compound-page.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:01:20 -0800
Message-ID: <569e9610.C+juYFg37NDUbFnC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033AbcASUBV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:01:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: add argument to charge compound page
has been removed from the -mm tree.  Its filename was
     rmap-add-argument-to-charge-compound-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: rmap: add argument to charge compound page

We're going to allow mapping of individual 4k pages of THP compound page. 
It means we cannot rely on PageTransHuge() check to decide if map/unmap
small page or THP.

The patch adds new argument to rmap functions to indicate whether we want
to operate on whole compound page or only the small page.

[n-horiguchi@ah.jp.nec.com: fix mapcount mismatch in hugepage migration]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h    |   12 +++++++--
 kernel/events/uprobes.c |    4 +--
 mm/huge_memory.c        |   16 ++++++------
 mm/hugetlb.c            |    4 +--
 mm/ksm.c                |    4 +--
 mm/memory.c             |   14 +++++------
 mm/migrate.c            |    8 +++---
 mm/rmap.c               |   48 ++++++++++++++++++++++++--------------
 mm/swapfile.c           |    4 +--
 mm/userfaultfd.c        |    2 -
 10 files changed, 68 insertions(+), 48 deletions(-)

diff -puN include/linux/rmap.h~rmap-add-argument-to-charge-compound-page include/linux/rmap.h
--- a/include/linux/rmap.h~rmap-add-argument-to-charge-compound-page
+++ a/include/linux/rmap.h
@@ -161,16 +161,22 @@ static inline void anon_vma_merge(struct
 
 struct anon_vma *page_get_anon_vma(struct page *page);
 
+/* bitflags for do_page_add_anon_rmap() */
+#define RMAP_EXCLUSIVE 0x01
+#define RMAP_COMPOUND 0x02
+
 /*
  * rmap interfaces called when adding or removing pte of page
  */
 void page_move_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
-void page_add_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
+void page_add_anon_rmap(struct page *, struct vm_area_struct *,
+		unsigned long, bool);
 void do_page_add_anon_rmap(struct page *, struct vm_area_struct *,
 			   unsigned long, int);
-void page_add_new_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
+void page_add_new_anon_rmap(struct page *, struct vm_area_struct *,
+		unsigned long, bool);
 void page_add_file_rmap(struct page *);
-void page_remove_rmap(struct page *);
+void page_remove_rmap(struct page *, bool);
 
 void hugepage_add_anon_rmap(struct page *, struct vm_area_struct *,
 			    unsigned long);
diff -puN kernel/events/uprobes.c~rmap-add-argument-to-charge-compound-page kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~rmap-add-argument-to-charge-compound-page
+++ a/kernel/events/uprobes.c
@@ -175,7 +175,7 @@ static int __replace_page(struct vm_area
 		goto unlock;
 
 	get_page(kpage);
-	page_add_new_anon_rmap(kpage, vma, addr);
+	page_add_new_anon_rmap(kpage, vma, addr, false);
 	mem_cgroup_commit_charge(kpage, memcg, false);
 	lru_cache_add_active_or_unevictable(kpage, vma);
 
@@ -188,7 +188,7 @@ static int __replace_page(struct vm_area
 	ptep_clear_flush_notify(vma, addr, ptep);
 	set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
 
-	page_remove_rmap(page);
+	page_remove_rmap(page, false);
 	if (!page_mapped(page))
 		try_to_free_swap(page);
 	pte_unmap_unlock(ptep, ptl);
diff -puN mm/huge_memory.c~rmap-add-argument-to-charge-compound-page mm/huge_memory.c
--- a/mm/huge_memory.c~rmap-add-argument-to-charge-compound-page
+++ a/mm/huge_memory.c
@@ -797,7 +797,7 @@ static int __do_huge_pmd_anonymous_page(
 
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		page_add_new_anon_rmap(page, vma, haddr);
+		page_add_new_anon_rmap(page, vma, haddr, true);
 		mem_cgroup_commit_charge(page, memcg, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
@@ -1139,7 +1139,7 @@ static int do_huge_pmd_wp_page_fallback(
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		memcg = (void *)page_private(pages[i]);
 		set_page_private(pages[i], 0);
-		page_add_new_anon_rmap(pages[i], vma, haddr);
+		page_add_new_anon_rmap(pages[i], vma, haddr, false);
 		mem_cgroup_commit_charge(pages[i], memcg, false);
 		lru_cache_add_active_or_unevictable(pages[i], vma);
 		pte = pte_offset_map(&_pmd, haddr);
@@ -1151,7 +1151,7 @@ static int do_huge_pmd_wp_page_fallback(
 
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
-	page_remove_rmap(page);
+	page_remove_rmap(page, true);
 	spin_unlock(ptl);
 
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
@@ -1271,7 +1271,7 @@ alloc:
 		entry = mk_huge_pmd(new_page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		pmdp_huge_clear_flush_notify(vma, haddr, pmd);
-		page_add_new_anon_rmap(new_page, vma, haddr);
+		page_add_new_anon_rmap(new_page, vma, haddr, true);
 		mem_cgroup_commit_charge(new_page, memcg, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
 		set_pmd_at(mm, haddr, pmd, entry);
@@ -1281,7 +1281,7 @@ alloc:
 			put_huge_zero_page();
 		} else {
 			VM_BUG_ON_PAGE(!PageHead(page), page);
-			page_remove_rmap(page);
+			page_remove_rmap(page, true);
 			put_page(page);
 		}
 		ret |= VM_FAULT_WRITE;
@@ -1508,7 +1508,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		put_huge_zero_page();
 	} else {
 		struct page *page = pmd_page(orig_pmd);
-		page_remove_rmap(page);
+		page_remove_rmap(page, true);
 		VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
 		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 		VM_BUG_ON_PAGE(!PageHead(page), page);
@@ -2371,7 +2371,7 @@ static void __collapse_huge_page_copy(pt
 			 * superfluous.
 			 */
 			pte_clear(vma->vm_mm, address, _pte);
-			page_remove_rmap(src_page);
+			page_remove_rmap(src_page, false);
 			spin_unlock(ptl);
 			free_page_and_swap_cache(src_page);
 		}
@@ -2682,7 +2682,7 @@ static void collapse_huge_page(struct mm
 
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
-	page_add_new_anon_rmap(new_page, vma, address);
+	page_add_new_anon_rmap(new_page, vma, address, true);
 	mem_cgroup_commit_charge(new_page, memcg, false);
 	lru_cache_add_active_or_unevictable(new_page, vma);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
diff -puN mm/hugetlb.c~rmap-add-argument-to-charge-compound-page mm/hugetlb.c
--- a/mm/hugetlb.c~rmap-add-argument-to-charge-compound-page
+++ a/mm/hugetlb.c
@@ -3186,7 +3186,7 @@ again:
 			set_page_dirty(page);
 
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
-		page_remove_rmap(page);
+		page_remove_rmap(page, true);
 		force_flush = !__tlb_remove_page(tlb, page);
 		if (force_flush) {
 			address += sz;
@@ -3415,7 +3415,7 @@ retry_avoidcopy:
 		mmu_notifier_invalidate_range(mm, mmun_start, mmun_end);
 		set_huge_pte_at(mm, address, ptep,
 				make_huge_pte(vma, new_page, 1));
-		page_remove_rmap(old_page);
+		page_remove_rmap(old_page, true);
 		hugepage_add_new_anon_rmap(new_page, vma, address);
 		/* Make the old page be freed below */
 		new_page = old_page;
diff -puN mm/ksm.c~rmap-add-argument-to-charge-compound-page mm/ksm.c
--- a/mm/ksm.c~rmap-add-argument-to-charge-compound-page
+++ a/mm/ksm.c
@@ -956,13 +956,13 @@ static int replace_page(struct vm_area_s
 	}
 
 	get_page(kpage);
-	page_add_anon_rmap(kpage, vma, addr);
+	page_add_anon_rmap(kpage, vma, addr, false);
 
 	flush_cache_page(vma, addr, pte_pfn(*ptep));
 	ptep_clear_flush_notify(vma, addr, ptep);
 	set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
 
-	page_remove_rmap(page);
+	page_remove_rmap(page, false);
 	if (!page_mapped(page))
 		try_to_free_swap(page);
 	put_page(page);
diff -puN mm/memory.c~rmap-add-argument-to-charge-compound-page mm/memory.c
--- a/mm/memory.c~rmap-add-argument-to-charge-compound-page
+++ a/mm/memory.c
@@ -1118,7 +1118,7 @@ again:
 					mark_page_accessed(page);
 			}
 			rss[mm_counter(page)]--;
-			page_remove_rmap(page);
+			page_remove_rmap(page, false);
 			if (unlikely(page_mapcount(page) < 0))
 				print_bad_pte(vma, addr, ptent, page);
 			if (unlikely(!__tlb_remove_page(tlb, page))) {
@@ -2118,7 +2118,7 @@ static int wp_page_copy(struct mm_struct
 		 * thread doing COW.
 		 */
 		ptep_clear_flush_notify(vma, address, page_table);
-		page_add_new_anon_rmap(new_page, vma, address);
+		page_add_new_anon_rmap(new_page, vma, address, false);
 		mem_cgroup_commit_charge(new_page, memcg, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
 		/*
@@ -2151,7 +2151,7 @@ static int wp_page_copy(struct mm_struct
 			 * mapcount is visible. So transitively, TLBs to
 			 * old page will be flushed before it can be reused.
 			 */
-			page_remove_rmap(old_page);
+			page_remove_rmap(old_page, false);
 		}
 
 		/* Free the old page.. */
@@ -2567,7 +2567,7 @@ static int do_swap_page(struct mm_struct
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 		flags &= ~FAULT_FLAG_WRITE;
 		ret |= VM_FAULT_WRITE;
-		exclusive = 1;
+		exclusive = RMAP_EXCLUSIVE;
 	}
 	flush_icache_page(vma, page);
 	if (pte_swp_soft_dirty(orig_pte))
@@ -2577,7 +2577,7 @@ static int do_swap_page(struct mm_struct
 		do_page_add_anon_rmap(page, vma, address, exclusive);
 		mem_cgroup_commit_charge(page, memcg, true);
 	} else { /* ksm created a completely new copy */
-		page_add_new_anon_rmap(page, vma, address);
+		page_add_new_anon_rmap(page, vma, address, false);
 		mem_cgroup_commit_charge(page, memcg, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	}
@@ -2735,7 +2735,7 @@ static int do_anonymous_page(struct mm_s
 	}
 
 	inc_mm_counter_fast(mm, MM_ANONPAGES);
-	page_add_new_anon_rmap(page, vma, address);
+	page_add_new_anon_rmap(page, vma, address, false);
 	mem_cgroup_commit_charge(page, memcg, false);
 	lru_cache_add_active_or_unevictable(page, vma);
 setpte:
@@ -2824,7 +2824,7 @@ void do_set_pte(struct vm_area_struct *v
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 	if (anon) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
-		page_add_new_anon_rmap(page, vma, address);
+		page_add_new_anon_rmap(page, vma, address, false);
 	} else {
 		inc_mm_counter_fast(vma->vm_mm, mm_counter_file(page));
 		page_add_file_rmap(page);
diff -puN mm/migrate.c~rmap-add-argument-to-charge-compound-page mm/migrate.c
--- a/mm/migrate.c~rmap-add-argument-to-charge-compound-page
+++ a/mm/migrate.c
@@ -167,7 +167,7 @@ static int remove_migration_pte(struct p
 		else
 			page_dup_rmap(new);
 	} else if (PageAnon(new))
-		page_add_anon_rmap(new, vma, addr);
+		page_add_anon_rmap(new, vma, addr, false);
 	else
 		page_add_file_rmap(new);
 
@@ -1815,7 +1815,7 @@ fail_putback:
 	 * guarantee the copy is visible before the pagetable update.
 	 */
 	flush_cache_range(vma, mmun_start, mmun_end);
-	page_add_anon_rmap(new_page, vma, mmun_start);
+	page_add_anon_rmap(new_page, vma, mmun_start, true);
 	pmdp_huge_clear_flush_notify(vma, mmun_start, pmd);
 	set_pmd_at(mm, mmun_start, pmd, entry);
 	flush_tlb_range(vma, mmun_start, mmun_end);
@@ -1826,14 +1826,14 @@ fail_putback:
 		flush_tlb_range(vma, mmun_start, mmun_end);
 		mmu_notifier_invalidate_range(mm, mmun_start, mmun_end);
 		update_mmu_cache_pmd(vma, address, &entry);
-		page_remove_rmap(new_page);
+		page_remove_rmap(new_page, true);
 		goto fail_putback;
 	}
 
 	mlock_migrate_page(new_page, page);
 	set_page_memcg(new_page, page_memcg(page));
 	set_page_memcg(page, NULL);
-	page_remove_rmap(page);
+	page_remove_rmap(page, true);
 
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
diff -puN mm/rmap.c~rmap-add-argument-to-charge-compound-page mm/rmap.c
--- a/mm/rmap.c~rmap-add-argument-to-charge-compound-page
+++ a/mm/rmap.c
@@ -1133,6 +1133,7 @@ static void __page_check_anon_rmap(struc
  * @page:	the page to add the mapping to
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
+ * @compound:	charge the page as compound or small page
  *
  * The caller needs to hold the pte lock, and the page must be locked in
  * the anon_vma case: to serialize mapping,index checking after setting,
@@ -1140,9 +1141,9 @@ static void __page_check_anon_rmap(struc
  * (but PageKsm is never downgraded to PageAnon).
  */
 void page_add_anon_rmap(struct page *page,
-	struct vm_area_struct *vma, unsigned long address)
+	struct vm_area_struct *vma, unsigned long address, bool compound)
 {
-	do_page_add_anon_rmap(page, vma, address, 0);
+	do_page_add_anon_rmap(page, vma, address, compound ? RMAP_COMPOUND : 0);
 }
 
 /*
@@ -1151,21 +1152,24 @@ void page_add_anon_rmap(struct page *pag
  * Everybody else should continue to use page_add_anon_rmap above.
  */
 void do_page_add_anon_rmap(struct page *page,
-	struct vm_area_struct *vma, unsigned long address, int exclusive)
+	struct vm_area_struct *vma, unsigned long address, int flags)
 {
 	int first = atomic_inc_and_test(&page->_mapcount);
 	if (first) {
+		bool compound = flags & RMAP_COMPOUND;
+		int nr = compound ? hpage_nr_pages(page) : 1;
 		/*
 		 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
 		 * these counters are not modified in interrupt context, and
 		 * pte lock(a spinlock) is held, which implies preemption
 		 * disabled.
 		 */
-		if (PageTransHuge(page))
+		if (compound) {
+			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 			__inc_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
-		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
-				hpage_nr_pages(page));
+		}
+		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, nr);
 	}
 	if (unlikely(PageKsm(page)))
 		return;
@@ -1173,7 +1177,8 @@ void do_page_add_anon_rmap(struct page *
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	/* address might be in next vma when migration races vma_adjust */
 	if (first)
-		__page_set_anon_rmap(page, vma, address, exclusive);
+		__page_set_anon_rmap(page, vma, address,
+				flags & RMAP_EXCLUSIVE);
 	else
 		__page_check_anon_rmap(page, vma, address);
 }
@@ -1183,21 +1188,25 @@ void do_page_add_anon_rmap(struct page *
  * @page:	the page to add the mapping to
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
+ * @compound:	charge the page as compound or small page
  *
  * Same as page_add_anon_rmap but must only be called on *new* pages.
  * This means the inc-and-test can be bypassed.
  * Page does not have to be locked.
  */
 void page_add_new_anon_rmap(struct page *page,
-	struct vm_area_struct *vma, unsigned long address)
+	struct vm_area_struct *vma, unsigned long address, bool compound)
 {
+	int nr = compound ? hpage_nr_pages(page) : 1;
+
 	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
 	SetPageSwapBacked(page);
 	atomic_set(&page->_mapcount, 0); /* increment count (starts at -1) */
-	if (PageTransHuge(page))
+	if (compound) {
+		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 		__inc_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
-	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
-			hpage_nr_pages(page));
+	}
+	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, nr);
 	__page_set_anon_rmap(page, vma, address, 1);
 }
 
@@ -1249,13 +1258,17 @@ out:
 
 /**
  * page_remove_rmap - take down pte mapping from a page
- * @page: page to remove mapping from
+ * @page:	page to remove mapping from
+ * @compound:	uncharge the page as compound or small page
  *
  * The caller needs to hold the pte lock.
  */
-void page_remove_rmap(struct page *page)
+void page_remove_rmap(struct page *page, bool compound)
 {
+	int nr = compound ? hpage_nr_pages(page) : 1;
+
 	if (!PageAnon(page)) {
+		VM_BUG_ON_PAGE(compound && !PageHuge(page), page);
 		page_remove_file_rmap(page);
 		return;
 	}
@@ -1273,11 +1286,12 @@ void page_remove_rmap(struct page *page)
 	 * these counters are not modified in interrupt context, and
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
-	if (PageTransHuge(page))
+	if (compound) {
+		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 		__dec_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
+	}
 
-	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
-			      -hpage_nr_pages(page));
+	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, -nr);
 
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
@@ -1416,7 +1430,7 @@ static int try_to_unmap_one(struct page
 	} else
 		dec_mm_counter(mm, mm_counter_file(page));
 
-	page_remove_rmap(page);
+	page_remove_rmap(page, PageHuge(page));
 	page_cache_release(page);
 
 out_unmap:
diff -puN mm/swapfile.c~rmap-add-argument-to-charge-compound-page mm/swapfile.c
--- a/mm/swapfile.c~rmap-add-argument-to-charge-compound-page
+++ a/mm/swapfile.c
@@ -1160,10 +1160,10 @@ static int unuse_pte(struct vm_area_stru
 	set_pte_at(vma->vm_mm, addr, pte,
 		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
 	if (page == swapcache) {
-		page_add_anon_rmap(page, vma, addr);
+		page_add_anon_rmap(page, vma, addr, false);
 		mem_cgroup_commit_charge(page, memcg, true);
 	} else { /* ksm created a completely new copy */
-		page_add_new_anon_rmap(page, vma, addr);
+		page_add_new_anon_rmap(page, vma, addr, false);
 		mem_cgroup_commit_charge(page, memcg, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	}
diff -puN mm/userfaultfd.c~rmap-add-argument-to-charge-compound-page mm/userfaultfd.c
--- a/mm/userfaultfd.c~rmap-add-argument-to-charge-compound-page
+++ a/mm/userfaultfd.c
@@ -76,7 +76,7 @@ static int mcopy_atomic_pte(struct mm_st
 		goto out_release_uncharge_unlock;
 
 	inc_mm_counter(dst_mm, MM_ANONPAGES);
-	page_add_new_anon_rmap(page, dst_vma, dst_addr);
+	page_add_new_anon_rmap(page, dst_vma, dst_addr, false);
 	mem_cgroup_commit_charge(page, memcg, false);
 	lru_cache_add_active_or_unevictable(page, dst_vma);
 
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

