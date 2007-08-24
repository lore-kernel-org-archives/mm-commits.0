From: akpm@linux-foundation.org
Subject: + memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch added to -mm tree
Date: Fri, 24 Aug 2007 16:39:16 -0700
Message-ID: <200708242339.l7ONdGRc020616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35609 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752721AbXHXXjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 19:39:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@skynet.ie, nacc@us.ibm.com


The patch titled
     Move setup of N_CPU node state mask
has been added to the -mm tree.  Its filename is
     memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask mm/page_alloc.c
--- a/mm/page_alloc.c~memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask
+++ a/mm/page_alloc.c
@@ -2367,6 +2367,8 @@ static int __cpuinit process_zones(int c
 	struct zone *zone, *dzone;
 	int node = cpu_to_node(cpu);
 
+	node_set_state(node, N_CPU);	/* this node has a cpu */
+
 	for_each_zone(zone) {
 
 		if (!populated_zone(zone))
@@ -2384,7 +2386,6 @@ static int __cpuinit process_zones(int c
 			 	(zone->present_pages / percpu_pagelist_fraction));
 	}
 
-	node_set_state(node, N_CPU);
 	return 0;
 bad:
 	for_each_zone(dzone) {
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-prefetch.patch
