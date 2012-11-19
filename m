From: akpm@linux-foundation.org
Subject: [merged] memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0.patch removed from -mm tree
Date: Mon, 19 Nov 2012 12:21:32 -0800
Message-ID: <20121119202132.C3D0B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:51731 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab2KSUVe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 15:21:34 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so599754yhl.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 12:21:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: oom: fix totalpages calculation for memory.swappiness==0
has been removed from the -mm tree.  Its filename was
     memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: oom: fix totalpages calculation for memory.swappiness==0

oom_badness() takes a totalpages argument which says how many pages are
available and it uses it as a base for the score calculation.  The value
is calculated by mem_cgroup_get_limit which considers both limit and
total_swap_pages (resp.  memsw portion of it).

This is usually correct but since fe35004f ("mm: avoid swapping out with
swappiness==0") we do not swap when swappiness is 0 which means that we
cannot really use up all the totalpages pages.  This in turn confuses oom
score calculation if the memcg limit is much smaller than the available
swap because the used memory (capped by the limit) is negligible comparing
to totalpages so the resulting score is too small if adj!=0 (typically
task with CAP_SYS_ADMIN or non zero oom_score_adj).  A wrong process might
be selected as result.

The problem can be worked around by checking mem_cgroup_swappiness==0 and
not considering swap at all in such a case.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    4 ++++
 mm/memcontrol.c                  |   21 +++++++++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0 Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0
+++ a/Documentation/cgroups/memory.txt
@@ -466,6 +466,10 @@ Note:
 5.3 swappiness
 
 Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
+Please note that unlike the global swappiness, memcg knob set to 0
+really prevents from any swapping even if there is a swap storage
+available. This might lead to memcg OOM killer if there are no file
+pages to reclaim.
 
 Following cgroups' swappiness can't be changed.
 - root cgroup (uses /proc/sys/vm/swappiness).
diff -puN mm/memcontrol.c~memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0
+++ a/mm/memcontrol.c
@@ -1452,17 +1452,26 @@ static int mem_cgroup_count_children(str
 static u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
 {
 	u64 limit;
-	u64 memsw;
 
 	limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
-	limit += total_swap_pages << PAGE_SHIFT;
 
-	memsw = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
 	/*
-	 * If memsw is finite and limits the amount of swap space available
-	 * to this memcg, return that limit.
+	 * Do not consider swap space if we cannot swap due to swappiness
 	 */
-	return min(limit, memsw);
+	if (mem_cgroup_swappiness(memcg)) {
+		u64 memsw;
+
+		limit += total_swap_pages << PAGE_SHIFT;
+		memsw = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
+
+		/*
+		 * If memsw is finite and limits the amount of swap space
+		 * available to this memcg, return that limit.
+		 */
+		limit = min(limit, memsw);
+	}
+
+	return limit;
 }
 
 void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
_

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
mm-memcg-make-mem_cgroup_out_of_memory-static.patch
thp-clean-up-__collapse_huge_page_isolate.patch
thp-clean-up-__collapse_huge_page_isolate-v2.patch
mm-introduce-mm_find_pmd.patch
mm-introduce-mm_find_pmd-fix.patch
thp-introduce-hugepage_vma_check.patch
thp-cleanup-introduce-mk_huge_pmd.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
memcg-kmem-controller-infrastructure-replace-__always_inline-with-plain-inline.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears-simplify-ida-initialization.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions-remove-test-for-current-mm-in-memcg_stop-resume_kmem_account.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-destroy-memcg-caches-move-include-of-workqueueh-to-top-of-slabh-file.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation.patch
slub-drop-mutex-before-deleting-sysfs-entry.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch
drop_caches-add-some-documentation-and-info-messsge.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
mm-memblock-reduce-overhead-in-binary-search.patch

