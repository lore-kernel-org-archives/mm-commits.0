From: akpm@linux-foundation.org
Subject: - readahead-state-based-method-protect-against-tiny-size.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:36 -0700
Message-ID: <200705080815.l488FaW3019062@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934646AbXEHIQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:16:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: state based method: protect against tiny size
has been removed from the -mm tree.  Its filename was
     readahead-state-based-method-protect-against-tiny-size.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: state based method: protect against tiny size
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Move the tiny I/O size protection code from limit_rala() to
state_based_readahead().

limit_rala() is also called by context based readahead, which has its own
minimal readahead size.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/readahead.c~readahead-state-based-method-protect-against-tiny-size mm/readahead.c
--- a/mm/readahead.c~readahead-state-based-method-protect-against-tiny-size
+++ a/mm/readahead.c
@@ -1034,13 +1034,6 @@ static void limit_rala(unsigned long ra_
 	unsigned long stream_shift;
 
 	/*
-	 * Protect against too small I/O sizes,
-	 * by mapping [0, 4*min] to [min, 4*min].
-	 */
-	if (*ra_size < 4 * MIN_RA_PAGES)
-		*ra_size = MIN_RA_PAGES + *ra_size * 3 / 4;
-
-	/*
 	 * Apply basic upper limits.
 	 */
 	if (*ra_size > ra_max)
@@ -1148,6 +1141,13 @@ state_based_readahead(struct address_spa
 	if (!adjust_rala(&ra_size, &la_size))
 		goto cancel_lookahead;
 
+	/*
+	 * Protect against too small I/O sizes,
+	 * by mapping [0, 4*min] to [min, 4*min].
+	 */
+	if (ra_size < 4 * MIN_RA_PAGES)
+		ra_size = MIN_RA_PAGES + ra_size * 3 / 4;
+
 	growth_limit = req_size;
 	growth_limit += ra_max / 16;
 	growth_limit += 2 * ra_old;
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-state-based-method-protect-against-tiny-size.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
