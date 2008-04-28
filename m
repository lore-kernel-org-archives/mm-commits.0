From: akpm@linux-foundation.org
Subject: - hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:13 -0700
Message-ID: <200804282151.m3SLpDsi017563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765975AbYD1Vv5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, apw@shadowen.org, david@gibson.dropbear.id.au, haveblue@us.ibm.com, mel@csn.ul.ie, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: decrease hugetlb_lock cycling in gather_surplus_huge_pages
has been removed from the -mm tree.  Its filename was
     hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: decrease hugetlb_lock cycling in gather_surplus_huge_pages
From: Adam Litke <agl@us.ibm.com>

To reduce hugetlb_lock acquisitions and releases when freeing excess surplus
pages, scan the page list in two parts.  First, transfer the needed pages to
the hugetlb pool.  Then drop the lock and free the remaining pages back to the
buddy allocator.

In the common case there are zero excess pages and no lock operations are
required.

Thanks Mel Gorman for this improvement.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages
+++ a/mm/hugetlb.c
@@ -372,11 +372,19 @@ retry:
 	resv_huge_pages += delta;
 	ret = 0;
 free:
+	/* Free the needed pages to the hugetlb pool */
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
+		if ((--needed) < 0)
+			break;
 		list_del(&page->lru);
-		if ((--needed) >= 0)
-			enqueue_huge_page(page);
-		else {
+		enqueue_huge_page(page);
+	}
+
+	/* Free unnecessary surplus pages to the buddy allocator */
+	if (!list_empty(&surplus_list)) {
+		spin_unlock(&hugetlb_lock);
+		list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
+			list_del(&page->lru);
 			/*
 			 * The page has a reference count of zero already, so
 			 * call free_huge_page directly instead of using
@@ -384,10 +392,9 @@ free:
 			 * unlocked which is safe because free_huge_page takes
 			 * hugetlb_lock before deciding how to free the page.
 			 */
-			spin_unlock(&hugetlb_lock);
 			free_huge_page(page);
-			spin_lock(&hugetlb_lock);
 		}
+		spin_lock(&hugetlb_lock);
 	}
 
 	return ret;
_

Patches currently in -mm which might be from agl@us.ibm.com are

origin.patch

