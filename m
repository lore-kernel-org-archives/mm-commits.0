Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE41C2BB41
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 19:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237632AbiHQTFk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 15:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239958AbiHQTFD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 15:05:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F7247B99
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 12:05:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05F59B81F05
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 19:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F10C433D6;
        Wed, 17 Aug 2022 19:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660763098;
        bh=wu2x30xynX9Z1u51ko/T8jI+RlSeby4gMzzKpxTHBGU=;
        h=Date:To:From:Subject:From;
        b=tGqRv0iEFmo8sqzbd92nRh/F6J3gPPdPZOYCKZKCF+Wg/3us2gIt+HYPOwh1nfMZv
         gXZPO2WQUGZaIe8NPr4cnGuPD1+jkPulgw/8CUQpCesOQbpUiw+lcW/fDitvvYhqMX
         V8ZgtXN81e/csnJWQCGQDvx0UjFtJd6QWVm0VOmI=
Date:   Wed, 17 Aug 2022 12:04:57 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, will@kernel.org, vbabka@suse.cz,
        vaibhav@linux.ibm.com, tj@kernel.org, szhai2@cs.rochester.edu,
        suleiman@google.com, steven@liquorix.net, sofia.trinh@edi.works,
        rppt@kernel.org, peterz@infradead.org, oleksandr@natalenko.name,
        Michael@MichaelLarabel.com, mhocko@kernel.org, mgorman@suse.de,
        linmiaohe@huawei.com, holger@applied-asynchrony.com,
        Hi-Angel@yandex.ru, heftig@archlinux.org, hdanton@sina.com,
        hannes@cmpxchg.org, djbyrne@mtu.edu, d@chaos-reins.com,
        dave.hansen@linux.intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bgeffon@google.com, baohua@kernel.org,
        axboe@kernel.dk, aneesh.kumar@linux.ibm.com, ak@linux.intel.com,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-exploit-locality-in-rmap.patch added to mm-unstable branch
Message-Id: <20220817190458.A7F10C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: exploit locality in rmap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-exploit-locality-in-rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-exploit-locality-in-rmap.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: exploit locality in rmap
Date: Mon, 15 Aug 2022 01:13:26 -0600

Searching the rmap for PTEs mapping each page on an LRU list (to test and
clear the accessed bit) can be expensive because pages from different VMAs
(PA space) are not cache friendly to the rmap (VA space).  For workloads
mostly using mapped pages, searching the rmap can incur the highest CPU
cost in the reclaim path.

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
    memcached (anon): +[3, 5]%
                Ops/sec      KB/sec
      patch1-6: 1106168.46   43025.04
      patch1-7: 1147696.57   44640.29

  Configurations:
    no change

Client benchmark results:
  kswapd profiles:
    patch1-6
      39.03%  lzo1x_1_do_compress (real work)
      18.47%  page_vma_mapped_walk (overhead)
       6.74%  _raw_spin_unlock_irq
       3.97%  do_raw_spin_lock
       2.49%  ptep_clear_flush
       2.48%  anon_vma_interval_tree_iter_first
       1.92%  folio_referenced_one
       1.88%  __zram_bvec_write
       1.48%  memmove
       1.31%  vma_interval_tree_iter_next

    patch1-7
      48.16%  lzo1x_1_do_compress (real work)
       8.20%  page_vma_mapped_walk (overhead)
       7.06%  _raw_spin_unlock_irq
       2.92%  ptep_clear_flush
       2.53%  __zram_bvec_write
       2.11%  do_raw_spin_lock
       2.02%  memmove
       1.93%  lru_gen_look_around
       1.56%  free_unref_page_list
       1.40%  memset

  Configurations:
    no change

Link: https://lkml.kernel.org/r/20220815071332.627393-8-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Barry Song <baohua@kernel.org>
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
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Larabel <Michael@MichaelLarabel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   31 +++++
 include/linux/mm.h         |    5 
 include/linux/mmzone.h     |    6 +
 mm/internal.h              |    1 
 mm/memcontrol.c            |    1 
 mm/rmap.c                  |    6 +
 mm/swap.c                  |    4 
 mm/vmscan.c                |  184 +++++++++++++++++++++++++++++++++++
 8 files changed, 236 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~mm-multi-gen-lru-exploit-locality-in-rmap
+++ a/include/linux/memcontrol.h
@@ -444,6 +444,7 @@ static inline struct obj_cgroup *__folio
  * - LRU isolation
  * - lock_page_memcg()
  * - exclusive reference
+ * - mem_cgroup_trylock_pages()
  *
  * For a kmem folio a caller should hold an rcu read lock to protect memcg
  * associated with a kmem folio from being released.
@@ -505,6 +506,7 @@ static inline struct mem_cgroup *folio_m
  * - LRU isolation
  * - lock_page_memcg()
  * - exclusive reference
+ * - mem_cgroup_trylock_pages()
  *
  * For a kmem page a caller should hold an rcu read lock to protect memcg
  * associated with a kmem page from being released.
