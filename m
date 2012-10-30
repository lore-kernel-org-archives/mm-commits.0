From: akpm@linux-foundation.org
Subject: + mm-highmem-remove-useless-pool_lock.patch added to -mm tree
Date: Tue, 30 Oct 2012 14:39:08 -0700
Message-ID: <20121030213909.75224200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:60753 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab2J3VjM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 17:39:12 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so49888wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 14:39:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: js1304@gmail.com, a.p.zijlstra@chello.nl, mel@csn.ul.ie, minchan@kernel.org


The patch titled
     Subject: mm, highmem: remove useless pool_lock
has been added to the -mm tree.  Its filename is
     mm-highmem-remove-useless-pool_lock.patch

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
Subject: mm, highmem: remove useless pool_lock

The pool_lock protects the page_address_pool from concurrent access.  But,
access to the page_address_pool is already protected by kmap_lock.  So
remove it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kin <minchan@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/highmem.c~mm-highmem-remove-useless-pool_lock mm/highmem.c
--- a/mm/highmem.c~mm-highmem-remove-useless-pool_lock
+++ a/mm/highmem.c
@@ -329,7 +329,6 @@ struct page_address_map {
  * page_address_map freelist, allocated from page_address_maps.
  */
 static struct list_head page_address_pool;	/* freelist */
-static spinlock_t pool_lock;			/* protects page_address_pool */
 
 /*
  * Hash table bucket
@@ -396,11 +395,9 @@ void set_page_address(struct page *page,
 	if (virtual) {		/* Add */
 		BUG_ON(list_empty(&page_address_pool));
 
-		spin_lock_irqsave(&pool_lock, flags);
 		pam = list_entry(page_address_pool.next,
 				struct page_address_map, list);
 		list_del(&pam->list);
-		spin_unlock_irqrestore(&pool_lock, flags);
 
 		pam->page = page;
 		pam->virtual = virtual;
@@ -414,9 +411,7 @@ void set_page_address(struct page *page,
 			if (pam->page == page) {
 				list_del(&pam->list);
 				spin_unlock_irqrestore(&pas->lock, flags);
-				spin_lock_irqsave(&pool_lock, flags);
 				list_add_tail(&pam->list, &page_address_pool);
-				spin_unlock_irqrestore(&pool_lock, flags);
 				goto done;
 			}
 		}
@@ -439,7 +434,6 @@ void __init page_address_init(void)
 		INIT_LIST_HEAD(&page_address_htable[i].lh);
 		spin_lock_init(&page_address_htable[i].lock);
 	}
-	spin_lock_init(&pool_lock);
 }
 
 #endif	/* defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL) */
_

Patches currently in -mm which might be from js1304@gmail.com are

linux-next.patch
mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch
mm-highmem-remove-useless-pool_lock.patch
mm-highmem-remove-page_address_pool-list.patch
mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry.patch
mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr.patch

