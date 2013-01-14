From: akpm@linux-foundation.org
Subject: + page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch added to -mm tree
Date: Mon, 14 Jan 2013 14:35:42 -0800
Message-ID: <20130114223543.9D38320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:36700 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab3ANWfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 17:35:47 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so294887fav.0
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 14:35:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, hpa@zytor.com, jiang.liu@huawei.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: page_alloc: introduce zone_movable_limit[] to keep movable limit for nodes
has been added to the -mm tree.  Its filename is
     page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: page_alloc: introduce zone_movable_limit[] to keep movable limit for nodes

Introduce a new array zone_movable_limit[] to store the ZONE_MOVABLE limit
from movablecore_map boot option for all nodes.  The function
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

 mm/page_alloc.c |   79 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes
+++ a/mm/page_alloc.c
@@ -209,6 +209,7 @@ static unsigned long __meminitdata arch_
 static unsigned long __initdata required_kernelcore;
 static unsigned long __initdata required_movablecore;
 static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
+static unsigned long __meminitdata zone_movable_limit[MAX_NUMNODES];
 
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
@@ -4370,6 +4371,77 @@ static unsigned long __meminit zone_abse
 	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
+/**
+ * sanitize_zone_movable_limit - Sanitize the zone_movable_limit array.
+ *
+ * zone_movable_limit is initialized as 0. This function will try to get
+ * the first ZONE_MOVABLE pfn of each node from movablecore_map, and
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
+	if (!movablecore_map.nr_map)
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
+		while (map_pos < movablecore_map.nr_map) {
+			if (end_pfn <= movablecore_map.map[map_pos].start_pfn)
+				break;
+
+			if (start_pfn >= movablecore_map.map[map_pos].end_pfn) {
+				map_pos++;
+				continue;
+			}
+
+			/*
+			 * The start_pfn of ZONE_MOVABLE is either the minimum
+			 * pfn specified by movablecore_map, or 0, which means
+			 * the node has no ZONE_MOVABLE.
+			 */
+			zone_movable_limit[nid] = max(start_pfn,
+					movablecore_map.map[map_pos].start_pfn);
+
+			break;
+		}
+	}
+}
+
 #else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
@@ -4388,6 +4460,10 @@ static inline unsigned long __meminit zo
 	return zholes_size[zone_type];
 }
 
+static void __meminit sanitize_zone_movable_limit(void)
+{
+}
+
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
@@ -4831,7 +4907,6 @@ static void __init find_zone_movable_pfn
 		goto out;
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
-	find_usable_zone_for_movable();
 	usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
 
 restart:
@@ -4990,6 +5065,8 @@ void __init free_area_init_nodes(unsigne
 
 	/* Find the PFNs that ZONE_MOVABLE begins at in each node */
 	memset(zone_movable_pfn, 0, sizeof(zone_movable_pfn));
+	find_usable_zone_for_movable();
+	sanitize_zone_movable_limit();
 	find_zone_movable_pfns_for_nodes();
 
 	/* Print out the zone ranges */
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
x86-get-pg_data_ts-memory-from-other-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch
page_alloc-make-movablecore_map-has-higher-priority.patch
page_alloc-bootmem-limit-with-movablecore_map.patch

