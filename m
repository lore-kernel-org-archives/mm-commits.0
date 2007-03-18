From: akpm@linux-foundation.org
Subject: + readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch added to -mm tree
Date: Sat, 17 Mar 2007 23:49:41 -0800
Message-ID: <200703180749.l2I7nfMa018331@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58671 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbXCRHt4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:49:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: state based method: decouple readahead_ratio from growth_limit
has been added to the -mm tree.  Its filename is
     readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: state based method: decouple readahead_ratio from growth_limit
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Remove readahead_ratio from the growth_limit computing in state based method.

It simplifies the size ramp up rules to:

        ahead_window_size = request_size +
                            current_window_size * 2 +
                            readahead_max / 16;

The first two sizes are apparent. The last one has two effects:

1) Ensure that we get acceptable readahead size in early start up phase.
   It is an analog to the old 'first x4 then x2' trick.

2) Ensure that we reach readahead_max within 8 steps.
   It is good for the laptop mode. A user may set a huge readahead_max, and
   expect the kernel to do large I/Os right away.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/readahead.c~readahead-state-based-method-decouple-readahead_ratio-from-growth_limit mm/readahead.c
--- a/mm/readahead.c~readahead-state-based-method-decouple-readahead_ratio-from-growth_limit
+++ a/mm/readahead.c
@@ -1099,7 +1099,7 @@ state_based_readahead(struct address_spa
 
 	growth_limit = req_size;
 	growth_limit += ra_max / 16;
-	growth_limit += (2 + readahead_ratio / 64) * ra_old;
+	growth_limit += 2 * ra_old;
 	if (growth_limit > ra_max)
 	    growth_limit = ra_max;
 
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
