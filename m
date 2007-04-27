From: akpm@linux-foundation.org
Subject: - smaps-add-clear_refs-file-to-clear-reference-cleanup.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:12:46 -0700
Message-ID: <200704270812.l3R8ClNu023009@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755500AbXD0IND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     rename for_each_pmd
has been removed from the -mm tree.  Its filename was
     smaps-add-clear_refs-file-to-clear-reference-cleanup.patch

This patch was dropped because it was folded into smaps-add-clear_refs-file-to-clear-reference.patch

------------------------------------------------------
Subject: rename for_each_pmd
From: Matt Mackall <mpm@selenic.com>

This function caused me some confusion.  In keeping with the precedent in
mm/memory.c, I've used pte_range instead of pmd.  While I was at it, I
changed for_each_ to walk_ as we have another precedent of using for_each
as a macro that can drive a for loop.

[It'd be nice to give sensible names to these data structures some day. 
For instance, the thing pointed at by a pmd_t is not a "page middle
directory" but a "page table entry...table"?

Ideally, we'd make a consistent distinction between "e"ntries and
"d"irectories in the naming.  So a PGD would contain PGEs that pointed
to...  that pointed to PTDs that contained PTEs.]

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   47 +++++++++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 19 deletions(-)

diff -puN fs/proc/task_mmu.c~smaps-add-clear_refs-file-to-clear-reference-cleanup fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-add-clear_refs-file-to-clear-reference-cleanup
+++ a/fs/proc/task_mmu.c
@@ -214,9 +214,9 @@ static int show_map(struct seq_file *m, 
 	return show_map_internal(m, v, NULL);
 }
 
-static void smaps_one_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-			  unsigned long addr, unsigned long end,
-			  void *private)
+static void smaps_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
+			    unsigned long addr, unsigned long end,
+			    void *private)
 {
 	struct mem_size_stats *mss = private;
 	pte_t *pte, ptent;
@@ -254,9 +254,9 @@ static void smaps_one_pmd(struct vm_area
 	cond_resched();
 }
 
-static void clear_refs_one_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-			       unsigned long addr, unsigned long end,
-			       void *private)
+static void clear_refs_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
+				 unsigned long addr, unsigned long end,
+				 void *private)
 {
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
@@ -283,8 +283,8 @@ static void clear_refs_one_pmd(struct vm
 	cond_resched();
 }
 
-static inline void for_each_pmd_in_pud(struct pmd_walker *walker, pud_t *pud,
-				       unsigned long addr, unsigned long end)
+static inline void walk_pmd_range(struct pmd_walker *walker, pud_t *pud,
+				  unsigned long addr, unsigned long end)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -298,8 +298,8 @@ static inline void for_each_pmd_in_pud(s
 	}
 }
 
-static inline void for_each_pud_in_pgd(struct pmd_walker *walker, pgd_t *pgd,
-				       unsigned long addr, unsigned long end)
+static inline void walk_pud_range(struct pmd_walker *walker, pgd_t *pgd,
+				  unsigned long addr, unsigned long end)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -309,15 +309,24 @@ static inline void for_each_pud_in_pgd(s
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		for_each_pmd_in_pud(walker, pud, addr, next);
+		walk_pmd_range(walker, pud, addr, next);
 	}
 }
 
-static inline void for_each_pmd(struct vm_area_struct *vma,
-				void (*action)(struct vm_area_struct *, pmd_t *,
-					       unsigned long, unsigned long,
-					       void *),
-				void *private)
+/*
+ * walk_page_range - walk the page tables of a VMA with a callback
+ * @vma - VMA to walk
+ * @action - callback invoked for every bottom-level (PTE) page table
+ * @private - private data passed to the callback function
+ *
+ * Recursively walk the page table for the memory area in a VMA, calling
+ * a callback for every bottom-level (PTE) page table.
+ */
+static inline void walk_page_range(struct vm_area_struct *vma,
+				   void (*action)(struct vm_area_struct *,
+						  pmd_t *, unsigned long,
+						  unsigned long, void *),
+				   void *private)
 {
 	unsigned long addr = vma->vm_start;
 	unsigned long end = vma->vm_end;
@@ -334,7 +343,7 @@ static inline void for_each_pmd(struct v
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		for_each_pud_in_pgd(&walker, pgd, addr, next);
+		walk_pud_range(&walker, pgd, addr, next);
 	}
 }
 
@@ -345,7 +354,7 @@ static int show_smap(struct seq_file *m,
 
 	memset(&mss, 0, sizeof mss);
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-		for_each_pmd(vma, smaps_one_pmd, &mss);
+		walk_page_range(vma, smaps_pte_range, &mss);
 	return show_map_internal(m, v, &mss);
 }
 
@@ -356,7 +365,7 @@ void clear_refs_smap(struct mm_struct *m
 	down_read(&mm->mmap_sem);
 	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-			for_each_pmd(vma, clear_refs_one_pmd, NULL);
+			walk_page_range(vma, clear_refs_pte_range, NULL);
 	flush_tlb_mm(mm);
 	up_read(&mm->mmap_sem);
 }
_

Patches currently in -mm which might be from mpm@selenic.com are

slab-introduce-krealloc.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-pid-pagemap-interface-fix.patch
maps2-add-proc-pid-pagemap-interface-fix-fix.patch
maps2-add-proc-kpagemap-interface.patch
maps2-add-proc-kpagemap-interface-fix.patch
slob-handle-slab_panic-flag.patch
