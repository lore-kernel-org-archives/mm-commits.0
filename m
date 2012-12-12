From: akpm@linux-foundation.org
Subject: [merged] mm-highmem-remove-useless-pool_lock.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:29 -0800
Message-ID: <20121212195829.B6BD2100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:64672 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT6b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:58:31 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so116658vbi.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:58:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, a.p.zijlstra@chello.nl, mel@csn.ul.ie, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, highmem: remove useless pool_lock
has been removed from the -mm tree.  Its filename was
     mm-highmem-remove-useless-pool_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -328,7 +328,6 @@ struct page_address_map {
  * page_address_map freelist, allocated from page_address_maps.
  */
 static struct list_head page_address_pool;	/* freelist */
-static spinlock_t pool_lock;			/* protects page_address_pool */
 
 /*
  * Hash table bucket
@@ -395,11 +394,9 @@ void set_page_address(struct page *page,
 	if (virtual) {		/* Add */
 		BUG_ON(list_empty(&page_address_pool));
 
-		spin_lock_irqsave(&pool_lock, flags);
 		pam = list_entry(page_address_pool.next,
 				struct page_address_map, list);
 		list_del(&pam->list);
-		spin_unlock_irqrestore(&pool_lock, flags);
 
 		pam->page = page;
 		pam->virtual = virtual;
@@ -413,9 +410,7 @@ void set_page_address(struct page *page,
 			if (pam->page == page) {
 				list_del(&pam->list);
 				spin_unlock_irqrestore(&pas->lock, flags);
-				spin_lock_irqsave(&pool_lock, flags);
 				list_add_tail(&pam->list, &page_address_pool);
-				spin_unlock_irqrestore(&pool_lock, flags);
 				goto done;
 			}
 		}
@@ -438,7 +433,6 @@ void __init page_address_init(void)
 		INIT_LIST_HEAD(&page_address_htable[i].lh);
 		spin_lock_init(&page_address_htable[i].lock);
 	}
-	spin_lock_init(&pool_lock);
 }
 
 #endif	/* defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL) */
_

Patches currently in -mm which might be from js1304@gmail.com are

origin.patch
bootmem-remove-not-implemented-function-call-bootmem_arch_preferred_node.patch
bootmem-remove-alloc_arch_preferred_bootmem.patch
mm-warn_on_once-if-f_op-mmap-change-vmas-start-address.patch
linux-next.patch

