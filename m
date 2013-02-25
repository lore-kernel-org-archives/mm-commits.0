From: akpm@linux-foundation.org
Subject: [merged] acpi-memory-hotplug-parse-srat-before-memblock-is-ready.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:51:20 -0800
Message-ID: <20130225205121.0D5375A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:39957 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759615Ab3BYUvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:51:22 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so347945yhz.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:51:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, len.brown@intel.com, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acpi, memory-hotplug: parse SRAT before memblock is ready
has been removed from the -mm tree.  Its filename was
     acpi-memory-hotplug-parse-srat-before-memblock-is-ready.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

So, let's parse SRAT before memblock is called first.  And it is early
enough.

The first call of memblock_find_in_range_node() is in:
setup_arch()
  |-->setup_real_mode()

so, this patch add a function early_parse_srat() to parse SRAT, and call
it before setup_real_mode() is called.

NOTE:

1) early_parse_srat() is called before numa_init(), and has initialized
   numa_meminfo.  So DO NOT clear numa_nodes_parsed in numa_init() and DO
   NOT zero numa_meminfo in numa_init(), otherwise we will lose memory
   numa info.

2) I don't know why using count of memory affinities parsed from SRAT
   as a return value in original acpi_numa_init().  So I add a static
   variable srat_mem_cnt to remember this count and use it as the return
   value of the new acpi_numa_init()

[mhocko@suse.cz: parse SRAT before memblock is ready fix]
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
 arch/x86/mm/numa.c      |    6 ++++--
 drivers/acpi/numa.c     |   23 +++++++++++++----------
 include/linux/acpi.h    |    8 ++++++++
 4 files changed, 34 insertions(+), 16 deletions(-)

diff -puN arch/x86/kernel/setup.c~acpi-memory-hotplug-parse-srat-before-memblock-is-ready arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~acpi-memory-hotplug-parse-srat-before-memblock-is-ready
+++ a/arch/x86/kernel/setup.c
@@ -1056,6 +1056,15 @@ void __init setup_arch(char **cmdline_p)
 	setup_bios_corruption_check();
 #endif
 
+	/*
+	 * In the memory hotplug case, the kernel needs info from SRAT to
+	 * determine which memory is hotpluggable before allocating memory
+	 * using memblock.
+	 */
+	acpi_boot_table_init();
+	early_acpi_boot_init();
+	early_parse_srat();
+
 #ifdef CONFIG_X86_32
 	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
 			(max_pfn_mapped<<PAGE_SHIFT) - 1);
@@ -1101,10 +1110,6 @@ void __init setup_arch(char **cmdline_p)
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
@@ -560,10 +560,12 @@ static int __init numa_init(int (*init_f
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		set_apicid_to_node(i, NUMA_NO_NODE);
 
-	nodes_clear(numa_nodes_parsed);
+	/*
+	 * Do not clear numa_nodes_parsed or zero numa_meminfo here, because
+	 * SRAT was parsed earlier in early_parse_srat().
+	 */
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
-	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
 	WARN_ON(memblock_set_node(0, ULLONG_MAX, MAX_NUMNODES));
 	numa_reset_distance();
 
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
@@ -485,6 +485,14 @@ static inline bool acpi_driver_match_dev
 
 #endif	/* !CONFIG_ACPI */
 
+#ifdef CONFIG_ACPI_NUMA
+void __init early_parse_srat(void);
+#else
+static inline void early_parse_srat(void)
+{
+}
+#endif
+
 #ifdef CONFIG_ACPI
 void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
 			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

