From: akpm@linux-foundation.org
Subject: [folded-merged] memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:38:20 -0800
Message-ID: <20130222233821.30A2831C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:51259 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341Ab3BVXiW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:38:22 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so135258qah.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:38:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Bug fix: Do not split pages when freeing pagetable pages.
has been removed from the -mm tree.  Its filename was
     memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix.patch

This patch was dropped because it was folded into memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: Bug fix: Do not split pages when freeing pagetable pages.

The old way we free pagetable pages was wrong.

The old way is:
When we got a hugepage, we split it into smaller pages. And sometimes,
we only need to free some of the smaller pages because the others are
still in use. And the whole larger page will be freed if all the smaller
pages are not in use. All these were done in remove_pmd/pud_table().

But there is no way to know if the larger page has been split. As a result,
there is no way to decide when to split.

Actually, there is no need to split larger pages into smaller ones.

We do it in the following new way:
1) For direct mapped pages, all the pages were freed when they were offlined.
   And since menmory offline is done section by section, all the memory ranges
   being removed are aligned to PAGE_SIZE. So only need to deal with unaligned
   pages when freeing vmemmap pages.

2) For vmemmap pages being used to store page_struct, if part of the larger
   page is still in use, just fill the unused part with 0xFD. And when the
   whole page is fulfilled with 0xFD, then free the larger page.

This problem is caused by the following related patch:
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix.patch

This patch will fix the problem based on the above patches.

Reported-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |  150 ++++++++++++----------------------------
 1 file changed, 47 insertions(+), 103 deletions(-)

