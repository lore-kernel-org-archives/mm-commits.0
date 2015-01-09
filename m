From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch removed from -mm tree
Date: Fri, 09 Jan 2015 15:31:03 -0800
Message-ID: <54b064b7.+7vAT8vuiRH30Pmh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbbAIXbE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 18:31:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch

This patch was dropped because it was folded into mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update

Here is an updated version of this patch with a more detailed changelog.

The OOM killing invocation does a lot of duplicative checks against
the task's allocation context.  Rework it to take advantage of the
existing checks in the allocator slowpath.

The OOM killer is invoked when the allocator is unable to reclaim any
pages but the allocation has to keep looping.  Instead of having a
check for __GFP_NORETRY hidden in oom_gfp_allowed(), just move the OOM
invocation to the true branch of should_alloc_retry().  The __GFP_FS
check from oom_gfp_allowed() can then be moved into the OOM avoidance
branch in __alloc_pages_may_oom(), along with the PF_DUMPCORE test.

__alloc_pages_may_oom() can then signal to the caller whether the OOM
killer was invoked, instead of requiring it to duplicate the order and
high_zoneidx checks to guess this when deciding whether to continue.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update
+++ a/mm/page_alloc.c
@@ -2818,10 +2818,8 @@ rebalance:
 						migratetype,&did_some_progress);
 			if (page)
 				goto got_pg;
-			if (!did_some_progress) {
-				BUG_ON(gfp_mask & __GFP_NOFAIL);
+			if (!did_some_progress)
 				goto nopage;
-			}
 		}
 		/* Wait for some write requests to complete then retry */
 		wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-memcontrol-switch-soft-limit-default-back-to-infinity.patch
memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch
mm-vmscan-prevent-kswapd-livelock-due-to-pfmemalloc-throttled-process-being-killed.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-memcontrol-track-move_lock-state-internally-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch

