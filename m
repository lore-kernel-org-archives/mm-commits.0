Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C074C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 04:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345785AbiDLEXE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245601AbiDLEWY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 00:22:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AA627CDF
        for <mm-commits@vger.kernel.org>; Mon, 11 Apr 2022 21:20:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D213CB81B1C
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 04:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F7CC385A1;
        Tue, 12 Apr 2022 04:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649737204;
        bh=XS6BkqCr9cQhQTHmtFWj6PFBAoudvgs9yRyZK3fMCCw=;
        h=Date:To:From:Subject:From;
        b=GEWgcXImU6AgVWt8U2u4+3fAtFdrY5qZZ5X2hb6FFeG4RpzAG/w7vxJgC7KVSVPu9
         K2E8edx3HRBb1Eu9Tf89xGluoja4qAypTqLJg/mnypv0iYABnkLVoiE/uxHveRrvdK
         /9/dlyerVZroSBGYMwBbfGqQwFeksKerVwSFH1Lg=
Date:   Mon, 11 Apr 2022 21:20:03 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, vaibhav@linux.ibm.com,
        szhai2@cs.rochester.edu, suleiman@google.com, steven@liquorix.net,
        sofia.trinh@edi.works, shy828301@gmail.com,
        oleksandr@natalenko.name, mgorman@techsingularity.net,
        holger@applied-asynchrony.com, Hi-Angel@yandex.ru,
        heftig@archlinux.org, hannes@cmpxchg.org, djbyrne@mtu.edu,
        d@chaos-reins.com, bgeffon@google.com, baohua@kernel.org,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-exploit-locality-in-rmap.patch added to -mm tree
Message-Id: <20220412042004.88F7CC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: exploit locality in rmap
has been added to the -mm tree.  Its filename is
     mm-multi-gen-lru-exploit-locality-in-rmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-multi-gen-lru-exploit-locality-in-rmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-multi-gen-lru-exploit-locality-in-rmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: exploit locality in rmap

Searching the rmap for PTEs mapping each page on an LRU list (to test and
clear the accessed bit) can be expensive because pages from different VMAs
(PA space) are not cache friendly to the rmap (VA space).  For workloads
mostly using mapped pages, the rmap has a high CPU cost in the reclaim
path.

This patch exploits spatial locality to reduce the trips into the rmap. 
When shrink_page_list() walks the rmap and finds a young PTE, a new
function lru_gen_look_around() scans at most BITS_PER_LONG-1 adjacent
PTEs.  On finding another young PTE, it clears the accessed bit and
updates the gen counter of the page mapped by this PTE to
(max_seq%MAX_NR_GENS)+1.

Server benchmark results:
  Single workload:
    fio (buffered I/O): no change

  Single workload:
    memcached (anon): +[5.5, 7.5]%
                Ops/sec      KB/sec
      patch1-6: 1120643.70   43588.06
      patch1-7: 1193918.93   46438.15

  Configurations:
    no change

Client benchmark results:
  kswapd profiles:
    patch1-6
      35.99%  lzo1x_1_do_compress (real work)
      19.40%  page_vma_mapped_walk
       6.31%  _raw_spin_unlock_irq
       3.95%  do_raw_spin_lock
       2.39%  anon_vma_interval_tree_iter_first
       2.25%  ptep_clear_flush
       1.92%  __anon_vma_interval_tree_subtree_search
       1.70%  folio_referenced_one
       1.68%  __zram_bvec_write
       1.43%  anon_vma_interval_tree_iter_next

    patch1-7
      45.90%  lzo1x_1_do_compress (real work)
       9.14%  page_vma_mapped_walk
       6.81%  _raw_spin_unlock_irq
       2.80%  ptep_clear_flush
       2.34%  __zram_bvec_write
       2.29%  do_raw_spin_lock
       1.84%  lru_gen_look_around
       1.78%  memmove
       1.74%  obj_malloc
       1.50%  free_unref_page_list

  Configurations:
    no change

Link: https://lkml.kernel.org/r/20220407031525.2368067-8-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Acked-by: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Acked-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Acked-by: Steven Barrett <steven@liquorix.net>
Acked-by: Suleiman Souhlal <suleiman@google.com>
Tested-by: Daniel Byrne <djbyrne@mtu.edu>
Tested-by: Donald Carr <d@chaos-reins.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Tested-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>
Tested-by: Shuang Zhai <szhai2@cs.rochester.edu>
Tested-by: Sofia Trinh <sofia.trinh@edi.works>
Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/memcontrol.h~mm-multi-gen-lru-exploit-locality-in-rmap
+++ a/include/linux/memcontrol.h
@@ -438,6 +438,7 @@ static inline struct obj_cgroup *__folio
  * - LRU isolation
  * - lock_page_memcg()
  * - exclusive reference
