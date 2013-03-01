From: akpm@linux-foundation.org
Subject: + x86-acpi-mm-revert-movablemem_map-support.patch added to -mm tree
Date: Fri, 01 Mar 2013 15:01:04 -0800
Message-ID: <20130301230105.71FA731C1B5@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:38752 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3CAXBI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Mar 2013 18:01:08 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so393741ggn.0
        for <mm-commits@vger.kernel.org>; Fri, 01 Mar 2013 15:01:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, don.morris@hp.com, isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com, tim.gardner@canonical.com, tj@kernel.org, tony.luck@intel.com, trenn@suse.de


The patch titled
     Subject: x86, ACPI, mm: revert movablemem_map support
has been added to the -mm tree.  Its filename is
     x86-acpi-mm-revert-movablemem_map-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: x86, ACPI, mm: revert movablemem_map support

Tim found:
[    0.181441] WARNING: at
/home/rtg/ukb/raring/amd64/unstable-3.9/ubuntu-raring/arch/x86/kernel/smpboot.c:324
topology_sane.isra.2+0x6f/0x80()
[    0.181443] Hardware name: S2600CP
[    0.181445] sched: CPU #1's llc-sibling CPU #0 is not on the same
node! [node: 1 != 0]. Ignoring dependency.
[    0.166925] smpboot: Booting Node   1, Processors  #1
[    0.181446] Modules linked in:
[    0.181451] Pid: 0, comm: swapper/1 Not tainted 3.9.0-0-generic #1
[    0.181452] Call Trace:
[    0.181457]  [<ffffffff816c0270>] ? topology_sane.isra.2+0x6f/0x80
[    0.181463]  [<ffffffff8105914f>] warn_slowpath_common+0x7f/0xc0
[    0.181469]  [<ffffffff8105924c>] warn_slowpath_fmt+0x4c/0x50
[    0.181473]  [<ffffffff816bf737>] ? mcheck_cpu_init+0x378/0x3fb
[    0.181478]  [<ffffffff816ca32b>] ? cpuid_eax+0x27/0x2e
[    0.181483]  [<ffffffff816c0270>] topology_sane.isra.2+0x6f/0x80
[    0.181488]  [<ffffffff816c0534>] set_cpu_sibling_map+0x279/0x449
[    0.181493]  [<ffffffff816c0821>] start_secondary+0x11d/0x1e5
[    0.181507] ---[ end trace 8c24ebb220b8c665 ]---

Don Morris reproduced on a HP z620 workstation, and bisect to
# bad: [e8d1955258091e4c92d5a975ebd7fd8a98f5d30f] acpi, memory-hotplug:
   parse SRAT before memblock is ready

It turns out movable_map has some problems, and it breaks several things

1. numa_init is called several times, NOT just for srat. so those
	nodes_clear(numa_nodes_parsed)
	memset(&numa_meminfo, 0, sizeof(numa_meminfo))
   can not be just removed.  Need to consider sequence is: numaq, srat, amd,
   dummy.  And make fall back path work.

2. simply split acpi_numa_init to early_parse_srat.
   a. that early_parse_srat is NOT called for ia64, so you break ia64.
   b.  for (i = 0; i < MAX_LOCAL_APIC; i++)
	     set_apicid_to_node(i, NUMA_NO_NODE)
     still left in numa_init. So it will just clear result from
     early_parse_srat.  It should be moved before that....
   c.  it breaks ACPI_TABLE_OVERIDE...as the acpi table scan is moved
       early before override from INITRD is settled.
3. that patch TITLE is total misleading, there is NO x86 in the title,
   but it changes critical x86 code. It caused x86 guys did not
   pay attention to find the problem early. Those patches really should
   be routed via tip/x86/mm.
4: after that commit, following range can not use movable ram:
  a. real_mode code.... well..funny, legacy Node0 [0,1M) could be hot-removed?
  b. initrd... it will be freed after booting, so it could be on movable...
  c. crashkernel for kdump...: looks like we can not put kdump kernel above 4G
	anymore.
  d. init_mem_mapping: can not put page table high anymore.
  e. initmem_init: vmemmap can not be high local node anymore. That is
     not good.

If node is hotplugable, the mem related range like page table and vmemmap
could be on the that node without problem and should be on that node.

We have workaround patch that could fix some problems, but some
can not be fixed.

