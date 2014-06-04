From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:23:48 -0700
Message-ID: <538f9c74.1aeMtu9IPHAC7Ds6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaFDWXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:23:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rientjes@google.com, mhocko@suse.cz, hannes@cmpxchg.org

Subject: [folded-merged] mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch removed from -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,rientjes@google.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:23:48 -0700


The patch titled
     Subject: mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch

This patch was dropped because it was folded into mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix

Update Documentation/cgroups/memory.txt

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN Documentation/cgroups/memory.txt~mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix
+++ a/Documentation/cgroups/memory.txt
@@ -535,17 +535,15 @@ Note:
 
 5.3 swappiness
 
-Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
+Similar to /proc/sys/vm/swappiness, but only affecting reclaim that is
+triggered by this cgroup's hard limit.  The tunable in the root cgroup
+corresponds to the global swappiness setting.
+
 Please note that unlike the global swappiness, memcg knob set to 0
 really prevents from any swapping even if there is a swap storage
 available. This might lead to memcg OOM killer if there are no file
 pages to reclaim.
 
-Following cgroups' swappiness can't be changed.
-- root cgroup (uses /proc/sys/vm/swappiness).
-- a cgroup which uses hierarchy and it has other cgroup(s) below it.
-- a cgroup which uses hierarchy and not the root of hierarchy.
-
 5.4 failcnt
 
 A memory cgroup provides memory.failcnt and memory.memsw.failcnt files.
@@ -754,7 +752,6 @@ You can disable the OOM-killer by writin
 
 	#echo 1 > memory.oom_control
 
-This operation is only allowed to the top cgroup of a sub-hierarchy.
 If OOM-killer is disabled, tasks under cgroup will hang/sleep
 in memory cgroup's OOM-waitqueue when they request accountable memory.
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
documentation-memcg-warn-about-incomplete-kmemcg-state.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
memcg-kill-config_mm_owner.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch
mm-avoid-throttling-reclaim-for-loop-back-nfsd-threads.patch
memcg-mm_update_next_owner-should-skip-kthreads.patch
memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch
memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
memcg-fold-mem_cgroup_stolen.patch
memcg-fold-mem_cgroup_stolen-fix.patch
memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch
memcg-get-rid-of-memcg_create_cache_name.patch
memcg-memcg_kmem_create_cache-make-memcg_name_buf.patch
swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
memcg-cleanup-kmem-cache-creation-destruction-functions-naming.patch
mm-page_alloc-do-not-update-zlc-unless-the-zlc-is-active.patch
mm-page_alloc-do-not-treat-a-zone-that-cannot-be-used-for-dirty-pages-as-full.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref-fix.patch
mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch
fs-superblock-unregister-sb-shrinker-before-kill_sb.patch
fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch
mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch
mm-page-writebackc-remove-outdated-comment.patch
mm-memcg-periodically-schedule-when-emptying-page-list.patch
lib-radix-treec-kernel-doc-warning-fix.patch

