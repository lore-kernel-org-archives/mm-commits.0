From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:45 -0700
Message-ID: <53e3dbdd.pf1CtrYWeVrok+01%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:57652 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaHGUEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:46 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so608994qaq.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, Kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: remove remains of kswapd-managed zone->all_unreclaimable
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: remove remains of kswapd-managed zone->all_unreclaimable

shrink_zones() has a special branch to skip the all_unreclaimable() check
during hibernation, because a frozen kswapd can't mark a zone
unreclaimable.

But ever since 6e543d5780e3 ("mm: vmscan: fix do_try_to_free_pages()
livelock"), determining a zone to be unreclaimable is done by directly
looking at its scan history and no longer relies on kswapd setting the
per-zone flag.

Remove this branch and let shrink_zones() check the reclaimability of the
target zones regardless of hibernation state.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <Kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable
+++ a/mm/vmscan.c
@@ -2534,14 +2534,6 @@ out:
 	if (sc->nr_reclaimed)
 		return sc->nr_reclaimed;
 
-	/*
-	 * As hibernation is going on, kswapd is freezed so that it can't mark
-	 * the zone into all_unreclaimable. Thus bypassing all_unreclaimable
-	 * check.
-	 */
-	if (oom_killer_disabled)
-		return 0;
