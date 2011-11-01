From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:08:36 -0700
Message-ID: <201111012108.pA1L8aZO006940@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28747 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab1KAVJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:09:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, minchan.kim@gmail.com, nishimura@mxp.nes.nec.


The patch titled
     Subject: mm: vmscan: drop nr_force_scan[] from get_scan_count
has been removed from the -mm tree.  Its filename was
     mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: vmscan: drop nr_force_scan[] from get_scan_count

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
@@ -1817,12 +1817,19 @@ static void get_scan_count(struct zone *
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
 
@@ -1832,8 +1839,6 @@ static void get_scan_count(struct zone *
 		fraction[0] = 0;
 		fraction[1] = 1;
 		denominator = 1;
-		nr_force_scan[0] = 0;
-		nr_force_scan[1] = SWAP_CLUSTER_MAX;
 		goto out;
 	}
 
@@ -1850,8 +1855,6 @@ static void get_scan_count(struct zone *
 			fraction[0] = 1;
 			fraction[1] = 0;
 			denominator = 1;
-			nr_force_scan[0] = SWAP_CLUSTER_MAX;
-			nr_force_scan[1] = 0;
 			goto out;
 		}
 	}
@@ -1900,11 +1903,6 @@ static void get_scan_count(struct zone *
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
@@ -1913,20 +1911,10 @@ out:
 		scan = zone_nr_lru_pages(zone, sc, l);
 		if (priority || noswap) {
 			scan >>= priority;
+			if (!scan && force_scan)
+				scan = SWAP_CLUSTER_MAX;
 			scan = div64_u64(scan * fraction[file], denominator);
 		}
-
-		/*
-		 * If zone is small or memcg is small, nr[l] can be 0.
-		 * This results no-scan on this priority and priority drop down.
-		 * For global direct reclaim, it can visit next zone and tend
-		 * not to have problems. For global kswapd, it's for zone
-		 * balancing and it need to scan a small amounts. When using
-		 * memcg, priority drop can cause big latency. So, it's better
-		 * to scan small amount. See may_noscan above.
-		 */
-		if (!scan && force_scan)
-			scan = nr_force_scan[file];
 		nr[l] = scan;
 	}
 }
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch
memcg-close-race-between-charge-and-putback.patch

