From: akpm@linux-foundation.org
Subject: +
 mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages.patch added to -mm
 tree
Date: Wed, 17 Jun 2020 16:33:52 -0700
Message-ID: <20200617233352.FTxdz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgFQXdx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 19:33:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tobin@kernel.org, tj@kernel.org, shakeelb@google.com, rientjes@google.com, penberg@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net, longman@redhat.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, dennis@kernel.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: mm: memcg/slab: allocate obj_cgroups for non-root slab pages
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages.patch

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
Subject: mm: memcg/slab: allocate obj_cgroups for non-root slab pages

Allocate and release memory to store obj_cgroup pointers for each non-root
slab page.  Reuse page->mem_cgroup pointer to store a pointer to the
allocated space.

To distinguish between obj_cgroups and memcg pointers in case when it's
not obvious which one is used (as in page_cgroup_ino()), let's always set
the lowest bit in the obj_cgroup case.

Link: http://lkml.kernel.org/r/20200608230654.828134-8-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    5 +++
 include/linux/slab_def.h |    6 ++++
 include/linux/slub_def.h |    5 +++
 mm/memcontrol.c          |   17 ++++++++++--
 mm/slab.h                |   49 +++++++++++++++++++++++++++++++++++++
 5 files changed, 78 insertions(+), 4 deletions(-)

--- a/include/linux/mm_types.h~mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages
+++ a/include/linux/mm_types.h
@@ -198,7 +198,10 @@ struct page {
 	atomic_t _refcount;
 
 #ifdef CONFIG_MEMCG
-	struct mem_cgroup *mem_cgroup;
+	union {
+		struct mem_cgroup *mem_cgroup;
+		struct obj_cgroup **obj_cgroups;
+	};
 #endif
 
 	/*
--- a/include/linux/slab_def.h~mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages
+++ a/include/linux/slab_def.h
@@ -114,4 +114,10 @@ static inline unsigned int obj_to_index(
 	return reciprocal_divide(offset, cache->reciprocal_buffer_size);
 }
 
+static inline int objs_per_slab_page(const struct kmem_cache *cache,
+				     const struct page *page)
+{
+	return cache->num;
+}
+
 #endif	/* _LINUX_SLAB_DEF_H */
--- a/include/linux/slub_def.h~mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages
+++ a/include/linux/slub_def.h
@@ -198,4 +198,9 @@ static inline unsigned int obj_to_index(
 	return __obj_to_index(cache, page_address(page), obj);
 }
 
+static inline int objs_per_slab_page(const struct kmem_cache *cache,
+				     const struct page *page)
+{
+	return page->objects;
+}
 #endif /* _LINUX_SLUB_DEF_H */
--- a/mm/memcontrol.c~mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages
+++ a/mm/memcontrol.c
@@ -569,10 +569,21 @@ ino_t page_cgroup_ino(struct page *page)
 	unsigned long ino = 0;
 
 	rcu_read_lock();
-	if (PageSlab(page) && !PageTail(page))
+	if (PageSlab(page) && !PageTail(page)) {
 		memcg = memcg_from_slab_page(page);
-	else
-		memcg = READ_ONCE(page->mem_cgroup);
+	} else {
+		memcg = page->mem_cgroup;
+
+		/*
+		 * The lowest bit set means that memcg isn't a valid
+		 * memcg pointer, but a obj_cgroups pointer.
+		 * In this case the page is shared and doesn't belong
+		 * to any specific memory cgroup.
+		 */
+		if ((unsigned long) memcg & 0x1UL)
+			memcg = NULL;
+	}
+
 	while (memcg && !(memcg->css.flags & CSS_ONLINE))
 		memcg = parent_mem_cgroup(memcg);
 	if (memcg)
--- a/mm/slab.h~mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages
+++ a/mm/slab.h
@@ -319,6 +319,18 @@ static inline struct kmem_cache *memcg_r
 	return s->memcg_params.root_cache;
 }
 
+static inline struct obj_cgroup **page_obj_cgroups(struct page *page)
+{
+	/*
+	 * page->mem_cgroup and page->obj_cgroups are sharing the same
+	 * space. To distinguish between them in case we don't know for sure
+	 * that the page is a slab page (e.g. page_cgroup_ino()), let's
+	 * always set the lowest bit of obj_cgroups.
+	 */
+	return (struct obj_cgroup **)
+		((unsigned long)page->obj_cgroups & ~0x1UL);
+}
+
 /*
  * Expects a pointer to a slab page. Please note, that PageSlab() check
  * isn't sufficient, as it returns true also for tail compound slab pages,
@@ -406,6 +418,26 @@ static __always_inline void memcg_unchar
 	percpu_ref_put_many(&s->memcg_params.refcnt, nr_pages);
 }
 
+static inline int memcg_alloc_page_obj_cgroups(struct page *page,
+					       struct kmem_cache *s, gfp_t gfp)
+{
+	unsigned int objects = objs_per_slab_page(s, page);
+	void *vec;
+
+	vec = kcalloc(objects, sizeof(struct obj_cgroup *), gfp);
+	if (!vec)
+		return -ENOMEM;
+
+	page->obj_cgroups = (struct obj_cgroup **) ((unsigned long)vec | 0x1UL);
+	return 0;
+}
+
+static inline void memcg_free_page_obj_cgroups(struct page *page)
+{
+	kfree(page_obj_cgroups(page));
+	page->obj_cgroups = NULL;
+}
+
 extern void slab_init_memcg_params(struct kmem_cache *);
 extern void memcg_link_cache(struct kmem_cache *s, struct mem_cgroup *memcg);
 
@@ -455,6 +487,16 @@ static inline void memcg_uncharge_slab(s
 {
 }
 
+static inline int memcg_alloc_page_obj_cgroups(struct page *page,
+					       struct kmem_cache *s, gfp_t gfp)
+{
+	return 0;
+}
+
+static inline void memcg_free_page_obj_cgroups(struct page *page)
+{
+}
+
 static inline void slab_init_memcg_params(struct kmem_cache *s)
 {
 }
@@ -481,12 +523,18 @@ static __always_inline int charge_slab_p
 					    gfp_t gfp, int order,
 					    struct kmem_cache *s)
 {
+	int ret;
+
 	if (is_root_cache(s)) {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
 				    PAGE_SIZE << order);
 		return 0;
 	}
 
+	ret = memcg_alloc_page_obj_cgroups(page, s, gfp);
+	if (ret)
+		return ret;
+
 	return memcg_charge_slab(page, gfp, order, s);
 }
 
@@ -499,6 +547,7 @@ static __always_inline void uncharge_sla
 		return;
 	}
 
+	memcg_free_page_obj_cgroups(page);
 	memcg_uncharge_slab(page, order, s);
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
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
