From: akpm@linux-foundation.org
Subject: [patch 034/142] slab: introduce __kmemcg_cache_deactivate()
Date: Wed, 22 Feb 2017 15:41:27 -0800
Message-ID: <58ae21a7.63+Ar3XkL2xy6ySJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48280 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934483AbdBVXmC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov.dev@gmail.com

From: Tejun Heo <tj@kernel.org>
Subject: slab: introduce __kmemcg_cache_deactivate()

__kmem_cache_shrink() is called with %true @deactivate only for memcg
caches.  Remove @deactivate from __kmem_cache_shrink() and introduce
__kmemcg_cache_deactivate() instead.  Each memcg-supporting allocator
should implement it and it should deactivate and drain the cache.

This is to allow memcg cache deactivation behavior to further deviate from
simple shrinking without messing up __kmem_cache_shrink().

This is pure reorganization and doesn't introduce any observable behavior
changes.

v2: Dropped unnecessary ifdef in mm/slab.h as suggested by Vladimir.

Link: http://lkml.kernel.org/r/20170117235411.9408-8-tj@kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |   11 +++++++++--
 mm/slab.h        |    3 ++-
 mm/slab_common.c |    4 ++--
 mm/slob.c        |    2 +-
 mm/slub.c        |   39 ++++++++++++++++++++++-----------------
 5 files changed, 36 insertions(+), 23 deletions(-)

diff -puN mm/slab.c~slab-introduce-__kmemcg_cache_deactivate mm/slab.c
--- a/mm/slab.c~slab-introduce-__kmemcg_cache_deactivate
+++ a/mm/slab.c
@@ -2315,7 +2315,7 @@ out:
 	return nr_freed;
 }
 
-int __kmem_cache_shrink(struct kmem_cache *cachep, bool deactivate)
+int __kmem_cache_shrink(struct kmem_cache *cachep)
 {
 	int ret = 0;
 	int node;
@@ -2333,9 +2333,16 @@ int __kmem_cache_shrink(struct kmem_cach
 	return (ret ? 1 : 0);
 }
 
+#ifdef CONFIG_MEMCG
+void __kmemcg_cache_deactivate(struct kmem_cache *cachep)
+{
+	__kmem_cache_shrink(cachep);
+}
+#endif
+
 int __kmem_cache_shutdown(struct kmem_cache *cachep)
 {
-	return __kmem_cache_shrink(cachep, false);
+	return __kmem_cache_shrink(cachep);
 }
 
 void __kmem_cache_release(struct kmem_cache *cachep)
diff -puN mm/slab.h~slab-introduce-__kmemcg_cache_deactivate mm/slab.h
--- a/mm/slab.h~slab-introduce-__kmemcg_cache_deactivate
+++ a/mm/slab.h
@@ -167,7 +167,8 @@ static inline unsigned long kmem_cache_f
 
 int __kmem_cache_shutdown(struct kmem_cache *);
 void __kmem_cache_release(struct kmem_cache *);
-int __kmem_cache_shrink(struct kmem_cache *, bool);
+int __kmem_cache_shrink(struct kmem_cache *);
+void __kmemcg_cache_deactivate(struct kmem_cache *s);
 void slab_kmem_cache_release(struct kmem_cache *);
 
 struct seq_file;
diff -puN mm/slab_common.c~slab-introduce-__kmemcg_cache_deactivate mm/slab_common.c
--- a/mm/slab_common.c~slab-introduce-__kmemcg_cache_deactivate
+++ a/mm/slab_common.c
@@ -646,7 +646,7 @@ void memcg_deactivate_kmem_caches(struct
 		if (!c)
 			continue;
 
-		__kmem_cache_shrink(c, true);
+		__kmemcg_cache_deactivate(c);
 		arr->entries[idx] = NULL;
 	}
 	mutex_unlock(&slab_mutex);
@@ -794,7 +794,7 @@ int kmem_cache_shrink(struct kmem_cache
 	get_online_cpus();
 	get_online_mems();
 	kasan_cache_shrink(cachep);
-	ret = __kmem_cache_shrink(cachep, false);
+	ret = __kmem_cache_shrink(cachep);
 	put_online_mems();
 	put_online_cpus();
 	return ret;
diff -puN mm/slob.c~slab-introduce-__kmemcg_cache_deactivate mm/slob.c
--- a/mm/slob.c~slab-introduce-__kmemcg_cache_deactivate
+++ a/mm/slob.c
@@ -634,7 +634,7 @@ void __kmem_cache_release(struct kmem_ca
 {
 }
 
-int __kmem_cache_shrink(struct kmem_cache *d, bool deactivate)
+int __kmem_cache_shrink(struct kmem_cache *d)
 {
 	return 0;
 }
diff -puN mm/slub.c~slab-introduce-__kmemcg_cache_deactivate mm/slub.c
--- a/mm/slub.c~slab-introduce-__kmemcg_cache_deactivate
+++ a/mm/slub.c
@@ -3894,7 +3894,7 @@ EXPORT_SYMBOL(kfree);
  * being allocated from last increasing the chance that the last objects
  * are freed in them.
  */
-int __kmem_cache_shrink(struct kmem_cache *s, bool deactivate)
+int __kmem_cache_shrink(struct kmem_cache *s)
 {
 	int node;
 	int i;
@@ -3906,21 +3906,6 @@ int __kmem_cache_shrink(struct kmem_cach
 	unsigned long flags;
 	int ret = 0;
 
-	if (deactivate) {
-		/*
-		 * Disable empty slabs caching. Used to avoid pinning offline
-		 * memory cgroups by kmem pages that can be freed.
-		 */
-		s->cpu_partial = 0;
-		s->min_partial = 0;
-
-		/*
-		 * s->cpu_partial is checked locklessly (see put_cpu_partial),
-		 * so we have to make sure the change is visible.
-		 */
-		synchronize_sched();
-	}
-
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
 		INIT_LIST_HEAD(&discard);
@@ -3971,13 +3956,33 @@ int __kmem_cache_shrink(struct kmem_cach
 	return ret;
 }
 
+#ifdef CONFIG_MEMCG
+void __kmemcg_cache_deactivate(struct kmem_cache *s)
+{
+	/*
+	 * Disable empty slabs caching. Used to avoid pinning offline
+	 * memory cgroups by kmem pages that can be freed.
+	 */
+	s->cpu_partial = 0;
+	s->min_partial = 0;
+
+	/*
+	 * s->cpu_partial is checked locklessly (see put_cpu_partial), so
+	 * we have to make sure the change is visible.
+	 */
+	synchronize_sched();
+
+	__kmem_cache_shrink(s);
+}
+#endif
+
 static int slab_mem_going_offline_callback(void *arg)
 {
 	struct kmem_cache *s;
 
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list)
-		__kmem_cache_shrink(s, false);
+		__kmem_cache_shrink(s);
 	mutex_unlock(&slab_mutex);
 
 	return 0;
_
