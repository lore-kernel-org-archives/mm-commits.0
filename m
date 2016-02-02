From: akpm@linux-foundation.org
Subject: + mm-vmscan-make-zone_reclaimable_pages-more-precise.patch added
 to -mm tree
Date: Mon, 01 Feb 2016 22:32:02 -0800
Message-ID: <56b04d62.Inja1r5JuU6uuEzB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbcBBGcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 01:32:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hillf.zj@alibaba-inc.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: make zone_reclaimable_pages more precise
has been added to the -mm tree.  Its filename is
     mm-vmscan-make-zone_reclaimable_pages-more-precise.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-make-zone_reclaimable_pages-more-precise.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-make-zone_reclaimable_pages-more-precise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmstat-make-quiet_vmstat-lighter.patch
vmstat-make-vmstat_update-deferrable.patch
mm-vmscan-make-zone_reclaimable_pages-more-precise.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch
mm-oom-introduce-oom-reaper.patch
mm-oom-introduce-oom-reaper-v4.patch
oom-reaper-handle-anonymous-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch

