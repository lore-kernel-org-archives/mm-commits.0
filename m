From: akpm@linux-foundation.org
Subject: - add-n_cpu-node-state.patch removed from -mm tree
Date: Fri, 03 Aug 2007 22:15:27 -0700
Message-ID: <200708040515.l745FROu011739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55766 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735AbXHDFPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 4 Aug 2007 01:15:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Add N_CPU node state
has been removed from the -mm tree.  Its filename was
     add-n_cpu-node-state.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Add N_CPU node state
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

We need the check for a node with cpu in zone reclaim.  Zone reclaim will not
allow remote zone reclaim if a node has a cpu.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Tested-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    1 +
 mm/page_alloc.c          |    4 +++-
 mm/vmscan.c              |    4 +---
 3 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/nodemask.h~add-n_cpu-node-state include/linux/nodemask.h
--- a/include/linux/nodemask.h~add-n_cpu-node-state
+++ a/include/linux/nodemask.h
@@ -344,6 +344,7 @@ enum node_states {
 	N_POSSIBLE,	/* The node could become online at some point */
 	N_ONLINE,	/* The node is online */
 	N_MEMORY,	/* The node has memory */
+	N_CPU,		/* The node has cpus */
 	NR_NODE_STATES
 };
 
diff -puN mm/page_alloc.c~add-n_cpu-node-state mm/page_alloc.c
--- a/mm/page_alloc.c~add-n_cpu-node-state
+++ a/mm/page_alloc.c
@@ -2646,6 +2646,7 @@ static struct per_cpu_pageset boot_pages
 static int __cpuinit process_zones(int cpu)
 {
 	struct zone *zone, *dzone;
+	int node = cpu_to_node(cpu);
 
 	for_each_zone(zone) {
 
@@ -2653,7 +2654,7 @@ static int __cpuinit process_zones(int c
 			continue;
 
 		zone_pcp(zone, cpu) = kmalloc_node(sizeof(struct per_cpu_pageset),
-					 GFP_KERNEL, cpu_to_node(cpu));
+					 GFP_KERNEL, node);
 		if (!zone_pcp(zone, cpu))
 			goto bad;
 
@@ -2664,6 +2665,7 @@ static int __cpuinit process_zones(int c
 			 	(zone->present_pages / percpu_pagelist_fraction));
 	}
 
+	node_set_state(node, N_CPU);
 	return 0;
 bad:
 	for_each_zone(dzone) {
diff -puN mm/vmscan.c~add-n_cpu-node-state mm/vmscan.c
--- a/mm/vmscan.c~add-n_cpu-node-state
+++ a/mm/vmscan.c
@@ -1825,7 +1825,6 @@ static int __zone_reclaim(struct zone *z
 
 int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 {
-	cpumask_t mask;
 	int node_id;
 
 	/*
@@ -1862,8 +1861,7 @@ int zone_reclaim(struct zone *zone, gfp_
 	 * as wide as possible.
 	 */
 	node_id = zone_to_nid(zone);
-	mask = node_to_cpumask(node_id);
-	if (!cpus_empty(mask) && node_id != numa_node_id())
+	if (node_state(node_id, N_CPU) && node_id != numa_node_id())
 		return 0;
 	return __zone_reclaim(zone, gfp_mask, order);
 }
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

fix-missing-numa_zonelist_order-sysctl.patch
document-linux-memory-policy-v3.patch
add-n_cpu-node-state.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-node_memory_map-for-cpusets.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
