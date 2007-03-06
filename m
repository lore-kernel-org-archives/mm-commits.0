From: akpm@linux-foundation.org
Subject: - readahead-call-scheme-fix-thrashed-unaligned-read.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:50:31 -0800
Message-ID: <200703060150.l261oVhC008394@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46095 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933832AbXCFBui (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:50:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: call scheme: fix thrashed unaligned read
has been removed from the -mm tree.  Its filename was
     readahead-call-scheme-fix-thrashed-unaligned-read.patch

This patch was dropped because it was folded into readahead-call-scheme.patch

------------------------------------------------------
Subject: readahead: call scheme: fix thrashed unaligned read
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

When doing unaligned/subpages sequential reads, and thrashing happened, it is
possible that (offset == prev_page), besides the normal (offset == prev_page +
1).

We do not have such problem for the state based method.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/readahead.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/readahead.c~readahead-call-scheme-fix-thrashed-unaligned-read mm/readahead.c
--- a/mm/readahead.c~readahead-call-scheme-fix-thrashed-unaligned-read
+++ a/mm/readahead.c
@@ -1624,7 +1624,7 @@ page_cache_readahead_adaptive(struct add
 	/*
 	 * Recover from possible thrashing.
 	 */
-	if (!page && offset == ra->prev_page + 1 && ra_has_index(ra, offset))
+	if (!page && offset - ra->prev_page <= 1 && ra_has_index(ra, offset))
 		return thrashing_recovery_readahead(mapping, filp, ra,
 								offset, ra_max);
 
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
