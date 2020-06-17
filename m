From: akpm@linux-foundation.org
Subject: +
 percpu-return-number-of-released-bytes-from-pcpu_free_area.patch added to -mm
 tree
Date: Wed, 17 Jun 2020 16:34:52 -0700
Message-ID: <20200617233452.i1izc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgFQXey (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 19:34:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tobin@kernel.org, tj@kernel.org, shakeelb@google.com, rientjes@google.com, penberg@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net, longman@redhat.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, dennis@kernel.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: percpu: return number of released bytes from pcpu_free_area()
has been added to the -mm tree.  Its filename is
     percpu-return-number-of-released-bytes-from-pcpu_free_area.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/percpu-return-number-of-released-bytes-from-pcpu_free_area.patch

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
Subject: percpu: return number of released bytes from pcpu_free_area()

Patch series "mm: memcg accounting of percpu memory", v2.

This patchset adds percpu memory accounting to memory cgroups.  It's based
on the rework of the slab controller and reuses concepts and features
introduced for the per-object slab accounting.

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

Percpu allocations by their nature are scattered over multiple pages, so
they can't be tracked on the per-page basis.  So the per-object tracking
introduced by the new slab controller is reused.

The patchset implements charging of percpu allocations, adds memcg-level
statistics, enables accounting for percpu allocations made by memory
cgroup internals and provides some basic tests.

To implement the accounting of percpu memory without a significant memory
and performance overhead the following approach is used: all accounted
allocations are placed into a separate percpu chunk (or chunks).  These
chunks are similar to default chunks, except that they do have an attached
vector of pointers to obj_cgroup objects, which is big enough to save a
pointer for each allocated object.  On the allocation, if the allocation
has to be accounted (__GFP_ACCOUNT is passed, the allocating process
belongs to a non-root memory cgroup, etc), the memory cgroup is getting
charged and if the maximum limit is not exceeded the allocation is
performed using a memcg-aware chunk.  Otherwise -ENOMEM is returned or the
allocation is forced over the limit, depending on gfp (as any other kernel
memory allocation).  The memory cgroup information is saved in the
obj_cgroup vector at the corresponding offset.  On the release time the
memcg information is restored from the vector and the cgroup is getting
uncharged.  Unaccounted allocations (at this point the absolute majority
of all percpu allocations) are performed in the old way, so no additional
overhead is expected.

To avoid pinning dying memory cgroups by outstanding allocations,
obj_cgroup API is used instead of directly saving memory cgroup pointers. 
obj_cgroup is basically a pointer to a memory cgroup with a standalone
reference counter.  The trick is that it can be atomically swapped to
point at the parent cgroup, so that the original memory cgroup can be
released prior to all objects, which has been charged to it.  Because all
charges and statistics are fully recursive, it's perfectly correct to
uncharge the parent cgroup instead.  This scheme is used in the slab
memory accounting, and percpu memory can just follow the scheme.


This patch (of 5):

To implement accounting of percpu memory we need the information about the
size of freed object.  Return it from pcpu_free_area().

Link: http://lkml.kernel.org/r/20200608230819.832349-1-guro@fb.com
Link: http://lkml.kernel.org/r/20200608230819.832349-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/percpu.c~percpu-return-number-of-released-bytes-from-pcpu_free_area
+++ a/mm/percpu.c
@@ -1211,11 +1211,14 @@ static int pcpu_alloc_area(struct pcpu_c
  *
  * This function determines the size of an allocation to free using
  * the boundary bitmap and clears the allocation map.
+ *
+ * RETURNS:
+ * Number of freed bytes.
  */
-static void pcpu_free_area(struct pcpu_chunk *chunk, int off)
+static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
 {
 	struct pcpu_block_md *chunk_md = &chunk->chunk_md;
-	int bit_off, bits, end, oslot;
+	int bit_off, bits, end, oslot, freed;
 
 	lockdep_assert_held(&pcpu_lock);
 	pcpu_stats_area_dealloc(chunk);
@@ -1230,8 +1233,10 @@ static void pcpu_free_area(struct pcpu_c
 	bits = end - bit_off;
 	bitmap_clear(chunk->alloc_map, bit_off, bits);
 
+	freed = bits * PCPU_MIN_ALLOC_SIZE;
+
 	/* update metadata */
-	chunk->free_bytes += bits * PCPU_MIN_ALLOC_SIZE;
+	chunk->free_bytes += freed;
 
 	/* update first free bit */
 	chunk_md->first_free = min(chunk_md->first_free, bit_off);
@@ -1239,6 +1244,8 @@ static void pcpu_free_area(struct pcpu_c
 	pcpu_block_update_hint_free(chunk, bit_off, bits);
 
 	pcpu_chunk_relocate(chunk, oslot);
+
+	return freed;
 }
 
 static void pcpu_init_md_block(struct pcpu_block_md *block, int nr_bits)
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
