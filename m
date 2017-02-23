From: akpm@linux-foundation.org
Subject: [merged]
 revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:12:19 -0800
Message-ID: <58af5033.0WbsP875UPO2Tw9L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39292 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbdBWVMU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:12:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cl@linux.com, iamjoonsoo.kim@lge.com, jsvana@fb.com, penberg@kernel.org, rientjes@google.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "slub: move synchronize_sched out of slab_mutex on shrink"
has been removed from the -mm tree.  Its filename was
     revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: Revert "slub: move synchronize_sched out of slab_mutex on shrink"

Patch series "slab: make memcg slab destruction scalable", v3.

With kmem cgroup support enabled, kmem_caches can be created and destroyed
frequently and a great number of near empty kmem_caches can accumulate if
there are a lot of transient cgroups and the system is not under memory
pressure.  When memory reclaim starts under such conditions, it can lead
to consecutive deactivation and destruction of many kmem_caches, easily
hundreds of thousands on moderately large systems, exposing scalability
issues in the current slab management code.

I've seen machines which end up with hundred thousands of caches and many
millions of kernfs_nodes.  The current code is O(N^2) on the total number
of caches and has synchronous rcu_barrier() and synchronize_sched() in
cgroup offline / release path which is executed while holding
cgroup_mutex.  Combined, this leads to very expensive and slow cache
destruction operations which can easily keep running for half a day.

This also messes up /proc/slabinfo along with other cache iterating
operations.  seq_file operates on 4k chunks and on each 4k boundary tries
to seek to the last position in the list.  With a huge number of caches on
the list, this becomes very slow and very prone to the list content
changing underneath it leading to a lot of missing and/or duplicate
entries.

This patchset addresses the scalability problem.

* Add root and per-memcg lists.  Update each user to use the
  appropriate list.

* Make rcu_barrier() for SLAB_DESTROY_BY_RCU caches globally batched
  and asynchronous.

* For dying empty slub caches, remove the sysfs files after
  deactivation so that we don't end up with millions of sysfs files
  without any useful information on them.

This patchset contains the following nine patches.

 0001-Revert-slub-move-synchronize_sched-out-of-slab_mutex.patch
 0002-slub-separate-out-sysfs_slab_release-from-sysfs_slab.patch
 0003-slab-remove-synchronous-rcu_barrier-call-in-memcg-ca.patch
 0004-slab-reorganize-memcg_cache_params.patch
 0005-slab-link-memcg-kmem_caches-on-their-associated-memo.patch
 0006-slab-implement-slab_root_caches-list.patch
 0007-slab-introduce-__kmemcg_cache_deactivate.patch
 0008-slab-remove-synchronous-synchronize_sched-from-memcg.patch
 0009-slab-remove-slub-sysfs-interface-files-early-for-emp.patch
 0010-slab-use-memcg_kmem_cache_wq-for-slab-destruction-op.patch

0001 reverts an existing optimization to prepare for the following
changes.  0002 is a prep patch.  0003 makes rcu_barrier() in release path
batched and asynchronous.  0004-0006 separate out the lists.  0007-0008
replace synchronize_sched() in slub destruction path with
call_rcu_sched().  0009 removes sysfs files early for empty dying caches. 
0010 makes destruction work items use a workqueue with limited
concurrency.



This patch (of 10):

Revert 89e364db71fb5e ("slub: move synchronize_sched out of slab_mutex on
shrink").

With kmem cgroup support enabled, kmem_caches can be created and destroyed
frequently and a great number of near empty kmem_caches can accumulate if
there are a lot of transient cgroups and the system is not under memory
pressure.  When memory reclaim starts under such conditions, it can lead
to consecutive deactivation and destruction of many kmem_caches, easily
hundreds of thousands on moderately large systems, exposing scalability
issues in the current slab management code.  This is one of the patches to
address the issue.

Moving synchronize_sched() out of slab_mutex isn't enough as it's still
inside cgroup_mutex.  The whole deactivation / release path will be
updated to avoid all synchronous RCU operations.  Revert this insufficient
optimization in preparation to ease future changes.

Link: http://lkml.kernel.org/r/20170117235411.9408-2-tj@kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jay Vana <jsvana@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    4 ++--
 mm/slab.h        |    2 +-
 mm/slab_common.c |   27 ++-------------------------
 mm/slob.c        |    2 +-
 mm/slub.c        |   19 +++++++++++++++++--
 5 files changed, 23 insertions(+), 31 deletions(-)

diff -puN mm/slab.c~revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink mm/slab.c
--- a/mm/slab.c~revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink
+++ a/mm/slab.c
@@ -2315,7 +2315,7 @@ out:
 	return nr_freed;
 }
 