+ * - mem_cgroup_trylock_pages()
  *
  * For a kmem folio a caller should hold an rcu read lock to protect memcg
  * associated with a kmem folio from being released.
@@ -499,6 +500,7 @@ static inline struct mem_cgroup *folio_m
  * - LRU isolation
  * - lock_page_memcg()
  * - exclusive reference
+ * - mem_cgroup_trylock_pages()
  *
  * For a kmem page a caller should hold an rcu read lock to protect memcg
  * associated with a kmem page from being released.
@@ -948,6 +950,23 @@ void unlock_page_memcg(struct page *page
 
 void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val);
 
+/* try to stablize folio_memcg() for all the pages in a memcg */
+static inline bool mem_cgroup_trylock_pages(struct mem_cgroup *memcg)
+{
+	rcu_read_lock();
+
+	if (mem_cgroup_disabled() || !atomic_read(&memcg->moving_account))
+		return true;
+
+	rcu_read_unlock();
+	return false;
+}
+
+static inline void mem_cgroup_unlock_pages(void)
+{
+	rcu_read_unlock();
+}
+
 /* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void mod_memcg_state(struct mem_cgroup *memcg,
 				   int idx, int val)
@@ -1386,6 +1405,18 @@ static inline void folio_memcg_unlock(st
 {
 }
 
+static inline bool mem_cgroup_trylock_pages(struct mem_cgroup *memcg)
+{
+	/* to match folio_memcg_rcu() */
+	rcu_read_lock();
+	return true;
+}
+
+static inline void mem_cgroup_unlock_pages(void)
+{
+	rcu_read_unlock();
+}
+
 static inline void mem_cgroup_handle_over_high(void)
 {
 }
--- a/include/linux/mm.h~mm-multi-gen-lru-exploit-locality-in-rmap
+++ a/include/linux/mm.h
@@ -1523,6 +1523,11 @@ static inline unsigned long folio_pfn(st
 	return page_to_pfn(&folio->page);
 }
 
