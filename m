From: akpm@linux-foundation.org
Subject: + hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch added to -mm tree
Date: Mon, 29 Jun 2009 15:43:49 -0700
Message-ID: <200906292243.n5TMhnZA023914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312AbZF2WoR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 18:44:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, agl@us.ibm.com, apw@canonical.com, eric.whitney@hp.com, mel@csn.ul.ie, nacc@us.ibm.com, rientjes@google.com


The patch titled
     hugetlb: use free_pool_huge_page() to return unused surplus pages
has been added to the -mm tree.  Its filename is
     hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: use free_pool_huge_page() to return unused surplus pages
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Use the [modified] free_pool_huge_page() function to return unused
surplus pages.  This will help keep huge pages balanced across nodes
between freeing of unused surplus pages and freeing of persistent huge
pages [from set_max_huge_pages] by using the same node id "cursor". It
also eliminates some code duplication.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   57 +++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 32 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages
+++ a/mm/hugetlb.c
@@ -687,7 +687,7 @@ static int hstate_next_node_to_free(stru
  * balanced over allowed nodes.
  * Called with hugetlb_lock locked.
  */
-static int free_pool_huge_page(struct hstate *h)
+static int free_pool_huge_page(struct hstate *h, bool acct_surplus)
 {
 	int start_nid;
 	int next_nid;
@@ -697,6 +697,13 @@ static int free_pool_huge_page(struct hs
 	next_nid = start_nid;
 
 	do {
+		/*
+		 * If we're returning unused surplus pages, skip nodes
+		 * with no surplus.
+		 */
+		if (acct_surplus && !h->surplus_huge_pages_node[next_nid])
+			continue;
+
 		if (!list_empty(&h->hugepage_freelists[next_nid])) {
 			struct page *page =
 				list_entry(h->hugepage_freelists[next_nid].next,
@@ -704,6 +711,10 @@ static int free_pool_huge_page(struct hs
 			list_del(&page->lru);
 			h->free_huge_pages--;
 			h->free_huge_pages_node[next_nid]--;
+			if (acct_surplus) {
+				h->surplus_huge_pages--;
+				h->surplus_huge_pages_node[next_nid]--;
+			}
 			update_and_free_page(h, page);
 			ret = 1;
 		}
@@ -884,22 +895,13 @@ free:
  * When releasing a hugetlb pool reservation, any surplus pages that were
  * allocated to satisfy the reservation must be explicitly freed if they were
  * never used.
+ * Called with hugetlb_lock held.
  */
 static void return_unused_surplus_pages(struct hstate *h,
 					unsigned long unused_resv_pages)
 {
-	static int nid = -1;
-	struct page *page;
 	unsigned long nr_pages;
 
-	/*
-	 * We want to release as many surplus pages as possible, spread
-	 * evenly across all nodes. Iterate across all nodes until we
-	 * can no longer free unreserved surplus pages. This occurs when
-	 * the nodes with surplus pages have no free pages.
-	 */
-	unsigned long remaining_iterations = nr_online_nodes;
-
 	/* Uncommit the reservation */
 	h->resv_huge_pages -= unused_resv_pages;
 
@@ -909,26 +911,17 @@ static void return_unused_surplus_pages(
 
 	nr_pages = min(unused_resv_pages, h->surplus_huge_pages);
 
-	while (remaining_iterations-- && nr_pages) {
-		nid = next_node(nid, node_online_map);
-		if (nid == MAX_NUMNODES)
-			nid = first_node(node_online_map);
-
-		if (!h->surplus_huge_pages_node[nid])
-			continue;
-
-		if (!list_empty(&h->hugepage_freelists[nid])) {
-			page = list_entry(h->hugepage_freelists[nid].next,
-					  struct page, lru);
-			list_del(&page->lru);
-			update_and_free_page(h, page);
-			h->free_huge_pages--;
-			h->free_huge_pages_node[nid]--;
-			h->surplus_huge_pages--;
-			h->surplus_huge_pages_node[nid]--;
-			nr_pages--;
-			remaining_iterations = nr_online_nodes;
-		}
+	/*
+	 * We want to release as many surplus pages as possible, spread
+	 * evenly across all nodes. Iterate across all nodes until we
+	 * can no longer free unreserved surplus pages. This occurs when
+	 * the nodes with surplus pages have no free pages.
+	 * free_pool_huge_page() will balance the the frees across the
+	 * on-line nodes for us and will handle the hstate accounting.
+	 */
+	while (nr_pages--) {
+		if (!free_pool_huge_page(h, 1))
+			break;
 	}
 }
 
@@ -1268,7 +1261,7 @@ static unsigned long set_max_huge_pages(
 	min_count = max(count, min_count);
 	try_to_free_low(h, min_count);
 	while (min_count < persistent_huge_pages(h)) {
-		if (!free_pool_huge_page(h))
+		if (!free_pool_huge_page(h, 0))
 			break;
 	}
 	while (count < persistent_huge_pages(h)) {
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch

