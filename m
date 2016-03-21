From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-introduce-kcompactd.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:38:31 -0700
Message-ID: <56f03fa7.Mrkkni9WJQlzYnUg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294AbcCUT4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aarcange@redhat.com, arnd@arndb.de, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, paul.gortmaker@windriver.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: introduce kcompactd
has been removed from the -mm tree.  Its filename was
     mm-compaction-introduce-kcompactd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: introduce kcompactd

Memory compaction can be currently performed in several contexts:

- kswapd balancing a zone after a high-order allocation failure
- direct compaction to satisfy a high-order allocation, including THP page
  fault attemps
- khugepaged trying to collapse a hugepage
- manually from /proc

The purpose of compaction is two-fold.  The obvious purpose is to satisfy
a (pending or future) high-order allocation, and is easy to evaluate.  The
other purpose is to keep overal memory fragmentation low and help the
anti-fragmentation mechanism.  The success wrt the latter purpose is more

The current situation wrt the purposes has a few drawbacks:

- compaction is invoked only when a high-order page or hugepage is not
  available (or manually). This might be too late for the purposes of keeping
  memory fragmentation low.
- direct compaction increases latency of allocations. Again, it would be
  better if compaction was performed asynchronously to keep fragmentation low,
  before the allocation itself comes.
- (a special case of the previous) the cost of compaction during THP page
  faults can easily offset the benefits of THP.
- kswapd compaction appears to be complex, fragile and not working in some
  scenarios. It could also end up compacting for a high-order allocation
  request when it should be reclaiming memory for a later order-0 request.

To improve the situation, we should be able to benefit from an equivalent
of kswapd, but for compaction - i.e.  a background thread which responds
to fragmentation and the need for high-order allocations (including
hugepages) somewhat proactively.

One possibility is to extend the responsibilities of kswapd, which could
however complicate its design too much.  It should be better to let kswapd
handle reclaim, as order-0 allocations are often more critical than
high-order ones.

Another possibility is to extend khugepaged, but this kthread is a single
instance and tied to THP configs.

This patch goes with the option of a new set of per-node kthreads called
kcompactd, and lays the foundations, without introducing any new tunables.
The lifecycle mimics kswapd kthreads, including the memory hotplug hooks.

For compaction, kcompactd uses the standard compaction_suitable() and
ompact_finished() criteria and the deferred compaction functionality. 
Unlike direct compaction, it uses only sync compaction, as there's no
allocation latency to minimize.

This patch doesn't yet add a call to wakeup_kcompactd.  The kswapd
compact/reclaim loop for high-order pages will be replaced by waking up
kcompactd in the next patch with the description of what's wrong with the
old approach.

Waking up of the kcompactd threads is also tied to kswapd activity and follows
these rules:
- we don't want to affect any fastpaths, so wake up kcompactd only from the
  slowpath, as it's done for kswapd
- if kswapd is doing reclaim, it's more important than compaction, so don't
  invoke kcompactd until kswapd goes to sleep
- the target order used for kswapd is passed to kcompactd

Future possible future uses for kcompactd include the ability to wake up
kcompactd on demand in special situations, such as when hugepages are not
available (currently not done due to __GFP_NO_KSWAPD) or when a
fragmentation event (i.e.  __rmqueue_fallback()) occurs.  It's also
possible to perform periodic compaction with kcompactd.

[arnd@arndb.de: fix build errors with kcompactd]
[paul.gortmaker@windriver.com: don't use modular references for non modular code]
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h        |   16 ++
 include/linux/mmzone.h            |    6 
 include/linux/vm_event_item.h     |    1 
 include/trace/events/compaction.h |   55 ++++++
 mm/compaction.c                   |  222 ++++++++++++++++++++++++++++
 mm/memory_hotplug.c               |    9 -
 mm/page_alloc.c                   |    3 
 mm/vmstat.c                       |    1 
 8 files changed, 311 insertions(+), 2 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-introduce-kcompactd include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-introduce-kcompactd
+++ a/include/linux/compaction.h
@@ -52,6 +52,10 @@ extern void compaction_defer_reset(struc
 				bool alloc_success);
 extern bool compaction_restarting(struct zone *zone, int order);
 
+extern int kcompactd_run(int nid);
+extern void kcompactd_stop(int nid);
+extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx);
+
 #else
 static inline unsigned long try_to_compact_pages(gfp_t gfp_mask,
 			unsigned int order, int alloc_flags,
@@ -84,6 +88,18 @@ static inline bool compaction_deferred(s
 	return true;
 }
 
+static inline int kcompactd_run(int nid)
+{
+	return 0;
+}
+static inline void kcompactd_stop(int nid)
+{
+}
+
+static inline void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx)
+{
+}
+
 #endif /* CONFIG_COMPACTION */
 
 #if defined(CONFIG_COMPACTION) && defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
diff -puN include/linux/mmzone.h~mm-compaction-introduce-kcompactd include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-introduce-kcompactd
+++ a/include/linux/mmzone.h
@@ -668,6 +668,12 @@ typedef struct pglist_data {
 					   mem_hotplug_begin/end() */
 	int kswapd_max_order;
 	enum zone_type classzone_idx;
+#ifdef CONFIG_COMPACTION
+	int kcompactd_max_order;
+	enum zone_type kcompactd_classzone_idx;
+	wait_queue_head_t kcompactd_wait;
+	struct task_struct *kcompactd;
+#endif
 #ifdef CONFIG_NUMA_BALANCING
 	/* Lock serializing the migrate rate limiting window */
 	spinlock_t numabalancing_migrate_lock;
diff -puN include/linux/vm_event_item.h~mm-compaction-introduce-kcompactd include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-compaction-introduce-kcompactd
+++ a/include/linux/vm_event_item.h
@@ -53,6 +53,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		COMPACTMIGRATE_SCANNED, COMPACTFREE_SCANNED,
 		COMPACTISOLATED,
 		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS,
+		KCOMPACTD_WAKE,
 #endif
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
diff -puN include/trace/events/compaction.h~mm-compaction-introduce-kcompactd include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-introduce-kcompactd
+++ a/include/trace/events/compaction.h
@@ -350,6 +350,61 @@ DEFINE_EVENT(mm_compaction_defer_templat
 );
 #endif
 
+TRACE_EVENT(mm_compaction_kcompactd_sleep,
+
+	TP_PROTO(int nid),
+
+	TP_ARGS(nid),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+	),
+
+	TP_printk("nid=%d", __entry->nid)
+);
+
+DECLARE_EVENT_CLASS(kcompactd_wake_template,
+
+	TP_PROTO(int nid, int order, enum zone_type classzone_idx),
+
+	TP_ARGS(nid, order, classzone_idx),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(int, order)
+		__field(enum zone_type, classzone_idx)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->order = order;
+		__entry->classzone_idx = classzone_idx;
+	),
+
+	TP_printk("nid=%d order=%d classzone_idx=%-8s",
+		__entry->nid,
+		__entry->order,
+		__print_symbolic(__entry->classzone_idx, ZONE_TYPE))
+);
+
+DEFINE_EVENT(kcompactd_wake_template, mm_compaction_wakeup_kcompactd,
+
+	TP_PROTO(int nid, int order, enum zone_type classzone_idx),
+
+	TP_ARGS(nid, order, classzone_idx)
+);
+
+DEFINE_EVENT(kcompactd_wake_template, mm_compaction_kcompactd_wake,
+
+	TP_PROTO(int nid, int order, enum zone_type classzone_idx),
+
+	TP_ARGS(nid, order, classzone_idx)
+);
+
 #endif /* _TRACE_COMPACTION_H */
 
 /* This part must be outside protection */
diff -puN mm/compaction.c~mm-compaction-introduce-kcompactd mm/compaction.c
--- a/mm/compaction.c~mm-compaction-introduce-kcompactd
+++ a/mm/compaction.c
@@ -7,6 +7,7 @@
  *
  * Copyright IBM Corp. 2007-2010 Mel Gorman <mel@csn.ul.ie>
  */
+#include <linux/cpu.h>
 #include <linux/swap.h>
 #include <linux/migrate.h>
 #include <linux/compaction.h>
@@ -17,6 +18,8 @@
 #include <linux/balloon_compaction.h>
 #include <linux/page-isolation.h>
 #include <linux/kasan.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -1736,4 +1739,223 @@ void compaction_unregister_node(struct n
 }
 #endif /* CONFIG_SYSFS && CONFIG_NUMA */
 
