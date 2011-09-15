From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-fix-force-scanning-small-targets-without-swap.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:36:21 -0700
Message-ID: <201109151936.p8FJaLqY010397@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:14200 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab1IOTht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.c


The patch titled
     mm: vmscan: fix force-scanning small targets without swap
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-force-scanning-small-targets-without-swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmscan: fix force-scanning small targets without swap
From: Johannes Weiner <jweiner@redhat.com>

Without swap, anonymous pages are not scanned.  As such, they should not
count when considering force-scanning a small target if there is no swap.

Otherwise, targets are not force-scanned even when their effective scan
number is zero and the other conditions--kswapd/memcg--apply.

This fixes 246e87a ("memcg: fix get_scan_count() for small targets").

[akpm@linux-foundation.org: fix comment]
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
@@ -1808,23 +1808,15 @@ static void get_scan_count(struct zone *
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
+	/* kswapd does zone balancing and needs to scan this zone */
+	if (scanning_global_lru(sc) && current_is_kswapd())
+		force_scan = true;
+	/* memcg may have small limit and need to avoid priority drop */
+	if (!scanning_global_lru(sc))
+		force_scan = true;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (!sc->may_swap || (nr_swap_pages <= 0)) {
@@ -1837,6 +1829,11 @@ static void get_scan_count(struct zone *
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

origin.patch
mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch
mm-page-writebackc-document-bdi_min_ratio.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-compaction-compact-unevictable-pages.patch
mm-compaction-accounting-fix.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch
memcg-close-race-between-charge-and-putback.patch

