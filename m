From: akpm@linux-foundation.org
Subject: [merged]
 slab-remove-synchronous-rcu_barrier-call-in-memcg-cache-release-path.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:12:25 -0800
Message-ID: <58af5039.s6Eu4wWihxwpjD4o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39386 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbdBWVM0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:12:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cl@linux.com, iamjoonsoo.kim@lge.com, jsvana@fb.com, penberg@kernel.org, rientjes@google.com, vdavydov@tarantool.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: remove synchronous rcu_barrier() call in memcg cache release path
has been removed from the -mm tree.  Its filename was
     slab-remove-synchronous-rcu_barrier-call-in-memcg-cache-release-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: slab: remove synchronous rcu_barrier() call in memcg cache release path

With kmem cgroup support enabled, kmem_caches can be created and destroyed
frequently and a great number of near empty kmem_caches can accumulate if
there are a lot of transient cgroups and the system is not under memory
pressure.  When memory reclaim starts under such conditions, it can lead
to consecutive deactivation and destruction of many kmem_caches, easily
hundreds of thousands on moderately large systems, exposing scalability
issues in the current slab management code.  This is one of the patches to
address the issue.

SLAB_DESTORY_BY_RCU caches need to flush all RCU operations before
destruction because slab pages are freed through RCU and they need to be
able to dereference the associated kmem_cache.  Currently, it's done
synchronously with rcu_barrier().  As rcu_barrier() is expensive
time-wise, slab implements a batching mechanism so that rcu_barrier() can
be done for multiple caches at the same time.

Unfortunately, the rcu_barrier() is in synchronous path which is called
while holding cgroup_mutex and the batching is too limited to be actually
helpful.

This patch updates the cache release path so that the batching is
asynchronous and global.  All SLAB_DESTORY_BY_RCU caches are queued
globally and a work item consumes the list.  The work item calls
rcu_barrier() only once for all caches that are currently queued.

* release_caches() is removed and shutdown_cache() now either directly
  release the cache or schedules a RCU callback to do that.  This
  makes the cache inaccessible once shutdown_cache() is called and
  makes it impossible for shutdown_memcg_caches() to do memcg-specific
  cleanups afterwards.  Move memcg-specific part into a helper,
  unlink_memcg_cache(), and make shutdown_cache() call it directly.

Link: http://lkml.kernel.org/r/20170117235411.9408-4-tj@kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jay Vana <jsvana@fb.com>
Acked-by: Vladimir Davydov <vdavydov@tarantool.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |  102 ++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 42 deletions(-)

diff -puN mm/slab_common.c~slab-remove-synchronous-rcu_barrier-call-in-memcg-cache-release-path mm/slab_common.c
--- a/mm/slab_common.c~slab-remove-synchronous-rcu_barrier-call-in-memcg-cache-release-path
+++ a/mm/slab_common.c
@@ -30,6 +30,11 @@ LIST_HEAD(slab_caches);
 DEFINE_MUTEX(slab_mutex);
 struct kmem_cache *kmem_cache;
 
+static LIST_HEAD(slab_caches_to_rcu_destroy);
+static void slab_caches_to_rcu_destroy_workfn(struct work_struct *work);
+static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
+		    slab_caches_to_rcu_destroy_workfn);
+
 /*
  * Set of flags that will prevent slab merging
  */
@@ -215,6 +220,11 @@ int memcg_update_all_caches(int num_memc
 	mutex_unlock(&slab_mutex);
 	return ret;
 }
+
+static void unlink_memcg_cache(struct kmem_cache *s)
+{
+	list_del(&s->memcg_params.list);
+}
 #else
 static inline int init_memcg_params(struct kmem_cache *s,
 		struct mem_cgroup *memcg, struct kmem_cache *root_cache)
@@ -225,6 +235,10 @@ static inline int init_memcg_params(stru
 static inline void destroy_memcg_params(struct kmem_cache *s)
 {
 }
+
+static inline void unlink_memcg_cache(struct kmem_cache *s)
+{
+}
 #endif /* CONFIG_MEMCG && !CONFIG_SLOB */
 
 /*
@@ -461,33 +475,59 @@ out_unlock:
 }
 EXPORT_SYMBOL(kmem_cache_create);
 
-static int shutdown_cache(struct kmem_cache *s,
-		struct list_head *release, bool *need_rcu_barrier)
+static void slab_caches_to_rcu_destroy_workfn(struct work_struct *work)
 {
-	if (__kmem_cache_shutdown(s) != 0)
-		return -EBUSY;
+	LIST_HEAD(to_destroy);
+	struct kmem_cache *s, *s2;
 
-	if (s->flags & SLAB_DESTROY_BY_RCU)
-		*need_rcu_barrier = true;
+	/*
+	 * On destruction, SLAB_DESTROY_BY_RCU kmem_caches are put on the
+	 * @slab_caches_to_rcu_destroy list.  The slab pages are freed
+	 * through RCU and and the associated kmem_cache are dereferenced
+	 * while freeing the pages, so the kmem_caches should be freed only
+	 * after the pending RCU operations are finished.  As rcu_barrier()
+	 * is a pretty slow operation, we batch all pending destructions
+	 * asynchronously.
+	 */
+	mutex_lock(&slab_mutex);
+	list_splice_init(&slab_caches_to_rcu_destroy, &to_destroy);
+	mutex_unlock(&slab_mutex);
 
-	list_move(&s->list, release);
-	return 0;
+	if (list_empty(&to_destroy))
+		return;
+
+	rcu_barrier();
+
+	list_for_each_entry_safe(s, s2, &to_destroy, list) {
+#ifdef SLAB_SUPPORTS_SYSFS
+		sysfs_slab_release(s);
+#else
+		slab_kmem_cache_release(s);
+#endif
+	}
 }
 
