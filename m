From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch removed from -mm tree
Date: Thu, 14 Aug 2014 14:32:33 -0700
Message-ID: <53ed2af1.LHpyw0N1mIBQoy2A%akpm__33065.9461244524$1408051966$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:62498 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbaHNVce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:32:34 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so374340oig.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:32:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, cl@linux.com, hughd@google.com, mel@csn.ul.ie, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use get_page_unless_zero() in hugetlb_fault()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb: use get_page_unless_zero() in hugetlb_fault()

After fixing locking in follow_page(FOLL_GET) for hugepages, I start to
observe the BUG of "get_page() on refcount 0 page" in hugetlb_fault() in
the same test.

I'm not exactly sure about how this race is triggered, but hugetlb_fault()
calls pte_page() and get_page() outside page table lock, so it's not safe.
 This patch checks the refcount of the gotten page, and aborts the page
fault if the refcount is 0, expecting to retry.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault
+++ a/mm/hugetlb.c
@@ -3192,7 +3192,8 @@ int hugetlb_fault(struct mm_struct *mm,
 	 * so no worry about deadlock.
 	 */
 	page = pte_page(entry);
-	get_page(page);
+	if (!get_page_unless_zero(page))
+		goto out_put_pagecache;
 	if (page != pagecache_page)
 		lock_page(page);
 
@@ -3218,15 +3219,14 @@ int hugetlb_fault(struct mm_struct *mm,
 
 out_ptl:
 	spin_unlock(ptl);
-
+	if (page != pagecache_page)
+		unlock_page(page);
+	put_page(page);
+out_put_pagecache:
 	if (pagecache_page) {
 		unlock_page(pagecache_page);
 		put_page(pagecache_page);
 	}
-	if (page != pagecache_page)
-		unlock_page(page);
-	put_page(page);
