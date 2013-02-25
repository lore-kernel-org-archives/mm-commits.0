From: akpm@linux-foundation.org
Subject: [merged] acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:51:28 -0800
Message-ID: <20130225205129.0D0C15A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:37250 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759636Ab3BYUvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:51:31 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so347171vch.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:51:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, len.brown@intel.com, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acpi, memory-hotplug: support getting hotplug info from SRAT
has been removed from the -mm tree.  Its filename was
     acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: acpi, memory-hotplug: support getting hotplug info from SRAT

We now provide an option for users who don't want to specify physical
memory address in kernel commandline.

         /*
          * For movablemem_map=acpi:
          *
          * SRAT:                |_____| |_____| |_________| |_________| ......
          * node id:                0       1         1           2
          * hotpluggable:           n       y         y           n
          * movablemem_map:              |_____| |_________|
          *
          * Using movablemem_map, we can prevent memblock from allocating memory
          * on ZONE_MOVABLE at boot time.
          */

So user just specify movablemem_map=acpi, and the kernel will use
hotpluggable info in SRAT to determine which memory ranges should be set
as ZONE_MOVABLE.

If all the memory ranges in SRAT is hotpluggable, then no memory can be
used by kernel.  But before parsing SRAT, memblock has already reserve
some memory ranges for other purposes, such as for kernel image, and so
on.  We cannot prevent kernel from using these memory.  So we need to
exclude these ranges even if these memory is hotpluggable.

Furthermore, there could be several memory ranges in the single node which
the kernel resides in.  We may skip one range that have memory reserved by
memblock, but if the rest of memory is too small, then the kernel will
fail to boot.  So, make the whole node which the kernel resides in
un-hotpluggable.  Then the kernel has enough memory to use.

NOTE: Using this way will cause NUMA performance down because the
      whole node will be set as ZONE_MOVABLE, and kernel cannot use memory
      on it.  If users don't want to lose NUMA performance, just don't use
      it.

[akpm@linux-foundation.org: fix warning]
[akpm@linux-foundation.org: use strcmp()]
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

 Documentation/kernel-parameters.txt |   29 ++++++++--
 arch/x86/mm/srat.c                  |   71 ++++++++++++++++++++++++--
 include/linux/mm.h                  |    2 
 mm/page_alloc.c                     |   22 +++++++-
 4 files changed, 113 insertions(+), 11 deletions(-)

diff -puN Documentation/kernel-parameters.txt~acpi-memory-hotplug-support-getting-hotplug-info-from-srat Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~acpi-memory-hotplug-support-getting-hotplug-info-from-srat
+++ a/Documentation/kernel-parameters.txt
@@ -1640,15 +1640,30 @@ bytes respectively. Such letter suffixes
 			that the amount of memory usable for all allocations
 			is not too small.
 
+	movablemem_map=acpi
+			[KNL,X86,IA-64,PPC] This parameter is similar to
+			memmap except it specifies the memory map of
+			ZONE_MOVABLE.
+			This option inform the kernel to use Hot Pluggable bit
+			in flags from SRAT from ACPI BIOS to determine which
+			memory devices could be hotplugged. The corresponding
+			memory ranges will be set as ZONE_MOVABLE.
+			NOTE: Whatever node the kernel resides in will always
+			      be un-hotpluggable.
+
 	movablemem_map=nn[KMG]@ss[KMG]
 			[KNL,X86,IA-64,PPC] This parameter is similar to
 			memmap except it specifies the memory map of
 			ZONE_MOVABLE.
-			If more areas are all within one node, then from
-			lowest ss to the end of the node will be ZONE_MOVABLE.
-			If an area covers two or more nodes, the area from
-			ss to the end of the 1st node will be ZONE_MOVABLE,
-			and all the rest nodes will only have ZONE_MOVABLE.
+			If user specifies memory ranges, the info in SRAT will
+			be ingored. And it works like the following:
+			- If more ranges are all within one node, then from
+			  lowest ss to the end of the node will be ZONE_MOVABLE.
+			- If a range is within a node, then from ss to the end
+			  of the node will be ZONE_MOVABLE.
+			- If a range covers two or more nodes, then from ss to
+			  the end of the 1st node will be ZONE_MOVABLE, and all
+			  the rest nodes will only have ZONE_MOVABLE.
 			If memmap is specified at the same time, the
 			movablemem_map will be limited within the memmap
 			areas. If kernelcore or movablecore is also specified,
@@ -1656,6 +1671,10 @@ bytes respectively. Such letter suffixes
 			satisfied. So the administrator should be careful that
 			the amount of movablemem_map areas are not too large.
 			Otherwise kernel won't have enough memory to start.
+			NOTE: We don't stop users specifying the node the
+			      kernel resides in as hotpluggable so that this
+			      option can be used as a workaround of firmware
+                              bugs.
 
 	MTD_Partition=	[MTD]
 			Format: <name>,<region-number>,<size>,<offset>