-static void release_caches(struct list_head *release, bool need_rcu_barrier)
+static int shutdown_cache(struct kmem_cache *s)
 {
-	struct kmem_cache *s, *s2;
+	if (__kmem_cache_shutdown(s) != 0)
+		return -EBUSY;
 
-	if (need_rcu_barrier)
-		rcu_barrier();
+	list_del(&s->list);
+	if (!is_root_cache(s))
+		unlink_memcg_cache(s);
 
-	list_for_each_entry_safe(s, s2, release, list) {
+	if (s->flags & SLAB_DESTROY_BY_RCU) {
+		list_add_tail(&s->list, &slab_caches_to_rcu_destroy);
+		schedule_work(&slab_caches_to_rcu_destroy_work);
+	} else {
 #ifdef SLAB_SUPPORTS_SYSFS
 		sysfs_slab_release(s);
 #else
 		slab_kmem_cache_release(s);
 #endif
 	}
+
+	return 0;
 }
 
 #if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
@@ -602,22 +642,8 @@ void memcg_deactivate_kmem_caches(struct
 	put_online_cpus();
 }
 
-static int __shutdown_memcg_cache(struct kmem_cache *s,
-		struct list_head *release, bool *need_rcu_barrier)
-{
-	BUG_ON(is_root_cache(s));
-
-	if (shutdown_cache(s, release, need_rcu_barrier))
-		return -EBUSY;
-
-	list_del(&s->memcg_params.list);
-	return 0;
-}
-
 void memcg_destroy_kmem_caches(struct mem_cgroup *memcg)
 {
-	LIST_HEAD(release);
-	bool need_rcu_barrier = false;
 	struct kmem_cache *s, *s2;
 
 	get_online_cpus();
@@ -631,18 +657,15 @@ void memcg_destroy_kmem_caches(struct me
 		 * The cgroup is about to be freed and therefore has no charges
 		 * left. Hence, all its caches must be empty by now.
 		 */
-		BUG_ON(__shutdown_memcg_cache(s, &release, &need_rcu_barrier));
+		BUG_ON(shutdown_cache(s));
 	}
 	mutex_unlock(&slab_mutex);
 
 	put_online_mems();
 	put_online_cpus();
-
-	release_caches(&release, need_rcu_barrier);
 }
 
-static int shutdown_memcg_caches(struct kmem_cache *s,
-		struct list_head *release, bool *need_rcu_barrier)
+static int shutdown_memcg_caches(struct kmem_cache *s)
 {
 	struct memcg_cache_array *arr;
 	struct kmem_cache *c, *c2;
@@ -661,7 +684,7 @@ static int shutdown_memcg_caches(struct
 		c = arr->entries[i];
 		if (!c)
 			continue;
-		if (__shutdown_memcg_cache(c, release, need_rcu_barrier))
+		if (shutdown_cache(c))
 			/*
 			 * The cache still has objects. Move it to a temporary
 			 * list so as not to try to destroy it for a second
@@ -684,7 +707,7 @@ static int shutdown_memcg_caches(struct
 	 */
 	list_for_each_entry_safe(c, c2, &s->memcg_params.list,
 				 memcg_params.list)
-		__shutdown_memcg_cache(c, release, need_rcu_barrier);
+		shutdown_cache(c);
 
 	list_splice(&busy, &s->memcg_params.list);
 
@@ -697,8 +720,7 @@ static int shutdown_memcg_caches(struct
 	return 0;
 }
 #else
-static inline int shutdown_memcg_caches(struct kmem_cache *s,
-		struct list_head *release, bool *need_rcu_barrier)
+static inline int shutdown_memcg_caches(struct kmem_cache *s)
 {
 	return 0;
 }
@@ -714,8 +736,6 @@ void slab_kmem_cache_release(struct kmem
 
 void kmem_cache_destroy(struct kmem_cache *s)
 {
-	LIST_HEAD(release);
-	bool need_rcu_barrier = false;
 	int err;
 
 	if (unlikely(!s))
@@ -731,9 +751,9 @@ void kmem_cache_destroy(struct kmem_cach
 	if (s->refcount)
 		goto out_unlock;
 
-	err = shutdown_memcg_caches(s, &release, &need_rcu_barrier);
+	err = shutdown_memcg_caches(s);
 	if (!err)
-		err = shutdown_cache(s, &release, &need_rcu_barrier);
+		err = shutdown_cache(s);
 
 	if (err) {
 		pr_err("kmem_cache_destroy %s: Slab cache still has objects\n",
@@ -745,8 +765,6 @@ out_unlock:
 
 	put_online_mems();
 	put_online_cpus();
