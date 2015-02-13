From: akpm@linux-foundation.org
Subject: [merged]
 slab-link-memcg-caches-of-the-same-kind-into-a-list.patch removed from -mm
 tree
Date: Fri, 13 Feb 2015 12:20:14 -0800
Message-ID: <54de5c7e.DiPoPb7w9I8TBklb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbbBMUUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: link memcg caches of the same kind into a list
has been removed from the -mm tree.  Its filename was
     slab-link-memcg-caches-of-the-same-kind-into-a-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: link memcg caches of the same kind into a list

Sometimes, we need to iterate over all memcg copies of a particular root
kmem cache.  Currently, we use memcg_cache_params->memcg_caches array for
that, because it contains all existing memcg caches.

However, it's a bad practice to keep all caches, including those that
belong to offline cgroups, in this array, because it will be growing
beyond any bounds then.  I'm going to wipe away dead caches from it to
save space.  To still be able to perform iterations over all memcg caches
of the same kind, let us link them into a list.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    4 ++++
 mm/slab.c            |   13 +++++--------
 mm/slab.h            |   17 +++++++++++++++++
 mm/slab_common.c     |   21 ++++++++++-----------
 mm/slub.c            |   19 +++++--------------
 5 files changed, 41 insertions(+), 33 deletions(-)

diff -puN include/linux/slab.h~slab-link-memcg-caches-of-the-same-kind-into-a-list include/linux/slab.h
--- a/include/linux/slab.h~slab-link-memcg-caches-of-the-same-kind-into-a-list
+++ a/include/linux/slab.h
@@ -491,9 +491,13 @@ struct memcg_cache_array {
  *
  * @memcg: pointer to the memcg this cache belongs to
  * @root_cache: pointer to the global, root cache, this cache was derived from
+ *
+ * Both root and child caches of the same kind are linked into a list chained
+ * through @list.
  */
 struct memcg_cache_params {
 	bool is_root_cache;
+	struct list_head list;
 	union {
 		struct memcg_cache_array __rcu *memcg_caches;
 		struct {
diff -puN mm/slab.c~slab-link-memcg-caches-of-the-same-kind-into-a-list mm/slab.c
--- a/mm/slab.c~slab-link-memcg-caches-of-the-same-kind-into-a-list
+++ a/mm/slab.c
@@ -3708,8 +3708,7 @@ static int do_tune_cpucache(struct kmem_
 				int batchcount, int shared, gfp_t gfp)
 {
 	int ret;
-	struct kmem_cache *c = NULL;
-	int i = 0;
+	struct kmem_cache *c;
 
 	ret = __do_tune_cpucache(cachep, limit, batchcount, shared, gfp);
 
@@ -3719,12 +3718,10 @@ static int do_tune_cpucache(struct kmem_
 	if ((ret < 0) || !is_root_cache(cachep))
 		return ret;
 
-	VM_BUG_ON(!mutex_is_locked(&slab_mutex));
-	for_each_memcg_cache_index(i) {
-		c = cache_from_memcg_idx(cachep, i);
-		if (c)
-			/* return value determined by the parent cache only */
-			__do_tune_cpucache(c, limit, batchcount, shared, gfp);
+	lockdep_assert_held(&slab_mutex);
+	for_each_memcg_cache(c, cachep) {
+		/* return value determined by the root cache only */
+		__do_tune_cpucache(c, limit, batchcount, shared, gfp);
 	}
 
 	return ret;
diff -puN mm/slab.h~slab-link-memcg-caches-of-the-same-kind-into-a-list mm/slab.h
--- a/mm/slab.h~slab-link-memcg-caches-of-the-same-kind-into-a-list
+++ a/mm/slab.h
@@ -163,6 +163,18 @@ ssize_t slabinfo_write(struct file *file
 		       size_t count, loff_t *ppos);
 
 #ifdef CONFIG_MEMCG_KMEM
+/*
+ * Iterate over all memcg caches of the given root cache. The caller must hold
+ * slab_mutex.
+ */
+#define for_each_memcg_cache(iter, root) \
+	list_for_each_entry(iter, &(root)->memcg_params.list, \
+			    memcg_params.list)
+
+#define for_each_memcg_cache_safe(iter, tmp, root) \
+	list_for_each_entry_safe(iter, tmp, &(root)->memcg_params.list, \
+				 memcg_params.list)
+
 static inline bool is_root_cache(struct kmem_cache *s)
 {
 	return s->memcg_params.is_root_cache;
@@ -241,6 +253,11 @@ extern void slab_init_memcg_params(struc
 
 #else /* !CONFIG_MEMCG_KMEM */
 
+#define for_each_memcg_cache(iter, root) \
+	for ((void)(iter), (void)(root); 0; )
+#define for_each_memcg_cache_safe(iter, tmp, root) \
+	for ((void)(iter), (void)(tmp), (void)(root); 0; )
+
 static inline bool is_root_cache(struct kmem_cache *s)
 {
 	return true;
diff -puN mm/slab_common.c~slab-link-memcg-caches-of-the-same-kind-into-a-list mm/slab_common.c
--- a/mm/slab_common.c~slab-link-memcg-caches-of-the-same-kind-into-a-list
+++ a/mm/slab_common.c
@@ -109,6 +109,7 @@ static inline int kmem_cache_sanity_chec
 void slab_init_memcg_params(struct kmem_cache *s)
 {
 	s->memcg_params.is_root_cache = true;
+	INIT_LIST_HEAD(&s->memcg_params.list);
 	RCU_INIT_POINTER(s->memcg_params.memcg_caches, NULL);
 }
 
@@ -449,6 +450,7 @@ static int do_kmem_cache_shutdown(struct
 						lockdep_is_held(&slab_mutex));
 		BUG_ON(arr->entries[idx] != s);
 		arr->entries[idx] = NULL;
+		list_del(&s->memcg_params.list);
 	}
 #endif
 	list_move(&s->list, release);
@@ -529,6 +531,8 @@ void memcg_create_kmem_cache(struct mem_
 		goto out_unlock;
 	}
 
+	list_add(&s->memcg_params.list, &root_cache->memcg_params.list);
+
 	/*
 	 * Since readers won't lock (see cache_from_memcg_idx()), we need a
 	 * barrier here to ensure nobody will see the kmem_cache partially
@@ -581,11 +585,13 @@ void slab_kmem_cache_release(struct kmem
 
 void kmem_cache_destroy(struct kmem_cache *s)
 {
-	int i;
+	struct kmem_cache *c, *c2;
 	LIST_HEAD(release);
 	bool need_rcu_barrier = false;
 	bool busy = false;
 
+	BUG_ON(!is_root_cache(s));
+
 	get_online_cpus();
 	get_online_mems();
 
@@ -595,10 +601,8 @@ void kmem_cache_destroy(struct kmem_cach
 	if (s->refcount)
 		goto out_unlock;
 
-	for_each_memcg_cache_index(i) {
-		struct kmem_cache *c = cache_from_memcg_idx(s, i);
-
-		if (c && do_kmem_cache_shutdown(c, &release, &need_rcu_barrier))
+	for_each_memcg_cache_safe(c, c2, s) {
+		if (do_kmem_cache_shutdown(c, &release, &need_rcu_barrier))
 			busy = true;
 	}
 
@@ -932,16 +936,11 @@ memcg_accumulate_slabinfo(struct kmem_ca
 {
 	struct kmem_cache *c;
 	struct slabinfo sinfo;
-	int i;
 
 	if (!is_root_cache(s))
 		return;
 
-	for_each_memcg_cache_index(i) {
-		c = cache_from_memcg_idx(s, i);
-		if (!c)
-			continue;
-
+	for_each_memcg_cache(c, s) {
 		memset(&sinfo, 0, sizeof(sinfo));
 		get_slabinfo(c, &sinfo);
 
diff -puN mm/slub.c~slab-link-memcg-caches-of-the-same-kind-into-a-list mm/slub.c
--- a/mm/slub.c~slab-link-memcg-caches-of-the-same-kind-into-a-list
+++ a/mm/slub.c
@@ -3636,13 +3636,10 @@ struct kmem_cache *
 __kmem_cache_alias(const char *name, size_t size, size_t align,
 		   unsigned long flags, void (*ctor)(void *))
 {
-	struct kmem_cache *s;
+	struct kmem_cache *s, *c;
 
 	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {
-		int i;
-		struct kmem_cache *c;
-
 		s->refcount++;
 
 		/*
@@ -3652,10 +3649,7 @@ __kmem_cache_alias(const char *name, siz
 		s->object_size = max(s->object_size, (int)size);
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
 
-		for_each_memcg_cache_index(i) {
-			c = cache_from_memcg_idx(s, i);
-			if (!c)
-				continue;
+		for_each_memcg_cache(c, s) {
 			c->object_size = s->object_size;
 			c->inuse = max_t(int, c->inuse,
 					 ALIGN(size, sizeof(void *)));
@@ -4921,7 +4915,7 @@ static ssize_t slab_attr_store(struct ko
 	err = attribute->store(s, buf, len);
 #ifdef CONFIG_MEMCG_KMEM
 	if (slab_state >= FULL && err >= 0 && is_root_cache(s)) {
-		int i;
+		struct kmem_cache *c;
 
 		mutex_lock(&slab_mutex);
 		if (s->max_attr_size < len)
@@ -4944,11 +4938,8 @@ static ssize_t slab_attr_store(struct ko
 		 * directly either failed or succeeded, in which case we loop
 		 * through the descendants with best-effort propagation.
 		 */
-		for_each_memcg_cache_index(i) {
-			struct kmem_cache *c = cache_from_memcg_idx(s, i);
-			if (c)
-				attribute->store(c, buf, len);
-		}
+		for_each_memcg_cache(c, s)
+			attribute->store(c, buf, len);
 		mutex_unlock(&slab_mutex);
 	}
 #endif
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

