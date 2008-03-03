From: akpm@linux-foundation.org
Subject: + hugetlb-correct-page-count-for-surplus-huge-pages.patch added to -mm tree
Date: Mon, 03 Mar 2008 13:23:51 -0800
Message-ID: <200803032123.m23LNqgA007270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754594AbYCCV3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 16:29:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, apw@shadowen.org, david@gibson.dropbear.id.au, haveblue@us.ibm.com, mel@csn.ul.ie, wli@holomorphy.com


The patch titled
     hugetlb: correct page count for surplus huge pages
has been added to the -mm tree.  Its filename is
     hugetlb-correct-page-count-for-surplus-huge-pages.patch

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
Subject: hugetlb: correct page count for surplus huge pages
From: Adam Litke <agl@us.ibm.com>

Free pages in the hugetlb pool are free and as such have a reference count of
zero.  Regular allocations into the pool from the buddy are "freed" into the
pool which results in their page_count dropping to zero.  However, surplus
pages can be directly utilized by the caller without first being freed to the
pool.  Therefore, a call to put_page_testzero() is in order so that such a
page will be handed to the caller with a correct count.

This has not affected end users because the bad page count is reset before the
page is handed off.  However, under CONFIG_DEBUG_VM this triggers a BUG when
the page count is validated.

Thanks go to Mel for first spotting this issue and providing an initial fix.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-correct-page-count-for-surplus-huge-pages mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-correct-page-count-for-surplus-huge-pages
+++ a/mm/hugetlb.c
@@ -268,6 +268,12 @@ static struct page *alloc_buddy_huge_pag
 
 	spin_lock(&hugetlb_lock);
 	if (page) {
+		/*
+		 * This page is now managed by the hugetlb allocator and has
+		 * no users -- drop the buddy allocator's reference.
+		 */
+		int page_count = put_page_testzero(page);
+		BUG_ON(page_count != 0);
 		nid = page_to_nid(page);
 		set_compound_page_dtor(page, free_huge_page);
 		/*
@@ -346,13 +352,14 @@ free:
 			enqueue_huge_page(page);
 		else {
 			/*
-			 * Decrement the refcount and free the page using its
-			 * destructor.  This must be done with hugetlb_lock
+			 * The page has a reference count of zero already, so
+			 * call free_huge_page directly instead of using
+			 * put_page.  This must be done with hugetlb_lock
 			 * unlocked which is safe because free_huge_page takes
 			 * hugetlb_lock before deciding how to free the page.
 			 */
 			spin_unlock(&hugetlb_lock);
-			put_page(page);
+			free_huge_page(page);
 			spin_lock(&hugetlb_lock);
 		}
 	}
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-correct-page-count-for-surplus-huge-pages.patch
hugetlb-close-a-difficult-to-trigger-reservation-race.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch

