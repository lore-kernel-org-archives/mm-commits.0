From: akpm@linux-foundation.org
Subject: - readahead-call-scheme-catch-thrashing-on-lookahead-time.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:10 -0700
Message-ID: <200705080815.l488FAfx019034@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934642AbXEHIPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: call scheme: catch thrashing on lookahead time
has been removed from the -mm tree.  Its filename was
     readahead-call-scheme-catch-thrashing-on-lookahead-time.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: call scheme: catch thrashing on lookahead time
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Move the call to thrashing_recovery_readahead() before
state_based_readahead().

That catches the rare case where thrashing happened on the time we are to read
the page at ra->lookahead_index.  Obviously this case should be handled by
thrashing_recovery_readahead() instead of state_based_readahead().

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/readahead.c~readahead-call-scheme-catch-thrashing-on-lookahead-time mm/readahead.c
--- a/mm/readahead.c~readahead-call-scheme-catch-thrashing-on-lookahead-time
+++ a/mm/readahead.c
@@ -1641,6 +1641,13 @@ page_cache_readahead_adaptive(struct add
 		return initial_readahead(mapping, filp, ra, req_size);
 
 	/*
+	 * Recover from possible thrashing.
+	 */
+	if (!page && offset - ra->prev_index <= 1 && ra_has_index(ra, offset))
+		return thrashing_recovery_readahead(mapping, filp, ra,
+								offset, ra_max);
+
+	/*
 	 * State based sequential read-ahead.
 	 */
 	if (offset == ra->prev_index + 1 &&
@@ -1650,13 +1657,6 @@ page_cache_readahead_adaptive(struct add
 						offset, req_size, ra_max);
 
 	/*
-	 * Recover from possible thrashing.
-	 */
-	if (!page && offset - ra->prev_index <= 1 && ra_has_index(ra, offset))
-		return thrashing_recovery_readahead(mapping, filp, ra,
-								offset, ra_max);
-
-	/*
 	 * Backward read-ahead.
 	 */
 	if (!page && try_backward_prefetching(ra, offset, req_size, ra_max))
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
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