diff -puN arch/x86/mm/srat.c~acpi-memory-hotplug-support-getting-hotplug-info-from-srat arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~acpi-memory-hotplug-support-getting-hotplug-info-from-srat
+++ a/arch/x86/mm/srat.c
@@ -142,16 +142,72 @@ static inline int save_add_info(void) {r
 #endif
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-static void __init handle_movablemem(int node, u64 start, u64 end)
+static void __init
+handle_movablemem(int node, u64 start, u64 end, u32 hotpluggable)
 {
-	int overlap;
+	int overlap, i;
 	unsigned long start_pfn, end_pfn;
 
 	start_pfn = PFN_DOWN(start);
 	end_pfn = PFN_UP(end);
 
 	/*
-	 * For movablecore_map=nn[KMG]@ss[KMG]:
+	 * For movablemem_map=acpi:
+	 *
+	 * SRAT:		|_____| |_____| |_________| |_________| ......
+	 * node id:                0       1         1           2
+	 * hotpluggable:	   n       y         y           n
+	 * movablemem_map:	        |_____| |_________|
+	 *
+	 * Using movablemem_map, we can prevent memblock from allocating memory
+	 * on ZONE_MOVABLE at boot time.
+	 *
+	 * Before parsing SRAT, memblock has already reserve some memory ranges
+	 * for other purposes, such as for kernel image. We cannot prevent
+	 * kernel from using these memory, so we need to exclude these memory
+	 * even if it is hotpluggable.
+	 * Furthermore, to ensure the kernel has enough memory to boot, we make
+	 * all the memory on the node which the kernel resides in
+	 * un-hotpluggable.
+	 */
+	if (hotpluggable && movablemem_map.acpi) {
+		/* Exclude ranges reserved by memblock. */
+		struct memblock_type *rgn = &memblock.reserved;
+
+		for (i = 0; i < rgn->cnt; i++) {
+			if (end <= rgn->regions[i].base ||
+			    start >= rgn->regions[i].base +
+			    rgn->regions[i].size)
+				continue;
+
+			/*
+			 * If the memory range overlaps the memory reserved by
+			 * memblock, then the kernel resides in this node.
+			 */
+			node_set(node, movablemem_map.numa_nodes_kernel);
+
+			goto out;
+		}
+
+		/*
+		 * If the kernel resides in this node, then the whole node
+		 * should not be hotpluggable.
+		 */
+		if (node_isset(node, movablemem_map.numa_nodes_kernel))
+			goto out;
+
+		insert_movablemem_map(start_pfn, end_pfn);
+
+		/*
+		 * numa_nodes_hotplug nodemask represents which nodes are put
+		 * into movablemem_map.map[].
+		 */
+		node_set(node, movablemem_map.numa_nodes_hotplug);
+		goto out;
+	}
+
+	/*
+	 * For movablemem_map=nn[KMG]@ss[KMG]:
 	 *
 	 * SRAT:		|_____| |_____| |_________| |_________| ......
 	 * node id:		   0       1         1           2
@@ -160,6 +216,8 @@ static void __init handle_movablemem(int
 	 *
 	 * Using movablemem_map, we can prevent memblock from allocating memory
 	 * on ZONE_MOVABLE at boot time.
+	 *
+	 * NOTE: In this case, SRAT info will be ingored.
 	 */
 	overlap = movablemem_map_overlap(start_pfn, end_pfn);
 	if (overlap >= 0) {
@@ -187,9 +245,12 @@ static void __init handle_movablemem(int
 			 */
 			insert_movablemem_map(start_pfn, end_pfn);
 	}
+out:
+	return;
 }
 #else		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
-static inline void handle_movablemem(int node, u64 start, u64 end)
+static inline void
+handle_movablemem(int node, u64 start, u64 end, u32 hotpluggable)
 {
 }
 #endif		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
@@ -234,7 +295,7 @@ acpi_numa_memory_affinity_init(struct ac
 	       (unsigned long long) start, (unsigned long long) end - 1,
 	       hotpluggable ? "Hot Pluggable": "");
 
-	handle_movablemem(node, start, end);
+	handle_movablemem(node, start, end, hotpluggable);
 
 	return 0;
 out_err_bad_srat:
diff -puN include/linux/mm.h~acpi-memory-hotplug-support-getting-hotplug-info-from-srat include/linux/mm.h
--- a/include/linux/mm.h~acpi-memory-hotplug-support-getting-hotplug-info-from-srat
+++ a/include/linux/mm.h
@@ -1366,9 +1366,11 @@ struct movablemem_entry {
 };
 
 struct movablemem_map {
+	bool acpi;	/* true if using SRAT info */
 	int nr_map;
 	struct movablemem_entry map[MOVABLEMEM_MAP_MAX];
 	nodemask_t numa_nodes_hotplug;	/* on which nodes we specify memory */
+	nodemask_t numa_nodes_kernel;	/* on which nodes kernel resides in */
 };
 
 extern void __init insert_movablemem_map(unsigned long start_pfn,
diff -puN mm/page_alloc.c~acpi-memory-hotplug-support-getting-hotplug-info-from-srat mm/page_alloc.c
--- a/mm/page_alloc.c~acpi-memory-hotplug-support-getting-hotplug-info-from-srat
+++ a/mm/page_alloc.c
@@ -203,7 +203,10 @@ static unsigned long __meminitdata dma_r
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /* Movable memory ranges, will also be used by memblock subsystem. */
-struct movablemem_map movablemem_map;
+struct movablemem_map movablemem_map = {
+	.acpi = false,
+	.nr_map = 0,
+};
 
 static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
@@ -5314,6 +5317,23 @@ static int __init cmdline_parse_movablem
 	if (!p)
 		goto err;
 
+	if (!strcmp(p, "acpi"))
+		movablemem_map.acpi = true;
+
+	/*
+	 * If user decide to use info from BIOS, all the other user specified
+	 * ranges will be ingored.
+	 */
+	if (movablemem_map.acpi) {
+		if (movablemem_map.nr_map) {
+			memset(movablemem_map.map, 0,
+				sizeof(struct movablemem_entry)
+				* movablemem_map.nr_map);
+			movablemem_map.nr_map = 0;
+		}
+		return 0;
+	}
+
 	oldp = p;
 	mem_size = memparse(p, &p);
 	if (p == oldp)
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

