From: akpm@linux-foundation.org
Subject: + vmscan-minor-cleanup-for-kswapd.patch added to -mm tree
Date: Mon, 11 Mar 2013 16:14:06 -0700
Message-ID: <20130311231406.689BC31C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:63071 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3CKXOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 19:14:07 -0400
Received: by mail-ye0-f201.google.com with SMTP id m12so441383yen.2
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 16:14:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com


The patch titled
     Subject: mm/vmscan.c: minor cleanup for kswapd
has been added to the -mm tree.  Its filename is
     vmscan-minor-cleanup-for-kswapd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm/vmscan.c: minor cleanup for kswapd

Local variable total_scanned is no longer used.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
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

rmap-recompute-pgoff-for-unmapping-huge-page.patch
vmscan-minor-cleanup-for-kswapd.patch

