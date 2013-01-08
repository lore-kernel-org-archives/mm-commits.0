From: akpm@linux-foundation.org
Subject: + mm-avoid-calling-pgdat_balanced-needlessly.patch added to -mm tree
Date: Tue, 08 Jan 2013 14:56:08 -0800
Message-ID: <20130108225609.232A1200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:53306 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3AHW4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 17:56:12 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so70842fae.1
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 14:56:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zlatko.calusic@iskon.hr, hughd@google.com, mgorman@suse.de, minchan.kim@gmail.com


The patch titled
     Subject: mm: avoid calling pgdat_balanced() needlessly
has been added to the -mm tree.  Its filename is
     mm-avoid-calling-pgdat_balanced-needlessly.patch

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
Subject: mm: avoid calling pgdat_balanced() needlessly

Now that balance_pgdat() is slightly tidied up, thanks to more capable
pgdat_balanced(), it's become obvious that pgdat_balanced() is called to
check the status, then break the loop if pgdat is balanced, just to be
immediately called again.  The second call is completely unnecessary, of
course.

The patch introduces pgdat_is_balanced boolean, which helps resolve the
above suboptimal behavior, with the added benefit of slightly better
documenting one other place in the function where we jump and skip lots of
code.

Signed-off-by: Zlatko Calusic <zlatko.calusic@iskon.hr>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~mm-avoid-calling-pgdat_balanced-needlessly mm/vmscan.c
--- a/mm/vmscan.c~mm-avoid-calling-pgdat_balanced-needlessly
+++ a/mm/vmscan.c
@@ -2627,6 +2627,7 @@ static bool prepare_kswapd_sleep(pg_data
 static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
 							int *classzone_idx)
 {
+	bool pgdat_is_balanced = false;
 	struct zone *unbalanced_zone;
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
@@ -2701,8 +2702,11 @@ loop_again:
 				zone_clear_flag(zone, ZONE_CONGESTED);
 			}
 		}
-		if (i < 0)
+
+		if (i < 0) {
+			pgdat_is_balanced = true;
 			goto out;
+		}
 
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
@@ -2829,8 +2833,11 @@ loop_again:
 				pfmemalloc_watermark_ok(pgdat))
 			wake_up(&pgdat->pfmemalloc_wait);
 
-		if (pgdat_balanced(pgdat, order, *classzone_idx))
+		if (pgdat_balanced(pgdat, order, *classzone_idx)) {
+			pgdat_is_balanced = true;
 			break;		/* kswapd: all done */
+		}
+
 		/*
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
@@ -2851,9 +2858,9 @@ loop_again:
 		if (sc.nr_reclaimed >= SWAP_CLUSTER_MAX)
 			break;
 	} while (--sc.priority >= 0);
-out:
 
-	if (!pgdat_balanced(pgdat, order, *classzone_idx)) {
+out:
+	if (!pgdat_is_balanced) {
 		cond_resched();
 
 		try_to_freeze();
_

Patches currently in -mm which might be from zlatko.calusic@iskon.hr are

mm-avoid-calling-pgdat_balanced-needlessly.patch

