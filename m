From: akpm@linux-foundation.org
Subject: +
 mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch added to -mm
 tree
Date: Wed, 17 Jun 2020 16:34:55 -0700
Message-ID: <20200617233455.Np_jQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgFQXe5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 19:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tobin@kernel.org, tj@kernel.org, shakeelb@google.com, rientjes@google.com, penberg@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net, longman@redhat.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, dennis@kernel.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: mm: memcg/percpu: account percpu memory to memory cgroups
has been added to the -mm tree.  Its filename is
     mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch

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
Subject: mm: memcg/percpu: account percpu memory to memory cgroups

Percpu memory is becoming more and more widely used by various subsystems,
and the total amount of memory controlled by the percpu allocator can make
a good part of the total memory.

As an example, bpf maps can consume a lot of percpu memory, and they are
created by a user.  Also, some cgroup internals (e.g.  memory controller
statistics) can be quite large.  On a machine with many CPUs and big
number of cgroups they can consume hundreds of megabytes.

So the lack of memcg accounting is creating a breach in the memory
isolation.  Similar to the slab memory, percpu memory should be accounted
by default.

To implement the perpcu accounting it's possible to take the slab memory
accounting as a model to follow.  Let's introduce two types of percpu
chunks: root and memcg.  What makes memcg chunks different is an
additional space allocated to store memcg membership information.  If
__GFP_ACCOUNT is passed on allocation, a memcg chunk should be be used. 
If it's possible to charge the corresponding size to the target memory
cgroup, allocation is performed, and the memcg ownership data is recorded.
System-wide allocations are performed using root chunks, so there is no
additional memory overhead.

To implement a fast reparenting of percpu memory on memcg removal, we
don't store mem_cgroup pointers directly: instead we use obj_cgroup API,
introduced for slab accounting.

Link: http://lkml.kernel.org/r/20200608230819.832349-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-internal.h |   55 ++++++++++++
 mm/percpu-km.c       |    5 -
 mm/percpu-stats.c    |   36 ++++----
 mm/percpu-vm.c       |    5 -
 mm/percpu.c          |  183 ++++++++++++++++++++++++++++++++++++-----
 5 files changed, 244 insertions(+), 40 deletions(-)

--- a/mm/percpu.c~mm-memcg-percpu-account-percpu-memory-to-memory-cgroups
+++ a/mm/percpu.c
@@ -37,9 +37,14 @@
  * takes care of normal allocations.
  *
  * The allocator organizes chunks into lists according to free size and
- * tries to allocate from the fullest chunk first.  Each chunk is managed
- * by a bitmap with metadata blocks.  The allocation map is updated on
- * every allocation and free to reflect the current state while the boundary
+ * memcg-awareness.  To make a percpu allocation memcg-aware the __GFP_ACCOUNT
+ * flag should be passed.  All memcg-aware allocations are sharing one set
+ * of chunks and all unaccounted allocations and allocations performed
+ * by processes belonging to the root memory cgroup are using the second set.
+ *
+ * The allocator tries to allocate from the fullest chunk first. Each chunk
+ * is managed by a bitmap with metadata blocks.  The allocation map is updated
+ * on every allocation and free to reflect the current state while the boundary
  * map is only updated on allocation.  Each metadata block contains
  * information to help mitigate the need to iterate over large portions
  * of the bitmap.  The reverse mapping from page to chunk is stored in
@@ -81,6 +86,7 @@
 #include <linux/kmemleak.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
+#include <linux/memcontrol.h>
 
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
@@ -160,7 +166,7 @@ struct pcpu_chunk *pcpu_reserved_chunk _
 DEFINE_SPINLOCK(pcpu_lock);	/* all internal data structures */
 static DEFINE_MUTEX(pcpu_alloc_mutex);	/* chunk create/destroy, [de]pop, map ext */
 
-struct list_head *pcpu_slot __ro_after_init; /* chunk list slots */
+struct list_head *pcpu_chunk_lists __ro_after_init; /* chunk list slots */
 
 /* chunks which need their map areas extended, protected by pcpu_lock */
 static LIST_HEAD(pcpu_map_extend_chunks);
@@ -500,6 +506,9 @@ static void __pcpu_chunk_move(struct pcp
 			      bool move_front)
 {
 	if (chunk != pcpu_reserved_chunk) {
+		struct list_head *pcpu_slot;
+
+		pcpu_slot = pcpu_chunk_list(pcpu_chunk_type(chunk));
 		if (move_front)
 			list_move(&chunk->list, &pcpu_slot[slot]);
 		else
@@ -1341,6 +1350,10 @@ static struct pcpu_chunk * __init pcpu_a
 		panic("%s: Failed to allocate %zu bytes\n", __func__,
 		      alloc_size);
 
+#ifdef CONFIG_MEMCG_KMEM
+	/* first chunk isn't memcg-aware */
+	chunk->obj_cgroups = NULL;
+#endif
 	pcpu_init_md_blocks(chunk);
 
 	/* manage populated page bitmap */
@@ -1380,7 +1393,7 @@ static struct pcpu_chunk * __init pcpu_a
 	return chunk;
 }
 
-static struct pcpu_chunk *pcpu_alloc_chunk(gfp_t gfp)
+static struct pcpu_chunk *pcpu_alloc_chunk(enum pcpu_chunk_type type, gfp_t gfp)
 {
 	struct pcpu_chunk *chunk;
 	int region_bits;
@@ -1408,6 +1421,16 @@ static struct pcpu_chunk *pcpu_alloc_chu
 	if (!chunk->md_blocks)
 		goto md_blocks_fail;
 
+#ifdef CONFIG_MEMCG_KMEM
+	if (pcpu_is_memcg_chunk(type)) {
+		chunk->obj_cgroups =
+			pcpu_mem_zalloc(pcpu_chunk_map_bits(chunk) *
+					sizeof(struct obj_cgroup *), gfp);
+		if (!chunk->obj_cgroups)
+			goto objcg_fail;
+	}
+#endif
+
 	pcpu_init_md_blocks(chunk);
 
 	/* init metadata */
@@ -1415,6 +1438,8 @@ static struct pcpu_chunk *pcpu_alloc_chu
 
 	return chunk;
 
+objcg_fail:
+	pcpu_mem_free(chunk->md_blocks);
 md_blocks_fail:
 	pcpu_mem_free(chunk->bound_map);
 bound_map_fail:
@@ -1429,6 +1454,9 @@ static void pcpu_free_chunk(struct pcpu_
 {
 	if (!chunk)
 		return;
+#ifdef CONFIG_MEMCG_KMEM
+	pcpu_mem_free(chunk->obj_cgroups);
+#endif
 	pcpu_mem_free(chunk->md_blocks);
 	pcpu_mem_free(chunk->bound_map);
 	pcpu_mem_free(chunk->alloc_map);
@@ -1505,7 +1533,8 @@ static int pcpu_populate_chunk(struct pc
 			       int page_start, int page_end, gfp_t gfp);
 static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk,
 				  int page_start, int page_end);
-static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp);
+static struct pcpu_chunk *pcpu_create_chunk(enum pcpu_chunk_type type,
+					    gfp_t gfp);
 static void pcpu_destroy_chunk(struct pcpu_chunk *chunk);
 static struct page *pcpu_addr_to_page(void *addr);
 static int __init pcpu_verify_alloc_info(const struct pcpu_alloc_info *ai);
@@ -1547,6 +1576,77 @@ static struct pcpu_chunk *pcpu_chunk_add
 	return pcpu_get_page_chunk(pcpu_addr_to_page(addr));
 }
 
+#ifdef CONFIG_MEMCG_KMEM
+static enum pcpu_chunk_type pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
+						     struct obj_cgroup **objcgp)
+{
+	struct obj_cgroup *objcg;
+
+	if (!memcg_kmem_enabled() || !(gfp & __GFP_ACCOUNT) ||
+	    memcg_kmem_bypass())
+		return PCPU_CHUNK_ROOT;
+
+	objcg = get_obj_cgroup_from_current();
+	if (!objcg)
+		return PCPU_CHUNK_ROOT;
+
+	if (obj_cgroup_charge(objcg, gfp, size * num_possible_cpus())) {
+		obj_cgroup_put(objcg);
+		return PCPU_FAIL_ALLOC;
+	}
+
+	*objcgp = objcg;
+	return PCPU_CHUNK_MEMCG;
+}
+
+static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
+				       struct pcpu_chunk *chunk, int off,
+				       size_t size)
+{
+	if (!objcg)
+		return;
+
+	if (chunk) {
+		chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT] = objcg;
+	} else {
+		obj_cgroup_uncharge(objcg, size * num_possible_cpus());
+		obj_cgroup_put(objcg);
+	}
+}
+
+static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
+{
+	struct obj_cgroup *objcg;
+
+	if (!pcpu_is_memcg_chunk(pcpu_chunk_type(chunk)))
+		return;
+
+	objcg = chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT];
+	chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT] = NULL;
+
+	obj_cgroup_uncharge(objcg, size * num_possible_cpus());
+
+	obj_cgroup_put(objcg);
+}
+
+#else /* CONFIG_MEMCG_KMEM */
+static enum pcpu_chunk_type pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
+						     struct mem_cgroup **memcgp)
+{
+	return PCPU_CHUNK_ROOT;
+}
+
+static void pcpu_memcg_post_alloc_hook(struct mem_cgroup *memcg,
+				       struct pcpu_chunk *chunk, int off,
+				       size_t size)
+{
+}
+
+static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
+{
+}
+#endif /* CONFIG_MEMCG_KMEM */
+
 /**
  * pcpu_alloc - the percpu allocator
  * @size: size of area to allocate in bytes
@@ -1568,6 +1668,9 @@ static void __percpu *pcpu_alloc(size_t
 	gfp_t pcpu_gfp;
 	bool is_atomic;
 	bool do_warn;
+	enum pcpu_chunk_type type;
+	struct list_head *pcpu_slot;
+	struct obj_cgroup *objcg = NULL;
 	static int warn_limit = 10;
 	struct pcpu_chunk *chunk, *next;
 	const char *err;
@@ -1602,16 +1705,23 @@ static void __percpu *pcpu_alloc(size_t
 		return NULL;
 	}
 
+	type = pcpu_memcg_pre_alloc_hook(size, gfp, &objcg);
+	if (unlikely(type == PCPU_FAIL_ALLOC))
+		return NULL;
+	pcpu_slot = pcpu_chunk_list(type);
+
 	if (!is_atomic) {
 		/*
 		 * pcpu_balance_workfn() allocates memory under this mutex,
 		 * and it may wait for memory reclaim. Allow current task
 		 * to become OOM victim, in case of memory pressure.
 		 */
-		if (gfp & __GFP_NOFAIL)
+		if (gfp & __GFP_NOFAIL) {
 			mutex_lock(&pcpu_alloc_mutex);
-		else if (mutex_lock_killable(&pcpu_alloc_mutex))
+		} else if (mutex_lock_killable(&pcpu_alloc_mutex)) {
+			pcpu_memcg_post_alloc_hook(objcg, NULL, 0, size);
 			return NULL;
+		}
 	}
 
 	spin_lock_irqsave(&pcpu_lock, flags);
@@ -1666,7 +1776,7 @@ restart:
 	}
 
 	if (list_empty(&pcpu_slot[pcpu_nr_slots - 1])) {
-		chunk = pcpu_create_chunk(pcpu_gfp);
+		chunk = pcpu_create_chunk(type, pcpu_gfp);
 		if (!chunk) {
 			err = "failed to allocate new chunk";
 			goto fail;
@@ -1723,6 +1833,8 @@ area_found:
 	trace_percpu_alloc_percpu(reserved, is_atomic, size, align,
 			chunk->base_addr, off, ptr);
 
+	pcpu_memcg_post_alloc_hook(objcg, chunk, off, size);
+
 	return ptr;
 
 fail_unlock:
@@ -1744,6 +1856,9 @@ fail:
 	} else {
 		mutex_unlock(&pcpu_alloc_mutex);
 	}
+
+	pcpu_memcg_post_alloc_hook(objcg, NULL, 0, size);
+
 	return NULL;
 }
 
@@ -1803,8 +1918,8 @@ void __percpu *__alloc_reserved_percpu(s
 }
 
 /**
- * pcpu_balance_workfn - manage the amount of free chunks and populated pages
- * @work: unused
+ * __pcpu_balance_workfn - manage the amount of free chunks and populated pages
+ * @type: chunk type
  *
  * Reclaim all fully free chunks except for the first one.  This is also
  * responsible for maintaining the pool of empty populated pages.  However,
@@ -1813,11 +1928,12 @@ void __percpu *__alloc_reserved_percpu(s
  * allocation causes the failure as it is possible that requests can be
  * serviced from already backed regions.
  */
