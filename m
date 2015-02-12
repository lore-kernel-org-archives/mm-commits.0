From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 11:36:27 -0800
Message-ID: <54dd00bb.SawEgDMlUbdigdp3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbbBLTg3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, james.hogan@imgtec.com, lcapitulino@redhat.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, mhocko@suse.cz, nacc@linux.vnet.ibm.com, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org, steve.capper@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add migration entry check in __unmap_hugepage_range
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

