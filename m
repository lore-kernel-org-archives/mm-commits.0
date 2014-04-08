From: akpm@linux-foundation.org
Subject: [merged] memcg-slab-never-try-to-merge-memcg-caches.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:41:21 -0700
Message-ID: <53446d01.dLmt2ogW3Ks6e6vj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbaDHVlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:41:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@gmail.com, vdavydov@parallels.com

Subject: [merged] memcg-slab-never-try-to-merge-memcg-caches.patch removed from -mm tree
To: vdavydov@parallels.com,glommer@gmail.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:41:21 -0700


The patch titled
     Subject: memcg, slab: never try to merge memcg caches
has been removed from the -mm tree.  Its filename was
     memcg-slab-never-try-to-merge-memcg-caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg, slab: never try to merge memcg caches

When a kmem cache is created (kmem_cache_create_memcg()), we first try to
find a compatible cache that already exists and can handle requests from
the new cache, i.e.  has the same object size, alignment, ctor, etc.  If
there is such a cache, we do not create any new caches, instead we simply
increment the refcount of the cache found and return it.

Currently we do this procedure not only when creating root caches, but
also for memcg caches.  However, there is no point in that, because, as
every memcg cache has exactly the same parameters as its parent and cache
merging cannot be turned off in runtime (only on boot by passing
"slub_nomerge"), the root caches of any two potentially mergeable memcg
caches should be merged already, i.e.  it must be the same root cache, and
therefore we couldn't even get to the memcg cache creation, because it
already exists.

The only exception is boot caches - they are explicitly forbidden to be
merged by setting their refcount to -1.  There are currently only two of
them - kmem_cache and kmem_cache_node, which are used in slab internals (I
do not count kmalloc caches as their refcount is set to 1 immediately
after creation).  Since they are prevented from merging preliminary I
guess we should avoid to merge their children too.

So let's remove the useless code responsible for merging memcg caches.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Glauber Costa <glommer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h        |   21 ++++-----------------
 mm/slab_common.c |    8 +++++---
 mm/slub.c        |   19 +++++++++----------
 3 files changed, 18 insertions(+), 30 deletions(-)

diff -puN mm/slab.h~memcg-slab-never-try-to-merge-memcg-caches mm/slab.h
--- a/mm/slab.h~memcg-slab-never-try-to-merge-memcg-caches
+++ a/mm/slab.h
@@ -55,12 +55,12 @@ extern void create_boot_cache(struct kme
 struct mem_cgroup;
 #ifdef CONFIG_SLUB
 struct kmem_cache *
-__kmem_cache_alias(struct mem_cgroup *memcg, const char *name, size_t size,
-		   size_t align, unsigned long flags, void (*ctor)(void *));
+__kmem_cache_alias(const char *name, size_t size, size_t align,
+		   unsigned long flags, void (*ctor)(void *));
 #else
 static inline struct kmem_cache *
-__kmem_cache_alias(struct mem_cgroup *memcg, const char *name, size_t size,
-		   size_t align, unsigned long flags, void (*ctor)(void *))
+__kmem_cache_alias(const char *name, size_t size, size_t align,
+		   unsigned long flags, void (*ctor)(void *))
 { return NULL; }
 #endif
 
@@ -119,13 +119,6 @@ static inline bool is_root_cache(struct
 	return !s->memcg_params || s->memcg_params->is_root_cache;
 }
 
-static inline bool cache_match_memcg(struct kmem_cache *cachep,
-				     struct mem_cgroup *memcg)
-{
-	return (is_root_cache(cachep) && !memcg) ||
-				(cachep->memcg_params->memcg == memcg);
-}
-
 static inline void memcg_bind_pages(struct kmem_cache *s, int order)
 {
 	if (!is_root_cache(s))
@@ -203,12 +196,6 @@ static inline bool is_root_cache(struct
 {
 	return true;
 }
-
-static inline bool cache_match_memcg(struct kmem_cache *cachep,
-				     struct mem_cgroup *memcg)
-{
-	return true;
-}
 
 static inline void memcg_bind_pages(struct kmem_cache *s, int order)
 {
diff -puN mm/slab_common.c~memcg-slab-never-try-to-merge-memcg-caches mm/slab_common.c
--- a/mm/slab_common.c~memcg-slab-never-try-to-merge-memcg-caches
+++ a/mm/slab_common.c
@@ -200,9 +200,11 @@ kmem_cache_create_memcg(struct mem_cgrou
 	 */
 	flags &= CACHE_CREATE_MASK;
 
-	s = __kmem_cache_alias(memcg, name, size, align, flags, ctor);
-	if (s)
-		goto out_unlock;
+	if (!memcg) {
+		s = __kmem_cache_alias(name, size, align, flags, ctor);
+		if (s)
+			goto out_unlock;
+	}
 
 	err = -ENOMEM;
 	s = kmem_cache_zalloc(kmem_cache, GFP_KERNEL);
diff -puN mm/slub.c~memcg-slab-never-try-to-merge-memcg-caches mm/slub.c
--- a/mm/slub.c~memcg-slab-never-try-to-merge-memcg-caches
+++ a/mm/slub.c
@@ -3685,6 +3685,9 @@ static int slab_unmergeable(struct kmem_
 	if (slub_nomerge || (s->flags & SLUB_NEVER_MERGE))
 		return 1;
 
+	if (!is_root_cache(s))
+		return 1;
+
 	if (s->ctor)
 		return 1;
 
@@ -3697,9 +3700,8 @@ static int slab_unmergeable(struct kmem_
 	return 0;
 }
 
-static struct kmem_cache *find_mergeable(struct mem_cgroup *memcg, size_t size,
-		size_t align, unsigned long flags, const char *name,
-		void (*ctor)(void *))
+static struct kmem_cache *find_mergeable(size_t size, size_t align,
+		unsigned long flags, const char *name, void (*ctor)(void *))
 {
 	struct kmem_cache *s;
 
@@ -3722,7 +3724,7 @@ static struct kmem_cache *find_mergeable
 			continue;
 
 		if ((flags & SLUB_MERGE_SAME) != (s->flags & SLUB_MERGE_SAME))
-				continue;
+			continue;
 		/*
 		 * Check if alignment is compatible.
 		 * Courtesy of Adrian Drzewiecki
@@ -3733,21 +3735,18 @@ static struct kmem_cache *find_mergeable
 		if (s->size - size >= sizeof(void *))
 			continue;
 
-		if (!cache_match_memcg(s, memcg))
-			continue;
