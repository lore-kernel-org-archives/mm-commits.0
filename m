From: akpm@linux-foundation.org
Subject: [merged] page_alloc-add-movable_memmap-kernel-parameter.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:51:07 -0800
Message-ID: <20130225205107.CC06E5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:61848 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab3BYUvJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:51:09 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so347131ghb.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:51:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, hpa@zytor.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page_alloc: add movable_memmap kernel parameter
has been removed from the -mm tree.  Its filename was
     page_alloc-add-movable_memmap-kernel-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: page_alloc: add movable_memmap kernel parameter

Add functions to parse movablemem_map boot option.  Since the option
could be specified more then once, all the maps will be stored in the
global variable movablemem_map.map array.

And also, we keep the array in monotonic increasing order by start_pfn.
And merge all overlapped ranges.

[akpm@linux-foundation.org: improve comment]
[akpm@linux-foundation.org: checkpatch fixes]
[akpm@linux-foundation.org: remove unneeded parens]
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   17 +++
 include/linux/mm.h                  |   11 ++
 mm/page_alloc.c                     |  131 ++++++++++++++++++++++++++
 3 files changed, 159 insertions(+)

diff -puN Documentation/kernel-parameters.txt~page_alloc-add-movable_memmap-kernel-parameter Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~page_alloc-add-movable_memmap-kernel-parameter
+++ a/Documentation/kernel-parameters.txt
@@ -1640,6 +1640,23 @@ bytes respectively. Such letter suffixes
 			that the amount of memory usable for all allocations
 			is not too small.
 
+	movablemem_map=nn[KMG]@ss[KMG]
+			[KNL,X86,IA-64,PPC] This parameter is similar to
+			memmap except it specifies the memory map of
+			ZONE_MOVABLE.
+			If more areas are all within one node, then from
+			lowest ss to the end of the node will be ZONE_MOVABLE.
+			If an area covers two or more nodes, the area from
+			ss to the end of the 1st node will be ZONE_MOVABLE,
+			and all the rest nodes will only have ZONE_MOVABLE.
+			If memmap is specified at the same time, the
+			movablemem_map will be limited within the memmap
+			areas. If kernelcore or movablecore is also specified,
+			movablemem_map will have higher priority to be
+			satisfied. So the administrator should be careful that
+			the amount of movablemem_map areas are not too large.
+			Otherwise kernel won't have enough memory to start.
+
 	MTD_Partition=	[MTD]
 			Format: <name>,<region-number>,<size>,<offset>
 
diff -puN include/linux/mm.h~page_alloc-add-movable_memmap-kernel-parameter include/linux/mm.h
--- a/include/linux/mm.h~page_alloc-add-movable_memmap-kernel-parameter
+++ a/include/linux/mm.h
@@ -1359,6 +1359,17 @@ extern void free_bootmem_with_active_reg
 						unsigned long max_low_pfn);
 extern void sparse_memory_present_with_active_regions(int nid);
 
+#define MOVABLEMEM_MAP_MAX MAX_NUMNODES
+struct movablemem_entry {
+	unsigned long start_pfn;    /* start pfn of memory segment */
+	unsigned long end_pfn;      /* end pfn of memory segment (exclusive) */
+};
+
+struct movablemem_map {
+	int nr_map;
+	struct movablemem_entry map[MOVABLEMEM_MAP_MAX];
+};
+
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 #if !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && \
diff -puN mm/page_alloc.c~page_alloc-add-movable_memmap-kernel-parameter mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-add-movable_memmap-kernel-parameter
+++ a/mm/page_alloc.c
@@ -202,6 +202,9 @@ static unsigned long __meminitdata nr_al
 static unsigned long __meminitdata dma_reserve;
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+/* Movable memory ranges, will also be used by memblock subsystem. */
+struct movablemem_map movablemem_map;
+
 static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __initdata required_kernelcore;
@@ -5078,6 +5081,134 @@ static int __init cmdline_parse_movablec
 early_param("kernelcore", cmdline_parse_kernelcore);
 early_param("movablecore", cmdline_parse_movablecore);
 
