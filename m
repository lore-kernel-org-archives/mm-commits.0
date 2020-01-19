From: akpm@linux-foundation.org
Subject: +
 mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch
 added to -mm tree
Date: Sat, 18 Jan 2020 16:07:09 -0800
Message-ID: <20200119000709.HRUsr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbgASAHK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 18 Jan 2020 19:07:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com, thellstrom@vmware.com, kirill@shutemov.name, dan.j.williams@intel.com, aneesh.kumar@linux.ibm.com, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/mremap: it is sure to have enough space when extent meets requirement
has been added to the -mm tree.  Its filename is
     mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/mremap: it is sure to have enough space when extent meets requirement

old_end is passed to these two function to check whether there is enough
space to do the move, while this check is done before invoking these
functions.

These two functions only would be invoked when extent meets the
requirement and there is one check before invoking these functions:

    if (extent > old_end - old_addr)
        extent = old_end - old_addr;

This implies (old_end - old_addr) won't fail the check in these two
functions.

Link: http://lkml.kernel.org/r/20200117232254.2792-3-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 +-
 mm/huge_memory.c        |    7 ++-----
 mm/mremap.c             |   11 ++++-------
 3 files changed, 7 insertions(+), 13 deletions(-)

--- a/include/linux/huge_mm.h~mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement
+++ a/include/linux/huge_mm.h
@@ -42,7 +42,7 @@ extern int mincore_huge_pmd(struct vm_ar
 			unsigned long addr, unsigned long end,
 			unsigned char *vec);
 extern bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
-			 unsigned long new_addr, unsigned long old_end,
+			 unsigned long new_addr,
 			 pmd_t *old_pmd, pmd_t *new_pmd);
 extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, pgprot_t newprot,
--- a/mm/huge_memory.c~mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement
+++ a/mm/huge_memory.c
@@ -1871,17 +1871,14 @@ static pmd_t move_soft_dirty_pmd(pmd_t p
 }
 
 bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
-		  unsigned long new_addr, unsigned long old_end,
-		  pmd_t *old_pmd, pmd_t *new_pmd)
+		  unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd)
 {
 	spinlock_t *old_ptl, *new_ptl;
 	pmd_t pmd;
 	struct mm_struct *mm = vma->vm_mm;
 	bool force_flush = false;
 
-	if ((old_addr & ~HPAGE_PMD_MASK) ||
-	    (new_addr & ~HPAGE_PMD_MASK) ||
-	    old_end - old_addr < HPAGE_PMD_SIZE)
+	if ((old_addr & ~HPAGE_PMD_MASK) || (new_addr & ~HPAGE_PMD_MASK))
 		return false;
 
 	/*
--- a/mm/mremap.c~mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement
+++ a/mm/mremap.c
@@ -193,16 +193,13 @@ static void move_ptes(struct vm_area_str
 
 #ifdef CONFIG_HAVE_MOVE_PMD
 static bool move_normal_pmd(struct vm_area_struct *vma, unsigned long old_addr,
-		  unsigned long new_addr, unsigned long old_end,
-		  pmd_t *old_pmd, pmd_t *new_pmd)
+		  unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd)
 {
 	spinlock_t *old_ptl, *new_ptl;
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmd;
 
-	if ((old_addr & ~PMD_MASK) ||
-	    (new_addr & ~PMD_MASK) ||
-	    old_end - old_addr < PMD_SIZE)
+	if ((old_addr & ~PMD_MASK) || (new_addr & ~PMD_MASK))
 		return false;
 
 	/*
@@ -274,7 +271,7 @@ unsigned long move_page_tables(struct vm
 				if (need_rmap_locks)
 					take_rmap_locks(vma);
 				moved = move_huge_pmd(vma, old_addr, new_addr,
-						    old_end, old_pmd, new_pmd);
+						      old_pmd, new_pmd);
 				if (need_rmap_locks)
 					drop_rmap_locks(vma);
 				if (moved)
@@ -294,7 +291,7 @@ unsigned long move_page_tables(struct vm
 			if (need_rmap_locks)
 				take_rmap_locks(vma);
 			moved = move_normal_pmd(vma, old_addr, new_addr,
-					old_end, old_pmd, new_pmd);
+						old_pmd, new_pmd);
 			if (need_rmap_locks)
 				drop_rmap_locks(vma);
 			if (moved)
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are

mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch
mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge.patch
mm-mremap-format-the-check-in-move_normal_pmd-same-as-move_huge_pmd.patch
mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch
mm-mremap-use-pmd_addr_end-to-calculate-next-in-move_page_tables.patch
mm-mremap-calculate-extent-in-one-place.patch
mm-mremap-start-addresses-are-properly-aligned.patch
mm-huge_memoryc-use-head-to-check-huge-zero-page.patch
mm-huge_memoryc-use-head-to-emphasize-the-purpose-of-page.patch
mm-huge_memoryc-reduce-critical-section-protected-by-split_queue_lock.patch
mm-remove-dead-code-totalram_pages_set.patch
