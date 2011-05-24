From: akpm@linux-foundation.org
Subject: [folded] mm-per-node-vmstat-show-proper-vmstats-fix-2.patch removed from -mm tree
Date: Tue, 24 May 2011 16:52:14 -0700
Message-ID: <201105242352.p4ONqE1A023622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932094Ab1EXXwW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 19:52:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, mrubin@google.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     vmstat: fix build error when SYSFS=y and PROC_FS=n
has been removed from the -mm tree.  Its filename was
     mm-per-node-vmstat-show-proper-vmstats-fix-2.patch

This patch was dropped because it was folded into mm-per-node-vmstat-show-proper-vmstats.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmstat: fix build error when SYSFS=y and PROC_FS=n
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Randy Dunlap pointed out node.c makes build error when PROC_FS=n.  Because
node.c#node_read_vmstat() uses vmstat_text and it depend on PROC_FS.

Thus, this patch change it to depend both SYSFS and PROC_FS.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |  261 +++++++++++++++++++++++++-------------------------
 1 file changed, 132 insertions(+), 129 deletions(-)

diff -puN mm/vmstat.c~mm-per-node-vmstat-show-proper-vmstats-fix-2 mm/vmstat.c
--- a/mm/vmstat.c~mm-per-node-vmstat-show-proper-vmstats-fix-2
+++ a/mm/vmstat.c
@@ -659,6 +659,138 @@ static void walk_zones_in_node(struct se
 }
 #endif
 
+#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS)
+#ifdef CONFIG_ZONE_DMA
+#define TEXT_FOR_DMA(xx) xx "_dma",
+#else
+#define TEXT_FOR_DMA(xx)
+#endif
+
+#ifdef CONFIG_ZONE_DMA32
+#define TEXT_FOR_DMA32(xx) xx "_dma32",
+#else
+#define TEXT_FOR_DMA32(xx)
+#endif
+
+#ifdef CONFIG_HIGHMEM
+#define TEXT_FOR_HIGHMEM(xx) xx "_high",
+#else
+#define TEXT_FOR_HIGHMEM(xx)
+#endif
+
+#define TEXTS_FOR_ZONES(xx) TEXT_FOR_DMA(xx) TEXT_FOR_DMA32(xx) xx "_normal", \
+					TEXT_FOR_HIGHMEM(xx) xx "_movable",
+
+const char * const vmstat_text[] = {
+	/* Zoned VM counters */
+	"nr_free_pages",
+	"nr_inactive_anon",
+	"nr_active_anon",
+	"nr_inactive_file",
+	"nr_active_file",
+	"nr_unevictable",
+	"nr_mlock",
+	"nr_anon_pages",
+	"nr_mapped",
+	"nr_file_pages",
+	"nr_dirty",
+	"nr_writeback",
+	"nr_slab_reclaimable",
+	"nr_slab_unreclaimable",
+	"nr_page_table_pages",
+	"nr_kernel_stack",
+	"nr_unstable",
+	"nr_bounce",
+	"nr_vmscan_write",
+	"nr_writeback_temp",
+	"nr_isolated_anon",
+	"nr_isolated_file",
+	"nr_shmem",
+	"nr_dirtied",
+	"nr_written",
+
+#ifdef CONFIG_NUMA
+	"numa_hit",
+	"numa_miss",
+	"numa_foreign",
+	"numa_interleave",
+	"numa_local",
+	"numa_other",
+#endif
+	"nr_anon_transparent_hugepages",
+	"nr_dirty_threshold",
+	"nr_dirty_background_threshold",
+
+#ifdef CONFIG_VM_EVENT_COUNTERS
+	"pgpgin",
+	"pgpgout",
+	"pswpin",
+	"pswpout",
+
+	TEXTS_FOR_ZONES("pgalloc")
+
+	"pgfree",
+	"pgactivate",
+	"pgdeactivate",
+
+	"pgfault",
+	"pgmajfault",
+
+	TEXTS_FOR_ZONES("pgrefill")
+	TEXTS_FOR_ZONES("pgsteal")
+	TEXTS_FOR_ZONES("pgscan_kswapd")
+	TEXTS_FOR_ZONES("pgscan_direct")
+
+#ifdef CONFIG_NUMA
+	"zone_reclaim_failed",
+#endif
+	"pginodesteal",
+	"slabs_scanned",
+	"kswapd_steal",
+	"kswapd_inodesteal",
+	"kswapd_low_wmark_hit_quickly",
+	"kswapd_high_wmark_hit_quickly",
+	"kswapd_skip_congestion_wait",
+	"pageoutrun",
+	"allocstall",
+
+	"pgrotated",
+
+#ifdef CONFIG_COMPACTION
+	"compact_blocks_moved",
+	"compact_pages_moved",
+	"compact_pagemigrate_failed",
+	"compact_stall",
+	"compact_fail",
+	"compact_success",
+#endif
+
+#ifdef CONFIG_HUGETLB_PAGE
+	"htlb_buddy_alloc_success",
+	"htlb_buddy_alloc_fail",
+#endif
+	"unevictable_pgs_culled",
+	"unevictable_pgs_scanned",
+	"unevictable_pgs_rescued",
+	"unevictable_pgs_mlocked",
+	"unevictable_pgs_munlocked",
+	"unevictable_pgs_cleared",
+	"unevictable_pgs_stranded",
+	"unevictable_pgs_mlockfreed",
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	"thp_fault_alloc",
+	"thp_fault_fallback",
+	"thp_collapse_alloc",
+	"thp_collapse_alloc_failed",
+	"thp_split",
+#endif
+
+#endif /* CONFIG_VM_EVENTS_COUNTERS */
+};
+#endif /* CONFIG_PROC_FS || CONFIG_SYSFS */
+
+
 #ifdef CONFIG_PROC_FS
 static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
 						struct zone *zone)
