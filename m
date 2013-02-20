From: akpm@linux-foundation.org
Subject: + acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix-fix.patch added to -mm tree
Date: Wed, 20 Feb 2013 13:31:04 -0800
Message-ID: <20130220213104.D830031C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:44750 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759221Ab3BTVbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 16:31:08 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so830712qeb.0
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 13:31:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, len.brown@intel.com, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de, will.huckk@gmail.com, wujianguo@huawei.com


The patch titled
     Subject: acpi, movablemem_map: make whatever nodes the kernel resides in un-hotpluggable.
has been added to the -mm tree.  Its filename is
     acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix-fix.patch

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
Subject: acpi, movablemem_map: make whatever nodes the kernel resides in un-hotpluggable.

There could be several memory ranges in the node in which the kernel
resides.  When using movablemem_map=acpi, we may skip one range that have
memory reserved by memblock.  But if it is too small, then the kernel will
fail to boot.  So, make the whole node which the kernel resides in
un-hotpluggable.  Then the kernel has enough memory to use.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reported-by: H Peter Anvin <hpa@zytor.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Will Huck <will.huckk@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 ++++++
 arch/x86/mm/srat.c                  |   17 +++++++++++++++++
 include/linux/mm.h                  |    1 +
 3 files changed, 24 insertions(+)

diff -puN Documentation/kernel-parameters.txt~acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix-fix Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix-fix
+++ a/Documentation/kernel-parameters.txt
@@ -1652,6 +1652,8 @@ bytes respectively. Such letter suffixes
 			in flags from SRAT from ACPI BIOS to determine which
 			memory devices could be hotplugged. The corresponding
 			memory ranges will be set as ZONE_MOVABLE.
+			NOTE: Whatever node the kernel resides in will always
+			      be un-hotpluggable.
 
 	movablemem_map=nn[KMG]@ss[KMG]
 			[KNL,X86,IA-64,PPC] This parameter is similar to
@@ -1673,6 +1675,10 @@ bytes respectively. Such letter suffixes
 			satisfied. So the administrator should be careful that
 			the amount of movablemem_map areas are not too large.
 			Otherwise kernel won't have enough memory to start.
+			NOTE: We don't stop users specifying the node the
+			      kernel resides in as hotpluggable so that this
+			      option can be used as a workaround of firmware
+                              bugs.
 
 	MTD_Partition=	[MTD]
 			Format: <name>,<region-number>,<size>,<offset>
diff -puN arch/x86/mm/srat.c~acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix-fix arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix-fix
+++ a/arch/x86/mm/srat.c
@@ -166,6 +166,9 @@ handle_movablemem(int node, u64 start, u
 	 * for other purposes, such as for kernel image. We cannot prevent
 	 * kernel from using these memory, so we need to exclude these memory
 	 * even if it is hotpluggable.
+	 * Furthermore, to ensure the kernel has enough memory to boot, we make
+	 * all the memory on the node which the kernel resides in
+	 * un-hotpluggable.
 	 */
 	if (hotpluggable && movablemem_map.acpi) {
 		/* Exclude ranges reserved by memblock. */
@@ -176,9 +179,23 @@ handle_movablemem(int node, u64 start, u
 			    start >= rgn->regions[i].base +
 			    rgn->regions[i].size)
 				continue;
+
+			/*
+			 * If the memory range overlaps the memory reserved by
+			 * memblock, then the kernel resides in this node.
+			 */
+			node_set(node, movablemem_map.numa_nodes_kernel);
+
 			goto out;
 		}
 
+		/*
+		 * If the kernel resides in this node, then the whole node
+		 * should not be hotpluggable.
+		 */
+		if (node_isset(node, movablemem_map.numa_nodes_kernel))
+			goto out;
+
 		insert_movablemem_map(start_pfn, end_pfn);
 
 		/*
diff -puN include/linux/mm.h~acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix-fix include/linux/mm.h
--- a/include/linux/mm.h~acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix-fix
+++ a/include/linux/mm.h
@@ -1372,6 +1372,7 @@ struct movablemem_map {
 	int nr_map;
 	struct movablemem_entry map[MOVABLEMEM_MAP_MAX];
 	nodemask_t numa_nodes_hotplug;	/* on which nodes we specify memory */
+	nodemask_t numa_nodes_kernel;	/* on which nodes kernel resides in */
 };
 
 extern void __init insert_movablemem_map(unsigned long start_pfn,
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

linux-next.patch
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
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix.patch
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
acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix.patch
acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix-fix.patch
mm-memblockc-use-config_have_memblock_node_map-to-protect-movablecore_map-in-memblock_overlaps_region.patch