+static inline struct folio *pfn_folio(unsigned long pfn)
+{
+	return page_folio(pfn_to_page(pfn));
+}
+
 static inline atomic_t *folio_pincount_ptr(struct folio *folio)
 {
 	return &folio_page(folio, 1)->compound_pincount;
--- a/include/linux/mmzone.h~mm-multi-gen-lru-exploit-locality-in-rmap
+++ a/include/linux/mmzone.h
@@ -371,6 +371,7 @@ enum lruvec_flags {
 #ifndef __GENERATING_BOUNDS_H
 
 struct lruvec;
+struct page_vma_mapped_walk;
 
 #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
 #define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
@@ -424,6 +425,7 @@ struct lru_gen_struct {
 };
 
 void lru_gen_init_lruvec(struct lruvec *lruvec);
+void lru_gen_look_around(struct page_vma_mapped_walk *pvmw);
 
 #ifdef CONFIG_MEMCG
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
@@ -436,6 +438,10 @@ static inline void lru_gen_init_lruvec(s
 {
 }
 
+static inline void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+{
+}
+
 #ifdef CONFIG_MEMCG
 static inline void lru_gen_init_memcg(struct mem_cgroup *memcg)
 {
--- a/mm/internal.h~mm-multi-gen-lru-exploit-locality-in-rmap
+++ a/mm/internal.h
@@ -68,6 +68,7 @@ vm_fault_t do_swap_page(struct vm_fault
 void folio_rotate_reclaimable(struct folio *folio);
 bool __folio_end_writeback(struct folio *folio);
 void deactivate_file_folio(struct folio *folio);
+void folio_activate(struct folio *folio);
 
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
--- a/mm/memcontrol.c~mm-multi-gen-lru-exploit-locality-in-rmap
+++ a/mm/memcontrol.c
@@ -2768,6 +2768,7 @@ static void commit_charge(struct folio *
 	 * - LRU isolation
 	 * - lock_page_memcg()
 	 * - exclusive reference
+	 * - mem_cgroup_trylock_pages()
 	 */
 	folio->memcg_data = (unsigned long)memcg;
 }
--- a/mm/rmap.c~mm-multi-gen-lru-exploit-locality-in-rmap
+++ a/mm/rmap.c
@@ -822,6 +822,12 @@ static bool folio_referenced_one(struct
 		}
 
 		if (pvmw.pte) {
+			if (lru_gen_enabled() && pte_young(*pvmw.pte) &&
+			    !(vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))) {
+				lru_gen_look_around(&pvmw);
+				referenced++;
+			}
+
 			if (ptep_clear_flush_young_notify(vma, address,
 						pvmw.pte)) {
 				/*
--- a/mm/swap.c~mm-multi-gen-lru-exploit-locality-in-rmap
+++ a/mm/swap.c
@@ -342,7 +342,7 @@ static bool need_activate_page_drain(int
 	return pagevec_count(&per_cpu(lru_pvecs.activate_page, cpu)) != 0;
 }
 
-static void folio_activate(struct folio *folio)
+void folio_activate(struct folio *folio)
 {
 	if (folio_test_lru(folio) && !folio_test_active(folio) &&
 	    !folio_test_unevictable(folio)) {
@@ -362,7 +362,7 @@ static inline void activate_page_drain(i
 {
 }
 
-static void folio_activate(struct folio *folio)
+void folio_activate(struct folio *folio)
 {
 	struct lruvec *lruvec;
 
--- a/mm/vmscan.c~mm-multi-gen-lru-exploit-locality-in-rmap
+++ a/mm/vmscan.c
@@ -1574,6 +1574,11 @@ retry:
 		if (!sc->may_unmap && page_mapped(page))
 			goto keep_locked;
 
+		/* folio_update_gen() tried to promote this page? */
+		if (lru_gen_enabled() && !ignore_references &&
+		    page_mapped(page) && PageReferenced(page))
+			goto keep_locked;
+
 		/*
 		 * The number of dirty pages determines if a node is marked
 		 * reclaim_congested. kswapd will stall and start writing
@@ -3168,6 +3173,31 @@ static bool positive_ctrl_err(struct ctr
  *                          the aging
  ******************************************************************************/
 
+static int folio_update_gen(struct folio *folio, int gen)
+{
+	unsigned long old_flags, new_flags;
+
+	VM_BUG_ON(gen >= MAX_NR_GENS);
+	VM_BUG_ON(!rcu_read_lock_held());
+
+	do {
+		new_flags = old_flags = READ_ONCE(folio->flags);
+
+		/* for shrink_page_list() */
+		if (!(new_flags & LRU_GEN_MASK)) {
+			new_flags |= BIT(PG_referenced);
+			continue;
+		}
+
+		new_flags &= ~LRU_GEN_MASK;
+		new_flags |= (gen + 1UL) << LRU_GEN_PGOFF;
+		new_flags &= ~(LRU_REFS_MASK | LRU_REFS_FLAGS);
+	} while (new_flags != old_flags &&
+		 cmpxchg(&folio->flags, old_flags, new_flags) != old_flags);
+
+	return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+}
+
 static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
 {
 	unsigned long old_flags, new_flags;
@@ -3179,6 +3209,11 @@ static int folio_inc_gen(struct lruvec *
 		new_flags = old_flags = READ_ONCE(folio->flags);
 		VM_BUG_ON_FOLIO(!(new_flags & LRU_GEN_MASK), folio);
 
+		new_gen = ((new_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+		/* folio_update_gen() has promoted this page? */
+		if (new_gen >= 0 && new_gen != old_gen)
+			return new_gen;
+
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
 
 		new_flags &= ~LRU_GEN_MASK;
@@ -3400,6 +3435,125 @@ static void lru_gen_age_node(struct pgli
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
 }
 
+/*
+ * This function exploits spatial locality when shrink_page_list() walks the
+ * rmap. It scans the adjacent PTEs of a young PTE and promotes hot pages.
+ */
+void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+{
+	int i;
+	pte_t *pte;
+	unsigned long start;
+	unsigned long end;
+	unsigned long addr;
+	unsigned long bitmap[BITS_TO_LONGS(MIN_LRU_BATCH)] = {};
+	struct folio *folio = pfn_folio(pvmw->pfn);
+	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct pglist_data *pgdat = folio_pgdat(folio);
+	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	DEFINE_MAX_SEQ(lruvec);
+	int old_gen, new_gen = lru_gen_from_seq(max_seq);
+
+	lockdep_assert_held(pvmw->ptl);
+	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
+
+	if (spin_is_contended(pvmw->ptl))
+		return;
+
+	start = max(pvmw->address & PMD_MASK, pvmw->vma->vm_start);
+	end = pmd_addr_end(pvmw->address, pvmw->vma->vm_end);
+
+	if (end - start > MIN_LRU_BATCH * PAGE_SIZE) {
+		if (pvmw->address - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
+			end = start + MIN_LRU_BATCH * PAGE_SIZE;
+		else if (end - pvmw->address < MIN_LRU_BATCH * PAGE_SIZE / 2)
+			start = end - MIN_LRU_BATCH * PAGE_SIZE;
+		else {
+			start = pvmw->address - MIN_LRU_BATCH * PAGE_SIZE / 2;
+			end = pvmw->address + MIN_LRU_BATCH * PAGE_SIZE / 2;
+		}
+	}
+
+	pte = pvmw->pte - (pvmw->address - start) / PAGE_SIZE;
+
+	rcu_read_lock();
+	arch_enter_lazy_mmu_mode();
+
+	for (i = 0, addr = start; addr != end; i++, addr += PAGE_SIZE) {
+		unsigned long pfn = pte_pfn(pte[i]);
+
+		VM_BUG_ON(addr < pvmw->vma->vm_start || addr >= pvmw->vma->vm_end);
+
+		if (!pte_present(pte[i]) || is_zero_pfn(pfn))
+			continue;
+
+		if (WARN_ON_ONCE(pte_devmap(pte[i]) || pte_special(pte[i])))
+			continue;
+
+		if (!pte_young(pte[i]))
+			continue;
+
+		VM_BUG_ON(!pfn_valid(pfn));
+		if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
+			continue;
+
+		folio = pfn_folio(pfn);
+		if (folio_nid(folio) != pgdat->node_id)
+			continue;
+
+		if (folio_memcg_rcu(folio) != memcg)
+			continue;
+
+		if (!ptep_test_and_clear_young(pvmw->vma, addr, pte + i))
+			continue;
+
+		if (pte_dirty(pte[i]) && !folio_test_dirty(folio) &&
+		    !(folio_test_anon(folio) && folio_test_swapbacked(folio) &&
+		      !folio_test_swapcache(folio)))
+			folio_mark_dirty(folio);
+
+		old_gen = folio_lru_gen(folio);
+		if (old_gen < 0)
+			folio_set_referenced(folio);
+		else if (old_gen != new_gen)
+			__set_bit(i, bitmap);
+	}
+
+	arch_leave_lazy_mmu_mode();
+	rcu_read_unlock();
+
+	if (bitmap_weight(bitmap, MIN_LRU_BATCH) < PAGEVEC_SIZE) {
+		for_each_set_bit(i, bitmap, MIN_LRU_BATCH) {
+			folio = pfn_folio(pte_pfn(pte[i]));
+			folio_activate(folio);
+		}
+		return;
+	}
+
+	/* folio_update_gen() requires stable folio_memcg() */
+	if (!mem_cgroup_trylock_pages(memcg))
+		return;
+
+	spin_lock_irq(&lruvec->lru_lock);
+	new_gen = lru_gen_from_seq(lruvec->lrugen.max_seq);
+
+	for_each_set_bit(i, bitmap, MIN_LRU_BATCH) {
+		folio = pfn_folio(pte_pfn(pte[i]));
+		if (folio_memcg_rcu(folio) != memcg)
+			continue;
+
+		old_gen = folio_update_gen(folio, new_gen);
+		if (old_gen < 0 || old_gen == new_gen)
+			continue;
+
+		lru_gen_update_size(lruvec, folio, old_gen, new_gen);
+	}
+
+	spin_unlock_irq(&lruvec->lru_lock);
+
+	mem_cgroup_unlock_pages();
+}
+
 /******************************************************************************
  *                          the eviction
  ******************************************************************************/
@@ -3433,6 +3587,11 @@ static bool sort_folio(struct lruvec *lr
 		return true;
 	}
 
+	if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
+		list_move(&folio->lru, &lrugen->lists[gen][type][zone]);
+		return true;
+	}
+
 	if (tier > tier_idx) {
 		int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-x86-arm64-add-arch_has_hw_pte_young.patch
mm-x86-add-config_arch_has_nonleaf_pmd_young.patch
mm-vmscanc-refactor-shrink_node.patch
revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller.patch
mm-multi-gen-lru-groundwork.patch
mm-multi-gen-lru-minimal-implementation.patch
mm-multi-gen-lru-exploit-locality-in-rmap.patch
mm-multi-gen-lru-support-page-table-walks.patch
mm-multi-gen-lru-optimize-multiple-memcgs.patch
mm-multi-gen-lru-kill-switch.patch
mm-multi-gen-lru-thrashing-prevention.patch
mm-multi-gen-lru-debugfs-interface.patch
mm-multi-gen-lru-admin-guide.patch
mm-multi-gen-lru-design-doc.patch

