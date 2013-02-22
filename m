From: akpm@linux-foundation.org
Subject: [folded-merged] memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:38:10 -0800
Message-ID: <20130222233810.D200931C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:33531 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986Ab3BVXiM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:38:12 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so120431vch.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:38:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Bug fix: Do not calculate direct mapping pages when freeing vmemmap pagetables.
has been removed from the -mm tree.  Its filename was
     memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix.patch

This patch was dropped because it was folded into memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: Bug fix: Do not calculate direct mapping pages when freeing vmemmap pagetables.

We only need to update direct_pages_count[level] when we freeing direct mapped
pagetables.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN arch/x86/mm/init_64.c~memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix
+++ a/arch/x86/mm/init_64.c
@@ -829,14 +829,13 @@ remove_pte_table(pte_t *pte_start, unsig
 
 		if (IS_ALIGNED(addr, PAGE_SIZE) &&
 		    IS_ALIGNED(next, PAGE_SIZE)) {
-			if (!direct) {
+			if (!direct)
 				free_pagetable(pte_page(*pte), 0);
-				pages++;
-			}
 
 			spin_lock(&init_mm.page_table_lock);
 			pte_clear(&init_mm, addr, pte);
 			spin_unlock(&init_mm.page_table_lock);
+			pages++;
 		} else {
 			/*
 			 * If we are not removing the whole page, it means
@@ -849,11 +848,11 @@ remove_pte_table(pte_t *pte_start, unsig
 
 			if (!memchr_inv(page_addr, PAGE_INUSE, PAGE_SIZE)) {
 				free_pagetable(pte_page(*pte), 0);
-				pages++;
 
 				spin_lock(&init_mm.page_table_lock);
 				pte_clear(&init_mm, addr, pte);
 				spin_unlock(&init_mm.page_table_lock);
+				pages++;
 			}
 		}
 	}
@@ -882,15 +881,14 @@ remove_pmd_table(pmd_t *pmd_start, unsig
 		if (pmd_large(*pmd)) {
 			if (IS_ALIGNED(addr, PMD_SIZE) &&
 			    IS_ALIGNED(next, PMD_SIZE)) {
-				if (!direct) {
+				if (!direct)
 					free_pagetable(pmd_page(*pmd),
 						       get_order(PMD_SIZE));
-					pages++;
-				}
 
 				spin_lock(&init_mm.page_table_lock);
 				pmd_clear(pmd);
 				spin_unlock(&init_mm.page_table_lock);
+				pages++;
 				continue;
 			}
 
@@ -939,15 +937,14 @@ remove_pud_table(pud_t *pud_start, unsig
 		if (pud_large(*pud)) {
 			if (IS_ALIGNED(addr, PUD_SIZE) &&
 			    IS_ALIGNED(next, PUD_SIZE)) {
-				if (!direct) {
+				if (!direct)
 					free_pagetable(pud_page(*pud),
 						       get_order(PUD_SIZE));
-					pages++;
-				}
 
 				spin_lock(&init_mm.page_table_lock);
 				pud_clear(pud);
 				spin_unlock(&init_mm.page_table_lock);
+				pages++;
 				continue;
 			}
 
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

