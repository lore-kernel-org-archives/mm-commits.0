From: akpm@linux-foundation.org
Subject: + mm-hugetlb-add-hugepage-support-to-pagemap.patch added to -mm tree
Date: Tue, 08 Dec 2009 14:39:44 -0800
Message-ID: <200912082239.nB8Mdi0Q019687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966565AbZLHWkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 17:40:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, apw@canonical.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     mm hugetlb: add hugepage support to pagemap
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-hugepage-support-to-pagemap.patch

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
Subject: mm hugetlb: add hugepage support to pagemap
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Enable extraction of the pfn of the hugepage from /proc/pid/pagemap in an
architecture independent manner.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h |    3 +++
 mm/pagewalk.c      |   18 ++++++++++++++++--
 3 files changed, 62 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-hugetlb-add-hugepage-support-to-pagemap fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-hugetlb-add-hugepage-support-to-pagemap
+++ a/fs/proc/task_mmu.c
@@ -650,6 +650,48 @@ static int pagemap_pte_range(pmd_t *pmd,
 	return err;
 }
 
+static u64 huge_pte_to_pagemap_entry(pte_t pte, int offset)
+{
+	u64 pme = 0;
+	if (pte_present(pte))
+		pme = PM_PFRAME(pte_pfn(pte) + offset)
+			| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT;
+	return pme;
+}
+
+static int pagemap_hugetlb_range(pte_t *pte, unsigned long addr,
+				 unsigned long end, struct mm_walk *walk)
+{
+	struct vm_area_struct *vma;
+	struct pagemapread *pm = walk->private;
+	struct hstate *hs = NULL;
+	int err = 0;
+
+	vma = find_vma(walk->mm, addr);
+	hs = hstate_vma(vma);
+	for (; addr != end; addr += PAGE_SIZE) {
+		u64 pfn = PM_NOT_PRESENT;
+
+		if (vma && (addr >= vma->vm_end)) {
+			vma = find_vma(walk->mm, addr);
+			hs = hstate_vma(vma);
+		}
+
+		if (vma && (vma->vm_start <= addr) && is_vm_hugetlb_page(vma)) {
+			/* calculate pfn of the "raw" page in the hugepage. */
+			int offset = (addr & ~huge_page_mask(hs)) >> PAGE_SHIFT;
+			pfn = huge_pte_to_pagemap_entry(*pte, offset);
+		}
+		err = add_to_pagemap(addr, pfn, pm);
+		if (err)
+			return err;
+	}
+
+	cond_resched();
+
+	return err;
+}
+
 /*
  * /proc/pid/pagemap - an array mapping virtual pages to pfns
  *
@@ -742,6 +784,7 @@ static ssize_t pagemap_read(struct file 
 
 	pagemap_walk.pmd_entry = pagemap_pte_range;
 	pagemap_walk.pte_hole = pagemap_pte_hole;
+	pagemap_walk.hugetlb_entry = pagemap_hugetlb_range;
 	pagemap_walk.mm = mm;
 	pagemap_walk.private = &pm;
 
diff -puN include/linux/mm.h~mm-hugetlb-add-hugepage-support-to-pagemap include/linux/mm.h
--- a/include/linux/mm.h~mm-hugetlb-add-hugepage-support-to-pagemap
+++ a/include/linux/mm.h
@@ -770,6 +770,7 @@ unsigned long unmap_vmas(struct mmu_gath
  * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
  * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
  * @pte_hole: if set, called for each hole at all levels
+ * @hugetlb_entry: if set, called for each hugetlb entry
  *
  * (see walk_page_range for more details)
  */
@@ -779,6 +780,8 @@ struct mm_walk {
 	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, struct mm_walk *);
 	int (*pte_entry)(pte_t *, unsigned long, unsigned long, struct mm_walk *);
 	int (*pte_hole)(unsigned long, unsigned long, struct mm_walk *);
+	int (*hugetlb_entry)(pte_t *, unsigned long, unsigned long,
+			     struct mm_walk *);
 	struct mm_struct *mm;
 	void *private;
 };
diff -puN mm/pagewalk.c~mm-hugetlb-add-hugepage-support-to-pagemap mm/pagewalk.c
--- a/mm/pagewalk.c~mm-hugetlb-add-hugepage-support-to-pagemap
+++ a/mm/pagewalk.c
@@ -106,9 +106,11 @@ int walk_page_range(unsigned long addr, 
 		    struct mm_walk *walk)
 {
 	pgd_t *pgd;
+	pte_t *pte;
 	unsigned long next;
 	int err = 0;
 	struct vm_area_struct *vma;
+	struct hstate *hs;
 
 	if (addr >= end)
 		return err;
@@ -120,11 +122,23 @@ int walk_page_range(unsigned long addr, 
 	do {
 		next = pgd_addr_end(addr, end);
 
-		/* skip hugetlb vma to avoid hugepage PMD being cleared
-		 * in pmd_none_or_clear_bad(). */
+		/*
+		 * handle hugetlb vma individually because pagetable walk for
+		 * the hugetlb page is dependent on the architecture and
+		 * we can't handled it in the same manner as non-huge pages.
+		 */
 		vma = find_vma(walk->mm, addr);
 		if (is_vm_hugetlb_page(vma)) {
 			next = (vma->vm_end < next) ? vma->vm_end : next;
+			hs = hstate_vma(vma);
+			pte = huge_pte_offset(walk->mm,
+					      addr & huge_page_mask(hs));
+			if (pte && !huge_pte_none(huge_ptep_get(pte))
+			    && walk->hugetlb_entry)
+				err = walk->hugetlb_entry(pte, addr,
+							  next, walk);
+			if (err)
+				break;
 			continue;
 		}
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch

