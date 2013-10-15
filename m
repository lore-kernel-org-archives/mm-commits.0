From: akpm@linux-foundation.org
Subject: + mm-fix-bug-in-__split_huge_page_pmd.patch added to -mm tree
Date: Tue, 15 Oct 2013 12:59:18 -0700
Message-ID: <525d9e96.LWMZ6NCoA/e+Qfmz%akpm__20044.743436347$1381867171$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933444Ab3JOT7T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Oct 2013 15:59:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rientjes@google.com, n-horiguchi@ah.jp.nec.com, kirill.shutemov@linux.intel.com, aarcange@redhat.com, hughd@google.com

Subject: + mm-fix-bug-in-__split_huge_page_pmd.patch added to -mm tree
To: hughd@google.com,aarcange@redhat.com,kirill.shutemov@linux.intel.com,n-horiguchi@ah.jp.nec.com,rientjes@google.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 15 Oct 2013 12:59:18 -0700


The patch titled
     Subject: mm: fix BUG in __split_huge_page_pmd
has been added to the -mm tree.  Its filename is
     mm-fix-bug-in-__split_huge_page_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-bug-in-__split_huge_page_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-bug-in-__split_huge_page_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix BUG in __split_huge_page_pmd

Occasionally we hit the BUG_ON(pmd_trans_huge(*pmd)) at the end of
__split_huge_page_pmd(): seen when doing madvise(,,MADV_DONTNEED).

It's invalid: we don't always have down_write of mmap_sem there: a racing
do_huge_pmd_wp_page() might have copied-on-write to another huge page
before our split_huge_page() got the anon_vma lock.

Forget the BUG_ON, just go back and try again if this happens.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-fix-bug-in-__split_huge_page_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~mm-fix-bug-in-__split_huge_page_pmd
+++ a/mm/huge_memory.c
@@ -2697,6 +2697,7 @@ void __split_huge_page_pmd(struct vm_are
 
 	mmun_start = haddr;
 	mmun_end   = haddr + HPAGE_PMD_SIZE;
+again:
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_trans_huge(*pmd))) {
@@ -2719,7 +2720,14 @@ void __split_huge_page_pmd(struct vm_are
 	split_huge_page(page);
 
 	put_page(page);
-	BUG_ON(pmd_trans_huge(*pmd));
+
+	/*
+	 * We don't always have down_write of mmap_sem here: a racing
+	 * do_huge_pmd_wp_page() might have copied-on-write to another
+	 * huge page before our split_huge_page() got the anon_vma lock.
+	 */
+	if (unlikely(pmd_trans_huge(*pmd)))
+		goto again;
 }
 
 void split_huge_page_pmd_mm(struct mm_struct *mm, unsigned long address,
_

Patches currently in -mm which might be from hughd@google.com are

mm-hugetlb-correct-missing-private-flag-clearing.patch
mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages.patch
swap-fix-set_blocksize-race-during-swapon-swapoff.patch
mm-fix-bug-in-__split_huge_page_pmd.patch
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
swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

