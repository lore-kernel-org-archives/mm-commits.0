From: akpm@linux-foundation.org
Subject: [folded] hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch removed from -mm tree
Date: Mon, 21 Sep 2009 14:20:03 -0700
Message-ID: <200909212120.n8LLK3uM001322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751990AbZIUVUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 17:20:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, agl@us.ibm.com, apw@canonical.com, eric.whitney@hp.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, nacc@us.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: use free_pool_huge_page() to return unused surplus pages fix
has been removed from the -mm tree.  Its filename was
     hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch

This patch was dropped because it was folded into hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: use free_pool_huge_page() to return unused surplus pages fix
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Fixes bug detected by libhugetlbfs test suite in:
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch

Can't just "continue" for node with no surplus pages when returning
unused surplus.  We need to advance to 'next node to free'.

With this fix, the "hugetlb balance free across nodes" series passes
the test suite.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix
+++ a/mm/hugetlb.c
@@ -698,13 +698,11 @@ static int free_pool_huge_page(struct hs
 
 	do {
 		/*
-		 * If we're returning unused surplus pages, skip nodes
-		 * with no surplus.
+		 * If we're returning unused surplus pages, only examine
+		 * nodes with surplus pages.
 		 */
-		if (acct_surplus && !h->surplus_huge_pages_node[next_nid])
-			continue;
