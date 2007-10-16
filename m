From: akpm@linux-foundation.org
Subject: - maps2-remove-vma-from-args-in-the-page-walker.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:16 -0700
Message-ID: <200710162136.l9GLaGhV018561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933745AbXJPVg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, jeremy@goop.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     maps: remove vma from args in the page walker
has been removed from the -mm tree.  Its filename was
     maps2-remove-vma-from-args-in-the-page-walker.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: maps: remove vma from args in the page walker
From: Matt Mackall <mpm@selenic.com>

This makes the walker more generic.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN fs/proc/task_mmu.c~maps2-remove-vma-from-args-in-the-page-walker fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-remove-vma-from-args-in-the-page-walker
+++ a/fs/proc/task_mmu.c
@@ -313,25 +313,26 @@ static void walk_pud_range(pgd_t *pgd, u
 }
 
 /*
- * walk_page_range - walk the page tables of a VMA with a callback
- * @vma - VMA to walk
+ * walk_page_range - walk a memory map's page tables with a callback
+ * @mm - memory map to walk
+ * @addr - starting address
+ * @end - ending address
  * @action - callback invoked for every bottom-level (PTE) page table
  * @private - private data passed to the callback function
  *
  * Recursively walk the page table for the memory area in a VMA, calling
  * a callback for every bottom-level (PTE) page table.
  */
-static void walk_page_range(struct vm_area_struct *vma,
+static void walk_page_range(struct mm_struct *mm,
+			    unsigned long addr, unsigned long end,
 			    void (*action)(pmd_t *, unsigned long,
 					   unsigned long, void *),
 			    void *private)
 {
-	unsigned long addr = vma->vm_start;
-	unsigned long end = vma->vm_end;
 	pgd_t *pgd;
 	unsigned long next;
 
-	for (pgd = pgd_offset(vma->vm_mm, addr); addr != end;
+	for (pgd = pgd_offset(mm, addr); addr != end;
 	     pgd++, addr = next) {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
@@ -348,7 +349,8 @@ static int show_smap(struct seq_file *m,
 	memset(&mss, 0, sizeof mss);
 	mss.vma = vma;
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-		walk_page_range(vma, smaps_pte_range, &mss);
+		walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
+				smaps_pte_range, &mss);
 	return show_map_internal(m, v, &mss);
 }
 
@@ -359,7 +361,8 @@ void clear_refs_smap(struct mm_struct *m
 	down_read(&mm->mmap_sem);
 	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-			walk_page_range(vma, clear_refs_pte_range, vma);
+			walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
+					clear_refs_pte_range, vma);
 	flush_tlb_mm(mm);
 	up_read(&mm->mmap_sem);
 }
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
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
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace.patch
maps2-add-proc-kpagemap-interface.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
lib-sortc-optimization.patch
sparse-pointer-use-of-zero-as-null.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
