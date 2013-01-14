From: akpm@linux-foundation.org
Subject: + page_alloc-add-movable_memmap-kernel-parameter.patch added to -mm tree
Date: Mon, 14 Jan 2013 14:35:35 -0800
Message-ID: <20130114223536.520C4100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:33388 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421Ab3ANWfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 17:35:38 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so556268qch.2
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 14:35:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, hpa@zytor.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: page_alloc: add movable_memmap kernel parameter
has been added to the -mm tree.  Its filename is
     page_alloc-add-movable_memmap-kernel-parameter.patch

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
Subject: page_alloc: add movable_memmap kernel parameter

Add functions to parse movablecore_map boot option.  Since the option
could be specified more then once, all the maps will be stored in the
global variable movablecore_map.map array.

And also, we keep the array in monotonic increasing order by start_pfn.
And merge all overlapped ranges.

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
 mm/page_alloc.c                     |  126 ++++++++++++++++++++++++++
 3 files changed, 154 insertions(+)

diff -puN Documentation/kernel-parameters.txt~page_alloc-add-movable_memmap-kernel-parameter Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~page_alloc-add-movable_memmap-kernel-parameter
+++ a/Documentation/kernel-parameters.txt
@@ -1637,6 +1637,23 @@ bytes respectively. Such letter suffixes
 			that the amount of memory usable for all allocations
 			is not too small.
 
+	movablecore_map=nn[KMG]@ss[KMG]
+			[KNL,X86,IA-64,PPC] This parameter is similar to
+			memmap except it specifies the memory map of
+			ZONE_MOVABLE.
+			If more areas are all within one node, then from
+			lowest ss to the end of the node will be ZONE_MOVABLE.
+			If an area covers two or more nodes, the area from
+			ss to the end of the 1st node will be ZONE_MOVABLE,
+			and all the rest nodes will only have ZONE_MOVABLE.
+			If memmap is specified at the same time, the
+			movablecore_map will be limited within the memmap
+			areas. If kernelcore or movablecore is also specified,
+			movablecore_map will have higher priority to be
+			satisfied. So the administrator should be careful that
+			the amount of movablecore_map areas are not too large.
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
 
+#define MOVABLECORE_MAP_MAX MAX_NUMNODES
+struct movablecore_entry {
+	unsigned long start_pfn;    /* start pfn of memory segment */
+	unsigned long end_pfn;      /* end pfn of memory segment */
+};
+
+struct movablecore_map {
+	int nr_map;
+	struct movablecore_entry map[MOVABLECORE_MAP_MAX];
+};
+
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 #if !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && \
diff -puN mm/page_alloc.c~page_alloc-add-movable_memmap-kernel-parameter mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-add-movable_memmap-kernel-parameter
+++ a/mm/page_alloc.c
@@ -201,6 +201,9 @@ static unsigned long __meminitdata nr_al
 static unsigned long __meminitdata dma_reserve;
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+/* Movable memory ranges, will also be used by memblock subsystem. */
+struct movablecore_map movablecore_map;
+
 static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __initdata required_kernelcore;
@@ -5070,6 +5073,129 @@ static int __init cmdline_parse_movablec
 early_param("kernelcore", cmdline_parse_kernelcore);
 early_param("movablecore", cmdline_parse_movablecore);
 
+/**
+ * insert_movablecore_map - Insert a memory range in to movablecore_map.map.
+ * @start_pfn: start pfn of the range
+ * @end_pfn: end pfn of the range
+ *
+ * This function will also merge the overlapped ranges, and sort the array
+ * by start_pfn in monotonic increasing order.
+ */
+static void __init insert_movablecore_map(unsigned long start_pfn,
+					  unsigned long end_pfn)
+{
+	int pos, overlap;
+
+	/*
+	 * pos will be at the 1st overlapped range, or the position
+	 * where the element should be inserted.
+	 */
+	for (pos = 0; pos < movablecore_map.nr_map; pos++)
+		if (start_pfn <= movablecore_map.map[pos].end_pfn)
+			break;
+
+	/* If there is no overlapped range, just insert the element. */
+	if (pos == movablecore_map.nr_map ||
+	    end_pfn < movablecore_map.map[pos].start_pfn) {
+		/*
+		 * If pos is not the end of array, we need to move all
+		 * the rest elements backward.
+		 */
+		if (pos < movablecore_map.nr_map)
+			memmove(&movablecore_map.map[pos+1],
+				&movablecore_map.map[pos],
+				sizeof(struct movablecore_entry) *
+				(movablecore_map.nr_map - pos));
+		movablecore_map.map[pos].start_pfn = start_pfn;
+		movablecore_map.map[pos].end_pfn = end_pfn;
+		movablecore_map.nr_map++;
+		return;
+	}
+
+	/* overlap will be at the last overlapped range */
+	for (overlap = pos + 1; overlap < movablecore_map.nr_map; overlap++)
+		if (end_pfn < movablecore_map.map[overlap].start_pfn)
+			break;
+
+	/*
+	 * If there are more ranges overlapped, we need to merge them,
+	 * and move the rest elements forward.
+	 */
+	overlap--;
+	movablecore_map.map[pos].start_pfn = min(start_pfn,
+					movablecore_map.map[pos].start_pfn);
+	movablecore_map.map[pos].end_pfn = max(end_pfn,
+					movablecore_map.map[overlap].end_pfn);
+
+	if (pos != overlap && overlap + 1 != movablecore_map.nr_map)
+		memmove(&movablecore_map.map[pos+1],
+			&movablecore_map.map[overlap+1],
+			sizeof(struct movablecore_entry) *
+			(movablecore_map.nr_map - overlap - 1));
+
+	movablecore_map.nr_map -= overlap - pos;
+}
+
+/**
+ * movablecore_map_add_region - Add a memory range into movablecore_map.
+ * @start: physical start address of range
+ * @end: physical end address of range
+ *
+ * This function transform the physical address into pfn, and then add the
+ * range into movablecore_map by calling insert_movablecore_map().
+ */
+static void __init movablecore_map_add_region(u64 start, u64 size)
+{
+	unsigned long start_pfn, end_pfn;
+
+	/* In case size == 0 or start + size overflows */
+	if (start + size <= start)
+		return;
+
+	if (movablecore_map.nr_map >= ARRAY_SIZE(movablecore_map.map)) {
+		pr_err("movable_memory_map: too many entries;"
+			" ignoring [mem %#010llx-%#010llx]\n",
+			(unsigned long long) start,
+			(unsigned long long) (start + size - 1));
+		return;
+	}
+
+	start_pfn = PFN_DOWN(start);
+	end_pfn = PFN_UP(start + size);
+	insert_movablecore_map(start_pfn, end_pfn);
+}
+
+/*
+ * movablecore_map=nn[KMG]@ss[KMG] sets the region of memory to be used as
+ * movable memory.
+ */
+static int __init cmdline_parse_movablecore_map(char *p)
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
+		movablecore_map_add_region(start_at, mem_size);
+		return 0;
+	}
+err:
+	return -EINVAL;
+}
+early_param("movablecore_map", cmdline_parse_movablecore_map);
+
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 /**
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