diff -puN arch/x86/mm/init_64.c~memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix
+++ a/arch/x86/mm/init_64.c
@@ -802,7 +802,7 @@ static bool __meminit free_pud_table(pud
 
 static void __meminit
 remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
-		 bool direct, bool split)
+		 bool direct)
 {
 	unsigned long next, pages = 0;
 	pte_t *pte;
@@ -832,23 +832,9 @@ remove_pte_table(pte_t *pte_start, unsig
 			/*
 			 * Do not free direct mapping pages since they were
 			 * freed when offlining, or simplely not in use.
-			 *
-			 * Do not free pages split from larger page since only
-			 * the _count of the 1st page struct is available.
-			 * Free the larger page when it is fulfilled with 0xFD.
 			 */
-			if (!direct) {
-				if (split) {
-					/*
-					 * Fill the split 4KB page with 0xFD.
-					 * When the whole 2MB page is fulfilled
-					 * with 0xFD, it could be freed.
-					 */
-					memset((void *)addr, PAGE_INUSE,
-						PAGE_SIZE);
-				} else
-					free_pagetable(pte_page(*pte), 0);
-			}
+			if (!direct)
+				free_pagetable(pte_page(*pte), 0);
 
 			spin_lock(&init_mm.page_table_lock);
 			pte_clear(&init_mm, addr, pte);
@@ -858,26 +844,24 @@ remove_pte_table(pte_t *pte_start, unsig
 			pages++;
 		} else {
 			/*
+			 * If we are here, we are freeing vmemmap pages since
+			 * direct mapped memory ranges to be freed are aligned.
+			 *
 			 * If we are not removing the whole page, it means
-			 * other ptes in this page are being used and we cannot
-			 * remove them. So fill the unused ptes with 0xFD, and
-			 * remove the page when it is wholly filled with 0xFD.
+			 * other page structs in this page are being used and
+			 * we canot remove them. So fill the unused page_structs
+			 * with 0xFD, and remove the page when it is wholly
+			 * filled with 0xFD.
 			 */
 			memset((void *)addr, PAGE_INUSE, next - addr);
 
-			/*
-			 * If the range is not aligned to PAGE_SIZE, then the
-			 * page is definitely not split from larger page.
-			 */
 			page_addr = page_address(pte_page(*pte));
 			if (!memchr_inv(page_addr, PAGE_INUSE, PAGE_SIZE)) {
-				if (!direct)
-					free_pagetable(pte_page(*pte), 0);
+				free_pagetable(pte_page(*pte), 0);
 
 				spin_lock(&init_mm.page_table_lock);
 				pte_clear(&init_mm, addr, pte);
 				spin_unlock(&init_mm.page_table_lock);
-				pages++;
 			}
 		}
 	}
@@ -890,13 +874,12 @@ remove_pte_table(pte_t *pte_start, unsig
 
 static void __meminit
 remove_pmd_table(pmd_t *pmd_start, unsigned long addr, unsigned long end,
-		 bool direct, bool split)
+		 bool direct)
 {
-	unsigned long pte_phys, next, pages = 0;
+	unsigned long next, pages = 0;
 	pte_t *pte_base;
 	pmd_t *pmd;
 	void *page_addr;
-	bool split_pmd = split, split_pte = false;
 
 	pmd = pmd_start + pmd_index(addr);
 	for (; addr < end; addr = next, pmd++) {
@@ -908,63 +891,35 @@ remove_pmd_table(pmd_t *pmd_start, unsig
 		if (pmd_large(*pmd)) {
 			if (IS_ALIGNED(addr, PMD_SIZE) &&
 			    IS_ALIGNED(next, PMD_SIZE)) {
-				if (!direct) {
-					if (split_pmd) {
-						/*
-						 * Fill the split 2MB page with
-						 * 0xFD. When the whole 1GB page
-						 * is fulfilled with 0xFD, it
-						 * could be freed.
-						 */
-						memset((void *)addr, PAGE_INUSE,
-							PMD_SIZE);
-					} else {
-						free_pagetable(pmd_page(*pmd),
+				if (!direct)
+					free_pagetable(pmd_page(*pmd),
 						       get_order(PMD_SIZE));
-					}
-				}
 
 				spin_lock(&init_mm.page_table_lock);
 				pmd_clear(pmd);
 				spin_unlock(&init_mm.page_table_lock);
-
-				/*
-				 * For non-direct mapping, pages means
-				 * nothing.
-				 */
 				pages++;
+			} else {
+				/* If here, we are freeing vmemmap pages. */
+				memset((void *)addr, PAGE_INUSE, next - addr);
+
+				page_addr = page_address(pmd_page(*pmd));
+				if (!memchr_inv(page_addr, PAGE_INUSE,
+						PMD_SIZE)) {
+					free_pagetable(pmd_page(*pmd),
+						       get_order(PMD_SIZE));
 
-				continue;
+					spin_lock(&init_mm.page_table_lock);
+					pmd_clear(pmd);
+					spin_unlock(&init_mm.page_table_lock);
+				}
 			}
 
-			/*
-			 * We use 2M page, but we need to remove part of them,
-			 * so split 2M page to 4K page.
-			 */
-			pte_base = (pte_t *)alloc_low_page(&pte_phys);
-			BUG_ON(!pte_base);
-			__split_large_page((pte_t *)pmd, addr,
-					   (pte_t *)pte_base);
-			split_pte = true;
-
-			spin_lock(&init_mm.page_table_lock);
-			pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
-			spin_unlock(&init_mm.page_table_lock);
-
-			flush_tlb_all();
+			continue;
 		}
 
 		pte_base = (pte_t *)map_low_page((pte_t *)pmd_page_vaddr(*pmd));
-		remove_pte_table(pte_base, addr, next, direct, split_pte);
-
-		if (!direct && split_pte) {
-			page_addr = page_address(pmd_page(*pmd));
-			if (!memchr_inv(page_addr, PAGE_INUSE, PMD_SIZE)) {
-				free_pagetable(pmd_page(*pmd),
-					       get_order(PMD_SIZE));
-			}
-		}
-
+		remove_pte_table(pte_base, addr, next, direct);
 		free_pte_table(pte_base, pmd);
 		unmap_low_page(pte_base);
 	}
@@ -978,11 +933,10 @@ static void __meminit
 remove_pud_table(pud_t *pud_start, unsigned long addr, unsigned long end,
 		 bool direct)
 {
-	unsigned long pmd_phys, next, pages = 0;
+	unsigned long next, pages = 0;
 	pmd_t *pmd_base;
 	pud_t *pud;
 	void *page_addr;
-	bool split_pmd = false;
 
 	pud = pud_start + pud_index(addr);
 	for (; addr < end; addr = next, pud++) {
@@ -1002,37 +956,27 @@ remove_pud_table(pud_t *pud_start, unsig
 				pud_clear(pud);
 				spin_unlock(&init_mm.page_table_lock);
 				pages++;
-				continue;
-			}
-
-			/*
-			 * We use 1G page, but we need to remove part of them,
-			 * so split 1G page to 2M page.
-			 */
-			pmd_base = (pmd_t *)alloc_low_page(&pmd_phys);
-			BUG_ON(!pmd_base);
-			__split_large_page((pte_t *)pud, addr,
-					   (pte_t *)pmd_base);
-			split_pmd = true;
+			} else {
+				/* If here, we are freeing vmemmap pages. */
+				memset((void *)addr, PAGE_INUSE, next - addr);
+
+				page_addr = page_address(pud_page(*pud));
+				if (!memchr_inv(page_addr, PAGE_INUSE,
+						PUD_SIZE)) {
+					free_pagetable(pud_page(*pud),
+						       get_order(PUD_SIZE));
 
-			spin_lock(&init_mm.page_table_lock);
-			pud_populate(&init_mm, pud, __va(pmd_phys));
-			spin_unlock(&init_mm.page_table_lock);
+					spin_lock(&init_mm.page_table_lock);
+					pud_clear(pud);
+					spin_unlock(&init_mm.page_table_lock);
+				}
+			}
 
-			flush_tlb_all();
+			continue;
 		}
 
 		pmd_base = (pmd_t *)map_low_page((pmd_t *)pud_page_vaddr(*pud));
-		remove_pmd_table(pmd_base, addr, next, direct, split_pmd);
-
-		if (!direct && split_pmd) {
-			page_addr = page_address(pud_page(*pud));
-			if (!memchr_inv(page_addr, PAGE_INUSE, PUD_SIZE)) {
-				free_pagetable(pud_page(*pud),
-					       get_order(PUD_SIZE));
-			}
-		}
-
+		remove_pmd_table(pmd_base, addr, next, direct);
 		free_pmd_table(pmd_base, pud);
 		unmap_low_page(pmd_base);
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

