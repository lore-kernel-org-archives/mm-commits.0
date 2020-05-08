From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch added to -mm tree
Date: Fri, 08 May 2020 16:19:56 -0700
Message-ID: <20200508231956.jn8jbykgC%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbgEHXT6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 19:19:58 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm: memcontrol: switch to native NR_ANON_THPS counter
has been added to the -mm tree.  Its filename is
     mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: switch to native NR_ANON_THPS counter

With rmap memcg locking already in place for NR_ANON_MAPPED, it's just a
small step to remove the MEMCG_RSS_HUGE wart and switch memcg to the
native NR_ANON_THPS accounting sites.

Link: http://lkml.kernel.org/r/20200508183105.225460-12-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 --
 mm/huge_memory.c           |    4 ++-
 mm/memcontrol.c            |   39 ++++++++++++++---------------------
 mm/rmap.c                  |    6 ++---
 4 files changed, 23 insertions(+), 29 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-switch-to-native-nr_anon_thps-counter
+++ a/include/linux/memcontrol.h
@@ -29,8 +29,7 @@ struct kmem_cache;
 
 /* Cgroup-specific page state, on top of universal node page state */
 enum memcg_stat_item {
-	MEMCG_RSS_HUGE = NR_VM_NODE_STAT_ITEMS,
-	MEMCG_SWAP,
+	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_SOCK,
 	/* XXX: why are these zone and not node counters? */
 	MEMCG_KERNEL_STACK_KB,
--- a/mm/huge_memory.c~mm-memcontrol-switch-to-native-nr_anon_thps-counter
+++ a/mm/huge_memory.c
@@ -2360,15 +2360,17 @@ static void __split_huge_pmd_locked(stru
 			atomic_inc(&page[i]._mapcount);
 	}
 
+	lock_page_memcg(page);
 	if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
 		/* Last compound_mapcount is gone. */
-		__dec_node_page_state(page, NR_ANON_THPS);
+		__dec_lruvec_page_state(page, NR_ANON_THPS);
 		if (TestClearPageDoubleMap(page)) {
 			/* No need in mapcount reference anymore */
 			for (i = 0; i < HPAGE_PMD_NR; i++)
 				atomic_dec(&page[i]._mapcount);
 		}
 	}
