From: akpm@linux-foundation.org
Subject: + vmscan-check-all_unreclaimable-in-direct-reclaim-path-v2.patch added to -mm tree
Date: Tue, 14 Sep 2010 12:50:03 -0700
Message-ID: <201009141950.o8EJo3pV014849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648Ab0INTuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 15:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, bicave@superonline.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, rjw@sisk.pl, stable@kernel.org


The patch titled
     vmscan-check-all_unreclaimable-in-direct-reclaim-path-v2
has been added to the -mm tree.  Its filename is
     vmscan-check-all_unreclaimable-in-direct-reclaim-path-v2.patch

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
Subject: vmscan-check-all_unreclaimable-in-direct-reclaim-path-v2
From: Minchan Kim <minchan.kim@gmail.com>

   * remove inline - suggested by Andrew
   * add function desription - suggeseted by Adnrew

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: M. Vefa Bicakci <bicave@superonline.com>
Cc: <stable@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-check-all_unreclaimable-in-direct-reclaim-path-v2 mm/vmscan.c
--- a/mm/vmscan.c~vmscan-check-all_unreclaimable-in-direct-reclaim-path-v2
+++ a/mm/vmscan.c
@@ -1829,12 +1829,17 @@ static void shrink_zones(int priority, s
 	}
 }
 
-static inline bool zone_reclaimable(struct zone *zone)
+static bool zone_reclaimable(struct zone *zone)
 {
 	return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
 }
 
-static inline bool all_unreclaimable(struct zonelist *zonelist,
+/*
+ * As hibernation is going on, kswapd is freezed so that it can't mark
+ * the zone into all_unreclaimable. It can't handle OOM during hibernation.
+ * So let's check zone's unreclaimable in direct reclaim as well as kswapd.
+ */
+static bool all_unreclaimable(struct zonelist *zonelist,
 		struct scan_control *sc)
 {
 	struct zoneref *z;
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks.patch
vmscan-check-all_unreclaimable-in-direct-reclaim-path.patch
vmscan-check-all_unreclaimable-in-direct-reclaim-path-v2.patch
mm-vmap-area-cache.patch
mm-compaction-fix-compactpagefailed-counting.patch
vmscan-prevent-background-aging-of-anon-page-in-no-swap-system.patch