@@ -959,6 +961,23 @@ void unlock_page_memcg(struct page *page
 
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
@@ -1433,6 +1452,18 @@ static inline void folio_memcg_unlock(st
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
@@ -1490,6 +1490,11 @@ static inline unsigned long folio_pfn(st
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
@@ -375,6 +375,7 @@ enum lruvec_flags {
 #ifndef __GENERATING_BOUNDS_H
 
 struct lruvec;
+struct page_vma_mapped_walk;
 
 #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
 #define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
@@ -430,6 +431,7 @@ struct lru_gen_struct {
 };
 
 void lru_gen_init_lruvec(struct lruvec *lruvec);
+void lru_gen_look_around(struct page_vma_mapped_walk *pvmw);
 
 #ifdef CONFIG_MEMCG
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
@@ -442,6 +444,10 @@ static inline void lru_gen_init_lruvec(s
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
@@ -83,6 +83,7 @@ vm_fault_t do_swap_page(struct vm_fault
 void folio_rotate_reclaimable(struct folio *folio);
 bool __folio_end_writeback(struct folio *folio);
 void deactivate_file_folio(struct folio *folio);
+void folio_activate(struct folio *folio);
 
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
--- a/mm/memcontrol.c~mm-multi-gen-lru-exploit-locality-in-rmap
+++ a/mm/memcontrol.c
@@ -2789,6 +2789,7 @@ static void commit_charge(struct folio *
 	 * - LRU isolation
 	 * - lock_page_memcg()
 	 * - exclusive reference
+	 * - mem_cgroup_trylock_pages()
 	 */
 	folio->memcg_data = (unsigned long)memcg;
 }
--- a/mm/rmap.c~mm-multi-gen-lru-exploit-locality-in-rmap
+++ a/mm/rmap.c
@@ -825,6 +825,12 @@ static bool folio_referenced_one(struct
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
@@ -366,7 +366,7 @@ static void folio_activate_drain(int cpu
 		folio_batch_move_lru(fbatch, folio_activate_fn);
 }
 
-static void folio_activate(struct folio *folio)
+void folio_activate(struct folio *folio)
 {
 	if (folio_test_lru(folio) && !folio_test_active(folio) &&
 	    !folio_test_unevictable(folio)) {
@@ -385,7 +385,7 @@ static inline void folio_activate_drain(
 {
 }
 
-static void folio_activate(struct folio *folio)
+void folio_activate(struct folio *folio)
 {
 	struct lruvec *lruvec;
 
--- a/mm/vmscan.c~mm-multi-gen-lru-exploit-locality-in-rmap
+++ a/mm/vmscan.c
@@ -1635,6 +1635,11 @@ retry:
 		if (!sc->may_unmap && folio_mapped(folio))
 			goto keep_locked;
 
+		/* folio_update_gen() tried to promote this page? */
+		if (lru_gen_enabled() && !ignore_references &&
+		    folio_mapped(folio) && folio_test_referenced(folio))
+			goto keep_locked;
+
 		/*
 		 * The number of dirty pages determines if a node is marked
 		 * reclaim_congested. kswapd will stall and start writing
@@ -3219,6 +3224,29 @@ static bool positive_ctrl_err(struct ctr
  *                          the aging
  ******************************************************************************/
 
+/* promote pages accessed through page tables */
+static int folio_update_gen(struct folio *folio, int gen)
+{
+	unsigned long new_flags, old_flags = READ_ONCE(folio->flags);
+
+	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
+	VM_WARN_ON_ONCE(!rcu_read_lock_held());
+
+	do {
+		/* lru_gen_del_folio() has isolated this page? */
+		if (!(old_flags & LRU_GEN_MASK)) {
+			/* for shrink_page_list() */
+			new_flags = old_flags | BIT(PG_referenced);
+			continue;
+		}
+
+		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_MASK | LRU_REFS_FLAGS);
+		new_flags |= (gen + 1UL) << LRU_GEN_PGOFF;
+	} while (!try_cmpxchg(&folio->flags, &old_flags, new_flags));
+
+	return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+}
+
 /* protect pages accessed multiple times through file descriptors */
 static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
 {
@@ -3230,6 +3258,11 @@ static int folio_inc_gen(struct lruvec *
 	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
 
 	do {
+		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+		/* folio_update_gen() has promoted this page? */
+		if (new_gen >= 0 && new_gen != old_gen)
+			return new_gen;
+
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
 
 		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_MASK | LRU_REFS_FLAGS);
@@ -3244,6 +3277,43 @@ static int folio_inc_gen(struct lruvec *
 	return new_gen;
 }
 
+static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned long addr)
+{
+	unsigned long pfn = pte_pfn(pte);
+
+	VM_WARN_ON_ONCE(addr < vma->vm_start || addr >= vma->vm_end);
+
+	if (!pte_present(pte) || is_zero_pfn(pfn))
+		return -1;
+
+	if (WARN_ON_ONCE(pte_devmap(pte) || pte_special(pte)))
+		return -1;
+
+	if (WARN_ON_ONCE(!pfn_valid(pfn)))
+		return -1;
+
+	return pfn;
+}
+
+static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
+				   struct pglist_data *pgdat)
+{
+	struct folio *folio;
+
+	/* try to avoid unnecessary memory loads */
+	if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
+		return NULL;
+
+	folio = pfn_folio(pfn);
+	if (folio_nid(folio) != pgdat->node_id)
+		return NULL;
+
+	if (folio_memcg_rcu(folio) != memcg)
+		return NULL;
+
+	return folio;
+}
+
 static void inc_min_seq(struct lruvec *lruvec, int type)
 {
 	struct lru_gen_struct *lrugen = &lruvec->lrugen;
@@ -3445,6 +3515,114 @@ static void lru_gen_age_node(struct pgli
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
+	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
+
+	if (spin_is_contended(pvmw->ptl))
+		return;
+
+	start = max(pvmw->address & PMD_MASK, pvmw->vma->vm_start);
+	end = min(pvmw->address | ~PMD_MASK, pvmw->vma->vm_end - 1) + 1;
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
+		unsigned long pfn;
+
+		pfn = get_pte_pfn(pte[i], pvmw->vma, addr);
+		if (pfn == -1)
+			continue;
+
+		if (!pte_young(pte[i]))
+			continue;
+
+		folio = get_pfn_folio(pfn, memcg, pgdat);
+		if (!folio)
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
@@ -3481,6 +3659,12 @@ static bool sort_folio(struct lruvec *lr
 		return true;
 	}
 
+	/* promoted */
+	if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
+		list_move(&folio->lru, &lrugen->lists[gen][type][zone]);
+		return true;
+	}
+
 	/* protected */
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

