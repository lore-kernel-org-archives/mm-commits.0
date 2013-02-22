From: akpm@linux-foundation.org
Subject: [folded-merged] page_alloc-add-movable_memmap-kernel-parameter-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:44:05 -0800
Message-ID: <20130222234405.D85BB31C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:65422 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3BVXoG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:44:06 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so120470yhz.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:44:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Bug fix: Fix the doc format.
has been removed from the -mm tree.  Its filename was
     page_alloc-add-movable_memmap-kernel-parameter-fix-fix.patch

This patch was dropped because it was folded into page_alloc-add-movable_memmap-kernel-parameter.patch

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: Bug fix: Fix the doc format.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN mm/page_alloc.c~page_alloc-add-movable_memmap-kernel-parameter-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-add-movable_memmap-kernel-parameter-fix-fix
+++ a/mm/page_alloc.c
@@ -5082,9 +5082,9 @@ early_param("kernelcore", cmdline_parse_
 early_param("movablecore", cmdline_parse_movablecore);
 
 /**
- * insert_movablecore_map - Insert a memory range in to movablecore_map.map.
- * @start_pfn: start pfn of the range
- * @end_pfn: end pfn of the range
+ * insert_movablecore_map() - Insert a memory range in to movablecore_map.map.
+ * @start_pfn:	start pfn of the range
+ * @end_pfn:	end pfn of the range
  *
  * This function will also merge the overlapped ranges, and sort the array
  * by start_pfn in monotonic increasing order.
@@ -5145,9 +5145,9 @@ static void __init insert_movablecore_ma
 }
 
 /**
- * movablecore_map_add_region - Add a memory range into movablecore_map.
- * @start: physical start address of range
- * @end: physical end address of range
+ * movablecore_map_add_region() - Add a memory range into movablecore_map.
+ * @start:	physical start address of range
+ * @end:	physical end address of range
  *
  * This function transform the physical address into pfn, and then add the
  * range into movablecore_map by calling insert_movablecore_map().
@@ -5174,8 +5174,13 @@ static void __init movablecore_map_add_r
 }
 
 /*
- * movablecore_map=nn[KMG]@ss[KMG] sets the region of memory to be used as
- * movable memory.
+ * cmdline_parse_movablecore_map() - Parse boot option movablecore_map.
+ * @p:	The boot option of the following format:
+ * 	movablecore_map=nn[KMG]@ss[KMG]
+ *
+ * This option sets the memory range [ss, ss+nn) to be used as movable memory.
+ *
+ * Return: 0 on success or -EINVAL on failure.
  */
 static int __init cmdline_parse_movablecore_map(char *p)
 {
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

