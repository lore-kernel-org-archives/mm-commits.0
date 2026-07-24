Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD0C1A9FBC
	for <mm-commits@vger.kernel.org>; Fri, 24 Jul 2026 00:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784852572; cv=none; b=FmDilEEDH1GZYy5vkcosQCZcKwBr0F2Ve/rZQBP8zk5h1vRvZcfL6r7QyzqfM1us4o+8YhCjKZm7ytb7bBoUrGm0D6EeGv5pISLmMxH1fw3BKzpeVo20NfdBtFD0SjcXuALPsuwI+KVkuS11bs9MS+ooNfyKmlG8/nyyaTmouvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784852572; c=relaxed/simple;
	bh=mYvsBbew+2hoIPNZTqws2h2cS+DFCLntpBGmEvDmg8U=;
	h=Date:To:From:Subject:Message-Id; b=Durw6J9BNisdvStuwk3VoqrvsfSL+O+xNu4CUD3M5dYd+I6jZVPFRbMgoEMS+AknNpZWwGD7jMJgXdDPS373bL17KHpwyb+2Ph2QsITymt85Aj3tR5zKajlzt9CNxi0cUk3EH2eM3gfTW364zMJaFkAO/pWe17hjECbaoF6b+I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ljt7tXnF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ljt7tXnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9FE1F000E9;
	Fri, 24 Jul 2026 00:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784852570;
	bh=hufjqy+bArLduaSjrBPIQDBt0K1TY+CCz/chKBeQLZk=;
	h=Date:To:From:Subject;
	b=Ljt7tXnF2/KtQPe9ypue5RQUVM9+hZBDzDkh/s2kLac1N72qwDIzdKzuM/x/injaX
	 0qjhmAS64dNJ3w4wcZLivpGQFmwXSv97FfRaH/XDoZeWRHJS1x2fiMlPdcPhXbI+0M
	 14EXzl1CHhLvVgWAkPjL8QZFFsffhRcuBWV9oeGI=
Date: Thu, 23 Jul 2026 17:22:49 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,axelrasmussen@google.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch added to mm-new branch
Message-Id: <20260724002250.1C9FE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmstat, mm/memcontrol: add _monotonic vmstat readers
has been added to the -mm mm-new branch.  Its filename is
     mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/vmstat, mm/memcontrol: add _monotonic vmstat readers
Date: Mon, 20 Jul 2026 09:41:22 -0700

Patch series "mm/vmscan: reduce lru_lock contention via vmstat-derived
scan-balance cost", v4.

The anon/file scan balance heuristic in get_scan_count() is fed by two
scalars in struct lruvec (anon_cost, file_cost) that every reclaim
producer updates under lruvec->lru_lock.  The cost-recording work itself
is trivial, but it both contends for and contributes to contention on
lru_lock - which is often a contention point on memory-pressured
workloads.  Specifically:

- shrink_inactive_list() re-acquires lru_lock at function exit just
  to call lru_note_cost_unlock_irq().
- shrink_active_list() does the same after rotation accounting.
- workingset_refault() takes folio_lruvec_lock_irq() purely to
  record the refault cost.
- prepare_scan_control() snapshots anon_cost/file_cost under
  lru_lock.
- lru_note_cost_unlock_irq() itself walks parent_lruvec() and
  re-acquires lru_lock on every ancestor, multiplying the cost
  of every update by memcg-hierarchy depth.

This series removes those producer-side acquisitions entirely.  The
rotation inputs become per-LRU PGROTATE_{ANON,FILE} vmstat counters. 
NR_VMSCAN_WRITE already captures reclaim-driven pageout at writeout();
charge it through lruvec_stat_mod_folio() so it is available per lruvec
and aggregated through the memcg hierarchy.  Reclaim does not submit
filesystem folios for writeback from this path, so pageout contributes
only to anon cost.  WORKINGSET_RESTORE_* already captures the refault
input.

prepare_scan_control() reads the raw cost signals without lru_lock:

  anon = PGROTATE_ANON +
         (NR_VMSCAN_WRITE + WORKINGSET_RESTORE_ANON) * SWAP_CLUSTER_MAX
  file = PGROTATE_FILE +
         WORKINGSET_RESTORE_FILE * SWAP_CLUSTER_MAX

It folds the deltas into a per-lruvec accumulator.  A dedicated per-lruvec
cost_lock, not touched by isolate_lru_folios(), move_folios_to_lru(), or
folio_add_lru(), serialises the accumulator RMW and the lrusize/4 halving
check.  Hierarchy aggregation is implicit in rstat propagation, so the
parent_lruvec() walk and the lru_reparent_memcg() cost-splice both
disappear.

Moving accumulation and decay to the reclaim side also improves the cost
model across reclaim gaps.  With producer-side decay, events that happen
while reclaim is idle still age each other before reclaim ever samples the
costs.  If a workload refaults a large anon set and then a smaller file
set before reclaim runs again, the later file activity can age the earlier
anon activity out of the cost model.  The new scheme observes the whole
between-reclaim delta and decays anon and file proportionally, so the
scan-balance history better represents what happened since the last
reclaim pass.

Trade-offs:
  - Cost reads see rstat-aggregated values that can lag until periodic /
    reader-triggered flushing.
  - Per-lruvec footprint grows by 4 unsigned longs + a spinlock (a
    struct lru_cost { count, last_rotated, last_io } per side), which
    is a small cost.
  - NR_VMSCAN_WRITE now also updates the folio's lruvec/memcg stat,
    adding memcg stat accounting to the reclaim writeout path while
    preserving the existing node-level total.

== Numbers ==

Tested on a 176-core, 256 GB host.  The benchmark drives sustained
swap-out/refault inside a tight memcg using vm-scalability/usemem:

  usemem -n 16 --prealloc --prefault --random $((256*1024*1024))

run inside a two-level memcg with memory.max=512M on the leaf (4 GB anon
working set has to fit in 512 MB -> continuous shrink_inactive_list +
workingset_refault).  A 16 GB swap file is used.  Measurement is a 30 s
`perf lock record -a` window over otherwise-idle hardware.

Workload rates are identical on both kernels (the bench drives the same
memory pressure):

                          baseline    patched      delta
  pgscan_direct  / s      172,662     171,817      ~0%
  pgsteal_direct / s       67,162      66,306      ~0%
  workingset_refault_anon / s
                           40,696      39,830      ~0%

perf lock contention (total wait per 30 s window):

  Lock Name                Before      After     % change
  shrink_lruvec+0x770     722.84 ms    0         -100% (eliminated)
        (= lru_note_cost_unlock_irq)
  workingset_refault+0x167 385.26 ms   0         -100% (eliminated)
        (= lru_note_cost_refault)
  shrink_node+0x4ad       689.43 ms    26.95 ms  -96%
  shrink_active_list      208.34 ms    15.97 ms  -92%
  lru_add_drain_cpu+0x34    1.96 s    917.71 ms  -53%

  Total LRU lock wait      ~4.23 s     ~1.66 s   -61%

The two specific contention sites the patch removes (shrink_lruvec+0x770 =
lru_note_cost_unlock_irq; workingset_refault+0x167 =
lru_note_cost_refault) are completely absent from the patched
perf-lock-contention output.  Secondary reductions in shrink_node,
shrink_active_list, lru_add_drain_cpu and pgrefill/pgactivate look like
knock-on effects from removing the cost-recording overhead and the
parent_lruvec walk.

The remaining ~1.66 s of LRU lock wait on the patched kernel is dominated
by the per-CPU pagevec drain (lru_add_drain_cpu) and the main reclaim path
in shrink_lruvec.

The numbers above can be reproduced using the script in [1].

== Series structure ==

  1. mm/vmstat, mm/memcontrol: add _monotonic vmstat readers
     Non-clamping siblings of lruvec_page_state() / node_page_state() /
     global_node_page_state() for callers that snapshot a
     monotonically-incremented counter and subtract two samples.
     Unsigned modular subtraction on the raw wrapping value stays
     correct across a signed-long overflow that the existing clamp
     would otherwise turn into a huge spurious delta (a real hazard
     on 32-bit).

  2. mm/vmscan: reduce lru_lock contention via vmstat-derived
     scan-balance cost
     The optimization described above; samples PGROTATE_*,
     NR_VMSCAN_WRITE (for anon) and WORKINGSET_RESTORE_* via
     lruvec_page_state_monotonic() from patch 1. MGLRU also updates
     PGROTATE_* so the counters remain meaningful with either reclaim
     implementation, although MGLRU does not consume this cost signal.

== Alternatives considered ==

1. cost_lock for both producer and consumer (no vmstat indirection):
   Keep the producer loop, just swap lru_lock for a new per-lruvec
   cost_lock. Decouples cost from LRU manipulation, but producers
   still synchronously contend on cost_lock, the parent_lruvec()
   walk is still required (O(memcg-depth) acquisitions per recording,
   now on cost_lock), and lru_reparent_memcg() still needs explicit
   cost-splice. We can do much better and this series removes the
   producer lock entirely and gets hierarchy propagation for "free"
   via rstat.

