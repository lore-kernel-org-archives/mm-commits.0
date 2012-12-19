From: akpm@linux-foundation.org
Subject: [merged] slab-propagate-tunable-values.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:42:08 -0800
Message-ID: <20121219204209.230F982004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:59598 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab2LSUmK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:42:10 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so278260yhr.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:42:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: propagate tunable values
has been removed from the -mm tree.  Its filename was
     slab-propagate-tunable-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -448,7 +448,8 @@ void __memcg_kmem_commit_charge(struct p
 void __memcg_kmem_uncharge_pages(struct page *page, int order);
 
 int memcg_cache_id(struct mem_cgroup *memcg);
-int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s);
+int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
+			 struct kmem_cache *root_cache);
 void memcg_release_cache(struct kmem_cache *cachep);
 void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep);
 
@@ -590,8 +591,9 @@ static inline int memcg_cache_id(struct 
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
@@ -130,7 +130,7 @@ struct kmem_cache *kmem_cache_create(con
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
@@ -3012,7 +3012,8 @@ int memcg_update_cache_size(struct kmem_
 	return 0;
 }
 
-int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s)
+int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
+			 struct kmem_cache *root_cache)
 {
 	size_t size = sizeof(struct memcg_cache_params);
 
@@ -3026,8 +3027,10 @@ int memcg_register_cache(struct mem_cgro
 	if (!s->memcg_params)
 		return -ENOMEM;
 
-	if (memcg)
+	if (memcg) {
 		s->memcg_params->memcg = memcg;
+		s->memcg_params->root_cache = root_cache;
+	}
 	return 0;
 }
 
@@ -3186,7 +3189,7 @@ static struct kmem_cache *kmem_cache_dup
 		return NULL;
 
 	new = kmem_cache_create_memcg(memcg, name, s->object_size, s->align,
-				      (s->flags & ~SLAB_PANIC), s->ctor);
+				      (s->flags & ~SLAB_PANIC), s->ctor, s);
 
 	if (new)
 		new->allocflags |= __GFP_KMEMCG;
@@ -3226,7 +3229,6 @@ static struct kmem_cache *memcg_create_k
 	}
 
 	mem_cgroup_get(memcg);
-	new_cachep->memcg_params->root_cache = cachep;
 	atomic_set(&new_cachep->memcg_params->nr_pages , 0);
 
 	cachep->memcg_params->memcg_caches[idx] = new_cachep;
diff -puN mm/slab.c~slab-propagate-tunable-values mm/slab.c
--- a/mm/slab.c~slab-propagate-tunable-values
+++ a/mm/slab.c
@@ -4041,7 +4041,7 @@ static void do_ccupdate_local(void *info
 }
 
 /* Always called with the slab_mutex held */
-static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
+static int __do_tune_cpucache(struct kmem_cache *cachep, int limit,
 				int batchcount, int shared, gfp_t gfp)
 {
 	struct ccupdate_struct *new;
@@ -4084,12 +4084,48 @@ static int do_tune_cpucache(struct kmem_
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
@@ -4131,7 +4167,9 @@ static int enable_cpucache(struct kmem_c
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
@@ -155,6 +155,13 @@ static inline struct kmem_cache *cache_f
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
@@ -190,6 +197,11 @@ static inline struct kmem_cache *cache_f
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
@@ -164,7 +164,8 @@ unsigned long calculate_alignment(unsign
 
 struct kmem_cache *
 kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
-			size_t align, unsigned long flags, void (*ctor)(void *))
+			size_t align, unsigned long flags, void (*ctor)(void *),
+			struct kmem_cache *parent_cache)
 {
 	struct kmem_cache *s = NULL;
 	int err = 0;
@@ -193,7 +194,7 @@ kmem_cache_create_memcg(struct mem_cgrou
 		s->align = calculate_alignment(flags, align, size);
 		s->ctor = ctor;
 
-		if (memcg_register_cache(memcg, s)) {
+		if (memcg_register_cache(memcg, s, parent_cache)) {
 			kmem_cache_free(kmem_cache, s);
 			err = -ENOMEM;
 			goto out_locked;
@@ -243,7 +244,7 @@ struct kmem_cache *
 kmem_cache_create(const char *name, size_t size, size_t align,
 		  unsigned long flags, void (*ctor)(void *))
 {
-	return kmem_cache_create_memcg(NULL, name, size, align, flags, ctor);
+	return kmem_cache_create_memcg(NULL, name, size, align, flags, ctor, NULL);
 }
 EXPORT_SYMBOL(kmem_cache_create);
 
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

