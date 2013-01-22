From: akpm@linux-foundation.org
Subject: + page_alloc-add-movable_memmap-kernel-parameter-rename-movablecore_map-to-movablemem_map.patch added to -mm tree
Date: Tue, 22 Jan 2013 14:24:42 -0800
Message-ID: <20130122222442.A912131C257@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:59019 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3AVWYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 17:24:44 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so694880vcd.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 14:24:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, hpa@zytor.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com, wency@cn.fujitsu.com


The patch titled
     Subject: Rename movablecore_map to movablemem_map.
has been added to the -mm tree.  Its filename is
     page_alloc-add-movable_memmap-kernel-parameter-rename-movablecore_map-to-movablemem_map.patch

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
Subject: Rename movablecore_map to movablemem_map.

Since "core" could be confused with cpu cores, but here it is memory,
so rename the boot option movablecore_map to movablemem_map.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    8 +-
 include/linux/mm.h                  |    8 +-
 mm/page_alloc.c                     |   78 +++++++++++++-------------
 3 files changed, 47 insertions(+), 47 deletions(-)

diff -puN Documentation/kernel-parameters.txt~page_alloc-add-movable_memmap-kernel-parameter-rename-movablecore_map-to-movablemem_map Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~page_alloc-add-movable_memmap-kernel-parameter-rename-movablecore_map-to-movablemem_map
+++ a/Documentation/kernel-parameters.txt
@@ -1637,7 +1637,7 @@ bytes respectively. Such letter suffixes
 			that the amount of memory usable for all allocations
 			is not too small.
 
-	movablecore_map=nn[KMG]@ss[KMG]
+	movablemem_map=nn[KMG]@ss[KMG]
 			[KNL,X86,IA-64,PPC] This parameter is similar to
 			memmap except it specifies the memory map of
 			ZONE_MOVABLE.
@@ -1647,11 +1647,11 @@ bytes respectively. Such letter suffixes
 			ss to the end of the 1st node will be ZONE_MOVABLE,
 			and all the rest nodes will only have ZONE_MOVABLE.
 			If memmap is specified at the same time, the
-			movablecore_map will be limited within the memmap
+			movablemem_map will be limited within the memmap
 			areas. If kernelcore or movablecore is also specified,
-			movablecore_map will have higher priority to be
+			movablemem_map will have higher priority to be
 			satisfied. So the administrator should be careful that
-			the amount of movablecore_map areas are not too large.
+			the amount of movablemem_map areas are not too large.
 			Otherwise kernel won't have enough memory to start.
 
 	MTD_Partition=	[MTD]
diff -puN include/linux/memblock.h~page_alloc-add-movable_memmap-kernel-parameter-rename-movablecore_map-to-movablemem_map include/linux/memblock.h
diff -puN include/linux/mm.h~page_alloc-add-movable_memmap-kernel-parameter-rename-movablecore_map-to-movablemem_map include/linux/mm.h
--- a/include/linux/mm.h~page_alloc-add-movable_memmap-kernel-parameter-rename-movablecore_map-to-movablemem_map
+++ a/include/linux/mm.h
@@ -1359,15 +1359,15 @@ extern void free_bootmem_with_active_reg
 						unsigned long max_low_pfn);
 extern void sparse_memory_present_with_active_regions(int nid);
 