-int __kmem_cache_shrink(struct kmem_cache *cachep)
+int __kmem_cache_shrink(struct kmem_cache *cachep, bool deactivate)
 {
 	int ret = 0;
 	int node;
@@ -2335,7 +2335,7 @@ int __kmem_cache_shrink(struct kmem_cach
 
 int __kmem_cache_shutdown(struct kmem_cache *cachep)
 {
-	return __kmem_cache_shrink(cachep);
+	return __kmem_cache_shrink(cachep, false);
 }
 
 void __kmem_cache_release(struct kmem_cache *cachep)
diff -puN mm/slab.h~revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink mm/slab.h
--- a/mm/slab.h~revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink
+++ a/mm/slab.h
@@ -167,7 +167,7 @@ static inline unsigned long kmem_cache_f
 
 int __kmem_cache_shutdown(struct kmem_cache *);
 void __kmem_cache_release(struct kmem_cache *);
-int __kmem_cache_shrink(struct kmem_cache *);
+int __kmem_cache_shrink(struct kmem_cache *, bool);
 void slab_kmem_cache_release(struct kmem_cache *);
 
 struct seq_file;
diff -puN mm/slab_common.c~revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink mm/slab_common.c
--- a/mm/slab_common.c~revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink
+++ a/mm/slab_common.c
@@ -582,29 +582,6 @@ void memcg_deactivate_kmem_caches(struct
 	get_online_cpus();
 	get_online_mems();
 
-#ifdef CONFIG_SLUB
-	/*
-	 * In case of SLUB, we need to disable empty slab caching to
-	 * avoid pinning the offline memory cgroup by freeable kmem
-	 * pages charged to it. SLAB doesn't need this, as it
-	 * periodically purges unused slabs.
-	 */
-	mutex_lock(&slab_mutex);
-	list_for_each_entry(s, &slab_caches, list) {
-		c = is_root_cache(s) ? cache_from_memcg_idx(s, idx) : NULL;
-		if (c) {
-			c->cpu_partial = 0;
-			c->min_partial = 0;
-		}
-	}
-	mutex_unlock(&slab_mutex);
-	/*
-	 * kmem_cache->cpu_partial is checked locklessly (see
-	 * put_cpu_partial()). Make sure the change is visible.
-	 */
-	synchronize_sched();
-#endif
-
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list) {
 		if (!is_root_cache(s))
@@ -616,7 +593,7 @@ void memcg_deactivate_kmem_caches(struct
 		if (!c)
 			continue;
 
-		__kmem_cache_shrink(c);
+		__kmem_cache_shrink(c, true);
 		arr->entries[idx] = NULL;
 	}
 	mutex_unlock(&slab_mutex);
@@ -787,7 +764,7 @@ int kmem_cache_shrink(struct kmem_cache
 	get_online_cpus();
 	get_online_mems();
 	kasan_cache_shrink(cachep);
-	ret = __kmem_cache_shrink(cachep);
+	ret = __kmem_cache_shrink(cachep, false);
 	put_online_mems();
 	put_online_cpus();
 	return ret;
diff -puN mm/slob.c~revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink mm/slob.c
--- a/mm/slob.c~revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink
+++ a/mm/slob.c
@@ -634,7 +634,7 @@ void __kmem_cache_release(struct kmem_ca
 {
 }
 
-int __kmem_cache_shrink(struct kmem_cache *d)
+int __kmem_cache_shrink(struct kmem_cache *d, bool deactivate)
 {
 	return 0;
 }
diff -puN mm/slub.c~revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink mm/slub.c
--- a/mm/slub.c~revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink
+++ a/mm/slub.c
@@ -3891,7 +3891,7 @@ EXPORT_SYMBOL(kfree);
  * being allocated from last increasing the chance that the last objects
  * are freed in them.
  */
-int __kmem_cache_shrink(struct kmem_cache *s)
+int __kmem_cache_shrink(struct kmem_cache *s, bool deactivate)
 {
 	int node;
 	int i;
@@ -3903,6 +3903,21 @@ int __kmem_cache_shrink(struct kmem_cach
 	unsigned long flags;
 	int ret = 0;
 
+	if (deactivate) {
+		/*
+		 * Disable empty slabs caching. Used to avoid pinning offline
+		 * memory cgroups by kmem pages that can be freed.
+		 */
+		s->cpu_partial = 0;
+		s->min_partial = 0;
+
+		/*
+		 * s->cpu_partial is checked locklessly (see put_cpu_partial),
+		 * so we have to make sure the change is visible.
+		 */
+		synchronize_sched();
+	}
+
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
 		INIT_LIST_HEAD(&discard);
@@ -3959,7 +3974,7 @@ static int slab_mem_going_offline_callba
 
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list)
-		__kmem_cache_shrink(s);
+		__kmem_cache_shrink(s, false);
 	mutex_unlock(&slab_mutex);
 
 	return 0;
_

Patches currently in -mm which might be from tj@kernel.org are


