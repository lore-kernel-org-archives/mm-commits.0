From: akpm@linux-foundation.org
Subject: + readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch added to -mm tree
Date: Sat, 17 Mar 2007 23:49:55 -0800
Message-ID: <200703180749.l2I7nt6H018356@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58793 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXCRHxH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:53:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: remove parameter ra_max from thrashing_recovery_readahead()
has been added to the -mm tree.  Its filename is
     readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: remove parameter ra_max from thrashing_recovery_readahead()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Remove the unused @ra_max from thrashing_recovery_readahead().

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/readahead.c~readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead mm/readahead.c
--- a/mm/readahead.c~readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead
+++ a/mm/readahead.c
@@ -1567,9 +1567,8 @@ try_backward_prefetching(struct file_ra_
  * Readahead thrashing recovery.
  */
 static unsigned long
-thrashing_recovery_readahead(struct address_space *mapping,
-				struct file *filp, struct file_ra_state *ra,
-				pgoff_t offset, unsigned long ra_max)
+thrashing_recovery_readahead(struct address_space *mapping, struct file *filp,
+			     struct file_ra_state *ra, pgoff_t offset)
 {
 	unsigned long ra_size;
 	int unbalanced_aging = probe_page(mapping, offset - 1);
@@ -1682,8 +1681,7 @@ page_cache_readahead_adaptive(struct add
 	 * Recover from possible thrashing.
 	 */
 	if (!page && offset - ra->prev_page <= 1 && ra_has_index(ra, offset))
-		return thrashing_recovery_readahead(mapping, filp, ra,
-								offset, ra_max);
+		return thrashing_recovery_readahead(mapping, filp, ra, offset);
 
 	/*
 	 * State based sequential read-ahead.
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
