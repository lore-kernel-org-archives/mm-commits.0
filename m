From: akpm@linux-foundation.org
Subject: [folded-merged] mm-fix-checkpatch-errors-whitespace-errors.patch
 removed from -mm tree
Date: Thu, 02 Feb 2017 15:19:29 -0800
Message-ID: <5893be81.Q9plRjE7ee3DXdFN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33084 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbdBBXTa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 18:19:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@tobin.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Fix checkpatch errors, whitespace errors
has been removed from the -mm tree.  Its filename was
     mm-fix-checkpatch-errors-whitespace-errors.patch

This patch was dropped because it was folded into mm-fix-checkpatch-warnings-whitespace.patch

------------------------------------------------------
From: Tobin C Harding <me@tobin.cc>
Subject: mm: Fix checkpatch errors, whitespace errors

Patch fixes whitespace checkpatch errors.

Link: http://lkml.kernel.org/r/1485992240-10986-4-git-send-email-me@tobin.cc
Signed-off-by: Tobin C Harding <me@tobin.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff -puN mm/memory.c~mm-fix-checkpatch-errors-whitespace-errors mm/memory.c
--- a/mm/memory.c~mm-fix-checkpatch-errors-whitespace-errors
+++ a/mm/memory.c
@@ -95,7 +95,7 @@ EXPORT_SYMBOL(mem_map);
  * highstart_pfn must be the same; there must be no gap between ZONE_NORMAL
  * and ZONE_HIGHMEM.
  */
-void * high_memory;
+void *high_memory;
 EXPORT_SYMBOL(high_memory);
 
 /*
@@ -555,7 +555,7 @@ void free_pgtables(struct mmu_gather *tl
 
 		if (is_vm_hugetlb_page(vma)) {
 			hugetlb_free_pgd_range(tlb, addr, vma->vm_end,
-				floor, next? next->vm_start: ceiling);
+				floor, next ? next->vm_start : ceiling);
 		} else {
 			/*
 			 * Optimization: gather nearby vmas into one call down
@@ -568,7 +568,7 @@ void free_pgtables(struct mmu_gather *tl
 				unlink_file_vma(vma);
 			}
 			free_pgd_range(tlb, addr, vma->vm_end,
-				floor, next? next->vm_start: ceiling);
+				floor, next ? next->vm_start : ceiling);
 		}
 		vma = next;
 	}
@@ -1462,10 +1462,10 @@ EXPORT_SYMBOL_GPL(zap_vma_ptes);
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
@@ -2524,7 +2524,7 @@ void unmap_mapping_range(struct address_
 			hlen = ULONG_MAX - hba + 1;
 	}
 
-	details.check_mapping = even_cows? NULL: mapping;
+	details.check_mapping = even_cows ? NULL : mapping;
 	details.first_index = hba;
 	details.last_index = hba + hlen - 1;
 	if (details.last_index < details.first_index)
@@ -3406,14 +3406,14 @@ static int do_numa_page(struct vm_fault
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
@@ -3758,12 +3758,12 @@ int handle_mm_fault(struct vm_area_struc
 
 	if (flags & FAULT_FLAG_USER) {
 		mem_cgroup_oom_disable();
-                /*
-                 * The task may have entered a memcg OOM situation but
-                 * if the allocation error was handled gracefully (no
-                 * VM_FAULT_OOM), there is no need to kill anything.
-                 * Just clean up the OOM state peacefully.
-                 */
+		/*
+		 * The task may have entered a memcg OOM situation but
+		 * if the allocation error was handled gracefully (no
+		 * VM_FAULT_OOM), there is no need to kill anything.
+		 * Just clean up the OOM state peacefully.
+		 */
 		if (task_in_memcg_oom(current) && !(ret & VM_FAULT_OOM))
 			mem_cgroup_oom_synchronize(false);
 	}
_

Patches currently in -mm which might be from me@tobin.cc are

mm-fix-sparse-use-plain-integer-as-null-pointer.patch
mm-fix-checkpatch-warnings-whitespace.patch
mm-fix-checkpatch-warning-extraneous-braces.patch

