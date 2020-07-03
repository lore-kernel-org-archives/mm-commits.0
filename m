From: akpm@linux-foundation.org
Subject: + mm-kmem-make-memcg_kmem_enabled-irreversible.patch
 added to -mm tree
Date: Thu, 02 Jul 2020 21:26:50 -0700
Message-ID: <20200703042650.v405M0Lth%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgGCE0v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 00:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, mhocko@suse.com, mm-commits@vger.kernel.org, naresh.kamboju@linaro.org, shakeelb@google.com, vbabka@suse.cz


The patch titled
     Subject: mm: kmem: make memcg_kmem_enabled() irreversible
has been added to the -mm tree.  Its filename is
     mm-kmem-make-memcg_kmem_enabled-irreversible.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmem-make-memcg_kmem_enabled-irreversible.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmem-make-memcg_kmem_enabled-irreversible.patch

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
Subject: mm: kmem: make memcg_kmem_enabled() irreversible

Historically the kernel memory accounting was an opt-in feature, which
could be enabled for individual cgroups.  But now it's not true, and it's
on by default both on cgroup v1 and cgroup v2.  And as long as a user has
at least one non-root memory cgroup, the kernel memory accounting is on. 
So in most setups it's either always on (if memory cgroups are in use and
kmem accounting is not disabled), either always off (otherwise).

memcg_kmem_enabled() is used in many places to guard the kernel memory
accounting code.  If memcg_kmem_enabled() can reverse from returning true
to returning false (as now), we can't rely on it on release paths and have
to check if it was on before.

If we'll make memcg_kmem_enabled() irreversible (always returning true
after returning it for the first time), it'll make the general logic more
simple and robust.  It also will allow to guard some checks which
otherwise would stay unguarded.

Link: http://lkml.kernel.org/r/20200702180926.1330769-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-kmem-make-memcg_kmem_enabled-irreversible
+++ a/mm/memcontrol.c
@@ -3416,7 +3416,8 @@ static int memcg_online_kmem(struct mem_
 	if (memcg_id < 0)
 		return memcg_id;
 
-	static_branch_inc(&memcg_kmem_enabled_key);
+	static_branch_enable(&memcg_kmem_enabled_key);
+
 	/*
 	 * A memory cgroup is considered kmem-online as soon as it gets
 	 * kmemcg_id. Setting the id after enabling static branching will
@@ -3486,11 +3487,6 @@ static void memcg_free_kmem(struct mem_c
 	/* css_alloc() failed, offlining didn't happen */
 	if (unlikely(memcg->kmem_state == KMEM_ONLINE))
 		memcg_offline_kmem(memcg);
-
-	if (memcg->kmem_state == KMEM_ALLOCATED) {
-		WARN_ON(!list_empty(&memcg->kmem_caches));
-		static_branch_dec(&memcg_kmem_enabled_key);
-	}
 }
 #else
 static int memcg_online_kmem(struct mem_cgroup *memcg)
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
