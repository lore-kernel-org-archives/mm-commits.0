From: akpm@linux-foundation.org
Subject: + memcg-do-not-check-for-mm-in-mem_cgroup_count_vm_event-disabled.patch added to -mm tree
Date: Thu, 29 Nov 2012 16:32:20 -0800
Message-ID: <20121130003220.CF72110004A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:62409 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2K3AcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Nov 2012 19:32:22 -0500
Received: by mail-ia0-f202.google.com with SMTP id k10so3323723iag.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Nov 2012 16:32:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com, yinghan@google.com


The patch titled
     Subject: memcg: do not check for mm in mem_cgroup_count_vm_event
has been added to the -mm tree.  Its filename is
     memcg-do-not-check-for-mm-in-mem_cgroup_count_vm_event-disabled.patch

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
Subject: memcg: do not check for mm in mem_cgroup_count_vm_event

mm given to mem_cgroup_count_vm_event() cannot be NULL because the
function is either called from the page fault path or vma->vm_mm is used. 
So the check can be dropped.

The check was introduced by 456f998e (memcg: add the pagefault count into
memcg stats) because the originally proposed patch used current->mm for
shmem but this has been changed to vma->vm_mm later on without the check
being removed (thanks to Hugh for this recollection).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-do-not-check-for-mm-in-mem_cgroup_count_vm_event-disabled include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-do-not-check-for-mm-in-mem_cgroup_count_vm_event-disabled
+++ a/include/linux/memcontrol.h
@@ -188,7 +188,7 @@ void __mem_cgroup_count_vm_event(struct 
 static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
 					     enum vm_event_item idx)
 {
-	if (mem_cgroup_disabled() || !mm)
+	if (mem_cgroup_disabled())
 		return;
 	__mem_cgroup_count_vm_event(mm, idx);
 }
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-vmemmap-fix-wrong-use-of-virt_to_page.patch
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
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch
mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled.patch
mm-oom-cleanup-pagefault-oom-handler.patch
mm-oom-remove-redundant-sleep-in-pagefault-oom-handler.patch
mm-oom-remove-statically-defined-arch-functions-of-same-name.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
memcg-do-not-check-for-mm-in-mem_cgroup_count_vm_event-disabled.patch
drop_caches-add-some-documentation-and-info-messsge.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
mm-memblock-reduce-overhead-in-binary-search.patch

