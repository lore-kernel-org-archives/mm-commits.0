From: akpm@linux-foundation.org
Subject: [merged] acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:51:24 -0800
Message-ID: <20130225205124.CF42F31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:50520 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759633Ab3BYUv0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:51:26 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so141957yen.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:51:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, len.brown@intel.com, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acpi, memory-hotplug: extend movablemem_map ranges to the end of node
has been removed from the -mm tree.  Its filename was
     acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: acpi, memory-hotplug: extend movablemem_map ranges to the end of node

When implementing movablemem_map boot option, we introduced an array
movablemem_map.map[] to store the memory ranges to be set as ZONE_MOVABLE.

Since ZONE_MOVABLE is the latst zone of a node, if user didn't specify the
whole node memory range, we need to extend it to the node end so that we
can use it to prevent memblock from allocating memory in the ranges user
didn't specify.

We now implement movablemem_map boot option like this:
        /*
         * For movablemem_map=nn[KMG]@ss[KMG]:
         *
         * SRAT:                |_____| |_____| |_________| |_________| ......
         * node id:                0       1         1           2
         * user specified:                |__|                 |___|
         * movablemem_map:                |___| |_________|    |______| ......
         *
         * Using movablemem_map, we can prevent memblock from allocating memory
         * on ZONE_MOVABLE at boot time.
         *
         * NOTE: In this case, SRAT info will be ingored.
         */

[akpm@linux-foundation.org: clean up code, fix build warning]
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/srat.c |   64 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/mm.h |    5 +++
 mm/page_alloc.c    |   34 +++++++++++++++++++++-
 3 files changed, 98 insertions(+), 5 deletions(-)

diff -puN arch/x86/mm/srat.c~acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node
+++ a/arch/x86/mm/srat.c
@@ -141,11 +141,65 @@ static inline int save_add_info(void) {r
 static inline int save_add_info(void) {return 0;}
 #endif
 
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+static void __init handle_movablemem(int node, u64 start, u64 end)
+{
+	int overlap;
+	unsigned long start_pfn, end_pfn;
+
+	start_pfn = PFN_DOWN(start);
+	end_pfn = PFN_UP(end);
+
+	/*
+	 * For movablecore_map=nn[KMG]@ss[KMG]:
+	 *
+	 * SRAT:		|_____| |_____| |_________| |_________| ......
+	 * node id:		   0       1         1           2
+	 * user specified:	          |__|                 |___|
+	 * movablemem_map:		  |___| |_________|    |______| ......
+	 *
+	 * Using movablemem_map, we can prevent memblock from allocating memory
+	 * on ZONE_MOVABLE at boot time.
+	 */
+	overlap = movablemem_map_overlap(start_pfn, end_pfn);
+	if (overlap >= 0) {
+		/*
+		 * If part of this range is in movablemem_map, we need to
+		 * add the range after it to extend the range to the end
+		 * of the node, because from the min address specified to
+		 * the end of the node will be ZONE_MOVABLE.
+		 */
+		start_pfn = max(start_pfn,
+			    movablemem_map.map[overlap].start_pfn);
+		insert_movablemem_map(start_pfn, end_pfn);
+
+		/*
+		 * Set the nodemask, so that if the address range on one node
+		 * is not continuse, we can add the subsequent ranges on the
+		 * same node into movablemem_map.
+		 */
+		node_set(node, movablemem_map.numa_nodes_hotplug);
+	} else {
+		if (node_isset(node, movablemem_map.numa_nodes_hotplug))
+			/*
+			 * Insert the range if we already have movable ranges
+			 * on the same node.
+			 */
+			insert_movablemem_map(start_pfn, end_pfn);
+	}
+}
+#else		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+static inline void handle_movablemem(int node, u64 start, u64 end)
+{
+}
+#endif		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+
 /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
 int __init
 acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 {
 	u64 start, end;
+	u32 hotpluggable;
 	int node, pxm;
 
 	if (srat_disabled())
@@ -154,7 +208,8 @@ acpi_numa_memory_affinity_init(struct ac
 		goto out_err_bad_srat;
 	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
 		goto out_err;
-	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
+	hotpluggable = ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE;
+	if (hotpluggable && !save_add_info())
 		goto out_err;
 
 	start = ma->base_address;
@@ -174,9 +229,12 @@ acpi_numa_memory_affinity_init(struct ac
 
 	node_set(node, numa_nodes_parsed);
 
-	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
+	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx] %s\n",
 	       node, pxm,
-	       (unsigned long long) start, (unsigned long long) end - 1);
+	       (unsigned long long) start, (unsigned long long) end - 1,
+	       hotpluggable ? "Hot Pluggable": "");
+
+	handle_movablemem(node, start, end);
 
 	return 0;
 out_err_bad_srat:
diff -puN include/linux/mm.h~acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node include/linux/mm.h
--- a/include/linux/mm.h~acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node
+++ a/include/linux/mm.h
@@ -1368,8 +1368,13 @@ struct movablemem_entry {
 struct movablemem_map {
 	int nr_map;
 	struct movablemem_entry map[MOVABLEMEM_MAP_MAX];
+	nodemask_t numa_nodes_hotplug;	/* on which nodes we specify memory */
 };
 
+extern void __init insert_movablemem_map(unsigned long start_pfn,
+					 unsigned long end_pfn);
+extern int __init movablemem_map_overlap(unsigned long start_pfn,
+					 unsigned long end_pfn);
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 #if !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && \
diff -puN mm/page_alloc.c~acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node mm/page_alloc.c
--- a/mm/page_alloc.c~acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node
+++ a/mm/page_alloc.c
@@ -5176,6 +5176,36 @@ early_param("kernelcore", cmdline_parse_
 early_param("movablecore", cmdline_parse_movablecore);
 
 /**
+ * movablemem_map_overlap() - Check if a range overlaps movablemem_map.map[].
+ * @start_pfn:	start pfn of the range to be checked
+ * @end_pfn: 	end pfn of the range to be checked (exclusive)
+ *
+ * This function checks if a given memory range [start_pfn, end_pfn) overlaps
+ * the movablemem_map.map[] array.
+ *
+ * Return: index of the first overlapped element in movablemem_map.map[]
+ *         or -1 if they don't overlap each other.
+ */
+int __init movablemem_map_overlap(unsigned long start_pfn,
+				   unsigned long end_pfn)
+{
+	int overlap;
+
+	if (!movablemem_map.nr_map)
+		return -1;
+
+	for (overlap = 0; overlap < movablemem_map.nr_map; overlap++)
+		if (start_pfn < movablemem_map.map[overlap].end_pfn)
+			break;
+
+	if (overlap == movablemem_map.nr_map ||
+	    end_pfn <= movablemem_map.map[overlap].start_pfn)
+		return -1;
+
+	return overlap;
+}
+
+/**
  * insert_movablemem_map - Insert a memory range in to movablemem_map.map.
  * @start_pfn:	start pfn of the range
  * @end_pfn:	end pfn of the range
@@ -5183,8 +5213,8 @@ early_param("movablecore", cmdline_parse
  * This function will also merge the overlapped ranges, and sort the array
  * by start_pfn in monotonic increasing order.
  */
-static void __init insert_movablemem_map(unsigned long start_pfn,
-					  unsigned long end_pfn)
+void __init insert_movablemem_map(unsigned long start_pfn,
+				  unsigned long end_pfn)
 {
 	int pos, overlap;
 
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

