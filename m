From: akpm@linux-foundation.org
Subject: [merged] mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:43 -0700
Message-ID: <201105252026.p4PKQ6jC014465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754304Ab1EYUtJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm, mem-hotplug: update pcp->stat_threshold when memory hotplug occur
has been removed from the -mm tree.  Its filename was
     mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm, mem-hotplug: update pcp->stat_threshold when memory hotplug occur
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, cpu hotplug updates pcp->stat_threshold, but memory hotplug
doesn't.  There is no reason for this.

[akpm@linux-foundation.org: fix CONFIG_SMP=n build]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    3 +++
 mm/page_alloc.c        |    2 ++
 mm/vmstat.c            |    3 +--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/vmstat.h~mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur
+++ a/include/linux/vmstat.h
@@ -261,6 +261,7 @@ extern void dec_zone_state(struct zone *
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 
 void refresh_cpu_vm_stats(int);
+void refresh_zone_stat_thresholds(void);
 
 int calculate_pressure_threshold(struct zone *zone);
 int calculate_normal_threshold(struct zone *zone);
@@ -313,6 +314,8 @@ static inline void __dec_zone_page_state
 #define set_pgdat_percpu_threshold(pgdat, callback) { }
 
 static inline void refresh_cpu_vm_stats(int cpu) { }
+static inline void refresh_zone_stat_thresholds(void) { }
+
 #endif		/* CONFIG_SMP */
 
 extern const char * const vmstat_text[];
diff -puN mm/page_alloc.c~mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur mm/page_alloc.c
--- a/mm/page_alloc.c~mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur
+++ a/mm/page_alloc.c
@@ -39,6 +39,7 @@
 #include <linux/memory_hotplug.h>
 #include <linux/nodemask.h>
 #include <linux/vmalloc.h>
+#include <linux/vmstat.h>
 #include <linux/mempolicy.h>
 #include <linux/stop_machine.h>
 #include <linux/sort.h>
@@ -5152,6 +5153,7 @@ int __meminit init_per_zone_wmark_min(vo
 	if (min_free_kbytes > 65536)
 		min_free_kbytes = 65536;
 	setup_per_zone_wmarks();
+	refresh_zone_stat_thresholds();
 	setup_per_zone_lowmem_reserve();
 	setup_per_zone_inactive_ratio();
 	return 0;
diff -puN mm/vmstat.c~mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur mm/vmstat.c
--- a/mm/vmstat.c~mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur
+++ a/mm/vmstat.c
@@ -157,7 +157,7 @@ int calculate_normal_threshold(struct zo
 /*
  * Refresh the thresholds for each zone.
  */
-static void refresh_zone_stat_thresholds(void)
+void refresh_zone_stat_thresholds(void)
 {
 	struct zone *zone;
 	int cpu;
@@ -1201,7 +1201,6 @@ static int __init setup_vmstat(void)
 #ifdef CONFIG_SMP
 	int cpu;
 
-	refresh_zone_stat_thresholds();
 	register_cpu_notifier(&vmstat_notifier);
 
 	for_each_online_cpu(cpu)
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

