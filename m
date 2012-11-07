From: akpm@linux-foundation.org
Subject: + memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0.patch added to -mm tree
Date: Wed, 07 Nov 2012 14:11:37 -0800
Message-ID: <20121107221138.AF8EA20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:60570 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2KGWLl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2012 17:11:41 -0500
Received: by mail-ee0-f74.google.com with SMTP id b57so139233eek.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Nov 2012 14:11:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, stable@vger.kernel.org


The patch titled
     Subject: memcg: oom: fix totalpages calculation for memory.swappiness==0
has been added to the -mm tree.  Its filename is
     memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 mm/memcontrol.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0
+++ a/mm/memcontrol.c
@@ -1591,17 +1591,26 @@ static int mem_cgroup_count_children(str
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
 
 static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
_

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
mm-fix-a-regression-with-highmem-introduced-by-changeset-7f1290f2f2a4d.patch
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
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0.patch
memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
mm-memblock-reduce-overhead-in-binary-search.patch