So just remove that offending commit and related ones including:
commit f7210e6c4ac795694106c1c5307134d3fc233e88
    mm/memblock.c: use CONFIG_HAVE_MEMBLOCK_NODE_MAP to protect movablecore_map in memblock_overlaps_region().
commit 01a178a94e8eaec351b29ee49fbb3d1c124cb7fb
    acpi, memory-hotplug: support getting hotplug info from SRAT
commit 27168d38fa209073219abedbe6a9de7ba9acbfad
    acpi, memory-hotplug: extend movablemem_map ranges to the end of node
commit e8d1955258091e4c92d5a975ebd7fd8a98f5d30f
    acpi, memory-hotplug: parse SRAT before memblock is ready
commit fb06bc8e5f42f38c011de0e59481f464a82380f6
    page_alloc: bootmem limit with movablecore_map
commit 42f47e27e761fee07da69e04612ec7dd0d490edd
    page_alloc: make movablemem_map have higher priority
commit 6981ec31146cf19454c55c130625f6cee89aab95
    page_alloc: introduce zone_movable_limit[] to keep movable limit for nodes
commit 34b71f1e04fcba578e719e675b4882eeeb2a1f6f
    page_alloc: add movable_memmap kernel parameter
commit 4d59a75125d5a4717e57e9fc62c64b3d346e603e
    x86: get pg_data_t's memory from other node

Later we should have patches that will make sure kernel put page table
and vmemmap on local node ram instead of push them down to node0.
Also need to find way to put other kernel used ram to local node ram.

Reported-by: Tim Gardner <tim.gardner@canonical.com>
Reported-by: Don Morris <don.morris@hp.com>
Bisected-by: Don Morris <don.morris@hp.com>
Tested-by: Don Morris <don.morris@hp.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   36 ---
 arch/x86/kernel/setup.c             |   13 -
 arch/x86/mm/numa.c                  |   11 -
 arch/x86/mm/srat.c                  |  125 -----------
 drivers/acpi/numa.c                 |   23 --
 include/linux/acpi.h                |    8 
 include/linux/memblock.h            |    2 
 include/linux/mm.h                  |   18 -
 mm/memblock.c                       |   50 ----
 mm/page_alloc.c                     |  285 --------------------------
 10 files changed, 27 insertions(+), 544 deletions(-)

diff -puN Documentation/kernel-parameters.txt~x86-acpi-mm-revert-movablemem_map-support Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~x86-acpi-mm-revert-movablemem_map-support
+++ a/Documentation/kernel-parameters.txt
@@ -1649,42 +1649,6 @@ bytes respectively. Such letter suffixes
 			that the amount of memory usable for all allocations
 			is not too small.
 
-	movablemem_map=acpi
-			[KNL,X86,IA-64,PPC] This parameter is similar to
-			memmap except it specifies the memory map of
-			ZONE_MOVABLE.
-			This option inform the kernel to use Hot Pluggable bit
-			in flags from SRAT from ACPI BIOS to determine which
-			memory devices could be hotplugged. The corresponding
-			memory ranges will be set as ZONE_MOVABLE.
-			NOTE: Whatever node the kernel resides in will always
-			      be un-hotpluggable.
-
-	movablemem_map=nn[KMG]@ss[KMG]
-			[KNL,X86,IA-64,PPC] This parameter is similar to
-			memmap except it specifies the memory map of
-			ZONE_MOVABLE.
-			If user specifies memory ranges, the info in SRAT will
-			be ingored. And it works like the following:
-			- If more ranges are all within one node, then from
-			  lowest ss to the end of the node will be ZONE_MOVABLE.
-			- If a range is within a node, then from ss to the end
-			  of the node will be ZONE_MOVABLE.
-			- If a range covers two or more nodes, then from ss to
-			  the end of the 1st node will be ZONE_MOVABLE, and all
-			  the rest nodes will only have ZONE_MOVABLE.
-			If memmap is specified at the same time, the
-			movablemem_map will be limited within the memmap
-			areas. If kernelcore or movablecore is also specified,
-			movablemem_map will have higher priority to be
-			satisfied. So the administrator should be careful that
-			the amount of movablemem_map areas are not too large.
-			Otherwise kernel won't have enough memory to start.
-			NOTE: We don't stop users specifying the node the
-			      kernel resides in as hotpluggable so that this
-			      option can be used as a workaround of firmware
-                              bugs.
-
 	MTD_Partition=	[MTD]
 			Format: <name>,<region-number>,<size>,<offset>
 
diff -puN arch/x86/kernel/setup.c~x86-acpi-mm-revert-movablemem_map-support arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-acpi-mm-revert-movablemem_map-support
+++ a/arch/x86/kernel/setup.c
@@ -1056,15 +1056,6 @@ void __init setup_arch(char **cmdline_p)
 	setup_bios_corruption_check();
 #endif
 
-	/*
-	 * In the memory hotplug case, the kernel needs info from SRAT to
-	 * determine which memory is hotpluggable before allocating memory
-	 * using memblock.
-	 */
-	acpi_boot_table_init();
-	early_acpi_boot_init();
-	early_parse_srat();
-
 #ifdef CONFIG_X86_32
 	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
 			(max_pfn_mapped<<PAGE_SHIFT) - 1);
@@ -1110,6 +1101,10 @@ void __init setup_arch(char **cmdline_p)
 	/*
 	 * Parse the ACPI tables for possible boot-time SMP configuration.
 	 */
+	acpi_boot_table_init();
+
+	early_acpi_boot_init();
+
 	initmem_init();
 	memblock_find_dma_reserve();
 
diff -puN arch/x86/mm/numa.c~x86-acpi-mm-revert-movablemem_map-support arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~x86-acpi-mm-revert-movablemem_map-support
+++ a/arch/x86/mm/numa.c
@@ -212,9 +212,10 @@ static void __init setup_node_data(int n
 	 * Allocate node data.  Try node-local memory and then any node.
 	 * Never allocate in DMA zone.
 	 */
-	nd_pa = memblock_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
+	nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
 	if (!nd_pa) {
-		pr_err("Cannot find %zu bytes in any node\n", nd_size);
+		pr_err("Cannot find %zu bytes in node %d\n",
+		       nd_size, nid);
 		return;
 	}
 	nd = __va(nd_pa);
@@ -559,12 +560,10 @@ static int __init numa_init(int (*init_f
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		set_apicid_to_node(i, NUMA_NO_NODE);
 
-	/*
-	 * Do not clear numa_nodes_parsed or zero numa_meminfo here, because
-	 * SRAT was parsed earlier in early_parse_srat().
-	 */
+	nodes_clear(numa_nodes_parsed);
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
+	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
 	WARN_ON(memblock_set_node(0, ULLONG_MAX, MAX_NUMNODES));
 	numa_reset_distance();
 
diff -puN arch/x86/mm/srat.c~x86-acpi-mm-revert-movablemem_map-support arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~x86-acpi-mm-revert-movablemem_map-support
+++ a/arch/x86/mm/srat.c
@@ -141,126 +141,11 @@ static inline int save_add_info(void) {r
 static inline int save_add_info(void) {return 0;}
 #endif
 
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-static void __init
-handle_movablemem(int node, u64 start, u64 end, u32 hotpluggable)
-{
-	int overlap, i;
-	unsigned long start_pfn, end_pfn;
-
-	start_pfn = PFN_DOWN(start);
-	end_pfn = PFN_UP(end);
-
-	/*
-	 * For movablemem_map=acpi:
-	 *
-	 * SRAT:		|_____| |_____| |_________| |_________| ......
-	 * node id:                0       1         1           2
-	 * hotpluggable:	   n       y         y           n
-	 * movablemem_map:	        |_____| |_________|
-	 *
-	 * Using movablemem_map, we can prevent memblock from allocating memory
-	 * on ZONE_MOVABLE at boot time.
-	 *
-	 * Before parsing SRAT, memblock has already reserve some memory ranges
-	 * for other purposes, such as for kernel image. We cannot prevent
-	 * kernel from using these memory, so we need to exclude these memory
-	 * even if it is hotpluggable.
-	 * Furthermore, to ensure the kernel has enough memory to boot, we make
-	 * all the memory on the node which the kernel resides in
-	 * un-hotpluggable.
-	 */
-	if (hotpluggable && movablemem_map.acpi) {
-		/* Exclude ranges reserved by memblock. */
-		struct memblock_type *rgn = &memblock.reserved;
-
-		for (i = 0; i < rgn->cnt; i++) {
-			if (end <= rgn->regions[i].base ||
-			    start >= rgn->regions[i].base +
-			    rgn->regions[i].size)
-				continue;
-
-			/*
-			 * If the memory range overlaps the memory reserved by
-			 * memblock, then the kernel resides in this node.
-			 */
-			node_set(node, movablemem_map.numa_nodes_kernel);
-
-			goto out;
-		}
-
-		/*
-		 * If the kernel resides in this node, then the whole node
-		 * should not be hotpluggable.
-		 */
-		if (node_isset(node, movablemem_map.numa_nodes_kernel))
-			goto out;
-
-		insert_movablemem_map(start_pfn, end_pfn);
-
-		/*
-		 * numa_nodes_hotplug nodemask represents which nodes are put
-		 * into movablemem_map.map[].
-		 */
-		node_set(node, movablemem_map.numa_nodes_hotplug);
-		goto out;
-	}
-
-	/*
-	 * For movablemem_map=nn[KMG]@ss[KMG]:
-	 *
-	 * SRAT:		|_____| |_____| |_________| |_________| ......
-	 * node id:		   0       1         1           2
-	 * user specified:	          |__|                 |___|
-	 * movablemem_map:		  |___| |_________|    |______| ......
-	 *
-	 * Using movablemem_map, we can prevent memblock from allocating memory
-	 * on ZONE_MOVABLE at boot time.
-	 *
-	 * NOTE: In this case, SRAT info will be ingored.
-	 */
-	overlap = movablemem_map_overlap(start_pfn, end_pfn);
-	if (overlap >= 0) {
-		/*
-		 * If part of this range is in movablemem_map, we need to
-		 * add the range after it to extend the range to the end
-		 * of the node, because from the min address specified to
-		 * the end of the node will be ZONE_MOVABLE.
-		 */
-		start_pfn = max(start_pfn,
-			    movablemem_map.map[overlap].start_pfn);
-		insert_movablemem_map(start_pfn, end_pfn);
-
-		/*
-		 * Set the nodemask, so that if the address range on one node
-		 * is not continuse, we can add the subsequent ranges on the
-		 * same node into movablemem_map.
-		 */
-		node_set(node, movablemem_map.numa_nodes_hotplug);
-	} else {
-		if (node_isset(node, movablemem_map.numa_nodes_hotplug))
-			/*
-			 * Insert the range if we already have movable ranges
-			 * on the same node.
-			 */
-			insert_movablemem_map(start_pfn, end_pfn);
-	}
-out:
-	return;
-}
-#else		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
-static inline void
-handle_movablemem(int node, u64 start, u64 end, u32 hotpluggable)
-{
-}
-#endif		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
-
 /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
 int __init
 acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 {
 	u64 start, end;
-	u32 hotpluggable;
 	int node, pxm;
 
 	if (srat_disabled())
@@ -269,8 +154,7 @@ acpi_numa_memory_affinity_init(struct ac
 		goto out_err_bad_srat;
 	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
 		goto out_err;
-	hotpluggable = ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE;
-	if (hotpluggable && !save_add_info())
+	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
 		goto out_err;
 
 	start = ma->base_address;
@@ -290,12 +174,9 @@ acpi_numa_memory_affinity_init(struct ac
 
 	node_set(node, numa_nodes_parsed);
 
-	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx] %s\n",
+	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
 	       node, pxm,
-	       (unsigned long long) start, (unsigned long long) end - 1,
-	       hotpluggable ? "Hot Pluggable": "");
-
-	handle_movablemem(node, start, end, hotpluggable);
+	       (unsigned long long) start, (unsigned long long) end - 1);
 
 	return 0;
 out_err_bad_srat:
diff -puN drivers/acpi/numa.c~x86-acpi-mm-revert-movablemem_map-support drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~x86-acpi-mm-revert-movablemem_map-support
+++ a/drivers/acpi/numa.c
@@ -282,10 +282,10 @@ acpi_table_parse_srat(enum acpi_srat_typ
 					    handler, max_entries);
 }
 
-static int srat_mem_cnt;
-
-void __init early_parse_srat(void)
+int __init acpi_numa_init(void)
 {
+	int cnt = 0;
+
 	/*
 	 * Should not limit number with cpu num that is from NR_CPUS or nr_cpus=
 	 * SRAT cpu entries could have different order with that in MADT.
@@ -295,24 +295,21 @@ void __init early_parse_srat(void)
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
-				      acpi_parse_x2apic_affinity, 0);
+				     acpi_parse_x2apic_affinity, 0);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
-				      acpi_parse_processor_affinity, 0);
-		srat_mem_cnt = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
-						     acpi_parse_memory_affinity,
-						     NR_NODE_MEMBLKS);
+				     acpi_parse_processor_affinity, 0);
+		cnt = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
+					    acpi_parse_memory_affinity,
+					    NR_NODE_MEMBLKS);
 	}
-}
 
-int __init acpi_numa_init(void)
-{
 	/* SLIT: System Locality Information Table */
 	acpi_table_parse(ACPI_SIG_SLIT, acpi_parse_slit);
 
 	acpi_numa_arch_fixup();
 
-	if (srat_mem_cnt < 0)
-		return srat_mem_cnt;
+	if (cnt < 0)
+		return cnt;
 	else if (!parsed_numa_memblks)
 		return -ENOENT;
 	return 0;
diff -puN include/linux/acpi.h~x86-acpi-mm-revert-movablemem_map-support include/linux/acpi.h
--- a/include/linux/acpi.h~x86-acpi-mm-revert-movablemem_map-support
+++ a/include/linux/acpi.h
@@ -485,14 +485,6 @@ static inline bool acpi_driver_match_dev
 
 #endif	/* !CONFIG_ACPI */
 
-#ifdef CONFIG_ACPI_NUMA
-void __init early_parse_srat(void);
-#else
-static inline void early_parse_srat(void)
-{
-}
-#endif
-
 #ifdef CONFIG_ACPI
 void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
 			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
diff -puN include/linux/memblock.h~x86-acpi-mm-revert-movablemem_map-support include/linux/memblock.h
--- a/include/linux/memblock.h~x86-acpi-mm-revert-movablemem_map-support
+++ a/include/linux/memblock.h
@@ -42,7 +42,6 @@ struct memblock {
 
 extern struct memblock memblock;
 extern int memblock_debug;
-extern struct movablemem_map movablemem_map;
 
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
@@ -61,7 +60,6 @@ int memblock_reserve(phys_addr_t base, p
 void memblock_trim_memory(phys_addr_t align);
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
 			  unsigned long *out_end_pfn, int *out_nid);
 
diff -puN include/linux/mm.h~x86-acpi-mm-revert-movablemem_map-support include/linux/mm.h
--- a/include/linux/mm.h~x86-acpi-mm-revert-movablemem_map-support
+++ a/include/linux/mm.h
@@ -1335,24 +1335,6 @@ extern void free_bootmem_with_active_reg
 						unsigned long max_low_pfn);
 extern void sparse_memory_present_with_active_regions(int nid);
 
-#define MOVABLEMEM_MAP_MAX MAX_NUMNODES
-struct movablemem_entry {
-	unsigned long start_pfn;    /* start pfn of memory segment */
-	unsigned long end_pfn;      /* end pfn of memory segment (exclusive) */
-};
-
-struct movablemem_map {
-	bool acpi;	/* true if using SRAT info */
-	int nr_map;
-	struct movablemem_entry map[MOVABLEMEM_MAP_MAX];
-	nodemask_t numa_nodes_hotplug;	/* on which nodes we specify memory */
-	nodemask_t numa_nodes_kernel;	/* on which nodes kernel resides in */
-};
-
-extern void __init insert_movablemem_map(unsigned long start_pfn,
-					 unsigned long end_pfn);
-extern int __init movablemem_map_overlap(unsigned long start_pfn,
-					 unsigned long end_pfn);
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 #if !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && \
diff -puN mm/memblock.c~x86-acpi-mm-revert-movablemem_map-support mm/memblock.c
--- a/mm/memblock.c~x86-acpi-mm-revert-movablemem_map-support
+++ a/mm/memblock.c
@@ -92,58 +92,9 @@ static long __init_memblock memblock_ove
  *
  * Find @size free area aligned to @align in the specified range and node.
  *
- * If we have CONFIG_HAVE_MEMBLOCK_NODE_MAP defined, we need to check if the
- * memory we found if not in hotpluggable ranges.
- *
  * RETURNS:
  * Found address on success, %0 on failure.
  */
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
-					phys_addr_t end, phys_addr_t size,
-					phys_addr_t align, int nid)
-{
-	phys_addr_t this_start, this_end, cand;
-	u64 i;
-	int curr = movablemem_map.nr_map - 1;
-
-	/* pump up @end */
-	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
-		end = memblock.current_limit;
-
-	/* avoid allocating the first page */
-	start = max_t(phys_addr_t, start, PAGE_SIZE);
-	end = max(start, end);
-
-	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
-		this_start = clamp(this_start, start, end);
-		this_end = clamp(this_end, start, end);
-
-restart:
-		if (this_end <= this_start || this_end < size)
-			continue;
-
-		for (; curr >= 0; curr--) {
-			if ((movablemem_map.map[curr].start_pfn << PAGE_SHIFT)
-			    < this_end)
-				break;
-		}
-
-		cand = round_down(this_end - size, align);
-		if (curr >= 0 &&
-		    cand < movablemem_map.map[curr].end_pfn << PAGE_SHIFT) {
-			this_end = movablemem_map.map[curr].start_pfn
-				   << PAGE_SHIFT;
-			goto restart;
-		}
-
-		if (cand >= this_start)
-			return cand;
-	}
-
-	return 0;
-}
-#else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 					phys_addr_t end, phys_addr_t size,
 					phys_addr_t align, int nid)
@@ -172,7 +123,6 @@ phys_addr_t __init_memblock memblock_fin
 	}
 	return 0;
 }
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 /**
  * memblock_find_in_range - find free area in given range
diff -puN mm/page_alloc.c~x86-acpi-mm-revert-movablemem_map-support mm/page_alloc.c
--- a/mm/page_alloc.c~x86-acpi-mm-revert-movablemem_map-support
+++ a/mm/page_alloc.c
@@ -202,18 +202,11 @@ static unsigned long __meminitdata nr_al
 static unsigned long __meminitdata dma_reserve;
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-/* Movable memory ranges, will also be used by memblock subsystem. */
-struct movablemem_map movablemem_map = {
-	.acpi = false,
-	.nr_map = 0,
-};
-
 static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __initdata required_kernelcore;
 static unsigned long __initdata required_movablecore;
 static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
