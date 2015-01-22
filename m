From: akpm@linux-foundation.org
Subject: + numa_maps-remove-numa_maps-vma.patch added to -mm tree
Date: Thu, 22 Jan 2015 15:31:22 -0800
Message-ID: <54c1884a.16sSGslFLOHIsfw/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbbAVXbX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 18:31:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, benh@kernel.crashing.org, dave.hansen@intel.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: numa_maps: remove numa_maps->vma
has been added to the -mm tree.  Its filename is
     numa_maps-remove-numa_maps-vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/numa_maps-remove-numa_maps-vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/numa_maps-remove-numa_maps-vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: numa_maps: remove numa_maps->vma

pagewalk.c can handle vma in itself, so we don't have to pass vma via
walk->private.  And show_numa_map() walks pages on vma basis, so using
walk_page_vma() is preferable.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff -puN fs/proc/task_mmu.c~numa_maps-remove-numa_maps-vma fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~numa_maps-remove-numa_maps-vma
+++ a/fs/proc/task_mmu.c
@@ -1285,7 +1285,6 @@ const struct file_operations proc_pagema
 #ifdef CONFIG_NUMA
 
 struct numa_maps {
-	struct vm_area_struct *vma;
 	unsigned long pages;
 	unsigned long anon;
 	unsigned long active;
@@ -1354,18 +1353,17 @@ static struct page *can_gather_numa_stat
 static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 		unsigned long end, struct mm_walk *walk)
 {
-	struct numa_maps *md;
+	struct numa_maps *md = walk->private;
+	struct vm_area_struct *vma = walk->vma;
 	spinlock_t *ptl;
 	pte_t *orig_pte;
 	pte_t *pte;
 
-	md = walk->private;
-
-	if (pmd_trans_huge_lock(pmd, md->vma, &ptl) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		pte_t huge_pte = *(pte_t *)pmd;
 		struct page *page;
 
-		page = can_gather_numa_stats(huge_pte, md->vma, addr);
+		page = can_gather_numa_stats(huge_pte, vma, addr);
 		if (page)
 			gather_stats(page, md, pte_dirty(huge_pte),
 				     HPAGE_PMD_SIZE/PAGE_SIZE);
@@ -1377,7 +1375,7 @@ static int gather_pte_stats(pmd_t *pmd,
 		return 0;
 	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	do {
-		struct page *page = can_gather_numa_stats(*pte, md->vma, addr);
+		struct page *page = can_gather_numa_stats(*pte, vma, addr);
 		if (!page)
 			continue;
 		gather_stats(page, md, pte_dirty(*pte), 1);
@@ -1424,7 +1422,12 @@ static int show_numa_map(struct seq_file
 	struct numa_maps *md = &numa_priv->md;
 	struct file *file = vma->vm_file;
 	struct mm_struct *mm = vma->vm_mm;
-	struct mm_walk walk = {};
+	struct mm_walk walk = {
+		.hugetlb_entry = gather_hugetlb_stats,
+		.pmd_entry = gather_pte_stats,
+		.private = md,
+		.mm = mm,
+	};
 	struct mempolicy *pol;
 	char buffer[64];
 	int nid;
@@ -1435,13 +1438,6 @@ static int show_numa_map(struct seq_file
 	/* Ensure we start with an empty set of numa_maps statistics. */
 	memset(md, 0, sizeof(*md));
 
-	md->vma = vma;
-
-	walk.hugetlb_entry = gather_hugetlb_stats;
-	walk.pmd_entry = gather_pte_stats;
-	walk.private = md;
-	walk.mm = mm;
-
 	pol = __get_vma_policy(vma, vma->vm_start);
 	if (pol) {
 		mpol_to_str(buffer, sizeof(buffer), pol);
@@ -1475,7 +1471,8 @@ static int show_numa_map(struct seq_file
 	if (is_vm_hugetlb_page(vma))
 		seq_puts(m, " huge");
 
-	walk_page_range(vma->vm_start, vma->vm_end, &walk);
+	/* mmap_sem is held by m_start */
+	walk_page_vma(vma, &walk);
 
 	if (!md->pages)
 		goto out;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch
mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
revert-mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch
pagewalk-improve-vma-handling.patch
pagewalk-add-walk_page_vma.patch
smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch
clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk.patch
pagemap-use-walk-vma-instead-of-calling-find_vma.patch
numa_maps-fix-typo-in-gather_hugetbl_stats.patch
numa_maps-remove-numa_maps-vma.patch
memcg-cleanup-preparation-for-page-table-walk.patch
arch-powerpc-mm-subpage-protc-use-walk-vma-and-walk_page_vma.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-proc-pid-clear_refs-avoid-split_huge_page.patch
mincore-apply-page-table-walker-on-do_mincore.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

