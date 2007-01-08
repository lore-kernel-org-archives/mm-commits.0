From: akpm@osdl.org
Subject: + readahead-context-based-method-update-ra_min.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:17:05 -0800
Message-ID: <200701082217.l08MH5Xa020528@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48045 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161026AbXAHWRM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:17:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: context based method: update ra_min
has been added to the -mm tree.  Its filename is
     readahead-context-based-method-update-ra_min.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: context based method: update ra_min
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Classify the 4 cases into 2 classes, and assign proper ra_min for them.
Also update comments correspondly.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/readahead.c |   49 +++++++++++++++++++++++++++++++----------------
 1 files changed, 33 insertions(+), 16 deletions(-)

diff -puN mm/readahead.c~readahead-context-based-method-update-ra_min mm/readahead.c
--- a/mm/readahead.c~readahead-context-based-method-update-ra_min
+++ a/mm/readahead.c
@@ -1285,17 +1285,26 @@ static int
 try_context_based_readahead(struct address_space *mapping,
 			struct file_ra_state *ra,
 			struct page *page, pgoff_t offset,
-			unsigned long ra_min, unsigned long ra_max)
+			unsigned long req_size, unsigned long ra_max)
 {
 	pgoff_t start;
+	unsigned long ra_min;
 	unsigned long ra_size;
 	unsigned long la_size;
 
-	/* Check if there is a segment of history pages, and its end index.
+	/*
+	 * Check if there is a segment of history pages, and its end index.
 	 * Based on which we decide whether and where to start read-ahead.
-	 *
-	 * Case 1: we have a current page.
-	 * 	   Search forward for a nearby hole.
+	 */
+
+	/*
+	 * Select a reasonable large initial size for sequential reads.
+	 */
+	ra_min = min(req_size * 4, mapping->backing_dev_info->ra_pages0);
+
+	/*
+	 * Case s1: we have a current page.
+	 * =======> Search forward for a nearby hole.
 	 */
 	read_lock_irq(&mapping->tree_lock);
 	if (page) {
@@ -1308,8 +1317,9 @@ try_context_based_readahead(struct addre
 		return -1;
 	}
 
-	/* Case 2: current page is missing; previous page is present.
-	 *         Just do read-ahead from the current index on.
+	/*
+	 * Case s2: current page is missing; previous page is present.
+	 * =======> Just do read-ahead from the current index on.
 	 * There's clear sign of sequential reading. It can be
 	 * 	a) seek => read => this read
 	 * 	b) cache hit read(s) => this read
@@ -1321,26 +1331,33 @@ try_context_based_readahead(struct addre
 		goto has_history_pages;
 	}
 
-	/* Case 2x: the same context info as 2.
-	 * It can be the early stage of semi-sequential reads(interleaved/nfsd),
-	 * or an ugly random one.  So be conservative.
+	/*
+	 * Not an obvious sequential read:
+	 * select a conservative initial size, plus user prefered agressiveness.
+	 */
+	ra_min = min(req_size, MIN_RA_PAGES) +
+		 readahead_hit_rate * 8192 / PAGE_CACHE_SIZE;
+
+	/*
+	 * Case r1: the same context info as s2, but not that obvious.
+	 * =======> The same action as s2, but be conservative.
+	 * It can be the early stage of intermixed sequential reads,
+	 * or an ugly random one.
 	 */
 	if (readahead_hit_rate && __probe_page(mapping, offset - 1)) {
 		start = offset;
-		if (ra_min > 2 * readahead_hit_rate)
-		    ra_min = 2 * readahead_hit_rate;
 		goto has_history_pages;
 	}
 
-	/* Case 3: no current/previous pages;
-	 *         sparse read-ahead is enabled: ok, be aggressive.
-	 *         Check if there's any adjecent history pages.
+	/*
+	 * Case r2: no current/previous pages; sparse read-ahead is enabled.
+	 * =======> Do sparse read-ahead if there are adjecent history pages.
 	 */
 	if (readahead_hit_rate > 1) {
 		start = radix_tree_scan_data_backward(&mapping->page_tree,
 							       offset, ra_min);
 		if (start != ULONG_MAX && offset - start < ra_min) {
-			ra_min += offset - start;
+			ra_min *= 2;
 			offset = ++start; /* pretend the request starts here */
 			goto has_history_pages;
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
