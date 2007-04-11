From: akpm@linux-foundation.org
Subject: + x86_64-set-node_possible_map-at-runtime-fix-2.patch added to -mm tree
Date: Wed, 11 Apr 2007 16:42:49 -0700
Message-ID: <200704112342.l3BNgnde018169@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36693 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbXDKXnD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 19:43:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, rientjes@google.com


The patch titled
     x86_64: more fixes to node_possible_map runtime setup
has been added to the -mm tree.  Its filename is
     x86_64-set-node_possible_map-at-runtime-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: more fixes to node_possible_map runtime setup
From: Suresh Siddha <suresh.b.siddha@intel.com>

More fixes in the failure cases and a small cleanup in numa emulation case.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/numa.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/mm/numa.c~x86_64-set-node_possible_map-at-runtime-fix-2 arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-set-node_possible_map-at-runtime-fix-2
+++ a/arch/x86_64/mm/numa.c
@@ -295,7 +295,6 @@ static int __init setup_node_range(int n
 		ret = -1;
 	}
 	nodes[nid].end = *addr;
-	node_set_online(nid);
 	node_set(nid, node_possible_map);
 	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
 	       nodes[nid].start, nodes[nid].end,
@@ -480,7 +479,7 @@ out:
 	 * SRAT.
 	 */
 	remove_all_active_ranges();
-	for_each_online_node(i) {
+	for_each_node_mask(i, node_possible_map) {
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
  		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
@@ -507,11 +506,13 @@ void __init numa_initmem_init(unsigned l
 	if (!numa_off && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
 					  end_pfn << PAGE_SHIFT))
  		return;
+	nodes_clear(node_possible_map);
 #endif
 
 #ifdef CONFIG_K8_NUMA
 	if (!numa_off && !k8_scan_nodes(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT))
 		return;
+	nodes_clear(node_possible_map);
 #endif
 	printk(KERN_INFO "%s\n",
 	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

x86_64-set-node_possible_map-at-runtime.patch
x86_64-set-node_possible_map-at-runtime-fix.patch
x86_64-set-node_possible_map-at-runtime-fix-2.patch
slab-x86_64-skip-cache_free_alien-on-non-numa.patch
pad-irq_desc-to-internode-cacheline-size.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-dynticks-idle-load-balancing-v3.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched-align-rq-to-cacheline-boundary.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
