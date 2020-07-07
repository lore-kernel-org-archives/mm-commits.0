From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-kmem-switch-to-static_branch_likely-in-memcg_kmem_enabled.patch added to
 -mm tree
Date: Tue, 07 Jul 2020 12:20:27 -0700
Message-ID: <20200707192027.S4IXW4ryw%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727834AbgGGTU3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:20:29 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, guro@fb.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, shakeelb@google.com, vbabka@suse.cz


The patch titled
     Subject: mm: kmem: switch to static_branch_likely() in memcg_kmem_enabled()
has been added to the -mm tree.  Its filename is
     mm-kmem-switch-to-static_branch_likely-in-memcg_kmem_enabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmem-switch-to-static_branch_likely-in-memcg_kmem_enabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmem-switch-to-static_branch_likely-in-memcg_kmem_enabled.patch

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
Subject: mm: kmem: switch to static_branch_likely() in memcg_kmem_enabled()

Currently memcg_kmem_enabled() is optimized for the kernel memory
accounting being off.  It was so for a long time, and arguably the reason
behind was that the kernel memory accounting was initially an opt-in
feature.  However, now it's on by default on both cgroup v1 and cgroup v2,
and it's on for all cgroups.  So let's switch over to
static_branch_likely() to reflect this fact.

Unlikely there is a significant performance difference, as the cost of a
memory allocation and its accounting significantly exceeds the cost of a
jump.  However, the conversion makes the code look more logically.

Link: http://lkml.kernel.org/r/20200707173612.124425-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-kmem-switch-to-static_branch_likely-in-memcg_kmem_enabled
+++ a/include/linux/memcontrol.h
@@ -1456,7 +1456,7 @@ void memcg_put_cache_ids(void);
 
 static inline bool memcg_kmem_enabled(void)
 {
-	return static_branch_unlikely(&memcg_kmem_enabled_key);
+	return static_branch_likely(&memcg_kmem_enabled_key);
 }
 
 static inline bool memcg_kmem_bypass(void)
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
