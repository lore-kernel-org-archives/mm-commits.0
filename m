From: akpm@linux-foundation.org
Subject: + slb-allocate-objects-from-memcg-cache.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:04:42 -0700
Message-ID: <20121102000442.8D860100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36051 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992641Ab2KBAEo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:04:44 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so365559ggm.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:04:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: sl[au]b: allocate objects from memcg cache
has been added to the -mm tree.  Its filename is
     slb-allocate-objects-from-memcg-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3059,6 +3059,9 @@ static struct kmem_cache *kmem_cache_dup
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
@@ -1974,7 +1974,7 @@ static void kmem_freepages(struct kmem_c
 	}
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += nr_freed;
-	free_pages((unsigned long)addr, cachep->gfporder);
+	free_memcg_kmem_pages((unsigned long)addr, cachep->gfporder);
 }
 
 static void kmem_rcu_free(struct rcu_head *head)
@@ -3541,6 +3541,8 @@ slab_alloc_node(struct kmem_cache *cache
 	if (slab_should_failslab(cachep, flags))
 		return NULL;
 
+	cachep = memcg_kmem_get_cache(cachep, flags);
+
 	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 
@@ -3626,6 +3628,8 @@ slab_alloc(struct kmem_cache *cachep, gf
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
@@ -1407,7 +1407,7 @@ static void __free_slab(struct kmem_cach
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
@@ -3346,7 +3347,7 @@ static void *kmalloc_large_node(size_t s
 	struct page *page;
 	void *ptr = NULL;
 
-	flags |= __GFP_COMP | __GFP_NOTRACK;
+	flags |= __GFP_COMP | __GFP_NOTRACK | __GFP_KMEMCG;
 	page = alloc_pages_node(node, flags, get_order(size));
 	if (page)
 		ptr = page_address(page);
@@ -3452,7 +3453,7 @@ void kfree(const void *x)
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

linux-next.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch

