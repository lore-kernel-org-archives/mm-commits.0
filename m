From: akpm@linux-foundation.org
Subject: + mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page.patch added to -mm tree
Date: Tue, 10 Feb 2015 12:27:34 -0800
Message-ID: <54da69b6.B8yYm7wgVRJ9qpDr%akpm__9290.77290134064$1423600068$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbbBJU1f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Feb 2015 15:27:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, gong.chen@linux.intel.com, stable@vger.kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: drop lru_add_drain_all() in __soft_offline_page()
has been added to the -mm tree.  Its filename is
     mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page.patch

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
Subject: mm: hwpoison: drop lru_add_drain_all() in __soft_offline_page()

A race condition starts to be visible in recent mmotm, where a PG_hwpoison
flag is set on a migration source page *before* it's back in buddy page
poo= l.

This is problematic because no page flag is supposed to be set when
freeing (see __free_one_page().) So the user-visible effect of this race
is that it could trigger the BUG_ON() when soft-offlining is called.

The root cause is that we call lru_add_drain_all() to make sure that the
page is in buddy, but that doesn't work because this function just
schedule= s a work item and doesn't wait its completion. 
drain_all_pages() does drainin= g directly, so simply dropping
lru_add_drain_all() solves this problem.

Fixes: f15bdfa802bf ("mm/memory-failure.c: fix memory leak in successful soft offlining")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: <stable@vger.kernel.org>	[3.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page
+++ a/mm/memory-failure.c
@@ -1647,8 +1647,6 @@ static int __soft_offline_page(struct pa
 			 * setting PG_hwpoison.
 			 */
 			if (!is_free_buddy_page(page))
-				lru_add_drain_all();
-			if (!is_free_buddy_page(page))
 				drain_all_pages(page_zone(page));
 			SetPageHWPoison(page);
 			if (!is_free_buddy_page(page))
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hugetlb-x86-register-1g-page-size-if-we-can-allocate-them-runtime.patch
mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
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
mm-pagewalk-fix-misbehavior-of-walk_page_range-for-vmavm_pfnmap-re-pagewalk-improve-vma-handling.patch
mm-proc-pid-clear_refs-avoid-split_huge_page.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mincore-apply-page-table-walker-on-do_mincore-fix.patch
mincore-apply-page-table-walker-on-do_mincore-fix-fix.patch
mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

