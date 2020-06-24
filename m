From: akpm@linux-foundation.org
Subject: + mm-memcg-slab-remove-memcg_kmem_get_cache.patch added to
 -mm tree
Date: Wed, 24 Jun 2020 14:47:22 -0700
Message-ID: <20200624214722.5cQL6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404728AbgFXVrX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 17:47:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tj@kernel.org, shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: mm: memcg/slab: remove memcg_kmem_get_cache()
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-remove-memcg_kmem_get_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-remove-memcg_kmem_get_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-remove-memcg_kmem_get_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: remove memcg_kmem_get_cache()

The memcg_kmem_get_cache() function became really trivial, so let's just
inline it into the single call point: memcg_slab_pre_alloc_hook().

It will make the code less bulky and can also help the compiler to
generate a better code.

Link: http://lkml.kernel.org/r/20200623174037.3951353-15-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 --
 mm/memcontrol.c            |   25 +------------------------
 mm/slab.h                  |   11 +++++++++--
 mm/slab_common.c           |    2 +-
 4 files changed, 11 insertions(+), 29 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-remove-memcg_kmem_get_cache
+++ a/include/linux/memcontrol.h
@@ -1403,8 +1403,6 @@ static inline void memcg_set_shrinker_bi
 }
 #endif
 
-struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep);
-
 #ifdef CONFIG_MEMCG_KMEM
 int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
 			unsigned int nr_pages);
--- a/mm/memcontrol.c~mm-memcg-slab-remove-memcg_kmem_get_cache
+++ a/mm/memcontrol.c
@@ -393,7 +393,7 @@ void memcg_put_cache_ids(void)
 
 /*
  * A lot of the calls to the cache allocation functions are expected to be
- * inlined by the compiler. Since the calls to memcg_kmem_get_cache are
+ * inlined by the compiler. Since the calls to memcg_slab_pre_alloc_hook() are
  * conditional to this static branch, we'll have to allow modules that does
  * kmem_cache_alloc and the such to see this symbol as well
  */
@@ -2901,29 +2901,6 @@ static void memcg_free_cache_id(int id)
 }
 
 /**
- * memcg_kmem_get_cache: select memcg or root cache for allocation
- * @cachep: the original global kmem cache
- *
- * Return the kmem_cache we're supposed to use for a slab allocation.
- *
- * If the cache does not exist yet, if we are the first user of it, we
- * create it asynchronously in a workqueue and let the current allocation
- * go through with the original cache.
- */
-struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep)
-{
-	struct kmem_cache *memcg_cachep;
-
-	memcg_cachep = READ_ONCE(cachep->memcg_params.memcg_cache);
-	if (unlikely(!memcg_cachep)) {
-		queue_work(system_wq, &cachep->memcg_params.work);
-		return cachep;
-	}
-
-	return memcg_cachep;
-}
-
-/**
  * __memcg_kmem_charge: charge a number of kernel pages to a memcg
  * @memcg: memory cgroup to charge
  * @gfp: reclaim mode
--- a/mm/slab_common.c~mm-memcg-slab-remove-memcg_kmem_get_cache
+++ a/mm/slab_common.c
@@ -568,7 +568,7 @@ void memcg_create_kmem_cache(struct kmem
 	}
 
 	/*
-	 * Since readers won't lock (see memcg_kmem_get_cache()), we need a
+	 * Since readers won't lock (see memcg_slab_pre_alloc_hook()), we need a
 	 * barrier here to ensure nobody will see the kmem_cache partially
 	 * initialized.
 	 */
--- a/mm/slab.h~mm-memcg-slab-remove-memcg_kmem_get_cache
+++ a/mm/slab.h
@@ -364,9 +364,16 @@ static inline struct kmem_cache *memcg_s
 	if (memcg_kmem_bypass())
 		return s;
 
-	cachep = memcg_kmem_get_cache(s);
-	if (is_root_cache(cachep))
+	cachep = READ_ONCE(s->memcg_params.memcg_cache);
+	if (unlikely(!cachep)) {
+		/*
+		 * If memcg cache does not exist yet, we schedule it's
+		 * asynchronous creation and let the current allocation
+		 * go through with the root cache.
+		 */
+		queue_work(system_wq, &s->memcg_params.work);
 		return s;
+	}
 
 	objcg = get_obj_cgroup_from_current();
 	if (!objcg)
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state.patch
mm-memcg-prepare-for-byte-sized-vmstat-items.patch
mm-memcg-convert-vmstat-slab-counters-to-bytes.patch
mm-slub-implement-slub-version-of-obj_to_index.patch
mm-memcg-slab-obj_cgroup-api.patch
mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages.patch
mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects.patch
mm-memcg-slab-charge-individual-slab-objects-instead-of-pages.patch
mm-memcg-slab-deprecate-memorykmemslabinfo.patch
mm-memcg-slab-move-memcg_kmem_bypass-to-memcontrolh.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-accounted-allocations.patch
mm-memcg-slab-simplify-memcg-cache-creation.patch
mm-memcg-slab-remove-memcg_kmem_get_cache.patch
mm-memcg-slab-deprecate-slab_root_caches.patch
mm-memcg-slab-remove-redundant-check-in-memcg_accumulate_slabinfo.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations.patch
kselftests-cgroup-add-kernel-memory-accounting-tests.patch
tools-cgroup-add-memcg_slabinfopy-tool.patch
percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
