From: akpm@linux-foundation.org
Subject: [merged] memcg-free-memcg_caches-slot-on-css-offline.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:20:23 -0800
Message-ID: <54de5c87.wEPkNx4C6LXvAtL7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbbBMUUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: free memcg_caches slot on css offline
has been removed from the -mm tree.  Its filename was
     memcg-free-memcg_caches-slot-on-css-offline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: free memcg_caches slot on css offline

We need to look up a kmem_cache in ->memcg_params.memcg_caches arrays only
on allocations, so there is no need to have the array entries set until
css free - we can clear them on css offline.  This will allow us to reuse
array entries more efficiently and avoid costly array relocations.

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

 include/linux/slab.h |   10 +++++-----
 mm/memcontrol.c      |   38 ++++++++++++++++++++++++++++++++------
 mm/slab_common.c     |   39 ++++++++++++++++++++++++++++-----------
 3 files changed, 65 insertions(+), 22 deletions(-)

diff -puN include/linux/slab.h~memcg-free-memcg_caches-slot-on-css-offline include/linux/slab.h
--- a/include/linux/slab.h~memcg-free-memcg_caches-slot-on-css-offline
+++ a/include/linux/slab.h
@@ -115,13 +115,12 @@ int slab_is_available(void);
 struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
 			unsigned long,
 			void (*)(void *));
-#ifdef CONFIG_MEMCG_KMEM
-void memcg_create_kmem_cache(struct mem_cgroup *, struct kmem_cache *);
-void memcg_destroy_kmem_caches(struct mem_cgroup *);
-#endif
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
-void kmem_cache_free(struct kmem_cache *, void *);
+
+void memcg_create_kmem_cache(struct mem_cgroup *, struct kmem_cache *);
+void memcg_deactivate_kmem_caches(struct mem_cgroup *);
+void memcg_destroy_kmem_caches(struct mem_cgroup *);
 
 /*
  * Please use this macro to create slab caches. Simply specify the
@@ -288,6 +287,7 @@ static __always_inline int kmalloc_index
 
 void *__kmalloc(size_t size, gfp_t flags);
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t flags);
+void kmem_cache_free(struct kmem_cache *, void *);
 
 #ifdef CONFIG_NUMA
 void *__kmalloc_node(size_t size, gfp_t flags, int node);
diff -puN mm/memcontrol.c~memcg-free-memcg_caches-slot-on-css-offline mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-free-memcg_caches-slot-on-css-offline
+++ a/mm/memcontrol.c
@@ -334,6 +334,7 @@ struct mem_cgroup {
 #if defined(CONFIG_MEMCG_KMEM)
         /* Index in the kmem_cache->memcg_params.memcg_caches array */
 	int kmemcg_id;
+	bool kmem_acct_active;
 #endif
 
 	int last_scanned_node;
