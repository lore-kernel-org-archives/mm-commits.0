From: akpm@linux-foundation.org
Subject: - maps2-move-the-page-walker-code-to-lib.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:22 -0700
Message-ID: <200710162136.l9GLaMrP018570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36024 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966075AbXJPVst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:48:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, jeremy@goop.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     maps: move the page walker code to lib/
has been removed from the -mm tree.  Its filename was
     maps2-move-the-page-walker-code-to-lib.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: maps: move the page walker code to lib/
From: Matt Mackall <mpm@selenic.com>

This lets it get shared outside of proc/ and linked in only when needed.

[akpm@linux-foundation.org: build fixes]
Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |  117 -------------------------------------------
 include/linux/mm.h |   10 +++
 lib/Makefile       |    2 
 lib/pagewalk.c     |  113 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 124 insertions(+), 118 deletions(-)

diff -puN fs/proc/task_mmu.c~maps2-move-the-page-walker-code-to-lib fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-move-the-page-walker-code-to-lib
+++ a/fs/proc/task_mmu.c
@@ -280,123 +280,6 @@ static int clear_refs_pte_range(pmd_t *p
 	return 0;
 }
 
-struct mm_walk {
-	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, void *);
-	int (*pud_entry)(pud_t *, unsigned long, unsigned long, void *);
-	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, void *);
-	int (*pte_entry)(pte_t *, unsigned long, unsigned long, void *);
-};
-
-static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
-			  struct mm_walk *walk, void *private)
-{
-	pte_t *pte;
-	int err;
-
-	for (pte = pte_offset_map(pmd, addr); addr != end;
-	     addr += PAGE_SIZE, pte++) {
-		if (pte_none(*pte))
-			continue;
-		err = walk->pte_entry(pte, addr, addr, private);
-		if (err) {
-			pte_unmap(pte);
-			return err;
-		}
-	}
-	pte_unmap(pte);
-	return 0;
-}
-
-static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
-			  struct mm_walk *walk, void *private)
-{
-	pmd_t *pmd;
-	unsigned long next;
-	int err;
-
-	for (pmd = pmd_offset(pud, addr); addr != end;
-	     pmd++, addr = next) {
-		next = pmd_addr_end(addr, end);
-		if (pmd_none_or_clear_bad(pmd))
-			continue;
-		if (walk->pmd_entry) {
-			err = walk->pmd_entry(pmd, addr, next, private);
-			if (err)
-				return err;
-		}
-		if (walk->pte_entry) {
-			err = walk_pte_range(pmd, addr, next, walk, private);
-			if (err)
-				return err;
-		}
-	}
-	return 0;
-}
-
-static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
-			  struct mm_walk *walk, void *private)
-{
-	pud_t *pud;
-	unsigned long next;
-	int err;
-
-	for (pud = pud_offset(pgd, addr); addr != end;
-	     pud++, addr = next) {
-		next = pud_addr_end(addr, end);
-		if (pud_none_or_clear_bad(pud))
-			continue;
-		if (walk->pud_entry) {
-			err = walk->pud_entry(pud, addr, next, private);
-			if (err)
-				return err;
-		}
-		if (walk->pmd_entry || walk->pte_entry) {
-			err = walk_pmd_range(pud, addr, next, walk, private);
-			if (err)
-				return err;
-		}
-	}
-	return 0;
-}
-
-/*
- * walk_page_range - walk a memory map's page tables with a callback
- * @mm - memory map to walk
- * @addr - starting address
- * @end - ending address
- * @action - callback invoked for every bottom-level (PTE) page table
- * @private - private data passed to the callback function
- *
- * Recursively walk the page table for the memory area in a VMA, calling
- * a callback for every bottom-level (PTE) page table.
- */
-static int walk_page_range(struct mm_struct *mm,
-			   unsigned long addr, unsigned long end,
-			   struct mm_walk *walk, void *private)
-{
-	pgd_t *pgd;
-	unsigned long next;
-	int err;
-
-	for (pgd = pgd_offset(mm, addr); addr != end;
-	     pgd++, addr = next) {
-		next = pgd_addr_end(addr, end);
-		if (pgd_none_or_clear_bad(pgd))
-			continue;
-		if (walk->pgd_entry) {
-			err = walk->pgd_entry(pgd, addr, next, private);
-			if (err)
-				return err;
-		}
-		if (walk->pud_entry || walk->pmd_entry || walk->pte_entry) {
-			err = walk_pud_range(pgd, addr, next, walk, private);
-			if (err)
-				return err;
-		}
-	}
-	return 0;
-}
-
 static struct mm_walk smaps_walk = { .pmd_entry = smaps_pte_range };
 
 static int show_smap(struct seq_file *m, void *v)
