From: akpm@linux-foundation.org
Subject: [merged] page_alloc-make-movablecore_map-has-higher-priority.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:51:14 -0800
Message-ID: <20130225205114.D7AE25A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:58179 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759615Ab3BYUvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:51:16 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so347050ghb.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:51:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, hpa@zytor.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page_alloc: make movablemem_map have higher priority
has been removed from the -mm tree.  Its filename was
     page_alloc-make-movablecore_map-has-higher-priority.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: page_alloc: make movablemem_map have higher priority

If kernelcore or movablecore is specified at the same time with
movablemem_map, movablemem_map will have higher priority to be
satisfied.  This patch will make find_zone_movable_pfns_for_nodes()
calculate zone_movable_pfn[] with the limit from zone_movable_limit[].

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~page_alloc-make-movablecore_map-has-higher-priority mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-make-movablecore_map-has-higher-priority
+++ a/mm/page_alloc.c
@@ -4905,9 +4905,17 @@ static void __init find_zone_movable_pfn
 		required_kernelcore = max(required_kernelcore, corepages);
 	}
 
-	/* If kernelcore was not specified, there is no ZONE_MOVABLE */
-	if (!required_kernelcore)
+	/*
+	 * If neither kernelcore/movablecore nor movablemem_map is specified,
+	 * there is no ZONE_MOVABLE. But if movablemem_map is specified, the
+	 * start pfn of ZONE_MOVABLE has been stored in zone_movable_limit[].
+	 */
+	if (!required_kernelcore) {
+		if (movablemem_map.nr_map)
+			memcpy(zone_movable_pfn, zone_movable_limit,
+				sizeof(zone_movable_pfn));
 		goto out;
+	}
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
 	usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
@@ -4937,10 +4945,24 @@ restart:
 		for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 			unsigned long size_pages;
 
+			/*
+			 * Find more memory for kernelcore in
+			 * [zone_movable_pfn[nid], zone_movable_limit[nid]).
+			 */
 			start_pfn = max(start_pfn, zone_movable_pfn[nid]);
 			if (start_pfn >= end_pfn)
 				continue;
 
+			if (zone_movable_limit[nid]) {
+				end_pfn = min(end_pfn, zone_movable_limit[nid]);
+				/* No range left for kernelcore in this node */
+				if (start_pfn >= end_pfn) {
+					zone_movable_pfn[nid] =
+							zone_movable_limit[nid];
+					break;
+				}
+			}
+
 			/* Account for what is only usable for kernelcore */
 			if (start_pfn < usable_startpfn) {
 				unsigned long kernel_pages;
@@ -5000,12 +5022,12 @@ restart:
 	if (usable_nodes && required_kernelcore > usable_nodes)
 		goto restart;
 
+out:
 	/* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
 	for (nid = 0; nid < MAX_NUMNODES; nid++)
 		zone_movable_pfn[nid] =
 			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
 
-out:
 	/* restore the node_state */
 	node_states[N_MEMORY] = saved_node_state;
 }
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