-static unsigned long __meminitdata zone_movable_limit[MAX_NUMNODES];
 
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
@@ -4412,77 +4405,6 @@ static unsigned long __meminit zone_abse
 	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
-/**
- * sanitize_zone_movable_limit - Sanitize the zone_movable_limit array.
- *
- * zone_movable_limit is initialized as 0. This function will try to get
- * the first ZONE_MOVABLE pfn of each node from movablemem_map, and
- * assigne them to zone_movable_limit.
- * zone_movable_limit[nid] == 0 means no limit for the node.
- *
- * Note: Each range is represented as [start_pfn, end_pfn)
- */
-static void __meminit sanitize_zone_movable_limit(void)
-{
-	int map_pos = 0, i, nid;
-	unsigned long start_pfn, end_pfn;
-
-	if (!movablemem_map.nr_map)
-		return;
-
-	/* Iterate all ranges from minimum to maximum */
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
-		/*
-		 * If we have found lowest pfn of ZONE_MOVABLE of the node
-		 * specified by user, just go on to check next range.
-		 */
-		if (zone_movable_limit[nid])
-			continue;
-
-#ifdef CONFIG_ZONE_DMA
-		/* Skip DMA memory. */
-		if (start_pfn < arch_zone_highest_possible_pfn[ZONE_DMA])
-			start_pfn = arch_zone_highest_possible_pfn[ZONE_DMA];
-#endif
-
-#ifdef CONFIG_ZONE_DMA32
-		/* Skip DMA32 memory. */
-		if (start_pfn < arch_zone_highest_possible_pfn[ZONE_DMA32])
-			start_pfn = arch_zone_highest_possible_pfn[ZONE_DMA32];
-#endif
-
-#ifdef CONFIG_HIGHMEM
-		/* Skip lowmem if ZONE_MOVABLE is highmem. */
-		if (zone_movable_is_highmem() &&
-		    start_pfn < arch_zone_lowest_possible_pfn[ZONE_HIGHMEM])
-			start_pfn = arch_zone_lowest_possible_pfn[ZONE_HIGHMEM];
-#endif
-
-		if (start_pfn >= end_pfn)
-			continue;
-
-		while (map_pos < movablemem_map.nr_map) {
-			if (end_pfn <= movablemem_map.map[map_pos].start_pfn)
-				break;
-
-			if (start_pfn >= movablemem_map.map[map_pos].end_pfn) {
-				map_pos++;
-				continue;
-			}
-
-			/*
-			 * The start_pfn of ZONE_MOVABLE is either the minimum
-			 * pfn specified by movablemem_map, or 0, which means
-			 * the node has no ZONE_MOVABLE.
-			 */
-			zone_movable_limit[nid] = max(start_pfn,
-					movablemem_map.map[map_pos].start_pfn);
-
-			break;
-		}
-	}
-}
-
 #else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
