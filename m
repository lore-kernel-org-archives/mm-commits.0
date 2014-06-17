From: akpm@linux-foundation.org
Subject: + memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
 added to -mm tree
Date: Tue, 17 Jun 2014 14:44:27 -0700
Message-ID: <53a0b6bb.xBDjgKwyusROq9ax%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965160AbaFQVo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 17:44:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, cl@linux.com, vdavydov@parallels.com


The patch titled
     Subject: memcg: wait for kfree's to finish before destroying cache
has been added to the -mm tree.  Its filename is
     memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: wait for kfree's to finish before destroying cache

kmem_cache_free doesn't expect that the cache can be destroyed as soon as
the object is freed, e.g.  SLUB's implementation may want to update cache
stats after putting the object to the free list.

Therefore we should wait for all kmem_cache_free's to finish before
proceeding to cache destruction.  Since both SLAB and SLUB versions of
kmem_cache_free are non-preemptable, we wait for rcu-sched grace period to
elapse.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    6 ++----
 mm/memcontrol.c      |   34 ++++++++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 6 deletions(-)

diff -puN include/linux/slab.h~memcg-wait-for-kfrees-to-finish-before-destroying-cache include/linux/slab.h
--- a/include/linux/slab.h~memcg-wait-for-kfrees-to-finish-before-destroying-cache
+++ a/include/linux/slab.h
@@ -532,11 +532,9 @@ static __always_inline void *kmalloc_nod
  */
 struct memcg_cache_params {
 	bool is_root_cache;
+	struct rcu_head rcu_head;
 	union {
-		struct {
-			struct rcu_head rcu_head;
-			struct kmem_cache *memcg_caches[0];
-		};
+		struct kmem_cache *memcg_caches[0];
 		struct {
 			struct mem_cgroup *memcg;
 			struct list_head list;
diff -puN mm/memcontrol.c~memcg-wait-for-kfrees-to-finish-before-destroying-cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-wait-for-kfrees-to-finish-before-destroying-cache
+++ a/mm/memcontrol.c
@@ -3194,6 +3194,14 @@ static void memcg_unregister_cache_func(
 	mutex_unlock(&memcg_slab_mutex);
 }
 
+static void memcg_unregister_cache_rcu_func(struct rcu_head *rcu)
+{
+	struct memcg_cache_params *params =
+		container_of(rcu, struct memcg_cache_params, rcu_head);
+
+	schedule_work(&params->unregister_work);
+}
+
 /*
  * During the creation a new cache, we need to disable our accounting mechanism
  * altogether. This is true even if we are not creating, but rather just
@@ -3249,6 +3257,7 @@ static void memcg_unregister_all_caches(
 {
 	struct kmem_cache *cachep;
 	struct memcg_cache_params *params, *tmp;
+	LIST_HEAD(empty_caches);
 
 	if (!memcg_kmem_is_active(memcg))
 		return;
@@ -3261,7 +3270,26 @@ static void memcg_unregister_all_caches(
 		kmem_cache_shrink(cachep);
 
 		if (atomic_long_dec_and_test(&cachep->memcg_params->refcnt))
-			memcg_unregister_cache(cachep);
+			list_move(&cachep->memcg_params->list, &empty_caches);
+	}
+
+	/*
+	 * kmem_cache_free doesn't expect that the cache can be destroyed as
+	 * soon as the object is freed, e.g. SLUB's implementation may want to
+	 * update cache stats after putting the object to the free list.
+	 *
+	 * Therefore we should wait for all kmem_cache_free's to finish before
+	 * proceeding to cache destruction. Since both SLAB and SLUB versions
+	 * of kmem_cache_free are non-preemptable, we wait for rcu-sched grace
+	 * period to elapse.
+	 */
+	synchronize_sched();
+
+	while (!list_empty(&empty_caches)) {
+		params = list_first_entry(&empty_caches,
+					  struct memcg_cache_params, list);
+		cachep = memcg_params_to_cache(params);
+		memcg_unregister_cache(cachep);
 	}
 	mutex_unlock(&memcg_slab_mutex);
 }
@@ -3343,7 +3371,9 @@ void __memcg_uncharge_slab(struct kmem_c
 	memcg_uncharge_kmem(cachep->memcg_params->memcg, PAGE_SIZE << order);
 
 	if (unlikely(atomic_long_dec_and_test(&cachep->memcg_params->refcnt)))
-		schedule_work(&cachep->memcg_params->unregister_work);
+		/* see memcg_unregister_all_caches */
+		call_rcu_sched(&cachep->memcg_params->rcu_head,
+			       memcg_unregister_cache_rcu_func);
 }
 
 /*
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slab-fix-oops-when-reading-proc-slab_allocators.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
linux-next.patch

