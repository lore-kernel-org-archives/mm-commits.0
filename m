From: akpm@linux-foundation.org
Subject: [merged] hugetlb-move-all-the-in-use-pages-to-active-list.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:12:54 -0700
Message-ID: <20120801201255.22D635C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:62258 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUM5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:12:57 -0400
Received: by bkcjc3 with SMTP id jc3so345182bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:12:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: move all the in use pages to active list
has been removed from the -mm tree.  Its filename was
     hugetlb-move-all-the-in-use-pages-to-active-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb: move all the in use pages to active list

When we fail to allocate pages from the reserve pool, hugetlb tries to
allocate huge pages using alloc_buddy_huge_page.  Add these to the active
list.  We also need to add the huge page we allocate when we soft offline
the oldpage to active list.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-move-all-the-in-use-pages-to-active-list mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-move-all-the-in-use-pages-to-active-list
+++ a/mm/hugetlb.c
@@ -928,8 +928,14 @@ struct page *alloc_huge_page_node(struct
 	page = dequeue_huge_page_node(h, nid);
 	spin_unlock(&hugetlb_lock);
 
-	if (!page)
+	if (!page) {
 		page = alloc_buddy_huge_page(h, nid);
+		if (page) {
+			spin_lock(&hugetlb_lock);
+			list_move(&page->lru, &h->hugepage_activelist);
+			spin_unlock(&hugetlb_lock);
+		}
+	}
 
 	return page;
 }
@@ -1155,6 +1161,9 @@ static struct page *alloc_huge_page(stru
 			hugepage_subpool_put_pages(spool, chg);
 			return ERR_PTR(-ENOSPC);
 		}
+		spin_lock(&hugetlb_lock);
+		list_move(&page->lru, &h->hugepage_activelist);
+		spin_unlock(&hugetlb_lock);
 	}
 
 	set_page_private(page, (unsigned long)spool);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
linux-next.patch

