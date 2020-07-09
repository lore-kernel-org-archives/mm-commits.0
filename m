From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.patch added to
 -mm tree
Date: Thu, 09 Jul 2020 16:10:49 -0700
Message-ID: <20200709231049.FmodEQwCT%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgGIXKv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 19:10:51 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, domas@fb.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org


The patch titled
     Subject: mm: memcontrol: avoid workload stalls when lowering memory.high
has been added to the -mm tree.  Its filename is
     mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.patch

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
Subject: mm: memcontrol: avoid workload stalls when lowering memory.high

Memory.high limit is implemented in a way such that the kernel penalizes
all threads which are allocating a memory over the limit.  Forcing all
threads into the synchronous reclaim and adding some artificial delays
allows to slow down the memory consumption and potentially give some time
for userspace oom handlers/resource control agents to react.

It works nicely if the memory usage is hitting the limit from below,
however it works sub-optimal if a user adjusts memory.high to a value way
below the current memory usage.  It basically forces all workload threads
(doing any memory allocations) into the synchronous reclaim and sleep. 
This makes the workload completely unresponsive for a long period of time
and can also lead to a system-wide contention on lru locks.  It can happen
even if the workload is not actually tight on memory and has, for example,
a ton of cold pagecache.

In the current implementation writing to memory.high causes an atomic
update of page counter's high value followed by an attempt to reclaim
enough memory to fit into the new limit.  To fix the problem described
above, all we need is to change the order of execution: try to push the
memory usage under the limit first, and only then set the new high limit.

Link: http://lkml.kernel.org/r/20200709194718.189231-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Domas Mituzas <domas@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh
+++ a/mm/memcontrol.c
@@ -6203,8 +6203,6 @@ static ssize_t memory_high_write(struct
 	if (err)
 		return err;
 
-	page_counter_set_high(&memcg->memory, high);
-
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
@@ -6228,6 +6226,8 @@ static ssize_t memory_high_write(struct
 			break;
 	}
 
+	page_counter_set_high(&memcg->memory, high);
+
 	return nbytes;
 }
 
_

Patches currently in -mm which might be from guro@fb.com are

mm-kmem-make-memcg_kmem_enabled-irreversible.patch
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
mm-memcg-slab-remove-unused-argument-by-charge_slab_page.patch
mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page.patch
mm-kmem-switch-to-static_branch_likely-in-memcg_kmem_enabled.patch
mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.patch
