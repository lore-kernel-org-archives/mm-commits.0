From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch added
 to -mm tree
Date: Fri, 09 Jan 2015 14:39:16 -0800
Message-ID: <54b05894.Q4/zA9HJWViNbcVX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbAIWjS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 17:39:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, james.hogan@imgtec.com, lcapitulino@redhat.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, mhocko@suse.cz, nacc@linux.vnet.ibm.com, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org, steve.capper@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add migration entry check in __unmap_hugepage_range
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch

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
Subject: mm/hugetlb: add migration entry check in __unmap_hugepage_range

If __unmap_hugepage_range() tries to unmap the address range over which
hugepage migration is on the way, we get the wrong page because pte_page()
doesn't work for migration entries.  This patch simply clears the pte for
migration entries as we do for hwpoison entries.

Fixes: 290408d4a2 ("hugetlb: hugepage migration core")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: <stable@vger.kernel.org>	[2.6.36+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range
+++ a/mm/hugetlb.c
@@ -2657,9 +2657,10 @@ again:
 			goto unlock;
 
 		/*
-		 * HWPoisoned hugepage is already unmapped and dropped reference
+		 * Migrating hugepage or HWPoisoned hugepage is already
+		 * unmapped and its refcount is dropped, so just clear pte here.
 		 */
-		if (unlikely(is_hugetlb_entry_hwpoisoned(pte))) {
+		if (unlikely(!pte_present(pte))) {
 			huge_pte_clear(mm, address, ptep);
 			goto unlock;
 		}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

