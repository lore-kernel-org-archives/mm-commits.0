From: akpm@linux-foundation.org
Subject: + mm-slub-implement-slub-version-of-obj_to_index.patch
 added to -mm tree
Date: Wed, 24 Jun 2020 14:46:59 -0700
Message-ID: <20200624214659.GbeCU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731881AbgFXVrA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 17:47:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tj@kernel.org, shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: mm: slub: implement SLUB version of obj_to_index()
has been added to the -mm tree.  Its filename is
     mm-slub-implement-slub-version-of-obj_to_index.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-implement-slub-version-of-obj_to_index.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-implement-slub-version-of-obj_to_index.patch

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
Subject: mm: slub: implement SLUB version of obj_to_index()

This commit implements SLUB version of the obj_to_index() function, which
will be required to calculate the offset of obj_cgroup in the obj_cgroups
vector to store/obtain the objcg ownership data.

To make it faster, let's repeat the SLAB's trick introduced by commit
6a2d7a955d8d ("SLAB: use a multiply instead of a divide in
obj_to_index()") and avoid an expensive division.

Vlastimil Babka noticed, that SLUB does have already a similar function
called slab_index(), which is defined only if SLUB_DEBUG is enabled.  The
function does a similar math, but with a division, and it also takes a
page address instead of a page pointer.

Let's remove slab_index() and replace it with the new helper
__obj_to_index(), which takes a page address.  obj_to_index() will be a
simple wrapper taking a page pointer and passing page_address(page) into
__obj_to_index().

Link: http://lkml.kernel.org/r/20200623174037.3951353-5-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   16 ++++++++++++++++
 mm/slub.c                |   15 +++++----------
 2 files changed, 21 insertions(+), 10 deletions(-)

--- a/include/linux/slub_def.h~mm-slub-implement-slub-version-of-obj_to_index
+++ a/include/linux/slub_def.h
@@ -8,6 +8,7 @@
  * (C) 2007 SGI, Christoph Lameter
  */
 #include <linux/kobject.h>
+#include <linux/reciprocal_div.h>
 
 enum stat_item {
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
@@ -86,6 +87,7 @@ struct kmem_cache {
 	unsigned long min_partial;
 	unsigned int size;	/* The size of an object including metadata */
 	unsigned int object_size;/* The size of an object without metadata */
+	struct reciprocal_value reciprocal_size;
 	unsigned int offset;	/* Free pointer offset */
 #ifdef CONFIG_SLUB_CPU_PARTIAL
 	/* Number of per cpu partial objects to keep around */
@@ -182,4 +184,18 @@ static inline void *nearest_obj(struct k
 	return result;
 }
 
+/* Determine object index from a given position */
+static inline unsigned int __obj_to_index(const struct kmem_cache *cache,
+					  void *addr, void *obj)
+{
+	return reciprocal_divide(kasan_reset_tag(obj) - addr,
+				 cache->reciprocal_size);
+}
+
+static inline unsigned int obj_to_index(const struct kmem_cache *cache,
+					const struct page *page, void *obj)
+{
+	return __obj_to_index(cache, page_address(page), obj);
+}
+
 #endif /* _LINUX_SLUB_DEF_H */
--- a/mm/slub.c~mm-slub-implement-slub-version-of-obj_to_index
+++ a/mm/slub.c
@@ -317,12 +317,6 @@ static inline void set_freepointer(struc
 		__p < (__addr) + (__objects) * (__s)->size; \
 		__p += (__s)->size)
 
-/* Determine object index from a given position */
-static inline unsigned int slab_index(void *p, struct kmem_cache *s, void *addr)
-{
-	return (kasan_reset_tag(p) - addr) / s->size;
-}
-
 static inline unsigned int order_objects(unsigned int order, unsigned int size)
 {
 	return ((unsigned int)PAGE_SIZE << order) / size;
@@ -465,7 +459,7 @@ static unsigned long *get_map(struct kme
 	bitmap_zero(object_map, page->objects);
 
 	for (p = page->freelist; p; p = get_freepointer(s, p))
-		set_bit(slab_index(p, s, addr), object_map);
+		set_bit(__obj_to_index(s, addr, p), object_map);
 
 	return object_map;
 }
@@ -3758,6 +3752,7 @@ static int calculate_sizes(struct kmem_c
 	 */
 	size = ALIGN(size, s->align);
 	s->size = size;
+	s->reciprocal_size = reciprocal_value(size);
 	if (forced_order >= 0)
 		order = forced_order;
 	else
@@ -3862,7 +3857,7 @@ static void list_slab_objects(struct kme
 	map = get_map(s, page);
 	for_each_object(p, s, addr, page->objects) {
 
-		if (!test_bit(slab_index(p, s, addr), map)) {
+		if (!test_bit(__obj_to_index(s, addr, p), map)) {
 			pr_err("INFO: Object 0x%p @offset=%tu\n", p, p - addr);
 			print_tracking(s, p);
 		}
@@ -4578,7 +4573,7 @@ static void validate_slab(struct kmem_ca
 	/* Now we know that a valid freelist exists */
 	map = get_map(s, page);
 	for_each_object(p, s, addr, page->objects) {
-		u8 val = test_bit(slab_index(p, s, addr), map) ?
+		u8 val = test_bit(__obj_to_index(s, addr, p), map) ?
 			 SLUB_RED_INACTIVE : SLUB_RED_ACTIVE;
 
 		if (!check_object(s, page, p, val))
@@ -4769,7 +4764,7 @@ static void process_slab(struct loc_trac
 
 	map = get_map(s, page);
 	for_each_object(p, s, addr, page->objects)
-		if (!test_bit(slab_index(p, s, addr), map))
+		if (!test_bit(__obj_to_index(s, addr, p), map))
 			add_location(t, s, get_track(s, p, alloc));
 	put_map(map);
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