+static inline bool kcompactd_work_requested(pg_data_t *pgdat)
+{
+	return pgdat->kcompactd_max_order > 0;
+}
+
+static bool kcompactd_node_suitable(pg_data_t *pgdat)
+{
+	int zoneid;
+	struct zone *zone;
+	enum zone_type classzone_idx = pgdat->kcompactd_classzone_idx;
+
+	for (zoneid = 0; zoneid < classzone_idx; zoneid++) {
+		zone = &pgdat->node_zones[zoneid];
+
+		if (!populated_zone(zone))
+			continue;
+
+		if (compaction_suitable(zone, pgdat->kcompactd_max_order, 0,
+					classzone_idx) == COMPACT_CONTINUE)
+			return true;
+	}
+
+	return false;
+}
+
+static void kcompactd_do_work(pg_data_t *pgdat)
+{
+	/*
+	 * With no special task, compact all zones so that a page of requested
+	 * order is allocatable.
+	 */
+	int zoneid;
+	struct zone *zone;
+	struct compact_control cc = {
+		.order = pgdat->kcompactd_max_order,
+		.classzone_idx = pgdat->kcompactd_classzone_idx,
+		.mode = MIGRATE_SYNC_LIGHT,
+		.ignore_skip_hint = true,
+
+	};
+	bool success = false;
+
+	trace_mm_compaction_kcompactd_wake(pgdat->node_id, cc.order,
+							cc.classzone_idx);
+	count_vm_event(KCOMPACTD_WAKE);
+
+	for (zoneid = 0; zoneid < cc.classzone_idx; zoneid++) {
+		int status;
+
+		zone = &pgdat->node_zones[zoneid];
+		if (!populated_zone(zone))
+			continue;
+
+		if (compaction_deferred(zone, cc.order))
+			continue;
+
+		if (compaction_suitable(zone, cc.order, 0, zoneid) !=
+							COMPACT_CONTINUE)
+			continue;
+
+		cc.nr_freepages = 0;
+		cc.nr_migratepages = 0;
+		cc.zone = zone;
+		INIT_LIST_HEAD(&cc.freepages);
+		INIT_LIST_HEAD(&cc.migratepages);
+
+		status = compact_zone(zone, &cc);
+
+		if (zone_watermark_ok(zone, cc.order, low_wmark_pages(zone),
+						cc.classzone_idx, 0)) {
+			success = true;
+			compaction_defer_reset(zone, cc.order, false);
+		} else if (status == COMPACT_COMPLETE) {
+			/*
+			 * We use sync migration mode here, so we defer like
+			 * sync direct compaction does.
+			 */
+			defer_compaction(zone, cc.order);
+		}
+
+		VM_BUG_ON(!list_empty(&cc.freepages));
+		VM_BUG_ON(!list_empty(&cc.migratepages));
+	}
+
+	/*
+	 * Regardless of success, we are done until woken up next. But remember
+	 * the requested order/classzone_idx in case it was higher/tighter than
+	 * our current ones
+	 */
+	if (pgdat->kcompactd_max_order <= cc.order)
+		pgdat->kcompactd_max_order = 0;
+	if (pgdat->kcompactd_classzone_idx >= cc.classzone_idx)
+		pgdat->kcompactd_classzone_idx = pgdat->nr_zones - 1;
+}
+
+void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx)
+{
+	if (!order)
+		return;
+
+	if (pgdat->kcompactd_max_order < order)
+		pgdat->kcompactd_max_order = order;
+
+	if (pgdat->kcompactd_classzone_idx > classzone_idx)
+		pgdat->kcompactd_classzone_idx = classzone_idx;
+
+	if (!waitqueue_active(&pgdat->kcompactd_wait))
+		return;
+
+	if (!kcompactd_node_suitable(pgdat))
+		return;
+
+	trace_mm_compaction_wakeup_kcompactd(pgdat->node_id, order,
+							classzone_idx);
+	wake_up_interruptible(&pgdat->kcompactd_wait);
+}
+
+/*
+ * The background compaction daemon, started as a kernel thread
+ * from the init process.
+ */
+static int kcompactd(void *p)
+{
+	pg_data_t *pgdat = (pg_data_t*)p;
+	struct task_struct *tsk = current;
+
+	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
+
+	if (!cpumask_empty(cpumask))
+		set_cpus_allowed_ptr(tsk, cpumask);
+
+	set_freezable();
+
+	pgdat->kcompactd_max_order = 0;
+	pgdat->kcompactd_classzone_idx = pgdat->nr_zones - 1;
+
+	while (!kthread_should_stop()) {
+		trace_mm_compaction_kcompactd_sleep(pgdat->node_id);
+		wait_event_freezable(pgdat->kcompactd_wait,
+				kcompactd_work_requested(pgdat));
+
+		kcompactd_do_work(pgdat);
+	}
+
+	return 0;
+}
+
+/*
+ * This kcompactd start function will be called by init and node-hot-add.
+ * On node-hot-add, kcompactd will moved to proper cpus if cpus are hot-added.
+ */
+int kcompactd_run(int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+	int ret = 0;
+
+	if (pgdat->kcompactd)
+		return 0;
+
+	pgdat->kcompactd = kthread_run(kcompactd, pgdat, "kcompactd%d", nid);
+	if (IS_ERR(pgdat->kcompactd)) {
+		pr_err("Failed to start kcompactd on node %d\n", nid);
+		ret = PTR_ERR(pgdat->kcompactd);
+		pgdat->kcompactd = NULL;
+	}
+	return ret;
+}
+
+/*
+ * Called by memory hotplug when all memory in a node is offlined. Caller must
+ * hold mem_hotplug_begin/end().
+ */
+void kcompactd_stop(int nid)
+{
+	struct task_struct *kcompactd = NODE_DATA(nid)->kcompactd;
+
+	if (kcompactd) {
+		kthread_stop(kcompactd);
+		NODE_DATA(nid)->kcompactd = NULL;
+	}
+}
+
+/*
+ * It's optimal to keep kcompactd on the same CPUs as their memory, but
+ * not required for correctness. So if the last cpu in a node goes
+ * away, we get changed to run anywhere: as the first one comes back,
+ * restore their cpu bindings.
+ */
+static int cpu_callback(struct notifier_block *nfb, unsigned long action,
+			void *hcpu)
+{
+	int nid;
+
+	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN) {
+		for_each_node_state(nid, N_MEMORY) {
+			pg_data_t *pgdat = NODE_DATA(nid);
+			const struct cpumask *mask;
+
+			mask = cpumask_of_node(pgdat->node_id);
+
+			if (cpumask_any_and(cpu_online_mask, mask) < nr_cpu_ids)
+				/* One of our CPUs online: restore mask */
+				set_cpus_allowed_ptr(pgdat->kcompactd, mask);
+		}
+	}
+	return NOTIFY_OK;
+}
+
+static int __init kcompactd_init(void)
+{
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY)
+		kcompactd_run(nid);
+	hotcpu_notifier(cpu_callback, 0);
+	return 0;
+}
+subsys_initcall(kcompactd_init)
+
 #endif /* CONFIG_COMPACTION */