-#define MOVABLECORE_MAP_MAX MAX_NUMNODES
-struct movablecore_entry {
+#define MOVABLEMEM_MAP_MAX MAX_NUMNODES
+struct movablemem_entry {
 	unsigned long start_pfn;    /* start pfn of memory segment */
 	unsigned long end_pfn;      /* end pfn of memory segment (exclusive) */
 };
 
-struct movablecore_map {
+struct movablemem_map {
 	int nr_map;
-	struct movablecore_entry map[MOVABLECORE_MAP_MAX];
+	struct movablemem_entry map[MOVABLEMEM_MAP_MAX];
 };
 
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
diff -puN mm/memblock.c~page_alloc-add-movable_memmap-kernel-parameter-rename-movablecore_map-to-movablemem_map mm/memblock.c
diff -puN mm/page_alloc.c~page_alloc-add-movable_memmap-kernel-parameter-rename-movablecore_map-to-movablemem_map mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-add-movable_memmap-kernel-parameter-rename-movablecore_map-to-movablemem_map
+++ a/mm/page_alloc.c
@@ -202,7 +202,7 @@ static unsigned long __meminitdata dma_r
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /* Movable memory ranges, will also be used by memblock subsystem. */
-struct movablecore_map movablecore_map;
+struct movablemem_map movablemem_map;
 
 static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
@@ -5074,14 +5074,14 @@ early_param("kernelcore", cmdline_parse_
 early_param("movablecore", cmdline_parse_movablecore);
 
 /**
- * insert_movablecore_map - Insert a memory range in to movablecore_map.map.
+ * insert_movablemem_map - Insert a memory range in to movablemem_map.map.
  * @start_pfn:	start pfn of the range
  * @end_pfn:	end pfn of the range
  *
  * This function will also merge the overlapped ranges, and sort the array
  * by start_pfn in monotonic increasing order.
  */
-static void __init insert_movablecore_map(unsigned long start_pfn,
+static void __init insert_movablemem_map(unsigned long start_pfn,
 					  unsigned long end_pfn)
 {
 	int pos, overlap;
@@ -5090,31 +5090,31 @@ static void __init insert_movablecore_ma
 	 * pos will be at the 1st overlapped range, or the position
 	 * where the element should be inserted.
 	 */
-	for (pos = 0; pos < movablecore_map.nr_map; pos++)
-		if (start_pfn <= movablecore_map.map[pos].end_pfn)
+	for (pos = 0; pos < movablemem_map.nr_map; pos++)
+		if (start_pfn <= movablemem_map.map[pos].end_pfn)
 			break;
 
 	/* If there is no overlapped range, just insert the element. */
-	if (pos == movablecore_map.nr_map ||
-	    end_pfn < movablecore_map.map[pos].start_pfn) {
+	if (pos == movablemem_map.nr_map ||
+	    end_pfn < movablemem_map.map[pos].start_pfn) {
 		/*
 		 * If pos is not the end of array, we need to move all
 		 * the rest elements backward.
 		 */
-		if (pos < movablecore_map.nr_map)
-			memmove(&movablecore_map.map[pos+1],
-				&movablecore_map.map[pos],
-				sizeof(struct movablecore_entry) *
-				(movablecore_map.nr_map - pos));
-		movablecore_map.map[pos].start_pfn = start_pfn;
-		movablecore_map.map[pos].end_pfn = end_pfn;
-		movablecore_map.nr_map++;
+		if (pos < movablemem_map.nr_map)
+			memmove(&movablemem_map.map[pos+1],
+				&movablemem_map.map[pos],
+				sizeof(struct movablemem_entry) *
+				(movablemem_map.nr_map - pos));
+		movablemem_map.map[pos].start_pfn = start_pfn;
+		movablemem_map.map[pos].end_pfn = end_pfn;
+		movablemem_map.nr_map++;
 		return;
 	}
 
 	/* overlap will be at the last overlapped range */
-	for (overlap = pos + 1; overlap < movablecore_map.nr_map; overlap++)
-		if (end_pfn < movablecore_map.map[overlap].start_pfn)
+	for (overlap = pos + 1; overlap < movablemem_map.nr_map; overlap++)
+		if (end_pfn < movablemem_map.map[overlap].start_pfn)
 			break;
 
 	/*
@@ -5122,29 +5122,29 @@ static void __init insert_movablecore_ma
 	 * and move the rest elements forward.
 	 */
 	overlap--;
-	movablecore_map.map[pos].start_pfn = min(start_pfn,
-					movablecore_map.map[pos].start_pfn);
-	movablecore_map.map[pos].end_pfn = max(end_pfn,
-					movablecore_map.map[overlap].end_pfn);
-
-	if (pos != overlap && overlap + 1 != movablecore_map.nr_map)
-		memmove(&movablecore_map.map[pos+1],
-			&movablecore_map.map[overlap+1],
-			sizeof(struct movablecore_entry) *
-			(movablecore_map.nr_map - overlap - 1));
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
 
-	movablecore_map.nr_map -= overlap - pos;
+	movablemem_map.nr_map -= overlap - pos;
 }
 
 /**
- * movablecore_map_add_region - Add a memory range into movablecore_map.
+ * movablemem_map_add_region - Add a memory range into movablemem_map.
  * @start:	physical start address of range
  * @end:	physical end address of range
  *
  * This function transform the physical address into pfn, and then add the
- * range into movablecore_map by calling insert_movablecore_map().
+ * range into movablemem_map by calling insert_movablemem_map().
  */
-static void __init movablecore_map_add_region(u64 start, u64 size)
+static void __init movablemem_map_add_region(u64 start, u64 size)
 {
 	unsigned long start_pfn, end_pfn;
 
@@ -5152,8 +5152,8 @@ static void __init movablecore_map_add_r
 	if (start + size <= start)
 		return;
 
-	if (movablecore_map.nr_map >= ARRAY_SIZE(movablecore_map.map)) {
-		pr_err("movable_memory_map: too many entries;"
+	if (movablemem_map.nr_map >= ARRAY_SIZE(movablemem_map.map)) {
+		pr_err("movablemem_map: too many entries;"
 			" ignoring [mem %#010llx-%#010llx]\n",
 			(unsigned long long) start,
 			(unsigned long long) (start + size - 1));
@@ -5162,19 +5162,19 @@ static void __init movablecore_map_add_r
 
 	start_pfn = PFN_DOWN(start);
 	end_pfn = PFN_UP(start + size);
-	insert_movablecore_map(start_pfn, end_pfn);
+	insert_movablemem_map(start_pfn, end_pfn);
 }
 
 /*
- * cmdline_parse_movablecore_map - Parse boot option movablecore_map.
+ * cmdline_parse_movablemem_map - Parse boot option movablemem_map.
  * @p:	The boot option of the following format:
- *	movablecore_map=nn[KMG]@ss[KMG]
+ *	movablemem_map=nn[KMG]@ss[KMG]
  *
  * This option sets the memory range [ss, ss+nn) to be used as movable memory.
  *
  * Return: 0 on success or -EINVAL on failure.
  */
-static int __init cmdline_parse_movablecore_map(char *p)
+static int __init cmdline_parse_movablemem_map(char *p)
 {
 	char *oldp;
 	u64 start_at, mem_size;
@@ -5193,13 +5193,13 @@ static int __init cmdline_parse_movablec
 		if (p == oldp || *p != '\0')
 			goto err;
 
-		movablecore_map_add_region(start_at, mem_size);
+		movablemem_map_add_region(start_at, mem_size);
 		return 0;
 	}
 err:
 	return -EINVAL;
 }
-early_param("movablecore_map", cmdline_parse_movablecore_map);
+early_param("movablemem_map", cmdline_parse_movablemem_map);
 
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix-fix.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
memory-hotplug-consider-compound-pages-when-free-memmap.patch
mempolicy-fix-is_valid_nodemask.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch
memory-hotplug-export-the-function-try_offline_node.patch
cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch
sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node.patch
bug-fix-use-config_have_memblock_node_map-to-protect-movablecore_map-in-memblock_overlaps_region.patch
x86-get-pg_data_ts-memory-from-other-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-rename-movablecore_map-to-movablemem_map.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes-fix.patch
page_alloc-make-movablecore_map-has-higher-priority.patch
page_alloc-bootmem-limit-with-movablecore_map.patch

