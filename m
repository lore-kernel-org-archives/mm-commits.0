From: akpm@linux-foundation.org
Subject: [merged] mm-per-node-vmstat-show-proper-vmstats.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:32 -0700
Message-ID: <201105252025.p4PKPtSR014439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755650Ab1EYU0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, mrubin@google.com, rdunlap@xenotime.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: per-node vmstat: show proper vmstats
has been removed from the -mm tree.  Its filename was
     mm-per-node-vmstat-show-proper-vmstats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: per-node vmstat: show proper vmstats
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 2ac390370a ("writeback: add
/sys/devices/system/node/<node>/vmstat") added vmstat entry.  But
strangely it only show nr_written and nr_dirtied.

        # cat /sys/devices/system/node/node20/vmstat
        nr_written 0
        nr_dirtied 0

Of course, It's not adequate.  With this patch, the vmstat show all vm
stastics as /proc/vmstat.

        # cat /sys/devices/system/node/node0/vmstat
	nr_free_pages 899224
	nr_inactive_anon 201
	nr_active_anon 17380
	nr_inactive_file 31572
	nr_active_file 28277
	nr_unevictable 0
	nr_mlock 0
	nr_anon_pages 17321
	nr_mapped 8640
	nr_file_pages 60107
	nr_dirty 33
	nr_writeback 0
	nr_slab_reclaimable 6850
	nr_slab_unreclaimable 7604
	nr_page_table_pages 3105
	nr_kernel_stack 175
	nr_unstable 0
	nr_bounce 0
	nr_vmscan_write 0
	nr_writeback_temp 0
	nr_isolated_anon 0
	nr_isolated_file 0
	nr_shmem 260
	nr_dirtied 1050
	nr_written 938
	numa_hit 962872
	numa_miss 0
	numa_foreign 0
	numa_interleave 8617
	numa_local 962872
	numa_other 0
	nr_anon_transparent_hugepages 0

[akpm@linux-foundation.org: no externs in .c files]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |   14 +-
 include/linux/vmstat.h |    4 
 mm/vmstat.c            |  261 +++++++++++++++++++--------------------
 3 files changed, 144 insertions(+), 135 deletions(-)

diff -puN drivers/base/node.c~mm-per-node-vmstat-show-proper-vmstats drivers/base/node.c
--- a/drivers/base/node.c~mm-per-node-vmstat-show-proper-vmstats
+++ a/drivers/base/node.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/memory.h>
+#include <linux/vmstat.h>
 #include <linux/node.h>
 #include <linux/hugetlb.h>
 #include <linux/compaction.h>
@@ -179,11 +180,14 @@ static ssize_t node_read_vmstat(struct s
 				struct sysdev_attribute *attr, char *buf)
 {
 	int nid = dev->id;
-	return sprintf(buf,
-		"nr_written %lu\n"
-		"nr_dirtied %lu\n",
-		node_page_state(nid, NR_WRITTEN),
-		node_page_state(nid, NR_DIRTIED));
+	int i;
+	int n = 0;
+
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+		n += sprintf(buf+n, "%s %lu\n", vmstat_text[i],
+			     node_page_state(nid, i));
+
+	return n;
 }
 static SYSDEV_ATTR(vmstat, S_IRUGO, node_read_vmstat, NULL);
 
diff -puN include/linux/vmstat.h~mm-per-node-vmstat-show-proper-vmstats include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-per-node-vmstat-show-proper-vmstats
+++ a/include/linux/vmstat.h
@@ -313,6 +313,8 @@ static inline void __dec_zone_page_state
 #define set_pgdat_percpu_threshold(pgdat, callback) { }
 
 static inline void refresh_cpu_vm_stats(int cpu) { }
-#endif
+#endif		/* CONFIG_SMP */
+
+extern const char * const vmstat_text[];
 
 #endif /* _LINUX_VMSTAT_H */
diff -puN mm/vmstat.c~mm-per-node-vmstat-show-proper-vmstats mm/vmstat.c
--- a/mm/vmstat.c~mm-per-node-vmstat-show-proper-vmstats
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
-static const char * const vmstat_text[] = {
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
linux-next.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
m32r-convert-cpumask-api.patch
m32r-fix-spin_lock_irqsave-misuse.patch
m32r-remove-redundant-declaration.patch
getdelays-show-average-cpu-io-swap-reclaim-delays.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
vmscanmemcg-memcg-aware-swap-token.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

