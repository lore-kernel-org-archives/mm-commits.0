From: akpm@linux-foundation.org
Subject: [folded-merged] acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:46:52 -0800
Message-ID: <20130222234653.61CD05A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:34883 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab3BVXqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:46:55 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so121029ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:46:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, len.brown@intel.com, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de, will.huckk@gmail.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acpi, movablemem_map: Exclude memblock.reserved ranges when parsing SRAT.
has been removed from the -mm tree.  Its filename was
     acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix.patch

This patch was dropped because it was folded into acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: acpi, movablemem_map: Exclude memblock.reserved ranges when parsing SRAT.

As mentioned by HPA before, when we are using movablemem_map=acpi, if all the
memory ranges in SRAT is hotpluggable, then no memory can be used by kernel.

Before parsing SRAT, memblock has already reserve some memory ranges for other
purposes, such as for kernel image, and so on. We cannot prevent kernel from
using these memory. So we need to exclude these ranges even if these memory is
hotpluggable.

This patch changes the movablemem_map=acpi option's behavior. The memory ranges
reserved by memblock will not be added into movablemem_map.map[]. So even if
all the memory is hotpluggable, there will always be memory that could be used
by the kernel.

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

 arch/x86/mm/srat.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/srat.c~acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix
+++ a/arch/x86/mm/srat.c
@@ -145,7 +145,7 @@ static inline int save_add_info(void) {r
 static void __init
 handle_movablemem(int node, u64 start, u64 end, u32 hotpluggable)
 {
-	int overlap;
+	int overlap, i;
 	unsigned long start_pfn, end_pfn;
 
 	start_pfn = PFN_DOWN(start);
@@ -161,8 +161,24 @@ handle_movablemem(int node, u64 start, u
 	 *
 	 * Using movablemem_map, we can prevent memblock from allocating memory
 	 * on ZONE_MOVABLE at boot time.
+	 *
+	 * Before parsing SRAT, memblock has already reserve some memory ranges
+	 * for other purposes, such as for kernel image. We cannot prevent
+	 * kernel from using these memory, so we need to exclude these memory
+	 * even if it is hotpluggable.
 	 */
 	if (hotpluggable && movablemem_map.acpi) {
+		/* Exclude ranges reserved by memblock. */
+		struct memblock_type *rgn = &memblock.reserved;
+
+		for (i = 0; i < rgn->cnt; i++) {
+			if (end <= rgn->regions[i].base ||
+			    start >= rgn->regions[i].base +
+			    rgn->regions[i].size)
+				continue;
+			goto out;
+		}
+
 		insert_movablemem_map(start_pfn, end_pfn);
 
 		/*
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
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
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
x86-get-pg_data_ts-memory-from-other-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch
page_alloc-make-movablecore_map-has-higher-priority.patch
page_alloc-bootmem-limit-with-movablecore_map.patch
acpi-memory-hotplug-parse-srat-before-memblock-is-ready.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix-fix.patch
mm-memblockc-use-config_have_memblock_node_map-to-protect-movablecore_map-in-memblock_overlaps_region.patch