diff -puN mm/memory_hotplug.c~mm-compaction-introduce-kcompactd mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-compaction-introduce-kcompactd
+++ a/mm/memory_hotplug.c
@@ -33,6 +33,7 @@
 #include <linux/hugetlb.h>
 #include <linux/memblock.h>
 #include <linux/bootmem.h>
+#include <linux/compaction.h>
 
 #include <asm/tlbflush.h>
 
@@ -1105,8 +1106,10 @@ int __ref online_pages(unsigned long pfn
 
 	init_per_zone_wmark_min();
 
-	if (onlined_pages)
+	if (onlined_pages) {
 		kswapd_run(zone_to_nid(zone));
+		kcompactd_run(nid);
+	}
 
 	vm_total_pages = nr_free_pagecache_pages();
 
@@ -1880,8 +1883,10 @@ repeat:
 		zone_pcp_update(zone);
 
 	node_states_clear_node(node, &arg);
-	if (arg.status_change_nid >= 0)
+	if (arg.status_change_nid >= 0) {
 		kswapd_stop(node);
+		kcompactd_stop(node);
+	}
 
 	vm_total_pages = nr_free_pagecache_pages();
 	writeback_set_ratelimit();
diff -puN mm/page_alloc.c~mm-compaction-introduce-kcompactd mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-introduce-kcompactd
+++ a/mm/page_alloc.c
@@ -5405,6 +5405,9 @@ static void __paginginit free_area_init_
 #endif
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
+#ifdef CONFIG_COMPACTION
+	init_waitqueue_head(&pgdat->kcompactd_wait);
+#endif
 	pgdat_page_ext_init(pgdat);
 
 	for (j = 0; j < MAX_NR_ZONES; j++) {
diff -puN mm/vmstat.c~mm-compaction-introduce-kcompactd mm/vmstat.c
--- a/mm/vmstat.c~mm-compaction-introduce-kcompactd
+++ a/mm/vmstat.c
@@ -826,6 +826,7 @@ const char * const vmstat_text[] = {
 	"compact_stall",
 	"compact_fail",
 	"compact_success",
+	"compact_daemon_wake",
 #endif
 
 #ifdef CONFIG_HUGETLB_PAGE
_

Patches currently in -mm which might be from vbabka@suse.cz are


