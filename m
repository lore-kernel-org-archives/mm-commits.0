From: akpm@linux-foundation.org
Subject: [folded-merged] acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:45:47 -0800
Message-ID: <20130222234548.09EB45A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:64558 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab3BVXpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:45:49 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so136363qah.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:45:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, laijs@cn.fujitsu.com, shli@kernel.org, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acpi, movablemem_map: Do not zero numa_meminfo in numa_init().
has been removed from the -mm tree.  Its filename was
     acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix-fix.patch

This patch was dropped because it was folded into acpi-memory-hotplug-parse-srat-before-memblock-is-ready.patch

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: acpi, movablemem_map: Do not zero numa_meminfo in numa_init().

early_parse_srat() is called before numa_init(), and has initialized
numa_meminfo. So do not zero numa_meminfo in numa_init(), otherwise
we will lose memory numa info.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reported-by: Li Shaohua <shli@kernel.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/numa.c~acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix-fix arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix-fix
+++ a/arch/x86/mm/numa.c
@@ -559,10 +559,12 @@ static int __init numa_init(int (*init_f
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		set_apicid_to_node(i, NUMA_NO_NODE);
 
-	/* Do not clear numa_nodes_parsed because SRAT was parsed earlier. */
+	/*
+	 * Do not clear numa_nodes_parsed or zero numa_meminfo here, because
+	 * SRAT was parsed earlier in early_parse_srat().
+	 */
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
-	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
 	WARN_ON(memblock_set_node(0, ULLONG_MAX, MAX_NUMNODES));
 	numa_reset_distance();
 
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
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix-fix.patch
mm-memblockc-use-config_have_memblock_node_map-to-protect-movablecore_map-in-memblock_overlaps_region.patch