@@ -831,135 +963,6 @@ static const struct file_operations page
 	.release	= seq_release,
 };
 
-#ifdef CONFIG_ZONE_DMA
-#define TEXT_FOR_DMA(xx) xx "_dma",
-#else
-#define TEXT_FOR_DMA(xx)
-#endif
-
-#ifdef CONFIG_ZONE_DMA32
-#define TEXT_FOR_DMA32(xx) xx "_dma32",
-#else
-#define TEXT_FOR_DMA32(xx)
-#endif
-
-#ifdef CONFIG_HIGHMEM
-#define TEXT_FOR_HIGHMEM(xx) xx "_high",
-#else
-#define TEXT_FOR_HIGHMEM(xx)
-#endif
-
-#define TEXTS_FOR_ZONES(xx) TEXT_FOR_DMA(xx) TEXT_FOR_DMA32(xx) xx "_normal", \
-					TEXT_FOR_HIGHMEM(xx) xx "_movable",
-
-const char * const vmstat_text[] = {
-	/* Zoned VM counters */
-	"nr_free_pages",
-	"nr_inactive_anon",
-	"nr_active_anon",
-	"nr_inactive_file",
-	"nr_active_file",
-	"nr_unevictable",
-	"nr_mlock",
-	"nr_anon_pages",
-	"nr_mapped",
-	"nr_file_pages",
-	"nr_dirty",
-	"nr_writeback",
-	"nr_slab_reclaimable",
-	"nr_slab_unreclaimable",
-	"nr_page_table_pages",
-	"nr_kernel_stack",
-	"nr_unstable",
-	"nr_bounce",
-	"nr_vmscan_write",
-	"nr_writeback_temp",
-	"nr_isolated_anon",
-	"nr_isolated_file",
-	"nr_shmem",
-	"nr_dirtied",
-	"nr_written",
-
-#ifdef CONFIG_NUMA
-	"numa_hit",
-	"numa_miss",
-	"numa_foreign",
-	"numa_interleave",
-	"numa_local",
-	"numa_other",
-#endif
-	"nr_anon_transparent_hugepages",
-	"nr_dirty_threshold",
-	"nr_dirty_background_threshold",
-
-#ifdef CONFIG_VM_EVENT_COUNTERS
-	"pgpgin",
-	"pgpgout",
-	"pswpin",
-	"pswpout",
-
-	TEXTS_FOR_ZONES("pgalloc")
-
-	"pgfree",
-	"pgactivate",
-	"pgdeactivate",
-
-	"pgfault",
-	"pgmajfault",
-
-	TEXTS_FOR_ZONES("pgrefill")
-	TEXTS_FOR_ZONES("pgsteal")
-	TEXTS_FOR_ZONES("pgscan_kswapd")
-	TEXTS_FOR_ZONES("pgscan_direct")
-
-#ifdef CONFIG_NUMA
-	"zone_reclaim_failed",
-#endif
-	"pginodesteal",
-	"slabs_scanned",
-	"kswapd_steal",
-	"kswapd_inodesteal",
-	"kswapd_low_wmark_hit_quickly",
-	"kswapd_high_wmark_hit_quickly",
-	"kswapd_skip_congestion_wait",
-	"pageoutrun",
-	"allocstall",
-
-	"pgrotated",
-
-#ifdef CONFIG_COMPACTION
-	"compact_blocks_moved",
-	"compact_pages_moved",
-	"compact_pagemigrate_failed",
-	"compact_stall",
-	"compact_fail",
-	"compact_success",
-#endif
-
-#ifdef CONFIG_HUGETLB_PAGE
-	"htlb_buddy_alloc_success",
-	"htlb_buddy_alloc_fail",
-#endif
-	"unevictable_pgs_culled",
-	"unevictable_pgs_scanned",
-	"unevictable_pgs_rescued",
-	"unevictable_pgs_mlocked",
-	"unevictable_pgs_munlocked",
-	"unevictable_pgs_cleared",
-	"unevictable_pgs_stranded",
-	"unevictable_pgs_mlockfreed",
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	"thp_fault_alloc",
-	"thp_fault_fallback",
-	"thp_collapse_alloc",
-	"thp_collapse_alloc_failed",
-	"thp_split",
-#endif
-
-#endif /* CONFIG_VM_EVENTS_COUNTERS */
-};
-
 static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 							struct zone *zone)
 {
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch
mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch
mm-strictly-require-elevated-page-refcount-in-isolate_lru_page.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix-2.patch
readahead-readahead-page-allocations-are-ok-to-fail.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
mm-fail-gfp_dma-allocations-when-zone_dma-is-not-configured.patch
mm-export-get_vma_policy.patch
mm-use-walk_page_range-instead-of-custom-page-table-walking-code.patch
mm-remove-mpol_mf_stats.patch
mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch
mm-remove-check_huge_range.patch
mm-declare-mpol_to_str-when-config_tmpfs=n.patch
mm-proc-move-show_numa_map-to-fs-proc-task_mmuc.patch
proc-make-struct-proc_maps_private-truly-private.patch
proc-allocate-storage-for-numa_maps-statistics-once.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
alpha-replace-with-new-cpumask-apis.patch
mn10300-convert-old-cpumask-api-into-new-one.patch
cris-convert-old-cpumask-api-into-new-one.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
sparse-define-dummy-build_bug_on-definition-for-sparse.patch
sparse-define-__must_be_array-for-__checker__.patch
sparse-undef-__compiletime_warningerror-if-__checker__-is-defined.patch

