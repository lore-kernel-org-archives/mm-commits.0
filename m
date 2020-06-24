From: akpm@linux-foundation.org
Subject: + mm-memcg-slab-deprecate-memorykmemslabinfo.patch added to
 -mm tree
Date: Wed, 24 Jun 2020 14:47:13 -0700
Message-ID: <20200624214713.7vXUo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404274AbgFXVrP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 17:47:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tj@kernel.org, shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: mm: memcg/slab: deprecate memory.kmem.slabinfo
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-deprecate-memorykmemslabinfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-deprecate-memorykmemslabinfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-deprecate-memorykmemslabinfo.patch

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
Subject: mm: memcg/slab: deprecate memory.kmem.slabinfo

Deprecate memory.kmem.slabinfo.

An empty file will be presented if corresponding config options are
enabled.

The interface is implementation dependent, isn't present in cgroup v2, and
is generally useful only for core mm debugging purposes.  In other words,
it doesn't provide any value for the absolute majority of users.

A drgn-based replacement can be found in tools/cgroup/slabinfo.py .  It
does support cgroup v1 and v2, mimics memory.kmem.slabinfo output and also
allows to get any additional information without a need to recompile the
kernel.

If a drgn-based solution is too slow for a task, a bpf-based tracing tool
can be used, which can easily keep track of all slab allocations belonging
to a memory cgroup.

Link: http://lkml.kernel.org/r/20200623174037.3951353-11-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c  |    3 ---
 mm/slab_common.c |   31 ++++---------------------------
 2 files changed, 4 insertions(+), 30 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-slab-deprecate-memorykmemslabinfo
+++ a/mm/memcontrol.c
@@ -5118,9 +5118,6 @@ static struct cftype mem_cgroup_legacy_f
 	(defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG))
 	{
 		.name = "kmem.slabinfo",
-		.seq_start = memcg_slab_start,
-		.seq_next = memcg_slab_next,
-		.seq_stop = memcg_slab_stop,
 		.seq_show = memcg_slab_show,
 	},
 #endif
--- a/mm/slab_common.c~mm-memcg-slab-deprecate-memorykmemslabinfo
+++ a/mm/slab_common.c
@@ -1523,35 +1523,12 @@ void dump_unreclaimable_slab(void)
 }
 
 #if defined(CONFIG_MEMCG_KMEM)
-void *memcg_slab_start(struct seq_file *m, loff_t *pos)
-{
-	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
-
-	mutex_lock(&slab_mutex);
-	return seq_list_start(&memcg->kmem_caches, *pos);
-}
-
-void *memcg_slab_next(struct seq_file *m, void *p, loff_t *pos)
-{
-	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
-
-	return seq_list_next(p, &memcg->kmem_caches, pos);
-}
-
-void memcg_slab_stop(struct seq_file *m, void *p)
-{
-	mutex_unlock(&slab_mutex);
-}
-
 int memcg_slab_show(struct seq_file *m, void *p)
 {
-	struct kmem_cache *s = list_entry(p, struct kmem_cache,
-					  memcg_params.kmem_caches_node);
-	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
-
-	if (p == memcg->kmem_caches.next)
-		print_slabinfo_header(m);
-	cache_show(s, m);
+	/*
+	 * Deprecated.
+	 * Please, take a look at tools/cgroup/slabinfo.py .
+	 */
 	return 0;
 }
 #endif
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
