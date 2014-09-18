From: akpm@linux-foundation.org
Subject: + memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
 added to -mm tree
Date: Thu, 18 Sep 2014 12:12:07 -0700
Message-ID: <541b2e87.M7yvdZac+cV4cMIO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaIRTMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 15:12:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, glommer@parallels.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: move memcg_{alloc,free}_cache_params to slab_common.c
has been added to the -mm tree.  Its filename is
     memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: move memcg_{alloc,free}_cache_params to slab_common.c

The only reason why they live in memcontrol.c is that we get/put css
reference to the owner memory cgroup in them.  However, we can do that in
memcg_{un,}register_cache.

So let's move them to slab_common.c and make them static.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 -----------
 mm/memcontrol.c            |   41 +++-----------------------------
 mm/slab_common.c           |   44 ++++++++++++++++++++++++++++++++++-
 3 files changed, 47 insertions(+), 52 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-move-memcg_allocfree_cache_params-to-slab_commonc include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-move-memcg_allocfree_cache_params-to-slab_commonc
+++ a/include/linux/memcontrol.h
@@ -440,10 +440,6 @@ void __memcg_kmem_uncharge_pages(struct
 
 int memcg_cache_id(struct mem_cgroup *memcg);
 
-int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
-			     struct kmem_cache *root_cache);
-void memcg_free_cache_params(struct kmem_cache *s);
-
 int memcg_update_cache_size(struct kmem_cache *s, int num_groups);
 void memcg_update_array_size(int num_groups);
 
@@ -574,16 +570,6 @@ static inline int memcg_cache_id(struct
 	return -1;
 }
 
-static inline int memcg_alloc_cache_params(struct mem_cgroup *memcg,
-		struct kmem_cache *s, struct kmem_cache *root_cache)
-{
-	return 0;
-}
-
-static inline void memcg_free_cache_params(struct kmem_cache *s)
-{
-}
-
 static inline struct kmem_cache *
 memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
 {
diff -puN mm/memcontrol.c~memcg-move-memcg_allocfree_cache_params-to-slab_commonc mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move-memcg_allocfree_cache_params-to-slab_commonc
+++ a/mm/memcontrol.c
@@ -2970,43 +2970,6 @@ int memcg_update_cache_size(struct kmem_
 	return 0;
 }
 
-int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
-			     struct kmem_cache *root_cache)
-{
-	size_t size;
-
-	if (!memcg_kmem_enabled())
-		return 0;
-
-	if (!memcg) {
-		size = offsetof(struct memcg_cache_params, memcg_caches);
-		size += memcg_limited_groups_array_size * sizeof(void *);
-	} else
-		size = sizeof(struct memcg_cache_params);
-
-	s->memcg_params = kzalloc(size, GFP_KERNEL);
-	if (!s->memcg_params)
-		return -ENOMEM;
-
-	if (memcg) {
-		s->memcg_params->memcg = memcg;
-		s->memcg_params->root_cache = root_cache;
-		css_get(&memcg->css);
-	} else
-		s->memcg_params->is_root_cache = true;
-
-	return 0;
-}
-
-void memcg_free_cache_params(struct kmem_cache *s)
-{
-	if (!s->memcg_params)
-		return;
-	if (!s->memcg_params->is_root_cache)
-		css_put(&s->memcg_params->memcg->css);
-	kfree(s->memcg_params);
-}
-
 static void memcg_register_cache(struct mem_cgroup *memcg,
 				 struct kmem_cache *root_cache)
 {
@@ -3037,6 +3000,7 @@ static void memcg_register_cache(struct
 	if (!cachep)
 		return;
 
+	css_get(&memcg->css);
 	list_add(&cachep->memcg_params->list, &memcg->memcg_slab_caches);
 
 	/*
@@ -3070,6 +3034,9 @@ static void memcg_unregister_cache(struc
 	list_del(&cachep->memcg_params->list);
 
 	kmem_cache_destroy(cachep);
+
+	/* drop the reference taken in memcg_register_cache */
+	css_put(&memcg->css);
 }
 
 /*
diff -puN mm/slab_common.c~memcg-move-memcg_allocfree_cache_params-to-slab_commonc mm/slab_common.c
--- a/mm/slab_common.c~memcg-move-memcg_allocfree_cache_params-to-slab_commonc
+++ a/mm/slab_common.c
@@ -88,6 +88,38 @@ static inline int kmem_cache_sanity_chec
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
+static int memcg_alloc_cache_params(struct mem_cgroup *memcg,
+		struct kmem_cache *s, struct kmem_cache *root_cache)
+{
+	size_t size;
+
+	if (!memcg_kmem_enabled())
+		return 0;
+
+	if (!memcg) {
+		size = offsetof(struct memcg_cache_params, memcg_caches);
+		size += memcg_limited_groups_array_size * sizeof(void *);
+	} else
+		size = sizeof(struct memcg_cache_params);
+
+	s->memcg_params = kzalloc(size, GFP_KERNEL);
+	if (!s->memcg_params)
+		return -ENOMEM;
+
+	if (memcg) {
+		s->memcg_params->memcg = memcg;
+		s->memcg_params->root_cache = root_cache;
+	} else
+		s->memcg_params->is_root_cache = true;
+
+	return 0;
+}
+
+static void memcg_free_cache_params(struct kmem_cache *s)
+{
+	kfree(s->memcg_params);
+}
+
 int memcg_update_all_caches(int num_memcgs)
 {
 	struct kmem_cache *s;
@@ -113,7 +145,17 @@ out:
 	mutex_unlock(&slab_mutex);
 	return ret;
 }
-#endif
+#else
+static inline int memcg_alloc_cache_params(struct mem_cgroup *memcg,
+		struct kmem_cache *s, struct kmem_cache *root_cache)
+{
+	return 0;
+}
+
+static inline void memcg_free_cache_params(struct kmem_cache *s)
+{
+}
+#endif /* CONFIG_MEMCG_KMEM */
 
 /*
  * Figure out what the alignment of the objects will be given a set of
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
linux-next.patch

