From: akpm@linux-foundation.org
Subject: - x86_64-set-node_possible_map-at-runtime.patch removed from -mm tree
Date: Thu, 26 Apr 2007 13:51:41 -0700
Message-ID: <200704262051.l3QKpfhk011217@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047AbXDZUwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 16:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, andi@firstfloor.org, clameter@engr.sgi.com, dada1@cosmosbay.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: set node_possible_map at runtime
has been removed from the -mm tree.  Its filename was
     x86_64-set-node_possible_map-at-runtime.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: x86_64: set node_possible_map at runtime
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Set the node_possible_map at runtime on x86_64.  On a non NUMA system,
num_possible_nodes() will now say '1'.

[rientjes@google.com: clear node_possible_map]
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/k8topology.c |    7 ++-----
 arch/x86_64/mm/numa.c       |   10 ++++++++--
 arch/x86_64/mm/srat.c       |   17 ++++++++---------
 3 files changed, 18 insertions(+), 16 deletions(-)

diff -puN arch/x86_64/mm/k8topology.c~x86_64-set-node_possible_map-at-runtime arch/x86_64/mm/k8topology.c
--- a/arch/x86_64/mm/k8topology.c~x86_64-set-node_possible_map-at-runtime
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
diff -puN arch/x86_64/mm/numa.c~x86_64-set-node_possible_map-at-runtime arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-set-node_possible_map-at-runtime
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
diff -puN arch/x86_64/mm/srat.c~x86_64-set-node_possible_map-at-runtime arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c~x86_64-set-node_possible_map-at-runtime
+++ a/arch/x86_64/mm/srat.c
@@ -25,7 +25,6 @@ int acpi_numa __initdata;
 
 static struct acpi_table_slit *acpi_slit;
 
-static nodemask_t nodes_parsed __initdata;
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode nodes_add[MAX_NUMNODES];
 static int found_add_area __initdata;
@@ -43,7 +42,7 @@ static __init int setup_node(int pxm)
 static __init int conflicting_nodes(unsigned long start, unsigned long end)
 {
 	int i;
-	for_each_node_mask(i, nodes_parsed) {
+	for_each_node_mask(i, node_possible_map) {
 		struct bootnode *nd = &nodes[i];
 		if (nd->start == nd->end)
 			continue;
@@ -321,7 +320,7 @@ acpi_numa_memory_affinity_init(struct ac
 	}
 	nd = &nodes[node];
 	oldnode = *nd;
-	if (!node_test_and_set(node, nodes_parsed)) {
+	if (!node_test_and_set(node, node_possible_map)) {
 		nd->start = start;
 		nd->end = end;
 	} else {
@@ -344,7 +343,7 @@ acpi_numa_memory_affinity_init(struct ac
 		printk(KERN_NOTICE "SRAT: Hotplug region ignored\n");
 		*nd = oldnode;
 		if ((nd->start | nd->end) == 0)
-			node_clear(node, nodes_parsed);
+			node_clear(node, node_possible_map);
 	}
 }
 
@@ -356,7 +355,7 @@ static int nodes_cover_memory(void)
 	unsigned long pxmram, e820ram;
 
 	pxmram = 0;
-	for_each_node_mask(i, nodes_parsed) {
+	for_each_node_mask(i, node_possible_map) {
 		unsigned long s = nodes[i].start >> PAGE_SHIFT;
 		unsigned long e = nodes[i].end >> PAGE_SHIFT;
 		pxmram += e - s;
@@ -380,7 +379,7 @@ static int nodes_cover_memory(void)
 static void unparse_node(int node)
 {
 	int i;
-	node_clear(node, nodes_parsed);
+	node_clear(node, node_possible_map);
 	for (i = 0; i < MAX_LOCAL_APIC; i++) {
 		if (apicid_to_node[i] == node)
 			apicid_to_node[i] = NUMA_NO_NODE;
@@ -420,18 +419,18 @@ int __init acpi_scan_nodes(unsigned long
 	}
 
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

x86_64-set-node_possible_map-at-runtime.patch
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