2. Attempt to switch to using MGLRU's scan model:
   MGLRU has no anon_cost/file_cost at all. It replaces the cost
   heuristic with generation-based aging: per-LRU sequence numbers
   (min_seq/max_seq) age folios into generations, and the
   older-generation type is the one to scan. So
   lru_note_cost_unlock_irq() / lru_note_cost_refault() are simply
   not called when lru_gen_enabled() — by design it sidesteps every
   concern this patch addresses.
   But MGLRU is not a substitute for fixing classic LRU:
     - It relies on a lot of things including per-lruvec generation
       lists, bloom filters, mm_struct walk infrastructure, working-set
       protection tiers and a whole sysfs interface. Replacing
       classic LRU's cost recording with the MGLRU model would
       mean dragging in all of that.
     - It changes scan-balance semantics, not just the locking, so
       it's a heuristic change we would need to evaluate separately.
       There are known regressions (database/anon-heavy workloads
       sensitive to swappiness, or file-cache-dominated workloads
       where MGLRU's bloom-filter protection differs from classic
       refault tracking).
   This series keeps classic LRU's scan-balance model and fixes where
   its cost history is sampled and aged.

3. Atomic cost counter:
   lrusize/4 halving has no clean atomic form, and the parent
   walk still has to run explicitly. Reusing vmstats gives per-CPU
   aggregation AND rstat hierarchy propagation for free.

4. Drop cost_lock from the existing patch and reuse lru_lock in the
   consumer (prepare_scan_control()):
   Saves 1 lock space per lruvec but re-couples the cost path to LRU
   manipulation, though just from the consumer side this time.
   prepare_scan_control() runs at the start of every shrink_lruvec()
   cycle, so under sustained memory pressure it would take lru_lock
   on the hot path and block isolate_lru_folios() /
   move_folios_to_lru() / folio_add_lru() i.e. when reclaim is
   in flight. A dedicated cost_lock is never taken by anyone except
   the consumer cost calculation.


This patch (of 2):

lruvec_page_state(), node_page_state(), and global_node_page_state() all
clamp negative reads to zero on CONFIG_SMP so that a transient per-CPU
delta skew presents as zero pages rather than as a garbage unsigned value.
This is the right behaviour for non-monotonic page-count readers.

It is however incorrect for callers that snapshot a monotonically-
incremented event counter and compute a delta from two samples.  Once the
underlying signed long wraps past LONG_MAX, the clamped read drops to zero
while the previously-recorded snapshot still holds the pre-wrap value; the
unsigned subtraction then underflows into a ~2^31 spurious delta for
32-bit architecture and corrupts the caller's accumulator.

Add non-clamping siblings that return the underlying state value cast to
unsigned long:

  global_node_page_state_monotonic()
  node_page_state_monotonic()
  lruvec_page_state_monotonic()

With both samples read via the _monotonic variant, unsigned modular
subtraction stays correct across a signed-long wraparound as long as the
true growth between two samples fits in unsigned long (< 2^32 on 32-bit, <
2^64 on 64-bit); the 32-bit bound is the practically-reachable one that
motivates this helper.

The variants are only safe for monotonically-incremented counters. 
Non-monotonic page-count readers must keep using the existing clamped
helpers so transient negative reads still present as zero.

This is a prerequisite for the following patch which replaces the
producer-side anon_cost/file_cost accumulators with a read-side
accumulator in prepare_scan_control() that samples monotonic per-LRU
vmstat counters (PGROTATE_*, PGRECLAIM_PAGEOUT_*, WORKINGSET_RESTORE_*)
via lruvec_page_state_monotonic() and folds the unsigned modular delta
into a per-lruvec cost_accum[].

Link: https://lore.kernel.org/20260720164207.450685-2-usama.arif@linux.dev
Link: https://gist.github.com/uarif1/a4eb33a86c5b2d7bbc55b42f0956e884 [1]
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 +++++++
 include/linux/vmstat.h     |   16 +++++++++++++++
 mm/memcontrol.c            |   36 +++++++++++++++++++++++++++++++++++
 mm/vmstat.c                |   11 ++++++++++
 4 files changed, 71 insertions(+)

--- a/include/linux/memcontrol.h~mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers
+++ a/include/linux/memcontrol.h
@@ -931,6 +931,8 @@ unsigned long memcg_page_state_output(st
 bool memcg_stat_item_valid(int idx);
 bool memcg_vm_event_item_valid(enum vm_event_item idx);
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
+unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+					  enum node_stat_item idx);
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
 
