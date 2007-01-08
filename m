From: akpm@osdl.org
Subject: + readahead-context-based-method-remove-readahead_ratio.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:17:07 -0800
Message-ID: <200701082217.l08MH70V020533@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48046 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030283AbXAHWRM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:17:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: context based method: remove readahead_ratio
has been added to the -mm tree.  Its filename is
     readahead-context-based-method-remove-readahead_ratio.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1236,9 +1236,7 @@ static unsigned long count_history_pages
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
@@ -1384,7 +1382,8 @@ has_history_pages:
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
readahead-kconfig-options-fix.patch
radixtree-introduce-scan-hole-data-functions.patch
mm-introduce-probe_page.patch
mm-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-insert-cond_resched-calls.patch
readahead-minmax_ra_pages.patch
readahead-events-accounting.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
readahead-rescue_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-sysctl-parameters-fix.patch
readahead-sysctl-parameters-set-readahead_hit_rate=1.patch
readahead-min-max-sizes.patch
readahead-min-max-sizes-remove-get_readahead_bounds.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-context-based-method.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-context-based-method-update-ra_min.patch
readahead-context-based-method-remove-readahead_ratio.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-call-scheme.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-call-scheme-remove-get_readahead_bounds.patch
readahead-laptop-mode.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
readahead-nfsd-case-fix-uninitialized-ra_min-ra_max.patch
readahead-nfsd-case-remove-ra_min.patch
readahead-turn-on-by-default.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
