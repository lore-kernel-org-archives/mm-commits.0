From: akpm@linux-foundation.org
Subject: [merged] page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:51:10 -0800
Message-ID: <20130225205110.E3A1D31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:58768 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab3BYUvM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:51:12 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so347188ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:51:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, hpa@zytor.com, jiang.liu@huawei.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page_alloc: introduce zone_movable_limit[] to keep movable limit for nodes
has been removed from the -mm tree.  Its filename was
     page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: page_alloc: introduce zone_movable_limit[] to keep movable limit for nodes

Introduce a new array zone_movable_limit[] to store the ZONE_MOVABLE limit
from movablemem_map boot option for all nodes.  The function
sanitize_zone_movable_limit() will find out to which node the ranges in
movable_map.map[] belongs, and calculates the low boundary of ZONE_MOVABLE
for each node.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Liu Jiang <jiang.liu@huawei.com>
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

 mm/page_alloc.c |   76 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes
+++ a/mm/page_alloc.c
@@ -210,6 +210,7 @@ static unsigned long __meminitdata arch_
 static unsigned long __initdata required_kernelcore;
 static unsigned long __initdata required_movablecore;
 static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
+static unsigned long __meminitdata zone_movable_limit[MAX_NUMNODES];
 
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
@@ -4375,6 +4376,77 @@ static unsigned long __meminit zone_abse
 	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
+/**
+ * sanitize_zone_movable_limit - Sanitize the zone_movable_limit array.
+ *
+ * zone_movable_limit is initialized as 0. This function will try to get
+ * the first ZONE_MOVABLE pfn of each node from movablemem_map, and
+ * assigne them to zone_movable_limit.
+ * zone_movable_limit[nid] == 0 means no limit for the node.
+ *
+ * Note: Each range is represented as [start_pfn, end_pfn)
+ */
+static void __meminit sanitize_zone_movable_limit(void)
+{
+	int map_pos = 0, i, nid;
+	unsigned long start_pfn, end_pfn;
+
+	if (!movablemem_map.nr_map)
+		return;
+
+	/* Iterate all ranges from minimum to maximum */
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		/*
+		 * If we have found lowest pfn of ZONE_MOVABLE of the node
+		 * specified by user, just go on to check next range.
+		 */
+		if (zone_movable_limit[nid])
+			continue;
+
+#ifdef CONFIG_ZONE_DMA
+		/* Skip DMA memory. */
+		if (start_pfn < arch_zone_highest_possible_pfn[ZONE_DMA])
+			start_pfn = arch_zone_highest_possible_pfn[ZONE_DMA];
+#endif
+
+#ifdef CONFIG_ZONE_DMA32
+		/* Skip DMA32 memory. */
+		if (start_pfn < arch_zone_highest_possible_pfn[ZONE_DMA32])
+			start_pfn = arch_zone_highest_possible_pfn[ZONE_DMA32];
+#endif
+
+#ifdef CONFIG_HIGHMEM
+		/* Skip lowmem if ZONE_MOVABLE is highmem. */
+		if (zone_movable_is_highmem() &&
+		    start_pfn < arch_zone_lowest_possible_pfn[ZONE_HIGHMEM])
+			start_pfn = arch_zone_lowest_possible_pfn[ZONE_HIGHMEM];
+#endif
+
+		if (start_pfn >= end_pfn)
+			continue;
+
+		while (map_pos < movablemem_map.nr_map) {
+			if (end_pfn <= movablemem_map.map[map_pos].start_pfn)
+				break;
+
+			if (start_pfn >= movablemem_map.map[map_pos].end_pfn) {
+				map_pos++;
+				continue;
+			}
+
+			/*
+			 * The start_pfn of ZONE_MOVABLE is either the minimum
+			 * pfn specified by movablemem_map, or 0, which means
+			 * the node has no ZONE_MOVABLE.
+			 */
+			zone_movable_limit[nid] = max(start_pfn,
+					movablemem_map.map[map_pos].start_pfn);
+
+			break;
+		}
+	}
+}
+
 #else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
@@ -4392,7 +4464,6 @@ static inline unsigned long __meminit zo
 
 	return zholes_size[zone_type];
 }
-
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
@@ -4839,7 +4910,6 @@ static void __init find_zone_movable_pfn
 		goto out;
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
-	find_usable_zone_for_movable();
 	usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
 
 restart:
@@ -4998,6 +5068,8 @@ void __init free_area_init_nodes(unsigne
 
 	/* Find the PFNs that ZONE_MOVABLE begins at in each node */
 	memset(zone_movable_pfn, 0, sizeof(zone_movable_pfn));
+	find_usable_zone_for_movable();
+	sanitize_zone_movable_limit();
 	find_zone_movable_pfns_for_nodes();
 
 	/* Print out the zone ranges */
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

