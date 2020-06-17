From: akpm@linux-foundation.org
Subject: +
 mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch added to -mm
 tree
Date: Wed, 17 Jun 2020 16:35:02 -0700
Message-ID: <20200617233502.gCI1E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbgFQXfD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 19:35:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tobin@kernel.org, tj@kernel.org, shakeelb@google.com, rientjes@google.com, penberg@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net, longman@redhat.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, dennis@kernel.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: mm: memcg: charge memcg percpu memory to the parent cgroup
has been added to the -mm tree.  Its filename is
     mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch

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
Subject: mm: memcg: charge memcg percpu memory to the parent cgroup

Memory cgroups are using large chunks of percpu memory to store vmstat
data.  Yet this memory is not accounted at all, so in the case when there
are many (dying) cgroups, it's not exactly clear where all the memory is.

Because the size of memory cgroup internal structures can dramatically
exceed the size of object or page which is pinning it in the memory, it's
not a good idea to simple ignore it.  It actually breaks the isolation
between cgroups.

Let's account the consumed percpu memory to the parent cgroup.

Link: http://lkml.kernel.org/r/20200608230819.832349-5-guro@fb.com
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

 mm/memcontrol.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup
+++ a/mm/memcontrol.c
@@ -5069,13 +5069,15 @@ static int alloc_mem_cgroup_per_node_inf
 	if (!pn)
 		return 1;
 
-	pn->lruvec_stat_local = alloc_percpu(struct lruvec_stat);
+	pn->lruvec_stat_local = alloc_percpu_gfp(struct lruvec_stat,
+						 GFP_KERNEL_ACCOUNT);
 	if (!pn->lruvec_stat_local) {
 		kfree(pn);
 		return 1;
 	}
 
-	pn->lruvec_stat_cpu = alloc_percpu(struct lruvec_stat);
+	pn->lruvec_stat_cpu = alloc_percpu_gfp(struct lruvec_stat,
+					       GFP_KERNEL_ACCOUNT);
 	if (!pn->lruvec_stat_cpu) {
 		free_percpu(pn->lruvec_stat_local);
 		kfree(pn);
@@ -5149,11 +5151,13 @@ static struct mem_cgroup *mem_cgroup_all
 		goto fail;
 	}
 
-	memcg->vmstats_local = alloc_percpu(struct memcg_vmstats_percpu);
+	memcg->vmstats_local = alloc_percpu_gfp(struct memcg_vmstats_percpu,
+						GFP_KERNEL_ACCOUNT);
 	if (!memcg->vmstats_local)
 		goto fail;
 
-	memcg->vmstats_percpu = alloc_percpu(struct memcg_vmstats_percpu);
+	memcg->vmstats_percpu = alloc_percpu_gfp(struct memcg_vmstats_percpu,
+						 GFP_KERNEL_ACCOUNT);
 	if (!memcg->vmstats_percpu)
 		goto fail;
 
@@ -5202,7 +5206,9 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	struct mem_cgroup *memcg;
 	long error = -ENOMEM;
 
+	memalloc_use_memcg(parent);
 	memcg = mem_cgroup_alloc();
+	memalloc_unuse_memcg();
 	if (IS_ERR(memcg))
 		return ERR_CAST(memcg);
 
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
