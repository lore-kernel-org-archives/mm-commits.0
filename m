From: akpm@linux-foundation.org
Subject: [merged]
 slab_common-clear-pointers-to-per-memcg-caches-on-destroy.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:06:36 -0800
Message-ID: <563d084c.c58vBHp4uo/8LSS7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033202AbbKFUGh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common.c: clear pointers to per memcg caches on destroy
has been removed from the -mm tree.  Its filename was
     slab_common-clear-pointers-to-per-memcg-caches-on-destroy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm/slab_common.c: clear pointers to per memcg caches on destroy

Currently, we do not clear pointers to per memcg caches in the
memcg_params.memcg_caches array when a global cache is destroyed with
kmem_cache_destroy.

This is fine if the global cache does get destroyed.  However, a cache can
be left on the list if it still has active objects when kmem_cache_destroy
is called (due to a memory leak).  If this happens, the entries in the
array will point to already freed areas, which is likely to result in data
corruption when the cache is reused (via slab merging).

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h        |    6 --
 mm/slab_common.c |   93 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 78 insertions(+), 21 deletions(-)

diff -puN mm/slab.h~slab_common-clear-pointers-to-per-memcg-caches-on-destroy mm/slab.h
--- a/mm/slab.h~slab_common-clear-pointers-to-per-memcg-caches-on-destroy
+++ a/mm/slab.h
@@ -181,10 +181,6 @@ bool __kmem_cache_alloc_bulk(struct kmem
 	list_for_each_entry(iter, &(root)->memcg_params.list, \
 			    memcg_params.list)
 
-#define for_each_memcg_cache_safe(iter, tmp, root) \
-	list_for_each_entry_safe(iter, tmp, &(root)->memcg_params.list, \
-				 memcg_params.list)
-
 static inline bool is_root_cache(struct kmem_cache *s)
 {
 	return s->memcg_params.is_root_cache;
@@ -265,8 +261,6 @@ extern void slab_init_memcg_params(struc
 
 #define for_each_memcg_cache(iter, root) \
 	for ((void)(iter), (void)(root); 0; )
-#define for_each_memcg_cache_safe(iter, tmp, root) \
-	for ((void)(iter), (void)(tmp), (void)(root); 0; )
 
 static inline bool is_root_cache(struct kmem_cache *s)
 {
diff -puN mm/slab_common.c~slab_common-clear-pointers-to-per-memcg-caches-on-destroy mm/slab_common.c
--- a/mm/slab_common.c~slab_common-clear-pointers-to-per-memcg-caches-on-destroy
+++ a/mm/slab_common.c
@@ -461,10 +461,6 @@ static int shutdown_cache(struct kmem_ca
 	if (s->flags & SLAB_DESTROY_BY_RCU)
 		*need_rcu_barrier = true;
 
-#ifdef CONFIG_MEMCG_KMEM
-	if (!is_root_cache(s))
-		list_del(&s->memcg_params.list);
-#endif
 	list_move(&s->list, release);
 	return 0;
 }
@@ -597,6 +593,18 @@ void memcg_deactivate_kmem_caches(struct
 	put_online_cpus();
 }
 
+static int __shutdown_memcg_cache(struct kmem_cache *s,
+		struct list_head *release, bool *need_rcu_barrier)
+{
+	BUG_ON(is_root_cache(s));
+
+	if (shutdown_cache(s, release, need_rcu_barrier))
+		return -EBUSY;
+
+	list_del(&s->memcg_params.list);
+	return 0;
+}
+
 void memcg_destroy_kmem_caches(struct mem_cgroup *memcg)
 {
 	LIST_HEAD(release);
@@ -614,7 +622,7 @@ void memcg_destroy_kmem_caches(struct me
 		 * The cgroup is about to be freed and therefore has no charges
 		 * left. Hence, all its caches must be empty by now.
 		 */
-		BUG_ON(shutdown_cache(s, &release, &need_rcu_barrier));
+		BUG_ON(__shutdown_memcg_cache(s, &release, &need_rcu_barrier));
 	}
 	mutex_unlock(&slab_mutex);
 
@@ -623,6 +631,68 @@ void memcg_destroy_kmem_caches(struct me
 
 	release_caches(&release, need_rcu_barrier);
 }
+
+static int shutdown_memcg_caches(struct kmem_cache *s,
+		struct list_head *release, bool *need_rcu_barrier)
+{
+	struct memcg_cache_array *arr;
+	struct kmem_cache *c, *c2;
+	LIST_HEAD(busy);
+	int i;
+
+	BUG_ON(!is_root_cache(s));
+
+	/*
+	 * First, shutdown active caches, i.e. caches that belong to online
+	 * memory cgroups.
+	 */
+	arr = rcu_dereference_protected(s->memcg_params.memcg_caches,
+					lockdep_is_held(&slab_mutex));
+	for_each_memcg_cache_index(i) {
+		c = arr->entries[i];
+		if (!c)
+			continue;
+		if (__shutdown_memcg_cache(c, release, need_rcu_barrier))
+			/*
+			 * The cache still has objects. Move it to a temporary
+			 * list so as not to try to destroy it for a second
+			 * time while iterating over inactive caches below.
+			 */
+			list_move(&c->memcg_params.list, &busy);
+		else
+			/*
+			 * The cache is empty and will be destroyed soon. Clear
+			 * the pointer to it in the memcg_caches array so that
+			 * it will never be accessed even if the root cache
+			 * stays alive.
+			 */
+			arr->entries[i] = NULL;
+	}
+
+	/*
+	 * Second, shutdown all caches left from memory cgroups that are now
+	 * offline.
+	 */
+	list_for_each_entry_safe(c, c2, &s->memcg_params.list,
+				 memcg_params.list)
+		__shutdown_memcg_cache(c, release, need_rcu_barrier);
+
+	list_splice(&busy, &s->memcg_params.list);
+
+	/*
+	 * A cache being destroyed must be empty. In particular, this means
+	 * that all per memcg caches attached to it must be empty too.
+	 */
+	if (!list_empty(&s->memcg_params.list))
+		return -EBUSY;
+	return 0;
+}
+#else
+static inline int shutdown_memcg_caches(struct kmem_cache *s,
+		struct list_head *release, bool *need_rcu_barrier)
+{
+	return 0;
+}
 #endif /* CONFIG_MEMCG_KMEM */
 
 void slab_kmem_cache_release(struct kmem_cache *s)
@@ -634,16 +704,13 @@ void slab_kmem_cache_release(struct kmem
 
 void kmem_cache_destroy(struct kmem_cache *s)
 {
-	struct kmem_cache *c, *c2;
 	LIST_HEAD(release);
 	bool need_rcu_barrier = false;
-	bool busy = false;
+	int err;
 
 	if (unlikely(!s))
 		return;
 
-	BUG_ON(!is_root_cache(s));
-
 	get_online_cpus();
 	get_online_mems();
 
@@ -653,12 +720,8 @@ void kmem_cache_destroy(struct kmem_cach
 	if (s->refcount)
 		goto out_unlock;
 
-	for_each_memcg_cache_safe(c, c2, s) {
-		if (shutdown_cache(c, &release, &need_rcu_barrier))
-			busy = true;
-	}
