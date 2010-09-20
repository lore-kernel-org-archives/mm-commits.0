From: akpm@linux-foundation.org
Subject: + vmscan-check-all_unreclaimable-in-direct-reclaim-path-fix.patch added to -mm tree
Date: Mon, 20 Sep 2010 11:51:31 -0700
Message-ID: <201009201851.o8KIpVEh006686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371Ab0ITSwY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Sep 2010 14:52:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, balbir@in.ibm.com, caiqian@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     Fix all_unreclaimable in memcg.
has been added to the -mm tree.  Its filename is
     vmscan-check-all_unreclaimable-in-direct-reclaim-path-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix all_unreclaimable in memcg.
From: Minchan Kim <minchan.kim@gmail.com>

vmscan-check-all_unreclaimable-in-direct-reclaim-path.patch has a problem.
 It changed old behavior of memcg.

When memory pressure in memcg is high, do_try_to_free_pages returns 0.  It
causes mem_cgroup_out_of_memory so that any process in mem group would be
killed.

But vmscan-check-all_unreclaimable-in-direct-reclaim-path.patch changed
the old behavior.  It returns 1 unconditionally regardless of considering
global reclaim or memcg relcaim.  It causes hang without triggering OOM in
case of memcg direct reclaim.

This patch fixes it.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reported-by: <caiqian@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/vmscan.c~vmscan-check-all_unreclaimable-in-direct-reclaim-path-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-check-all_unreclaimable-in-direct-reclaim-path-fix
+++ a/mm/vmscan.c
@@ -1846,9 +1846,6 @@ static bool all_unreclaimable(struct zon
 	struct zone *zone;
 	bool all_unreclaimable = true;
 
-	if (!scanning_global_lru(sc))
-		return false;
-
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 			gfp_zone(sc->gfp_mask), sc->nodemask) {
 		if (!populated_zone(zone))
@@ -1962,7 +1959,7 @@ out:
 		return sc->nr_reclaimed;
 
 	/* top priority shrink_zones still had more to do? don't OOM, then */
-	if (!all_unreclaimable(zonelist, sc))
+	if (scanning_global_lru(sc) && !all_unreclaimable(zonelist, sc))
 		return 1;
 
 	return 0;
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks.patch
vmscan-check-all_unreclaimable-in-direct-reclaim-path.patch
vmscan-check-all_unreclaimable-in-direct-reclaim-path-v2.patch
vmscan-check-all_unreclaimable-in-direct-reclaim-path-fix.patch
mm-vmap-area-cache.patch
mm-compaction-fix-compactpagefailed-counting.patch
vmscan-prevent-background-aging-of-anon-page-in-no-swap-system.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
vmscantmpfs-treat-used-once-pages-on-tmpfs-as-used-once.patch

