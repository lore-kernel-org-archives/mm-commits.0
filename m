From: akpm@linux-foundation.org
Subject: [merged] mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:01 -0700
Message-ID: <200909222038.n8MKc1MA000567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbZIVUi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:38:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: show_free_areas(): display slab pages in two separate fields
has been removed from the -mm tree.  Its filename was
     mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: show_free_areas(): display slab pages in two separate fields
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

If an OOM happens, we really want to know the number of remaining
reclaimable pages.  So the reclaimable slab and unreclaimable slab fields
should not be combined for display.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-show_free_areas-display-slab-pages-in-two-separate-fields mm/page_alloc.c
--- a/mm/page_alloc.c~mm-show_free_areas-display-slab-pages-in-two-separate-fields
+++ a/mm/page_alloc.c
@@ -2138,7 +2138,8 @@ void show_free_areas(void)
 		" inactive_file:%lu"
 		" unevictable:%lu"
 		" dirty:%lu writeback:%lu unstable:%lu\n"
-		" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
+		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
+		" mapped:%lu pagetables:%lu bounce:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
 		global_page_state(NR_ACTIVE_FILE),
 		global_page_state(NR_INACTIVE_ANON),
@@ -2148,8 +2149,8 @@ void show_free_areas(void)
 		global_page_state(NR_WRITEBACK),
 		global_page_state(NR_UNSTABLE_NFS),
 		global_page_state(NR_FREE_PAGES),
-		global_page_state(NR_SLAB_RECLAIMABLE) +
-			global_page_state(NR_SLAB_UNRECLAIMABLE),
+		global_page_state(NR_SLAB_RECLAIMABLE),
+		global_page_state(NR_SLAB_UNRECLAIMABLE),
 		global_page_state(NR_FILE_MAPPED),
 		global_page_state(NR_PAGETABLE),
 		global_page_state(NR_BOUNCE));
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

