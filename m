From: akpm@linux-foundation.org
Subject: + readahead-remove-parameter-ra_max-from-adjust_rala.patch added to -mm tree
Date: Sat, 17 Mar 2007 23:49:57 -0800
Message-ID: <200703180749.l2I7nvOq018359@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58690 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbXCRHuG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:50:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: remove parameter ra_max from adjust_rala*()
has been added to the -mm tree.  Its filename is
     readahead-remove-parameter-ra_max-from-adjust_rala.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1000,8 +1000,7 @@ static unsigned long ra_submit(struct fi
  *	- @ra_size stores the estimated thrashing-threshold.
  *	- @la_size stores the look-ahead size of previous request.
  */
-static int adjust_rala(unsigned long ra_max,
-			unsigned long *ra_size, unsigned long *la_size)
+static int adjust_rala(unsigned long *ra_size, unsigned long *la_size)
 {
 	/*
 	 * Cancel asynchrous read-ahead,
@@ -1143,15 +1142,15 @@ state_based_readahead(struct address_spa
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
@@ -1345,8 +1344,8 @@ out_unlock:
  * which is safe: the tailing look-ahead part is 'unsafe'. However it will be
  * safeguarded by rescue_pages() when the previous chunks are lost.
  */
-static void adjust_rala_aggressive(unsigned long ra_max,
-				unsigned long *ra_size, unsigned long *la_size)
+static void adjust_rala_aggressive(unsigned long *ra_size,
+				   unsigned long *la_size)
 {
 	pgoff_t offset = *ra_size;
 
@@ -1463,12 +1462,12 @@ has_history_pages:
 
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

readahead-kconfig-options.patch
radixtree-introduce-scan-hole-data-functions.patch
mm-introduce-probe_page.patch
mm-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-insert-cond_resched-calls.patch
readahead-minmax_ra_pages.patch
readahead-events-accounting.patch
readahead-rescue_pages.patch
readahead-sysctl-parameters.patch
readahead-min-max-sizes.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-state-based-method-check-node-id.patch
readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch
readahead-state-based-method-cancel-lookahead-gracefully.patch
readahead-context-based-method.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-check-unbalanced-aging.patch
readahead-thrashing-recovery-method-refill-holes.patch
readahead-call-scheme.patch
readahead-call-scheme-cleanup.patch
readahead-call-scheme-catch-thrashing-on-lookahead-time.patch
readahead-laptop-mode.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
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
