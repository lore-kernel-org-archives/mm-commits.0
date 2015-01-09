From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch added to -mm tree
Date: Fri, 09 Jan 2015 14:39:14 -0800
Message-ID: <54b05892.cqCQ8Pkm6Z6SOyh5%akpm__39298.2406927787$1420843171$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbAIWjP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 17:39:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, james.hogan@imgtec.com, lcapitulino@redhat.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, mhocko@suse.cz, nacc@linux.vnet.ibm.com, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org, steve.capper@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add migration/hwpoisoned entry check in hugetlb_change_protection
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch

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
Subject: mm/hugetlb: add migration/hwpoisoned entry check in hugetlb_change_protection

There is a race condition between hugepage migration and
change_protection(), where hugetlb_change_protection() doesn't care about
migration entries and wrongly overwrites them.  That causes unexpected
results like kernel crash.  HWPoison entries also can cause the same
problem.

This patch adds is_hugetlb_entry_(migration|hwpoisoned) check in this
function to do proper actions.

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

 mm/hugetlb.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection
+++ a/mm/hugetlb.c
@@ -3384,7 +3384,26 @@ unsigned long hugetlb_change_protection(
 			spin_unlock(ptl);
 			continue;
 		}
-		if (!huge_pte_none(huge_ptep_get(ptep))) {
+		pte = huge_ptep_get(ptep);
+		if (unlikely(is_hugetlb_entry_hwpoisoned(pte))) {
+			spin_unlock(ptl);
+			continue;
+		}
+		if (unlikely(is_hugetlb_entry_migration(pte))) {
+			swp_entry_t entry = pte_to_swp_entry(pte);
+
+			if (is_write_migration_entry(entry)) {
+				pte_t newpte;
+
+				make_migration_entry_read(&entry);
+				newpte = swp_entry_to_pte(entry);
+				set_huge_pte_at(mm, address, ptep, newpte);
+				pages++;
+			}
+			spin_unlock(ptl);
+			continue;
+		}
+		if (!huge_pte_none(pte)) {
 			pte = huge_ptep_get_and_clear(mm, address, ptep);
 			pte = pte_mkhuge(huge_pte_modify(pte, newprot));
 			pte = arch_make_huge_pte(pte, vma, NULL, 0);
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

