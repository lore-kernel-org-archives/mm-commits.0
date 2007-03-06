From: akpm@linux-foundation.org
Subject: - readahead-call-scheme-remove-get_readahead_bounds.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:50:28 -0800
Message-ID: <200703060150.l261oSDB008391@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46094 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933833AbXCFBuf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:50:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: call scheme: remove get_readahead_bounds()
has been removed from the -mm tree.  Its filename was
     readahead-call-scheme-remove-get_readahead_bounds.patch

This patch was dropped because it was folded into readahead-call-scheme.patch

------------------------------------------------------
Subject: readahead: call scheme: remove get_readahead_bounds()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Remove the one and only get_readahead_bounds() call.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/readahead.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/readahead.c~readahead-call-scheme-remove-get_readahead_bounds mm/readahead.c
--- a/mm/readahead.c~readahead-call-scheme-remove-get_readahead_bounds
+++ a/mm/readahead.c
@@ -1578,7 +1578,6 @@ page_cache_readahead_adaptive(struct add
 				pgoff_t offset, unsigned long req_size)
 {
 	unsigned long ra_size;
-	unsigned long ra_min;
 	unsigned long ra_max;
 	int ret;
 
@@ -1599,7 +1598,7 @@ page_cache_readahead_adaptive(struct add
 	else if (offset)
 		ra_account(ra, RA_EVENT_CACHE_MISS, req_size);
 
-	get_readahead_bounds(ra, &ra_min, &ra_max);
+	ra_max = get_max_readahead(ra);
 
 	/* read-ahead disabled? */
 	if (unlikely(!ra_max || !readahead_ratio)) {
@@ -1639,7 +1638,7 @@ page_cache_readahead_adaptive(struct add
 	 * Context based sequential read-ahead.
 	 */
 	ret = try_context_based_readahead(mapping, ra, page,
-							offset, ra_min, ra_max);
+						offset, req_size, ra_max);
 	if (ret > 0)
 		return ra_submit(ra, mapping, filp);
 	if (ret < 0)
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
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-call-scheme.patch
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