@@ -1378,6 +1380,12 @@ static inline unsigned long lruvec_page_
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
+static inline unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+							enum node_stat_item idx)
+{
+	return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
+}
+
 static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 						    enum node_stat_item idx)
 {
--- a/include/linux/vmstat.h~mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers
+++ a/include/linux/vmstat.h
@@ -194,6 +194,19 @@ unsigned long global_node_page_state_pag
 	return x;
 }
 
+/*
+ * Non-clamping variant of global_node_page_state() intended for callers that
+ * snapshot a monotonically-incremented counter and subtract two samples.
+ * Returns the raw wrapping value so that unsigned modular subtraction stays
+ * correct across a signed-long overflow (a real hazard on 32-bit) that the
+ * clamp in global_node_page_state() would otherwise turn into a huge spurious
+ * delta. Do NOT use for non-monotonic page-count reads.
+ */
+static inline unsigned long global_node_page_state_monotonic(enum node_stat_item item)
+{
+	return (unsigned long)atomic_long_read(&vm_node_stat[item]);
+}
+
 static inline unsigned long global_node_page_state(enum node_stat_item item)
 {
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
@@ -259,11 +272,14 @@ extern unsigned long node_page_state(str
 						enum node_stat_item item);
 extern unsigned long node_page_state_pages(struct pglist_data *pgdat,
 					   enum node_stat_item item);
+extern unsigned long node_page_state_monotonic(struct pglist_data *pgdat,
+					       enum node_stat_item item);
 extern void fold_vm_numa_events(void);
 #else
 #define sum_zone_node_page_state(node, item) global_zone_page_state(item)
 #define node_page_state(node, item) global_node_page_state(item)
 #define node_page_state_pages(node, item) global_node_page_state_pages(item)
+#define node_page_state_monotonic(node, item) global_node_page_state_monotonic(item)
 static inline void fold_vm_numa_events(void)
 {
 }
--- a/mm/memcontrol.c~mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers
+++ a/mm/memcontrol.c
@@ -508,6 +508,42 @@ unsigned long lruvec_page_state(struct l
 	return x;
 }
 
+/**
+ * lruvec_page_state_monotonic - non-clamping lruvec stat read for delta sampling
+ * @lruvec: the LRU vector to read from
+ * @idx: the node_stat_item to read
+ *
+ * Returns the raw state[idx] value cast to unsigned long, skipping the
+ * clamp-negative-to-zero step in lruvec_page_state(). Intended for callers
+ * that snapshot a monotonically-incremented counter and subtract two
+ * samples: unsigned modular arithmetic then yields the correct delta across
+ * a signed-long wraparound (a real hazard on 32-bit) that the clamp would
+ * otherwise turn into a huge spurious delta.
+ *
+ * Do NOT use for non-monotonic page-count reads where a transient negative
+ * reading from per-CPU delta skew must present as zero.
+ *
+ * XXX: This helper (and its node/global peers) exists because we place
+ * monotonically-incremented event counters (PGROTATE_*, PGRECLAIM_PAGEOUT_*)
+ * into enum node_stat_item.
+ */
+unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+					  enum node_stat_item idx)
+{
+	struct mem_cgroup_per_node *pn;
+	int i;
+
+	if (mem_cgroup_disabled())
+		return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
+
+	i = memcg_stats_index(idx);
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
+		return 0;
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
+}
+
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx)
 {
--- a/mm/vmstat.c~mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers
+++ a/mm/vmstat.c
@@ -1025,6 +1025,17 @@ unsigned long node_page_state(struct pgl
 
 	return node_page_state_pages(pgdat, item);
 }
+
+/*
+ * Non-clamping variant of node_page_state() intended for callers that
+ * snapshot a monotonically-incremented counter and subtract two samples.
+ * See global_node_page_state_monotonic() for the rationale.
+ */
+unsigned long node_page_state_monotonic(struct pglist_data *pgdat,
+					enum node_stat_item item)
+{
+	return (unsigned long)atomic_long_read(&pgdat->vm_stat[item]);
+}
 #endif
 
 /*
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-migrate_device-pin-large-folios-before-splitting-fix.patch
mm-mempolicy-skip-non-present-pmds-when-queueing-folios.patch
mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch
mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch
mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch
mm-vmscan-reduce-lru_lock-contention-via-vmstat-derived-scan-balance-cost.patch

