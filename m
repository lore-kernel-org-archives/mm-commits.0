From: akpm@linux-foundation.org
Subject: + acpi-memory-hotplug-parse-srat-before-memblock-is-ready.patch added to -mm tree
Date: Fri, 25 Jan 2013 16:40:53 -0800
Message-ID: <20130126004053.7E2465A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:55202 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab3AZAkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 19:40:55 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so96944ggn.0
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 16:40:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, len.brown@intel.com, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: acpi, memory-hotplug: parse SRAT before memblock is ready
has been added to the -mm tree.  Its filename is
     acpi-memory-hotplug-parse-srat-before-memblock-is-ready.patch

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
Subject: acpi, memory-hotplug: parse SRAT before memblock is ready

On linux, the pages used by kernel could not be migrated.  As a result, if
a memory range is used by kernel, it cannot be hot-removed.  So if we want
to hot-remove memory, we should prevent kernel from using it.

The way now used to prevent this is specify a memory range by
movablemem_map boot option and set it as ZONE_MOVABLE.

But when the system is booting, memblock will allocate memory, and reserve
the memory for kernel.  And before we parse SRAT, and know the node memory
ranges, memblock is working.  And it may allocate memory in ranges to be
set as ZONE_MOVABLE.  This memory can be used by kernel, and never be
freed.

So, let's parse SRAT before memblock is called first. And it is early enough.

The first call of memblock_find_in_range_node() is in:
setup_arch()
 |-->setup_real_mode()

so, this patch add a function early_parse_srat() to parse SRAT, and call
it before setup_real_mode() is called.

NOTE:

1) Do not clear numa_nodes_parsed in numa_init() because SRAT was
   parsed earlier.

2) I don't know why using count of memory affinities parsed from SRAT
   as a return value in original acpi_numa_init().  So I add a static
   variable srat_mem_cnt to remember this count and use it as the return
   value of the new acpi_numa_init()

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
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

 arch/x86/kernel/setup.c |   13 +++++++++----
 arch/x86/mm/numa.c      |    2 +-
 drivers/acpi/numa.c     |   23 +++++++++++++----------
 include/linux/acpi.h    |    1 +
 4 files changed, 24 insertions(+), 15 deletions(-)

diff -puN arch/x86/kernel/setup.c~acpi-memory-hotplug-parse-srat-before-memblock-is-ready arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~acpi-memory-hotplug-parse-srat-before-memblock-is-ready
+++ a/arch/x86/kernel/setup.c
@@ -981,6 +981,15 @@ void __init setup_arch(char **cmdline_p)
 	setup_bios_corruption_check();
 #endif
 
+	/*
+	 * In the memory hotplug case, the kernel need info from SRAT to
+	 * determine which memory is hotpluggable before allocating memory
+	 * using memblock.
+	 */
+	acpi_boot_table_init();
+	early_acpi_boot_init();
+	early_parse_srat();
+
 	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
 			(max_pfn_mapped<<PAGE_SHIFT) - 1);
 
@@ -1045,10 +1054,6 @@ void __init setup_arch(char **cmdline_p)
 	/*
 	 * Parse the ACPI tables for possible boot-time SMP configuration.
 	 */
-	acpi_boot_table_init();
-
-	early_acpi_boot_init();
-
 	initmem_init();
 	memblock_find_dma_reserve();
 
diff -puN arch/x86/mm/numa.c~acpi-memory-hotplug-parse-srat-before-memblock-is-ready arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~acpi-memory-hotplug-parse-srat-before-memblock-is-ready
+++ a/arch/x86/mm/numa.c
@@ -569,7 +569,7 @@ static int __init numa_init(int (*init_f
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		set_apicid_to_node(i, NUMA_NO_NODE);
 
-	nodes_clear(numa_nodes_parsed);
+	/* Do not clear numa_nodes_parsed because SRAT was parsed earlier. */
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
diff -puN drivers/acpi/numa.c~acpi-memory-hotplug-parse-srat-before-memblock-is-ready drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~acpi-memory-hotplug-parse-srat-before-memblock-is-ready
+++ a/drivers/acpi/numa.c
@@ -282,10 +282,10 @@ acpi_table_parse_srat(enum acpi_srat_typ
 					    handler, max_entries);
 }
 
-int __init acpi_numa_init(void)
-{
-	int cnt = 0;
+static int srat_mem_cnt;
 
+void __init early_parse_srat(void)
+{
 	/*
 	 * Should not limit number with cpu num that is from NR_CPUS or nr_cpus=
 	 * SRAT cpu entries could have different order with that in MADT.
@@ -295,21 +295,24 @@ int __init acpi_numa_init(void)
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
-				     acpi_parse_x2apic_affinity, 0);
+				      acpi_parse_x2apic_affinity, 0);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
-				     acpi_parse_processor_affinity, 0);
-		cnt = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
-					    acpi_parse_memory_affinity,
-					    NR_NODE_MEMBLKS);
+				      acpi_parse_processor_affinity, 0);
+		srat_mem_cnt = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
+						     acpi_parse_memory_affinity,
+						     NR_NODE_MEMBLKS);
 	}
+}
 
+int __init acpi_numa_init(void)
+{
 	/* SLIT: System Locality Information Table */
 	acpi_table_parse(ACPI_SIG_SLIT, acpi_parse_slit);
 
 	acpi_numa_arch_fixup();
 
-	if (cnt < 0)
-		return cnt;
+	if (srat_mem_cnt < 0)
+		return srat_mem_cnt;
 	else if (!parsed_numa_memblks)
 		return -ENOENT;
 	return 0;
diff -puN include/linux/acpi.h~acpi-memory-hotplug-parse-srat-before-memblock-is-ready include/linux/acpi.h
--- a/include/linux/acpi.h~acpi-memory-hotplug-parse-srat-before-memblock-is-ready
+++ a/include/linux/acpi.h
@@ -94,6 +94,7 @@ int acpi_boot_init (void);
 void acpi_boot_table_init (void);
 int acpi_mps_check (void);
 int acpi_numa_init (void);
+void __init early_parse_srat(void);
 
 int acpi_table_init (void);
 int acpi_table_parse(char *id, acpi_tbl_table_handler handler);
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

