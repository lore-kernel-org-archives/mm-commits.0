From: akpm@linux-foundation.org
Subject: - memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:28:46 -0700
Message-ID: <200710160428.l9G4Skn4008775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44473 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839AbXJPE3K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:29:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@skynet.ie, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Move setup of N_CPU node state mask
has been removed from the -mm tree.  Its filename was
     memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch

This patch was dropped because it was folded into memoryless-nodes-add-n_cpu-node-state.patch

------------------------------------------------------
Subject: Move setup of N_CPU node state mask
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Move recording of nodes w/ cpus to before zone loop.  Otherwise, error exit
could skip setup of N_CPU mask.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Bob Picco <bob.picco@hp.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask mm/page_alloc.c
--- a/mm/page_alloc.c~memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask
+++ a/mm/page_alloc.c
@@ -2355,6 +2355,8 @@ static int __cpuinit process_zones(int c
 	struct zone *zone, *dzone;
 	int node = cpu_to_node(cpu);
 
+	node_set_state(node, N_CPU);	/* this node has a cpu */
+
 	for_each_zone(zone) {
 
 		if (!populated_zone(zone))
@@ -2372,7 +2374,6 @@ static int __cpuinit process_zones(int c
 			 	(zone->present_pages / percpu_pagelist_fraction));
 	}
 
-	node_set_state(node, N_CPU);
 	return 0;
 bad:
 	for_each_zone(dzone) {
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2-3.patch
add-node-states-sysfs-class-attributes-v5.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch
