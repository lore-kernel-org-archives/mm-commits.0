From: akpm@linux-foundation.org
Subject: + memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:04:26 -0700
Message-ID: <20121102000427.12B0920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:41531 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992605Ab2KBAEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:04:31 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so63429wib.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:04:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: memcg: infrastructure to match an allocation to the right cache
has been added to the -mm tree.  Its filename is
     memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch

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
Subject: memcg: infrastructure to match an allocation to the right cache

The page allocator is able to bind a page to a memcg when it is allocated.
 But for the caches, we'd like to have as many objects as possible in a
page belonging to the same cache.

This is done in this patch by calling memcg_kmem_get_cache in the
beginning of every allocation function.  This routing is patched out by
static branches when kernel memory controller is not being used.

It assumes that the task allocating, which determines the memcg in the
page allocator, belongs to the same cgroup throughout the whole process. 
Misacounting can happen if the task calls memcg_kmem_get_cache() while
belonging to a cgroup, and later on changes.  This is considered
acceptable, and should only happen upon task migration.

Before the cache is created by the memcg core, there is also a possible
imbalance: the task belongs to a memcg, but the cache being allocated from
is the global cache, since the child cache is not yet guaranteed to be
ready.  This case is also fine, since in this case the GFP_KMEMCG will not
be passed and the page allocator will not attempt any cgroup accounting.

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

 include/linux/memcontrol.h |   41 ++++++
 init/Kconfig               |    3 
 mm/memcontrol.c            |  217 +++++++++++++++++++++++++++++++++++
 3 files changed, 259 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-infrastructure-to-match-an-allocation-to-the-right-cache include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-infrastructure-to-match-an-allocation-to-the-right-cache
+++ a/include/linux/memcontrol.h
@@ -442,6 +442,10 @@ void memcg_cache_list_add(struct mem_cgr
 
 int memcg_update_cache_size(struct kmem_cache *s, int num_groups);
 void memcg_update_array_size(int num_groups);
+
+struct kmem_cache *
+__memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
+
 /**
  * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
  * @gfp: the gfp allocation flags.
@@ -511,6 +515,37 @@ memcg_kmem_commit_charge(struct page *pa
 		__memcg_kmem_commit_charge(page, memcg, order);
 }
 
+/**
+ * memcg_kmem_get_cache: selects the correct per-memcg cache for allocation
+ * @cachep: the original global kmem cache
+ * @gfp: allocation flags.
+ *
+ * This function assumes that the task allocating, which determines the memcg
+ * in the page allocator, belongs to the same cgroup throughout the whole
+ * process.  Misacounting can happen if the task calls memcg_kmem_get_cache()
+ * while belonging to a cgroup, and later on changes. This is considered
+ * acceptable, and should only happen upon task migration.
+ *
+ * Before the cache is created by the memcg core, there is also a possible
+ * imbalance: the task belongs to a memcg, but the cache being allocated from
+ * is the global cache, since the child cache is not yet guaranteed to be
+ * ready. This case is also fine, since in this case the GFP_KMEMCG will not be
+ * passed and the page allocator will not attempt any cgroup accounting.
+ */
+static __always_inline struct kmem_cache *
+memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
+{
+	if (!memcg_kmem_enabled())
+		return cachep;
+	if (gfp & __GFP_NOFAIL)
+		return cachep;
+	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
+		return cachep;
+	if (unlikely(fatal_signal_pending(current)))
+		return cachep;
+
+	return __memcg_kmem_get_cache(cachep, gfp);
+}
 #else
 static inline bool
 memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
@@ -546,6 +581,12 @@ static inline void memcg_cache_list_add(
 					struct kmem_cache *s)
 {
 }
+
+static inline struct kmem_cache *
+memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
+{
+	return cachep;
+}
 #endif /* CONFIG_MEMCG_KMEM */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff -puN init/Kconfig~memcg-infrastructure-to-match-an-allocation-to-the-right-cache init/Kconfig
--- a/init/Kconfig~memcg-infrastructure-to-match-an-allocation-to-the-right-cache
+++ a/init/Kconfig
@@ -802,8 +802,7 @@ config MEMCG_SWAP_ENABLED
 	  then swapaccount=0 does the trick).
 config MEMCG_KMEM
 	bool "Memory Resource Controller Kernel Memory accounting"
-	depends on MEMCG
-	default n
+	depends on MEMCG && !SLOB
 	help
 	  The Kernel Memory extension for Memory Resource Controller can limit
 	  the amount of memory used by kernel objects in the system. Those are
diff -puN mm/memcontrol.c~memcg-infrastructure-to-match-an-allocation-to-the-right-cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-infrastructure-to-match-an-allocation-to-the-right-cache
+++ a/mm/memcontrol.c
@@ -586,7 +586,14 @@ static int memcg_limited_groups_array_si
 #define MEMCG_CACHES_MIN_SIZE 4
 #define MEMCG_CACHES_MAX_SIZE 65535
 
+/*
+ * A lot of the calls to the cache allocation functions are expected to be
+ * inlined by the compiler. Since the calls to memcg_kmem_get_cache are
+ * conditional to this static branch, we'll have to allow modules that does
+ * kmem_cache_alloc and the such to see this symbol as well
+ */
 struct static_key memcg_kmem_enabled_key;
+EXPORT_SYMBOL(memcg_kmem_enabled_key);
 
 static void disarm_kmem_keys(struct mem_cgroup *memcg)
 {
@@ -2958,9 +2965,219 @@ int memcg_register_cache(struct mem_cgro
 
 void memcg_release_cache(struct kmem_cache *s)
 {
+	struct kmem_cache *root;
+	struct mem_cgroup *memcg;
+	int id;
+
+	/*
+	 * This happens, for instance, when a root cache goes away before we
+	 * add any memcg.
+	 */
+	if (!s->memcg_params)
+		return;
+
+	if (s->memcg_params->is_root_cache)
+		goto out;
+
+	memcg = s->memcg_params->memcg;
+	id  = memcg_cache_id(memcg);
+
+	root = s->memcg_params->root_cache;
+	root->memcg_params->memcg_caches[id] = NULL;
+	mem_cgroup_put(memcg);
+
+	mutex_lock(&memcg->slab_caches_mutex);
+	list_del(&s->memcg_params->list);
+	mutex_unlock(&memcg->slab_caches_mutex);
+
+out:
 	kfree(s->memcg_params);
 }
 
+static char *memcg_cache_name(struct mem_cgroup *memcg, struct kmem_cache *s)
+{
+	char *name;
+	struct dentry *dentry;
+
+	rcu_read_lock();
+	dentry = rcu_dereference(memcg->css.cgroup->dentry);
+	rcu_read_unlock();
+
+	BUG_ON(dentry == NULL);
+
+	name = kasprintf(GFP_KERNEL, "%s(%d:%s)", s->name,
+			 memcg_cache_id(memcg), dentry->d_name.name);
+
+	return name;
+}
+
+static struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
+					 struct kmem_cache *s)
+{
+	char *name;
+	struct kmem_cache *new;
+
+	name = memcg_cache_name(memcg, s);
+	if (!name)
+		return NULL;
+
+	new = kmem_cache_create_memcg(memcg, name, s->object_size, s->align,
+				      (s->flags & ~SLAB_PANIC), s->ctor);
+
+	kfree(name);
+	return new;
+}
+
+/*
+ * This lock protects updaters, not readers. We want readers to be as fast as
+ * they can, and they will either see NULL or a valid cache value. Our model
+ * allow them to see NULL, in which case the root memcg will be selected.
+ *
+ * We need this lock because multiple allocations to the same cache from a non
+ * will span more than one worker. Only one of them can create the cache.
+ */
+static DEFINE_MUTEX(memcg_cache_mutex);
+static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
+						  struct kmem_cache *cachep)
+{
+	struct kmem_cache *new_cachep;
+	int idx;
+
+	BUG_ON(!memcg_can_account_kmem(memcg));
+
+	idx = memcg_cache_id(memcg);
+
+	mutex_lock(&memcg_cache_mutex);
+	new_cachep = cachep->memcg_params->memcg_caches[idx];
+	if (new_cachep)
+		goto out;
+
+	new_cachep = kmem_cache_dup(memcg, cachep);
+
+	if (new_cachep == NULL) {
+		new_cachep = cachep;
+		goto out;
+	}
+
+	mem_cgroup_get(memcg);
+	new_cachep->memcg_params->root_cache = cachep;
+
+	cachep->memcg_params->memcg_caches[idx] = new_cachep;
+	/*
+	 * the readers won't lock, make sure everybody sees the updated value,
+	 * so they won't put stuff in the queue again for no reason
+	 */
+	wmb();
+out:
+	mutex_unlock(&memcg_cache_mutex);
+	return new_cachep;
+}
+
+struct create_work {
+	struct mem_cgroup *memcg;
+	struct kmem_cache *cachep;
+	struct work_struct work;
+};
+
+static void memcg_create_cache_work_func(struct work_struct *w)
+{
+	struct create_work *cw;
+
+	cw = container_of(w, struct create_work, work);
+	memcg_create_kmem_cache(cw->memcg, cw->cachep);
+	/* Drop the reference gotten when we enqueued. */
+	css_put(&cw->memcg->css);
+	kfree(cw);
+}
+
+/*
+ * Enqueue the creation of a per-memcg kmem_cache.
+ * Called with rcu_read_lock.
+ */
+static void memcg_create_cache_enqueue(struct mem_cgroup *memcg,
+				       struct kmem_cache *cachep)
+{
+	struct create_work *cw;
+
+	cw = kmalloc(sizeof(struct create_work), GFP_NOWAIT);
+	if (cw == NULL)
+		return;
+
+	/* The corresponding put will be done in the workqueue. */
+	if (!css_tryget(&memcg->css)) {
+		kfree(cw);
+		return;
+	}
+
+	cw->memcg = memcg;
+	cw->cachep = cachep;
+
+	INIT_WORK(&cw->work, memcg_create_cache_work_func);
+	schedule_work(&cw->work);
+}
+
+/*
+ * Return the kmem_cache we're supposed to use for a slab allocation.
+ * We try to use the current memcg's version of the cache.
+ *
+ * If the cache does not exist yet, if we are the first user of it,
+ * we either create it immediately, if possible, or create it asynchronously
+ * in a workqueue.
+ * In the latter case, we will let the current allocation go through with
+ * the original cache.
+ *
+ * Can't be called in interrupt context or from kernel threads.
+ * This function needs to be called with rcu_read_lock() held.
+ */
+struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep,
+					  gfp_t gfp)
+{
+	struct mem_cgroup *memcg;
+	int idx;
+
+	VM_BUG_ON(!cachep->memcg_params);
+	VM_BUG_ON(!cachep->memcg_params->is_root_cache);
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_task(rcu_dereference(current->mm->owner));
+	rcu_read_unlock();
+
+	if (!memcg_can_account_kmem(memcg))
+		return cachep;
+
+	idx = memcg_cache_id(memcg);
+
+	/*
+	 * barrier to mare sure we're always seeing the up to date value.  The
+	 * code updating memcg_caches will issue a write barrier to match this.
+	 */
+	read_barrier_depends();
+	if (unlikely(cachep->memcg_params->memcg_caches[idx] == NULL)) {
+		/*
+		 * If we are in a safe context (can wait, and not in interrupt
+		 * context), we could be be predictable and return right away.
+		 * This would guarantee that the allocation being performed
+		 * already belongs in the new cache.
+		 *
+		 * However, there are some clashes that can arrive from locking.
+		 * For instance, because we acquire the slab_mutex while doing
+		 * kmem_cache_dup, this means no further allocation could happen
+		 * with the slab_mutex held.
+		 *
+		 * Also, because cache creation issue get_online_cpus(), this
+		 * creates a lock chain: memcg_slab_mutex -> cpu_hotplug_mutex,
+		 * that ends up reversed during cpu hotplug. (cpuset allocates
+		 * a bunch of GFP_KERNEL memory during cpuup). Due to all that,
+		 * better to defer everything.
+		 */
+		memcg_create_cache_enqueue(memcg, cachep);
+		return cachep;
+	}
+
+	return cachep->memcg_params->memcg_caches[idx];
+}
+EXPORT_SYMBOL(__memcg_kmem_get_cache);
+
 /*
  * We need to verify if the allocation against current->mm->owner's memcg is
  * possible for the given order. But the page is not allocated yet, so we'll
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

