From: akpm@linux-foundation.org
Subject: + pagemap-pass-mm-into-pagewalkers.patch added to -mm tree
Date: Wed, 11 Jun 2008 13:24:31 -0700
Message-ID: <200806112029.m5BKTOig016494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758781AbYFKU3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 16:29:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, mpm@selenic.com


The patch titled
     pagemap: pass mm into pagewalkers
has been added to the -mm tree.  Its filename is
     pagemap-pass-mm-into-pagewalkers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: pass mm into pagewalkers
From: Dave Hansen <dave@linux.vnet.ibm.com>

We need this at least for huge page detection for now, because powerpc
needs the vm_area_struct to be able to determine whether a virtual address
is referring to a huge page (its pmd_huge() doesn't work).

It might also come in handy for some of the other users.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   44 ++++++++++++++++++++++++-------------------
 include/linux/mm.h |   17 ++++++++--------
 mm/pagewalk.c      |   42 +++++++++++++++++++++--------------------
 3 files changed, 56 insertions(+), 47 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-pass-mm-into-pagewalkers fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-pass-mm-into-pagewalkers
+++ a/fs/proc/task_mmu.c
@@ -315,9 +315,9 @@ struct mem_size_stats {
 };
 
 static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
-			   void *private)
+			   struct mm_walk *walk)
 {
-	struct mem_size_stats *mss = private;
+	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = mss->vma;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
@@ -365,19 +365,21 @@ static int smaps_pte_range(pmd_t *pmd, u
 	return 0;
 }
 
-static struct mm_walk smaps_walk = { .pmd_entry = smaps_pte_range };
-
 static int show_smap(struct seq_file *m, void *v)
 {
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
 	int ret;
+	struct mm_walk smaps_walk = {
+		.pmd_entry = smaps_pte_range,
+		.mm = vma->vm_mm,
+		.private = &mss,
+	};
 
 	memset(&mss, 0, sizeof mss);
 	mss.vma = vma;
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-		walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
-				&smaps_walk, &mss);
+		walk_page_range(vma->vm_start, vma->vm_end, &smaps_walk);
 
 	ret = show_map(m, v);
 	if (ret)
@@ -426,9 +428,9 @@ const struct file_operations proc_smaps_
 };
 
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
-				unsigned long end, void *private)
+				unsigned long end, struct mm_walk *walk)
 {
-	struct vm_area_struct *vma = private;
+	struct vm_area_struct *vma = walk->private;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
@@ -452,8 +454,6 @@ static int clear_refs_pte_range(pmd_t *p
 	return 0;
 }
 
-static struct mm_walk clear_refs_walk = { .pmd_entry = clear_refs_pte_range };
-
 static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -476,11 +476,17 @@ static ssize_t clear_refs_write(struct f
 		return -ESRCH;
 	mm = get_task_mm(task);
 	if (mm) {
+		static struct mm_walk clear_refs_walk;
+		memset(&clear_refs_walk, 0, sizeof(clear_refs_walk));
+		clear_refs_walk.pmd_entry = clear_refs_pte_range;
+		clear_refs_walk.mm = mm;
 		down_read(&mm->mmap_sem);
-		for (vma = mm->mmap; vma; vma = vma->vm_next)
+		for (vma = mm->mmap; vma; vma = vma->vm_next) {
+			clear_refs_walk.private = vma;
 			if (!is_vm_hugetlb_page(vma))
-				walk_page_range(mm, vma->vm_start, vma->vm_end,
-						&clear_refs_walk, vma);
+				walk_page_range(vma->vm_start, vma->vm_end,
+						&clear_refs_walk);
+		}
 		flush_tlb_mm(mm);
 		up_read(&mm->mmap_sem);
 		mmput(mm);
@@ -528,9 +534,9 @@ static int add_to_pagemap(unsigned long 
 }
 
 static int pagemap_pte_hole(unsigned long start, unsigned long end,
-				void *private)
+				struct mm_walk *walk)
 {
-	struct pagemapread *pm = private;
+	struct pagemapread *pm = walk->private;
 	unsigned long addr;
 	int err = 0;
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
@@ -548,9 +554,9 @@ static u64 swap_pte_to_pagemap_entry(pte
 }
 
 static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
-			     void *private)
+			     struct mm_walk *walk)
 {
-	struct pagemapread *pm = private;
+	struct pagemapread *pm = walk->private;
 	pte_t *pte;
 	int err = 0;
 
@@ -675,8 +681,8 @@ static ssize_t pagemap_read(struct file 
 		 * user buffer is tracked in "pm", and the walk
 		 * will stop when we hit the end of the buffer.
 		 */
-		ret = walk_page_range(mm, start_vaddr, end_vaddr,
-					&pagemap_walk, &pm);
+		ret = walk_page_range(start_vaddr, end_vaddr,
+					&pagemap_walk);
 		if (ret == PM_END_OF_BUFFER)
 			ret = 0;
 		/* don't need mmap_sem for these, but this looks cleaner */
diff -puN include/linux/mm.h~pagemap-pass-mm-into-pagewalkers include/linux/mm.h
--- a/include/linux/mm.h~pagemap-pass-mm-into-pagewalkers
+++ a/include/linux/mm.h
@@ -760,16 +760,17 @@ unsigned long unmap_vmas(struct mmu_gath
  * (see walk_page_range for more details)
  */
 struct mm_walk {
-	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, void *);
-	int (*pud_entry)(pud_t *, unsigned long, unsigned long, void *);
-	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, void *);
-	int (*pte_entry)(pte_t *, unsigned long, unsigned long, void *);
-	int (*pte_hole)(unsigned long, unsigned long, void *);
+	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, struct mm_walk *);
+	int (*pud_entry)(pud_t *, unsigned long, unsigned long, struct mm_walk *);
+	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, struct mm_walk *);
+	int (*pte_entry)(pte_t *, unsigned long, unsigned long, struct mm_walk *);
+	int (*pte_hole)(unsigned long, unsigned long, struct mm_walk *);
+	struct mm_struct *mm;
+	void *private;
 };
 
-int walk_page_range(const struct mm_struct *, unsigned long addr,
-		    unsigned long end, const struct mm_walk *walk,
-		    void *private);
+int walk_page_range(unsigned long addr, unsigned long end,
+		struct mm_walk *walk);
 void free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *start_vma,
diff -puN mm/pagewalk.c~pagemap-pass-mm-into-pagewalkers mm/pagewalk.c
--- a/mm/pagewalk.c~pagemap-pass-mm-into-pagewalkers
+++ a/mm/pagewalk.c
@@ -3,14 +3,14 @@
 #include <linux/sched.h>
 
 static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
-			  const struct mm_walk *walk, void *private)
+			  struct mm_walk *walk)
 {
 	pte_t *pte;
 	int err = 0;
 
 	pte = pte_offset_map(pmd, addr);
 	for (;;) {
-		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, private);
+		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, walk);
 		if (err)
 		       break;
 		addr += PAGE_SIZE;
@@ -24,7 +24,7 @@ static int walk_pte_range(pmd_t *pmd, un
 }
 
 static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
-			  const struct mm_walk *walk, void *private)
+			  struct mm_walk *walk)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -35,15 +35,15 @@ static int walk_pmd_range(pud_t *pud, un
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_clear_bad(pmd)) {
 			if (walk->pte_hole)
-				err = walk->pte_hole(addr, next, private);
+				err = walk->pte_hole(addr, next, walk);
 			if (err)
 				break;
 			continue;
 		}
 		if (walk->pmd_entry)
-			err = walk->pmd_entry(pmd, addr, next, private);
+			err = walk->pmd_entry(pmd, addr, next, walk);
 		if (!err && walk->pte_entry)
-			err = walk_pte_range(pmd, addr, next, walk, private);
+			err = walk_pte_range(pmd, addr, next, walk);
 		if (err)
 			break;
 	} while (pmd++, addr = next, addr != end);
@@ -52,7 +52,7 @@ static int walk_pmd_range(pud_t *pud, un
 }
 
 static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
-			  const struct mm_walk *walk, void *private)
+			  struct mm_walk *walk)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -63,15 +63,15 @@ static int walk_pud_range(pgd_t *pgd, un
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud)) {
 			if (walk->pte_hole)
-				err = walk->pte_hole(addr, next, private);
+				err = walk->pte_hole(addr, next, walk);
 			if (err)
 				break;
 			continue;
 		}
 		if (walk->pud_entry)
-			err = walk->pud_entry(pud, addr, next, private);
+			err = walk->pud_entry(pud, addr, next, walk);
 		if (!err && (walk->pmd_entry || walk->pte_entry))
-			err = walk_pmd_range(pud, addr, next, walk, private);
+			err = walk_pmd_range(pud, addr, next, walk);
 		if (err)
 			break;
 	} while (pud++, addr = next, addr != end);
@@ -85,15 +85,15 @@ static int walk_pud_range(pgd_t *pgd, un
  * @addr: starting address
  * @end: ending address
  * @walk: set of callbacks to invoke for each level of the tree
- * @private: private data passed to the callback function
  *
  * Recursively walk the page table for the memory area in a VMA,
  * calling supplied callbacks. Callbacks are called in-order (first
  * PGD, first PUD, first PMD, first PTE, second PTE... second PMD,
  * etc.). If lower-level callbacks are omitted, walking depth is reduced.
  *
- * Each callback receives an entry pointer, the start and end of the
- * associated range, and a caller-supplied private data pointer.
+ * Each callback receives an entry pointer and the start and end of the
+ * associated range, and a copy of the original mm_walk for access to
+ * the ->private or ->mm fields.
  *
  * No locks are taken, but the bottom level iterator will map PTE
  * directories from highmem if necessary.
@@ -101,9 +101,8 @@ static int walk_pud_range(pgd_t *pgd, un
  * If any callback returns a non-zero value, the walk is aborted and
  * the return value is propagated back to the caller. Otherwise 0 is returned.
  */
-int walk_page_range(const struct mm_struct *mm,
-		    unsigned long addr, unsigned long end,
-		    const struct mm_walk *walk, void *private)
+int walk_page_range(unsigned long addr, unsigned long end,
+		    struct mm_walk *walk)
 {
 	pgd_t *pgd;
 	unsigned long next;
@@ -112,21 +111,24 @@ int walk_page_range(const struct mm_stru
 	if (addr >= end)
 		return err;
 
-	pgd = pgd_offset(mm, addr);
+	if (!walk->mm)
+		return -EINVAL;
+
+	pgd = pgd_offset(walk->mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd)) {
 			if (walk->pte_hole)
-				err = walk->pte_hole(addr, next, private);
+				err = walk->pte_hole(addr, next, walk);
 			if (err)
 				break;
 			continue;
 		}
 		if (walk->pgd_entry)
-			err = walk->pgd_entry(pgd, addr, next, private);
+			err = walk->pgd_entry(pgd, addr, next, walk);
 		if (!err &&
 		    (walk->pud_entry || walk->pmd_entry || walk->pte_entry))
-			err = walk_pud_range(pgd, addr, next, walk, private);
+			err = walk_pud_range(pgd, addr, next, walk);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

pagemap-pass-mm-into-pagewalkers.patch
pagemap-fix-large-pages-in-pagemap.patch

