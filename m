From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:29:07 -0800
Message-ID: <20121214232908.3FC92200063@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:41259 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab2LNX3L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:29:11 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so208420fae.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:29:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: avoid unnecessary function call when memcg is disabled
has been removed from the -mm tree.  Its filename was
     mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 ++++++++-
 mm/memcontrol.c            |    6 ++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled
+++ a/include/linux/memcontrol.h
@@ -181,7 +181,14 @@ unsigned long mem_cgroup_soft_limit_recl
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
 
-void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
+void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
+static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
+					     enum vm_event_item idx)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_count_vm_event(mm, idx);
+}
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 void mem_cgroup_split_huge_fixup(struct page *head);
 #endif
diff -puN mm/memcontrol.c~mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled
+++ a/mm/memcontrol.c
@@ -59,6 +59,8 @@
 #include <trace/events/vmscan.h>
 
 struct cgroup_subsys mem_cgroup_subsys __read_mostly;
+EXPORT_SYMBOL(mem_cgroup_subsys);
+
 #define MEM_CGROUP_RECLAIM_RETRIES	5
 static struct mem_cgroup *root_mem_cgroup __read_mostly;
 
@@ -1015,7 +1017,7 @@ void mem_cgroup_iter_break(struct mem_cg
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
+void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
 {
 	struct mem_cgroup *memcg;
 
@@ -1040,7 +1042,7 @@ void mem_cgroup_count_vm_event(struct mm
 out:
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(mem_cgroup_count_vm_event);
+EXPORT_SYMBOL(__mem_cgroup_count_vm_event);
 
 /**
  * mem_cgroup_zone_lruvec - get the lru list vector for a zone and memcg
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
irq-tsk-comm-is-an-array.patch
mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
memcg-kmem-accounting-basic-infrastructure-fix.patch
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
ksm-numa-awareness-sysfs-knob.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

