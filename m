From: akpm@linux-foundation.org
Subject: + smaps-extract-pmd-walker-from-smaps-code.patch added to -mm tree
Date: Fri, 09 Feb 2007 15:39:45 -0800
Message-ID: <200702092339.l19Ndjs5029891@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54710 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbXBIXj7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 18:39:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, clameter@sgi.com, hugh@veritas.com, lethal@linux-sh.org


The patch titled
     smaps: extract pmd walker from smaps code
has been added to the -mm tree.  Its filename is
     smaps-extract-pmd-walker-from-smaps-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: smaps: extract pmd walker from smaps code
From: David Rientjes <rientjes@google.com>

Extracts the pmd walker from smaps-specific code in fs/proc/task_mmu.c.

The new struct pmd_walker includes the struct vm_area_struct of the memory to
walk over.  Iteration begins at the vma->vm_start and completes at
vma->vm_end.  A pointer to another data structure may be stored in the private
field such as struct mem_size_stats, which acts as the smaps accumulator.  For
each pmd in the VMA, the action function is called with a pointer to its
struct vm_area_struct, a pointer to the pmd_t, its start and end addresses,
and the private field.

The interface for walking pmd's in a VMA for fs/proc/task_mmu.c is now:

	void for_each_pmd(struct vm_area_struct *vma,
			  void (*action)(struct vm_area_struct *vma,
					 pmd_t *pmd, unsigned long addr,
					 unsigned long end,
					 void *private),
			  void *private);

Since the pmd walker is now extracted from the smaps code, smaps_one_pmd() is
invoked for each pmd in the VMA.  Its behavior and efficiency is identical to
the existing implementation.

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   71 ++++++++++++++++++++++++++-----------------
 1 files changed, 43 insertions(+), 28 deletions(-)

diff -puN fs/proc/task_mmu.c~smaps-extract-pmd-walker-from-smaps-code fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-extract-pmd-walker-from-smaps-code
+++ a/fs/proc/task_mmu.c
@@ -122,6 +122,13 @@ struct mem_size_stats
 	unsigned long private_dirty;
 };
 
+struct pmd_walker {
+	struct vm_area_struct *vma;
+	void *private;
+	void (*action)(struct vm_area_struct *, pmd_t *, unsigned long,
+		       unsigned long, void *);
+};
+
 static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats *mss)
 {
 	struct proc_maps_private *priv = m->private;
@@ -204,16 +211,17 @@ static int show_map(struct seq_file *m, 
 	return show_map_internal(m, v, NULL);
 }
 
-static void smaps_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-				unsigned long addr, unsigned long end,
-				struct mem_size_stats *mss)
+static void smaps_one_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+			  unsigned long addr, unsigned long end,
+			  void *private)
 {
+	struct mem_size_stats *mss = private;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	do {
+	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
 		if (!pte_present(ptent))
 			continue;
@@ -235,57 +243,64 @@ static void smaps_pte_range(struct vm_ar
 			else
 				mss->private_clean += PAGE_SIZE;
 		}
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
 }
 
-static inline void smaps_pmd_range(struct vm_area_struct *vma, pud_t *pud,
-				unsigned long addr, unsigned long end,
-				struct mem_size_stats *mss)
+static inline void for_each_pmd_in_pud(struct pmd_walker *walker, pud_t *pud,
+				       unsigned long addr, unsigned long end)
 {
 	pmd_t *pmd;
 	unsigned long next;
 
-	pmd = pmd_offset(pud, addr);
-	do {
+	for (pmd = pmd_offset(pud, addr); addr != end;
+	     pmd++, addr = next) {
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		smaps_pte_range(vma, pmd, addr, next, mss);
-	} while (pmd++, addr = next, addr != end);
+		walker->action(walker->vma, pmd, addr, next, walker->private);
+	}
 }
 
-static inline void smaps_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
-				unsigned long addr, unsigned long end,
-				struct mem_size_stats *mss)
+static inline void for_each_pud_in_pgd(struct pmd_walker *walker, pgd_t *pgd,
+				       unsigned long addr, unsigned long end)
 {
 	pud_t *pud;
 	unsigned long next;
 
-	pud = pud_offset(pgd, addr);
-	do {
+	for (pud = pud_offset(pgd, addr); addr != end;
+	     pud++, addr = next) {
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		smaps_pmd_range(vma, pud, addr, next, mss);
-	} while (pud++, addr = next, addr != end);
+		for_each_pmd_in_pud(walker, pud, addr, next);
+	}
 }
 
-static inline void smaps_pgd_range(struct vm_area_struct *vma,
-				unsigned long addr, unsigned long end,
-				struct mem_size_stats *mss)
-{
+static inline void for_each_pmd(struct vm_area_struct *vma,
+				void (*action)(struct vm_area_struct *, pmd_t *,
+					       unsigned long, unsigned long,
+					       void *),
+				void *private)
+{
+	unsigned long addr = vma->vm_start;
+	unsigned long end = vma->vm_end;
+	struct pmd_walker walker = {
+		.vma		= vma,
+		.private	= private,
+		.action		= action,
+	};
 	pgd_t *pgd;
 	unsigned long next;
 
-	pgd = pgd_offset(vma->vm_mm, addr);
-	do {
+	for (pgd = pgd_offset(vma->vm_mm, addr); addr != end;
+	     pgd++, addr = next) {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		smaps_pud_range(vma, pgd, addr, next, mss);
-	} while (pgd++, addr = next, addr != end);
+		for_each_pud_in_pgd(&walker, pgd, addr, next);
+	}
 }
 
 static int show_smap(struct seq_file *m, void *v)
@@ -295,7 +310,7 @@ static int show_smap(struct seq_file *m,
 
 	memset(&mss, 0, sizeof mss);
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-		smaps_pgd_range(vma, vma->vm_start, vma->vm_end, &mss);
+		for_each_pmd(vma, smaps_one_pmd, &mss);
 	return show_map_internal(m, v, &mss);
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
