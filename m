From: akpm@linux-foundation.org
Subject: + memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:04:32 -0700
Message-ID: <20121102000432.EEF8B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:65357 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992605Ab2KBAEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:04:36 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so194324wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:04:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: memcg: skip memcg kmem allocations in specified code regions
has been added to the -mm tree.  Its filename is
     memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch

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
Subject: memcg: skip memcg kmem allocations in specified code regions

Create a mechanism that skip memcg allocations during certain pieces of
our core code.  It basically works in the same way as
preempt_disable()/preempt_enable(): By marking a region under which all
allocations will be accounted to the root memcg.

We need this to prevent races in early cache creation, when we
allocate data using caches that are not necessarily created already.

Signed-off-by: Glauber Costa <glommer@parallels.com>
yCc: Christoph Lameter <cl@linux.com>
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

 include/linux/sched.h |    1 
 mm/memcontrol.c       |   63 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 62 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~memcg-skip-memcg-kmem-allocations-in-specified-code-regions include/linux/sched.h
--- a/include/linux/sched.h~memcg-skip-memcg-kmem-allocations-in-specified-code-regions
+++ a/include/linux/sched.h
@@ -1577,6 +1577,7 @@ struct task_struct {
 		unsigned long nr_pages;	/* uncharged usage */
 		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
 	} memcg_batch;
+	unsigned int memcg_kmem_skip_account;
 #endif
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 	atomic_t ptrace_bp_refcnt;
diff -puN mm/memcontrol.c~memcg-skip-memcg-kmem-allocations-in-specified-code-regions mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-skip-memcg-kmem-allocations-in-specified-code-regions
+++ a/mm/memcontrol.c
@@ -2994,6 +2994,41 @@ out:
 	kfree(s->memcg_params);
 }
 
+/*
+ * During the creation a new cache, we need to disable our accounting mechanism
+ * altogether. This is true even if we are not creating, but rather just
+ * enqueing new caches to be created.
+ *
+ * This is because that process will trigger allocations; some visible, like
+ * explicit kmallocs to auxiliary data structures, name strings and internal
+ * cache structures; some well concealed, like INIT_WORK() that can allocate
+ * objects during debug.
+ *
+ * If any allocation happens during memcg_kmem_get_cache, we will recurse back
+ * to it. This may not be a bounded recursion: since the first cache creation
+ * failed to complete (waiting on the allocation), we'll just try to create the
+ * cache again, failing at the same point.
+ *
+ * memcg_kmem_get_cache is prepared to abort after seeing a positive count of
+ * memcg_kmem_skip_account. So we enclose anything that might allocate memory
+ * inside the following two functions.
+ */
+static inline void memcg_stop_kmem_account(void)
+{
+	if (!current->mm)
+		return;
+
+	current->memcg_kmem_skip_account++;
+}
+
+static inline void memcg_resume_kmem_account(void)
+{
+	if (!current->mm)
+		return;
+
+	current->memcg_kmem_skip_account--;
+}
+
 static char *memcg_cache_name(struct mem_cgroup *memcg, struct kmem_cache *s)
 {
 	char *name;
@@ -3052,7 +3087,10 @@ static struct kmem_cache *memcg_create_k
 	if (new_cachep)
 		goto out;
 
+	/* Don't block progress to enqueue caches for internal infrastructure */
+	memcg_stop_kmem_account();
 	new_cachep = kmem_cache_dup(memcg, cachep);
+	memcg_resume_kmem_account();
 
 	if (new_cachep == NULL) {
 		new_cachep = cachep;
@@ -3094,8 +3132,8 @@ static void memcg_create_cache_work_func
  * Enqueue the creation of a per-memcg kmem_cache.
  * Called with rcu_read_lock.
  */
-static void memcg_create_cache_enqueue(struct mem_cgroup *memcg,
-				       struct kmem_cache *cachep)
+static void __memcg_create_cache_enqueue(struct mem_cgroup *memcg,
+					 struct kmem_cache *cachep)
 {
 	struct create_work *cw;
 
@@ -3116,6 +3154,24 @@ static void memcg_create_cache_enqueue(s
 	schedule_work(&cw->work);
 }
 
+static void memcg_create_cache_enqueue(struct mem_cgroup *memcg,
+				       struct kmem_cache *cachep)
+{
+	/*
+	 * We need to stop accounting when we kmalloc, because if the
+	 * corresponding kmalloc cache is not yet created, the first allocation
+	 * in __memcg_create_cache_enqueue will recurse.
+	 *
+	 * However, it is better to enclose the whole function. Depending on
+	 * the debugging options enabled, INIT_WORK(), for instance, can
+	 * trigger an allocation. This too, will make us recurse. Because at
+	 * this point we can't allow ourselves back into memcg_kmem_get_cache,
+	 * the safest choice is to do it like this, wrapping the whole function.
+	 */
+	memcg_stop_kmem_account();
+	__memcg_create_cache_enqueue(memcg, cachep);
+	memcg_resume_kmem_account();
+}
 /*
  * Return the kmem_cache we're supposed to use for a slab allocation.
  * We try to use the current memcg's version of the cache.
@@ -3138,6 +3194,9 @@ struct kmem_cache *__memcg_kmem_get_cach
 	VM_BUG_ON(!cachep->memcg_params);
 	VM_BUG_ON(!cachep->memcg_params->is_root_cache);
 
+	if (!current->mm || current->memcg_kmem_skip_account)
+		return cachep;
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(current->mm->owner));
 	rcu_read_unlock();
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

