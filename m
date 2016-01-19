From: akpm@linux-foundation.org
Subject: [merged] memcg-adjust-to-support-new-thp-refcounting.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:01:23 -0800
Message-ID: <569e9613.GUOwIPWMsRc8drgi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033AbcASUBY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:01:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: adjust to support new THP refcounting
has been removed from the -mm tree.  Its filename was
     memcg-adjust-to-support-new-thp-refcounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: memcg: adjust to support new THP refcounting

As with rmap, with new refcounting we cannot rely on PageTransHuge() to
check if we need to charge size of huge page form the cgroup.  We need to
get information from caller to know whether it was mapped with PMD or PTE.

We do uncharge when last reference on the page gone.  At that point if we
see PageTransHuge() it means we need to unchange whole huge page.

The tricky part is partial unmap -- when we try to unmap part of huge
page.  We don't do a special handing of this situation, meaning we don't
uncharge the part of huge page unless last user is gone or
split_huge_page() is triggered.  In case of cgroup memory pressure happens
the partial unmapped page will be split through shrinker.  This should be
good enough.

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
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   16 +++++----
 kernel/events/uprobes.c    |    7 ++-
 mm/filemap.c               |    8 ++--
 mm/huge_memory.c           |   32 +++++++++---------
 mm/memcontrol.c            |   62 ++++++++++++-----------------------
 mm/memory.c                |   28 +++++++--------
 mm/shmem.c                 |   21 ++++++-----
 mm/swapfile.c              |    9 ++---
 mm/userfaultfd.c           |    6 +--
 9 files changed, 92 insertions(+), 97 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-adjust-to-support-new-thp-refcounting include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-adjust-to-support-new-thp-refcounting
+++ a/include/linux/memcontrol.h
@@ -280,10 +280,12 @@ static inline void mem_cgroup_events(str
 bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg);
 
 int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
-			  gfp_t gfp_mask, struct mem_cgroup **memcgp);
+			  gfp_t gfp_mask, struct mem_cgroup **memcgp,
+			  bool compound);
 void mem_cgroup_commit_charge(struct page *page, struct mem_cgroup *memcg,
-			      bool lrucare);
-void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg);
+			      bool lrucare, bool compound);
+void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg,
+		bool compound);
 void mem_cgroup_uncharge(struct page *page);
 void mem_cgroup_uncharge_list(struct list_head *page_list);
 
@@ -515,7 +517,8 @@ static inline bool mem_cgroup_low(struct
 
 static inline int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
 					gfp_t gfp_mask,
-					struct mem_cgroup **memcgp)
+					struct mem_cgroup **memcgp,
+					bool compound)
 {
 	*memcgp = NULL;
 	return 0;
@@ -523,12 +526,13 @@ static inline int mem_cgroup_try_charge(
 
 static inline void mem_cgroup_commit_charge(struct page *page,
 					    struct mem_cgroup *memcg,
-					    bool lrucare)
+					    bool lrucare, bool compound)
 {
 }
 
 static inline void mem_cgroup_cancel_charge(struct page *page,
-					    struct mem_cgroup *memcg)
+					    struct mem_cgroup *memcg,
+					    bool compound)
 {
 }
 
diff -puN kernel/events/uprobes.c~memcg-adjust-to-support-new-thp-refcounting kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~memcg-adjust-to-support-new-thp-refcounting
+++ a/kernel/events/uprobes.c
@@ -161,7 +161,8 @@ static int __replace_page(struct vm_area
 	const unsigned long mmun_end   = addr + PAGE_SIZE;
 	struct mem_cgroup *memcg;
 
-	err = mem_cgroup_try_charge(kpage, vma->vm_mm, GFP_KERNEL, &memcg);
+	err = mem_cgroup_try_charge(kpage, vma->vm_mm, GFP_KERNEL, &memcg,
+			false);
 	if (err)
 		return err;
 
@@ -176,7 +177,7 @@ static int __replace_page(struct vm_area
 
 	get_page(kpage);
 	page_add_new_anon_rmap(kpage, vma, addr, false);
-	mem_cgroup_commit_charge(kpage, memcg, false);
+	mem_cgroup_commit_charge(kpage, memcg, false, false);
 	lru_cache_add_active_or_unevictable(kpage, vma);
 
 	if (!PageAnon(page)) {
@@ -199,7 +200,7 @@ static int __replace_page(struct vm_area
 
 	err = 0;
  unlock:
-	mem_cgroup_cancel_charge(kpage, memcg);
+	mem_cgroup_cancel_charge(kpage, memcg, false);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	unlock_page(page);
 	return err;
diff -puN mm/filemap.c~memcg-adjust-to-support-new-thp-refcounting mm/filemap.c
--- a/mm/filemap.c~memcg-adjust-to-support-new-thp-refcounting
+++ a/mm/filemap.c
@@ -618,7 +618,7 @@ static int __add_to_page_cache_locked(st
 
 	if (!huge) {
 		error = mem_cgroup_try_charge(page, current->mm,
-					      gfp_mask, &memcg);
+					      gfp_mask, &memcg, false);
 		if (error)
 			return error;
 	}
@@ -626,7 +626,7 @@ static int __add_to_page_cache_locked(st
 	error = radix_tree_maybe_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (error) {
 		if (!huge)
-			mem_cgroup_cancel_charge(page, memcg);
+			mem_cgroup_cancel_charge(page, memcg, false);
 		return error;
 	}
 
@@ -645,7 +645,7 @@ static int __add_to_page_cache_locked(st
 		__inc_zone_page_state(page, NR_FILE_PAGES);
 	spin_unlock_irq(&mapping->tree_lock);
 	if (!huge)
-		mem_cgroup_commit_charge(page, memcg, false);
+		mem_cgroup_commit_charge(page, memcg, false, false);
 	trace_mm_filemap_add_to_page_cache(page);
 	return 0;
 err_insert:
@@ -653,7 +653,7 @@ err_insert:
 	/* Leave page->index set: truncation relies upon it */
 	spin_unlock_irq(&mapping->tree_lock);
 	if (!huge)
-		mem_cgroup_cancel_charge(page, memcg);
+		mem_cgroup_cancel_charge(page, memcg, false);
 	page_cache_release(page);
 	return error;
 }
diff -puN mm/huge_memory.c~memcg-adjust-to-support-new-thp-refcounting mm/huge_memory.c
--- a/mm/huge_memory.c~memcg-adjust-to-support-new-thp-refcounting
+++ a/mm/huge_memory.c
@@ -751,7 +751,7 @@ static int __do_huge_pmd_anonymous_page(
 
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
-	if (mem_cgroup_try_charge(page, mm, gfp, &memcg)) {
+	if (mem_cgroup_try_charge(page, mm, gfp, &memcg, true)) {
 		put_page(page);
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
@@ -759,7 +759,7 @@ static int __do_huge_pmd_anonymous_page(
 
 	pgtable = pte_alloc_one(mm, haddr);
 	if (unlikely(!pgtable)) {
-		mem_cgroup_cancel_charge(page, memcg);
+		mem_cgroup_cancel_charge(page, memcg, true);
 		put_page(page);
 		return VM_FAULT_OOM;
 	}
@@ -775,7 +775,7 @@ static int __do_huge_pmd_anonymous_page(
 	ptl = pmd_lock(mm, pmd);
 	if (unlikely(!pmd_none(*pmd))) {
 		spin_unlock(ptl);
-		mem_cgroup_cancel_charge(page, memcg);
+		mem_cgroup_cancel_charge(page, memcg, true);
 		put_page(page);
 		pte_free(mm, pgtable);
 	} else {
@@ -786,7 +786,7 @@ static int __do_huge_pmd_anonymous_page(
 			int ret;
 
 			spin_unlock(ptl);
-			mem_cgroup_cancel_charge(page, memcg);
+			mem_cgroup_cancel_charge(page, memcg, true);
 			put_page(page);
 			pte_free(mm, pgtable);
 			ret = handle_userfault(vma, address, flags,
@@ -798,7 +798,7 @@ static int __do_huge_pmd_anonymous_page(
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		page_add_new_anon_rmap(page, vma, haddr, true);
-		mem_cgroup_commit_charge(page, memcg, false);
+		mem_cgroup_commit_charge(page, memcg, false, true);
 		lru_cache_add_active_or_unevictable(page, vma);
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 		set_pmd_at(mm, haddr, pmd, entry);
@@ -1095,13 +1095,14 @@ static int do_huge_pmd_wp_page_fallback(
 					       vma, address, page_to_nid(page));
 		if (unlikely(!pages[i] ||
 			     mem_cgroup_try_charge(pages[i], mm, GFP_KERNEL,
-						   &memcg))) {
+						   &memcg, false))) {
 			if (pages[i])
 				put_page(pages[i]);
 			while (--i >= 0) {
 				memcg = (void *)page_private(pages[i]);
 				set_page_private(pages[i], 0);
-				mem_cgroup_cancel_charge(pages[i], memcg);
+				mem_cgroup_cancel_charge(pages[i], memcg,
+						false);
 				put_page(pages[i]);
 			}
 			kfree(pages);
@@ -1140,7 +1141,7 @@ static int do_huge_pmd_wp_page_fallback(
 		memcg = (void *)page_private(pages[i]);
 		set_page_private(pages[i], 0);
 		page_add_new_anon_rmap(pages[i], vma, haddr, false);
-		mem_cgroup_commit_charge(pages[i], memcg, false);
+		mem_cgroup_commit_charge(pages[i], memcg, false, false);
 		lru_cache_add_active_or_unevictable(pages[i], vma);
 		pte = pte_offset_map(&_pmd, haddr);
 		VM_BUG_ON(!pte_none(*pte));
@@ -1168,7 +1169,7 @@ out_free_pages:
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
 		memcg = (void *)page_private(pages[i]);
 		set_page_private(pages[i], 0);
-		mem_cgroup_cancel_charge(pages[i], memcg);
+		mem_cgroup_cancel_charge(pages[i], memcg, false);
 		put_page(pages[i]);
 	}
 	kfree(pages);
@@ -1234,7 +1235,8 @@ alloc:
 		goto out;
 	}
 
-	if (unlikely(mem_cgroup_try_charge(new_page, mm, huge_gfp, &memcg))) {
+	if (unlikely(mem_cgroup_try_charge(new_page, mm, huge_gfp, &memcg,
+					   true))) {
 		put_page(new_page);
 		if (page) {
 			split_huge_page(page);
@@ -1263,7 +1265,7 @@ alloc:
 		put_user_huge_page(page);
 	if (unlikely(!pmd_same(*pmd, orig_pmd))) {
 		spin_unlock(ptl);
-		mem_cgroup_cancel_charge(new_page, memcg);
+		mem_cgroup_cancel_charge(new_page, memcg, true);
 		put_page(new_page);
 		goto out_mn;
 	} else {
@@ -1272,7 +1274,7 @@ alloc:
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		pmdp_huge_clear_flush_notify(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr, true);
-		mem_cgroup_commit_charge(new_page, memcg, false);
+		mem_cgroup_commit_charge(new_page, memcg, false, true);
 		lru_cache_add_active_or_unevictable(new_page, vma);
 		set_pmd_at(mm, haddr, pmd, entry);
 		update_mmu_cache_pmd(vma, address, pmd);
@@ -2583,7 +2585,7 @@ static void collapse_huge_page(struct mm
 		goto out_nolock;
 	}
 
-	if (unlikely(mem_cgroup_try_charge(new_page, mm, gfp, &memcg))) {
+	if (unlikely(mem_cgroup_try_charge(new_page, mm, gfp, &memcg, true))) {
 		result = SCAN_CGROUP_CHARGE_FAIL;
 		goto out_nolock;
 	}
@@ -2683,7 +2685,7 @@ static void collapse_huge_page(struct mm
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(new_page, vma, address, true);
-	mem_cgroup_commit_charge(new_page, memcg, false);
+	mem_cgroup_commit_charge(new_page, memcg, false, true);
 	lru_cache_add_active_or_unevictable(new_page, vma);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, address, pmd, _pmd);
@@ -2703,7 +2705,7 @@ out_nolock:
 	trace_mm_collapse_huge_page(mm, isolated, result);
 	return;
 out:
-	mem_cgroup_cancel_charge(new_page, memcg);
+	mem_cgroup_cancel_charge(new_page, memcg, true);
 	goto out_up_write;
 }
 
diff -puN mm/memcontrol.c~memcg-adjust-to-support-new-thp-refcounting mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-adjust-to-support-new-thp-refcounting
+++ a/mm/memcontrol.c
@@ -647,7 +647,7 @@ static unsigned long mem_cgroup_read_eve
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 					 struct page *page,
-					 int nr_pages)
+					 bool compound, int nr_pages)
 {
 	/*
 	 * Here, RSS means 'mapped anon' and anon's SwapCache. Shmem/tmpfs is
@@ -660,9 +660,11 @@ static void mem_cgroup_charge_statistics
 		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_CACHE],
 				nr_pages);
 
-	if (PageTransHuge(page))
+	if (compound) {
+		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_RSS_HUGE],
 				nr_pages);
+	}
 
 	/* pagein of a big page is an event. So, ignore page size */
 	if (nr_pages > 0)
@@ -4513,30 +4515,24 @@ static struct page *mc_handle_file_pte(s
  * from old cgroup.
  */
 static int mem_cgroup_move_account(struct page *page,
-				   unsigned int nr_pages,
+				   bool compound,
 				   struct mem_cgroup *from,
 				   struct mem_cgroup *to)
 {
 	unsigned long flags;
+	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
 	int ret;
 	bool anon;
 
 	VM_BUG_ON(from == to);
 	VM_BUG_ON_PAGE(PageLRU(page), page);
-	/*
-	 * The page is isolated from LRU. So, collapse function
-	 * will not handle this page. But page splitting can happen.
-	 * Do this check under compound_page_lock(). The caller should
-	 * hold it.
-	 */
-	ret = -EBUSY;
-	if (nr_pages > 1 && !PageTransHuge(page))
-		goto out;
+	VM_BUG_ON(compound && !PageTransHuge(page));
 
 	/*
 	 * Prevent mem_cgroup_replace_page() from looking at
 	 * page->mem_cgroup of its source page while we change it.
 	 */
+	ret = -EBUSY;
 	if (!trylock_page(page))
 		goto out;
 
@@ -4591,9 +4587,9 @@ static int mem_cgroup_move_account(struc
 	ret = 0;
 
 	local_irq_disable();
-	mem_cgroup_charge_statistics(to, page, nr_pages);
+	mem_cgroup_charge_statistics(to, page, compound, nr_pages);
 	memcg_check_events(to, page);
-	mem_cgroup_charge_statistics(from, page, -nr_pages);
+	mem_cgroup_charge_statistics(from, page, compound, -nr_pages);
 	memcg_check_events(from, page);
 	local_irq_enable();
 out_unlock:
@@ -4890,7 +4886,7 @@ static int mem_cgroup_move_charge_pte_ra
 		if (target_type == MC_TARGET_PAGE) {
 			page = target.page;
 			if (!isolate_lru_page(page)) {
-				if (!mem_cgroup_move_account(page, HPAGE_PMD_NR,
+				if (!mem_cgroup_move_account(page, true,
 							     mc.from, mc.to)) {
 					mc.precharge -= HPAGE_PMD_NR;
 					mc.moved_charge += HPAGE_PMD_NR;
@@ -4919,7 +4915,8 @@ retry:
 			page = target.page;
 			if (isolate_lru_page(page))
 				goto put;
-			if (!mem_cgroup_move_account(page, 1, mc.from, mc.to)) {
+			if (!mem_cgroup_move_account(page, false,
+						mc.from, mc.to)) {
 				mc.precharge--;
 				/* we uncharge from mc.from later. */
 				mc.moved_charge++;
@@ -5258,10 +5255,11 @@ bool mem_cgroup_low(struct mem_cgroup *r
  * with mem_cgroup_cancel_charge() in case page instantiation fails.
  */
 int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
-			  gfp_t gfp_mask, struct mem_cgroup **memcgp)
+			  gfp_t gfp_mask, struct mem_cgroup **memcgp,
+			  bool compound)
 {
 	struct mem_cgroup *memcg = NULL;
-	unsigned int nr_pages = 1;
+	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
 	int ret = 0;
 
 	if (mem_cgroup_disabled())
@@ -5291,11 +5289,6 @@ int mem_cgroup_try_charge(struct page *p
 		}
 	}
 
-	if (PageTransHuge(page)) {
-		nr_pages <<= compound_order(page);
-		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
-	}
-
 	if (!memcg)
 		memcg = get_mem_cgroup_from_mm(mm);
 
@@ -5324,9 +5317,9 @@ out:
  * Use mem_cgroup_cancel_charge() to cancel the transaction instead.
  */
 void mem_cgroup_commit_charge(struct page *page, struct mem_cgroup *memcg,
-			      bool lrucare)
+			      bool lrucare, bool compound)
 {
-	unsigned int nr_pages = 1;
+	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
 
 	VM_BUG_ON_PAGE(!page->mapping, page);
 	VM_BUG_ON_PAGE(PageLRU(page) && !lrucare, page);
@@ -5343,13 +5336,8 @@ void mem_cgroup_commit_charge(struct pag
 
 	commit_charge(page, memcg, lrucare);
 
-	if (PageTransHuge(page)) {
-		nr_pages <<= compound_order(page);
-		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
-	}
-
 	local_irq_disable();
-	mem_cgroup_charge_statistics(memcg, page, nr_pages);
+	mem_cgroup_charge_statistics(memcg, page, compound, nr_pages);
 	memcg_check_events(memcg, page);
 	local_irq_enable();
 
@@ -5371,9 +5359,10 @@ void mem_cgroup_commit_charge(struct pag
  *
  * Cancel a charge transaction started by mem_cgroup_try_charge().
  */
-void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg)
+void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg,
+		bool compound)
 {
-	unsigned int nr_pages = 1;
+	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
 
 	if (mem_cgroup_disabled())
 		return;
@@ -5385,11 +5374,6 @@ void mem_cgroup_cancel_charge(struct pag
 	if (!memcg)
 		return;
 
-	if (PageTransHuge(page)) {
-		nr_pages <<= compound_order(page);
-		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
-	}
-
 	cancel_charge(memcg, nr_pages);
 }
 
@@ -5750,7 +5734,7 @@ void mem_cgroup_swapout(struct page *pag
 	 * only synchronisation we have for udpating the per-CPU variables.
 	 */
 	VM_BUG_ON(!irqs_disabled());
-	mem_cgroup_charge_statistics(memcg, page, -1);
+	mem_cgroup_charge_statistics(memcg, page, false, -1);
 	memcg_check_events(memcg, page);
 }
 
diff -puN mm/memory.c~memcg-adjust-to-support-new-thp-refcounting mm/memory.c
--- a/mm/memory.c~memcg-adjust-to-support-new-thp-refcounting
+++ a/mm/memory.c
@@ -2087,7 +2087,7 @@ static int wp_page_copy(struct mm_struct
 		cow_user_page(new_page, old_page, address, vma);
 	}
 
-	if (mem_cgroup_try_charge(new_page, mm, GFP_KERNEL, &memcg))
+	if (mem_cgroup_try_charge(new_page, mm, GFP_KERNEL, &memcg, false))
 		goto oom_free_new;
 
 	__SetPageUptodate(new_page);
@@ -2119,7 +2119,7 @@ static int wp_page_copy(struct mm_struct
 		 */
 		ptep_clear_flush_notify(vma, address, page_table);
 		page_add_new_anon_rmap(new_page, vma, address, false);
-		mem_cgroup_commit_charge(new_page, memcg, false);
+		mem_cgroup_commit_charge(new_page, memcg, false, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
 		/*
 		 * We call the notify macro here because, when using secondary
@@ -2158,7 +2158,7 @@ static int wp_page_copy(struct mm_struct
 		new_page = old_page;
 		page_copied = 1;
 	} else {
-		mem_cgroup_cancel_charge(new_page, memcg);
+		mem_cgroup_cancel_charge(new_page, memcg, false);
 	}
 
 	if (new_page)
@@ -2533,7 +2533,7 @@ static int do_swap_page(struct mm_struct
 		goto out_page;
 	}
 
-	if (mem_cgroup_try_charge(page, mm, GFP_KERNEL, &memcg)) {
+	if (mem_cgroup_try_charge(page, mm, GFP_KERNEL, &memcg, false)) {
 		ret = VM_FAULT_OOM;
 		goto out_page;
 	}
@@ -2575,10 +2575,10 @@ static int do_swap_page(struct mm_struct
 	set_pte_at(mm, address, page_table, pte);
 	if (page == swapcache) {
 		do_page_add_anon_rmap(page, vma, address, exclusive);
-		mem_cgroup_commit_charge(page, memcg, true);
+		mem_cgroup_commit_charge(page, memcg, true, false);
 	} else { /* ksm created a completely new copy */
 		page_add_new_anon_rmap(page, vma, address, false);
-		mem_cgroup_commit_charge(page, memcg, false);
+		mem_cgroup_commit_charge(page, memcg, false, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	}
 
@@ -2613,7 +2613,7 @@ unlock:
 out:
 	return ret;
 out_nomap:
-	mem_cgroup_cancel_charge(page, memcg);
+	mem_cgroup_cancel_charge(page, memcg, false);
 	pte_unmap_unlock(page_table, ptl);
 out_page:
 	unlock_page(page);
@@ -2707,7 +2707,7 @@ static int do_anonymous_page(struct mm_s
 	if (!page)
 		goto oom;
 
-	if (mem_cgroup_try_charge(page, mm, GFP_KERNEL, &memcg))
+	if (mem_cgroup_try_charge(page, mm, GFP_KERNEL, &memcg, false))
 		goto oom_free_page;
 
 	/*
@@ -2728,7 +2728,7 @@ static int do_anonymous_page(struct mm_s
 	/* Deliver the page fault to userland, check inside PT lock */
 	if (userfaultfd_missing(vma)) {
 		pte_unmap_unlock(page_table, ptl);
-		mem_cgroup_cancel_charge(page, memcg);
+		mem_cgroup_cancel_charge(page, memcg, false);
 		page_cache_release(page);
 		return handle_userfault(vma, address, flags,
 					VM_UFFD_MISSING);
@@ -2736,7 +2736,7 @@ static int do_anonymous_page(struct mm_s
 
 	inc_mm_counter_fast(mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, address, false);
-	mem_cgroup_commit_charge(page, memcg, false);
+	mem_cgroup_commit_charge(page, memcg, false, false);
 	lru_cache_add_active_or_unevictable(page, vma);
 setpte:
 	set_pte_at(mm, address, page_table, entry);
@@ -2747,7 +2747,7 @@ unlock:
 	pte_unmap_unlock(page_table, ptl);
 	return 0;
 release:
-	mem_cgroup_cancel_charge(page, memcg);
+	mem_cgroup_cancel_charge(page, memcg, false);
 	page_cache_release(page);
 	goto unlock;
 oom_free_page:
@@ -3000,7 +3000,7 @@ static int do_cow_fault(struct mm_struct
 	if (!new_page)
 		return VM_FAULT_OOM;
 
-	if (mem_cgroup_try_charge(new_page, mm, GFP_KERNEL, &memcg)) {
+	if (mem_cgroup_try_charge(new_page, mm, GFP_KERNEL, &memcg, false)) {
 		page_cache_release(new_page);
 		return VM_FAULT_OOM;
 	}
@@ -3029,7 +3029,7 @@ static int do_cow_fault(struct mm_struct
 		goto uncharge_out;
 	}
 	do_set_pte(vma, address, new_page, pte, true, true);
-	mem_cgroup_commit_charge(new_page, memcg, false);
+	mem_cgroup_commit_charge(new_page, memcg, false, false);
 	lru_cache_add_active_or_unevictable(new_page, vma);
 	pte_unmap_unlock(pte, ptl);
 	if (fault_page) {
@@ -3044,7 +3044,7 @@ static int do_cow_fault(struct mm_struct
 	}
 	return ret;
 uncharge_out:
-	mem_cgroup_cancel_charge(new_page, memcg);
+	mem_cgroup_cancel_charge(new_page, memcg, false);
 	page_cache_release(new_page);
 	return ret;
 }
diff -puN mm/shmem.c~memcg-adjust-to-support-new-thp-refcounting mm/shmem.c
--- a/mm/shmem.c~memcg-adjust-to-support-new-thp-refcounting
+++ a/mm/shmem.c
@@ -810,7 +810,8 @@ int shmem_unuse(swp_entry_t swap, struct
 	 * the shmem_swaplist_mutex which might hold up shmem_writepage().
 	 * Charged back to the user (not to caller) when swap account is used.
 	 */
-	error = mem_cgroup_try_charge(page, current->mm, GFP_KERNEL, &memcg);
+	error = mem_cgroup_try_charge(page, current->mm, GFP_KERNEL, &memcg,
+			false);
 	if (error)
 		goto out;
 	/* No radix_tree_preload: swap entry keeps a place for page in tree */
@@ -833,9 +834,9 @@ int shmem_unuse(swp_entry_t swap, struct
 	if (error) {
 		if (error != -ENOMEM)
 			error = 0;
-		mem_cgroup_cancel_charge(page, memcg);
+		mem_cgroup_cancel_charge(page, memcg, false);
 	} else
-		mem_cgroup_commit_charge(page, memcg, true);
+		mem_cgroup_commit_charge(page, memcg, true, false);
 out:
 	unlock_page(page);
 	page_cache_release(page);
@@ -1218,7 +1219,8 @@ repeat:
 				goto failed;
 		}
 
-		error = mem_cgroup_try_charge(page, current->mm, gfp, &memcg);
+		error = mem_cgroup_try_charge(page, current->mm, gfp, &memcg,
+				false);
 		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
 						swp_to_radix_entry(swap));
@@ -1235,14 +1237,14 @@ repeat:
 			 * "repeat": reading a hole and writing should succeed.
 			 */
 			if (error) {
-				mem_cgroup_cancel_charge(page, memcg);
+				mem_cgroup_cancel_charge(page, memcg, false);
 				delete_from_swap_cache(page);
 			}
 		}
 		if (error)
 			goto failed;
 
-		mem_cgroup_commit_charge(page, memcg, true);
+		mem_cgroup_commit_charge(page, memcg, true, false);
 
 		spin_lock(&info->lock);
 		info->swapped--;
@@ -1281,7 +1283,8 @@ repeat:
 		if (sgp == SGP_WRITE)
 			__SetPageReferenced(page);
 
-		error = mem_cgroup_try_charge(page, current->mm, gfp, &memcg);
+		error = mem_cgroup_try_charge(page, current->mm, gfp, &memcg,
+				false);
 		if (error)
 			goto decused;
 		error = radix_tree_maybe_preload(gfp & GFP_RECLAIM_MASK);
@@ -1291,10 +1294,10 @@ repeat:
 			radix_tree_preload_end();
 		}
 		if (error) {
-			mem_cgroup_cancel_charge(page, memcg);
+			mem_cgroup_cancel_charge(page, memcg, false);
 			goto decused;
 		}
-		mem_cgroup_commit_charge(page, memcg, false);
+		mem_cgroup_commit_charge(page, memcg, false, false);
 		lru_cache_add_anon(page);
 
 		spin_lock(&info->lock);
diff -puN mm/swapfile.c~memcg-adjust-to-support-new-thp-refcounting mm/swapfile.c
--- a/mm/swapfile.c~memcg-adjust-to-support-new-thp-refcounting
+++ a/mm/swapfile.c
@@ -1142,14 +1142,15 @@ static int unuse_pte(struct vm_area_stru
 	if (unlikely(!page))
 		return -ENOMEM;
 
-	if (mem_cgroup_try_charge(page, vma->vm_mm, GFP_KERNEL, &memcg)) {
+	if (mem_cgroup_try_charge(page, vma->vm_mm, GFP_KERNEL,
+				&memcg, false)) {
 		ret = -ENOMEM;
 		goto out_nolock;
 	}
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (unlikely(!maybe_same_pte(*pte, swp_entry_to_pte(entry)))) {
-		mem_cgroup_cancel_charge(page, memcg);
+		mem_cgroup_cancel_charge(page, memcg, false);
 		ret = 0;
 		goto out;
 	}
@@ -1161,10 +1162,10 @@ static int unuse_pte(struct vm_area_stru
 		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
 	if (page == swapcache) {
 		page_add_anon_rmap(page, vma, addr, false);
-		mem_cgroup_commit_charge(page, memcg, true);
+		mem_cgroup_commit_charge(page, memcg, true, false);
 	} else { /* ksm created a completely new copy */
 		page_add_new_anon_rmap(page, vma, addr, false);
-		mem_cgroup_commit_charge(page, memcg, false);
+		mem_cgroup_commit_charge(page, memcg, false, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	}
 	swap_free(entry);
diff -puN mm/userfaultfd.c~memcg-adjust-to-support-new-thp-refcounting mm/userfaultfd.c
--- a/mm/userfaultfd.c~memcg-adjust-to-support-new-thp-refcounting
+++ a/mm/userfaultfd.c
@@ -63,7 +63,7 @@ static int mcopy_atomic_pte(struct mm_st
 	__SetPageUptodate(page);
 
 	ret = -ENOMEM;
-	if (mem_cgroup_try_charge(page, dst_mm, GFP_KERNEL, &memcg))
+	if (mem_cgroup_try_charge(page, dst_mm, GFP_KERNEL, &memcg, false))
 		goto out_release;
 
 	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
@@ -77,7 +77,7 @@ static int mcopy_atomic_pte(struct mm_st
 
 	inc_mm_counter(dst_mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, dst_vma, dst_addr, false);
-	mem_cgroup_commit_charge(page, memcg, false);
+	mem_cgroup_commit_charge(page, memcg, false, false);
 	lru_cache_add_active_or_unevictable(page, dst_vma);
 
 	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
@@ -91,7 +91,7 @@ out:
 	return ret;
 out_release_uncharge_unlock:
 	pte_unmap_unlock(dst_pte, ptl);
-	mem_cgroup_cancel_charge(page, memcg);
+	mem_cgroup_cancel_charge(page, memcg, false);
 out_release:
 	page_cache_release(page);
 	goto out;
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

