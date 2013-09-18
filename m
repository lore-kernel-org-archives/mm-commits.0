From: akpm@linux-foundation.org
Subject: + mm-remove-obsolete-comments-about-page-table-lock.patch added
 to -mm tree
Date: Wed, 18 Sep 2013 15:16:48 -0700
Message-ID: <523a2650.bbw8MxcTuNj4iwnr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3IRWQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 18:16:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com

Subject: + mm-remove-obsolete-comments-about-page-table-lock.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 15:16:48 -0700


The patch titled
     Subject: mm: remove obsolete comments about page table lock
has been added to the -mm tree.  Its filename is
     mm-remove-obsolete-comments-about-page-table-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-obsolete-comments-about-page-table-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-obsolete-comments-about-page-table-lock.patch

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

mm-remove-obsolete-comments-about-page-table-lock.patch

