From: akpm@linux-foundation.org
Subject: - maps2-add-callbacks-for-each-level-to-page-walker.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:20 -0700
Message-ID: <200710162136.l9GLaKFI018567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934491AbXJPVhV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:37:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, jeremy@goop.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     maps: add callbacks for each level to page walker
has been removed from the -mm tree.  Its filename was
     maps2-add-callbacks-for-each-level-to-page-walker.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: maps: add callbacks for each level to page walker
From: Matt Mackall <mpm@selenic.com>

This allows iterating over all levels of the page tables.  Recursion continues
to the depth of the lowest supplied callback.

This makes the page walker nearly completely generic and should allow it to
replace some other hand-rolled page table walkers.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   89 +++++++++++++++++++++++++++++++------------
 1 file changed, 66 insertions(+), 23 deletions(-)

diff -puN fs/proc/task_mmu.c~maps2-add-callbacks-for-each-level-to-page-walker fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-add-callbacks-for-each-level-to-page-walker
+++ a/fs/proc/task_mmu.c
@@ -280,10 +280,35 @@ static int clear_refs_pte_range(pmd_t *p
 	return 0;
 }
 
+struct mm_walk {
+	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, void *);
+	int (*pud_entry)(pud_t *, unsigned long, unsigned long, void *);
+	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, void *);
+	int (*pte_entry)(pte_t *, unsigned long, unsigned long, void *);
+};
+
+static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			  struct mm_walk *walk, void *private)
+{
+	pte_t *pte;
+	int err;
+
+	for (pte = pte_offset_map(pmd, addr); addr != end;
+	     addr += PAGE_SIZE, pte++) {
+		if (pte_none(*pte))
+			continue;
+		err = walk->pte_entry(pte, addr, addr, private);
+		if (err) {
+			pte_unmap(pte);
+			return err;
+		}
+	}
+	pte_unmap(pte);
+	return 0;
+}
+
 static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
-			  int (*action)(pmd_t *, unsigned long,
-					unsigned long, void *),
-			  void *private)
+			  struct mm_walk *walk, void *private)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -294,18 +319,22 @@ static int walk_pmd_range(pud_t *pud, un
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		err = action(pmd, addr, next, private);
-		if (err)
-			return err;
+		if (walk->pmd_entry) {
+			err = walk->pmd_entry(pmd, addr, next, private);
+			if (err)
+				return err;
+		}
+		if (walk->pte_entry) {
+			err = walk_pte_range(pmd, addr, next, walk, private);
+			if (err)
+				return err;
+		}
 	}
-
 	return 0;
 }
 
 static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
-			  int (*action)(pmd_t *, unsigned long,
-					unsigned long, void *),
-			  void *private)
+			  struct mm_walk *walk, void *private)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -316,11 +345,17 @@ static int walk_pud_range(pgd_t *pgd, un
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		err = walk_pmd_range(pud, addr, next, action, private);
-		if (err)
-			return err;
+		if (walk->pud_entry) {
+			err = walk->pud_entry(pud, addr, next, private);
+			if (err)
+				return err;
+		}
+		if (walk->pmd_entry || walk->pte_entry) {
+			err = walk_pmd_range(pud, addr, next, walk, private);
+			if (err)
+				return err;
+		}
 	}
-
 	return 0;
 }
 
@@ -337,9 +372,7 @@ static int walk_pud_range(pgd_t *pgd, un
  */
 static int walk_page_range(struct mm_struct *mm,
 			   unsigned long addr, unsigned long end,
-			   int (*action)(pmd_t *, unsigned long,
-					 unsigned long, void *),
-			   void *private)
+			   struct mm_walk *walk, void *private)
 {
 	pgd_t *pgd;
 	unsigned long next;
@@ -350,14 +383,22 @@ static int walk_page_range(struct mm_str
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		err = walk_pud_range(pgd, addr, next, action, private);
-		if (err)
-			return err;
+		if (walk->pgd_entry) {
+			err = walk->pgd_entry(pgd, addr, next, private);
+			if (err)
+				return err;
+		}
+		if (walk->pud_entry || walk->pmd_entry || walk->pte_entry) {
+			err = walk_pud_range(pgd, addr, next, walk, private);
+			if (err)
+				return err;
+		}
 	}
-
 	return 0;
 }
 
+static struct mm_walk smaps_walk = { .pmd_entry = smaps_pte_range };
+
 static int show_smap(struct seq_file *m, void *v)
 {
 	struct vm_area_struct *vma = v;
@@ -367,10 +408,12 @@ static int show_smap(struct seq_file *m,
 	mss.vma = vma;
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
-				smaps_pte_range, &mss);
+				&smaps_walk, &mss);
 	return show_map_internal(m, v, &mss);
 }
 
+static struct mm_walk clear_refs_walk = { .pmd_entry = clear_refs_pte_range };
+
 void clear_refs_smap(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
@@ -379,7 +422,7 @@ void clear_refs_smap(struct mm_struct *m
 	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 			walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
-					clear_refs_pte_range, vma);
+					&clear_refs_walk, vma);
 	flush_tlb_mm(mm);
 	up_read(&mm->mmap_sem);
 }
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
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
