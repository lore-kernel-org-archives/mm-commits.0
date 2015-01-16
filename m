From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch added
 to -mm tree
Date: Thu, 15 Jan 2015 17:17:49 -0800
Message-ID: <54b866bd.NvMxdivAVaq1B5Cg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445AbbAPBSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 20:18:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vinmenon@codeaurora.org, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: fix the page state calculation in too_many_isolated
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vinayak Menon <vinmenon@codeaurora.org>
Subject: mm: vmscan: fix the page state calculation in too_many_isolated

It is observed that sometimes multiple tasks get blocked for long in the
congestion_wait loop below, in shrink_inactive_list.  This is because of
vm_stat values not being synced.

(__schedule) from [<c0a03328>]
(schedule_timeout) from [<c0a04940>]
(io_schedule_timeout) from [<c01d585c>]
(congestion_wait) from [<c01cc9d8>]
(shrink_inactive_list) from [<c01cd034>]
(shrink_zone) from [<c01cdd08>]
(try_to_free_pages) from [<c01c442c>]
(__alloc_pages_nodemask) from [<c01f1884>]
(new_slab) from [<c09fcf60>]
(__slab_alloc) from [<c01f1a6c>]

In one such instance, zone_page_state(zone, NR_ISOLATED_FILE) had returned
14, zone_page_state(zone, NR_INACTIVE_FILE) returned 92, and GFP_IOFS was
set, and this resulted in too_many_isolated returning true.  But one of
the CPU's pageset vm_stat_diff had NR_ISOLATED_FILE as "-14".  So the
actual isolated count was zero.  As there weren't any more updates to
NR_ISOLATED_FILE and vmstat_update deffered work had not been scheduled
yet, 7 tasks were spinning in the congestion wait loop for around 4
seconds, in the direct reclaim path.

This patch uses zone_page_state_snapshot instead, but restricts its usage
to avoid performance penalty.


The vmstat sync interval is HZ (sysctl_stat_interval), but since the
vmstat_work is declared as a deferrable work, the timer trigger can be
deferred to the next non-defferable timer expiry on the CPU which is in
idle.  This results in the vmstat syncing on an idle CPU being delayed by
seconds.  May be in most cases this behavior is fine, except in cases like
this.

Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   56 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated
+++ a/mm/vmscan.c
@@ -1401,6 +1401,32 @@ int isolate_lru_page(struct page *page)
 	return ret;
 }
 
+static int __too_many_isolated(struct zone *zone, int file,
+	struct scan_control *sc, int safe)
+{
+	unsigned long inactive, isolated;
+
+	if (safe) {
+		inactive = zone_page_state_snapshot(zone,
+				NR_INACTIVE_ANON + 2 * file);
+		isolated = zone_page_state_snapshot(zone,
+				NR_ISOLATED_ANON + file);
+	} else {
+		inactive = zone_page_state(zone, NR_INACTIVE_ANON + 2 * file);
+		isolated = zone_page_state(zone, NR_ISOLATED_ANON + file);
+	}
+
+	/*
+	 * GFP_NOIO/GFP_NOFS callers are allowed to isolate more pages, so they
+	 * won't get blocked by normal direct-reclaimers, forming a circular
+	 * deadlock.
+	 */
+	if ((sc->gfp_mask & GFP_IOFS) == GFP_IOFS)
+		inactive >>= 3;
+
+	return isolated > inactive;
+}
+
 /*
  * A direct reclaimer may isolate SWAP_CLUSTER_MAX pages from the LRU list and
  * then get resheduled. When there are massive number of tasks doing page
@@ -1409,33 +1435,22 @@ int isolate_lru_page(struct page *page)
  * unnecessary swapping, thrashing and OOM.
  */
 static int too_many_isolated(struct zone *zone, int file,
-		struct scan_control *sc)
+		struct scan_control *sc, int safe)
 {
-	unsigned long inactive, isolated;
-
 	if (current_is_kswapd())
 		return 0;
 
 	if (!global_reclaim(sc))
 		return 0;
 
-	if (file) {
-		inactive = zone_page_state(zone, NR_INACTIVE_FILE);
-		isolated = zone_page_state(zone, NR_ISOLATED_FILE);
-	} else {
-		inactive = zone_page_state(zone, NR_INACTIVE_ANON);
-		isolated = zone_page_state(zone, NR_ISOLATED_ANON);
+	if (unlikely(__too_many_isolated(zone, file, sc, 0))) {
+		if (safe)
+			return __too_many_isolated(zone, file, sc, safe);
+		else
+			return 1;
 	}
 
-	/*
-	 * GFP_NOIO/GFP_NOFS callers are allowed to isolate more pages, so they
-	 * won't get blocked by normal direct-reclaimers, forming a circular
-	 * deadlock.
-	 */
-	if ((sc->gfp_mask & GFP_IOFS) == GFP_IOFS)
-		inactive >>= 3;
-
-	return isolated > inactive;
+	return 0;
 }
 
 static noinline_for_stack void
@@ -1525,15 +1540,18 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_immediate = 0;
 	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
+	int safe = 0;
 	struct zone *zone = lruvec_zone(lruvec);
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 
-	while (unlikely(too_many_isolated(zone, file, sc))) {
+	while (unlikely(too_many_isolated(zone, file, sc, safe))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/* We are about to die and free our memory. Return now. */
 		if (fatal_signal_pending(current))
 			return SWAP_CLUSTER_MAX;
+
+		safe = 1;
 	}
 
 	lru_add_drain();
_

Patches currently in -mm which might be from vinmenon@codeaurora.org are

mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch

