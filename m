From: akpm@linux-foundation.org
Subject: + mm-memcg-slab-obj_cgroup-api.patch added to -mm tree
Date: Wed, 17 Jun 2020 16:33:48 -0700
Message-ID: <20200617233348.IgDUP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgFQXdu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 19:33:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tobin@kernel.org, tj@kernel.org, shakeelb@google.com, rientjes@google.com, penberg@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net, longman@redhat.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, dennis@kernel.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: mm: memcg/slab: obj_cgroup API
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-obj_cgroup-api.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-obj_cgroup-api.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-obj_cgroup-api.patch

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
Subject: mm: memcg/slab: obj_cgroup API

Obj_cgroup API provides an ability to account sub-page sized kernel
objects, which potentially outlive the original memory cgroup.

The top-level API consists of the following functions:
  bool obj_cgroup_tryget(struct obj_cgroup *objcg);
  void obj_cgroup_get(struct obj_cgroup *objcg);
  void obj_cgroup_put(struct obj_cgroup *objcg);

  int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
  void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);

  struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg);
  struct obj_cgroup *get_obj_cgroup_from_current(void);

Object cgroup is basically a pointer to a memory cgroup with a per-cpu
reference counter.  It substitutes a memory cgroup in places where it's
necessary to charge a custom amount of bytes instead of pages.

All charged memory rounded down to pages is charged to the corresponding
memory cgroup using __memcg_kmem_charge().

It implements reparenting: on memcg offlining it's getting reattached to
the parent memory cgroup.  Each online memory cgroup has an associated
active object cgroup to handle new allocations and the list of all
attached object cgroups.  On offlining of a cgroup this list is reparented
and for each object cgroup in the list the memcg pointer is swapped to the
parent memory cgroup.  It prevents long-living objects from pinning the
original memory cgroup in the memory.

The implementation is based on byte-sized per-cpu stocks.  A sub-page
sized leftover is stored in an atomic field, which is a part of obj_cgroup
object.  So on cgroup offlining the leftover is automatically reparented.

memcg->objcg is rcu protected.  objcg->memcg is a raw pointer, which is
always pointing at a memory cgroup, but can be atomically swapped to the
parent memory cgroup.  So the caller must ensure the lifetime of the
cgroup, e.g.  grab rcu_read_lock or css_set_lock.

Link: http://lkml.kernel.org/r/20200608230654.828134-7-guro@fb.com
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   51 ++++++
 mm/memcontrol.c            |  288 ++++++++++++++++++++++++++++++++++-
 2 files changed, 338 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-obj_cgroup-api
+++ a/include/linux/memcontrol.h
@@ -23,6 +23,7 @@
 #include <linux/page-flags.h>
 
 struct mem_cgroup;
+struct obj_cgroup;
 struct page;
 struct mm_struct;
 struct kmem_cache;
@@ -193,6 +194,22 @@ struct memcg_cgwb_frn {
 };
 
 /*
+ * Bucket for arbitrarily byte-sized objects charged to a memory
+ * cgroup. The bucket can be reparented in one piece when the cgroup
+ * is destroyed, without having to round up the individual references
+ * of all live memory objects in the wild.
+ */
+struct obj_cgroup {
+	struct percpu_ref refcnt;
+	struct mem_cgroup *memcg;
+	atomic_t nr_charged_bytes;
+	union {
+		struct list_head list;
+		struct rcu_head rcu;
+	};
+};
+
+/*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
  * statistics based on the statistics developed by Rik Van Riel for clock-pro,
@@ -301,6 +318,8 @@ struct mem_cgroup {
 	int kmemcg_id;
 	enum memcg_kmem_state kmem_state;
 	struct list_head kmem_caches;
+	struct obj_cgroup __rcu *objcg;
+	struct list_head objcg_list;
 #endif
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -416,6 +435,33 @@ struct mem_cgroup *mem_cgroup_from_css(s
 	return css ? container_of(css, struct mem_cgroup, css) : NULL;
 }
 
+static inline bool obj_cgroup_tryget(struct obj_cgroup *objcg)
+{
+	return percpu_ref_tryget(&objcg->refcnt);
+}
+
+static inline void obj_cgroup_get(struct obj_cgroup *objcg)
+{
+	percpu_ref_get(&objcg->refcnt);
+}
+
+static inline void obj_cgroup_put(struct obj_cgroup *objcg)
+{
+	percpu_ref_put(&objcg->refcnt);
+}
+
+/*
+ * After the initialization objcg->memcg is always pointing at
+ * a valid memcg, but can be atomically swapped to the parent memcg.
+ *
+ * The caller must ensure that the returned memcg won't be released:
+ * e.g. acquire the rcu_read_lock or css_set_lock.
+ */
+static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+{
+	return READ_ONCE(objcg->memcg);
+}
+
 static inline void mem_cgroup_put(struct mem_cgroup *memcg)
 {
 	if (memcg)
@@ -1368,6 +1414,11 @@ void __memcg_kmem_uncharge(struct mem_cg
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_page(struct page *page, int order);
 
+struct obj_cgroup *get_obj_cgroup_from_current(void);
+
+int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
+void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
+
 extern struct static_key_false memcg_kmem_enabled_key;
 extern struct workqueue_struct *memcg_kmem_cache_wq;
 
--- a/mm/memcontrol.c~mm-memcg-slab-obj_cgroup-api
+++ a/mm/memcontrol.c
@@ -257,6 +257,98 @@ struct cgroup_subsys_state *vmpressure_t
 }
 
 #ifdef CONFIG_MEMCG_KMEM
+extern spinlock_t css_set_lock;
+
+static void obj_cgroup_release(struct percpu_ref *ref)
+{
+	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
+	struct mem_cgroup *memcg;
+	unsigned int nr_bytes;
+	unsigned int nr_pages;
+	unsigned long flags;
+
+	/*
+	 * At this point all allocated objects are freed, and
+	 * objcg->nr_charged_bytes can't have an arbitrary byte value.
+	 * However, it can be PAGE_SIZE or (x * PAGE_SIZE).
+	 *
+	 * The following sequence can lead to it:
+	 * 1) CPU0: objcg == stock->cached_objcg
+	 * 2) CPU1: we do a small allocation (e.g. 92 bytes),
+	 *          PAGE_SIZE bytes are charged
+	 * 3) CPU1: a process from another memcg is allocating something,
+	 *          the stock if flushed,
+	 *          objcg->nr_charged_bytes = PAGE_SIZE - 92
+	 * 5) CPU0: we do release this object,
+	 *          92 bytes are added to stock->nr_bytes
+	 * 6) CPU0: stock is flushed,
+	 *          92 bytes are added to objcg->nr_charged_bytes
+	 *
+	 * In the result, nr_charged_bytes == PAGE_SIZE.
+	 * This page will be uncharged in obj_cgroup_release().
+	 */
+	nr_bytes = atomic_read(&objcg->nr_charged_bytes);
+	WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1));
+	nr_pages = nr_bytes >> PAGE_SHIFT;
+
+	spin_lock_irqsave(&css_set_lock, flags);
+	memcg = obj_cgroup_memcg(objcg);
+	if (nr_pages)
+		__memcg_kmem_uncharge(memcg, nr_pages);
+	list_del(&objcg->list);
+	mem_cgroup_put(memcg);
+	spin_unlock_irqrestore(&css_set_lock, flags);
+
+	percpu_ref_exit(ref);
+	kfree_rcu(objcg, rcu);
+}
+
+static struct obj_cgroup *obj_cgroup_alloc(void)
+{
+	struct obj_cgroup *objcg;
+	int ret;
+
+	objcg = kzalloc(sizeof(struct obj_cgroup), GFP_KERNEL);
+	if (!objcg)
+		return NULL;
+
+	ret = percpu_ref_init(&objcg->refcnt, obj_cgroup_release, 0,
+			      GFP_KERNEL);
+	if (ret) {
+		kfree(objcg);
+		return NULL;
+	}
+	INIT_LIST_HEAD(&objcg->list);
+	return objcg;
+}
+
+static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
+				  struct mem_cgroup *parent)
+{
+	struct obj_cgroup *objcg, *iter;
+
+	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
+
+	spin_lock_irq(&css_set_lock);
+
+	/* Move active objcg to the parent's list */
+	xchg(&objcg->memcg, parent);
+	css_get(&parent->css);
+	list_add(&objcg->list, &parent->objcg_list);
+
+	/* Move already reparented objcgs to the parent's list */
+	list_for_each_entry(iter, &memcg->objcg_list, list) {
+		css_get(&parent->css);
+		xchg(&iter->memcg, parent);
+		css_put(&memcg->css);
+	}
+	list_splice(&memcg->objcg_list, &parent->objcg_list);
+
+	spin_unlock_irq(&css_set_lock);
+
+	percpu_ref_kill(&objcg->refcnt);
+}
+
 /*
  * This will be the memcg's index in each cache's ->memcg_params.memcg_caches.
  * The main reason for not using cgroup id for this:
@@ -2047,6 +2139,12 @@ EXPORT_SYMBOL(unlock_page_memcg);
 struct memcg_stock_pcp {
 	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
+
+#ifdef CONFIG_MEMCG_KMEM
+	struct obj_cgroup *cached_objcg;
+	unsigned int nr_bytes;
+#endif
+
 	struct work_struct work;
 	unsigned long flags;
 #define FLUSHING_CACHED_CHARGE	0
@@ -2054,6 +2152,22 @@ struct memcg_stock_pcp {
 static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
 static DEFINE_MUTEX(percpu_charge_mutex);
 
+#ifdef CONFIG_MEMCG_KMEM
+static void drain_obj_stock(struct memcg_stock_pcp *stock);
+static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
+				     struct mem_cgroup *root_memcg);
+
+#else
+static inline void drain_obj_stock(struct memcg_stock_pcp *stock)
+{
+}
+static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
+				     struct mem_cgroup *root_memcg)
+{
+	return false;
+}
+#endif
+
 /**
  * consume_stock: Try to consume stocked charge on this cpu.
  * @memcg: memcg to consume from.
@@ -2120,6 +2234,7 @@ static void drain_local_stock(struct wor
 	local_irq_save(flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
+	drain_obj_stock(stock);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
@@ -2179,6 +2294,8 @@ static void drain_all_stock(struct mem_c
 		if (memcg && stock->nr_pages &&
 		    mem_cgroup_is_descendant(memcg, root_memcg))
 			flush = true;
+		if (obj_stock_flush_required(stock, root_memcg))
+			flush = true;
 		rcu_read_unlock();
 
 		if (flush &&
@@ -2705,6 +2822,30 @@ struct mem_cgroup *mem_cgroup_from_obj(v
 	return page->mem_cgroup;
 }
 
+__always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
+{
+	struct obj_cgroup *objcg = NULL;
+	struct mem_cgroup *memcg;
+
+	if (unlikely(!current->mm))
+		return NULL;
+
+	rcu_read_lock();
+	if (unlikely(current->active_memcg))
+		memcg = rcu_dereference(current->active_memcg);
+	else
+		memcg = mem_cgroup_from_task(current);
+
+	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
+		objcg = rcu_dereference(memcg->objcg);
+		if (objcg && obj_cgroup_tryget(objcg))
+			break;
+	}
+	rcu_read_unlock();
+
+	return objcg;
+}
+
 static int memcg_alloc_cache_id(void)
 {
 	int id, size;
@@ -2996,6 +3137,140 @@ void __memcg_kmem_uncharge_page(struct p
 	if (PageKmemcg(page))
 		__ClearPageKmemcg(page);
 }
+
+static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
+{
+	struct memcg_stock_pcp *stock;
+	unsigned long flags;
+	bool ret = false;
+
+	local_irq_save(flags);
+
+	stock = this_cpu_ptr(&memcg_stock);
+	if (objcg == stock->cached_objcg && stock->nr_bytes >= nr_bytes) {
+		stock->nr_bytes -= nr_bytes;
+		ret = true;
+	}
+
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+static void drain_obj_stock(struct memcg_stock_pcp *stock)
+{
+	struct obj_cgroup *old = stock->cached_objcg;
+
+	if (!old)
+		return;
+
+	if (stock->nr_bytes) {
+		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
+		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
+
+		if (nr_pages) {
+			rcu_read_lock();
+			__memcg_kmem_uncharge(obj_cgroup_memcg(old), nr_pages);
+			rcu_read_unlock();
+		}
+
+		/*
+		 * The leftover is flushed to the centralized per-memcg value.
+		 * On the next attempt to refill obj stock it will be moved
+		 * to a per-cpu stock (probably, on an other CPU), see
+		 * refill_obj_stock().
+		 *
+		 * How often it's flushed is a trade-off between the memory
+		 * limit enforcement accuracy and potential CPU contention,
+		 * so it might be changed in the future.
+		 */
+		atomic_add(nr_bytes, &old->nr_charged_bytes);
+		stock->nr_bytes = 0;
+	}
+
+	obj_cgroup_put(old);
+	stock->cached_objcg = NULL;
+}
+
+static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
+				     struct mem_cgroup *root_memcg)
+{
+	struct mem_cgroup *memcg;
+
+	if (stock->cached_objcg) {
+		memcg = obj_cgroup_memcg(stock->cached_objcg);
+		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
+			return true;
+	}
+
+	return false;
+}
+
+static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
+{
+	struct memcg_stock_pcp *stock;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	stock = this_cpu_ptr(&memcg_stock);
+	if (stock->cached_objcg != objcg) { /* reset if necessary */
+		drain_obj_stock(stock);
+		obj_cgroup_get(objcg);
+		stock->cached_objcg = objcg;
+		stock->nr_bytes = atomic_xchg(&objcg->nr_charged_bytes, 0);
+	}
+	stock->nr_bytes += nr_bytes;
+
+	if (stock->nr_bytes > PAGE_SIZE)
+		drain_obj_stock(stock);
+
+	local_irq_restore(flags);
+}
+
+int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
+{
+	struct mem_cgroup *memcg;
+	unsigned int nr_pages, nr_bytes;
+	int ret;
+
+	if (consume_obj_stock(objcg, size))
+		return 0;
+
+	/*
+	 * In theory, memcg->nr_charged_bytes can have enough
+	 * pre-charged bytes to satisfy the allocation. However,
+	 * flushing memcg->nr_charged_bytes requires two atomic
+	 * operations, and memcg->nr_charged_bytes can't be big,
+	 * so it's better to ignore it and try grab some new pages.
+	 * memcg->nr_charged_bytes will be flushed in
+	 * refill_obj_stock(), called from this function or
+	 * independently later.
+	 */
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	css_get(&memcg->css);
+	rcu_read_unlock();
+
+	nr_pages = size >> PAGE_SHIFT;
+	nr_bytes = size & (PAGE_SIZE - 1);
+
+	if (nr_bytes)
+		nr_pages += 1;
+
+	ret = __memcg_kmem_charge(memcg, gfp, nr_pages);
+	if (!ret && nr_bytes)
+		refill_obj_stock(objcg, PAGE_SIZE - nr_bytes);
+
+	css_put(&memcg->css);
+	return ret;
+}
+
+void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
+{
+	refill_obj_stock(objcg, size);
+}
+
 #endif /* CONFIG_MEMCG_KMEM */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -3416,6 +3691,7 @@ static void memcg_flush_percpu_vmevents(
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
+	struct obj_cgroup *objcg;
 	int memcg_id;
 
 	if (cgroup_memory_nokmem)
