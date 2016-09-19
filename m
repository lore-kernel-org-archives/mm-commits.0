From: akpm@linux-foundation.org
Subject: [patch 05/20] mm, thp: fix leaking mapped pte in
 __collapse_huge_page_swapin()
Date: Mon, 19 Sep 2016 14:44:04 -0700
Message-ID: <57e05c24.TkAwqfQYQRCJyy02%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52810 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932469AbcISVoF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2016 17:44:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ebru.akagunduz@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, riel@redhat.com, vbabka@suse.cz

From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: mm, thp: fix leaking mapped pte in __collapse_huge_page_swapin()

Currently, khugepaged does not permit swapin if there are enough young
pages in a THP.  The problem is when a THP does not have enough young
pages, khugepaged leaks mapped ptes.

This patch prohibits leaking mapped ptes.

Link: http://lkml.kernel.org/r/1472820276-7831-1-git-send-email-ebru.akagunduz@gmail.com
Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/khugepaged.c~mm-thp-fix-leaking-mapped-pte-in-__collapse_huge_page_swapin mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-fix-leaking-mapped-pte-in-__collapse_huge_page_swapin
+++ a/mm/khugepaged.c
@@ -882,6 +882,11 @@ static bool __collapse_huge_page_swapin(
 		.pmd = pmd,
 	};
 
+	/* we only decide to swapin, if there is enough young ptes */
+	if (referenced < HPAGE_PMD_NR/2) {
+		trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
+		return false;
+	}
 	fe.pte = pte_offset_map(pmd, address);
 	for (; fe.address < address + HPAGE_PMD_NR*PAGE_SIZE;
 			fe.pte++, fe.address += PAGE_SIZE) {
@@ -889,11 +894,6 @@ static bool __collapse_huge_page_swapin(
 		if (!is_swap_pte(pteval))
 			continue;
 		swapped_in++;
-		/* we only decide to swapin, if there is enough young ptes */
-		if (referenced < HPAGE_PMD_NR/2) {
-			trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
-			return false;
-		}
 		ret = do_swap_page(&fe, pteval);
 
 		/* do_swap_page returns VM_FAULT_RETRY with released mmap_sem */
_
