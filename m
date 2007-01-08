From: akpm@osdl.org
Subject: + readahead-call-scheme-remove-get_readahead_bounds.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:17:14 -0800
Message-ID: <200701082217.l08MHEAA020539@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48063 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030283AbXAHWRU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:17:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: call scheme: remove get_readahead_bounds()
has been added to the -mm tree.  Its filename is
     readahead-call-scheme-remove-get_readahead_bounds.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1572,7 +1572,6 @@ page_cache_readahead_adaptive(struct add
 				pgoff_t offset, unsigned long req_size)
 {
 	unsigned long ra_size;
-	unsigned long ra_min;
 	unsigned long ra_max;
 	int ret;
 
@@ -1593,7 +1592,7 @@ page_cache_readahead_adaptive(struct add
 	else if (offset)
 		ra_account(ra, RA_EVENT_CACHE_MISS, req_size);
 
-	get_readahead_bounds(ra, &ra_min, &ra_max);
+	ra_max = get_max_readahead(ra);
 
 	/* read-ahead disabled? */
 	if (unlikely(!ra_max || !readahead_ratio)) {
@@ -1633,7 +1632,7 @@ page_cache_readahead_adaptive(struct add
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
