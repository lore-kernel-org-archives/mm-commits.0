From: akpm@linux-foundation.org
Subject: + memcg-destroy-kmem-caches-when-last-slab-is-freed.patch added
 to -mm tree
Date: Tue, 17 Jun 2014 14:44:23 -0700
Message-ID: <53a0b6b7.X3N/tJwZSdch+Awp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931AbaFQVoY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 17:44:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, cl@linux.com, vdavydov@parallels.com


The patch titled
     Subject: memcg: destroy kmem caches when last slab is freed
has been added to the -mm tree.  Its filename is
     memcg-destroy-kmem-caches-when-last-slab-is-freed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-destroy-kmem-caches-when-last-slab-is-freed.patch

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
Subject: memcg: destroy kmem caches when last slab is freed

When the memcg_cache_params->refcnt goes to 0, schedule the worker that
will unregister the cache.  To prevent this from happening when the owner
memcg is alive, keep the refcnt incremented during memcg lifetime.

Note, this doesn't guarantee that the cache that belongs to a dead memcg
will go away as soon as the last object is freed, because SL[AU]B
implementation can cache empty slabs for performance reasons.  Hence the
cache may be hanging around indefinitely after memcg offline.  This is to
be resolved by the next patches.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 ++
 mm/memcontrol.c      |   22 ++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff -puN include/linux/slab.h~memcg-destroy-kmem-caches-when-last-slab-is-freed include/linux/slab.h
--- a/include/linux/slab.h~memcg-destroy-kmem-caches-when-last-slab-is-freed
+++ a/include/linux/slab.h
@@ -527,6 +527,7 @@ static __always_inline void *kmalloc_nod
  * @list: list_head for the list of all caches in this memcg
  * @root_cache: pointer to the global, root cache, this cache was derived from
  * @refcnt: reference counter
+ * @unregister_work: worker to destroy the cache
  */
 struct memcg_cache_params {
 	bool is_root_cache;
@@ -540,6 +541,7 @@ struct memcg_cache_params {
 			struct list_head list;
 			struct kmem_cache *root_cache;
 			atomic_long_t refcnt;
+			struct work_struct unregister_work;
 		};
 	};
 };
diff -puN mm/memcontrol.c~memcg-destroy-kmem-caches-when-last-slab-is-freed mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-destroy-kmem-caches-when-last-slab-is-freed
+++ a/mm/memcontrol.c
@@ -3076,6 +3076,8 @@ int memcg_update_cache_size(struct kmem_
 	return 0;
 }
 
+static void memcg_unregister_cache_func(struct work_struct *work);
+
 int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
 			     struct kmem_cache *root_cache)
 {
@@ -3097,6 +3099,9 @@ int memcg_alloc_cache_params(struct mem_
 	if (memcg) {
 		s->memcg_params->memcg = memcg;
 		s->memcg_params->root_cache = root_cache;
+		atomic_long_set(&s->memcg_params->refcnt, 1);
+		INIT_WORK(&s->memcg_params->unregister_work,
+			  memcg_unregister_cache_func);
 		css_get(&memcg->css);
 	} else
 		s->memcg_params->is_root_cache = true;
@@ -3178,6 +3183,17 @@ static void memcg_unregister_cache(struc
 	kmem_cache_destroy(cachep);
 }
 
+static void memcg_unregister_cache_func(struct work_struct *work)
+{
+	struct memcg_cache_params *params =
+		container_of(work, struct memcg_cache_params, unregister_work);
+	struct kmem_cache *cachep = memcg_params_to_cache(params);
+
+	mutex_lock(&memcg_slab_mutex);
+	memcg_unregister_cache(cachep);
+	mutex_unlock(&memcg_slab_mutex);
+}
+
 /*
  * During the creation a new cache, we need to disable our accounting mechanism
  * altogether. This is true even if we are not creating, but rather just
@@ -3241,7 +3257,7 @@ static void memcg_unregister_all_caches(
 	list_for_each_entry_safe(params, tmp, &memcg->memcg_slab_caches, list) {
 		cachep = memcg_params_to_cache(params);
 		kmem_cache_shrink(cachep);
-		if (atomic_long_read(&cachep->memcg_params->refcnt) == 0)
+		if (atomic_long_dec_and_test(&cachep->memcg_params->refcnt))
 			memcg_unregister_cache(cachep);
 	}
 	mutex_unlock(&memcg_slab_mutex);
@@ -3322,7 +3338,9 @@ int __memcg_charge_slab(struct kmem_cach
 void __memcg_uncharge_slab(struct kmem_cache *cachep, int order)
 {
 	memcg_uncharge_kmem(cachep->memcg_params->memcg, PAGE_SIZE << order);
-	atomic_long_dec(&cachep->memcg_params->refcnt);
+
+	if (unlikely(atomic_long_dec_and_test(&cachep->memcg_params->refcnt)))
+		schedule_work(&cachep->memcg_params->unregister_work);
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

