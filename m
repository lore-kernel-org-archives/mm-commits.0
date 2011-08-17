From: akpm@linux-foundation.org
Subject: + mm-vmscan-fix-force-scanning-small-targets-without-swap.patch added to -mm tree
Date: Wed, 17 Aug 2011 15:22:45 -0700
Message-ID: <201108172222.p7HMMjA3032348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638Ab1HQWYC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 18:24:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.com


The patch titled
     mm: vmscan: fix force-scanning small targets without swap
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-force-scanning-small-targets-without-swap.patch

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
Subject: mm: vmscan: fix force-scanning small targets without swap
From: Johannes Weiner <jweiner@redhat.com>

Without swap, anonymous pages are not scanned.  As such, they should not
count when considering force-scanning a small target if there is no swap.

Otherwise, targets are not force-scanned even when their effective scan
number is zero and the other conditions--kswapd/memcg--apply.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Mel Gorman <mel@csn.ul.ie>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-force-scanning-small-targets-without-swap mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-force-scanning-small-targets-without-swap
+++ a/mm/vmscan.c
@@ -1830,23 +1830,15 @@ static void get_scan_count(struct zone *
 	u64 fraction[2], denominator;
 	enum lru_list l;
 	int noswap = 0;
-	int force_scan = 0;
+	bool force_scan = false;
 	unsigned long nr_force_scan[2];
 
-
-	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
-		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
-	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
-		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
-
-	if (((anon + file) >> priority) < SWAP_CLUSTER_MAX) {
-		/* kswapd does zone balancing and need to scan this zone */
-		if (scanning_global_lru(sc) && current_is_kswapd())
-			force_scan = 1;
-		/* memcg may have small limit and need to avoid priority drop */
-		if (!scanning_global_lru(sc))
-			force_scan = 1;
-	}
+	/* kswapd does zone balancing and need to scan this zone */
+	if (scanning_global_lru(sc) && current_is_kswapd())
+		force_scan = true;
+	/* memcg may have small limit and need to avoid priority drop */
+	if (!scanning_global_lru(sc))
+		force_scan = true;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (!sc->may_swap || (nr_swap_pages <= 0)) {
@@ -1859,6 +1851,11 @@ static void get_scan_count(struct zone *
 		goto out;
 	}
 
+	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
+		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
+	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
+		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
+
 	if (scanning_global_lru(sc)) {
 		free  = zone_page_state(zone, NR_FREE_PAGES);
 		/* If we have very few page cache pages,
_

Patches currently in -mm which might be from jweiner@redhat.com are

memcg-pin-execution-to-current-cpu-while-draining-stock.patch
linux-next.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch

