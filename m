From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-oom-rework-oom-detection-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 05 Apr 2016 14:19:01 -0700
Message-ID: <57042bc5.Bb3RZlVlII8JcCpy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbcDEVTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:19:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-rework-oom-detection-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-oom-rework-oom-detection-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom-rework-oom-detection-checkpatch-fixes

Cc: David Rientjes <rientjes@google.com>

WARNING: line over 80 characters
#99: FILE: mm/page_alloc.c:2965:
+ * zone list (with a backoff mechanism which is a function of no_progress_loops).

WARNING: line over 80 characters
#129: FILE: mm/page_alloc.c:2995:
+	 * Keep reclaiming pages while there is a chance this will lead somewhere.

WARNING: line over 80 characters
#134: FILE: mm/page_alloc.c:3000:
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx, ac->nodemask) {

WARNING: line over 80 characters
#138: FILE: mm/page_alloc.c:3004:
+		available -= DIV_ROUND_UP(no_progress_loops * available, MAX_RECLAIM_RETRIES);

WARNING: line over 80 characters
#142: FILE: mm/page_alloc.c:3008:
+		 * Would the allocation succeed if we reclaimed the whole available?

WARNING: line over 80 characters
#146: FILE: mm/page_alloc.c:3012:
+			/* Wait for some write requests to complete then retry */

total: 0 errors, 6 warnings, 202 lines checked

./patches/mm-oom-rework-oom-detection.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~mm-oom-rework-oom-detection-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-rework-oom-detection-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -3153,7 +3153,8 @@ static inline bool is_thp_gfp_mask(gfp_t
  * the last reclaim round), pages_reclaimed (cumulative number of reclaimed
  * pages) and no_progress_loops (number of reclaim rounds without any progress
  * in a row) is considered as well as the reclaimable pages on the applicable
- * zone list (with a backoff mechanism which is a function of no_progress_loops).
+ * zone list (with a backoff mechanism which is a function of
+ * no_progress_loops).
  *
  * Returns true if a retry is viable or false to enter the oom path.
  */
@@ -3183,24 +3184,27 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 	}
 
 	/*
-	 * Keep reclaiming pages while there is a chance this will lead somewhere.
-	 * If none of the target zones can satisfy our allocation request even
-	 * if all reclaimable pages are considered then we are screwed and have
-	 * to go OOM.
+	 * Keep reclaiming pages while there is a chance this will lead
+	 * somewhere.  If none of the target zones can satisfy our allocation
+	 * request even if all reclaimable pages are considered then we are
+	 * screwed and have to go OOM.
 	 */
-	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx, ac->nodemask) {
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
+			ac->high_zoneidx, ac->nodemask) {
 		unsigned long available;
 
 		available = zone_reclaimable_pages(zone);
-		available -= DIV_ROUND_UP(no_progress_loops * available, MAX_RECLAIM_RETRIES);
+		available -= DIV_ROUND_UP(no_progress_loops * available,
+					  MAX_RECLAIM_RETRIES);
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
 
 		/*
-		 * Would the allocation succeed if we reclaimed the whole available?
+		 * Would the allocation succeed if we reclaimed the whole
+		 * available?
 		 */
 		if (__zone_watermark_ok(zone, order, min_wmark_pages(zone),
 				ac->high_zoneidx, alloc_flags, available)) {
-			/* Wait for some write requests to complete then retry */
+			/* Wait for some writes to complete then retry */
 			wait_iff_congested(zone, BLK_RW_ASYNC, HZ/50);
 			return true;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

