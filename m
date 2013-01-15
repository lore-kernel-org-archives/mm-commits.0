From: akpm@linux-foundation.org
Subject: + memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix.patch added to -mm tree
Date: Tue, 15 Jan 2013 13:37:55 -0800
Message-ID: <20130115213756.2A0CA20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:49779 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab3AOVh7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jan 2013 16:37:59 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so42234wib.5
        for <mm-commits@vger.kernel.org>; Tue, 15 Jan 2013 13:37:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, wency@cn.fujitsu.com


The patch titled
     Subject: Bug fix: Do not calculate direct mapping pages when freeing vmemmap pagetables.
has been added to the -mm tree.  Its filename is
     memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix.patch

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
@@ -804,14 +804,13 @@ remove_pte_table(pte_t *pte_start, unsig
 
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
@@ -824,11 +823,11 @@ remove_pte_table(pte_t *pte_start, unsig
 
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
@@ -857,15 +856,14 @@ remove_pmd_table(pmd_t *pmd_start, unsig
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
 
@@ -914,15 +912,14 @@ remove_pud_table(pud_t *pud_start, unsig
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
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
x86-get-pg_data_ts-memory-from-other-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch
page_alloc-make-movablecore_map-has-higher-priority.patch
page_alloc-bootmem-limit-with-movablecore_map.patch

