From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 093/131] mm: memcontrol: switch to native
 NR_ANON_MAPPED counter
Date: Wed, 03 Jun 2020 16:01:57 -0700
Message-ID: <20200603230157.d3kWqwSon%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgFCXIh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:37 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, bsingharora@gmail.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: switch to native NR_ANON_MAPPED counter

Memcg maintains a private MEMCG_RSS counter.  This divergence from the
generic VM accounting means unnecessary code overhead, and creates a
dependency for memcg that page->mapping is set up at the time of charging,
so that page types can be told apart.

Convert the generic accounting sites to mod_lruvec_page_state and friends
to maintain the per-cgroup vmstat counter of NR_ANON_MAPPED.  We use
lock_page_memcg() to stabilize page->mem_cgroup during rmap changes, the
same way we do for NR_FILE_MAPPED.

With the previous patch removing MEMCG_CACHE and the private NR_SHMEM
counter, this patch finally eliminates the need to have page->mapping set
up at charge time.  However, we need to have page->mem_cgroup set up by
the time rmap runs and does the accounting, so switch the commit and the
rmap callbacks around.

v2: fix temporary accounting bug by switching rmap<->commit (Joonsoo)

Link: http://lkml.kernel.org/r/20200508183105.225460-11-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 --
 kernel/events/uprobes.c    |    2 -
 mm/huge_memory.c           |    2 -
 mm/khugepaged.c            |    2 -
 mm/memcontrol.c            |   27 ++++++--------------
 mm/memory.c                |   10 +++----
 mm/migrate.c               |    2 -
 mm/rmap.c                  |   47 +++++++++++++++++++++--------------
 mm/swapfile.c              |    4 +-
 mm/userfaultfd.c           |    2 -
 10 files changed, 51 insertions(+), 50 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-switch-to-native-nr_anon_mapped-counter
