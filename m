From: akpm@linux-foundation.org
Subject: - readahead-thrashing-recovery-method-check-unbalanced-aging.patch removed from -mm tree
Date: Tue, 08 May 2007 01:14:55 -0700
Message-ID: <200705080814.l488Et35018999@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934639AbXEHIPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: thrashing recovery method: check unbalanced aging
has been removed from the -mm tree.  Its filename was
     readahead-thrashing-recovery-method-check-unbalanced-aging.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: thrashing recovery method: check unbalanced aging
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Always check for unbalanced aging in thrashing_recovery_readahead(), and
account RA_EVENT_READAHEAD_MUTILATE/RA_EVENT_READAHEAD_THRASHING events.

Unbalanced zone/node aging can come from abnormal system loads, or
misconfigured NUMA policies.

Thrashings are rare events, hence the cost of probe_page() is not a concern.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN mm/readahead.c~readahead-thrashing-recovery-method-check-unbalanced-aging mm/readahead.c
--- a/mm/readahead.c~readahead-thrashing-recovery-method-check-unbalanced-aging
+++ a/mm/readahead.c
@@ -1549,14 +1549,11 @@ thrashing_recovery_readahead(struct addr
 				pgoff_t offset, unsigned long ra_max)
 {
 	unsigned long ra_size;
+	int unbalanced_aging = probe_page(mapping, offset - 1);
 
-#ifdef CONFIG_DEBUG_READAHEAD
-	if (probe_page(mapping, offset - 1))
-		ra_account(ra, RA_EVENT_READAHEAD_MUTILATE,
-						ra->readahead_index - offset);
-	ra_account(ra, RA_EVENT_READAHEAD_THRASHING,
-						ra->readahead_index - offset);
-#endif
+	ra_account(ra, unbalanced_aging ? RA_EVENT_READAHEAD_MUTILATE :
+					  RA_EVENT_READAHEAD_THRASHING,
+					  ra->readahead_index - offset);
 
 	if (offset < ra->ra_index) {
 		/*
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
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
