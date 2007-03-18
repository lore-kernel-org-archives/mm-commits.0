From: akpm@linux-foundation.org
Subject: + readahead-account-i-o-block-times-for-stock-readahead.patch added to -mm tree
Date: Sat, 17 Mar 2007 23:50:03 -0800
Message-ID: <200703180750.l2I7o302018374@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58697 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbXCRHuL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: account I/O block times for stock readahead
has been added to the -mm tree.  Its filename is
     readahead-account-i-o-block-times-for-stock-readahead.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: account I/O block times for stock readahead
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Account I/O block times for the stock readahead, too.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/readahead.c~readahead-account-i-o-block-times-for-stock-readahead mm/readahead.c
--- a/mm/readahead.c~readahead-account-i-o-block-times-for-stock-readahead
+++ a/mm/readahead.c
@@ -1756,15 +1756,15 @@ EXPORT_SYMBOL_GPL(page_cache_readahead_a
  */
 void readahead_cache_hit(struct file_ra_state *ra, struct page *page)
 {
-	if (!prefer_adaptive_readahead())
-		return;
-
 	if (PageActive(page) || PageReferenced(page))
 		return;
 
 	if (!PageUptodate(page))
 		ra_account(ra, RA_EVENT_IO_BLOCK, 1);
 
+	if (!prefer_adaptive_readahead())
+		return;
+
 	if (!ra_has_index(ra, page->index))
 		return;
 
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
