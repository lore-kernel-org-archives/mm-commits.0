From: akpm@linux-foundation.org
Subject: + pagemap-fix-pfn-calculation-for-hugepage-v3.patch added to -mm tree
Date: Fri, 26 Mar 2010 14:34:05 -0700
Message-ID: <201003262134.o2QLY67u021860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991Ab0CZVeN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 17:34:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, kamezawa.hiroyu@jp.fujitsu.com, mpm@selenic.com


The patch titled
     pagemap: fix pfn calculation for hugepage
has been added to the -mm tree.  Its filename is
     pagemap-fix-pfn-calculation-for-hugepage-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: fix pfn calculation for hugepage
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

When we look into pagemap using page-types with option -p, the value of
pfn for hugepages looks wrong (see below.) This is because pte was
evaluated only once for one vma although it should be updated for each
hugepage.  This patch fixes it.

  $ page-types -p 3277 -Nl -b huge
  voffset   offset  len     flags
  7f21e8a00 11e400  1       ___U___________H_G________________
  7f21e8a01 11e401  1ff     ________________TG________________
               ^^^
  7f21e8c00 11e400  1       ___U___________H_G________________
  7f21e8c01 11e401  1ff     ________________TG________________
               ^^^

One hugepage contains 1 head page and 511 tail pages in x86_64 and each
two lines represent each hugepage.  Voffset and offset mean virtual
address and physical address in the page unit, respectively.  The
different hugepages should not have the same offset value.

With this patch applied:

  $ page-types -p 3386 -Nl -b huge
  voffset   offset   len    flags
  7fec7a600 112c00   1      ___UD__________H_G________________
  7fec7a601 112c01   1ff    ________________TG________________
               ^^^
  7fec7a800 113200   1      ___UD__________H_G________________
  7fec7a801 113201   1ff    ________________TG________________
               ^^^
               OK

More info:

- This patch modifies walk_page_range()'s hugepage walker.  But the
  change only affects pagemap_read(), which is the only caller of hugepage
  callback.

- Without this patch, hugetlb_entry() callback is called per vma, that
  doesn't match the natural expectation from its name.

- With this patch, hugetlb_entry() is called per hugepte entry and the
  callback can become much simpler.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   27 ++++++------------------
 include/linux/mm.h |    4 +--
 mm/pagewalk.c      |   47 +++++++++++++++++++++++++++++++++----------
 3 files changed, 46 insertions(+), 32 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-fix-pfn-calculation-for-hugepage-v3 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-fix-pfn-calculation-for-hugepage-v3
+++ a/fs/proc/task_mmu.c
@@ -661,31 +661,18 @@ static u64 huge_pte_to_pagemap_entry(pte
 	return pme;
 }
 
-static int pagemap_hugetlb_range(pte_t *pte, unsigned long addr,
-				 unsigned long end, struct mm_walk *walk)
+/* This function walks within one hugetlb entry in the single call */
+static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
+				 unsigned long addr, unsigned long end,
+				 struct mm_walk *walk)
 {
-	struct vm_area_struct *vma;
 	struct pagemapread *pm = walk->private;
-	struct hstate *hs = NULL;
 	int err = 0;
+	u64 pfn;
 
-	vma = find_vma(walk->mm, addr);
-	if (vma)
-		hs = hstate_vma(vma);
 	for (; addr != end; addr += PAGE_SIZE) {
-		u64 pfn = PM_NOT_PRESENT;
-
-		if (vma && (addr >= vma->vm_end)) {
-			vma = find_vma(walk->mm, addr);
-			if (vma)
-				hs = hstate_vma(vma);
-		}
-
-		if (vma && (vma->vm_start <= addr) && is_vm_hugetlb_page(vma)) {
-			/* calculate pfn of the "raw" page in the hugepage. */
-			int offset = (addr & ~huge_page_mask(hs)) >> PAGE_SHIFT;
-			pfn = huge_pte_to_pagemap_entry(*pte, offset);
-		}
+		int offset = (addr & ~hmask) >> PAGE_SHIFT;
+		pfn = huge_pte_to_pagemap_entry(*pte, offset);
 		err = add_to_pagemap(addr, pfn, pm);
 		if (err)
 			return err;
diff -puN include/linux/mm.h~pagemap-fix-pfn-calculation-for-hugepage-v3 include/linux/mm.h
--- a/include/linux/mm.h~pagemap-fix-pfn-calculation-for-hugepage-v3
+++ a/include/linux/mm.h
@@ -783,8 +783,8 @@ struct mm_walk {
 	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, struct mm_walk *);
 	int (*pte_entry)(pte_t *, unsigned long, unsigned long, struct mm_walk *);
 	int (*pte_hole)(unsigned long, unsigned long, struct mm_walk *);
-	int (*hugetlb_entry)(pte_t *, unsigned long, unsigned long,
-			     struct mm_walk *);
+	int (*hugetlb_entry)(pte_t *, unsigned long,
+			     unsigned long, unsigned long, struct mm_walk *);
 	struct mm_struct *mm;
 	void *private;
 };
diff -puN mm/pagewalk.c~pagemap-fix-pfn-calculation-for-hugepage-v3 mm/pagewalk.c
--- a/mm/pagewalk.c~pagemap-fix-pfn-calculation-for-hugepage-v3
+++ a/mm/pagewalk.c
@@ -80,6 +80,37 @@ static int walk_pud_range(pgd_t *pgd, un
 	return err;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
+				       unsigned long end)
+{
+	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
+	return boundary < end ? boundary : end;
+}
+
+static int walk_hugetlb_range(struct vm_area_struct *vma,
+			      unsigned long addr, unsigned long end,
+			      struct mm_walk *walk)
+{
+	struct hstate *h = hstate_vma(vma);
+	unsigned long next;
+	unsigned long hmask = huge_page_mask(h);
+	pte_t *pte;
+	int err = 0;
+
+	do {
+		next = hugetlb_entry_end(h, addr, end);
+		pte = huge_pte_offset(walk->mm, addr & hmask);
+		if (pte && walk->hugetlb_entry)
+			err = walk->hugetlb_entry(pte, hmask, addr, next, walk);
+		if (err)
+			return err;
+	} while (addr = next, addr != end);
+
+	return 0;
+}
+#endif
+
 /**
  * walk_page_range - walk a memory map's page tables with a callback
  * @mm: memory map to walk
@@ -128,20 +159,16 @@ int walk_page_range(unsigned long addr, 
 		vma = find_vma(walk->mm, addr);
 #ifdef CONFIG_HUGETLB_PAGE
 		if (vma && is_vm_hugetlb_page(vma)) {
-			pte_t *pte;
-			struct hstate *hs;
-
 			if (vma->vm_end < next)
 				next = vma->vm_end;
-			hs = hstate_vma(vma);
-			pte = huge_pte_offset(walk->mm,
-					      addr & huge_page_mask(hs));
-			if (pte && !huge_pte_none(huge_ptep_get(pte))
-			    && walk->hugetlb_entry)
-				err = walk->hugetlb_entry(pte, addr,
-							  next, walk);
+			/*
+			 * Hugepage is very tightly coupled with vma, so
+			 * walk through hugetlb entries within a given vma.
+			 */
+			err = walk_hugetlb_range(vma, addr, next, walk);
 			if (err)
 				break;
+			pgd = pgd_offset(walk->mm, next);
 			continue;
 		}
 #endif
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

pagemap-fix-pfn-calculation-for-hugepage-v3.patch
mincore-cleanups.patch
mincore-break-do_mincore-into-logical-pieces.patch
mincore-pass-ranges-as-startend-address-pairs.patch
mincore-do-nested-page-table-walks.patch
pagemap-add-ifdefs-config_hugetlb_page-on-code-walking-hugetlb-vma.patch

