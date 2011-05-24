From: akpm@linux-foundation.org
Subject: [folded] vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch removed from -mm tree
Date: Tue, 24 May 2011 16:57:21 -0700
Message-ID: <201105242357.p4ONvLjo023944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757467Ab1EXX5h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 19:57:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gm


The patch titled
     vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2
has been removed from the -mm tree.  Its filename was
     vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch

This patch was dropped because it was folded into vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2 mm/vmscan.c
--- a/mm/vmscan.c~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2
+++ a/mm/vmscan.c
@@ -2207,17 +2207,20 @@ unsigned long try_to_free_mem_cgroup_pag
 		.order = 0,
 		.mem_cgroup = mem_cont,
 		.nodemask = NULL, /* we don't care the placement */
+		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
+				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
+	};
+	struct shrink_control shrink = {
+		.gfp_mask = sc.gfp_mask,
 	};
 
-	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
-			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
 
 	trace_mm_vmscan_memcg_reclaim_begin(0,
 					    sc.may_writepage,
 					    sc.gfp_mask);
 
-	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
+	nr_reclaimed = do_try_to_free_pages(zonelist, &sc, &shrink);
 
 	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
 
@@ -2800,7 +2803,10 @@ unsigned long shrink_all_memory(unsigned
 		.swappiness = vm_swappiness,
 		.order = 0,
 	};
-	struct zonelist * zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
+	struct shrink_control shrink = {
+		.gfp_mask = sc.gfp_mask,
+	};
+	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 	struct task_struct *p = current;
 	unsigned long nr_reclaimed;
 
@@ -2809,7 +2815,7 @@ unsigned long shrink_all_memory(unsigned
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
+	nr_reclaimed = do_try_to_free_pages(zonelist, &sc, &shrink);
 
 	p->reclaim_state = NULL;
 	lockdep_clear_current_reclaim_state();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch
mm-nommu-sort-mm-mmap-list-properly.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mmu_gather-rework.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
nommu-add-page-alignment-to-mmap-checkpatch-fixes.patch
alpha-hook-up-gpiolib-support-fix.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
bitmap-irq-add-smp_affinity_list-interface-to-proc-irq-fix.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-gpio-vx855_gpioc-needs-slabh.patch
drivers-gpio-ml_ioh_gpioc-needs-slabh.patch
drivers-tty-serial-pch_uartc-needs-slabh.patch

