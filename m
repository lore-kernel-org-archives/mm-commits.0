From: akpm@linux-foundation.org
Subject: [merged] slb-allocate-objects-from-memcg-cache.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:41:42 -0800
Message-ID: <20121219204142.DBECE82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:36654 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab2LSUlp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:41:45 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so309343qaq.5
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:41:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sl[au]b: allocate objects from memcg cache
has been removed from the -mm tree.  Its filename was
     slb-allocate-objects-from-memcg-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: sl[au]b: allocate objects from memcg cache

We are able to match a cache allocation to a particular memcg.  If the
task doesn't change groups during the allocation itself - a rare event,
this will give us a good picture about who is the first group to touch a
cache page.

This patch uses the now available infrastructure by calling
memcg_kmem_get_cache() before all the cache allocations.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    5 ++++-
 mm/memcontrol.c          |    3 +++
 mm/slab.c                |    6 +++++-
 mm/slub.c                |    7 ++++---
 4 files changed, 16 insertions(+), 5 deletions(-)

diff -puN include/linux/slub_def.h~slb-allocate-objects-from-memcg-cache include/linux/slub_def.h
--- a/include/linux/slub_def.h~slb-allocate-objects-from-memcg-cache
+++ a/include/linux/slub_def.h
@@ -225,7 +225,10 @@ void *__kmalloc(size_t size, gfp_t flags
 static __always_inline void *
 kmalloc_order(size_t size, gfp_t flags, unsigned int order)
 {
-	void *ret = (void *) __get_free_pages(flags | __GFP_COMP, order);
+	void *ret;
+
+	flags |= (__GFP_COMP | __GFP_KMEMCG);
+	ret = (void *) __get_free_pages(flags, order);
 	kmemleak_alloc(ret, size, 1, flags);
 	return ret;
 }
diff -puN mm/memcontrol.c~slb-allocate-objects-from-memcg-cache mm/memcontrol.c
--- a/mm/memcontrol.c~slb-allocate-objects-from-memcg-cache
+++ a/mm/memcontrol.c
@@ -3086,6 +3086,9 @@ static struct kmem_cache *kmem_cache_dup
 	new = kmem_cache_create_memcg(memcg, name, s->object_size, s->align,
 				      (s->flags & ~SLAB_PANIC), s->ctor);
 
+	if (new)
+		new->allocflags |= __GFP_KMEMCG;
+
 	kfree(name);
 	return new;
 }
diff -puN mm/slab.c~slb-allocate-objects-from-memcg-cache mm/slab.c
--- a/mm/slab.c~slb-allocate-objects-from-memcg-cache
+++ a/mm/slab.c
@@ -1933,7 +1933,7 @@ static void kmem_freepages(struct kmem_c
 	}
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += nr_freed;
-	free_pages((unsigned long)addr, cachep->gfporder);
+	free_memcg_kmem_pages((unsigned long)addr, cachep->gfporder);
 }
 
 static void kmem_rcu_free(struct rcu_head *head)
@@ -3486,6 +3486,8 @@ slab_alloc_node(struct kmem_cache *cache
 	if (slab_should_failslab(cachep, flags))
 		return NULL;
 
+	cachep = memcg_kmem_get_cache(cachep, flags);
+
 	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 
@@ -3571,6 +3573,8 @@ slab_alloc(struct kmem_cache *cachep, gf
 	if (slab_should_failslab(cachep, flags))
 		return NULL;
 
+	cachep = memcg_kmem_get_cache(cachep, flags);
+
 	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 	objp = __do_cache_alloc(cachep, flags);
diff -puN mm/slub.c~slb-allocate-objects-from-memcg-cache mm/slub.c
--- a/mm/slub.c~slb-allocate-objects-from-memcg-cache
+++ a/mm/slub.c
@@ -1405,7 +1405,7 @@ static void __free_slab(struct kmem_cach
 	reset_page_mapcount(page);
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
-	__free_pages(page, order);
+	__free_memcg_kmem_pages(page, order);
 }
 
 #define need_reserve_slab_rcu						\
@@ -2323,6 +2323,7 @@ static __always_inline void *slab_alloc_
 	if (slab_pre_alloc_hook(s, gfpflags))
 		return NULL;
 
+	s = memcg_kmem_get_cache(s, gfpflags);
 redo:
 
 	/*
@@ -3284,7 +3285,7 @@ static void *kmalloc_large_node(size_t s
 	struct page *page;
 	void *ptr = NULL;
 
-	flags |= __GFP_COMP | __GFP_NOTRACK;
+	flags |= __GFP_COMP | __GFP_NOTRACK | __GFP_KMEMCG;
 	page = alloc_pages_node(node, flags, get_order(size));
 	if (page)
 		ptr = page_address(page);
@@ -3390,7 +3391,7 @@ void kfree(const void *x)
 	if (unlikely(!PageSlab(page))) {
 		BUG_ON(!PageCompound(page));
 		kmemleak_free(x);
-		__free_pages(page, compound_order(page));
+		__free_memcg_kmem_pages(page, compound_order(page));
 		return;
 	}
 	slab_free(page->slab_cache, page, object, _RET_IP_);
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