@@ -4500,6 +4422,7 @@ static inline unsigned long __meminit zo
 
 	return zholes_size[zone_type];
 }
+
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
@@ -4941,19 +4864,12 @@ static void __init find_zone_movable_pfn
 		required_kernelcore = max(required_kernelcore, corepages);
 	}
 
-	/*
-	 * If neither kernelcore/movablecore nor movablemem_map is specified,
-	 * there is no ZONE_MOVABLE. But if movablemem_map is specified, the
-	 * start pfn of ZONE_MOVABLE has been stored in zone_movable_limit[].
-	 */
-	if (!required_kernelcore) {
-		if (movablemem_map.nr_map)
-			memcpy(zone_movable_pfn, zone_movable_limit,
-				sizeof(zone_movable_pfn));
+	/* If kernelcore was not specified, there is no ZONE_MOVABLE */
+	if (!required_kernelcore)
 		goto out;
-	}
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
+	find_usable_zone_for_movable();
 	usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
 
 restart:
@@ -4981,24 +4897,10 @@ restart:
 		for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 			unsigned long size_pages;
 
-			/*
-			 * Find more memory for kernelcore in
-			 * [zone_movable_pfn[nid], zone_movable_limit[nid]).
-			 */
 			start_pfn = max(start_pfn, zone_movable_pfn[nid]);
 			if (start_pfn >= end_pfn)
 				continue;
 
