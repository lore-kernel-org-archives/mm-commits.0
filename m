From: akpm@linux-foundation.org
Subject: - x86_64-set-node_possible_map-at-runtime-try-2.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:55:45 -0700
Message-ID: <200704281055.l3SAtjY0020203@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965749AbXD1K4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, andi@firstfloor.org, clameter@engr.sgi.com, dada1@cosmosbay.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: set node_possible_map at runtime
has been removed from the -mm tree.  Its filename was
     x86_64-set-node_possible_map-at-runtime-try-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: set node_possible_map at runtime
From: Suresh Siddha <suresh.b.siddha@intel.com>

Set the node_possible_map at runtime on x86_64.  On a non NUMA system,
num_possible_nodes() will now say '1'.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/k8topology.c |    7 ++-----
 arch/x86_64/mm/numa.c       |   10 ++++++++--
 arch/x86_64/mm/srat.c       |    8 +++++---
 3 files changed, 15 insertions(+), 10 deletions(-)

diff -puN arch/x86_64/mm/k8topology.c~x86_64-set-node_possible_map-at-runtime-try-2 arch/x86_64/mm/k8topology.c
--- a/arch/x86_64/mm/k8topology.c~x86_64-set-node_possible_map-at-runtime-try-2
+++ a/arch/x86_64/mm/k8topology.c
@@ -49,11 +49,8 @@ int __init k8_scan_nodes(unsigned long s
 	int found = 0;
 	u32 reg;
 	unsigned numnodes;
-	nodemask_t nodes_parsed;
 	unsigned dualcore = 0;
 
-	nodes_clear(nodes_parsed);
-
 	if (!early_pci_allowed())
 		return -1;
 
@@ -102,7 +99,7 @@ int __init k8_scan_nodes(unsigned long s
 			       nodeid, (base>>8)&3, (limit>>8) & 3); 
 			return -1; 
 		}	
-		if (node_isset(nodeid, nodes_parsed)) { 
+		if (node_isset(nodeid, node_possible_map)) {
 			printk(KERN_INFO "Node %d already present. Skipping\n", 
 			       nodeid);
 			continue;
@@ -155,7 +152,7 @@ int __init k8_scan_nodes(unsigned long s
 
 		prevbase = base;
 
-		node_set(nodeid, nodes_parsed);
+		node_set(nodeid, node_possible_map);
 	} 
 
 	if (!found)
diff -puN arch/x86_64/mm/numa.c~x86_64-set-node_possible_map-at-runtime-try-2 arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-set-node_possible_map-at-runtime-try-2
+++ a/arch/x86_64/mm/numa.c
@@ -295,7 +295,7 @@ static int __init setup_node_range(int n
 		ret = -1;
 	}
 	nodes[nid].end = *addr;
-	node_set_online(nid);
+	node_set(nid, node_possible_map);
 	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
 	       nodes[nid].start, nodes[nid].end,
 	       (nodes[nid].end - nodes[nid].start) >> 20);
@@ -479,7 +479,7 @@ out:
 	 * SRAT.
 	 */
 	remove_all_active_ranges();
-	for_each_online_node(i) {
+	for_each_node_mask(i, node_possible_map) {
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
  		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
@@ -494,20 +494,25 @@ void __init numa_initmem_init(unsigned l
 { 
 	int i;
 
+	nodes_clear(node_possible_map);
+
 #ifdef CONFIG_NUMA_EMU
 	if (cmdline && !numa_emulation(start_pfn, end_pfn))
  		return;
+	nodes_clear(node_possible_map);
 #endif
 
 #ifdef CONFIG_ACPI_NUMA
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
@@ -521,6 +526,7 @@ void __init numa_initmem_init(unsigned l
 	memnodemap[0] = 0;
 	nodes_clear(node_online_map);
 	node_set_online(0);
+	node_set(0, node_possible_map);
 	for (i = 0; i < NR_CPUS; i++)
 		numa_set_node(i, 0);
 	node_to_cpumask[0] = cpumask_of_cpu(0);
diff -puN arch/x86_64/mm/srat.c~x86_64-set-node_possible_map-at-runtime-try-2 arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c~x86_64-set-node_possible_map-at-runtime-try-2
+++ a/arch/x86_64/mm/srat.c
@@ -419,19 +419,21 @@ int __init acpi_scan_nodes(unsigned long
 		return -1;
 	}
 
+	node_possible_map = nodes_parsed;
+
 	/* Finally register nodes */
-	for_each_node_mask(i, nodes_parsed)
+	for_each_node_mask(i, node_possible_map)
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	/* Try again in case setup_node_bootmem missed one due
 	   to missing bootmem */
-	for_each_node_mask(i, nodes_parsed)
+	for_each_node_mask(i, node_possible_map)
 		if (!node_online(i))
 			setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 
 	for (i = 0; i < NR_CPUS; i++) {
 		if (cpu_to_node[i] == NUMA_NO_NODE)
 			continue;
-		if (!node_isset(cpu_to_node[i], nodes_parsed))
+		if (!node_isset(cpu_to_node[i], node_possible_map))
 			numa_set_node(i, NUMA_NO_NODE);
 	}
 	numa_init_array();
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

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
