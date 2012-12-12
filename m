From: akpm@linux-foundation.org
Subject: [merged] mm-highmem-remove-page_address_pool-list.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:32 -0800
Message-ID: <20121212195832.A42D182004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:62187 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab2LLUD6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:03:58 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so118357yen.0
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:03:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, a.p.zijlstra@chello.nl, mel@csn.ul.ie, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, highmem: remove page_address_pool list
has been removed from the -mm tree.  Its filename was
     mm-highmem-remove-page_address_pool-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm, highmem: remove page_address_pool list

We can find free page_address_map instance without the page_address_pool. 
So remove it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff -puN mm/highmem.c~mm-highmem-remove-page_address_pool-list mm/highmem.c
--- a/mm/highmem.c~mm-highmem-remove-page_address_pool-list
+++ a/mm/highmem.c
@@ -324,10 +324,7 @@ struct page_address_map {
 	struct list_head list;
 };
 
-/*
- * page_address_map freelist, allocated from page_address_maps.
- */
-static struct list_head page_address_pool;	/* freelist */
+static struct page_address_map page_address_maps[LAST_PKMAP];
 
 /*
  * Hash table bucket
@@ -392,12 +389,7 @@ void set_page_address(struct page *page,
 
 	pas = page_slot(page);
 	if (virtual) {		/* Add */
-		BUG_ON(list_empty(&page_address_pool));
-
-		pam = list_entry(page_address_pool.next,
-				struct page_address_map, list);
-		list_del(&pam->list);
-
+		pam = &page_address_maps[PKMAP_NR((unsigned long)virtual)];
 		pam->page = page;
 		pam->virtual = virtual;
 
@@ -410,7 +402,6 @@ void set_page_address(struct page *page,
 			if (pam->page == page) {
 				list_del(&pam->list);
 				spin_unlock_irqrestore(&pas->lock, flags);
-				list_add_tail(&pam->list, &page_address_pool);
 				goto done;
 			}
 		}
@@ -420,15 +411,10 @@ done:
 	return;
 }
 
-static struct page_address_map page_address_maps[LAST_PKMAP];
