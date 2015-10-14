From: akpm@linux-foundation.org
Subject: + rmap-add-argument-to-charge-compound-page.patch added to -mm
 tree
Date: Wed, 14 Oct 2015 14:12:33 -0700
Message-ID: <561ec541.IcQLhMPYKuwq4SWk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbbJNVMf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Oct 2015 17:12:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: add argument to charge compound page
has been added to the -mm tree.  Its filename is
     rmap-add-argument-to-charge-compound-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rmap-add-argument-to-charge-compound-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rmap-add-argument-to-charge-compound-page.patch

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
Subject: rmap: add argument to charge compound page

We're going to allow mapping of individual 4k pages of THP compound page. 
It means we cannot rely on PageTransHuge() check to decide if map/unmap
small page or THP.

The patch adds new argument to rmap functions to indicate whether we want
to operate on whole compound page or only the small page.

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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
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
@@ -828,7 +828,7 @@ static int __do_huge_pmd_anonymous_page(
 
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		page_add_new_anon_rmap(page, vma, haddr);
+		page_add_new_anon_rmap(page, vma, haddr, true);
 		mem_cgroup_commit_charge(page, memcg, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
@@ -1170,7 +1170,7 @@ static int do_huge_pmd_wp_page_fallback(
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		memcg = (void *)page_private(pages[i]);
 		set_page_private(pages[i], 0);
-		page_add_new_anon_rmap(pages[i], vma, haddr);
+		page_add_new_anon_rmap(pages[i], vma, haddr, false);
 		mem_cgroup_commit_charge(pages[i], memcg, false);
 		lru_cache_add_active_or_unevictable(pages[i], vma);
 		pte = pte_offset_map(&_pmd, haddr);
@@ -1182,7 +1182,7 @@ static int do_huge_pmd_wp_page_fallback(
 
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
-	page_remove_rmap(page);
+	page_remove_rmap(page, true);
 	spin_unlock(ptl);
 
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
@@ -1302,7 +1302,7 @@ alloc:
 		entry = mk_huge_pmd(new_page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		pmdp_huge_clear_flush_notify(vma, haddr, pmd);
-		page_add_new_anon_rmap(new_page, vma, haddr);
+		page_add_new_anon_rmap(new_page, vma, haddr, true);
 		mem_cgroup_commit_charge(new_page, memcg, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
 		set_pmd_at(mm, haddr, pmd, entry);
@@ -1312,7 +1312,7 @@ alloc:
 			put_huge_zero_page();
 		} else {
 			VM_BUG_ON_PAGE(!PageHead(page), page);
-			page_remove_rmap(page);
+			page_remove_rmap(page, true);
 			put_page(page);
 		}
 		ret |= VM_FAULT_WRITE;
@@ -1539,7 +1539,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		put_huge_zero_page();
 	} else {
 		struct page *page = pmd_page(orig_pmd);
-		page_remove_rmap(page);
+		page_remove_rmap(page, true);
 		VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
 		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 		VM_BUG_ON_PAGE(!PageHead(page), page);
@@ -2400,7 +2400,7 @@ static void __collapse_huge_page_copy(pt
 			 * superfluous.
 			 */
 			pte_clear(vma->vm_mm, address, _pte);
-			page_remove_rmap(src_page);
+			page_remove_rmap(src_page, false);
 			spin_unlock(ptl);
 			free_page_and_swap_cache(src_page);
 		}
@@ -2754,7 +2754,7 @@ static void collapse_huge_page(struct mm
 
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
@@ -3110,7 +3110,7 @@ again:
 			set_page_dirty(page);
 
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
-		page_remove_rmap(page);
+		page_remove_rmap(page, true);
 		force_flush = !__tlb_remove_page(tlb, page);
 		if (force_flush) {
 			address += sz;
@@ -3339,7 +3339,7 @@ retry_avoidcopy:
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
@@ -957,13 +957,13 @@ static int replace_page(struct vm_area_s
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
@@ -1125,7 +1125,7 @@ again:
 					mark_page_accessed(page);
 				rss[MM_FILEPAGES]--;
 			}
-			page_remove_rmap(page);
+			page_remove_rmap(page, false);
 			if (unlikely(page_mapcount(page) < 0))
 				print_bad_pte(vma, addr, ptent, page);
 			if (unlikely(!__tlb_remove_page(tlb, page))) {
@@ -2113,7 +2113,7 @@ static int wp_page_copy(struct mm_struct
 		 * thread doing COW.
 		 */
 		ptep_clear_flush_notify(vma, address, page_table);
-		page_add_new_anon_rmap(new_page, vma, address);
+		page_add_new_anon_rmap(new_page, vma, address, false);
 		mem_cgroup_commit_charge(new_page, memcg, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
 		/*
@@ -2146,7 +2146,7 @@ static int wp_page_copy(struct mm_struct
 			 * mapcount is visible. So transitively, TLBs to
 			 * old page will be flushed before it can be reused.
 			 */
-			page_remove_rmap(old_page);
+			page_remove_rmap(old_page, false);
 		}
 
 		/* Free the old page.. */
@@ -2562,7 +2562,7 @@ int do_swap_page(struct mm_struct *mm, s
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 		flags &= ~FAULT_FLAG_WRITE;
 		ret |= VM_FAULT_WRITE;
-		exclusive = 1;
+		exclusive = RMAP_EXCLUSIVE;
 	}
 	flush_icache_page(vma, page);
 	if (pte_swp_soft_dirty(orig_pte))
@@ -2572,7 +2572,7 @@ int do_swap_page(struct mm_struct *mm, s
 		do_page_add_anon_rmap(page, vma, address, exclusive);
 		mem_cgroup_commit_charge(page, memcg, true);
 	} else { /* ksm created a completely new copy */
-		page_add_new_anon_rmap(page, vma, address);
+		page_add_new_anon_rmap(page, vma, address, false);
 		mem_cgroup_commit_charge(page, memcg, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	}
@@ -2730,7 +2730,7 @@ static int do_anonymous_page(struct mm_s
 	}
 
 	inc_mm_counter_fast(mm, MM_ANONPAGES);
-	page_add_new_anon_rmap(page, vma, address);
+	page_add_new_anon_rmap(page, vma, address, false);
 	mem_cgroup_commit_charge(page, memcg, false);
 	lru_cache_add_active_or_unevictable(page, vma);
 setpte:
@@ -2818,7 +2818,7 @@ void do_set_pte(struct vm_area_struct *v
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 	if (anon) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
-		page_add_new_anon_rmap(page, vma, address);
+		page_add_new_anon_rmap(page, vma, address, false);
 	} else {
 		inc_mm_counter_fast(vma->vm_mm, MM_FILEPAGES);
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
 
@@ -1814,7 +1814,7 @@ fail_putback:
 	 * guarantee the copy is visible before the pagetable update.
 	 */
 	flush_cache_range(vma, mmun_start, mmun_end);
-	page_add_anon_rmap(new_page, vma, mmun_start);
+	page_add_anon_rmap(new_page, vma, mmun_start, true);
 	pmdp_huge_clear_flush_notify(vma, mmun_start, pmd);
 	set_pmd_at(mm, mmun_start, pmd, entry);
 	flush_tlb_range(vma, mmun_start, mmun_end);
@@ -1825,13 +1825,13 @@ fail_putback:
 		flush_tlb_range(vma, mmun_start, mmun_end);
 		mmu_notifier_invalidate_range(mm, mmun_start, mmun_end);
 		update_mmu_cache_pmd(vma, address, &entry);
-		page_remove_rmap(new_page);
+		page_remove_rmap(new_page, true);
 		goto fail_putback;
 	}
 
 	mem_cgroup_migrate(page, new_page, false);
 
-	page_remove_rmap(page);
+	page_remove_rmap(page, true);
 
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
diff -puN mm/rmap.c~rmap-add-argument-to-charge-compound-page mm/rmap.c
--- a/mm/rmap.c~rmap-add-argument-to-charge-compound-page
+++ a/mm/rmap.c
@@ -1131,6 +1131,7 @@ static void __page_check_anon_rmap(struc
  * @page:	the page to add the mapping to
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
+ * @compound:	charge the page as compound or small page
  *
  * The caller needs to hold the pte lock, and the page must be locked in
  * the anon_vma case: to serialize mapping,index checking after setting,
@@ -1138,9 +1139,9 @@ static void __page_check_anon_rmap(struc
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
@@ -1149,21 +1150,24 @@ void page_add_anon_rmap(struct page *pag
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
@@ -1171,7 +1175,8 @@ void do_page_add_anon_rmap(struct page *
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	/* address might be in next vma when migration races vma_adjust */
 	if (first)
-		__page_set_anon_rmap(page, vma, address, exclusive);
+		__page_set_anon_rmap(page, vma, address,
+				flags & RMAP_EXCLUSIVE);
 	else
 		__page_check_anon_rmap(page, vma, address);
 }
@@ -1181,21 +1186,25 @@ void do_page_add_anon_rmap(struct page *
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
 
@@ -1247,13 +1256,17 @@ out:
 
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
@@ -1271,11 +1284,12 @@ void page_remove_rmap(struct page *page)
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
 		dec_mm_counter(mm, MM_FILEPAGES);
 
-	page_remove_rmap(page);
+	page_remove_rmap(page, false);
 	page_cache_release(page);
 
 out_unmap:
diff -puN mm/swapfile.c~rmap-add-argument-to-charge-compound-page mm/swapfile.c
--- a/mm/swapfile.c~rmap-add-argument-to-charge-compound-page
+++ a/mm/swapfile.c
@@ -1163,10 +1163,10 @@ static int unuse_pte(struct vm_area_stru
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

