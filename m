From: akpm@linux-foundation.org
Subject: - readahead-state-based-method-cancel-lookahead-gracefully.patch removed from -mm tree
Date: Tue, 08 May 2007 01:14:25 -0700
Message-ID: <200705080814.l488EPfd018963@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934631AbXEHIPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: state based method: cancel lookahead gracefully
has been removed from the -mm tree.  Its filename was
     readahead-state-based-method-cancel-lookahead-gracefully.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: state based method: cancel lookahead gracefully
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

When canceling lookahead, update ra->lookahead_index to the next invoke index.
 So that we see a consistent state in the next time.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/readahead.c~readahead-state-based-method-cancel-lookahead-gracefully mm/readahead.c
--- a/mm/readahead.c~readahead-state-based-method-cancel-lookahead-gracefully
+++ a/mm/readahead.c
@@ -1097,7 +1097,7 @@ state_based_readahead(struct address_spa
 
 	if (page && remain_space <= la_size) {
 		rescue_pages(page, la_size);
-		return 0;
+		goto cancel_lookahead;
 	}
 
 	growth_limit = req_size;
@@ -1107,7 +1107,7 @@ state_based_readahead(struct address_spa
 	    growth_limit = ra_max;
 
 	if (!adjust_rala(growth_limit, &ra_size, &la_size))
-		return 0;
+		goto cancel_lookahead;
 
 	limit_rala(growth_limit, la_old, &ra_size, &la_size);
 
@@ -1116,6 +1116,10 @@ state_based_readahead(struct address_spa
 	ra_set_size(ra, ra_size, la_size);
 
 	return ra_submit(ra, mapping, filp);
+
+cancel_lookahead:
+	ra->lookahead_index = ra->readahead_index;
+	return 0;
 }
 
 #endif /* CONFIG_ADAPTIVE_READAHEAD */
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
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
readahead-call-scheme-doc-fixes-for-readahead.patch
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
