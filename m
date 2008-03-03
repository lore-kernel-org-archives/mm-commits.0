From: akpm@linux-foundation.org
Subject: + hugetlb-close-a-difficult-to-trigger-reservation-race.patch added to -mm tree
Date: Mon, 03 Mar 2008 13:23:57 -0800
Message-ID: <200803032123.m23LNv09007277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758553AbYCCV2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 16:28:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, apw@shadowen.org, david@gibson.dropbear.id.au, haveblue@us.ibm.com, mel@csn.ul.ie, wli@holomorphy.com


The patch titled
     hugetlb: close a difficult to trigger reservation race
has been added to the -mm tree.  Its filename is
     hugetlb-close-a-difficult-to-trigger-reservation-race.patch

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
Subject: hugetlb: close a difficult to trigger reservation race
From: Adam Litke <agl@us.ibm.com>

A hugetlb reservation may be inadequately backed in the event of racing
allocations and frees when utilizing surplus huge pages.  Consider the
following series of events in processes A and B:

 A) Allocates some surplus pages to satisfy a reservation
 B) Frees some huge pages
 A) A notices the extra free pages and drops hugetlb_lock to free some of
    its surplus pages back to the buddy allocator.
 B) Allocates some huge pages
 A) Reacquires hugetlb_lock and returns from gather_surplus_huge_pages()

Avoid this by commiting the reservation after pages have been allocated but
before dropping the lock to free excess pages.  For parity, release the
reservation in return_unused_surplus_pages().

This patch also corrects the cpuset_mems_nr() error path in
hugetlb_acct_memory().  If the cpuset check fails, uncommit the
reservation, but also be sure to return any surplus huge pages that may
have been allocated to back the failed reservation.

Thanks to Andy Whitcroft for discovering this.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-close-a-difficult-to-trigger-reservation-race mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-close-a-difficult-to-trigger-reservation-race
+++ a/mm/hugetlb.c
@@ -302,8 +302,10 @@ static int gather_surplus_pages(int delt
 	int needed, allocated;
 
 	needed = (resv_huge_pages + delta) - free_huge_pages;
-	if (needed <= 0)
+	if (needed <= 0) {
+		resv_huge_pages += delta;
 		return 0;
+	}
 
 	allocated = 0;
 	INIT_LIST_HEAD(&surplus_list);
@@ -341,9 +343,12 @@ retry:
 	 * The surplus_list now contains _at_least_ the number of extra pages
 	 * needed to accomodate the reservation.  Add the appropriate number
 	 * of pages to the hugetlb pool and free the extras back to the buddy
-	 * allocator.
+	 * allocator.  Commit the entire reservation here to prevent another
+	 * process from stealing the pages as they are added to the pool but
+	 * before they are reserved.
 	 */
 	needed += allocated;
+	resv_huge_pages += delta;
 	ret = 0;
 free:
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
@@ -378,6 +383,9 @@ static void return_unused_surplus_pages(
 	struct page *page;
 	unsigned long nr_pages;
 
+	/* Uncommit the reservation */
+	resv_huge_pages -= unused_resv_pages;
+
 	nr_pages = min(unused_resv_pages, surplus_huge_pages);
 
 	while (nr_pages) {
@@ -1212,12 +1220,13 @@ static int hugetlb_acct_memory(long delt
 		if (gather_surplus_pages(delta) < 0)
 			goto out;
 
-		if (delta > cpuset_mems_nr(free_huge_pages_node))
+		if (delta > cpuset_mems_nr(free_huge_pages_node)) {
+			return_unused_surplus_pages(delta);
 			goto out;
+		}
 	}
 
 	ret = 0;
-	resv_huge_pages += delta;
 	if (delta < 0)
 		return_unused_surplus_pages((unsigned long) -delta);
 
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-correct-page-count-for-surplus-huge-pages.patch
hugetlb-close-a-difficult-to-trigger-reservation-race.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch

