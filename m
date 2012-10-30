From: akpm@linux-foundation.org
Subject: + mm-highmem-remove-page_address_pool-list.patch added to -mm tree
Date: Tue, 30 Oct 2012 14:39:13 -0700
Message-ID: <20121030213913.9A1B31E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:64177 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab2J3VjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 17:39:14 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so87036ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 14:39:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: js1304@gmail.com, a.p.zijlstra@chello.nl, mel@csn.ul.ie, minchan@kernel.org


The patch titled
     Subject: mm, highmem: remove page_address_pool list
has been added to the -mm tree.  Its filename is
     mm-highmem-remove-page_address_pool-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 mm/highmem.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff -puN mm/highmem.c~mm-highmem-remove-page_address_pool-list mm/highmem.c
--- a/mm/highmem.c~mm-highmem-remove-page_address_pool-list
+++ a/mm/highmem.c
@@ -324,11 +324,7 @@ struct page_address_map {
 	void *virtual;
 	struct list_head list;
 };
-
-/*
- * page_address_map freelist, allocated from page_address_maps.
- */
-static struct list_head page_address_pool;	/* freelist */
+static struct page_address_map page_address_maps[LAST_PKMAP];
 
 /*
  * Hash table bucket
@@ -393,12 +389,7 @@ void set_page_address(struct page *page,
 
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
 
@@ -411,7 +402,6 @@ void set_page_address(struct page *page,
 			if (pam->page == page) {
 				list_del(&pam->list);
 				spin_unlock_irqrestore(&pas->lock, flags);
-				list_add_tail(&pam->list, &page_address_pool);
 				goto done;
 			}
 		}
@@ -421,15 +411,10 @@ done:
 	return;
 }
 
-static struct page_address_map page_address_maps[LAST_PKMAP];
