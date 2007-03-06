From: akpm@linux-foundation.org
Subject: - readahead-state-based-method-move-readahead_ratio-out-of-compute_thrashing_threshold.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:46:48 -0800
Message-ID: <200703060146.l261knM8008287@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933819AbXCFBq6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:46:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: state based method: move readahead_ratio out of compute_thrashing_threshold()
has been removed from the -mm tree.  Its filename was
     readahead-state-based-method-move-readahead_ratio-out-of-compute_thrashing_threshold.patch

This patch was dropped because it was folded into readahead-state-based-method.patch

------------------------------------------------------
Subject: readahead: state based method: move readahead_ratio out of compute_thrashing_threshold()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Make compute_thrashing_threshold() a pure computing routine, by moving the
readahead_ratio policy out of it.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/readahead.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/readahead.c~readahead-state-based-method-move-readahead_ratio-out-of-compute_thrashing_threshold mm/readahead.c
--- a/mm/readahead.c~readahead-state-based-method-move-readahead_ratio-out-of-compute_thrashing_threshold
+++ a/mm/readahead.c
@@ -1031,7 +1031,7 @@ static unsigned long compute_thrashing_t
 	stream_shift = ra_invoke_interval(ra);
 
 	/* future safe space */
-	ll = (uint64_t) stream_shift * (global_size >> 9) * readahead_ratio * 5;
+	ll = (uint64_t) stream_shift * global_size;
 	do_div(ll, global_shift);
 	ra_size = ll;
 
@@ -1069,6 +1069,7 @@ state_based_readahead(struct address_spa
 	la_old = la_size = ra->readahead_index - offset;
 	ra_old = ra_readahead_size(ra);
 	ra_size = compute_thrashing_threshold(ra, &remain_space);
+	ra_size = ra_size * readahead_ratio / 100;
 
 	if (page && remain_space <= la_size) {
 		rescue_pages(page, la_size);
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
readahead-partial-sendfile-fix.patch