+/**
+ * insert_movablemem_map - Insert a memory range in to movablemem_map.map.
+ * @start_pfn:	start pfn of the range
+ * @end_pfn:	end pfn of the range
+ *
+ * This function will also merge the overlapped ranges, and sort the array
+ * by start_pfn in monotonic increasing order.
+ */
+static void __init insert_movablemem_map(unsigned long start_pfn,
+					  unsigned long end_pfn)
+{
+	int pos, overlap;
+
+	/*
+	 * pos will be at the 1st overlapped range, or the position
+	 * where the element should be inserted.
+	 */
+	for (pos = 0; pos < movablemem_map.nr_map; pos++)
+		if (start_pfn <= movablemem_map.map[pos].end_pfn)
+			break;
+
+	/* If there is no overlapped range, just insert the element. */
+	if (pos == movablemem_map.nr_map ||
+	    end_pfn < movablemem_map.map[pos].start_pfn) {
+		/*
+		 * If pos is not the end of array, we need to move all
+		 * the rest elements backward.
+		 */
+		if (pos < movablemem_map.nr_map)
+			memmove(&movablemem_map.map[pos+1],
+				&movablemem_map.map[pos],
+				sizeof(struct movablemem_entry) *
+				(movablemem_map.nr_map - pos));
+		movablemem_map.map[pos].start_pfn = start_pfn;
+		movablemem_map.map[pos].end_pfn = end_pfn;
+		movablemem_map.nr_map++;
+		return;
+	}
+
+	/* overlap will be at the last overlapped range */
+	for (overlap = pos + 1; overlap < movablemem_map.nr_map; overlap++)
+		if (end_pfn < movablemem_map.map[overlap].start_pfn)
+			break;
+
+	/*
+	 * If there are more ranges overlapped, we need to merge them,
+	 * and move the rest elements forward.
+	 */
+	overlap--;
+	movablemem_map.map[pos].start_pfn = min(start_pfn,
+					movablemem_map.map[pos].start_pfn);
+	movablemem_map.map[pos].end_pfn = max(end_pfn,
+					movablemem_map.map[overlap].end_pfn);
+
+	if (pos != overlap && overlap + 1 != movablemem_map.nr_map)
+		memmove(&movablemem_map.map[pos+1],
+			&movablemem_map.map[overlap+1],
+			sizeof(struct movablemem_entry) *
+			(movablemem_map.nr_map - overlap - 1));
+
+	movablemem_map.nr_map -= overlap - pos;
+}
+
+/**
+ * movablemem_map_add_region - Add a memory range into movablemem_map.
+ * @start:	physical start address of range
+ * @end:	physical end address of range
+ *
+ * This function transform the physical address into pfn, and then add the
+ * range into movablemem_map by calling insert_movablemem_map().
+ */
+static void __init movablemem_map_add_region(u64 start, u64 size)
+{
+	unsigned long start_pfn, end_pfn;
+
+	/* In case size == 0 or start + size overflows */
+	if (start + size <= start)
+		return;
+
+	if (movablemem_map.nr_map >= ARRAY_SIZE(movablemem_map.map)) {
+		pr_err("movablemem_map: too many entries;"
+			" ignoring [mem %#010llx-%#010llx]\n",
+			(unsigned long long) start,
+			(unsigned long long) (start + size - 1));
+		return;
+	}
+
+	start_pfn = PFN_DOWN(start);
+	end_pfn = PFN_UP(start + size);
+	insert_movablemem_map(start_pfn, end_pfn);
+}
+
+/*
+ * cmdline_parse_movablemem_map - Parse boot option movablemem_map.
+ * @p:	The boot option of the following format:
+ *	movablemem_map=nn[KMG]@ss[KMG]
+ *
+ * This option sets the memory range [ss, ss+nn) to be used as movable memory.
+ *
+ * Return: 0 on success or -EINVAL on failure.
+ */
+static int __init cmdline_parse_movablemem_map(char *p)
+{
+	char *oldp;
+	u64 start_at, mem_size;
+
+	if (!p)
+		goto err;
+
+	oldp = p;
+	mem_size = memparse(p, &p);
+	if (p == oldp)
+		goto err;
+
+	if (*p == '@') {
+		oldp = ++p;
+		start_at = memparse(p, &p);
+		if (p == oldp || *p != '\0')
+			goto err;
+
+		movablemem_map_add_region(start_at, mem_size);
+		return 0;
+	}
+err:
+	return -EINVAL;
+}
+early_param("movablemem_map", cmdline_parse_movablemem_map);
+
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 /**
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

