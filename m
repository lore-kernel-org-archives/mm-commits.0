From: akpm@linux-foundation.org
Subject: + mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
 added to -mm tree
Date: Wed, 17 Jun 2020 16:34:59 -0700
Message-ID: <20200617233459.5tMJ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgFQXfA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 19:35:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tobin@kernel.org, tj@kernel.org, shakeelb@google.com, rientjes@google.com, penberg@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net, longman@redhat.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, dennis@kernel.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: mm: memcg/percpu: per-memcg percpu memory statistics
has been added to the -mm tree.  Its filename is
     mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch

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
Subject: mm: memcg/percpu: per-memcg percpu memory statistics

Percpu memory can represent a noticeable chunk of the total memory
consumption, especially on big machines with many CPUs.  Let's track
percpu memory usage for each memcg and display it in memory.stat.

A percpu allocation is usually scattered over multiple pages (and nodes),
and can be significantly smaller than a page.  So let's add a byte-sized
counter on the memcg level: MEMCG_PERCPU_B.  Byte-sized vmstat infra
created for slabs can be perfectly reused for percpu case.

Link: http://lkml.kernel.org/r/20200608230819.832349-4-guro@fb.com
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

 Documentation/admin-guide/cgroup-v2.rst |    4 ++++
 include/linux/memcontrol.h              |    8 ++++++++
 mm/memcontrol.c                         |    4 +++-
 mm/percpu.c                             |   10 ++++++++++
 4 files changed, 25 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcg-percpu-per-memcg-percpu-memory-statistics
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1274,6 +1274,10 @@ PAGE_SIZE multiple when read back.
 		Amount of memory used for storing in-kernel data
 		structures.
 
+	  percpu
+		Amount of memory used for storing per-cpu kernel
+		data structures.
+
 	  sock
 		Amount of memory used in network transmission buffers
 
--- a/include/linux/memcontrol.h~mm-memcg-percpu-per-memcg-percpu-memory-statistics
+++ a/include/linux/memcontrol.h
@@ -32,11 +32,19 @@ struct kmem_cache;
 enum memcg_stat_item {
 	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_SOCK,
+	MEMCG_PERCPU_B,
 	/* XXX: why are these zone and not node counters? */
 	MEMCG_KERNEL_STACK_KB,
 	MEMCG_NR_STAT,
 };
 
+static __always_inline bool memcg_stat_item_in_bytes(enum memcg_stat_item item)
+{
+	if (item == MEMCG_PERCPU_B)
+		return true;
+	return vmstat_item_in_bytes(item);
+}
+
 enum memcg_memory_event {
 	MEMCG_LOW,
 	MEMCG_HIGH,
--- a/mm/memcontrol.c~mm-memcg-percpu-per-memcg-percpu-memory-statistics
+++ a/mm/memcontrol.c
@@ -783,7 +783,7 @@ void __mod_memcg_state(struct mem_cgroup
 	if (mem_cgroup_disabled())
 		return;
 
-	if (vmstat_item_in_bytes(idx))
+	if (memcg_stat_item_in_bytes(idx))
 		threshold <<= PAGE_SHIFT;
 
 	x = val + __this_cpu_read(memcg->vmstats_percpu->stat[idx]);
@@ -1490,6 +1490,8 @@ static char *memory_stat_format(struct m
 	seq_buf_printf(&s, "slab %llu\n",
 		       (u64)(memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
 			     memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B)));
+	seq_buf_printf(&s, "percpu %llu\n",
+		       (u64)memcg_page_state(memcg, MEMCG_PERCPU_B));
 	seq_buf_printf(&s, "sock %llu\n",
 		       (u64)memcg_page_state(memcg, MEMCG_SOCK) *
 		       PAGE_SIZE);
--- a/mm/percpu.c~mm-memcg-percpu-per-memcg-percpu-memory-statistics
+++ a/mm/percpu.c
@@ -1608,6 +1608,11 @@ static void pcpu_memcg_post_alloc_hook(s
 
 	if (chunk) {
 		chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT] = objcg;
+
+		rcu_read_lock();
+		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
+				size * num_possible_cpus());
+		rcu_read_unlock();
 	} else {
 		obj_cgroup_uncharge(objcg, size * num_possible_cpus());
 		obj_cgroup_put(objcg);
@@ -1626,6 +1631,11 @@ static void pcpu_memcg_free_hook(struct
 
 	obj_cgroup_uncharge(objcg, size * num_possible_cpus());
 
+	rcu_read_lock();
+	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
+			-(size * num_possible_cpus()));
+	rcu_read_unlock();
+
 	obj_cgroup_put(objcg);
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
