From: akpm@linux-foundation.org
Subject: [folded-dropped] memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0-fix.patch removed from -mm tree
Date: Fri, 16 Nov 2012 14:10:03 -0800
Message-ID: <20121116221004.10FBC200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:57666 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2KPWKH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Nov 2012 17:10:07 -0500
Received: by mail-ea0-f202.google.com with SMTP id f11so205665eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Nov 2012 14:10:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: doc: describe memcg swappiness more precisely
has been removed from the -mm tree.  Its filename was
     memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0-fix.patch

This patch was dropped because it was folded into memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: doc: describe memcg swappiness more precisely

since fe35004f (mm: avoid swapping out with swappiness==0) memcg reclaim
stopped swapping out anon pages completely when 0 value is used.
Although this is somehow expected it hasn't been done for a really long
time this way and so it is probably better to be explicit about the
effect. Moreover global reclaim swapps out even when swappiness is 0
to prevent from OOM killer.

The original issue (a wrong tasks get killed in a small group and memcg
swappiness=0) has been reported on top of our 3.0 based kernel (with
fe35004f backported).  I have tried to replicate it by the test case
mentioned https://lkml.org/lkml/2012/10/10/223.

As David correctly pointed out (https://lkml.org/lkml/2012/10/10/418) the
significant role played the fact that all the processes in the group have
CAP_SYS_ADMIN but oom_score_adj has the similar effect.  Say there is 2G
of swap space which is 524288 pages.  If you add CAP_SYS_ADMIN bonus then
you have -15728 score for the bias.  This means that all tasks with less
than 60M get the minimum score and it is tasks ordering which determines
who gets killed as a result.

To summarize it.  Users of small groups (relatively to the swap size) with
CAP_SYS_ADMIN tasks resp.  oom_score_adj are affected the most others
might see an unexpected oom_badness calculation.  Whether this is a
workload which is representative, I don't know but I think that it is
worth fixing and pushing to stable as well.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/cgroups/memory.txt~memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0-fix
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
_

Patches currently in -mm which might be from mhocko@suse.cz are

memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0.patch
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

