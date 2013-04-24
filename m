From: akpm@linux-foundation.org
Subject: + memcg-take-reference-before-releasing-rcu_read_lock.patch added to -mm tree
Date: Wed, 24 Apr 2013 15:50:59 -0700
Message-ID: <20130424225059.7C2E831C19E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:37239 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758197Ab3DXWvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 18:51:00 -0400
Received: by mail-yh0-f73.google.com with SMTP id i21so250530yha.4
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 15:51:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizefan@huawei.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: take reference before releasing rcu_read_lock
has been added to the -mm tree.  Its filename is
     memcg-take-reference-before-releasing-rcu_read_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3484,7 +3484,6 @@ static void memcg_create_cache_work_func
 
 /*
  * Enqueue the creation of a per-memcg kmem_cache.
- * Called with rcu_read_lock.
  */
 static void __memcg_create_cache_enqueue(struct mem_cgroup *memcg,
 					 struct kmem_cache *cachep)
@@ -3492,12 +3491,8 @@ static void __memcg_create_cache_enqueue
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
 
@@ -3553,10 +3548,9 @@ struct kmem_cache *__memcg_kmem_get_cach
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(current->mm->owner));
-	rcu_read_unlock();
 
 	if (!memcg_can_account_kmem(memcg))
-		return cachep;
+		goto out;
 
 	idx = memcg_cache_id(memcg);
 
@@ -3565,29 +3559,38 @@ struct kmem_cache *__memcg_kmem_get_cach
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

linux-next.patch
memcg-keep-prevs-css-alive-for-the-whole-mem_cgroup_iter.patch
memcg-rework-mem_cgroup_iter-to-use-cgroup-iterators.patch
memcg-relax-memcg-iter-caching.patch
memcg-simplify-mem_cgroup_iter.patch
memcg-further-simplify-mem_cgroup_iter.patch
cgroup-remove-css_get_next.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
memcg-avoid-accessing-memcg-after-releasing-reference.patch
memcg-take-reference-before-releasing-rcu_read_lock.patch
exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock.patch

