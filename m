From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 mm-memcontrol-switch-to-native-nr_anon_thps-counter-fix.patch removed from
 -mm tree
Date: Wed, 03 Jun 2020 15:16:24 -0700
Message-ID: <20200603221624.8l_Ifzcc6%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgFCWQ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:16:26 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bsingharora@gmail.com, geert@linux-m68k.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org, naresh.kamboju@linaro.org, rdunlap@infradead.org, sfr@canb.auug.org.au


The patch titled
     Subject: mm-memcontrol-switch-to-native-nr_anon_thps-counter-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-switch-to-native-nr_anon_thps-counter-fix.patch

This patch was dropped because it was folded into mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-memcontrol-switch-to-native-nr_anon_thps-counter-fix

The THP page size macros are CONFIG_TRANSPARENT_HUGEPAGE only.

We already ifdef most THP-related code in memcg, but not these
particular stats. Memcg used to track the pages as they came in, and
PageTransHuge() + hpage_nr_pages() work when THP is not compiled in.

Switching to native vmstat counters, memcg doesn't see the pages, it
only gets a count of THPs. To translate that to bytes, it has to know
how big the THPs are - and that's only available for CONFIG_THP.

Add the necessary ifdefs.  /proc/meminfo, smaps etc.  also don't show the
THP counters when the feature is compiled out.  The event counts
(THP_FAULT_ALLOC, THP_COLLAPSE_ALLOC) were already conditional also.

Style touchup: HPAGE_PMD_NR * PAGE_SIZE is silly. Use HPAGE_PMD_SIZE.

Link: http://lkml.kernel.org/r/20200512121750.GA397968@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>	[build-tested]
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-switch-to-native-nr_anon_thps-counter-fix
+++ a/mm/memcontrol.c
@@ -1401,9 +1401,11 @@ static char *memory_stat_format(struct m
 		       (u64)memcg_page_state(memcg, NR_WRITEBACK) *
 		       PAGE_SIZE);
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	seq_buf_printf(&s, "anon_thp %llu\n",
 		       (u64)memcg_page_state(memcg, NR_ANON_THPS) *
-		       HPAGE_PMD_NR * PAGE_SIZE);
+		       HPAGE_PMD_SIZE);
+#endif
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
 		seq_buf_printf(&s, "%s %llu\n", lru_list_name(i),
@@ -3805,7 +3807,9 @@ static int memcg_numa_stat_show(struct s
 static const unsigned int memcg1_stats[] = {
 	NR_FILE_PAGES,
 	NR_ANON_MAPPED,
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	NR_ANON_THPS,
+#endif
 	NR_SHMEM,
 	NR_FILE_MAPPED,
 	NR_FILE_DIRTY,
@@ -3816,7 +3820,9 @@ static const unsigned int memcg1_stats[]
 static const char *const memcg1_stat_names[] = {
 	"cache",
 	"rss",
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	"rss_huge",
+#endif
 	"shmem",
 	"mapped_file",
 	"dirty",
@@ -3847,8 +3853,10 @@ static int memcg_stat_show(struct seq_fi
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		nr = memcg_page_state_local(memcg, memcg1_stats[i]);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		if (memcg1_stats[i] == NR_ANON_THPS)
 			nr *= HPAGE_PMD_NR;
+#endif
 		seq_printf(m, "%s %lu\n", memcg1_stat_names[i], nr * PAGE_SIZE);
 	}
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-numa-node-file-count-error-in-replace_page_cache.patch
mm-memcontrol-fix-stat-corrupting-race-in-charge-moving.patch
mm-memcontrol-drop-compound-parameter-from-memcg-charging-api.patch
mm-shmem-remove-rare-optimization-when-swapin-races-with-hole-punching.patch
mm-memcontrol-move-out-cgroup-swaprate-throttling.patch
mm-memcontrol-convert-page-cache-to-a-new-mem_cgroup_charge-api.patch
mm-memcontrol-prepare-uncharging-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-move_account-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-cgroup-vmstat-infrastructure-for-native-anon-counters.patch
mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters.patch
mm-memcontrol-switch-to-native-nr_anon_mapped-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix.patch
mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch
mm-memcontrol-prepare-swap-controller-setup-for-integration.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control-fix-v2.patch
mm-memcontrol-charge-swapin-pages-on-instantiation.patch
mm-memcontrol-delete-unused-lrucare-handling.patch
mm-memcontrol-update-page-mem_cgroup-stability-rules.patch
mm-fix-lru-balancing-effect-of-new-transparent-huge-pages.patch
mm-keep-separate-anon-and-file-statistics-on-page-reclaim-activity.patch
mm-allow-swappiness-that-prefers-reclaiming-anon-over-the-file-workingset.patch
mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file.patch
mm-workingset-let-cache-workingset-challenge-anon.patch
mm-remove-use-once-cache-bias-from-lru-balancing.patch
mm-vmscan-drop-unnecessary-div0-avoidance-rounding-in-get_scan_count.patch
mm-base-lru-balancing-on-an-explicit-cost-model.patch
mm-deactivations-shouldnt-bias-the-lru-balance.patch
mm-only-count-actual-rotations-as-lru-reclaim-cost.patch
mm-balance-lru-lists-based-on-relative-thrashing.patch
mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root.patch
mm-vmscan-reclaim-writepage-is-io-cost.patch
mm-vmscan-limit-the-range-of-lru-type-balancing.patch
