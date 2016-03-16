From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-make-zone_reclaimable_pages-more-precise.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:56:36 -0700
Message-ID: <56e9ba74.07n8HgTp4oyVZ6Yi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbcCPT4h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:56:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hillf.zj@alibaba-inc.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: make zone_reclaimable_pages more precise
has been removed from the -mm tree.  Its filename was
     mm-vmscan-make-zone_reclaimable_pages-more-precise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: make zone_reclaimable_pages more precise

zone_reclaimable_pages() is used in should_reclaim_retry() which uses it
to calculate the target for the watermark check.  This means that precise
numbers are important for the correct decision.  zone_reclaimable_pages
uses zone_page_state which can contain stale data with per-cpu diffs not
synced yet (the last vmstat_update might have run 1s in the past).

Use zone_page_state_snapshot() in zone_reclaimable_pages() instead.  None
of the current callers is in a hot path where getting the precise value
(which involves per-cpu iteration) would cause an unreasonable overhead.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-make-zone_reclaimable_pages-more-precise mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-make-zone_reclaimable_pages-more-precise
+++ a/mm/vmscan.c
@@ -195,21 +195,21 @@ static unsigned long zone_reclaimable_pa
 {
 	unsigned long nr;
 
-	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
-	     zone_page_state(zone, NR_INACTIVE_FILE) +
-	     zone_page_state(zone, NR_ISOLATED_FILE);
+	nr = zone_page_state_snapshot(zone, NR_ACTIVE_FILE) +
+	     zone_page_state_snapshot(zone, NR_INACTIVE_FILE) +
+	     zone_page_state_snapshot(zone, NR_ISOLATED_FILE);
 
 	if (get_nr_swap_pages() > 0)
-		nr += zone_page_state(zone, NR_ACTIVE_ANON) +
-		      zone_page_state(zone, NR_INACTIVE_ANON) +
-		      zone_page_state(zone, NR_ISOLATED_ANON);
+		nr += zone_page_state_snapshot(zone, NR_ACTIVE_ANON) +
+		      zone_page_state_snapshot(zone, NR_INACTIVE_ANON) +
+		      zone_page_state_snapshot(zone, NR_ISOLATED_ANON);
 
 	return nr;
 }
 
 bool zone_reclaimable(struct zone *zone)
 {
-	return zone_page_state(zone, NR_PAGES_SCANNED) <
+	return zone_page_state_snapshot(zone, NR_PAGES_SCANNED) <
 		zone_reclaimable_pages(zone) * 6;
 }
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-introduce-oom-reaper.patch
oom-reaper-handle-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix-2.patch
mm-oom_reaper-report-success-failure.patch
mm-oom_reaper-report-success-failure-fix-2.patch
mm-oom_reaper-report-success-failure-fix-fix.patch
mm-oom_reaper-implement-oom-victims-queuing.patch
oom-make-oom_reaper-freezable.patch
oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch
mm-remove-__gfp_nofail-is-deprecated-comment.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

