From: akpm@linux-foundation.org
Subject: [patch 069/124] mm: codgin-style fixes
Date: Fri, 24 Feb 2017 14:59:01 -0800
Message-ID: <58b0bab5.wqUv0Fo09FHqtQSr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbdBXW7D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:59:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, me@tobin.cc

From: Tobin C Harding <me@tobin.cc>
Subject: mm: codgin-style fixes

Fix whitespace issues, extraneous braces.

Link: http://lkml.kernel.org/r/1485992240-10986-5-git-send-email-me@tobin.cc
Signed-off-by: Tobin C Harding <me@tobin.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   60 ++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

diff -puN mm/memory.c~mm-fix-checkpatch-warnings-whitespace mm/memory.c
--- a/mm/memory.c~mm-fix-checkpatch-warnings-whitespace
+++ a/mm/memory.c
@@ -30,7 +30,7 @@
 
 /*
  * 05.04.94  -  Multi-page memory management added for v1.1.
- * 		Idea by Alex Bligh (alex@cconcepts.co.uk)
+ *              Idea by Alex Bligh (alex@cconcepts.co.uk)
  *
  * 16.07.99  -  Support of BIGMEM added by Gerhard Wichert, Siemens AG
  *		(Gerhard.Wichert@pdb.siemens.de)
@@ -82,9 +82,9 @@
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 /* use the per-pgdat data instead for discontigmem - mbligh */
 unsigned long max_mapnr;
-struct page *mem_map;
-
 EXPORT_SYMBOL(max_mapnr);
+
+struct page *mem_map;
 EXPORT_SYMBOL(mem_map);
 #endif
 
@@ -95,8 +95,7 @@ EXPORT_SYMBOL(mem_map);
  * highstart_pfn must be the same; there must be no gap between ZONE_NORMAL
  * and ZONE_HIGHMEM.
  */
-void * high_memory;
-
+void *high_memory;
 EXPORT_SYMBOL(high_memory);
 
 /*
@@ -120,10 +119,10 @@ static int __init disable_randmaps(char
 __setup("norandmaps", disable_randmaps);
 
 unsigned long zero_pfn __read_mostly;
-unsigned long highest_memmap_pfn __read_mostly;
-
 EXPORT_SYMBOL(zero_pfn);
 
+unsigned long highest_memmap_pfn __read_mostly;
+
 /*
  * CONFIG_MMU architectures set up ZERO_PAGE in their paging_init()
  */
@@ -556,7 +555,7 @@ void free_pgtables(struct mmu_gather *tl
 
 		if (is_vm_hugetlb_page(vma)) {
 			hugetlb_free_pgd_range(tlb, addr, vma->vm_end,
-				floor, next? next->vm_start: ceiling);
+				floor, next ? next->vm_start : ceiling);
 		} else {
 			/*
 			 * Optimization: gather nearby vmas into one call down
@@ -569,7 +568,7 @@ void free_pgtables(struct mmu_gather *tl
 				unlink_file_vma(vma);
 			}
 			free_pgd_range(tlb, addr, vma->vm_end,
-				floor, next? next->vm_start: ceiling);
+				floor, next ? next->vm_start : ceiling);
 		}
 		vma = next;
 	}
@@ -1141,9 +1140,8 @@ again:
 	arch_enter_lazy_mmu_mode();
 	do {
 		pte_t ptent = *pte;
-		if (pte_none(ptent)) {
+		if (pte_none(ptent))
 			continue;
-		}
 
 		if (pte_present(ptent)) {
 			struct page *page;
@@ -1463,10 +1461,10 @@ EXPORT_SYMBOL_GPL(zap_vma_ptes);
 pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
 			spinlock_t **ptl)
 {
-	pgd_t * pgd = pgd_offset(mm, addr);
-	pud_t * pud = pud_alloc(mm, pgd, addr);
+	pgd_t *pgd = pgd_offset(mm, addr);
+	pud_t *pud = pud_alloc(mm, pgd, addr);
 	if (pud) {
-		pmd_t * pmd = pmd_alloc(mm, pud, addr);
+		pmd_t *pmd = pmd_alloc(mm, pud, addr);
 		if (pmd) {
 			VM_BUG_ON(pmd_trans_huge(*pmd));
 			return pte_alloc_map_lock(mm, pmd, addr, ptl);
@@ -2525,7 +2523,7 @@ void unmap_mapping_range(struct address_
 			hlen = ULONG_MAX - hba + 1;
 	}
 
-	details.check_mapping = even_cows? NULL: mapping;
+	details.check_mapping = even_cows ? NULL : mapping;
 	details.first_index = hba;
 	details.last_index = hba + hlen - 1;
 	if (details.last_index < details.first_index)
@@ -3407,14 +3405,14 @@ static int do_numa_page(struct vm_fault
 	int flags = 0;
 
 	/*
-	* The "pte" at this point cannot be used safely without
-	* validation through pte_unmap_same(). It's of NUMA type but
-	* the pfn may be screwed if the read is non atomic.
-	*
-	* We can safely just do a "set_pte_at()", because the old
-	* page table entry is not accessible, so there would be no
-	* concurrent hardware modifications to the PTE.
-	*/
+	 * The "pte" at this point cannot be used safely without
+	 * validation through pte_unmap_same(). It's of NUMA type but
+	 * the pfn may be screwed if the read is non atomic.
+	 *
+	 * We can safely just do a "set_pte_at()", because the old
+	 * page table entry is not accessible, so there would be no
+	 * concurrent hardware modifications to the PTE.
+	 */
 	vmf->ptl = pte_lockptr(vma->vm_mm, vmf->pmd);
 	spin_lock(vmf->ptl);
 	if (unlikely(!pte_same(*vmf->pte, pte))) {
@@ -3750,14 +3748,14 @@ int handle_mm_fault(struct vm_area_struc
 
 	if (flags & FAULT_FLAG_USER) {
 		mem_cgroup_oom_disable();
-                /*
-                 * The task may have entered a memcg OOM situation but
-                 * if the allocation error was handled gracefully (no
-                 * VM_FAULT_OOM), there is no need to kill anything.
-                 * Just clean up the OOM state peacefully.
-                 */
-                if (task_in_memcg_oom(current) && !(ret & VM_FAULT_OOM))
-                        mem_cgroup_oom_synchronize(false);
+		/*
+		 * The task may have entered a memcg OOM situation but
+		 * if the allocation error was handled gracefully (no
+		 * VM_FAULT_OOM), there is no need to kill anything.
+		 * Just clean up the OOM state peacefully.
+		 */
+		if (task_in_memcg_oom(current) && !(ret & VM_FAULT_OOM))
+			mem_cgroup_oom_synchronize(false);
 	}
 
 	/*
_
