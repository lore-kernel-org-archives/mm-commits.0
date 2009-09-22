From: akpm@linux-foundation.org
Subject: [merged] mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:09 -0700
Message-ID: <200909222038.n8MKc9fJ000835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780AbZIVUmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: oom analysis: add buffer cache information to show_free_areas()
has been removed from the -mm tree.  Its filename was
     mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: oom analysis: add buffer cache information to show_free_areas()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

It is often useful to know the statistics for all pages that are handled
like page cache pages when looking at OOM log output.

Therefore show_free_areas() should also display buffer cache statistics.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-oom-analysis-add-buffer-cache-information-to-show_free_areas mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-analysis-add-buffer-cache-information-to-show_free_areas
+++ a/mm/page_alloc.c
@@ -2137,7 +2137,7 @@ void show_free_areas(void)
 	printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
 		" inactive_file:%lu"
 		" unevictable:%lu"
-		" dirty:%lu writeback:%lu unstable:%lu\n"
+		" dirty:%lu writeback:%lu unstable:%lu buffer:%lu\n"
 		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
 		" mapped:%lu pagetables:%lu bounce:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
@@ -2148,6 +2148,7 @@ void show_free_areas(void)
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
 		global_page_state(NR_UNSTABLE_NFS),
+		nr_blockdev_pages(),
 		global_page_state(NR_FREE_PAGES),
 		global_page_state(NR_SLAB_RECLAIMABLE),
 		global_page_state(NR_SLAB_UNRECLAIMABLE),
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
readahead-add-blk_run_backing_dev.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
getrusage-fill-ru_maxrss-value.patch
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

