From: akpm@linux-foundation.org
Subject: + mm-memcg-convert-vmstat-slab-counters-to-bytes.patch
 added to -mm tree
Date: Wed, 17 Jun 2020 16:33:09 -0700
Message-ID: <20200617233309.QgANe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgFQXdM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 19:33:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tobin@kernel.org, tj@kernel.org, shakeelb@google.com, rientjes@google.com, penberg@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net, longman@redhat.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, dennis@kernel.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: mm: memcg: convert vmstat slab counters to bytes
has been added to the -mm tree.  Its filename is
     mm-memcg-convert-vmstat-slab-counters-to-bytes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-convert-vmstat-slab-counters-to-bytes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-convert-vmstat-slab-counters-to-bytes.patch

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
Subject: mm: memcg: convert vmstat slab counters to bytes

In order to prepare for per-object slab memory accounting, convert
NR_SLAB_RECLAIMABLE and NR_SLAB_UNRECLAIMABLE vmstat items to bytes.

To make it obvious, rename them to NR_SLAB_RECLAIMABLE_B and
NR_SLAB_UNRECLAIMABLE_B (similar to NR_KERNEL_STACK_KB).

Internally global and per-node counters are stored in pages, however memcg
and lruvec counters are stored in bytes.  This scheme may look weird, but
only for now.  As soon as slab pages will be shared between multiple
cgroups, global and node counters will reflect the total number of slab
pages.  However memcg and lruvec counters will be used for per-memcg slab
memory tracking, which will take separate kernel objects in the account. 
Keeping global and node counters in pages helps to avoid additional
overhead.

The size of slab memory shouldn't exceed 4Gb on 32-bit machines, so it
will fit into atomic_long_t we use for vmstats.

Link: http://lkml.kernel.org/r/20200608230654.828134-4-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c     |    4 ++--
 fs/proc/meminfo.c       |    4 ++--
 include/linux/mmzone.h  |   16 +++++++++++++---
 kernel/power/snapshot.c |    2 +-
 mm/memcontrol.c         |   11 ++++-------
 mm/oom_kill.c           |    2 +-
 mm/page_alloc.c         |    8 ++++----
 mm/slab.h               |   15 ++++++++-------
 mm/slab_common.c        |    4 ++--
 mm/slob.c               |   12 ++++++------
 mm/slub.c               |    8 ++++----
 mm/vmscan.c             |    3 ++-
 mm/workingset.c         |    6 ++++--
 13 files changed, 53 insertions(+), 42 deletions(-)

--- a/drivers/base/node.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/drivers/base/node.c
@@ -368,8 +368,8 @@ static ssize_t node_read_meminfo(struct
 	unsigned long sreclaimable, sunreclaimable;
 
 	si_meminfo_node(&i, nid);
-	sreclaimable = node_page_state(pgdat, NR_SLAB_RECLAIMABLE);
-	sunreclaimable = node_page_state(pgdat, NR_SLAB_UNRECLAIMABLE);
+	sreclaimable = node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B);
+	sunreclaimable = node_page_state_pages(pgdat, NR_SLAB_UNRECLAIMABLE_B);
 	n = sprintf(buf,
 		       "Node %d MemTotal:       %8lu kB\n"
 		       "Node %d MemFree:        %8lu kB\n"
--- a/fs/proc/meminfo.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/fs/proc/meminfo.c
@@ -52,8 +52,8 @@ static int meminfo_proc_show(struct seq_
 		pages[lru] = global_node_page_state(NR_LRU_BASE + lru);
 
 	available = si_mem_available();
-	sreclaimable = global_node_page_state(NR_SLAB_RECLAIMABLE);
-	sunreclaim = global_node_page_state(NR_SLAB_UNRECLAIMABLE);
+	sreclaimable = global_node_page_state_pages(NR_SLAB_RECLAIMABLE_B);
+	sunreclaim = global_node_page_state_pages(NR_SLAB_UNRECLAIMABLE_B);
 
 	show_val_kb(m, "MemTotal:       ", i.totalram);
 	show_val_kb(m, "MemFree:        ", i.freeram);
--- a/include/linux/mmzone.h~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/include/linux/mmzone.h
@@ -174,8 +174,8 @@ enum node_stat_item {
 	NR_INACTIVE_FILE,	/*  "     "     "   "       "         */
 	NR_ACTIVE_FILE,		/*  "     "     "   "       "         */
 	NR_UNEVICTABLE,		/*  "     "     "   "       "         */
-	NR_SLAB_RECLAIMABLE,
-	NR_SLAB_UNRECLAIMABLE,
+	NR_SLAB_RECLAIMABLE_B,
+	NR_SLAB_UNRECLAIMABLE_B,
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
 	WORKINGSET_NODES,
@@ -213,7 +213,17 @@ enum node_stat_item {
  */
 static __always_inline bool vmstat_item_in_bytes(enum node_stat_item item)
 {
-	return false;
+	/*
+	 * Global and per-node slab counters track slab pages.
+	 * It's expected that changes are multiples of PAGE_SIZE.
+	 * Internally values are stored in pages.
+	 *
+	 * Per-memcg and per-lruvec counters track memory, consumed
+	 * by individual slab objects. These counters are actually
+	 * byte-precise.
+	 */
+	return (item == NR_SLAB_RECLAIMABLE_B ||
+		item == NR_SLAB_UNRECLAIMABLE_B);
 }
 
 /*
--- a/kernel/power/snapshot.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/kernel/power/snapshot.c
@@ -1663,7 +1663,7 @@ static unsigned long minimum_image_size(
 {
 	unsigned long size;
 
-	size = global_node_page_state(NR_SLAB_RECLAIMABLE)
+	size = global_node_page_state_pages(NR_SLAB_RECLAIMABLE_B)
 		+ global_node_page_state(NR_ACTIVE_ANON)
 		+ global_node_page_state(NR_INACTIVE_ANON)
 		+ global_node_page_state(NR_ACTIVE_FILE)
--- a/mm/memcontrol.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/memcontrol.c
@@ -1391,9 +1391,8 @@ static char *memory_stat_format(struct m
 		       (u64)memcg_page_state(memcg, MEMCG_KERNEL_STACK_KB) *
 		       1024);
 	seq_buf_printf(&s, "slab %llu\n",
-		       (u64)(memcg_page_state(memcg, NR_SLAB_RECLAIMABLE) +
-			     memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE)) *
-		       PAGE_SIZE);
+		       (u64)(memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
+			     memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B)));
 	seq_buf_printf(&s, "sock %llu\n",
 		       (u64)memcg_page_state(memcg, MEMCG_SOCK) *
 		       PAGE_SIZE);
@@ -1423,11 +1422,9 @@ static char *memory_stat_format(struct m
 			       PAGE_SIZE);
 
 	seq_buf_printf(&s, "slab_reclaimable %llu\n",
-		       (u64)memcg_page_state(memcg, NR_SLAB_RECLAIMABLE) *
-		       PAGE_SIZE);
+		       (u64)memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B));
 	seq_buf_printf(&s, "slab_unreclaimable %llu\n",
-		       (u64)memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE) *
-		       PAGE_SIZE);
+		       (u64)memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B));
 
 	/* Accumulated memory events */
 
--- a/mm/oom_kill.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/oom_kill.c
@@ -184,7 +184,7 @@ static bool is_dump_unreclaim_slabs(void
 		 global_node_page_state(NR_ISOLATED_FILE) +
 		 global_node_page_state(NR_UNEVICTABLE);
 
-	return (global_node_page_state(NR_SLAB_UNRECLAIMABLE) > nr_lru);
+	return (global_node_page_state_pages(NR_SLAB_UNRECLAIMABLE_B) > nr_lru);
 }
 
 /**
--- a/mm/page_alloc.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/page_alloc.c
@@ -5220,8 +5220,8 @@ long si_mem_available(void)
 	 * items that are in use, and cannot be freed. Cap this estimate at the
 	 * low watermark.
 	 */
-	reclaimable = global_node_page_state(NR_SLAB_RECLAIMABLE) +
-			global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE);
+	reclaimable = global_node_page_state_pages(NR_SLAB_RECLAIMABLE_B) +
+		global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE);
 	available += reclaimable - min(reclaimable / 2, wmark_low);
 
 	if (available < 0)
@@ -5364,8 +5364,8 @@ void show_free_areas(unsigned int filter
 		global_node_page_state(NR_UNEVICTABLE),
 		global_node_page_state(NR_FILE_DIRTY),
 		global_node_page_state(NR_WRITEBACK),
-		global_node_page_state(NR_SLAB_RECLAIMABLE),
-		global_node_page_state(NR_SLAB_UNRECLAIMABLE),
+		global_node_page_state_pages(NR_SLAB_RECLAIMABLE_B),
+		global_node_page_state_pages(NR_SLAB_UNRECLAIMABLE_B),
 		global_node_page_state(NR_FILE_MAPPED),
 		global_node_page_state(NR_SHMEM),
 		global_zone_page_state(NR_PAGETABLE),
--- a/mm/slab_common.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/slab_common.c
@@ -1325,8 +1325,8 @@ void *kmalloc_order(size_t size, gfp_t f
 	page = alloc_pages(flags, order);
 	if (likely(page)) {
 		ret = page_address(page);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE,
-				    1 << order);
+		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
+				    PAGE_SIZE << order);
 	}
 	ret = kasan_kmalloc_large(ret, size, flags);
 	/* As ret might get tagged, call kmemleak hook after KASAN. */
--- a/mm/slab.h~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/slab.h
@@ -272,7 +272,7 @@ int __kmem_cache_alloc_bulk(struct kmem_
 static inline int cache_vmstat_idx(struct kmem_cache *s)
 {
 	return (s->flags & SLAB_RECLAIM_ACCOUNT) ?
-		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE;
+		NR_SLAB_RECLAIMABLE_B : NR_SLAB_UNRECLAIMABLE_B;
 }
 
 #ifdef CONFIG_MEMCG_KMEM
@@ -361,7 +361,7 @@ static __always_inline int memcg_charge_
 
 	if (unlikely(!memcg || mem_cgroup_is_root(memcg))) {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    nr_pages);
+				    nr_pages << PAGE_SHIFT);
 		percpu_ref_get_many(&s->memcg_params.refcnt, nr_pages);
 		return 0;
 	}
@@ -371,7 +371,7 @@ static __always_inline int memcg_charge_
 		goto out;
 
 	lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
-	mod_lruvec_state(lruvec, cache_vmstat_idx(s), nr_pages);
+	mod_lruvec_state(lruvec, cache_vmstat_idx(s), nr_pages << PAGE_SHIFT);
 
 	/* transer try_charge() page references to kmem_cache */
 	percpu_ref_get_many(&s->memcg_params.refcnt, nr_pages);
@@ -396,11 +396,12 @@ static __always_inline void memcg_unchar
 	memcg = READ_ONCE(s->memcg_params.memcg);
 	if (likely(!mem_cgroup_is_root(memcg))) {
 		lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
-		mod_lruvec_state(lruvec, cache_vmstat_idx(s), -nr_pages);
+		mod_lruvec_state(lruvec, cache_vmstat_idx(s),
+				 -(nr_pages << PAGE_SHIFT));
 		memcg_kmem_uncharge(memcg, nr_pages);
 	} else {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    -nr_pages);
+				    -(nr_pages << PAGE_SHIFT));
 	}
 	rcu_read_unlock();
 
