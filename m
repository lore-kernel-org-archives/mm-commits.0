From: akpm@linux-foundation.org
Subject: +
 mm-dirty-accountable-change-only-apply-to-non-prot-numa-case.patch added to -mm tree
Date: Thu, 13 Feb 2014 15:06:52 -0800
Message-ID: <52fd500c.vPeKyPCVhLV9E46E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaBMXGx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 18:06:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, paulus@samba.org, mgorman@suse.de, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com

Subject: + mm-dirty-accountable-change-only-apply-to-non-prot-numa-case.patch added to -mm tree
To: aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,mgorman@suse.de,paulus@samba.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 15:06:52 -0800


The patch titled
     Subject: mm: dirty accountable change only apply to non prot numa case
has been added to the -mm tree.  Its filename is
     mm-dirty-accountable-change-only-apply-to-non-prot-numa-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dirty-accountable-change-only-apply-to-non-prot-numa-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dirty-accountable-change-only-apply-to-non-prot-numa-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm: dirty accountable change only apply to non prot numa case

So move it within the if loop

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff -puN mm/mprotect.c~mm-dirty-accountable-change-only-apply-to-non-prot-numa-case mm/mprotect.c
--- a/mm/mprotect.c~mm-dirty-accountable-change-only-apply-to-non-prot-numa-case
+++ a/mm/mprotect.c
@@ -58,6 +58,13 @@ static unsigned long change_pte_range(st
 				if (pte_numa(ptent))
 					ptent = pte_mknonnuma(ptent);
 				ptent = pte_modify(ptent, newprot);
+				/*
+				 * Avoid taking write faults for pages we
+				 * know to be dirty.
+				 */
+				if (dirty_accountable && pte_dirty(ptent))
+					ptent = pte_mkwrite(ptent);
+				ptep_modify_prot_commit(mm, addr, pte, ptent);
 				updated = true;
 			} else {
 				struct page *page;
@@ -72,22 +79,8 @@ static unsigned long change_pte_range(st
 					}
 				}
 			}
-
-			/*
-			 * Avoid taking write faults for pages we know to be
-			 * dirty.
-			 */
-			if (dirty_accountable && pte_dirty(ptent)) {
-				ptent = pte_mkwrite(ptent);
-				updated = true;
-			}
-
 			if (updated)
 				pages++;
-
-			/* Only !prot_numa always clears the pte */
-			if (!prot_numa)
-				ptep_modify_prot_commit(mm, addr, pte, ptent);
 		} else if (IS_ENABLED(CONFIG_MIGRATION) && !pte_file(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

powerpc-mm-add-new-set-flag-argument-to-pte-pmd-update-function.patch
mm-dirty-accountable-change-only-apply-to-non-prot-numa-case.patch
mm-use-ptep-pmdp_set_numa-for-updating-_page_numa-bit.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch

