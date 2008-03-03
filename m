From: akpm@linux-foundation.org
Subject: + hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch added to -mm tree
Date: Mon, 03 Mar 2008 13:24:14 -0800
Message-ID: <200803032124.m23LOERo007309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755366AbYCCV0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 16:26:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, apw@shadowen.org, david@gibson.dropbear.id.au, haveblue@us.ibm.com, mel@csn.ul.ie, wli@holomorphy.com


The patch titled
     hugetlb: decrease hugetlb_lock cycling in gather_surplus_huge_pages
has been added to the -mm tree.  Its filename is
     hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -352,11 +352,19 @@ retry:
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
@@ -364,10 +372,9 @@ free:
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

hugetlb-correct-page-count-for-surplus-huge-pages.patch
hugetlb-close-a-difficult-to-trigger-reservation-race.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch

