From: akpm@linux-foundation.org
Subject: - smaps-extract-pmd-walker-from-smaps-code.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:24 -0700
Message-ID: <200705080002.l4802OtC008841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967490AbXEHAMF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:12:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, clameter@sgi.com, hugh@veritas.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     smaps: extract pmd walker from smaps code
has been removed from the -mm tree.  Its filename was
     smaps-extract-pmd-walker-from-smaps-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 43 insertions(+), 28 deletions(-)

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

origin.patch
git-alsa.patch
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
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
compiler-introduce-__used-and-__maybe_unused.patch
i386-pci-type-may-be-unused.patch
sh-dma-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
frv-gdb-use-__maybe_unused.patch
i386-voyager-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
powerpc-ps3-use-__maybe_unused.patch
i386-mmzone-use-__maybe_unused.patch
