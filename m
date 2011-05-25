From: akpm@linux-foundation.org
Subject: [merged] mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:40 -0700
Message-ID: <201105252026.p4PKQ3DC014461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755053Ab1EYU1A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:27:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm, mem-hotplug: recalculate lowmem_reserve when memory hotplug occurs
has been removed from the -mm tree.  Its filename was
     mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm, mem-hotplug: recalculate lowmem_reserve when memory hotplug occurs
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, memory hotplug calls setup_per_zone_wmarks() and
calculate_zone_inactive_ratio(), but doesn't call
setup_per_zone_lowmem_reserve().

It means the number of reserved pages aren't updated even if memory hot
plug occur.  This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    2 +-
 mm/memory_hotplug.c |    9 +++++----
 mm/page_alloc.c     |    4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur include/linux/mm.h
--- a/include/linux/mm.h~mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur
+++ a/include/linux/mm.h
@@ -1381,7 +1381,7 @@ extern void set_dma_reserve(unsigned lon
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
 extern void setup_per_zone_wmarks(void);
-extern void calculate_zone_inactive_ratio(struct zone *zone);
+extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(unsigned int flags);
diff -puN mm/memory_hotplug.c~mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur
+++ a/mm/memory_hotplug.c
@@ -459,8 +459,9 @@ int __ref online_pages(unsigned long pfn
 		zone_pcp_update(zone);
 
 	mutex_unlock(&zonelists_mutex);
-	setup_per_zone_wmarks();
-	calculate_zone_inactive_ratio(zone);
+
+	init_per_zone_wmark_min();
+
 	if (onlined_pages) {
 		kswapd_run(zone_to_nid(zone));
 		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
@@ -893,8 +894,8 @@ repeat:
 	zone->zone_pgdat->node_present_pages -= offlined_pages;
 	totalram_pages -= offlined_pages;
 
-	setup_per_zone_wmarks();
-	calculate_zone_inactive_ratio(zone);
+	init_per_zone_wmark_min();
+
 	if (!node_present_pages(node)) {
 		node_clear_state(node, N_HIGH_MEMORY);
 		kswapd_stop(node);
diff -puN mm/page_alloc.c~mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur mm/page_alloc.c
--- a/mm/page_alloc.c~mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur
+++ a/mm/page_alloc.c
@@ -5094,7 +5094,7 @@ void setup_per_zone_wmarks(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-void __meminit calculate_zone_inactive_ratio(struct zone *zone)
+static void __meminit calculate_zone_inactive_ratio(struct zone *zone)
 {
 	unsigned int gb, ratio;
 
@@ -5140,7 +5140,7 @@ static void __meminit setup_per_zone_ina
  * 8192MB:	11584k
  * 16384MB:	16384k
  */
-static int __init init_per_zone_wmark_min(void)
+int __meminit init_per_zone_wmark_min(void)
 {
 	unsigned long lowmem_kbytes;
 
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

