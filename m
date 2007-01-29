From: akpm@osdl.org
Subject: + readahead-thrashing-recovery-method-fix.patch added to -mm tree
Date: Mon, 29 Jan 2007 15:30:14 -0800
Message-ID: <200701292330.l0TNUENs002527@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33614 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964972AbXA2XaY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 18:30:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: thrashing recovery method fix
has been added to the -mm tree.  Its filename is
     readahead-thrashing-recovery-method-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: thrashing recovery method fix
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

- keep lookahead_index if the current chunk is lost, so that when we
  revisted this stream, the state based method see a consistent state.
- correct the thrashing-threshold computation
- discount read-ahead size more, to free more memory to the system on pressure
- disable look-ahead when thrashed, just to be safe

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/readahead.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff -puN mm/readahead.c~readahead-thrashing-recovery-method-fix mm/readahead.c
--- a/mm/readahead.c~readahead-thrashing-recovery-method-fix
+++ a/mm/readahead.c
@@ -1520,28 +1520,26 @@ thrashing_recovery_readahead(struct addr
 						ra->readahead_index - offset);
 #endif
 
-	/*
-	 * Some thrashing occur in (ra_index, la_index], in which case the
-	 * old read-ahead chunk is lost soon after the new one is allocated.
-	 * Ensure that we recover all needed pages in the old chunk.
-	 */
-	if (offset < ra->ra_index)
-		ra_size = ra->ra_index - offset;
-	else {
+	if (offset < ra->ra_index) {
+		/*
+		 * Thrashed when we are in [la_index, ra_index), i.e.
+		 * the old chunk is lost soon after the new one is allocated.
+		 * Ensure that we recover all needed pages in the old chunk.
+		 * And futher keep the lookahead_index untouched.
+		 */
+		ra_size = ra->lookahead_index - offset;
+	} else {
 		/* After thrashing, we know the exact thrashing-threshold. */
-		ra_size = offset - ra->ra_index;
+		ra_size = offset - ra->la_index;
 		update_ra_thrash_bytes(mapping->backing_dev_info, ra_size);
 
-		/* And we'd better be a bit conservative. */
-		ra_size = ra_size * 3 / 4;
+		/* And be cooperative: the system may be hunting for memory. */
+		ra_size = MIN_RA_PAGES + ra_size / 2;
 	}
 
-	if (ra_size > ra_max)
-		ra_size = ra_max;
-
 	ra_set_class(ra, RA_CLASS_THRASHING);
 	ra_set_index(ra, offset, offset);
-	ra_set_size(ra, ra_size, ra_size / LOOKAHEAD_RATIO);
+	ra_set_size(ra, ra_size, 0);
 
 	return ra_submit(ra, mapping, filp);
 }
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