+	unlock_page_memcg(page);
 
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
--- a/mm/memcontrol.c~mm-memcontrol-switch-to-native-nr_anon_thps-counter
+++ a/mm/memcontrol.c
@@ -836,11 +836,6 @@ static void mem_cgroup_charge_statistics
 					 struct page *page,
 					 int nr_pages)
 {
-	if (abs(nr_pages) > 1) {
-		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
-		__mod_memcg_state(memcg, MEMCG_RSS_HUGE, nr_pages);
-	}
-
 	/* pagein of a big page is an event. So, ignore page size */
 	if (nr_pages > 0)
 		__count_memcg_events(memcg, PGPGIN, 1);
@@ -1406,15 +1401,9 @@ static char *memory_stat_format(struct m
 		       (u64)memcg_page_state(memcg, NR_WRITEBACK) *
 		       PAGE_SIZE);
 
-	/*
-	 * TODO: We should eventually replace our own MEMCG_RSS_HUGE counter
-	 * with the NR_ANON_THP vm counter, but right now it's a pain in the
-	 * arse because it requires migrating the work out of rmap to a place
-	 * where the page->mem_cgroup is set up and stable.
-	 */
 	seq_buf_printf(&s, "anon_thp %llu\n",
-		       (u64)memcg_page_state(memcg, MEMCG_RSS_HUGE) *
-		       PAGE_SIZE);
+		       (u64)memcg_page_state(memcg, NR_ANON_THPS) *
+		       HPAGE_PMD_NR * PAGE_SIZE);
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
 		seq_buf_printf(&s, "%s %llu\n", lru_list_name(i),
@@ -3008,8 +2997,6 @@ void mem_cgroup_split_huge_fixup(struct
 
 	for (i = 1; i < HPAGE_PMD_NR; i++)
 		head[i].mem_cgroup = head->mem_cgroup;
-
-	__mod_memcg_state(head->mem_cgroup, MEMCG_RSS_HUGE, -HPAGE_PMD_NR);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -3765,7 +3752,7 @@ static int memcg_numa_stat_show(struct s
 static const unsigned int memcg1_stats[] = {
 	NR_FILE_PAGES,
 	NR_ANON_MAPPED,
-	MEMCG_RSS_HUGE,
+	NR_ANON_THPS,
 	NR_SHMEM,
 	NR_FILE_MAPPED,
 	NR_FILE_DIRTY,
@@ -3802,11 +3789,14 @@ static int memcg_stat_show(struct seq_fi
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
+		unsigned long nr;
+
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
-		seq_printf(m, "%s %lu\n", memcg1_stat_names[i],
-			   memcg_page_state_local(memcg, memcg1_stats[i]) *
-			   PAGE_SIZE);
+		nr = memcg_page_state_local(memcg, memcg1_stats[i]);
+		if (memcg1_stats[i] == NR_ANON_THPS)
+			nr *= HPAGE_PMD_NR;
+		seq_printf(m, "%s %lu\n", memcg1_stat_names[i], nr * PAGE_SIZE);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
@@ -5398,6 +5388,13 @@ static int mem_cgroup_move_account(struc
 		if (page_mapped(page)) {
 			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
 			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
+			if (PageTransHuge(page)) {
+				__mod_lruvec_state(from_vec, NR_ANON_THPS,
+						   -nr_pages);
+				__mod_lruvec_state(to_vec, NR_ANON_THPS,
+						   nr_pages);
+			}
+
 		}
 	} else {
 		__mod_lruvec_state(from_vec, NR_FILE_PAGES, -nr_pages);
@@ -6611,7 +6608,6 @@ struct uncharge_gather {
 	unsigned long nr_pages;
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
-	unsigned long nr_huge;
 	struct page *dummy_page;
 };
 
@@ -6634,7 +6630,6 @@ static void uncharge_batch(const struct
 	}
 
 	local_irq_save(flags);
-	__mod_memcg_state(ug->memcg, MEMCG_RSS_HUGE, -ug->nr_huge);
 	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
 	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_pages);
 	memcg_check_events(ug->memcg, ug->dummy_page);
@@ -6671,8 +6666,6 @@ static void uncharge_page(struct page *p
 	ug->nr_pages += nr_pages;
 
 	if (!PageKmemcg(page)) {
-		if (PageTransHuge(page))
-			ug->nr_huge += nr_pages;
 		ug->pgpgout++;
 	} else {
 		ug->nr_kmem += nr_pages;
--- a/mm/rmap.c~mm-memcontrol-switch-to-native-nr_anon_thps-counter
+++ a/mm/rmap.c
@@ -1138,7 +1138,7 @@ void do_page_add_anon_rmap(struct page *
 		 * disabled.
 		 */
 		if (compound)
-			__inc_node_page_state(page, NR_ANON_THPS);
+			__inc_lruvec_page_state(page, NR_ANON_THPS);
 		__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
 	}
 
@@ -1180,7 +1180,7 @@ void page_add_new_anon_rmap(struct page
 		if (hpage_pincount_available(page))
 			atomic_set(compound_pincount_ptr(page), 0);
 
-		__inc_node_page_state(page, NR_ANON_THPS);
+		__inc_lruvec_page_state(page, NR_ANON_THPS);
 	} else {
 		/* Anon THP always mapped first with PMD */
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
@@ -1286,7 +1286,7 @@ static void page_remove_anon_compound_rm
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		return;
 
-	__dec_node_page_state(page, NR_ANON_THPS);
+	__dec_lruvec_page_state(page, NR_ANON_THPS);
 
 	if (TestClearPageDoubleMap(page)) {
 		/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-numa-node-file-count-error-in-replace_page_cache.patch
mm-memcontrol-fix-stat-corrupting-race-in-charge-moving.patch
mm-memcontrol-drop-compound-parameter-from-memcg-charging-api.patch
mm-memcontrol-move-out-cgroup-swaprate-throttling.patch
mm-memcontrol-convert-page-cache-to-a-new-mem_cgroup_charge-api.patch
mm-memcontrol-prepare-uncharging-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-move_account-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-cgroup-vmstat-infrastructure-for-native-anon-counters.patch
mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters.patch
mm-memcontrol-switch-to-native-nr_anon_mapped-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch
mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch
mm-memcontrol-prepare-swap-controller-setup-for-integration.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control.patch
mm-memcontrol-charge-swapin-pages-on-instantiation.patch
mm-memcontrol-delete-unused-lrucare-handling.patch
mm-memcontrol-update-page-mem_cgroup-stability-rules.patch
