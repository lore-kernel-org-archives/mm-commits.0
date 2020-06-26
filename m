From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 13/32] slub: cure list_slab_objects() from double
 fix
Date: Thu, 25 Jun 2020 20:29:55 -0700
Message-ID: <20200626032955.fHMaoceJl%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728333AbgFZD34 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 23:29:56 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bigeasy@linutronix.de, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, tglx@linutronix.de, torvalds@linux-foundation.org, yuzhao@google.com

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: slub: cure list_slab_objects() from double fix

According to Christopher Lameter two fixes have been merged for the same
problem.  As far as I can tell, the code does not acquire the list_lock
and invoke kmalloc().  list_slab_objects() misses an unlock (the
counterpart to get_map()) and the memory allocated in free_partial() isn't
used.

Revert the mentioned commit.

Link: http://lkml.kernel.org/r/20200618201234.795692-1-bigeasy@linutronix.de
Fixes: aa456c7aebb14 ("slub: remove kmalloc under list_lock from list_slab_objects() V2")
Link: https://lkml.kernel.org/r/alpine.DEB.2.22.394.2006181501480.12014@www.lameter.com
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/mm/slub.c~slub-cure-list_slab_objects-from-double-fix
+++ a/mm/slub.c
@@ -3766,15 +3766,13 @@ error:
 }
 
 static void list_slab_objects(struct kmem_cache *s, struct page *page,
-			      const char *text, unsigned long *map)
+			      const char *text)
 {
 #ifdef CONFIG_SLUB_DEBUG
 	void *addr = page_address(page);
+	unsigned long *map;
 	void *p;
 
-	if (!map)
-		return;
-
 	slab_err(s, page, text, s->name);
 	slab_lock(page);
 
@@ -3786,6 +3784,7 @@ static void list_slab_objects(struct kme
 			print_tracking(s, p);
 		}
 	}
+	put_map(map);
 	slab_unlock(page);
 #endif
 }
@@ -3799,11 +3798,6 @@ static void free_partial(struct kmem_cac
 {
 	LIST_HEAD(discard);
 	struct page *page, *h;
-	unsigned long *map = NULL;
-
-#ifdef CONFIG_SLUB_DEBUG
-	map = bitmap_alloc(oo_objects(s->max), GFP_KERNEL);
-#endif
 
 	BUG_ON(irqs_disabled());
 	spin_lock_irq(&n->list_lock);
@@ -3813,16 +3807,11 @@ static void free_partial(struct kmem_cac
 			list_add(&page->slab_list, &discard);
 		} else {
 			list_slab_objects(s, page,
-			  "Objects remaining in %s on __kmem_cache_shutdown()",
-			  map);
+			  "Objects remaining in %s on __kmem_cache_shutdown()");
 		}
 	}
 	spin_unlock_irq(&n->list_lock);
 
-#ifdef CONFIG_SLUB_DEBUG
-	bitmap_free(map);
-#endif
