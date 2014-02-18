From: akpm@linux-foundation.org
Subject: [merged]
 mm-dirty-accountable-change-only-apply-to-non-prot-numa-case.patch removed
 from -mm tree
Date: Tue, 18 Feb 2014 12:12:23 -0800
Message-ID: <5303bea7.gM5mjR8Ph9OHl08S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaBRUMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 15:12:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, paulus@samba.org, mgorman@suse.de, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com

Subject: [merged] mm-dirty-accountable-change-only-apply-to-non-prot-numa-case.patch removed from -mm tree
To: aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,mgorman@suse.de,paulus@samba.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 12:12:23 -0800


The patch titled
     Subject: mm: dirty accountable change only apply to non prot numa case
has been removed from the -mm tree.  Its filename was
     mm-dirty-accountable-change-only-apply-to-non-prot-numa-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
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

