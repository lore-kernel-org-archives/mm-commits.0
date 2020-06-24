From: akpm@linux-foundation.org
Subject: +
 mm-memcg-slab-charge-individual-slab-objects-instead-of-pages.patch added to
 -mm tree
Date: Wed, 24 Jun 2020 14:47:11 -0700
Message-ID: <20200624214711.LzhHA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404274AbgFXVrN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 17:47:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tj@kernel.org, shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: mm: memcg/slab: charge individual slab objects instead of pages
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-charge-individual-slab-objects-instead-of-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-charge-individual-slab-objects-instead-of-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-charge-individual-slab-objects-instead-of-pages.patch

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
Subject: mm: memcg/slab: charge individual slab objects instead of pages

Switch to per-object accounting of non-root slab objects.

Charging is performed using obj_cgroup API in the pre_alloc hook.
Obj_cgroup is charged with the size of the object and the size of
metadata: as now it's the size of an obj_cgroup pointer.  If the amount of
memory has been charged successfully, the actual allocation code is
executed.  Otherwise, -ENOMEM is returned.

In the post_alloc hook if the actual allocation succeeded, corresponding
vmstats are bumped and the obj_cgroup pointer is saved.  Otherwise, the
charge is canceled.

On the free path obj_cgroup pointer is obtained and used to uncharge the
size of the releasing object.

Memcg and lruvec counters are now representing only memory used by active
slab objects and do not include the free space.  The free space is shared
and doesn't belong to any specific cgroup.

Global per-node slab vmstats are still modified from
(un)charge_slab_page() functions.  The idea is to keep all slab pages
accounted as slab pages on system level.

Link: http://lkml.kernel.org/r/20200623174037.3951353-10-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |  174 +++++++++++++++++++++++-----------------------------
 1 file changed, 78 insertions(+), 96 deletions(-)

--- a/mm/slab.h~mm-memcg-slab-charge-individual-slab-objects-instead-of-pages
+++ a/mm/slab.h
@@ -381,72 +381,6 @@ static inline struct mem_cgroup *memcg_f
 	return NULL;
 }
 
-/*
- * Charge the slab page belonging to the non-root kmem_cache.
- * Can be called for non-root kmem_caches only.
- */
-static __always_inline int memcg_charge_slab(struct page *page,
-					     gfp_t gfp, int order,
-					     struct kmem_cache *s)
-{
-	int nr_pages = 1 << order;
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
-	int ret;
-
-	rcu_read_lock();
-	memcg = READ_ONCE(s->memcg_params.memcg);
-	while (memcg && !css_tryget_online(&memcg->css))
-		memcg = parent_mem_cgroup(memcg);
-	rcu_read_unlock();
-
-	if (unlikely(!memcg || mem_cgroup_is_root(memcg))) {
-		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    nr_pages << PAGE_SHIFT);
-		percpu_ref_get_many(&s->memcg_params.refcnt, nr_pages);
-		return 0;
-	}
-
-	ret = memcg_kmem_charge(memcg, gfp, nr_pages);
-	if (ret)
-		goto out;
-
-	lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
-	mod_lruvec_state(lruvec, cache_vmstat_idx(s), nr_pages << PAGE_SHIFT);
-
-	percpu_ref_get_many(&s->memcg_params.refcnt, nr_pages);
-out:
-	css_put(&memcg->css);
-	return ret;
-}
-
-/*
- * Uncharge a slab page belonging to a non-root kmem_cache.
- * Can be called for non-root kmem_caches only.
- */
-static __always_inline void memcg_uncharge_slab(struct page *page, int order,
-						struct kmem_cache *s)
-{
-	int nr_pages = 1 << order;
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
-
-	rcu_read_lock();
-	memcg = READ_ONCE(s->memcg_params.memcg);
-	if (likely(!mem_cgroup_is_root(memcg))) {
-		lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
-		mod_lruvec_state(lruvec, cache_vmstat_idx(s),
-				 -(nr_pages << PAGE_SHIFT));
-		memcg_kmem_uncharge(memcg, nr_pages);
-	} else {
-		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    -(nr_pages << PAGE_SHIFT));
-	}
-	rcu_read_unlock();
-
-	percpu_ref_put_many(&s->memcg_params.refcnt, nr_pages);
-}
-
 static inline int memcg_alloc_page_obj_cgroups(struct page *page,
 					       struct kmem_cache *s, gfp_t gfp)
 {
@@ -469,6 +403,48 @@ static inline void memcg_free_page_obj_c
 	page->obj_cgroups = NULL;
 }
 
+static inline size_t obj_full_size(struct kmem_cache *s)
+{
+	/*
+	 * For each accounted object there is an extra space which is used
+	 * to store obj_cgroup membership. Charge it too.
+	 */
+	return s->size + sizeof(struct obj_cgroup *);
+}
+
+static inline struct kmem_cache *memcg_slab_pre_alloc_hook(struct kmem_cache *s,
+						struct obj_cgroup **objcgp,
+						size_t objects, gfp_t flags)
+{
+	struct kmem_cache *cachep;
+
+	cachep = memcg_kmem_get_cache(s, objcgp);
+	if (is_root_cache(cachep))
+		return s;
+
+	if (obj_cgroup_charge(*objcgp, flags, objects * obj_full_size(s))) {
+		obj_cgroup_put(*objcgp);
+		memcg_kmem_put_cache(cachep);
+		cachep = NULL;
+	}
+
+	return cachep;
+}
+
+static inline void mod_objcg_state(struct obj_cgroup *objcg,
+				   struct pglist_data *pgdat,
+				   int idx, int nr)
+{
+	struct mem_cgroup *memcg;
+	struct lruvec *lruvec;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	mod_memcg_lruvec_state(lruvec, idx, nr);
+	rcu_read_unlock();
+}
+
 static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
 					      struct obj_cgroup *objcg,
 					      size_t size, void **p)
@@ -483,6 +459,10 @@ static inline void memcg_slab_post_alloc
 			off = obj_to_index(s, page, p[i]);
 			obj_cgroup_get(objcg);
 			page_obj_cgroups(page)[off] = objcg;
+			mod_objcg_state(objcg, page_pgdat(page),
+					cache_vmstat_idx(s), obj_full_size(s));
+		} else {
+			obj_cgroup_uncharge(objcg, obj_full_size(s));
 		}
 	}
 	obj_cgroup_put(objcg);
@@ -501,6 +481,11 @@ static inline void memcg_slab_free_hook(
 	off = obj_to_index(s, page, p);
 	objcg = page_obj_cgroups(page)[off];
 	page_obj_cgroups(page)[off] = NULL;
+
+	obj_cgroup_uncharge(objcg, obj_full_size(s));
+	mod_objcg_state(objcg, page_pgdat(page), cache_vmstat_idx(s),
+			-obj_full_size(s));
+
 	obj_cgroup_put(objcg);
 }
 
@@ -542,17 +527,6 @@ static inline struct mem_cgroup *memcg_f
 	return NULL;
 }
 
-static inline int memcg_charge_slab(struct page *page, gfp_t gfp, int order,
-				    struct kmem_cache *s)
-{
-	return 0;
-}
-
-static inline void memcg_uncharge_slab(struct page *page, int order,
-				       struct kmem_cache *s)
-{
-}
-
 static inline int memcg_alloc_page_obj_cgroups(struct page *page,
 					       struct kmem_cache *s, gfp_t gfp)
 {
@@ -563,6 +537,13 @@ static inline void memcg_free_page_obj_c
 {
 }
 
+static inline struct kmem_cache *memcg_slab_pre_alloc_hook(struct kmem_cache *s,
+						struct obj_cgroup **objcgp,
+						size_t objects, gfp_t flags)
+{
+	return NULL;
+}
+
 static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
 					      struct obj_cgroup *objcg,
 					      size_t size, void **p)
@@ -600,32 +581,33 @@ static __always_inline int charge_slab_p
 					    gfp_t gfp, int order,
 					    struct kmem_cache *s)
 {
-	int ret;
+#ifdef CONFIG_MEMCG_KMEM
+	if (memcg_kmem_enabled() && !is_root_cache(s)) {
+		int ret;
+
+		ret = memcg_alloc_page_obj_cgroups(page, s, gfp);
+		if (ret)
+			return ret;
 
-	if (is_root_cache(s)) {
-		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    PAGE_SIZE << order);
-		return 0;
+		percpu_ref_get_many(&s->memcg_params.refcnt, 1 << order);
 	}
-
-	ret = memcg_alloc_page_obj_cgroups(page, s, gfp);
-	if (ret)
-		return ret;
-
-	return memcg_charge_slab(page, gfp, order, s);
+#endif
+	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
+			    PAGE_SIZE << order);
+	return 0;
 }
 
 static __always_inline void uncharge_slab_page(struct page *page, int order,
 					       struct kmem_cache *s)
 {
-	if (is_root_cache(s)) {
-		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    -(PAGE_SIZE << order));
-		return;
+#ifdef CONFIG_MEMCG_KMEM
+	if (memcg_kmem_enabled() && !is_root_cache(s)) {
+		memcg_free_page_obj_cgroups(page);
+		percpu_ref_put_many(&s->memcg_params.refcnt, 1 << order);
 	}
-
-	memcg_free_page_obj_cgroups(page);
-	memcg_uncharge_slab(page, order, s);
+#endif
+	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
+			    -(PAGE_SIZE << order));
 }
 
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
@@ -691,7 +673,7 @@ static inline struct kmem_cache *slab_pr
 
 	if (memcg_kmem_enabled() &&
 	    ((flags & __GFP_ACCOUNT) || (s->flags & SLAB_ACCOUNT)))
-		return memcg_kmem_get_cache(s, objcgp);
+		return memcg_slab_pre_alloc_hook(s, objcgp, size, flags);
 
 	return s;
 }
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
