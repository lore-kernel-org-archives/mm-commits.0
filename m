From: akpm@linux-foundation.org
Subject: - hugetlb-fix-race-in-alloc_fresh_huge_page.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:49:08 -0700
Message-ID: <200707162049.l6GKn8oY001139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49426 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761350AbXGPVcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:32:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe.jin@oracle.com, gurudas.pai@oracle.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     hugetlb: fix race in alloc_fresh_huge_page()
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-race-in-alloc_fresh_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hugetlb: fix race in alloc_fresh_huge_page()
From: Joe Jin <joe.jin@oracle.com>

That static `nid' index needs locking.  Without it we can end up calling
alloc_pages_node() with an illegal node ID and the kernel crashes.

Acked-by: gurudas pai <gurudas.pai@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-race-in-alloc_fresh_huge_page mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-race-in-alloc_fresh_huge_page
+++ a/mm/hugetlb.c
@@ -101,13 +101,20 @@ static void free_huge_page(struct page *
 
 static int alloc_fresh_huge_page(void)
 {
-	static int nid = 0;
+	static int prev_nid;
 	struct page *page;
-	page = alloc_pages_node(nid, GFP_HIGHUSER|__GFP_COMP|__GFP_NOWARN,
-					HUGETLB_PAGE_ORDER);
-	nid = next_node(nid, node_online_map);
+	static DEFINE_SPINLOCK(nid_lock);
+	int nid;
+
+	spin_lock(&nid_lock);
+	nid = next_node(prev_nid, node_online_map);
 	if (nid == MAX_NUMNODES)
 		nid = first_node(node_online_map);
+	prev_nid = nid;
+	spin_unlock(&nid_lock);
+
+	page = alloc_pages_node(nid, GFP_HIGHUSER|__GFP_COMP|__GFP_NOWARN,
+					HUGETLB_PAGE_ORDER);
 	if (page) {
 		set_compound_page_dtor(page, free_huge_page);
 		spin_lock(&hugetlb_lock);
_

Patches currently in -mm which might be from joe.jin@oracle.com are

origin.patch
