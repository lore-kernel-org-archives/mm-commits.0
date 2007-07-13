From: akpm@linux-foundation.org
Subject: + hugetlb-fix-race-in-alloc_fresh_huge_page.patch added to -mm tree
Date: Fri, 13 Jul 2007 12:23:34 -0700
Message-ID: <200707131923.l6DJNYus014183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759790AbXGMTXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 15:23:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe.jin@oracle.com, gurudas.pai@oracle.com


The patch titled
     hugetlb: fix race in alloc_fresh_huge_page()
has been added to the -mm tree.  Its filename is
     hugetlb-fix-race-in-alloc_fresh_huge_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: fix race in alloc_fresh_huge_page()
From: Joe Jin <joe.jin@oracle.com>

That static `nid' index needs locking.  Without it we can end up calling
alloc_pages_node() with an illegal node ID and the kernel crashes.

Acked-by: gurudas pai <gurudas.pai@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

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

hugetlb-fix-race-in-alloc_fresh_huge_page.patch
