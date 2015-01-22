From: akpm@linux-foundation.org
Subject: + smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch
 added to -mm tree
Date: Thu, 22 Jan 2015 15:31:14 -0800
Message-ID: <54c18842.f40lUYb9h9HXXoU9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbbAVXbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 18:31:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, benh@kernel.crashing.org, dave.hansen@intel.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: smaps: remove mem_size_stats->vma and use walk_page_vma()
has been added to the -mm tree.  Its filename is
     smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch

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
Subject: smaps: remove mem_size_stats->vma and use walk_page_vma()

pagewalk.c can handle vma in itself, so we don't have to pass vma via
walk->private.  And show_smap() walks pages on vma basis, so using
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

 fs/proc/task_mmu.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN fs/proc/task_mmu.c~smaps-remove-mem_size_stats-vma-and-use-walk_page_vma fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-remove-mem_size_stats-vma-and-use-walk_page_vma
+++ a/fs/proc/task_mmu.c
@@ -436,7 +436,6 @@ const struct file_operations proc_tid_ma
 
 #ifdef CONFIG_PROC_PAGE_MONITOR
 struct mem_size_stats {
-	struct vm_area_struct *vma;
 	unsigned long resident;
 	unsigned long shared_clean;
 	unsigned long shared_dirty;
@@ -485,7 +484,7 @@ static void smaps_pte_entry(pte_t *pte,
 		struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = mss->vma;
+	struct vm_area_struct *vma = walk->vma;
 	struct page *page = NULL;
 
 	if (pte_present(*pte)) {
@@ -509,7 +508,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 		struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = mss->vma;
+	struct vm_area_struct *vma = walk->vma;
 	struct page *page;
 
 	/* FOLL_DUMP will return -EFAULT on huge zero page */
@@ -530,8 +529,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			   struct mm_walk *walk)
 {
-	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = mss->vma;
+	struct vm_area_struct *vma = walk->vma;
 	pte_t *pte;
 	spinlock_t *ptl;
 
@@ -623,10 +621,8 @@ static int show_smap(struct seq_file *m,
 	};
 
 	memset(&mss, 0, sizeof mss);
-	mss.vma = vma;
 	/* mmap_sem is held in m_start */
-	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-		walk_page_range(vma->vm_start, vma->vm_end, &smaps_walk);
+	walk_page_vma(vma, &smaps_walk);
 
 	show_map_vma(m, vma, is_pid);
 
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