@@ -484,7 +485,7 @@ static __always_inline int charge_slab_p
 {
 	if (is_root_cache(s)) {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    1 << order);
+				    PAGE_SIZE << order);
 		return 0;
 	}
 
@@ -496,7 +497,7 @@ static __always_inline void uncharge_sla
 {
 	if (is_root_cache(s)) {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    -(1 << order));
+				    -(PAGE_SIZE << order));
 		return;
 	}
 
--- a/mm/slob.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/slob.c
@@ -202,8 +202,8 @@ static void *slob_new_pages(gfp_t gfp, i
 	if (!page)
 		return NULL;
 
-	mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE,
-			    1 << order);
+	mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
+			    PAGE_SIZE << order);
 	return page_address(page);
 }
 
@@ -214,8 +214,8 @@ static void slob_free_pages(void *b, int
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += 1 << order;
 
-	mod_node_page_state(page_pgdat(sp), NR_SLAB_UNRECLAIMABLE,
-			    -(1 << order));
+	mod_node_page_state(page_pgdat(sp), NR_SLAB_UNRECLAIMABLE_B,
+			    -(PAGE_SIZE << order));
 	__free_pages(sp, order);
 }
 
@@ -552,8 +552,8 @@ void kfree(const void *block)
 		slob_free(m, *m + align);
 	} else {
 		unsigned int order = compound_order(sp);
-		mod_node_page_state(page_pgdat(sp), NR_SLAB_UNRECLAIMABLE,
-				    -(1 << order));
+		mod_node_page_state(page_pgdat(sp), NR_SLAB_UNRECLAIMABLE_B,
+				    -(PAGE_SIZE << order));
 		__free_pages(sp, order);
 
 	}
--- a/mm/slub.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/slub.c
@@ -4043,8 +4043,8 @@ static void *kmalloc_large_node(size_t s
 	page = alloc_pages_node(node, flags, order);
 	if (page) {
 		ptr = page_address(page);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE,
-				    1 << order);
+		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
+				    PAGE_SIZE << order);
 	}
 
 	return kmalloc_large_node_hook(ptr, size, flags);
@@ -4175,8 +4175,8 @@ void kfree(const void *x)
 
 		BUG_ON(!PageCompound(page));
 		kfree_hook(object);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE,
-				    -(1 << order));
+		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
+				    -(PAGE_SIZE << order));
 		__free_pages(page, order);
 		return;
 	}
--- a/mm/vmscan.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/vmscan.c
@@ -4222,7 +4222,8 @@ int node_reclaim(struct pglist_data *pgd
 	 * unmapped file backed pages.
 	 */
 	if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
-	    node_page_state(pgdat, NR_SLAB_RECLAIMABLE) <= pgdat->min_slab_pages)
+	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
+	    pgdat->min_slab_pages)
 		return NODE_RECLAIM_FULL;
 
 	/*
--- a/mm/workingset.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/workingset.c
@@ -486,8 +486,10 @@ static unsigned long count_shadow_nodes(
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
 			pages += lruvec_page_state_local(lruvec,
 							 NR_LRU_BASE + i);
-		pages += lruvec_page_state_local(lruvec, NR_SLAB_RECLAIMABLE);
-		pages += lruvec_page_state_local(lruvec, NR_SLAB_UNRECLAIMABLE);
+		pages += lruvec_page_state_local(
+			lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
+		pages += lruvec_page_state_local(
+			lruvec, NR_SLAB_UNRECLAIMABLE_B) >> PAGE_SHIFT;
 	} else
 #endif
 		pages = node_present_pages(sc->nid);
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
