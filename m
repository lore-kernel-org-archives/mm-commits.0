From: akpm@linux-foundation.org
Subject: - readahead-context-based-method-remove-readahead_ratio.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:47:26 -0800
Message-ID: <200703060147.l261lRYL008307@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46009 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933827AbXCFBrf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:47:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: context based method: remove readahead_ratio
has been removed from the -mm tree.  Its filename was
     readahead-context-based-method-remove-readahead_ratio.patch

This patch was dropped because it was folded into readahead-context-based-method.patch

------------------------------------------------------
Subject: readahead: context based method: remove readahead_ratio
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

The context based readahead is pretty conservative by nature,
so do not apply readahead_ratio here.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/readahead.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/readahead.c~readahead-context-based-method-remove-readahead_ratio mm/readahead.c
--- a/mm/readahead.c~readahead-context-based-method-remove-readahead_ratio
+++ a/mm/readahead.c
@@ -1244,9 +1244,7 @@ static unsigned long count_history_pages
 	 * Check the far pages coarsely.
 	 * The enlarged count will contribute to the look-ahead size.
 	 */
-	lookback = ra_max * (LOOKAHEAD_RATIO + 1) *
-						100 / (readahead_ratio | 1);
-
+	lookback = ra_max * LOOKAHEAD_RATIO;
 	for (count += ra_max; count < lookback; count += ra_max)
 		if (!__probe_page(mapping, offset - count))
 			break;
@@ -1392,7 +1390,8 @@ has_history_pages:
 		adjust_rala_aggressive(ra_max, &ra_size, &la_size);
 		ra_set_class(ra, RA_CLASS_CONTEXT_AGGRESSIVE);
 	} else {
-		ra_size = max(ra_min, ra_size * readahead_ratio / 100);
+		if (ra_size < ra_min)
+		    ra_size = ra_min;
 		if (!adjust_rala(ra_max, &ra_size, &la_size))
 			return -1;
 		ra_set_class(ra, RA_CLASS_CONTEXT);
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
readahead-context-based-method.patch
readahead-context-based-method-remove-readahead_ratio.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method-user-recommended-size-rename-to-read_ahead_initial_kb.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-fix.patch
readahead-call-scheme.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-call-scheme-remove-get_readahead_bounds.patch
readahead-call-scheme-fix-thrashed-unaligned-read.patch
readahead-laptop-mode.patch
readahead-laptop-mode-fix.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
readahead-nfsd-case-fix-uninitialized-ra_min-ra_max.patch
readahead-nfsd-case-remove-ra_min.patch
readahead-turn-on-by-default.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
