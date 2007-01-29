From: akpm@osdl.org
Subject: + readahead-laptop-mode-fix.patch added to -mm tree
Date: Mon, 29 Jan 2007 15:30:20 -0800
Message-ID: <200701292330.l0TNUKLx002534@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33615 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964981AbXA2XaY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 18:30:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: laptop mode fix
has been added to the -mm tree.  Its filename is
     readahead-laptop-mode-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: laptop mode fix
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

1) make LAPTOP_POLL_INTERVAL independent of page size

2) defer readahead to the _last_ minute

There's no luck for the kernel to know the right time of
waking up the disk in order to hide the spin up latency.

So we make the rule simple:
- The kernel ensures _longest_ spin down time;
- The media player caches enough data to hide the spin up delay.

That means, if one enabled laptop mode, and want to watch movies
without pauses, he should setup proper media player cache as well.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/readahead.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff -puN mm/readahead.c~readahead-laptop-mode-fix mm/readahead.c
--- a/mm/readahead.c~readahead-laptop-mode-fix
+++ a/mm/readahead.c
@@ -37,7 +37,7 @@
 #define INITIAL_RA_PAGES  DIV_ROUND_UP(64*1024, PAGE_CACHE_SIZE)
 
 /* In laptop mode, poll delayed look-ahead on every ## pages read. */
-#define LAPTOP_POLL_INTERVAL 16
+#define LAPTOP_POLL_INTERVAL	DIV_ROUND_UP(64*1024, PAGE_CACHE_SIZE)
 
 /* Set look-ahead size to 1/# of the thrashing-threshold. */
 #define LOOKAHEAD_RATIO 8
@@ -784,28 +784,22 @@ out:
 
 /*
  * Set a new look-ahead mark at @next.
- * Return 0 if the new mark is successfully set.
  */
-static int renew_lookahead(struct address_space *mapping,
+static void defer_lookahead(struct address_space *mapping,
 				struct file_ra_state *ra,
 				pgoff_t offset, pgoff_t next)
 {
 	struct page *page;
 
-	if (offset == ra->lookahead_index &&
-	      next >= ra->readahead_index)
-		return 1;
-
-	if (!(page = find_get_page(mapping, next)))
-		return 1;
+	page = find_get_page(mapping, next);
+	if (!page)
+		return;
 
 	SetPageReadahead(page);
 	page_cache_release(page);
 
 	if (ra->lookahead_index == offset)
 	    ra->lookahead_index = next;
-
-	return 0;
 }
 
 /*
@@ -1613,9 +1607,9 @@ page_cache_readahead_adaptive(struct add
 		 * Defer read-ahead to save energy.
 		 */
 		if (unlikely(laptop_mode && laptop_spinned_down())) {
-			if (!renew_lookahead(mapping, ra, offset,
-						offset + LAPTOP_POLL_INTERVAL))
-				return 0;
+			defer_lookahead(mapping, ra, offset,
+						offset + LAPTOP_POLL_INTERVAL);
+			return 0;
 		}
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
