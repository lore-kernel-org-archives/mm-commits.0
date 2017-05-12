From: akpm@linux-foundation.org
Subject: [patch 05/15] mm/khugepaged: add missed tracepoint for
 collapse_huge_page_swapin
Date: Fri, 12 May 2017 15:46:38 -0700
Message-ID: <20170512224638.A9Qy6sQYp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38684 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756700AbdELWqj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 18:46:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, sj38.park@gmail.com, torvalds@linux-foundation.org

From: SeongJae Park <sj38.park@gmail.com>
Subject: mm/khugepaged: add missed tracepoint for collapse_huge_page_swapin

One return case of `__collapse_huge_page_swapin()` does not invoke
tracepoint while every other return case does.  This commit adds a
tracepoint invocation for the case.

Link: http://lkml.kernel.org/r/20170507101813.30187-1-sj38.park@gmail.com
Signed-off-by: SeongJae Park <sj38.park@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/khugepaged.c~mm-khugepaged-add-missed-tracepoint-for-collapse_huge_page_swapin mm/khugepaged.c
--- a/mm/khugepaged.c~mm-khugepaged-add-missed-tracepoint-for-collapse_huge_page_swapin
+++ a/mm/khugepaged.c
@@ -907,8 +907,10 @@ static bool __collapse_huge_page_swapin(
 				return false;
 			}
 			/* check if the pmd is still valid */
-			if (mm_find_pmd(mm, address) != pmd)
+			if (mm_find_pmd(mm, address) != pmd) {
+				trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
 				return false;
+			}
 		}
 		if (ret & VM_FAULT_ERROR) {
 			trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
_
