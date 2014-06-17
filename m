From: akpm@linux-foundation.org
Subject: + memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
 added to -mm tree
Date: Tue, 17 Jun 2014 14:44:24 -0700
Message-ID: <53a0b6b8.1+Sed+baQSpTvWvn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931AbaFQVoZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 17:44:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, cl@linux.com, vdavydov@parallels.com


The patch titled
     Subject: memcg: mark caches that belong to offline memcgs as dead
has been added to the -mm tree.  Its filename is
     memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch

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
Subject: memcg: mark caches that belong to offline memcgs as dead

This will be used by the next patches.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 ++
 mm/memcontrol.c      |    3 +++
 mm/slab.h            |   25 +++++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff -puN include/linux/slab.h~memcg-mark-caches-that-belong-to-offline-memcgs-as-dead include/linux/slab.h
--- a/include/linux/slab.h~memcg-mark-caches-that-belong-to-offline-memcgs-as-dead
+++ a/include/linux/slab.h
@@ -527,6 +527,7 @@ static __always_inline void *kmalloc_nod
  * @list: list_head for the list of all caches in this memcg
  * @root_cache: pointer to the global, root cache, this cache was derived from
  * @refcnt: reference counter
+ * @dead: set to true when owner memcg is turned offline
  * @unregister_work: worker to destroy the cache
  */
 struct memcg_cache_params {
@@ -541,6 +542,7 @@ struct memcg_cache_params {
 			struct list_head list;
 			struct kmem_cache *root_cache;
 			atomic_long_t refcnt;
+			bool dead;
 			struct work_struct unregister_work;
 		};
 	};
diff -puN mm/memcontrol.c~memcg-mark-caches-that-belong-to-offline-memcgs-as-dead mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-mark-caches-that-belong-to-offline-memcgs-as-dead
+++ a/mm/memcontrol.c
@@ -3256,7 +3256,10 @@ static void memcg_unregister_all_caches(
 	mutex_lock(&memcg_slab_mutex);
 	list_for_each_entry_safe(params, tmp, &memcg->memcg_slab_caches, list) {
 		cachep = memcg_params_to_cache(params);
+
+		memcg_cache_mark_dead(cachep);
 		kmem_cache_shrink(cachep);
+
 		if (atomic_long_dec_and_test(&cachep->memcg_params->refcnt))
 			memcg_unregister_cache(cachep);
 	}
diff -puN mm/slab.h~memcg-mark-caches-that-belong-to-offline-memcgs-as-dead mm/slab.h
--- a/mm/slab.h~memcg-mark-caches-that-belong-to-offline-memcgs-as-dead
+++ a/mm/slab.h
@@ -121,6 +121,26 @@ static inline bool is_root_cache(struct
 	return !s->memcg_params || s->memcg_params->is_root_cache;
 }
 
+static inline bool memcg_cache_dead(struct kmem_cache *s)
+{
+	if (is_root_cache(s))
+		return false;
+
+	/*
+	 * Since this function can be called without holding any locks, it
+	 * needs a barrier here to guarantee the read won't be reordered.
+	 */
+	smp_rmb();
+	return s->memcg_params->dead;
+}
+
+static inline void memcg_cache_mark_dead(struct kmem_cache *s)
+{
+	BUG_ON(is_root_cache(s));
+	s->memcg_params->dead = true;
+	smp_wmb();		/* matches rmb in memcg_cache_dead() */
+}
+
 static inline bool slab_equal_or_root(struct kmem_cache *s,
 					struct kmem_cache *p)
 {
@@ -203,6 +223,11 @@ static inline bool is_root_cache(struct
 	return true;
 }
 
+static inline bool memcg_cache_dead(struct kmem_cache *s)
+{
+	return false;
+}
+
 static inline bool slab_equal_or_root(struct kmem_cache *s,
 				      struct kmem_cache *p)
 {
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

