From: akpm@linux-foundation.org
Subject: + mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch added to -mm tree
Date: Wed, 17 Aug 2011 15:22:51 -0700
Message-ID: <201108172222.p7HMMpiS032354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466Ab1HQWYC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 18:24:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, yinghan@google.com


The patch titled
     mm: vmscan: drop nr_force_scan[] from get_scan_count
has been added to the -mm tree.  Its filename is
     mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch

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
Subject: mm: vmscan: drop nr_force_scan[] from get_scan_count
From: Johannes Weiner <jweiner@redhat.com>

The nr_force_scan[] tuple holds the effective scan numbers for anon and
file pages in case the situation called for a forced scan and the
regularly calculated scan numbers turned out zero.

However, the effective scan number can always be assumed to be
SWAP_CLUSTER_MAX right before the division into anon and file.  The
numerators and denominator are properly set up for all cases, be it force
scan for just file, just anon, or both, to do the right thing.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-drop-nr_force_scan-from-get_scan_count mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-drop-nr_force_scan-from-get_scan_count
+++ a/mm/vmscan.c
@@ -1831,12 +1831,19 @@ static void get_scan_count(struct zone *
 	enum lru_list l;
 	int noswap = 0;
 	bool force_scan = false;
-	unsigned long nr_force_scan[2];
 
-	/* kswapd does zone balancing and needs to scan this zone */
+	/*
+	 * If the zone or memcg is small, nr[l] can be 0.  This
+	 * results in no scanning on this priority and a potential
+	 * priority drop.  Global direct reclaim can go to the next
+	 * zone and tends to have no problems. Global kswapd is for
+	 * zone balancing and it needs to scan a minimum amount. When
+	 * reclaiming for a memcg, a priority drop can cause high
+	 * latencies, so it's better to scan a minimum amount there as
+	 * well.
+	 */
 	if (scanning_global_lru(sc) && current_is_kswapd())
 		force_scan = true;
-	/* memcg may have small limit and need to avoid priority drop */
 	if (!scanning_global_lru(sc))
 		force_scan = true;
 
@@ -1846,8 +1853,6 @@ static void get_scan_count(struct zone *
 		fraction[0] = 0;
 		fraction[1] = 1;
 		denominator = 1;
-		nr_force_scan[0] = 0;
-		nr_force_scan[1] = SWAP_CLUSTER_MAX;
 		goto out;
 	}
 
@@ -1864,8 +1869,6 @@ static void get_scan_count(struct zone *
 			fraction[0] = 1;
 			fraction[1] = 0;
 			denominator = 1;
-			nr_force_scan[0] = SWAP_CLUSTER_MAX;
-			nr_force_scan[1] = 0;
 			goto out;
 		}
 	}
@@ -1914,11 +1917,6 @@ static void get_scan_count(struct zone *
 	fraction[0] = ap;
 	fraction[1] = fp;
 	denominator = ap + fp + 1;
-	if (force_scan) {
-		unsigned long scan = SWAP_CLUSTER_MAX;
-		nr_force_scan[0] = div64_u64(scan * ap, denominator);
-		nr_force_scan[1] = div64_u64(scan * fp, denominator);
-	}
 out:
 	for_each_evictable_lru(l) {
 		int file = is_file_lru(l);
@@ -1927,20 +1925,10 @@ out:
 		scan = zone_nr_lru_pages(zone, sc, l);
 		if (priority || noswap) {
 			scan >>= priority;
+			if (!scan && force_scan)
+				scan = SWAP_CLUSTER_MAX;
 			scan = div64_u64(scan * fraction[file], denominator);
 		}
