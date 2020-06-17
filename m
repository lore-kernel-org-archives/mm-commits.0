From: akpm@linux-foundation.org
Subject: +
 =?us-ascii?Q?mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-?=
 =?us-ascii?Q?=5F=5Fmod=5Flruvec=5Fstate.patch?= added to -mm tree
Date: Wed, 17 Jun 2020 16:33:01 -0700
Message-ID: <20200617233301.sD9ee%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgFQXdE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 19:33:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tobin@kernel.org, tj@kernel.org, shakeelb@google.com, rientjes@google.com, penberg@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net, longman@redhat.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, dennis@kernel.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: mm: memcg: factor out memcg- and lruvec-level changes out of __mod_lruvec_state()
has been added to the -mm tree.  Its filename is
     mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state.patch

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
Subject: mm: memcg: factor out memcg- and lruvec-level changes out of __mod_lruvec_state()

Patch series "The new cgroup slab memory controller", v6.

The patchset moves the accounting from the page level to the object level.
It allows to share slab pages between memory cgroups.  This leads to a
significant win in the slab utilization (up to 45%) and the corresponding
drop in the total kernel memory footprint.  The reduced number of
unmovable slab pages should also have a positive effect on the memory
fragmentation.

The patchset makes the slab accounting code simpler: there is no more need
in the complicated dynamic creation and destruction of per-cgroup slab
caches, all memory cgroups use a global set of shared slab caches.  The
lifetime of slab caches is not more connected to the lifetime of memory
cgroups.

The more precise accounting does require more CPU, however in practice the
difference seems to be negligible.  We've been using the new slab
controller in Facebook production for several months with different
workloads and haven't seen any noticeable regressions.  What we've seen
were memory savings in order of 1 GB per host (it varied heavily depending
on the actual workload, size of RAM, number of CPUs, memory pressure,
etc).

The third version of the patchset added yet another step towards the
simplification of the code: sharing of slab caches between accounted and
non-accounted allocations.  It comes with significant upsides (most
noticeable, a complete elimination of dynamic slab caches creation) but
not without some regression risks, so this change sits on top of the
patchset and is not completely merged in.  So in the unlikely event of a
noticeable performance regression it can be reverted separately.


This patch (of 19):

To convert memcg and lruvec slab counters to bytes there must be a way to
change these counters without touching node counters.  Factor out
__mod_memcg_lruvec_state() out of __mod_lruvec_state().

Link: http://lkml.kernel.org/r/20200608230654.828134-1-guro@fb.com
Link: http://lkml.kernel.org/r/20200608230654.828134-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   17 +++++++++++++
 mm/memcontrol.c            |   43 +++++++++++++++++++----------------
 2 files changed, 41 insertions(+), 19 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state
+++ a/include/linux/memcontrol.h
@@ -679,11 +679,23 @@ static inline unsigned long lruvec_page_
 	return x;
 }
 
+void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+			      int val);
 void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
 void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val);
 void mod_memcg_obj_state(void *p, int idx, int val);
 
+static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
+					  enum node_stat_item idx, int val)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__mod_memcg_lruvec_state(lruvec, idx, val);
+	local_irq_restore(flags);
+}
+
 static inline void mod_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx, int val)
 {
@@ -1057,6 +1069,11 @@ static inline unsigned long lruvec_page_
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
+static inline void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+					    enum node_stat_item idx, int val)
+{
+}
+
 static inline void __mod_lruvec_state(struct lruvec *lruvec,
 				      enum node_stat_item idx, int val)
 {
--- a/mm/memcontrol.c~mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state
+++ a/mm/memcontrol.c
@@ -713,30 +713,13 @@ parent_nodeinfo(struct mem_cgroup_per_no
 	return mem_cgroup_nodeinfo(parent, nid);
 }
 
-/**
- * __mod_lruvec_state - update lruvec memory statistics
- * @lruvec: the lruvec
- * @idx: the stat item
- * @val: delta to add to the counter, can be negative
- *
- * The lruvec is the intersection of the NUMA node and a cgroup. This
- * function updates the all three counters that are affected by a
- * change of state at this level: per-node, per-cgroup, per-lruvec.
- */
-void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
-			int val)
+void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+			      int val)
 {
-	pg_data_t *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup *memcg;
 	long x;
 
-	/* Update node */
-	__mod_node_page_state(pgdat, idx, val);
-
-	if (mem_cgroup_disabled())
-		return;
-
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	memcg = pn->memcg;
 
@@ -748,6 +731,7 @@ void __mod_lruvec_state(struct lruvec *l
 
 	x = val + __this_cpu_read(pn->lruvec_stat_cpu->count[idx]);
 	if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
+		pg_data_t *pgdat = lruvec_pgdat(lruvec);
 		struct mem_cgroup_per_node *pi;
 
 		for (pi = pn; pi; pi = parent_nodeinfo(pi, pgdat->node_id))
@@ -757,6 +741,27 @@ void __mod_lruvec_state(struct lruvec *l
 	__this_cpu_write(pn->lruvec_stat_cpu->count[idx], x);
 }
 
+/**
+ * __mod_lruvec_state - update lruvec memory statistics
+ * @lruvec: the lruvec
+ * @idx: the stat item
+ * @val: delta to add to the counter, can be negative
+ *
+ * The lruvec is the intersection of the NUMA node and a cgroup. This
+ * function updates the all three counters that are affected by a
+ * change of state at this level: per-node, per-cgroup, per-lruvec.
+ */
+void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+			int val)
+{
+	/* Update node */
+	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+
+	/* Update memcg and lruvec */
+	if (!mem_cgroup_disabled())
+		__mod_memcg_lruvec_state(lruvec, idx, val);
+}
+
 void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val)
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
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
