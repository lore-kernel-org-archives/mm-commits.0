From: akpm@linux-foundation.org
Subject: - readahead-nfsd-case-remove-ra_min.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:52:46 -0800
Message-ID: <200703060152.l261qkwB008425@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46159 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933834AbXCFBwx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:52:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: nfsd case: remove ra_min
has been removed from the -mm tree.  Its filename was
     readahead-nfsd-case-remove-ra_min.patch

This patch was dropped because it was folded into readahead-nfsd-case.patch

------------------------------------------------------
Subject: readahead: nfsd case: remove ra_min
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

ra_min => req_size.
Now it is for try_context_based_readahead() to compute ra_min from req_size.

Please fold it into readahead-nfsd-case.patch to avoid a compiling error.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/readahead.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/readahead.c~readahead-nfsd-case-remove-ra_min mm/readahead.c
--- a/mm/readahead.c~readahead-nfsd-case-remove-ra_min
+++ a/mm/readahead.c
@@ -1712,7 +1712,7 @@ readit:
 		   !probe_page(mapping, ra_index)) {
 			ra->prev_page = ra_index - 1;
 			ret = try_context_based_readahead(mapping, ra, NULL,
-						 ra_index, ra_min, ra_max);
+						 ra_index, req_size, ra_max);
 			if (ret > 0)
 				ra_size += ra_submit(ra, mapping, filp);
 		}
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
readahead-laptop-mode.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-nfsd-case-remove-ra_min.patch
readahead-turn-on-by-default.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
