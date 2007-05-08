From: akpm@linux-foundation.org
Subject: - readahead-remove-parameter-ra_max-from-adjust_rala.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:33 -0700
Message-ID: <200705080815.l488FXKw019059@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934647AbXEHIQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:16:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: remove parameter ra_max from adjust_rala*()
has been removed from the -mm tree.  Its filename was
     readahead-remove-parameter-ra_max-from-adjust_rala.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: remove parameter ra_max from adjust_rala*()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Remove the unused parameter @ra_max from adjust_rala() and
adjust_rala_aggressive().

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN mm/readahead.c~readahead-remove-parameter-ra_max-from-adjust_rala mm/readahead.c
--- a/mm/readahead.c~readahead-remove-parameter-ra_max-from-adjust_rala
+++ a/mm/readahead.c
@@ -1003,8 +1003,7 @@ static unsigned long ra_submit(struct fi
  *	- @ra_size stores the estimated thrashing-threshold.
  *	- @la_size stores the look-ahead size of previous request.
  */
-static int adjust_rala(unsigned long ra_max,
-			unsigned long *ra_size, unsigned long *la_size)
+static int adjust_rala(unsigned long *ra_size, unsigned long *la_size)
 {
 	/*
 	 * Cancel asynchrous read-ahead,
@@ -1146,15 +1145,15 @@ state_based_readahead(struct address_spa
 		goto cancel_lookahead;
 	}
 
+	if (!adjust_rala(&ra_size, &la_size))
+		goto cancel_lookahead;
+
 	growth_limit = req_size;
 	growth_limit += ra_max / 16;
 	growth_limit += 2 * ra_old;
 	if (growth_limit > ra_max)
 	    growth_limit = ra_max;
 
-	if (!adjust_rala(growth_limit, &ra_size, &la_size))
-		goto cancel_lookahead;
-
 	limit_rala(growth_limit, la_old, &ra_size, &la_size);
 
 	/* ra_size in its _steady_ state reflects thrashing threshold */
@@ -1348,8 +1347,8 @@ out_unlock:
  * which is safe: the tailing look-ahead part is 'unsafe'. However it will be
  * safeguarded by rescue_pages() when the previous chunks are lost.
  */
-static void adjust_rala_aggressive(unsigned long ra_max,
-				unsigned long *ra_size, unsigned long *la_size)
+static void adjust_rala_aggressive(unsigned long *ra_size,
+				   unsigned long *la_size)
 {
 	pgoff_t offset = *ra_size;
 
@@ -1466,12 +1465,12 @@ has_history_pages:
 
 	if (ra_size >= offset) {
 		ra_size = offset;
-		adjust_rala_aggressive(ra_max, &ra_size, &la_size);
+		adjust_rala_aggressive(&ra_size, &la_size);
 		ra_set_class(ra, RA_CLASS_CONTEXT_AGGRESSIVE);
 	} else {
 		if (ra_size < ra_min)
 		    ra_size = ra_min;
-		if (!adjust_rala(ra_max, &ra_size, &la_size))
+		if (!adjust_rala(&ra_size, &la_size))
 			return -1;
 		ra_set_class(ra, RA_CLASS_CONTEXT);
 	}
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-remove-parameter-ra_max-from-adjust_rala.patch
readahead-state-based-method-protect-against-tiny-size.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
