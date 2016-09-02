From: akpm@linux-foundation.org
Subject: +
 mm-thp-fix-leaking-mapped-pte-in-__collapse_huge_page_swapin.patch added to -mm tree
Date: Fri, 02 Sep 2016 13:44:21 -0700
Message-ID: <57c9e4a5.OlqUn4E30TzARj/+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36157 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752847AbcIBUoW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2016 16:44:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: fix leaking mapped pte in __collapse_huge_page_swapin()
has been added to the -mm tree.  Its filename is
     mm-thp-fix-leaking-mapped-pte-in-__collapse_huge_page_swapin.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-leaking-mapped-pte-in-__collapse_huge_page_swapin.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-leaking-mapped-pte-in-__collapse_huge_page_swapin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: mm, thp: fix leaking mapped pte in __collapse_huge_page_swapin()

Currently, khugepaged does not permit swapin if there are enough young
pages in a THP.  The problem is when a THP does not have enough young
pages, khugepaged leaks mapped ptes.

This patch prohibits leaking mapped ptes.

Link: http://lkml.kernel.org/r/1472820276-7831-1-git-send-email-ebru.akagunduz@gmail.com
Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
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
@@ -881,6 +881,11 @@ static bool __collapse_huge_page_swapin(
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
@@ -888,11 +893,6 @@ static bool __collapse_huge_page_swapin(
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

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

mm-thp-fix-leaking-mapped-pte-in-__collapse_huge_page_swapin.patch

