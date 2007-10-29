From: akpm@linux-foundation.org
Subject: + maps4-introduce-a-generic-page-walker.patch added to -mm tree
Date: Mon, 29 Oct 2007 14:57:31 -0700
Message-ID: <200710292157.l9TLvVps025331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbXJ2V5z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 17:57:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, haveblue@us.ibm.com


The patch titled
     maps4: introduce a generic page walker
has been added to the -mm tree.  Its filename is
     maps4-introduce-a-generic-page-walker.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: maps4: introduce a generic page walker
From: Matt Mackall <mpm@selenic.com>

Introduce a general page table walker

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   22 +++++++
 mm/Makefile        |    2 
 mm/pagewalk.c      |  131 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 154 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~maps4-introduce-a-generic-page-walker include/linux/mm.h
--- a/include/linux/mm.h~maps4-introduce-a-generic-page-walker
+++ a/include/linux/mm.h
@@ -702,6 +702,28 @@ unsigned long unmap_vmas(struct mmu_gath
 		struct vm_area_struct *start_vma, unsigned long start_addr,
 		unsigned long end_addr, unsigned long *nr_accounted,
 		struct zap_details *);
+
+/**
+ * mm_walk - callbacks for walk_page_range
+ * @pgd_entry: if set, called for each non-empty PGD (top-level) entry
+ * @pud_entry: if set, called for each non-empty PUD (2nd-level) entry
+ * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
+ * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
+ * @pte_hole: if set, called for each hole at all levels
+ *
+ * (see walk_page_range for more details)
+ */
+struct mm_walk {
+	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, void *);
+	int (*pud_entry)(pud_t *, unsigned long, unsigned long, void *);
+	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, void *);
+	int (*pte_entry)(pte_t *, unsigned long, unsigned long, void *);
+	int (*pte_hole)(unsigned long, unsigned long, void *);
+};
+
+int walk_page_range(const struct mm_struct *, unsigned long addr,
+		    unsigned long end, const struct mm_walk *walk,
+		    void *private);
 void free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *start_vma,
diff -puN mm/Makefile~maps4-introduce-a-generic-page-walker mm/Makefile
--- a/mm/Makefile~maps4-introduce-a-generic-page-walker
+++ a/mm/Makefile
@@ -5,7 +5,7 @@
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o
+			   vmalloc.o pagewalk.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   page_alloc.o page-writeback.o pdflush.o \
diff -puN /dev/null mm/pagewalk.c
--- /dev/null
+++ a/mm/pagewalk.c
@@ -0,0 +1,131 @@
+#include <linux/mm.h>
+#include <linux/highmem.h>
+#include <linux/sched.h>
+
+static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			  const struct mm_walk *walk, void *private)
+{
+	pte_t *pte;
+	int err = 0;
+
+	pte = pte_offset_map(pmd, addr);
+	do {
+		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, private);
+		if (err)
+		       break;
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+
+	pte_unmap(pte);
+	return err;
+}
+
+static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
+			  const struct mm_walk *walk, void *private)
+{
+	pmd_t *pmd;
+	unsigned long next;
+	int err = 0;
+
+	pmd = pmd_offset(pud, addr);
+	do {
+		next = pmd_addr_end(addr, end);
+		if (pmd_none_or_clear_bad(pmd)) {
+			if (walk->pte_hole)
+				err = walk->pte_hole(addr, next, private);
+			if (err)
+				break;
+			continue;
+		}
+		if (walk->pmd_entry)
+			err = walk->pmd_entry(pmd, addr, next, private);
+		if (!err && walk->pte_entry)
+			err = walk_pte_range(pmd, addr, next, walk, private);
+		if (err)
+			break;
+	} while (pmd++, addr = next, addr != end);
+
+	return err;
+}
+
+static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
+			  const struct mm_walk *walk, void *private)
+{
+	pud_t *pud;
+	unsigned long next;
+	int err = 0;
+
+	pud = pud_offset(pgd, addr);
+	do {
+		next = pud_addr_end(addr, end);
+		if (pud_none_or_clear_bad(pud)) {
+			if (walk->pte_hole)
+				err = walk->pte_hole(addr, next, private);
+			if (err)
+				break;
+			continue;
+		}
+		if (walk->pud_entry)
+			err = walk->pud_entry(pud, addr, next, private);
+		if (!err && (walk->pmd_entry || walk->pte_entry))
+			err = walk_pmd_range(pud, addr, next, walk, private);
+		if (err)
+			break;
+	} while (pud++, addr = next, addr != end);
+
+	return err;
+}
+
+/**
+ * walk_page_range - walk a memory map's page tables with a callback
+ * @mm - memory map to walk
+ * @addr - starting address
+ * @end - ending address
+ * @walk - set of callbacks to invoke for each level of the tree
+ * @private - private data passed to the callback function
+ *
+ * Recursively walk the page table for the memory area in a VMA,
+ * calling supplied callbacks. Callbacks are called in-order (first
+ * PGD, first PUD, first PMD, first PTE, second PTE... second PMD,
+ * etc.). If lower-level callbacks are omitted, walking depth is reduced.
+ *
+ * Each callback receives an entry pointer, the start and end of the
+ * associated range, and a caller-supplied private data pointer.
+ *
+ * No locks are taken, but the bottom level iterator will map PTE
+ * directories from highmem if necessary.
+ *
+ * If any callback returns a non-zero value, the walk is aborted and
+ * the return value is propagated back to the caller. Otherwise 0 is returned.
+ */
+int walk_page_range(const struct mm_struct *mm,
+		    unsigned long addr, unsigned long end,
+		    const struct mm_walk *walk, void *private)
+{
+	pgd_t *pgd;
+	unsigned long next;
+	int err = 0;
+
+	if (addr >= end)
+		return err;
+
+	pgd = pgd_offset(mm, addr);
+	do {
+		next = pgd_addr_end(addr, end);
+		if (pgd_none_or_clear_bad(pgd)) {
+			if (walk->pte_hole)
+				err = walk->pte_hole(addr, next, private);
+			if (err)
+				break;
+			continue;
+		}
+		if (walk->pgd_entry)
+			err = walk->pgd_entry(pgd, addr, next, private);
+		if (!err &&
+		    (walk->pud_entry || walk->pmd_entry || walk->pte_entry))
+			err = walk_pud_range(pgd, addr, next, walk, private);
+		if (err)
+			break;
+	} while (pgd++, addr = next, addr != end);
+
+	return err;
+}
_

Patches currently in -mm which might be from mpm@selenic.com are

maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-from-dave-hansen-haveblue-usibmcom.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
