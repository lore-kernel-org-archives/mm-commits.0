From: akpm@linux-foundation.org
Subject: [folded] mm-vmstat-add-isolate-pages-fix-fix-fix.patch removed from -mm tree
Date: Tue, 15 Sep 2009 19:17:32 -0700
Message-ID: <200909160217.n8G2HW7q027145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978AbZIPCRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Sep 2009 22:17:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Kill Isolated field in /proc/meminfo fix
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-isolate-pages-fix-fix-fix.patch

This patch was dropped because it was folded into mm-vmstat-add-isolate-pages.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Kill Isolated field in /proc/meminfo fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Hugh Dickins pointed out Isolated field dislpay 0kB at almost time.
It is only increased at heavy memory pressure case.

So, if the system haven't get memory pressure, this field isn't useful.
And now, we have an alternative way, (i.e. /prov/vmstat).
Then, it can be removed.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/base/node.c~mm-vmstat-add-isolate-pages-fix-fix-fix drivers/base/node.c
--- a/drivers/base/node.c~mm-vmstat-add-isolate-pages-fix-fix-fix
+++ a/drivers/base/node.c
@@ -73,8 +73,6 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d Active(file):   %8lu kB\n"
 		       "Node %d Inactive(file): %8lu kB\n"
 		       "Node %d Unevictable:    %8lu kB\n"
-		       "Node %d Isolated(anon): %8lu kB\n"
-		       "Node %d Isolated(file): %8lu kB\n"
 		       "Node %d Mlocked:        %8lu kB\n"
 #ifdef CONFIG_HIGHMEM
 		       "Node %d HighTotal:      %8lu kB\n"
@@ -108,8 +106,6 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_ACTIVE_FILE)),
 		       nid, K(node_page_state(nid, NR_INACTIVE_FILE)),
 		       nid, K(node_page_state(nid, NR_UNEVICTABLE)),
-		       nid, K(node_page_state(nid, NR_ISOLATED_ANON)),
-		       nid, K(node_page_state(nid, NR_ISOLATED_FILE)),
 		       nid, K(node_page_state(nid, NR_MLOCK)),
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-memory-failure-remove-config_unevictable_lru-config-option.patch
revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-rename-pgmoved-variable-in-shrink_active_list.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
mm-vmstat-add-isolate-pages-fix-fix-fix.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback-fix.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
mm-drop-unneeded-double-negations.patch
mm-introduce-page_lru_base_type.patch
mm-introduce-page_lru_base_type-fix.patch
mm-return-boolean-from-page_is_file_cache.patch
mm-return-boolean-from-page_has_private.patch
mm-document-is_page_cache_freeable.patch
mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
mm-do-batched-scans-for-mem_cgroup.patch
mm-vmscan-remove-page_queue_congested-comment.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-munlock-use-follow_page.patch
mm-remove-unused-gup-flags.patch
mm-add-get_dump_page.patch
mm-foll_dump-replace-foll_anon.patch
mm-follow_hugetlb_page-flags.patch
mm-fix-anonymous-dirtying.patch
mm-reinstate-zero_page.patch
mm-foll-flags-for-gup-flags.patch
mm-munlock-avoid-zero_page.patch
mm-hugetlbfs_pagecache_present.patch
mm-zero_page-without-pte_special.patch
mm-move-highest_memmap_pfn.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