diff -puN include/linux/mm.h~maps2-move-the-page-walker-code-to-lib include/linux/mm.h
--- a/include/linux/mm.h~maps2-move-the-page-walker-code-to-lib
+++ a/include/linux/mm.h
@@ -711,6 +711,16 @@ unsigned long unmap_vmas(struct mmu_gath
 		struct vm_area_struct *start_vma, unsigned long start_addr,
 		unsigned long end_addr, unsigned long *nr_accounted,
 		struct zap_details *);
+
+struct mm_walk {
+	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, void *);
+	int (*pud_entry)(pud_t *, unsigned long, unsigned long, void *);
+	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, void *);
+	int (*pte_entry)(pte_t *, unsigned long, unsigned long, void *);
+};
+
+int walk_page_range(struct mm_struct *, unsigned long addr, unsigned long end,
+		    struct mm_walk *walk, void *private);
 void free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *start_vma,
diff -puN lib/Makefile~maps2-move-the-page-walker-code-to-lib lib/Makefile
--- a/lib/Makefile~maps2-move-the-page-walker-code-to-lib
+++ a/lib/Makefile
@@ -7,7 +7,7 @@ lib-y := ctype.o string.o vsprintf.o kas
 	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o
 
-lib-$(CONFIG_MMU) += ioremap.o
+lib-$(CONFIG_MMU) += ioremap.o pagewalk.o
 lib-$(CONFIG_SMP) += cpumask.o
 
 lib-y	+= kobject.o kref.o klist.o
diff -puN /dev/null lib/pagewalk.c
--- /dev/null
+++ a/lib/pagewalk.c
@@ -0,0 +1,113 @@
+#include <linux/mm.h>
+#include <linux/highmem.h>
+#include <linux/sched.h>
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
+static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
+			  struct mm_walk *walk, void *private)
+{
+	pmd_t *pmd;
+	unsigned long next;
+	int err;
+
+	for (pmd = pmd_offset(pud, addr); addr != end;
+	     pmd++, addr = next) {
+		next = pmd_addr_end(addr, end);
+		if (pmd_none_or_clear_bad(pmd))
+			continue;
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
+	}
+	return 0;
+}
+
+static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
+			  struct mm_walk *walk, void *private)
+{
+	pud_t *pud;
+	unsigned long next;
+	int err;
+
+	for (pud = pud_offset(pgd, addr); addr != end;
+	     pud++, addr = next) {
+		next = pud_addr_end(addr, end);
+		if (pud_none_or_clear_bad(pud))
+			continue;
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
+	}
+	return 0;
+}
+
+/*
+ * walk_page_range - walk a memory map's page tables with a callback
+ * @mm - memory map to walk
+ * @addr - starting address
+ * @end - ending address
+ * @walk - set of callbacks to invoke for each level of the tree
+ * @private - private data passed to the callback function
+ *
+ * Recursively walk the page table for the memory area in a VMA, calling
+ * a callback for every bottom-level (PTE) page table.
+ */
+int walk_page_range(struct mm_struct *mm,
+		    unsigned long addr, unsigned long end,
+		    struct mm_walk *walk, void *private)
+{
+	pgd_t *pgd;
+	unsigned long next;
+	int err;
+
+	for (pgd = pgd_offset(mm, addr); addr != end;
+	     pgd++, addr = next) {
+		next = pgd_addr_end(addr, end);
+		if (pgd_none_or_clear_bad(pgd))
+			continue;
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
+	}
+	return 0;
+}
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
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
