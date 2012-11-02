From: akpm@linux-foundation.org
Subject: + slab-propagate-tunable-values.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:05:10 -0700
Message-ID: <20121102000510.84BE1100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36051 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992683Ab2KBAFM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:05:12 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so365559ggm.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:05:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: slab: propagate tunable values
has been added to the -mm tree.  Its filename is
     slab-propagate-tunable-values.patch

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
Subject: slab: propagate tunable values

SLAB allows us to tune a particular cache behavior with tunables.  When
creating a new memcg cache copy, we'd like to preserve any tunables the
parent cache already had.

This could be done by an explicit call to do_tune_cpucache() after the
cache is created.  But this is not very convenient now that the caches are
created from common code, since this function is SLAB-specific.

Another method of doing that is taking advantage of the fact that
do_tune_cpucache() is always called from enable_cpucache(), which is
called at cache initialization.  We can just preset the values, and then
things work as expected.

It can also happen that a root cache has its tunables updated during
normal system operation.  In this case, we will propagate the change to
all caches that are already active.

This change will require us to move the assignment of root_cache in
memcg_params a bit earlier.  We need this to be already set - which
memcg_kmem_register_cache will do - when we reach __kmem_cache_create()

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

 include/linux/memcontrol.h |    8 +++---
 include/linux/slab.h       |    2 -
 mm/memcontrol.c            |   10 ++++---
 mm/slab.c                  |   44 ++++++++++++++++++++++++++++++++---
 mm/slab.h                  |   12 +++++++++
 mm/slab_common.c           |    7 +++--
 6 files changed, 69 insertions(+), 14 deletions(-)

diff -puN include/linux/memcontrol.h~slab-propagate-tunable-values include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~slab-propagate-tunable-values
+++ a/include/linux/memcontrol.h
@@ -441,7 +441,8 @@ void __memcg_kmem_commit_charge(struct p
 void __memcg_kmem_uncharge_pages(struct page *page, int order);
 
 int memcg_cache_id(struct mem_cgroup *memcg);
-int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s);
+int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
+			 struct kmem_cache *root_cache);
 void memcg_release_cache(struct kmem_cache *cachep);
 void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep);
 
@@ -583,8 +584,9 @@ static inline int memcg_cache_id(struct 
 	return -1;
 }
 
-static inline int memcg_register_cache(struct mem_cgroup *memcg,
-				       struct kmem_cache *s)
+static inline int
+memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
+		     struct kmem_cache *root_cache)
 {
 	return 0;
 }
diff -puN include/linux/slab.h~slab-propagate-tunable-values include/linux/slab.h
--- a/include/linux/slab.h~slab-propagate-tunable-values
+++ a/include/linux/slab.h
@@ -128,7 +128,7 @@ struct kmem_cache *kmem_cache_create(con
 			void (*)(void *));
 struct kmem_cache *
 kmem_cache_create_memcg(struct mem_cgroup *, const char *, size_t, size_t,
-			unsigned long, void (*)(void *));
+			unsigned long, void (*)(void *), struct kmem_cache *);
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
 void kmem_cache_free(struct kmem_cache *, void *);
diff -puN mm/memcontrol.c~slab-propagate-tunable-values mm/memcontrol.c
--- a/mm/memcontrol.c~slab-propagate-tunable-values
+++ a/mm/memcontrol.c
@@ -2981,7 +2981,8 @@ int memcg_update_cache_size(struct kmem_
 	return 0;
 }
 
-int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s)
+int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
+			 struct kmem_cache *root_cache)
 {
 	size_t size = sizeof(struct memcg_cache_params);
 
@@ -2995,8 +2996,10 @@ int memcg_register_cache(struct mem_cgro
 	if (!s->memcg_params)
 		return -ENOMEM;
 
-	if (memcg)
+	if (memcg) {
 		s->memcg_params->memcg = memcg;
+		s->memcg_params->root_cache = root_cache;
+	}
 	return 0;
 }
 
@@ -3162,7 +3165,7 @@ static struct kmem_cache *kmem_cache_dup
 		return NULL;
 
 	new = kmem_cache_create_memcg(memcg, name, s->object_size, s->align,
-				      (s->flags & ~SLAB_PANIC), s->ctor);
+				      (s->flags & ~SLAB_PANIC), s->ctor, s);
 
 	if (new)
 		new->allocflags |= __GFP_KMEMCG;
@@ -3206,7 +3209,6 @@ static struct kmem_cache *memcg_create_k
 	}
 
 	mem_cgroup_get(memcg);
-	new_cachep->memcg_params->root_cache = cachep;
 	atomic_set(&new_cachep->memcg_params->nr_pages , 0);
 
 	cachep->memcg_params->memcg_caches[idx] = new_cachep;
diff -puN mm/slab.c~slab-propagate-tunable-values mm/slab.c
--- a/mm/slab.c~slab-propagate-tunable-values
+++ a/mm/slab.c
@@ -4096,7 +4096,7 @@ static void do_ccupdate_local(void *info
 }
 
 /* Always called with the slab_mutex held */
-static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
+static int __do_tune_cpucache(struct kmem_cache *cachep, int limit,
 				int batchcount, int shared, gfp_t gfp)
 {
 	struct ccupdate_struct *new;
@@ -4139,12 +4139,48 @@ static int do_tune_cpucache(struct kmem_
 	return alloc_kmemlist(cachep, gfp);
 }
 
+static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
+				int batchcount, int shared, gfp_t gfp)
+{
+	int ret;
+	struct kmem_cache *c = NULL;
+	int i = 0;
+
+	ret = __do_tune_cpucache(cachep, limit, batchcount, shared, gfp);
+
+	if (slab_state < FULL)
+		return ret;
+
+	if ((ret < 0) || !is_root_cache(cachep))
+		return ret;
+
+	for_each_memcg_cache_index(i) {
+		c = cache_from_memcg(cachep, i);
+		if (c)
+			/* return value determined by the parent cache only */
+			__do_tune_cpucache(c, limit, batchcount, shared, gfp);
+	}
+
+	return ret;
+}
+
 /* Called with slab_mutex held always */
 static int enable_cpucache(struct kmem_cache *cachep, gfp_t gfp)
 {
 	int err;
-	int limit, shared;
+	int limit = 0;
+	int shared = 0;
+	int batchcount = 0;
+
+	if (!is_root_cache(cachep)) {
+		struct kmem_cache *root = memcg_root_cache(cachep);
+		limit = root->limit;
+		shared = root->shared;
+		batchcount = root->batchcount;
+	}
 
+	if (limit && shared && batchcount)
+		goto skip_setup;
 	/*
 	 * The head array serves three purposes:
 	 * - create a LIFO ordering, i.e. return objects that are cache-warm
@@ -4186,7 +4222,9 @@ static int enable_cpucache(struct kmem_c
 	if (limit > 32)
 		limit = 32;
 #endif
-	err = do_tune_cpucache(cachep, limit, (limit + 1) / 2, shared, gfp);
+	batchcount = (limit + 1) / 2;
+skip_setup:
+	err = do_tune_cpucache(cachep, limit, batchcount, shared, gfp);
 	if (err)
 		printk(KERN_ERR "enable_cpucache failed for %s, error %d.\n",
 		       cachep->name, -err);
diff -puN mm/slab.h~slab-propagate-tunable-values mm/slab.h
--- a/mm/slab.h~slab-propagate-tunable-values
+++ a/mm/slab.h
@@ -147,6 +147,13 @@ static inline struct kmem_cache *cache_f
 {
 	return s->memcg_params->memcg_caches[idx];
 }
+
+static inline struct kmem_cache *memcg_root_cache(struct kmem_cache *s)
+{
+	if (is_root_cache(s))
+		return s;
+	return s->memcg_params->root_cache;
+}
 #else
 static inline bool is_root_cache(struct kmem_cache *s)
 {
@@ -182,6 +189,11 @@ static inline struct kmem_cache *cache_f
 {
 	return NULL;
 }
+
+static inline struct kmem_cache *memcg_root_cache(struct kmem_cache *s)
+{
+	return s;
+}
 #endif
 
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
diff -puN mm/slab_common.c~slab-propagate-tunable-values mm/slab_common.c
--- a/mm/slab_common.c~slab-propagate-tunable-values
+++ a/mm/slab_common.c
@@ -136,7 +136,8 @@ out:
 
 struct kmem_cache *
 kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
-			size_t align, unsigned long flags, void (*ctor)(void *))
+			size_t align, unsigned long flags, void (*ctor)(void *),
+			struct kmem_cache *parent_cache)
 {
 	struct kmem_cache *s = NULL;
 	int err = 0;
@@ -165,7 +166,7 @@ kmem_cache_create_memcg(struct mem_cgrou
 		s->align = align;
 		s->ctor = ctor;
 
-		if (memcg_register_cache(memcg, s)) {
+		if (memcg_register_cache(memcg, s, parent_cache)) {
 			kmem_cache_free(kmem_cache, s);
 			err = -ENOMEM;
 			goto out_locked;
@@ -215,7 +216,7 @@ struct kmem_cache *
 kmem_cache_create(const char *name, size_t size, size_t align,
 		  unsigned long flags, void (*ctor)(void *))
 {
-	return kmem_cache_create_memcg(NULL, name, size, align, flags, ctor);
+	return kmem_cache_create_memcg(NULL, name, size, align, flags, ctor, NULL);
 }
 EXPORT_SYMBOL(kmem_cache_create);
 
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

