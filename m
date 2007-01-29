From: akpm@osdl.org
Subject: + readahead-state-based-method-prevent-tiny-size.patch added to -mm tree
Date: Mon, 29 Jan 2007 15:30:00 -0800
Message-ID: <200701292330.l0TNU0Lg002489@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33571 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964930AbXA2XaH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 18:30:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: state based method: prevent tiny size
has been added to the -mm tree.  Its filename is
     readahead-state-based-method-prevent-tiny-size.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: state based method: prevent tiny size
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

- cancel look-ahead if readahead size is small compared to the look-ahead size,
  to avoid too small I/O size, and not to add more memory/io pressure on the
  possibly loaded system.
- prevent issuing tiny readahead size, by applying a minimal limit

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/readahead.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff -puN mm/readahead.c~readahead-state-based-method-prevent-tiny-size mm/readahead.c
--- a/mm/readahead.c~readahead-state-based-method-prevent-tiny-size
+++ a/mm/readahead.c
@@ -928,17 +928,21 @@ static int adjust_rala(unsigned long ra_
 			unsigned long *ra_size, unsigned long *la_size)
 {
 	/*
-	 * Substract the old look-ahead to get real safe size for the next
-	 * read-ahead request.
+	 * Cancel asynchrous read-ahead,
+	 * if there is a major upsurge of load, or fall of this stream's speed.
 	 */
-	if (*ra_size > *la_size)
-		*ra_size -= *la_size;
-	else {
+	if (*ra_size <= *la_size * 2) {
 		ra_account(NULL, RA_EVENT_READAHEAD_SHRINK, *ra_size);
 		return 0;
 	}
 
 	/*
+	 * Substract the old look-ahead to get real safe size for the next
+	 * read-ahead request.
+	 */
+	*ra_size -= *la_size;
+
+	/*
 	 * Set new la_size according to the (still large) ra_size.
 	 */
 	*la_size = *ra_size / LOOKAHEAD_RATIO;
@@ -952,6 +956,13 @@ static void limit_rala(unsigned long ra_
 	unsigned long stream_shift;
 
 	/*
+	 * Protect against too small I/O sizes,
+	 * by mapping [0, 4*min] to [min, 4*min].
+	 */
+	if (*ra_size < 4 * MIN_RA_PAGES)
+		*ra_size = MIN_RA_PAGES + *ra_size * 3 / 4;
+
+	/*
 	 * Apply basic upper limits.
 	 */
 	if (*ra_size > ra_max)
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
readahead-min-max-sizes-increase-vm_min_readahead-to-32kb.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method-routines-explicitly-embed-class_new-class_old-inside-flags.patch
readahead-state-based-method.patch
readahead-state-based-method-prevent-tiny-size.patch
readahead-state-based-method-move-readahead_ratio-out-of-compute_thrashing_threshold.patch
readahead-context-based-method.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-context-based-method-update-ra_min.patch
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
