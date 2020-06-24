From: akpm@linux-foundation.org
Subject: + mm-memcg-prepare-for-byte-sized-vmstat-items.patch added
 to -mm tree
Date: Wed, 24 Jun 2020 14:46:52 -0700
Message-ID: <20200624214652.BcDl9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731881AbgFXVqy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 17:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tj@kernel.org, shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: mm: memcg: prepare for byte-sized vmstat items
has been added to the -mm tree.  Its filename is
     mm-memcg-prepare-for-byte-sized-vmstat-items.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-prepare-for-byte-sized-vmstat-items.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-prepare-for-byte-sized-vmstat-items.patch

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
Subject: mm: memcg: prepare for byte-sized vmstat items

To implement per-object slab memory accounting, we need to convert slab
vmstat counters to bytes.  Actually, out of 4 levels of counters: global,
per-node, per-memcg and per-lruvec only two last levels will require
byte-sized counters.  It's because global and per-node counters will be
counting the number of slab pages, and per-memcg and per-lruvec will be
counting the amount of memory taken by charged slab objects.

Converting all vmstat counters to bytes or even all slab counters to bytes
would introduce an additional overhead.  So instead let's store global and
per-node counters in pages, and memcg and lruvec counters in bytes.

To make the API clean all access helpers (both on the read and write
sides) are dealing with bytes.

To avoid back-and-forth conversions a new flavor of read-side helpers is
introduced, which always returns values in pages: node_page_state_pages()
and global_node_page_state_pages().

Actually new helpers are just reading raw values.  Old helpers are simple
wrappers, which will complain on an attempt to read byte value, because at
the moment no one actually needs bytes.

Thanks to Johannes Weiner for the idea of having the byte-sized API on top
of the page-sized internal storage.

Link: http://lkml.kernel.org/r/20200623174037.3951353-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    2 +-
 include/linux/mmzone.h |   10 ++++++++++
 include/linux/vmstat.h |   14 +++++++++++++-
 mm/memcontrol.c        |   14 ++++++++++----
 mm/vmstat.c            |   30 ++++++++++++++++++++++++++----
 5 files changed, 60 insertions(+), 10 deletions(-)

--- a/drivers/base/node.c~mm-memcg-prepare-for-byte-sized-vmstat-items
+++ a/drivers/base/node.c
@@ -513,7 +513,7 @@ static ssize_t node_read_vmstat(struct d
 
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 		n += sprintf(buf+n, "%s %lu\n", node_stat_name(i),
-			     node_page_state(pgdat, i));
+			     node_page_state_pages(pgdat, i));
 
 	return n;
 }
--- a/include/linux/mmzone.h~mm-memcg-prepare-for-byte-sized-vmstat-items
+++ a/include/linux/mmzone.h
@@ -207,6 +207,16 @@ enum node_stat_item {
 };
 
 /*
+ * Returns true if the value is measured in bytes (most vmstat values are
+ * measured in pages). This defines the API part, the internal representation
+ * might be different.
+ */
+static __always_inline bool vmstat_item_in_bytes(int idx)
+{
+	return false;
+}
+
+/*
  * We do arithmetic on the LRU lists in various places in the code,
  * so it is important to keep the active lists LRU_ACTIVE higher in
  * the array than the corresponding inactive lists, and to keep
--- a/include/linux/vmstat.h~mm-memcg-prepare-for-byte-sized-vmstat-items
+++ a/include/linux/vmstat.h
@@ -8,6 +8,7 @@
 #include <linux/vm_event_item.h>
 #include <linux/atomic.h>
 #include <linux/static_key.h>
+#include <linux/mmdebug.h>
 
 extern int sysctl_stat_interval;
 
@@ -192,7 +193,8 @@ static inline unsigned long global_zone_
 	return x;
 }
 
-static inline unsigned long global_node_page_state(enum node_stat_item item)
+static inline
+unsigned long global_node_page_state_pages(enum node_stat_item item)
 {
 	long x = atomic_long_read(&vm_node_stat[item]);
 #ifdef CONFIG_SMP
@@ -202,6 +204,13 @@ static inline unsigned long global_node_
 	return x;
 }
 
+static inline unsigned long global_node_page_state(enum node_stat_item item)
+{
+	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
+
+	return global_node_page_state_pages(item);
+}
+
 static inline unsigned long zone_page_state(struct zone *zone,
 					enum zone_stat_item item)
 {
@@ -242,9 +251,12 @@ extern unsigned long sum_zone_node_page_
 extern unsigned long sum_zone_numa_state(int node, enum numa_stat_item item);
 extern unsigned long node_page_state(struct pglist_data *pgdat,
 						enum node_stat_item item);
+extern unsigned long node_page_state_pages(struct pglist_data *pgdat,
+					   enum node_stat_item item);
 #else
 #define sum_zone_node_page_state(node, item) global_zone_page_state(item)
 #define node_page_state(node, item) global_node_page_state(item)
+#define node_page_state_pages(node, item) global_node_page_state_pages(item)
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_SMP
--- a/mm/memcontrol.c~mm-memcg-prepare-for-byte-sized-vmstat-items
+++ a/mm/memcontrol.c
@@ -681,13 +681,16 @@ mem_cgroup_largest_soft_limit_node(struc
  */
 void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val)
 {
-	long x;
+	long x, threshold = MEMCG_CHARGE_BATCH;
 
 	if (mem_cgroup_disabled())
 		return;
 
+	if (vmstat_item_in_bytes(idx))
+		threshold <<= PAGE_SHIFT;
+
 	x = val + __this_cpu_read(memcg->vmstats_percpu->stat[idx]);
-	if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
+	if (unlikely(abs(x) > threshold)) {
 		struct mem_cgroup *mi;
 
 		/*
@@ -718,7 +721,7 @@ void __mod_memcg_lruvec_state(struct lru
 {
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup *memcg;
-	long x;
+	long x, threshold = MEMCG_CHARGE_BATCH;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	memcg = pn->memcg;
@@ -729,8 +732,11 @@ void __mod_memcg_lruvec_state(struct lru
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stat_local->count[idx], val);
 
+	if (vmstat_item_in_bytes(idx))
+		threshold <<= PAGE_SHIFT;
+
 	x = val + __this_cpu_read(pn->lruvec_stat_cpu->count[idx]);
-	if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
+	if (unlikely(abs(x) > threshold)) {
 		pg_data_t *pgdat = lruvec_pgdat(lruvec);
 		struct mem_cgroup_per_node *pi;
 
--- a/mm/vmstat.c~mm-memcg-prepare-for-byte-sized-vmstat-items
+++ a/mm/vmstat.c
@@ -341,6 +341,11 @@ void __mod_node_page_state(struct pglist
 	long x;
 	long t;
 
+	if (vmstat_item_in_bytes(item)) {
+		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
+		delta >>= PAGE_SHIFT;
+	}
+
 	x = delta + __this_cpu_read(*p);
 
 	t = __this_cpu_read(pcp->stat_threshold);
@@ -398,6 +403,8 @@ void __inc_node_state(struct pglist_data
 	s8 __percpu *p = pcp->vm_node_stat_diff + item;
 	s8 v, t;
 
+	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
+
 	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v > t)) {
@@ -442,6 +449,8 @@ void __dec_node_state(struct pglist_data
 	s8 __percpu *p = pcp->vm_node_stat_diff + item;
 	s8 v, t;
 
+	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
+
 	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v < - t)) {
@@ -541,6 +550,11 @@ static inline void mod_node_state(struct
 	s8 __percpu *p = pcp->vm_node_stat_diff + item;
 	long o, n, t, z;
 
+	if (vmstat_item_in_bytes(item)) {
+		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
+		delta >>= PAGE_SHIFT;
+	}
+
 	do {
 		z = 0;  /* overflow to node counters */
 
@@ -989,8 +1003,8 @@ unsigned long sum_zone_numa_state(int no
 /*
  * Determine the per node value of a stat item.
  */
-unsigned long node_page_state(struct pglist_data *pgdat,
-				enum node_stat_item item)
+unsigned long node_page_state_pages(struct pglist_data *pgdat,
+				    enum node_stat_item item)
 {
 	long x = atomic_long_read(&pgdat->vm_stat[item]);
 #ifdef CONFIG_SMP
@@ -999,6 +1013,14 @@ unsigned long node_page_state(struct pgl
 #endif
 	return x;
 }
+
+unsigned long node_page_state(struct pglist_data *pgdat,
+			      enum node_stat_item item)
+{
+	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
+
+	return node_page_state_pages(pgdat, item);
+}
 #endif
 
 #ifdef CONFIG_COMPACTION
@@ -1577,7 +1599,7 @@ static void zoneinfo_show_print(struct s
 		seq_printf(m, "\n  per-node stats");
 		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
 			seq_printf(m, "\n      %-12s %lu", node_stat_name(i),
-				   node_page_state(pgdat, i));
+				   node_page_state_pages(pgdat, i));
 		}
 	}
 	seq_printf(m,
@@ -1698,7 +1720,7 @@ static void *vmstat_start(struct seq_fil
 #endif
 
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
-		v[i] = global_node_page_state(i);
+		v[i] = global_node_page_state_pages(i);
 	v += NR_VM_NODE_STAT_ITEMS;
 
 	global_dirty_limits(v + NR_DIRTY_BG_THRESHOLD,
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
