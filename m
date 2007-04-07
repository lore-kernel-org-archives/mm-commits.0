From: akpm@linux-foundation.org
Subject: + maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch added to -mm tree
Date: Fri, 06 Apr 2007 23:55:35 -0700
Message-ID: <200704070655.l376tZGZ029466@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46429 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965452AbXDGGzs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 02:55:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, jeremy@goop.org, rientjes@google.com


The patch titled
     maps: eliminate the pmd_walker struct in the page walker
has been added to the -mm tree.  Its filename is
     maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: maps: eliminate the pmd_walker struct in the page walker
From: Matt Mackall <mpm@selenic.com>

Eliminate the pmd_walker struct in the page walker.

This slightly simplifies things for the next few cleanups.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   47 ++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 27 deletions(-)

diff -puN fs/proc/task_mmu.c~maps2-eliminate-the-pmd_walker-struct-in-the-page-walker fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-eliminate-the-pmd_walker-struct-in-the-page-walker
+++ a/fs/proc/task_mmu.c
@@ -115,6 +115,7 @@ static void pad_len_spaces(struct seq_fi
 
 struct mem_size_stats
 {
+	struct vm_area_struct *vma;
 	unsigned long resident;
 	unsigned long shared_clean;
 	unsigned long shared_dirty;
@@ -123,13 +124,6 @@ struct mem_size_stats
 	unsigned long referenced;
 };
 
-struct pmd_walker {
-	struct vm_area_struct *vma;
-	void *private;
-	void (*action)(struct vm_area_struct *, pmd_t *, unsigned long,
-		       unsigned long, void *);
-};
-
 static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats *mss)
 {
 	struct proc_maps_private *priv = m->private;
@@ -214,11 +208,11 @@ static int show_map(struct seq_file *m, 
 	return show_map_internal(m, v, NULL);
 }
 
-static void smaps_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-			    unsigned long addr, unsigned long end,
+static void smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			    void *private)
 {
 	struct mem_size_stats *mss = private;
+	struct vm_area_struct *vma = mss->vma;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
@@ -254,10 +248,10 @@ static void smaps_pte_range(struct vm_ar
 	cond_resched();
 }
 
-static void clear_refs_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-				 unsigned long addr, unsigned long end,
-				 void *private)
+static void clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
+				 unsigned long end, void *private)
 {
+	struct vm_area_struct *vma = private;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
@@ -280,8 +274,10 @@ static void clear_refs_pte_range(struct 
 	cond_resched();
 }
 
-static void walk_pmd_range(struct pmd_walker *walker, pud_t *pud,
-				  unsigned long addr, unsigned long end)
+static void walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
+			   void (*action)(pmd_t *, unsigned long,
+					  unsigned long, void *),
+			   void *private)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -291,12 +287,14 @@ static void walk_pmd_range(struct pmd_wa
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		walker->action(walker->vma, pmd, addr, next, walker->private);
+		action(pmd, addr, next, private);
 	}
 }
 
-static void walk_pud_range(struct pmd_walker *walker, pgd_t *pgd,
-				  unsigned long addr, unsigned long end)
+static void walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
+			   void (*action)(pmd_t *, unsigned long,
+					  unsigned long, void *),
+			   void *private)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -306,7 +304,7 @@ static void walk_pud_range(struct pmd_wa
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		walk_pmd_range(walker, pud, addr, next);
+		walk_pmd_range(pud, addr, next, action, private);
 	}
 }
 
@@ -320,18 +318,12 @@ static void walk_pud_range(struct pmd_wa
  * a callback for every bottom-level (PTE) page table.
  */
 static void walk_page_range(struct vm_area_struct *vma,
-			    void (*action)(struct vm_area_struct *,
-					   pmd_t *, unsigned long,
+			    void (*action)(pmd_t *, unsigned long,
 					   unsigned long, void *),
 			    void *private)
 {
 	unsigned long addr = vma->vm_start;
 	unsigned long end = vma->vm_end;
-	struct pmd_walker walker = {
-		.vma		= vma,
-		.private	= private,
-		.action		= action,
-	};
 	pgd_t *pgd;
 	unsigned long next;
 
@@ -340,7 +332,7 @@ static void walk_page_range(struct vm_ar
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		walk_pud_range(&walker, pgd, addr, next);
+		walk_pud_range(pgd, addr, next, action, private);
 	}
 }
 
@@ -350,6 +342,7 @@ static int show_smap(struct seq_file *m,
 	struct mem_size_stats mss;
 
 	memset(&mss, 0, sizeof mss);
+	mss.vma = vma;
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma, smaps_pte_range, &mss);
 	return show_map_internal(m, v, &mss);
@@ -362,7 +355,7 @@ void clear_refs_smap(struct mm_struct *m
 	down_read(&mm->mmap_sem);
 	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-			walk_page_range(vma, clear_refs_pte_range, NULL);
+			walk_page_range(vma, clear_refs_pte_range, vma);
 	flush_tlb_mm(mm);
 	up_read(&mm->mmap_sem);
 }
_

Patches currently in -mm which might be from mpm@selenic.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
