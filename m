From: akpm@linux-foundation.org
Subject: + acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch added to -mm tree
Date: Fri, 25 Jan 2013 16:41:03 -0800
Message-ID: <20130126004104.5E62931C1F5@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:39522 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab3AZAlG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 19:41:06 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so96711ghb.2
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 16:41:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, len.brown@intel.com, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de, wujianguo@huawei.com


The patch titled
     Subject: acpi, memory-hotplug: support getting hotplug info from SRAT
has been added to the -mm tree.  Its filename is
     acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch

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

NOTE: Using this way will cause NUMA performance down because the whole node
      will be set as ZONE_MOVABLE, and kernel cannot use memory on it.
      If users don't want to lose NUMA performance, just don't use it.

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

 Documentation/kernel-parameters.txt |   23 +++++++++++++++----
 arch/x86/mm/srat.c                  |   30 ++++++++++++++++++++++----
 include/linux/mm.h                  |    1 
 mm/page_alloc.c                     |   22 ++++++++++++++++++-
 4 files changed, 66 insertions(+), 10 deletions(-)

diff -puN Documentation/kernel-parameters.txt~acpi-memory-hotplug-support-getting-hotplug-info-from-srat Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~acpi-memory-hotplug-support-getting-hotplug-info-from-srat
+++ a/Documentation/kernel-parameters.txt
@@ -1637,15 +1637,28 @@ bytes respectively. Such letter suffixes
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
diff -puN arch/x86/mm/srat.c~acpi-memory-hotplug-support-getting-hotplug-info-from-srat arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~acpi-memory-hotplug-support-getting-hotplug-info-from-srat
+++ a/arch/x86/mm/srat.c
@@ -142,7 +142,8 @@ static inline int save_add_info(void) {r
 #endif
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-static void __init handle_movablemem(int node, u64 start, u64 end)
+static void __init
+handle_movablemem(int node, u64 start, u64 end, u32 hotpluggable)
 {
 	int overlap;
 	unsigned long start_pfn, end_pfn;
@@ -151,7 +152,23 @@ static void __init handle_movablemem(int
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
+	 */
+	if (hotpluggable && movablemem_map.acpi) {
+		insert_movablemem_map(start_pfn, end_pfn);
+		goto out;
+	}
+
+	/*
+	 * For movablemem_map=nn[KMG]@ss[KMG]:
 	 *
 	 * SRAT:		|_____| |_____| |_________| |_________| ......
 	 * node id:		   0       1         1           2
@@ -160,6 +177,8 @@ static void __init handle_movablemem(int
 	 *
 	 * Using movablemem_map, we can prevent memblock from allocating memory
 	 * on ZONE_MOVABLE at boot time.
+	 *
+	 * NOTE: In this case, SRAT info will be ingored.
 	 */
 	overlap = movablemem_map_overlap(start_pfn, end_pfn);
 	if (overlap >= 0) {
@@ -187,9 +206,12 @@ static void __init handle_movablemem(int
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
@@ -234,7 +256,7 @@ acpi_numa_memory_affinity_init(struct ac
 	       (unsigned long long) start, (unsigned long long) end - 1,
 	       hotpluggable ? "Hot Pluggable": "");
 
-	handle_movablemem(node, start, end);
+	handle_movablemem(node, start, end, hotpluggable);
 
 	return 0;
 out_err_bad_srat:
diff -puN include/linux/mm.h~acpi-memory-hotplug-support-getting-hotplug-info-from-srat include/linux/mm.h
--- a/include/linux/mm.h~acpi-memory-hotplug-support-getting-hotplug-info-from-srat
+++ a/include/linux/mm.h
@@ -1366,6 +1366,7 @@ struct movablemem_entry {
 };
 
 struct movablemem_map {
+	bool acpi;	/* true if using SRAT info */
 	int nr_map;
 	struct movablemem_entry map[MOVABLEMEM_MAP_MAX];
 	nodemask_t numa_nodes_hotplug;	/* on which nodes we specify memory */
diff -puN mm/page_alloc.c~acpi-memory-hotplug-support-getting-hotplug-info-from-srat mm/page_alloc.c
--- a/mm/page_alloc.c~acpi-memory-hotplug-support-getting-hotplug-info-from-srat
+++ a/mm/page_alloc.c
@@ -202,7 +202,10 @@ static unsigned long __meminitdata dma_r
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /* Movable memory ranges, will also be used by memblock subsystem. */
-struct movablemem_map movablemem_map;
+struct movablemem_map movablemem_map = {
+	.acpi = false,
+	.nr_map = 0,
+};
 
 static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
@@ -5306,6 +5309,23 @@ static int __init cmdline_parse_movablem
 	if (!p)
 		goto err;
 
+	if (!strncmp(p, "acpi", max(4, strlen(p))))
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
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix-fix.patch
memory-hotplug-consider-compound-pages-when-free-memmap.patch
mempolicy-fix-is_valid_nodemask.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
memory-hotplug-export-the-function-try_offline_node.patch
memory-hotplug-export-the-function-try_offline_node-fix.patch
cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node.patch
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
acpi-memory-hotplug-parse-srat-before-memblock-is-ready.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch
mm-memblockc-use-config_have_memblock_node_map-to-protect-movablecore_map-in-memblock_overlaps_region.patch

