From: akpm@linux-foundation.org
Subject: - maps2-propagate-errors-from-callback-in-page-walker.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:18 -0700
Message-ID: <200710162136.l9GLaIco018564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33453 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934310AbXJPVhC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:37:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, jeremy@goop.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     maps: propagate errors from callback in page walker
has been removed from the -mm tree.  Its filename was
     maps2-propagate-errors-from-callback-in-page-walker.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: maps: propagate errors from callback in page walker
From: Matt Mackall <mpm@selenic.com>

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   57 +++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff -puN fs/proc/task_mmu.c~maps2-propagate-errors-from-callback-in-page-walker fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-propagate-errors-from-callback-in-page-walker
+++ a/fs/proc/task_mmu.c
@@ -212,8 +212,8 @@ static int show_map(struct seq_file *m, 
 	return show_map_internal(m, v, NULL);
 }
 
-static void smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
-			    void *private)
+static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			   void *private)
 {
 	struct mem_size_stats *mss = private;
 	struct vm_area_struct *vma = mss->vma;
@@ -250,10 +250,11 @@ static void smaps_pte_range(pmd_t *pmd, 
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
+	return 0;
 }
 
-static void clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
-				 unsigned long end, void *private)
+static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
+				unsigned long end, void *private)
 {
 	struct vm_area_struct *vma = private;
 	pte_t *pte, ptent;
@@ -276,40 +277,51 @@ static void clear_refs_pte_range(pmd_t *
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
+	return 0;
 }
 
-static void walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
-			   void (*action)(pmd_t *, unsigned long,
-					  unsigned long, void *),
-			   void *private)
+static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
+			  int (*action)(pmd_t *, unsigned long,
+					unsigned long, void *),
+			  void *private)
 {
 	pmd_t *pmd;
 	unsigned long next;
+	int err;
 
 	for (pmd = pmd_offset(pud, addr); addr != end;
 	     pmd++, addr = next) {
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		action(pmd, addr, next, private);
+		err = action(pmd, addr, next, private);
+		if (err)
+			return err;
 	}
+
+	return 0;
 }
 
-static void walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
-			   void (*action)(pmd_t *, unsigned long,
-					  unsigned long, void *),
-			   void *private)
+static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
+			  int (*action)(pmd_t *, unsigned long,
+					unsigned long, void *),
+			  void *private)
 {
 	pud_t *pud;
 	unsigned long next;
+	int err;
 
 	for (pud = pud_offset(pgd, addr); addr != end;
 	     pud++, addr = next) {
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		walk_pmd_range(pud, addr, next, action, private);
+		err = walk_pmd_range(pud, addr, next, action, private);
+		if (err)
+			return err;
 	}
+
+	return 0;
 }
 
 /*
@@ -323,22 +335,27 @@ static void walk_pud_range(pgd_t *pgd, u
  * Recursively walk the page table for the memory area in a VMA, calling
  * a callback for every bottom-level (PTE) page table.
  */
-static void walk_page_range(struct mm_struct *mm,
-			    unsigned long addr, unsigned long end,
-			    void (*action)(pmd_t *, unsigned long,
-					   unsigned long, void *),
-			    void *private)
+static int walk_page_range(struct mm_struct *mm,
+			   unsigned long addr, unsigned long end,
+			   int (*action)(pmd_t *, unsigned long,
+					 unsigned long, void *),
+			   void *private)
 {
 	pgd_t *pgd;
 	unsigned long next;
+	int err;
 
 	for (pgd = pgd_offset(mm, addr); addr != end;
 	     pgd++, addr = next) {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		walk_pud_range(pgd, addr, next, action, private);
+		err = walk_pud_range(pgd, addr, next, action, private);
+		if (err)
+			return err;
 	}
+
+	return 0;
 }
 
 static int show_smap(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
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
