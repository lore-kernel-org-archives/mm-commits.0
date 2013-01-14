From: akpm@linux-foundation.org
Subject: + mm-dont-wait-on-congested-zones-in-balance_pgdat.patch added to -mm tree
Date: Mon, 14 Jan 2013 13:45:55 -0800
Message-ID: <20130114214555.C8A07100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:37402 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267Ab3ANVp5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 16:45:57 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so304794qad.4
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 13:45:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zlatko.calusic@iskon.hr, jweiner@redhat.com, mgorman@suse.de, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     Subject: mm: don't wait on congested zones in balance_pgdat()
has been added to the -mm tree.  Its filename is
     mm-dont-wait-on-congested-zones-in-balance_pgdat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Subject: mm: don't wait on congested zones in balance_pgdat()


Commit 92df3a72 (mm: vmscan: throttle reclaim if encountering too many
dirty pages under writeback) introduced waiting on congested zones
based on a sane algorithm in shrink_inactive_list(). What this means
is that there's no more need for throttling and additional heuristics
in balance_pgdat(). So, let's remove it and tidy up the code.

Signed-off-by: Zlatko Calusic <zlatko.calusic@iskon.hr>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    1 -
 mm/vmscan.c                   |   29 +----------------------------
 mm/vmstat.c                   |    1 -
 3 files changed, 1 insertion(+), 30 deletions(-)

diff -puN include/linux/vm_event_item.h~mm-dont-wait-on-congested-zones-in-balance_pgdat include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-dont-wait-on-congested-zones-in-balance_pgdat
+++ a/include/linux/vm_event_item.h
@@ -36,7 +36,6 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #endif
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_INODESTEAL,
 		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
-		KSWAPD_SKIP_CONGESTION_WAIT,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
 #ifdef CONFIG_NUMA_BALANCING
 		NUMA_PTE_UPDATES,
diff -puN mm/vmscan.c~mm-dont-wait-on-congested-zones-in-balance_pgdat mm/vmscan.c
--- a/mm/vmscan.c~mm-dont-wait-on-congested-zones-in-balance_pgdat
+++ a/mm/vmscan.c
@@ -2617,7 +2617,6 @@ static unsigned long balance_pgdat(pg_da
 							int *classzone_idx)
 {
 	bool pgdat_is_balanced = false;
-	struct zone *unbalanced_zone;
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
 	unsigned long total_scanned;
@@ -2648,9 +2647,6 @@ loop_again:
 
 	do {
 		unsigned long lru_pages = 0;
-		int has_under_min_watermark_zone = 0;
-
-		unbalanced_zone = NULL;
 
 		/*
 		 * Scan in the highmem->dma direction for the highest
@@ -2790,17 +2786,7 @@ loop_again:
 				continue;
 			}
 
-			if (!zone_balanced(zone, testorder, 0, end_zone)) {
-				unbalanced_zone = zone;
-				/*
-				 * We are still under min water mark.  This
-				 * means that we have a GFP_ATOMIC allocation
-				 * failure risk. Hurry up!
-				 */
-				if (!zone_watermark_ok_safe(zone, order,
-					    min_wmark_pages(zone), end_zone, 0))
-					has_under_min_watermark_zone = 1;
-			} else {
+			if (zone_balanced(zone, testorder, 0, end_zone))
 				/*
 				 * If a zone reaches its high watermark,
 				 * consider it to be no longer congested. It's
@@ -2809,8 +2795,6 @@ loop_again:
 				 * speculatively avoid congestion waits
 				 */
 				zone_clear_flag(zone, ZONE_CONGESTED);
-			}
-
 		}
 
 		/*
@@ -2828,17 +2812,6 @@ loop_again:
 		}
 
 		/*
-		 * OK, kswapd is getting into trouble.  Take a nap, then take
-		 * another pass across the zones.
-		 */
-		if (total_scanned && (sc.priority < DEF_PRIORITY - 2)) {
-			if (has_under_min_watermark_zone)
-				count_vm_event(KSWAPD_SKIP_CONGESTION_WAIT);
-			else if (unbalanced_zone)
-				wait_iff_congested(unbalanced_zone, BLK_RW_ASYNC, HZ/10);
-		}
