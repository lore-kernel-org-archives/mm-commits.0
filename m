From: akpm@linux-foundation.org
Subject: [merged] mm-remove-obsolete-comments-about-page-table-lock.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:37:51 -0800
Message-ID: <5283e31f.vdXZF9hNscsxX5Ki%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3KMUhv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-remove-obsolete-comments-about-page-table-lock.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:51 -0800


The patch titled
     Subject: mm: remove obsolete comments about page table lock
has been removed from the -mm tree.  Its filename was
     mm-remove-obsolete-comments-about-page-table-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: remove obsolete comments about page table lock

The callers of free_pgd_range() and hugetlb_free_pgd_range() don't hold
page table locks.  The comments seems to be obsolete, so let's remove
them.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |    2 --
 mm/memory.c                   |    2 --
 2 files changed, 4 deletions(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~mm-remove-obsolete-comments-about-page-table-lock arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~mm-remove-obsolete-comments-about-page-table-lock
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -633,8 +633,6 @@ static void hugetlb_free_pud_range(struc
 
 /*
  * This function frees user-level page tables of a process.
- *
- * Must be called with pagetable lock held.
  */
 void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 			    unsigned long addr, unsigned long end,
diff -puN mm/memory.c~mm-remove-obsolete-comments-about-page-table-lock mm/memory.c
--- a/mm/memory.c~mm-remove-obsolete-comments-about-page-table-lock
+++ a/mm/memory.c
@@ -453,8 +453,6 @@ static inline void free_pud_range(struct
 
 /*
  * This function frees user-level page tables of a process.
- *
- * Must be called with pagetable lock held.
  */
 void free_pgd_range(struct mmu_gather *tlb,
 			unsigned long addr, unsigned long end,
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch

