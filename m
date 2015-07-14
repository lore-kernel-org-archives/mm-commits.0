From: akpm@linux-foundation.org
Subject: + pagemap-rework-hugetlb-and-thp-report.patch added to -mm tree
Date: Tue, 14 Jul 2015 11:57:55 -0700
Message-ID: <55a55bb3.ULvKI/GhZ8pJ6d0e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbbGNS54 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 14:57:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, mwilliamson@undo-software.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: rework hugetlb and thp report
has been added to the -mm tree.  Its filename is
     pagemap-rework-hugetlb-and-thp-report.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pagemap-rework-hugetlb-and-thp-report.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pagemap-rework-hugetlb-and-thp-report.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: pagemap: rework hugetlb and thp report

This patch moves pmd dissection out of reporting loop: huge pages are
reported as bunch of normal pages with contiguous PFNs.

Add missing "FILE" bit in hugetlb vmas.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mark Williamson <mwilliamson@undo-software.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |  100 ++++++++++++++++++-------------------------
 1 file changed, 44 insertions(+), 56 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-rework-hugetlb-and-thp-report fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-rework-hugetlb-and-thp-report
+++ a/fs/proc/task_mmu.c
@@ -1041,33 +1041,7 @@ static pagemap_entry_t pte_to_pagemap_en
 	return make_pme(frame, flags);
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static pagemap_entry_t thp_pmd_to_pagemap_entry(struct pagemapread *pm,
-		pmd_t pmd, int offset, u64 flags)
-{
-	u64 frame = 0;
-
-	/*
-	 * Currently pmd for thp is always present because thp can not be
-	 * swapped-out, migrated, or HWPOISONed (split in such cases instead.)
-	 * This if-check is just to prepare for future implementation.
-	 */
-	if (pmd_present(pmd)) {
-		frame = pmd_pfn(pmd) + offset;
-		flags |= PM_PRESENT;
-	}
-
-	return make_pme(frame, flags);
-}
-#else
-static pagemap_entry_t thp_pmd_to_pagemap_entry(struct pagemapread *pm,
-		pmd_t pmd, int offset, u64 flags)
-{
-	return make_pme(0, 0);
-}
-#endif
-
-static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			     struct mm_walk *walk)
 {
 	struct vm_area_struct *vma = walk->vma;
@@ -1076,35 +1050,48 @@ static int pagemap_pte_range(pmd_t *pmd,
 	pte_t *pte, *orig_pte;
 	int err = 0;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
-		u64 flags = 0;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (pmd_trans_huge_lock(pmdp, vma, &ptl) == 1) {
+		u64 flags = 0, frame = 0;
+		pmd_t pmd = *pmdp;
 
-		if ((vma->vm_flags & VM_SOFTDIRTY) || pmd_soft_dirty(*pmd))
+		if ((vma->vm_flags & VM_SOFTDIRTY) || pmd_soft_dirty(pmd))
 			flags |= PM_SOFT_DIRTY;
 
+		/*
+		 * Currently pmd for thp is always present because thp
+		 * can not be swapped-out, migrated, or HWPOISONed
+		 * (split in such cases instead.)
+		 * This if-check is just to prepare for future implementation.
+		 */
+		if (pmd_present(pmd)) {
+			flags |= PM_PRESENT;
+			frame = pmd_pfn(pmd) +
+				((addr & ~PMD_MASK) >> PAGE_SHIFT);
+		}
+
 		for (; addr != end; addr += PAGE_SIZE) {
-			unsigned long offset;
-			pagemap_entry_t pme;
+			pagemap_entry_t pme = make_pme(frame, flags);
 
-			offset = (addr & ~PAGEMAP_WALK_MASK) >>
-					PAGE_SHIFT;
-			pme = thp_pmd_to_pagemap_entry(pm, *pmd, offset, flags);
 			err = add_to_pagemap(addr, &pme, pm);
 			if (err)
 				break;
+			if (flags & PM_PRESENT)
+				frame++;
 		}
 		spin_unlock(ptl);
 		return err;
 	}
 
-	if (pmd_trans_unstable(pmd))
+	if (pmd_trans_unstable(pmdp))
 		return 0;
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	/*
 	 * We can assume that @vma always points to a valid one and @end never
 	 * goes beyond vma->vm_end.
 	 */
-	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	orig_pte = pte = pte_offset_map_lock(walk->mm, pmdp, addr, &ptl);
 	for (; addr < end; pte++, addr += PAGE_SIZE) {
 		pagemap_entry_t pme;
 
@@ -1121,39 +1108,40 @@ static int pagemap_pte_range(pmd_t *pmd,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static pagemap_entry_t huge_pte_to_pagemap_entry(struct pagemapread *pm,
-					pte_t pte, int offset, u64 flags)
-{
-	u64 frame = 0;
-
-	if (pte_present(pte)) {
-		frame = pte_pfn(pte) + offset;
-		flags |= PM_PRESENT;
-	}
-
-	return make_pme(frame, flags);
-}
-
 /* This function walks within one hugetlb entry in the single call */
-static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
+static int pagemap_hugetlb_range(pte_t *ptep, unsigned long hmask,
 				 unsigned long addr, unsigned long end,
 				 struct mm_walk *walk)
 {
 	struct pagemapread *pm = walk->private;
 	struct vm_area_struct *vma = walk->vma;
+	u64 flags = 0, frame = 0;
 	int err = 0;
-	u64 flags = 0;
-	pagemap_entry_t pme;
+	pte_t pte;
 
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
 
+	pte = huge_ptep_get(ptep);
+	if (pte_present(pte)) {
+		struct page *page = pte_page(pte);
+
+		if (!PageAnon(page))
+			flags |= PM_FILE;
+
+		flags |= PM_PRESENT;
+		frame = pte_pfn(pte) +
+			((addr & ~hmask) >> PAGE_SHIFT);
+	}
+
 	for (; addr != end; addr += PAGE_SIZE) {
-		int offset = (addr & ~hmask) >> PAGE_SHIFT;
-		pme = huge_pte_to_pagemap_entry(pm, *pte, offset, flags);
+		pagemap_entry_t pme = make_pme(frame, flags);
+
 		err = add_to_pagemap(addr, &pme, pm);
 		if (err)
 			return err;
+		if (flags & PM_PRESENT)
+			frame++;
 	}
 
 	cond_resched();
@@ -1217,7 +1205,7 @@ static ssize_t pagemap_read(struct file
 	if (!pm.buffer)
 		goto out_mm;
 
-	pagemap_walk.pmd_entry = pagemap_pte_range;
+	pagemap_walk.pmd_entry = pagemap_pmd_range;
 	pagemap_walk.pte_hole = pagemap_pte_hole;
 #ifdef CONFIG_HUGETLB_PAGE
 	pagemap_walk.hugetlb_entry = pagemap_hugetlb_range;
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

pagemap-check-permissions-and-capabilities-at-open-time.patch
pagemap-switch-to-the-new-format-and-do-some-cleanup.patch
pagemap-rework-hugetlb-and-thp-report.patch
pagemap-hide-physical-addresses-from-non-privileged-users.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch

