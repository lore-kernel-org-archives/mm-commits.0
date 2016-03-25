From: akpm@linux-foundation.org
Subject: + thp-fix-typo-in-khugepaged_scan_pmd.patch added to -mm tree
Date: Fri, 25 Mar 2016 11:48:49 -0700
Message-ID: <56f58811.cuMeCJtd4yLQaVfd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbcCYSsu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2016 14:48:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, ebru.akagunduz@gmail.com, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix typo in khugepaged_scan_pmd()
has been added to the -mm tree.  Its filename is
     thp-fix-typo-in-khugepaged_scan_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-fix-typo-in-khugepaged_scan_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-fix-typo-in-khugepaged_scan_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: fix typo in khugepaged_scan_pmd()

!PageLRU should lead to SCAN_PAGE_LRU, not SCAN_SCAN_ABORT result.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-fix-typo-in-khugepaged_scan_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-typo-in-khugepaged_scan_pmd
+++ a/mm/huge_memory.c
@@ -2578,7 +2578,7 @@ static int khugepaged_scan_pmd(struct mm
 		}
 		khugepaged_node_load[node]++;
 		if (!PageLRU(page)) {
-			result = SCAN_SCAN_ABORT;
+			result = SCAN_PAGE_LRU;
 			goto out_unmap;
 		}
 		if (PageLocked(page)) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-fix-typo-in-khugepaged_scan_pmd.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

