From: akpm@linux-foundation.org
Subject: [merged] memcg-execute-the-whole-memcg-freeing-in-free_worker.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:40:50 -0800
Message-ID: <20121219204051.A5EC5200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:54226 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2LSUkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:40:55 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so133788fav.4
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:40:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: execute the whole memcg freeing in free_worker()
has been removed from the -mm tree.  Its filename was
     memcg-execute-the-whole-memcg-freeing-in-free_worker.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: execute the whole memcg freeing in free_worker()

A lot of the initialization we do in mem_cgroup_create() is done with
softirqs enabled.  This include grabbing a css id, which holds
&ss->id_lock->rlock, and the per-zone trees, which holds
rtpz->lock->rlock.  All of those signal to the lockdep mechanism that
those locks can be used in SOFTIRQ-ON-W context.  This means that the
freeing of memcg structure must happen in a compatible context, otherwise
we'll get a deadlock, like the one below, caught by lockdep:

  [<ffffffff81103095>] free_accounted_pages+0x47/0x4c
  [<ffffffff81047f90>] free_task+0x31/0x5c
  [<ffffffff8104807d>] __put_task_struct+0xc2/0xdb
  [<ffffffff8104dfc7>] put_task_struct+0x1e/0x22
  [<ffffffff8104e144>] delayed_put_task_struct+0x7a/0x98
  [<ffffffff810cf0e5>] __rcu_process_callbacks+0x269/0x3df
  [<ffffffff810cf28c>] rcu_process_callbacks+0x31/0x5b
  [<ffffffff8105266d>] __do_softirq+0x122/0x277

This usage pattern could not be triggered before kmem came into play. 
With the introduction of kmem stack handling, it is possible that we call
the last mem_cgroup_put() from the task destructor, which is run in an rcu
callback.  Such callbacks are run with softirqs disabled, leading to the
offensive usage pattern.

In general, we have little, if any, means to guarantee in which context
the last memcg_put will happen.  The best we can do is test it and try to
make sure no invalid context releases are happening.  But as we add more
code to memcg, the possible interactions grow in number and expose more
ways to get context conflicts.  One thing to keep in mind, is that part of
the freeing process is already deferred to a worker, such as vfree(), that
can only be called from process context.

For the moment, the only two functions we really need moved away are:

  * free_css_id(), and
  * mem_cgroup_remove_from_trees().

But because the later accesses per-zone info,
free_mem_cgroup_per_zone_info() needs to be moved as well.  With that, we
are left with the per_cpu stats only.  Better move it all.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Tested-by: Greg Thelen <gthelen@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   66 +++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 32 deletions(-)

diff -puN mm/memcontrol.c~memcg-execute-the-whole-memcg-freeing-in-free_worker mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-execute-the-whole-memcg-freeing-in-free_worker
+++ a/mm/memcontrol.c
@@ -5247,16 +5247,29 @@ out_free:
 }
 
 /*
- * Helpers for freeing a kmalloc()ed/vzalloc()ed mem_cgroup by RCU,
- * but in process context.  The work_freeing structure is overlaid
- * on the rcu_freeing structure, which itself is overlaid on memsw.
+ * At destroying mem_cgroup, references from swap_cgroup can remain.
+ * (scanning all at force_empty is too costly...)
+ *
+ * Instead of clearing all references at force_empty, we remember
+ * the number of reference from swap_cgroup and free mem_cgroup when
+ * it goes down to 0.
+ *
+ * Removal of cgroup itself succeeds regardless of refs from swap.
  */
-static void free_work(struct work_struct *work)
+
+static void __mem_cgroup_free(struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *memcg;
+	int node;
 	int size = sizeof(struct mem_cgroup);
 
-	memcg = container_of(work, struct mem_cgroup, work_freeing);
+	mem_cgroup_remove_from_trees(memcg);
+	free_css_id(&mem_cgroup_subsys, &memcg->css);
+
+	for_each_node(node)
+		free_mem_cgroup_per_zone_info(memcg, node);
+
+	free_percpu(memcg->stat);
+
 	/*
 	 * We need to make sure that (at least for now), the jump label
 	 * destruction code runs outside of the cgroup lock. This is because
@@ -5275,38 +5288,27 @@ static void free_work(struct work_struct
 		vfree(memcg);
 }
 
-static void free_rcu(struct rcu_head *rcu_head)
-{
-	struct mem_cgroup *memcg;
-
-	memcg = container_of(rcu_head, struct mem_cgroup, rcu_freeing);
-	INIT_WORK(&memcg->work_freeing, free_work);
-	schedule_work(&memcg->work_freeing);
-}
 
 /*
- * At destroying mem_cgroup, references from swap_cgroup can remain.
- * (scanning all at force_empty is too costly...)
- *
- * Instead of clearing all references at force_empty, we remember
- * the number of reference from swap_cgroup and free mem_cgroup when
- * it goes down to 0.
- *
- * Removal of cgroup itself succeeds regardless of refs from swap.
+ * Helpers for freeing a kmalloc()ed/vzalloc()ed mem_cgroup by RCU,
+ * but in process context.  The work_freeing structure is overlaid
+ * on the rcu_freeing structure, which itself is overlaid on memsw.
  */
-
-static void __mem_cgroup_free(struct mem_cgroup *memcg)
+static void free_work(struct work_struct *work)
 {
-	int node;
+	struct mem_cgroup *memcg;
 
-	mem_cgroup_remove_from_trees(memcg);
-	free_css_id(&mem_cgroup_subsys, &memcg->css);
+	memcg = container_of(work, struct mem_cgroup, work_freeing);
+	__mem_cgroup_free(memcg);
+}
 
-	for_each_node(node)
-		free_mem_cgroup_per_zone_info(memcg, node);
+static void free_rcu(struct rcu_head *rcu_head)
+{
+	struct mem_cgroup *memcg;
 
-	free_percpu(memcg->stat);
-	call_rcu(&memcg->rcu_freeing, free_rcu);
+	memcg = container_of(rcu_head, struct mem_cgroup, rcu_freeing);
+	INIT_WORK(&memcg->work_freeing, free_work);
+	schedule_work(&memcg->work_freeing);
 }
 
 static void mem_cgroup_get(struct mem_cgroup *memcg)
@@ -5318,7 +5320,7 @@ static void __mem_cgroup_put(struct mem_
 {
 	if (atomic_sub_and_test(count, &memcg->refcnt)) {
 		struct mem_cgroup *parent = parent_mem_cgroup(memcg);
-		__mem_cgroup_free(memcg);
+		call_rcu(&memcg->rcu_freeing, free_rcu);
 		if (parent)
 			mem_cgroup_put(parent);
 	}
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

