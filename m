From: akpm@linux-foundation.org
Subject: [merged] mm-exclude-memory-less-nodes-from-zone_reclaim.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:34:51 -0700
Message-ID: <53445d6b.D7BDjVF/IKbX748J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaDHUew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:34:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, nacc@linux.vnet.ibm.com, mgorman@suse.de, mhocko@suse.cz

Subject: [merged] mm-exclude-memory-less-nodes-from-zone_reclaim.patch removed from -mm tree
To: mhocko@suse.cz,mgorman@suse.de,nacc@linux.vnet.ibm.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:34:51 -0700


The patch titled
     Subject: mm: exclude memoryless nodes from zone_reclaim
has been removed from the -mm tree.  Its filename was
     mm-exclude-memory-less-nodes-from-zone_reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: exclude memoryless nodes from zone_reclaim

We had a report about strange OOM killer strikes on a PPC machine although
there was a lot of swap free and a tons of anonymous memory which could be
swapped out.  In the end it turned out that the OOM was a side effect of
zone reclaim which wasn't unmapping and swapping out and so the system was
pushed to the OOM.  Although this sounds like a bug somewhere in the
kswapd vs.  zone reclaim vs.  direct reclaim interaction numactl on the
said hardware suggests that the zone reclaim should not have been set in
the first place:

node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
node 0 size: 0 MB
node 0 free: 0 MB
node 2 cpus:
node 2 size: 7168 MB
node 2 free: 6019 MB
node distances:
node   0   2
0:  10  40
2:  40  10

So all the CPUs are associated with Node0 which doesn't have any memory
while Node2 contains all the available memory.  Node distances cause an
automatic zone_reclaim_mode enabling.

Zone reclaim is intended to keep the allocations local but this doesn't
make any sense on the memoryless nodes.  So let's exclude such nodes for
init_zone_allows_reclaim which evaluates zone reclaim behavior and
suitable reclaim_nodes.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Tested-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-exclude-memory-less-nodes-from-zone_reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~mm-exclude-memory-less-nodes-from-zone_reclaim
+++ a/mm/page_alloc.c
@@ -1870,7 +1870,7 @@ static void __paginginit init_zone_allow
 {
 	int i;
 
-	for_each_online_node(i)
+	for_each_node_state(i, N_MEMORY)
 		if (node_distance(nid, i) <= RECLAIM_DISTANCE)
 			node_set(i, NODE_DATA(nid)->reclaim_nodes);
 		else
@@ -4919,7 +4919,8 @@ void __paginginit free_area_init_node(in
 
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
-	init_zone_allows_reclaim(nid);
+	if (node_state(nid, N_MEMORY))
+		init_zone_allows_reclaim(nid);
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 #endif
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch

