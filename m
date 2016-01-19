From: akpm@linux-foundation.org
Subject: [merged]
 khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch removed from
 -mm tree
Date: Tue, 19 Jan 2016 12:01:38 -0800
Message-ID: <569e9622.Cb5WEubK3Pv3xIL5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956AbcASUBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:01:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: ignore pmd tables with THP mapped with ptes
has been removed from the -mm tree.  Its filename was
     khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: ignore pmd tables with THP mapped with ptes

Prepare khugepaged to see compound pages mapped with pte.  For now we
won't collapse the pmd table with such pte.

khugepaged is subject for future rework wrt new refcounting.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    1 +
 mm/huge_memory.c                   |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN include/trace/events/huge_memory.h~khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes include/trace/events/huge_memory.h
--- a/include/trace/events/huge_memory.h~khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes
+++ a/include/trace/events/huge_memory.h
@@ -22,6 +22,7 @@
 	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
 	EM( SCAN_PAGE_LOCK,		"page_locked")			\
 	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
+	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
 	EM( SCAN_ANY_PROCESS,		"no_process_for_page")		\
 	EM( SCAN_VMA_NULL,		"vma_null")			\
 	EM( SCAN_VMA_CHECK,		"vma_check_failed")		\
diff -puN mm/huge_memory.c~khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes mm/huge_memory.c
--- a/mm/huge_memory.c~khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes
+++ a/mm/huge_memory.c
@@ -45,6 +45,7 @@ enum scan_result {
 	SCAN_PAGE_LRU,
 	SCAN_PAGE_LOCK,
 	SCAN_PAGE_ANON,
+	SCAN_PAGE_COMPOUND,
 	SCAN_ANY_PROCESS,
 	SCAN_VMA_NULL,
 	SCAN_VMA_CHECK,
@@ -2770,6 +2771,13 @@ static int khugepaged_scan_pmd(struct mm
 			result = SCAN_PAGE_NULL;
 			goto out_unmap;
 		}
+
+		/* TODO: teach khugepaged to collapse THP mapped with pte */
+		if (PageCompound(page)) {
+			result = SCAN_PAGE_COMPOUND;
+			goto out_unmap;
+		}
+
 		/*
 		 * Record which node the original page is from and save this
 		 * information to khugepaged_node_load[].
@@ -2782,7 +2790,6 @@ static int khugepaged_scan_pmd(struct mm
 			goto out_unmap;
 		}
 		khugepaged_node_load[node]++;
-		VM_BUG_ON_PAGE(PageCompound(page), page);
 		if (!PageLRU(page)) {
 			result = SCAN_SCAN_ABORT;
 			goto out_unmap;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

