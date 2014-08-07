From: akpm@linux-foundation.org
Subject: [merged]
 slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:03:13 -0700
Message-ID: <53e3db81.tq0pZdrhk0OvK1H8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:58511 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaHGUDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:14 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so611757ykq.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: use the lock on alien_cache, instead of the lock on array_cache
has been removed from the -mm tree.  Its filename was
     slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slab: use the lock on alien_cache, instead of the lock on array_cache

Now, we have separate alien_cache structure, so it'd be better to hold the
lock on alien_cache while manipulating alien_cache.  After that, we don't
need the lock on array_cache, so remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff -puN mm/slab.c~slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache mm/slab.c
--- a/mm/slab.c~slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache
+++ a/mm/slab.c
@@ -191,7 +191,6 @@ struct array_cache {
 	unsigned int limit;
 	unsigned int batchcount;
 	unsigned int touched;
-	spinlock_t lock;
 	void *entry[];	/*
 			 * Must have this definition in here for the proper
 			 * alignment of array_cache. Also simplifies accessing
@@ -512,7 +511,7 @@ static void slab_set_lock_classes(struct
 		return;
 	for_each_node(r) {
 		if (alc[r])
-			lockdep_set_class(&(alc[r]->ac.lock), alc_key);
+			lockdep_set_class(&(alc[r]->lock), alc_key);
 	}
 }
 
@@ -811,7 +810,6 @@ static void init_arraycache(struct array
 		ac->limit = limit;
 		ac->batchcount = batch;
 		ac->touched = 0;
-		spin_lock_init(&ac->lock);
 	}
 }
 
@@ -1010,6 +1008,7 @@ static struct alien_cache *__alloc_alien
 
 	alc = kmalloc_node(memsize, gfp, node);
 	init_arraycache(&alc->ac, entries, batch);
+	spin_lock_init(&alc->lock);
 	return alc;
 }
 
@@ -1086,9 +1085,9 @@ static void reap_alien(struct kmem_cache
 
 		if (alc) {
 			ac = &alc->ac;
-			if (ac->avail && spin_trylock_irq(&ac->lock)) {
+			if (ac->avail && spin_trylock_irq(&alc->lock)) {
 				__drain_alien_cache(cachep, ac, node);
-				spin_unlock_irq(&ac->lock);
+				spin_unlock_irq(&alc->lock);
 			}
 		}
 	}
@@ -1106,9 +1105,9 @@ static void drain_alien_cache(struct kme
 		alc = alien[i];
 		if (alc) {
 			ac = &alc->ac;
-			spin_lock_irqsave(&ac->lock, flags);
+			spin_lock_irqsave(&alc->lock, flags);
 			__drain_alien_cache(cachep, ac, i);
-			spin_unlock_irqrestore(&ac->lock, flags);
+			spin_unlock_irqrestore(&alc->lock, flags);
 		}
 	}
 }
@@ -1136,13 +1135,13 @@ static inline int cache_free_alien(struc
 	if (n->alien && n->alien[nodeid]) {
 		alien = n->alien[nodeid];
 		ac = &alien->ac;
-		spin_lock(&ac->lock);
+		spin_lock(&alien->lock);
 		if (unlikely(ac->avail == ac->limit)) {
 			STATS_INC_ACOVERFLOW(cachep);
 			__drain_alien_cache(cachep, ac, nodeid);
 		}
 		ac_put_obj(cachep, ac, objp);
-		spin_unlock(&ac->lock);
+		spin_unlock(&alien->lock);
 	} else {
 		n = get_node(cachep, nodeid);
 		spin_lock(&n->list_lock);
@@ -1613,10 +1612,6 @@ void __init kmem_cache_init(void)
 
 		memcpy(ptr, cpu_cache_get(kmem_cache),
 		       sizeof(struct arraycache_init));
-		/*
-		 * Do not assume that spinlocks can be initialized via memcpy:
-		 */
-		spin_lock_init(&ptr->lock);
 
 		kmem_cache->array[smp_processor_id()] = ptr;
 
@@ -1626,10 +1621,6 @@ void __init kmem_cache_init(void)
 		       != &initarray_generic.cache);
 		memcpy(ptr, cpu_cache_get(kmalloc_caches[INDEX_AC]),
 		       sizeof(struct arraycache_init));
-		/*
-		 * Do not assume that spinlocks can be initialized via memcpy:
-		 */
-		spin_lock_init(&ptr->lock);
 
 		kmalloc_caches[INDEX_AC]->array[smp_processor_id()] = ptr;
 	}
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

