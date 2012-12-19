From: akpm@linux-foundation.org
Subject: [merged] memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:41:30 -0800
Message-ID: <20121219204131.58044200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:57279 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab2LSUlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:41:35 -0500
Received: by mail-la0-f73.google.com with SMTP id d3so121325lah.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:41:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: skip memcg kmem allocations in specified code regions
has been removed from the -mm tree.  Its filename was
     memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 mm/memcontrol.c       |   57 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 55 insertions(+), 3 deletions(-)

diff -puN include/linux/sched.h~memcg-skip-memcg-kmem-allocations-in-specified-code-regions include/linux/sched.h
--- a/include/linux/sched.h~memcg-skip-memcg-kmem-allocations-in-specified-code-regions
+++ a/include/linux/sched.h
@@ -1597,6 +1597,7 @@ struct task_struct {
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
@@ -3025,6 +3025,37 @@ out:
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
+	VM_BUG_ON(!current->mm);
+	current->memcg_kmem_skip_account++;
+}
+
+static inline void memcg_resume_kmem_account(void)
+{
+	VM_BUG_ON(!current->mm);
+	current->memcg_kmem_skip_account--;
+}
+
 static char *memcg_cache_name(struct mem_cgroup *memcg, struct kmem_cache *s)
 {
 	char *name;
@@ -3084,7 +3115,6 @@ static struct kmem_cache *memcg_create_k
 		goto out;
 
 	new_cachep = kmem_cache_dup(memcg, cachep);
-
 	if (new_cachep == NULL) {
 		new_cachep = cachep;
 		goto out;
@@ -3125,8 +3155,8 @@ static void memcg_create_cache_work_func
  * Enqueue the creation of a per-memcg kmem_cache.
  * Called with rcu_read_lock.
  */
-static void memcg_create_cache_enqueue(struct mem_cgroup *memcg,
-				       struct kmem_cache *cachep)
+static void __memcg_create_cache_enqueue(struct mem_cgroup *memcg,
+					 struct kmem_cache *cachep)
 {
 	struct create_work *cw;
 
@@ -3147,6 +3177,24 @@ static void memcg_create_cache_enqueue(s
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
@@ -3169,6 +3217,9 @@ struct kmem_cache *__memcg_kmem_get_cach
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

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

