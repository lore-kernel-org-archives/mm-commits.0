From: akpm@linux-foundation.org
Subject: [merged] vmscan-minor-cleanup-for-kswapd.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:49 -0700
Message-ID: <20130430184449.6FFCA31C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:45322 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751Ab3D3Sou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:50 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so75326ves.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: minor cleanup for kswapd
has been removed from the -mm tree.  Its filename was
     vmscan-minor-cleanup-for-kswapd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm/vmscan.c: minor cleanup for kswapd

Local variable total_scanned is no longer used.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/vmscan.c~vmscan-minor-cleanup-for-kswapd mm/vmscan.c
--- a/mm/vmscan.c~vmscan-minor-cleanup-for-kswapd
+++ a/mm/vmscan.c
@@ -2619,7 +2619,6 @@ static unsigned long balance_pgdat(pg_da
 	bool pgdat_is_balanced = false;
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
-	unsigned long total_scanned;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
@@ -2639,7 +2638,6 @@ static unsigned long balance_pgdat(pg_da
 		.gfp_mask = sc.gfp_mask,
 	};
 loop_again:
-	total_scanned = 0;
 	sc.priority = DEF_PRIORITY;
 	sc.nr_reclaimed = 0;
 	sc.may_writepage = !laptop_mode;
@@ -2730,7 +2728,6 @@ loop_again:
 							order, sc.gfp_mask,
 							&nr_soft_scanned);
 			sc.nr_reclaimed += nr_soft_reclaimed;
-			total_scanned += nr_soft_scanned;
 
 			/*
 			 * We put equal pressure on every zone, unless
@@ -2765,7 +2762,6 @@ loop_again:
 				reclaim_state->reclaimed_slab = 0;
 				nr_slab = shrink_slab(&shrink, sc.nr_scanned, lru_pages);
 				sc.nr_reclaimed += reclaim_state->reclaimed_slab;
-				total_scanned += sc.nr_scanned;
 
 				if (nr_slab == 0 && !zone_reclaimable(zone))
 					zone->all_unreclaimable = 1;
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch

