From: akpm@linux-foundation.org
Subject: + smaps-add-clear_refs-file-to-clear-reference-cleanup.patch added to -mm tree
Date: Wed, 21 Mar 2007 15:27:04 -0700
Message-ID: <200703212227.l2LMR4ip005425@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56594 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965402AbXCUW1Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:27:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, rientjes@google.com


The patch titled
     rename for_each_pmd
has been added to the -mm tree.  Its filename is
     smaps-add-clear_refs-file-to-clear-reference-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
slab-introduce-krealloc-fix.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