-			if (zone_movable_limit[nid]) {
-				end_pfn = min(end_pfn, zone_movable_limit[nid]);
-				/* No range left for kernelcore in this node */
-				if (start_pfn >= end_pfn) {
-					zone_movable_pfn[nid] =
-							zone_movable_limit[nid];
-					break;
-				}
-			}
-
 			/* Account for what is only usable for kernelcore */
 			if (start_pfn < usable_startpfn) {
 				unsigned long kernel_pages;
@@ -5058,12 +4960,12 @@ restart:
 	if (usable_nodes && required_kernelcore > usable_nodes)
 		goto restart;
 
-out:
 	/* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
 	for (nid = 0; nid < MAX_NUMNODES; nid++)
 		zone_movable_pfn[nid] =
 			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
 
+out:
 	/* restore the node_state */
 	node_states[N_MEMORY] = saved_node_state;
 }
@@ -5126,8 +5028,6 @@ void __init free_area_init_nodes(unsigne
 
 	/* Find the PFNs that ZONE_MOVABLE begins at in each node */
 	memset(zone_movable_pfn, 0, sizeof(zone_movable_pfn));
-	find_usable_zone_for_movable();
-	sanitize_zone_movable_limit();
 	find_zone_movable_pfns_for_nodes();
 
 	/* Print out the zone ranges */
@@ -5211,181 +5111,6 @@ static int __init cmdline_parse_movablec
 early_param("kernelcore", cmdline_parse_kernelcore);
 early_param("movablecore", cmdline_parse_movablecore);
 
-/**
- * movablemem_map_overlap() - Check if a range overlaps movablemem_map.map[].
- * @start_pfn:	start pfn of the range to be checked
- * @end_pfn: 	end pfn of the range to be checked (exclusive)
- *
- * This function checks if a given memory range [start_pfn, end_pfn) overlaps
- * the movablemem_map.map[] array.
- *
- * Return: index of the first overlapped element in movablemem_map.map[]
- *         or -1 if they don't overlap each other.
- */
-int __init movablemem_map_overlap(unsigned long start_pfn,
-				   unsigned long end_pfn)
-{
-	int overlap;
-
-	if (!movablemem_map.nr_map)
-		return -1;
-
-	for (overlap = 0; overlap < movablemem_map.nr_map; overlap++)
-		if (start_pfn < movablemem_map.map[overlap].end_pfn)
-			break;
-
-	if (overlap == movablemem_map.nr_map ||
-	    end_pfn <= movablemem_map.map[overlap].start_pfn)
-		return -1;
-
-	return overlap;
-}
-
-/**
- * insert_movablemem_map - Insert a memory range in to movablemem_map.map.
- * @start_pfn:	start pfn of the range
- * @end_pfn:	end pfn of the range
- *
- * This function will also merge the overlapped ranges, and sort the array
- * by start_pfn in monotonic increasing order.
- */
-void __init insert_movablemem_map(unsigned long start_pfn,
-				  unsigned long end_pfn)
-{
-	int pos, overlap;
-
-	/*
-	 * pos will be at the 1st overlapped range, or the position
-	 * where the element should be inserted.
-	 */
-	for (pos = 0; pos < movablemem_map.nr_map; pos++)
-		if (start_pfn <= movablemem_map.map[pos].end_pfn)
-			break;
-
-	/* If there is no overlapped range, just insert the element. */
-	if (pos == movablemem_map.nr_map ||
-	    end_pfn < movablemem_map.map[pos].start_pfn) {
-		/*
-		 * If pos is not the end of array, we need to move all
-		 * the rest elements backward.
-		 */
-		if (pos < movablemem_map.nr_map)
-			memmove(&movablemem_map.map[pos+1],
-				&movablemem_map.map[pos],
-				sizeof(struct movablemem_entry) *
-				(movablemem_map.nr_map - pos));
-		movablemem_map.map[pos].start_pfn = start_pfn;
-		movablemem_map.map[pos].end_pfn = end_pfn;
-		movablemem_map.nr_map++;
-		return;
-	}
-
-	/* overlap will be at the last overlapped range */
-	for (overlap = pos + 1; overlap < movablemem_map.nr_map; overlap++)
-		if (end_pfn < movablemem_map.map[overlap].start_pfn)
-			break;
-
-	/*
-	 * If there are more ranges overlapped, we need to merge them,
-	 * and move the rest elements forward.
-	 */
-	overlap--;
-	movablemem_map.map[pos].start_pfn = min(start_pfn,
-					movablemem_map.map[pos].start_pfn);
-	movablemem_map.map[pos].end_pfn = max(end_pfn,
-					movablemem_map.map[overlap].end_pfn);
-
-	if (pos != overlap && overlap + 1 != movablemem_map.nr_map)
-		memmove(&movablemem_map.map[pos+1],
-			&movablemem_map.map[overlap+1],
-			sizeof(struct movablemem_entry) *
-			(movablemem_map.nr_map - overlap - 1));
-
-	movablemem_map.nr_map -= overlap - pos;
-}
-
-/**
- * movablemem_map_add_region - Add a memory range into movablemem_map.
- * @start:	physical start address of range
- * @end:	physical end address of range
- *
- * This function transform the physical address into pfn, and then add the
- * range into movablemem_map by calling insert_movablemem_map().
- */
-static void __init movablemem_map_add_region(u64 start, u64 size)
-{
-	unsigned long start_pfn, end_pfn;
-
-	/* In case size == 0 or start + size overflows */
-	if (start + size <= start)
-		return;
-
-	if (movablemem_map.nr_map >= ARRAY_SIZE(movablemem_map.map)) {
-		pr_err("movablemem_map: too many entries;"
-			" ignoring [mem %#010llx-%#010llx]\n",
-			(unsigned long long) start,
-			(unsigned long long) (start + size - 1));
-		return;
-	}
-
-	start_pfn = PFN_DOWN(start);
-	end_pfn = PFN_UP(start + size);
-	insert_movablemem_map(start_pfn, end_pfn);
-}
-
-/*
- * cmdline_parse_movablemem_map - Parse boot option movablemem_map.
- * @p:	The boot option of the following format:
- *	movablemem_map=nn[KMG]@ss[KMG]
- *
- * This option sets the memory range [ss, ss+nn) to be used as movable memory.
- *
- * Return: 0 on success or -EINVAL on failure.
- */
-static int __init cmdline_parse_movablemem_map(char *p)
-{
-	char *oldp;
-	u64 start_at, mem_size;
-
-	if (!p)
-		goto err;
-
-	if (!strcmp(p, "acpi"))
-		movablemem_map.acpi = true;
-
-	/*
-	 * If user decide to use info from BIOS, all the other user specified
-	 * ranges will be ingored.
-	 */
-	if (movablemem_map.acpi) {
-		if (movablemem_map.nr_map) {
-			memset(movablemem_map.map, 0,
-				sizeof(struct movablemem_entry)
-				* movablemem_map.nr_map);
-			movablemem_map.nr_map = 0;
-		}
-		return 0;
-	}
-
-	oldp = p;
-	mem_size = memparse(p, &p);
-	if (p == oldp)
-		goto err;
-
-	if (*p == '@') {
-		oldp = ++p;
-		start_at = memparse(p, &p);
-		if (p == oldp || *p != '\0')
-			goto err;
-
-		movablemem_map_add_region(start_at, mem_size);
-		return 0;
-	}
-err:
-	return -EINVAL;
-}
-early_param("movablemem_map", cmdline_parse_movablemem_map);
