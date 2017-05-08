From: akpm@linux-foundation.org
Subject: +
 mm-khugepaged-add-missed-tracepoint-for-collapse_huge_page_swapin.patch
 added to -mm tree
Date: Mon, 08 May 2017 14:42:55 -0700
Message-ID: <5910e65f.+ZycCd7+1rCTMkcK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35100 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdEHVm4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 17:42:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sj38.park@gmail.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: add missed tracepoint for collapse_huge_page_swapin
has been added to the -mm tree.  Its filename is
     mm-khugepaged-add-missed-tracepoint-for-collapse_huge_page_swapin.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-add-missed-tracepoint-for-collapse_huge_page_swapin.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-add-missed-tracepoint-for-collapse_huge_page_swapin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from sj38.park@gmail.com are

mm-khugepaged-add-missed-tracepoint-for-collapse_huge_page_swapin.patch
docs-vm-transhuge-fix-few-trivial-typos.patch