@@ -3428,6 +3704,14 @@ static int memcg_online_kmem(struct mem_
 	if (memcg_id < 0)
 		return memcg_id;
 
+	objcg = obj_cgroup_alloc();
+	if (!objcg) {
+		memcg_free_cache_id(memcg_id);
+		return -ENOMEM;
+	}
+	objcg->memcg = memcg;
+	rcu_assign_pointer(memcg->objcg, objcg);
+
 	static_branch_inc(&memcg_kmem_enabled_key);
 	/*
 	 * A memory cgroup is considered kmem-online as soon as it gets
@@ -3463,9 +3747,10 @@ static void memcg_offline_kmem(struct me
 		parent = root_mem_cgroup;
 
 	/*
-	 * Deactivate and reparent kmem_caches.
+	 * Deactivate and reparent kmem_caches and objcgs.
 	 */
 	memcg_deactivate_kmem_caches(memcg, parent);
+	memcg_reparent_objcgs(memcg, parent);
 
 	kmemcg_id = memcg->kmemcg_id;
 	BUG_ON(kmemcg_id < 0);
@@ -5034,6 +5319,7 @@ static struct mem_cgroup *mem_cgroup_all
 	memcg->socket_pressure = jiffies;
 #ifdef CONFIG_MEMCG_KMEM
 	memcg->kmemcg_id = -1;
+	INIT_LIST_HEAD(&memcg->objcg_list);
 #endif
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
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
