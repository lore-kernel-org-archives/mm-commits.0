From: akpm@linux-foundation.org
Subject: + readahead-call-scheme-cleanup.patch added to -mm tree
Date: Sat, 17 Mar 2007 23:49:51 -0800
Message-ID: <200703180749.l2I7npD7018345@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58681 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbXCRHuA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:50:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: call scheme: cleanup
has been added to the -mm tree.  Its filename is
     readahead-call-scheme-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: call scheme: cleanup
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Merge two similar page_cache_readahead_adaptive() calls into one.

No behavior change.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN mm/filemap.c~readahead-call-scheme-cleanup mm/filemap.c
--- a/mm/filemap.c~readahead-call-scheme-cleanup
+++ a/mm/filemap.c
@@ -934,17 +934,13 @@ void do_generic_mapping_read(struct addr
 find_page:
 		page = find_get_page(mapping, index);
 		if (prefer_adaptive_readahead()) {
-			if (unlikely(page == NULL)) {
-				ra.prev_page = prev_index;
-				page_cache_readahead_adaptive(mapping,
-						&ra, filp, NULL,
-						index, last_index - index);
-				page = find_get_page(mapping, index);
-			} else if (PageReadahead(page)) {
+			if (!page || PageReadahead(page)) {
 				ra.prev_page = prev_index;
 				page_cache_readahead_adaptive(mapping,
 						&ra, filp, page,
 						index, last_index - index);
+				if (!page)
+					page = find_get_page(mapping, index);
 			}
 		}
 		if (unlikely(page == NULL)) {
@@ -1394,13 +1390,11 @@ struct page *filemap_fault(struct vm_are
 retry_find:
 	page = find_lock_page(mapping, fdata->pgoff);
 	if (prefer_adaptive_readahead() && VM_SequentialReadHint(vma)) {
-		if (!page) {
-			page_cache_readahead_adaptive(mapping, ra, file, NULL,
-							fdata->pgoff, 1);
-			page = find_lock_page(mapping, fdata->pgoff);
-		} else if (PageReadahead(page)) {
+		if (!page || PageReadahead(page)) {
 			page_cache_readahead_adaptive(mapping, ra, file, page,
 							fdata->pgoff, 1);
+			if (!page)
+				page = find_lock_page(mapping, fdata->pgoff);
 		}
 	}
 	if (!page) {
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
