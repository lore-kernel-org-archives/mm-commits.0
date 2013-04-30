From: akpm@linux-foundation.org
Subject: [merged] memcg-take-reference-before-releasing-rcu_read_lock.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:33 -0700
Message-ID: <20130430185033.846295A4088@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:38805 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766Ab3D3Sue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:34 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so86299vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizefan@huawei.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: take reference before releasing rcu_read_lock
has been removed from the -mm tree.  Its filename was
     memcg-take-reference-before-releasing-rcu_read_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: memcg: take reference before releasing rcu_read_lock

The memcg is not referenced, so it can be destroyed at anytime right after
we exit rcu read section, so it's not safe to access it.

To fix this, we call css_tryget() to get a reference while we're still in
rcu read section.

This also removes a bogus comment above __memcg_create_cache_enqueue().

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   63 ++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff -puN mm/memcontrol.c~memcg-take-reference-before-releasing-rcu_read_lock mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-take-reference-before-releasing-rcu_read_lock
+++ a/mm/memcontrol.c
@@ -3483,7 +3483,6 @@ static void memcg_create_cache_work_func
 
 /*
  * Enqueue the creation of a per-memcg kmem_cache.
- * Called with rcu_read_lock.
  */
 static void __memcg_create_cache_enqueue(struct mem_cgroup *memcg,
 					 struct kmem_cache *cachep)
@@ -3491,12 +3490,8 @@ static void __memcg_create_cache_enqueue
 	struct create_work *cw;
 
 	cw = kmalloc(sizeof(struct create_work), GFP_NOWAIT);
-	if (cw == NULL)
-		return;
-
-	/* The corresponding put will be done in the workqueue. */
-	if (!css_tryget(&memcg->css)) {
-		kfree(cw);
+	if (cw == NULL) {
+		css_put(&memcg->css);
 		return;
 	}
 
@@ -3552,10 +3547,9 @@ struct kmem_cache *__memcg_kmem_get_cach
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(current->mm->owner));
-	rcu_read_unlock();
 
 	if (!memcg_can_account_kmem(memcg))
-		return cachep;
+		goto out;
 
 	idx = memcg_cache_id(memcg);
 
@@ -3564,29 +3558,38 @@ struct kmem_cache *__memcg_kmem_get_cach
 	 * code updating memcg_caches will issue a write barrier to match this.
 	 */
 	read_barrier_depends();
-	if (unlikely(cachep->memcg_params->memcg_caches[idx] == NULL)) {
-		/*
-		 * If we are in a safe context (can wait, and not in interrupt
-		 * context), we could be be predictable and return right away.
-		 * This would guarantee that the allocation being performed
-		 * already belongs in the new cache.
-		 *
-		 * However, there are some clashes that can arrive from locking.
-		 * For instance, because we acquire the slab_mutex while doing
-		 * kmem_cache_dup, this means no further allocation could happen
-		 * with the slab_mutex held.
-		 *
-		 * Also, because cache creation issue get_online_cpus(), this
-		 * creates a lock chain: memcg_slab_mutex -> cpu_hotplug_mutex,
-		 * that ends up reversed during cpu hotplug. (cpuset allocates
-		 * a bunch of GFP_KERNEL memory during cpuup). Due to all that,
-		 * better to defer everything.
-		 */
-		memcg_create_cache_enqueue(memcg, cachep);
-		return cachep;
+	if (likely(cachep->memcg_params->memcg_caches[idx])) {
+		cachep = cachep->memcg_params->memcg_caches[idx];
+		goto out;
 	}
 
-	return cachep->memcg_params->memcg_caches[idx];
+	/* The corresponding put will be done in the workqueue. */
+	if (!css_tryget(&memcg->css))
+		goto out;
+	rcu_read_unlock();
+
+	/*
+	 * If we are in a safe context (can wait, and not in interrupt
+	 * context), we could be be predictable and return right away.
+	 * This would guarantee that the allocation being performed
+	 * already belongs in the new cache.
+	 *
+	 * However, there are some clashes that can arrive from locking.
+	 * For instance, because we acquire the slab_mutex while doing
+	 * kmem_cache_dup, this means no further allocation could happen
+	 * with the slab_mutex held.
+	 *
+	 * Also, because cache creation issue get_online_cpus(), this
+	 * creates a lock chain: memcg_slab_mutex -> cpu_hotplug_mutex,
+	 * that ends up reversed during cpu hotplug. (cpuset allocates
+	 * a bunch of GFP_KERNEL memory during cpuup). Due to all that,
+	 * better to defer everything.
+	 */
+	memcg_create_cache_enqueue(memcg, cachep);
+	return cachep;
+out:
+	rcu_read_unlock();
+	return cachep;
 }
 EXPORT_SYMBOL(__memcg_kmem_get_cache);
 
_

Patches currently in -mm which might be from lizefan@huawei.com are

origin.patch
linux-next.patch
exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock.patch