+++ a/include/linux/memcontrol.h
@@ -29,8 +29,7 @@ struct kmem_cache;
 
 /* Cgroup-specific page state, on top of universal node page state */
 enum memcg_stat_item {
-	MEMCG_RSS = NR_VM_NODE_STAT_ITEMS,
-	MEMCG_RSS_HUGE,
+	MEMCG_RSS_HUGE = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_SWAP,
 	MEMCG_SOCK,
 	/* XXX: why are these zone and not node counters? */
--- a/kernel/events/uprobes.c~mm-memcontrol-switch-to-native-nr_anon_mapped-counter
+++ a/kernel/events/uprobes.c
@@ -188,8 +188,8 @@ static int __replace_page(struct vm_area
 
 	if (new_page) {
 		get_page(new_page);
-		page_add_new_anon_rmap(new_page, vma, addr, false);
 		mem_cgroup_commit_charge(new_page, memcg, false);
+		page_add_new_anon_rmap(new_page, vma, addr, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
 	} else
 		/* no new page, just dec_mm_counter for old_page */
--- a/mm/huge_memory.c~mm-memcontrol-switch-to-native-nr_anon_mapped-counter
+++ a/mm/huge_memory.c
@@ -640,8 +640,8 @@ static vm_fault_t __do_huge_pmd_anonymou
 
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		page_add_new_anon_rmap(page, vma, haddr, true);
 		mem_cgroup_commit_charge(page, memcg, false);
+		page_add_new_anon_rmap(page, vma, haddr, true);
 		lru_cache_add_active_or_unevictable(page, vma);
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
--- a/mm/khugepaged.c~mm-memcontrol-switch-to-native-nr_anon_mapped-counter
+++ a/mm/khugepaged.c
@@ -1175,8 +1175,8 @@ static void collapse_huge_page(struct mm
 
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
-	page_add_new_anon_rmap(new_page, vma, address, true);
 	mem_cgroup_commit_charge(new_page, memcg, false);
+	page_add_new_anon_rmap(new_page, vma, address, true);
 	count_memcg_events(memcg, THP_COLLAPSE_ALLOC, 1);
 	lru_cache_add_active_or_unevictable(new_page, vma);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
--- a/mm/memcontrol.c~mm-memcontrol-switch-to-native-nr_anon_mapped-counter
+++ a/mm/memcontrol.c
@@ -836,13 +836,6 @@ static void mem_cgroup_charge_statistics
 					 struct page *page,
 					 int nr_pages)
 {
-	/*
-	 * Here, RSS means 'mapped anon' and anon's SwapCache. Shmem/tmpfs is
-	 * counted as CACHE even if it's on ANON LRU.
-	 */
-	if (PageAnon(page))
-		__mod_memcg_state(memcg, MEMCG_RSS, nr_pages);
-
 	if (abs(nr_pages) > 1) {
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 		__mod_memcg_state(memcg, MEMCG_RSS_HUGE, nr_pages);
@@ -1384,7 +1377,7 @@ static char *memory_stat_format(struct m
 	 */
 
 	seq_buf_printf(&s, "anon %llu\n",
-		       (u64)memcg_page_state(memcg, MEMCG_RSS) *
+		       (u64)memcg_page_state(memcg, NR_ANON_MAPPED) *
 		       PAGE_SIZE);
 	seq_buf_printf(&s, "file %llu\n",
 		       (u64)memcg_page_state(memcg, NR_FILE_PAGES) *
@@ -3353,7 +3346,7 @@ static unsigned long mem_cgroup_usage(st
 
 	if (mem_cgroup_is_root(memcg)) {
 		val = memcg_page_state(memcg, NR_FILE_PAGES) +
-			memcg_page_state(memcg, MEMCG_RSS);
+			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)
 			val += memcg_page_state(memcg, MEMCG_SWAP);
 	} else {
@@ -3824,7 +3817,7 @@ static int memcg_numa_stat_show(struct s
 
 static const unsigned int memcg1_stats[] = {
 	NR_FILE_PAGES,
-	MEMCG_RSS,
+	NR_ANON_MAPPED,
 	MEMCG_RSS_HUGE,
 	NR_SHMEM,
 	NR_FILE_MAPPED,
@@ -5455,7 +5448,12 @@ static int mem_cgroup_move_account(struc
 
 	lock_page_memcg(page);
 
-	if (!PageAnon(page)) {
+	if (PageAnon(page)) {
+		if (page_mapped(page)) {
+			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
+			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
+		}
+	} else {
 		__mod_lruvec_state(from_vec, NR_FILE_PAGES, -nr_pages);
 		__mod_lruvec_state(to_vec, NR_FILE_PAGES, nr_pages);
 
@@ -6589,7 +6587,6 @@ void mem_cgroup_commit_charge(struct pag
 {
 	unsigned int nr_pages = hpage_nr_pages(page);
 
-	VM_BUG_ON_PAGE(!page->mapping, page);
 	VM_BUG_ON_PAGE(PageLRU(page) && !lrucare, page);
 
 	if (mem_cgroup_disabled())
@@ -6662,8 +6659,6 @@ int mem_cgroup_charge(struct page *page,
 	struct mem_cgroup *memcg;
 	int ret;
 
-	VM_BUG_ON_PAGE(!page->mapping, page);
-
 	ret = mem_cgroup_try_charge(page, mm, gfp_mask, &memcg);
 	if (ret)
 		return ret;
@@ -6675,7 +6670,6 @@ struct uncharge_gather {
 	struct mem_cgroup *memcg;
 	unsigned long nr_pages;
 	unsigned long pgpgout;
-	unsigned long nr_anon;
 	unsigned long nr_kmem;
 	unsigned long nr_huge;
 	struct page *dummy_page;
@@ -6700,7 +6694,6 @@ static void uncharge_batch(const struct
 	}
 
 	local_irq_save(flags);
-	__mod_memcg_state(ug->memcg, MEMCG_RSS, -ug->nr_anon);
 	__mod_memcg_state(ug->memcg, MEMCG_RSS_HUGE, -ug->nr_huge);
 	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
 	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_pages);
@@ -6740,8 +6733,6 @@ static void uncharge_page(struct page *p
 	if (!PageKmemcg(page)) {
 		if (PageTransHuge(page))
 			ug->nr_huge += nr_pages;
-		if (PageAnon(page))
-			ug->nr_anon += nr_pages;
 		ug->pgpgout++;
 	} else {
 		ug->nr_kmem += nr_pages;
--- a/mm/memory.c~mm-memcontrol-switch-to-native-nr_anon_mapped-counter
+++ a/mm/memory.c
@@ -2710,8 +2710,8 @@ static vm_fault_t wp_page_copy(struct vm
 		 * thread doing COW.
 		 */
 		ptep_clear_flush_notify(vma, vmf->address, vmf->pte);
-		page_add_new_anon_rmap(new_page, vma, vmf->address, false);
 		mem_cgroup_commit_charge(new_page, memcg, false);
+		page_add_new_anon_rmap(new_page, vma, vmf->address, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
 		/*
 		 * We call the notify macro here because, when using secondary
@@ -3243,12 +3243,12 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	/* ksm created a completely new copy */
 	if (unlikely(page != swapcache && swapcache)) {
-		page_add_new_anon_rmap(page, vma, vmf->address, false);
 		mem_cgroup_commit_charge(page, memcg, false);
+		page_add_new_anon_rmap(page, vma, vmf->address, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	} else {
-		do_page_add_anon_rmap(page, vma, vmf->address, exclusive);
 		mem_cgroup_commit_charge(page, memcg, true);
+		do_page_add_anon_rmap(page, vma, vmf->address, exclusive);
 		activate_page(page);
 	}
 
@@ -3390,8 +3390,8 @@ static vm_fault_t do_anonymous_page(stru
 	}
 
 	inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
-	page_add_new_anon_rmap(page, vma, vmf->address, false);
 	mem_cgroup_commit_charge(page, memcg, false);
+	page_add_new_anon_rmap(page, vma, vmf->address, false);
 	lru_cache_add_active_or_unevictable(page, vma);
 setpte:
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
@@ -3652,8 +3652,8 @@ vm_fault_t alloc_set_pte(struct vm_fault
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
-		page_add_new_anon_rmap(page, vma, vmf->address, false);
 		mem_cgroup_commit_charge(page, memcg, false);
+		page_add_new_anon_rmap(page, vma, vmf->address, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	} else {
 		inc_mm_counter_fast(vma->vm_mm, mm_counter_file(page));
--- a/mm/migrate.c~mm-memcontrol-switch-to-native-nr_anon_mapped-counter
+++ a/mm/migrate.c
@@ -2832,8 +2832,8 @@ static void migrate_vma_insert_page(stru
 		goto unlock_abort;
 
 	inc_mm_counter(mm, MM_ANONPAGES);
-	page_add_new_anon_rmap(page, vma, addr, false);
 	mem_cgroup_commit_charge(page, memcg, false);
+	page_add_new_anon_rmap(page, vma, addr, false);
 	if (!is_zone_device_page(page))
 		lru_cache_add_active_or_unevictable(page, vma);
 	get_page(page);
--- a/mm/rmap.c~mm-memcontrol-switch-to-native-nr_anon_mapped-counter
+++ a/mm/rmap.c
@@ -1114,6 +1114,11 @@ void do_page_add_anon_rmap(struct page *
 	bool compound = flags & RMAP_COMPOUND;
 	bool first;
 
+	if (unlikely(PageKsm(page)))
+		lock_page_memcg(page);
+	else
+		VM_BUG_ON_PAGE(!PageLocked(page), page);
+
 	if (compound) {
 		atomic_t *mapcount;
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
@@ -1134,12 +1139,13 @@ void do_page_add_anon_rmap(struct page *
 		 */
 		if (compound)
 			__inc_node_page_state(page, NR_ANON_THPS);
-		__mod_node_page_state(page_pgdat(page), NR_ANON_MAPPED, nr);
+		__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
 	}
-	if (unlikely(PageKsm(page)))
-		return;
 
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	if (unlikely(PageKsm(page))) {
+		unlock_page_memcg(page);
+		return;
+	}
 
 	/* address might be in next vma when migration races vma_adjust */
 	if (first)
@@ -1181,7 +1187,7 @@ void page_add_new_anon_rmap(struct page
 		/* increment count (starts at -1) */
 		atomic_set(&page->_mapcount, 0);
 	}
-	__mod_node_page_state(page_pgdat(page), NR_ANON_MAPPED, nr);
+	__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
 	__page_set_anon_rmap(page, vma, address, 1);
 }
 
@@ -1230,13 +1236,12 @@ static void page_remove_file_rmap(struct
 	int i, nr = 1;
 
 	VM_BUG_ON_PAGE(compound && !PageHead(page), page);
-	lock_page_memcg(page);
 
 	/* Hugepages are not counted in NR_FILE_MAPPED for now. */
 	if (unlikely(PageHuge(page))) {
 		/* hugetlb pages are always mapped with pmds */
 		atomic_dec(compound_mapcount_ptr(page));
-		goto out;
+		return;
 	}
 
 	/* page still mapped by someone else? */
@@ -1246,14 +1251,14 @@ static void page_remove_file_rmap(struct
 				nr++;
 		}
 		if (!atomic_add_negative(-1, compound_mapcount_ptr(page)))
-			goto out;
+			return;
 		if (PageSwapBacked(page))
 			__dec_node_page_state(page, NR_SHMEM_PMDMAPPED);
 		else
 			__dec_node_page_state(page, NR_FILE_PMDMAPPED);
 	} else {
 		if (!atomic_add_negative(-1, &page->_mapcount))
-			goto out;
+			return;
 	}
 
 	/*
@@ -1265,8 +1270,6 @@ static void page_remove_file_rmap(struct
 
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
-out:
-	unlock_page_memcg(page);
 }
 
 static void page_remove_anon_compound_rmap(struct page *page)
@@ -1310,7 +1313,7 @@ static void page_remove_anon_compound_rm
 		clear_page_mlock(page);
 
 	if (nr)
-		__mod_node_page_state(page_pgdat(page), NR_ANON_MAPPED, -nr);
+		__mod_lruvec_page_state(page, NR_ANON_MAPPED, -nr);
 }
 
 /**
@@ -1322,22 +1325,28 @@ static void page_remove_anon_compound_rm
  */
 void page_remove_rmap(struct page *page, bool compound)
 {
-	if (!PageAnon(page))
-		return page_remove_file_rmap(page, compound);
+	lock_page_memcg(page);
 
-	if (compound)
-		return page_remove_anon_compound_rmap(page);
+	if (!PageAnon(page)) {
+		page_remove_file_rmap(page, compound);
+		goto out;
+	}
+
+	if (compound) {
+		page_remove_anon_compound_rmap(page);
+		goto out;
+	}
 
 	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
-		return;
+		goto out;
 
 	/*
 	 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
 	 * these counters are not modified in interrupt context, and
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
-	__dec_node_page_state(page, NR_ANON_MAPPED);
+	__dec_lruvec_page_state(page, NR_ANON_MAPPED);
 
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
@@ -1354,6 +1363,8 @@ void page_remove_rmap(struct page *page,
 	 * Leaving it set also helps swapoff to reinstate ptes
 	 * faster for those pages still in swapcache.
 	 */
+out:
+	unlock_page_memcg(page);
 }
 
 /*
--- a/mm/swapfile.c~mm-memcontrol-switch-to-native-nr_anon_mapped-counter
+++ a/mm/swapfile.c
@@ -1920,11 +1920,11 @@ static int unuse_pte(struct vm_area_stru
 	set_pte_at(vma->vm_mm, addr, pte,
 		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
 	if (page == swapcache) {
-		page_add_anon_rmap(page, vma, addr, false);
 		mem_cgroup_commit_charge(page, memcg, true);
+		page_add_anon_rmap(page, vma, addr, false);
 	} else { /* ksm created a completely new copy */
-		page_add_new_anon_rmap(page, vma, addr, false);
 		mem_cgroup_commit_charge(page, memcg, false);
+		page_add_new_anon_rmap(page, vma, addr, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	}
 	swap_free(entry);
--- a/mm/userfaultfd.c~mm-memcontrol-switch-to-native-nr_anon_mapped-counter
+++ a/mm/userfaultfd.c
@@ -123,8 +123,8 @@ static int mcopy_atomic_pte(struct mm_st
 		goto out_release_uncharge_unlock;
 
 	inc_mm_counter(dst_mm, MM_ANONPAGES);
-	page_add_new_anon_rmap(page, dst_vma, dst_addr, false);
 	mem_cgroup_commit_charge(page, memcg, false);
+	page_add_new_anon_rmap(page, dst_vma, dst_addr, false);
 	lru_cache_add_active_or_unevictable(page, dst_vma);
 
 	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
_