-static void pcpu_balance_workfn(struct work_struct *work)
+static void __pcpu_balance_workfn(enum pcpu_chunk_type type)
 {
 	/* gfp flags passed to underlying allocators */
 	const gfp_t gfp = GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
 	LIST_HEAD(to_free);
+	struct list_head *pcpu_slot = pcpu_chunk_list(type);
 	struct list_head *free_head = &pcpu_slot[pcpu_nr_slots - 1];
 	struct pcpu_chunk *chunk, *next;
 	int slot, nr_to_pop, ret;
@@ -1915,7 +2031,7 @@ retry_pop:
 
 	if (nr_to_pop) {
 		/* ran out of chunks to populate, create a new one and retry */
-		chunk = pcpu_create_chunk(gfp);
+		chunk = pcpu_create_chunk(type, gfp);
 		if (chunk) {
 			spin_lock_irq(&pcpu_lock);
 			pcpu_chunk_relocate(chunk, -1);
@@ -1928,6 +2044,20 @@ retry_pop:
 }
 
 /**
+ * pcpu_balance_workfn - manage the amount of free chunks and populated pages
+ * @work: unused
+ *
+ * Call __pcpu_balance_workfn() for each chunk type.
+ */
+static void pcpu_balance_workfn(struct work_struct *work)
+{
+	enum pcpu_chunk_type type;
+
+	for (type = 0; type < PCPU_NR_CHUNK_TYPES; type++)
+		__pcpu_balance_workfn(type);
+}
+
+/**
  * free_percpu - free percpu area
  * @ptr: pointer to area to free
  *
@@ -1941,8 +2071,9 @@ void free_percpu(void __percpu *ptr)
 	void *addr;
 	struct pcpu_chunk *chunk;
 	unsigned long flags;
-	int off;
+	int size, off;
 	bool need_balance = false;
+	struct list_head *pcpu_slot;
 
 	if (!ptr)
 		return;
@@ -1956,7 +2087,11 @@ void free_percpu(void __percpu *ptr)
 	chunk = pcpu_chunk_addr_search(addr);
 	off = addr - chunk->base_addr;
 
-	pcpu_free_area(chunk, off);
+	size = pcpu_free_area(chunk, off);
+
+	pcpu_slot = pcpu_chunk_list(pcpu_chunk_type(chunk));
+
+	pcpu_memcg_free_hook(chunk, off, size);
 
 	/* if there are more than one fully free chunks, wake up grim reaper */
 	if (chunk->free_bytes == pcpu_unit_size) {
@@ -2267,6 +2402,7 @@ void __init pcpu_setup_first_chunk(const
 	int map_size;
 	unsigned long tmp_addr;
 	size_t alloc_size;
+	enum pcpu_chunk_type type;
 
 #define PCPU_SETUP_BUG_ON(cond)	do {					\
 	if (unlikely(cond)) {						\
@@ -2384,13 +2520,18 @@ void __init pcpu_setup_first_chunk(const
 	 * empty chunks.
 	 */
 	pcpu_nr_slots = __pcpu_size_to_slot(pcpu_unit_size) + 2;
-	pcpu_slot = memblock_alloc(pcpu_nr_slots * sizeof(pcpu_slot[0]),
-				   SMP_CACHE_BYTES);
-	if (!pcpu_slot)
+	pcpu_chunk_lists = memblock_alloc(pcpu_nr_slots *
+					  sizeof(pcpu_chunk_lists[0]) *
+					  PCPU_NR_CHUNK_TYPES,
+					  SMP_CACHE_BYTES);
+	if (!pcpu_chunk_lists)
 		panic("%s: Failed to allocate %zu bytes\n", __func__,
-		      pcpu_nr_slots * sizeof(pcpu_slot[0]));
-	for (i = 0; i < pcpu_nr_slots; i++)
-		INIT_LIST_HEAD(&pcpu_slot[i]);
+		      pcpu_nr_slots * sizeof(pcpu_chunk_lists[0]) *
+		      PCPU_NR_CHUNK_TYPES);
+
+	for (type = 0; type < PCPU_NR_CHUNK_TYPES; type++)
+		for (i = 0; i < pcpu_nr_slots; i++)
+			INIT_LIST_HEAD(&pcpu_chunk_list(type)[i]);
 
 	/*
 	 * The end of the static region needs to be aligned with the
--- a/mm/percpu-internal.h~mm-memcg-percpu-account-percpu-memory-to-memory-cgroups
+++ a/mm/percpu-internal.h
@@ -6,6 +6,25 @@
 #include <linux/percpu.h>
 
 /*
+ * There are two chunk types: root and memcg-aware.
+ * Chunks of each type have separate slots list.
+ *
+ * Memcg-aware chunks have an attached vector of obj_cgroup pointers, which is
+ * used to store memcg membership data of a percpu object.  Obj_cgroups are
+ * ref-counted pointers to a memory cgroup with an ability to switch dynamically
+ * to the parent memory cgroup.  This allows to reclaim a deleted memory cgroup
+ * without reclaiming of all outstanding objects, which hold a reference at it.
+ */
+enum pcpu_chunk_type {
+	PCPU_CHUNK_ROOT,
+#ifdef CONFIG_MEMCG_KMEM
+	PCPU_CHUNK_MEMCG,
+#endif
+	PCPU_NR_CHUNK_TYPES,
+	PCPU_FAIL_ALLOC = PCPU_NR_CHUNK_TYPES
+};
+
+/*
  * pcpu_block_md is the metadata block struct.
  * Each chunk's bitmap is split into a number of full blocks.
  * All units are in terms of bits.
@@ -54,6 +73,9 @@ struct pcpu_chunk {
 	int			end_offset;	/* additional area required to
 						   have the region end page
 						   aligned */
+#ifdef CONFIG_MEMCG_KMEM
+	struct obj_cgroup	**obj_cgroups;	/* vector of object cgroups */
+#endif
 
 	int			nr_pages;	/* # of pages served by this chunk */
 	int			nr_populated;	/* # of populated pages */
@@ -63,7 +85,7 @@ struct pcpu_chunk {
 
 extern spinlock_t pcpu_lock;
 
-extern struct list_head *pcpu_slot;
+extern struct list_head *pcpu_chunk_lists;
 extern int pcpu_nr_slots;
 extern int pcpu_nr_empty_pop_pages;
 
@@ -106,6 +128,37 @@ static inline int pcpu_chunk_map_bits(st
 	return pcpu_nr_pages_to_map_bits(chunk->nr_pages);
 }
 
+#ifdef CONFIG_MEMCG_KMEM
+static enum pcpu_chunk_type pcpu_chunk_type(struct pcpu_chunk *chunk)
+{
+	if (chunk->obj_cgroups)
+		return PCPU_CHUNK_MEMCG;
+	return PCPU_CHUNK_ROOT;
+}
+
+static bool pcpu_is_memcg_chunk(enum pcpu_chunk_type chunk_type)
+{
+	return chunk_type == PCPU_CHUNK_MEMCG;
+}
+
+#else
+static enum pcpu_chunk_type pcpu_chunk_type(struct pcpu_chunk *chunk)
+{
+	return PCPU_CHUNK_ROOT;
+}
+
+static bool pcpu_is_memcg_chunk(enum pcpu_chunk_type chunk_type)
+{
+	return false;
+}
+#endif
+
+static struct list_head *pcpu_chunk_list(enum pcpu_chunk_type chunk_type)
+{
+	return &pcpu_chunk_lists[pcpu_nr_slots *
+				 pcpu_is_memcg_chunk(chunk_type)];
+}
+
 #ifdef CONFIG_PERCPU_STATS
 
 #include <linux/spinlock.h>
--- a/mm/percpu-km.c~mm-memcg-percpu-account-percpu-memory-to-memory-cgroups
+++ a/mm/percpu-km.c
@@ -44,7 +44,8 @@ static void pcpu_depopulate_chunk(struct
 	/* nada */
 }
 
-static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
+static struct pcpu_chunk *pcpu_create_chunk(enum pcpu_chunk_type type,
+					    gfp_t gfp)
 {
 	const int nr_pages = pcpu_group_sizes[0] >> PAGE_SHIFT;
 	struct pcpu_chunk *chunk;
@@ -52,7 +53,7 @@ static struct pcpu_chunk *pcpu_create_ch
 	unsigned long flags;
 	int i;
 
-	chunk = pcpu_alloc_chunk(gfp);
+	chunk = pcpu_alloc_chunk(type, gfp);
 	if (!chunk)
 		return NULL;
 
--- a/mm/percpu-stats.c~mm-memcg-percpu-account-percpu-memory-to-memory-cgroups
+++ a/mm/percpu-stats.c
@@ -34,11 +34,15 @@ static int find_max_nr_alloc(void)
 {
 	struct pcpu_chunk *chunk;
 	int slot, max_nr_alloc;
+	enum pcpu_chunk_type type;
 
 	max_nr_alloc = 0;
-	for (slot = 0; slot < pcpu_nr_slots; slot++)
-		list_for_each_entry(chunk, &pcpu_slot[slot], list)
-			max_nr_alloc = max(max_nr_alloc, chunk->nr_alloc);
+	for (type = 0; type < PCPU_NR_CHUNK_TYPES; type++)
+		for (slot = 0; slot < pcpu_nr_slots; slot++)
+			list_for_each_entry(chunk, &pcpu_chunk_list(type)[slot],
+					    list)
+				max_nr_alloc = max(max_nr_alloc,
+						   chunk->nr_alloc);
 
 	return max_nr_alloc;
 }
@@ -129,6 +133,9 @@ static void chunk_map_stats(struct seq_f
 	P("cur_min_alloc", cur_min_alloc);
 	P("cur_med_alloc", cur_med_alloc);
 	P("cur_max_alloc", cur_max_alloc);
+#ifdef CONFIG_MEMCG_KMEM
+	P("memcg_aware", pcpu_is_memcg_chunk(pcpu_chunk_type(chunk)));
+#endif
 	seq_putc(m, '\n');
 }
 
@@ -137,6 +144,7 @@ static int percpu_stats_show(struct seq_
 	struct pcpu_chunk *chunk;
 	int slot, max_nr_alloc;
 	int *buffer;
+	enum pcpu_chunk_type type;
 
 alloc_buffer:
 	spin_lock_irq(&pcpu_lock);
@@ -202,18 +210,18 @@ alloc_buffer:
 		chunk_map_stats(m, pcpu_reserved_chunk, buffer);
 	}
 
-	for (slot = 0; slot < pcpu_nr_slots; slot++) {
-		list_for_each_entry(chunk, &pcpu_slot[slot], list) {
-			if (chunk == pcpu_first_chunk) {
-				seq_puts(m, "Chunk: <- First Chunk\n");
-				chunk_map_stats(m, chunk, buffer);
-
-
-			} else {
-				seq_puts(m, "Chunk:\n");
-				chunk_map_stats(m, chunk, buffer);
+	for (type = 0; type < PCPU_NR_CHUNK_TYPES; type++) {
+		for (slot = 0; slot < pcpu_nr_slots; slot++) {
+			list_for_each_entry(chunk, &pcpu_chunk_list(type)[slot],
+					    list) {
+				if (chunk == pcpu_first_chunk) {
+					seq_puts(m, "Chunk: <- First Chunk\n");
+					chunk_map_stats(m, chunk, buffer);
+				} else {
+					seq_puts(m, "Chunk:\n");
+					chunk_map_stats(m, chunk, buffer);
+				}
 			}
-
 		}
 	}
 
--- a/mm/percpu-vm.c~mm-memcg-percpu-account-percpu-memory-to-memory-cgroups
+++ a/mm/percpu-vm.c
@@ -328,12 +328,13 @@ static void pcpu_depopulate_chunk(struct
 	pcpu_free_pages(chunk, pages, page_start, page_end);
 }
 
-static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
+static struct pcpu_chunk *pcpu_create_chunk(enum pcpu_chunk_type type,
+					    gfp_t gfp)
 {
 	struct pcpu_chunk *chunk;
 	struct vm_struct **vms;
 
-	chunk = pcpu_alloc_chunk(gfp);
+	chunk = pcpu_alloc_chunk(type, gfp);
 	if (!chunk)
 		return NULL;
 
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