@@ -354,7 +355,7 @@ struct mem_cgroup {
 #ifdef CONFIG_MEMCG_KMEM
 bool memcg_kmem_is_active(struct mem_cgroup *memcg)
 {
-	return memcg->kmemcg_id >= 0;
+	return memcg->kmem_acct_active;
 }
 #endif
 
@@ -585,7 +586,7 @@ static void memcg_free_cache_id(int id);
 
 static void disarm_kmem_keys(struct mem_cgroup *memcg)
 {
-	if (memcg_kmem_is_active(memcg)) {
+	if (memcg->kmemcg_id >= 0) {
 		static_key_slow_dec(&memcg_kmem_enabled_key);
 		memcg_free_cache_id(memcg->kmemcg_id);
 	}
@@ -2666,6 +2667,7 @@ struct kmem_cache *__memcg_kmem_get_cach
 {
 	struct mem_cgroup *memcg;
 	struct kmem_cache *memcg_cachep;
+	int kmemcg_id;
 
 	VM_BUG_ON(!is_root_cache(cachep));
 
@@ -2673,10 +2675,11 @@ struct kmem_cache *__memcg_kmem_get_cach
 		return cachep;
 
 	memcg = get_mem_cgroup_from_mm(current->mm);
-	if (!memcg_kmem_is_active(memcg))
+	kmemcg_id = ACCESS_ONCE(memcg->kmemcg_id);
+	if (kmemcg_id < 0)
 		goto out;
 
-	memcg_cachep = cache_from_memcg_idx(cachep, memcg_cache_id(memcg));
+	memcg_cachep = cache_from_memcg_idx(cachep, kmemcg_id);
 	if (likely(memcg_cachep))
 		return memcg_cachep;
 
@@ -3318,8 +3321,8 @@ static int memcg_activate_kmem(struct me
 	int err = 0;
 	int memcg_id;
 
-	if (memcg_kmem_is_active(memcg))
-		return 0;
+	BUG_ON(memcg->kmemcg_id >= 0);
+	BUG_ON(memcg->kmem_acct_active);
 
 	/*
 	 * For simplicity, we won't allow this to be disabled.  It also can't
@@ -3362,6 +3365,7 @@ static int memcg_activate_kmem(struct me
 	 * patched.
 	 */
 	memcg->kmemcg_id = memcg_id;
+	memcg->kmem_acct_active = true;
 out:
 	return err;
 }
@@ -4041,6 +4045,22 @@ static int memcg_init_kmem(struct mem_cg
 	return mem_cgroup_sockets_init(memcg, ss);
 }
 
+static void memcg_deactivate_kmem(struct mem_cgroup *memcg)
+{
+	if (!memcg->kmem_acct_active)
+		return;
+
+	/*
+	 * Clear the 'active' flag before clearing memcg_caches arrays entries.
+	 * Since we take the slab_mutex in memcg_deactivate_kmem_caches(), it
+	 * guarantees no cache will be created for this cgroup after we are
+	 * done (see memcg_create_kmem_cache()).
+	 */
+	memcg->kmem_acct_active = false;
+
+	memcg_deactivate_kmem_caches(memcg);
+}
+
 static void memcg_destroy_kmem(struct mem_cgroup *memcg)
 {
 	memcg_destroy_kmem_caches(memcg);
@@ -4052,6 +4072,10 @@ static int memcg_init_kmem(struct mem_cg
 	return 0;
 }
 
+static void memcg_deactivate_kmem(struct mem_cgroup *memcg)
+{
+}
+
 static void memcg_destroy_kmem(struct mem_cgroup *memcg)
 {
 }
@@ -4608,6 +4632,8 @@ static void mem_cgroup_css_offline(struc
 	spin_unlock(&memcg->event_list_lock);
 
 	vmpressure_cleanup(&memcg->vmpressure);
+
+	memcg_deactivate_kmem(memcg);
 }
 
 static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
diff -puN mm/slab_common.c~memcg-free-memcg_caches-slot-on-css-offline mm/slab_common.c
--- a/mm/slab_common.c~memcg-free-memcg_caches-slot-on-css-offline
+++ a/mm/slab_common.c
@@ -440,18 +440,8 @@ static int do_kmem_cache_shutdown(struct
 		*need_rcu_barrier = true;
 
 #ifdef CONFIG_MEMCG_KMEM
-	if (!is_root_cache(s)) {
-		int idx;
-		struct memcg_cache_array *arr;
-
-		idx = memcg_cache_id(s->memcg_params.memcg);
-		arr = rcu_dereference_protected(s->memcg_params.root_cache->
-						memcg_params.memcg_caches,
-						lockdep_is_held(&slab_mutex));
-		BUG_ON(arr->entries[idx] != s);
-		arr->entries[idx] = NULL;
+	if (!is_root_cache(s))
 		list_del(&s->memcg_params.list);
-	}
 #endif
 	list_move(&s->list, release);
 	return 0;
@@ -499,6 +489,13 @@ void memcg_create_kmem_cache(struct mem_
 
 	mutex_lock(&slab_mutex);
 
+	/*
+	 * The memory cgroup could have been deactivated while the cache
+	 * creation work was pending.
+	 */
+	if (!memcg_kmem_is_active(memcg))
+		goto out_unlock;
+
 	idx = memcg_cache_id(memcg);
 	arr = rcu_dereference_protected(root_cache->memcg_params.memcg_caches,
 					lockdep_is_held(&slab_mutex));
@@ -548,6 +545,26 @@ out_unlock:
 	put_online_cpus();
 }
 
+void memcg_deactivate_kmem_caches(struct mem_cgroup *memcg)
+{
+	int idx;
+	struct memcg_cache_array *arr;
+	struct kmem_cache *s;
+
+	idx = memcg_cache_id(memcg);
+
+	mutex_lock(&slab_mutex);
+	list_for_each_entry(s, &slab_caches, list) {
+		if (!is_root_cache(s))
+			continue;
+
+		arr = rcu_dereference_protected(s->memcg_params.memcg_caches,
+						lockdep_is_held(&slab_mutex));
+		arr->entries[idx] = NULL;
+	}
+	mutex_unlock(&slab_mutex);
+}
+
 void memcg_destroy_kmem_caches(struct mem_cgroup *memcg)
 {
 	LIST_HEAD(release);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

