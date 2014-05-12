From: akpm@linux-foundation.org
Subject: +
 hwposion-hugetlb-lock_page-unlock_page-does-not-match-for-handling-a-free-hugepage.patch added to -mm tree
Date: Mon, 12 May 2014 15:56:24 -0700
Message-ID: <53715198.5bp8bZ0hOVOjyvKu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaELW4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 May 2014 18:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, slaoub@gmail.com

Subject: + hwposion-hugetlb-lock_page-unlock_page-does-not-match-for-handling-a-free-hugepage.patch added to -mm tree
To: slaoub@gmail.com,ak@linux.intel.com,n-horiguchi@ah.jp.nec.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 12 May 2014 15:56:24 -0700


The patch titled
     Subject: HWPOSION, hugetlb: lock_page/unlock_page does not match for handling a free hugepage
has been added to the -mm tree.  Its filename is
     hwposion-hugetlb-lock_page-unlock_page-does-not-match-for-handling-a-free-hugepage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwposion-hugetlb-lock_page-unlock_page-does-not-match-for-handling-a-free-hugepage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwposion-hugetlb-lock_page-unlock_page-does-not-match-for-handling-a-free-hugepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Yucong <slaoub@gmail.com>
Subject: HWPOSION, hugetlb: lock_page/unlock_page does not match for handling a free hugepage

For handling a free hugepage in memory failure, the race will happen if
another thread hwpoisoned this hugepage concurrently.  So we need to check
PageHWPoison instead of !PageHWPoison.

If hwpoison_filter(p) returns true or a race happens, then we need to
unlock_page(hpage).

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Tested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: <stable@vger.kernel.org>	[2.6.36+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN mm/memory-failure.c~hwposion-hugetlb-lock_page-unlock_page-does-not-match-for-handling-a-free-hugepage mm/memory-failure.c
--- a/mm/memory-failure.c~hwposion-hugetlb-lock_page-unlock_page-does-not-match-for-handling-a-free-hugepage
+++ a/mm/memory-failure.c
@@ -1081,15 +1081,16 @@ int memory_failure(unsigned long pfn, in
 			return 0;
 		} else if (PageHuge(hpage)) {
 			/*
-			 * Check "just unpoisoned", "filter hit", and
-			 * "race with other subpage."
+			 * Check "filter hit" and "race with other subpage."
 			 */
 			lock_page(hpage);
-			if (!PageHWPoison(hpage)
-			    || (hwpoison_filter(p) && TestClearPageHWPoison(p))
-			    || (p != hpage && TestSetPageHWPoison(hpage))) {
-				atomic_long_sub(nr_pages, &num_poisoned_pages);
-				return 0;
+			if (PageHWPoison(hpage)) {
+				if ((hwpoison_filter(p) && TestClearPageHWPoison(p))
+				    || (p != hpage && TestSetPageHWPoison(hpage))) {
+					atomic_long_sub(nr_pages, &num_poisoned_pages);
+					unlock_page(hpage);
+					return 0;
+				}
 			}
 			set_page_hwpoison_huge_page(hpage);
 			res = dequeue_hwpoisoned_huge_page(hpage);
_

Patches currently in -mm which might be from slaoub@gmail.com are

hwposion-hugetlb-lock_page-unlock_page-does-not-match-for-handling-a-free-hugepage.patch

