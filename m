From: akpm@linux-foundation.org
Subject: +
 mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map.patch
 added to -mm tree
Date: Wed, 18 Jun 2014 16:45:21 -0700
Message-ID: <53a22491.gGMNyyAIG2XWxpbn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaFRXpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 19:45:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, scott.norton@hp.com, riel@redhat.com, mgorman@suse.de, kirill.shutemov@linux.intel.com, aarcange@redhat.com, Waiman.Long@hp.com


The patch titled
     Subject: mm, thp: move invariant bug check out of loop in __split_huge_page_map
has been added to the -mm tree.  Its filename is
     mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <Waiman.Long@hp.com>
Subject: mm, thp: move invariant bug check out of loop in __split_huge_page_map

In __split_huge_page_map(), the check for page_mapcount(page) is invariant
within the for loop.  Because of the fact that the macro is implemented
using atomic_read(), the redundant check cannot be optimized away by the
compiler leading to unnecessary read to the page structure.

This patch moves the invariant bug check out of the loop so that it will
be done only once.  On a 3.16-rc1 based kernel, the execution time of a
microbenchmark that broke up 1000 transparent huge pages using munmap()
had an execution time of 38,245us and 38,548us with and without the patch
respectively.  The performance gain is about 1%.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Scott J Norton <scott.norton@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map
+++ a/mm/huge_memory.c
@@ -1775,6 +1775,8 @@ static int __split_huge_page_map(struct
 	if (pmd) {
 		pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 		pmd_populate(mm, &_pmd, pgtable);
+		if (pmd_write(*pmd))
+			BUG_ON(page_mapcount(page) != 1);
 
 		haddr = address;
 		for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
@@ -1784,8 +1786,6 @@ static int __split_huge_page_map(struct
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 			if (!pmd_write(*pmd))
 				entry = pte_wrprotect(entry);
-			else
-				BUG_ON(page_mapcount(page) != 1);
 			if (!pmd_young(*pmd))
 				entry = pte_mkold(entry);
 			if (pmd_numa(*pmd))
_

Patches currently in -mm which might be from Waiman.Long@hp.com are

mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map.patch
mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch

