From: akpm@linux-foundation.org
Subject: + mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled.patch added to -mm tree
Date: Tue, 20 Nov 2012 13:49:37 -0800
Message-ID: <20121120214937.AFC5082004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:54582 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2KTVtj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 16:49:39 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so204834vcd.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 13:49:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: mm, memcg: avoid unnecessary function call when memcg is disabled
has been added to the -mm tree.  Its filename is
     mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: avoid unnecessary function call when memcg is disabled

While profiling numa/core v16 with cgroup_disable=memory on the command
line, I noticed mem_cgroup_count_vm_event() still showed up as high as
0.60% in perftop.

This occurs because the function is called extremely often even when memcg
is disabled.

To fix this, inline the check for mem_cgroup_disabled() so we avoid the
unnecessary function call if memcg is disabled.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 ++++++++-
 mm/memcontrol.c            |    9 ++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled
+++ a/include/linux/memcontrol.h
@@ -184,7 +184,14 @@ unsigned long mem_cgroup_soft_limit_recl
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
 
-void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
+void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
+static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
+					     enum vm_event_item idx)
+{
+	if (mem_cgroup_disabled() || !mm)
+		return;
+	__mem_cgroup_count_vm_event(mm, idx);
+}
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 void mem_cgroup_split_huge_fixup(struct page *head);
 #endif
diff -puN mm/memcontrol.c~mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled
+++ a/mm/memcontrol.c
@@ -63,6 +63,8 @@
 #include <trace/events/vmscan.h>
 
 struct cgroup_subsys mem_cgroup_subsys __read_mostly;
+EXPORT_SYMBOL(mem_cgroup_subsys);
+
 #define MEM_CGROUP_RECLAIM_RETRIES	5
 static struct mem_cgroup *root_mem_cgroup __read_mostly;
 
@@ -1150,13 +1152,10 @@ void mem_cgroup_iter_break(struct mem_cg
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
+void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
 {
 	struct mem_cgroup *memcg;
 
-	if (!mm)
-		return;
-
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
 	if (unlikely(!memcg))
@@ -1175,7 +1174,7 @@ void mem_cgroup_count_vm_event(struct mm
 out:
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(mem_cgroup_count_vm_event);
+EXPORT_SYMBOL(__mem_cgroup_count_vm_event);
 
 /**
  * mem_cgroup_zone_lruvec - get the lru list vector for a zone and memcg
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mm-export-a-function-to-get-vm-committed-memory.patch
irq-tsk-comm-is-an-array.patch
mm-memcg-make-mem_cgroup_out_of_memory-static.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-clean-up-__collapse_huge_page_isolate.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves.patch
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
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes.patch
mm-mempolicy-remove-duplicate-code.patch
mm-cleanup-register_node.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch
drivers-base-nodec-cleanup-node_state_attr.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch
thp-huge-zero-page-basic-preparation.patch
thp-huge-zero-page-basic-preparation-v6.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6-fix.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch
thp-change_huge_pmd-keep-huge-zero-page-write-protected.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch
mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

