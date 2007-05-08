From: akpm@linux-foundation.org
Subject: - readahead-thrashing-recovery-method-refill-holes.patch removed from -mm tree
Date: Tue, 08 May 2007 01:14:59 -0700
Message-ID: <200705080814.l488ExeB019002@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934638AbXEHIPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: thrashing recovery method: refill holes
has been removed from the -mm tree.  Its filename was
     readahead-thrashing-recovery-method-refill-holes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: thrashing recovery method: refill holes
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

When thrashing happened in the following abnormal cases:
	1) the old chunk is lost;
	2) random pages are lost due to unbalanced aging.
There will be hole(s) in the otherwise continuous readahead pages.

We recover from it by simply refilling all possible holes and
turning off lookahead.

These kind of abnormal situations are not expected to repeatable for the same
stream.  They happen in a random fashion and do not tell much about the system
load.  So the best thing we can do is to do nothing more than refilling the
holes.  If thrashing persists, it will quickly fail into the 3) case where we
get the exact thrashing threshold:

	3) the new chunk is thrashed.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN mm/readahead.c~readahead-thrashing-recovery-method-refill-holes mm/readahead.c
--- a/mm/readahead.c~readahead-thrashing-recovery-method-refill-holes
+++ a/mm/readahead.c
@@ -1555,20 +1555,23 @@ thrashing_recovery_readahead(struct addr
 					  RA_EVENT_READAHEAD_THRASHING,
 					  ra->readahead_index - offset);
 
-	if (offset < ra->ra_index) {
+	if (offset < ra->ra_index || unbalanced_aging) {
 		/*
-		 * Thrashed when we are in [la_index, ra_index), i.e.
-		 * the old chunk is lost soon after the new one is allocated.
-		 * Ensure that we recover all needed pages in the old chunk.
-		 * And futher keep the lookahead_index untouched.
+		 * 1) The old chunk is lost.
+		 * 2) Some random pages are lost due to unbalanced zone/node aging.
+		 * Refill the hole(s).
+		 * Further thrashings will bring us back to case (3) below.
 		 */
-		ra_size = ra->lookahead_index - offset;
+		ra_size = ra->readahead_index - offset;
 	} else {
-		/* After thrashing, we know the exact thrashing-threshold. */
+		/*
+		 * 3) The new chunk is lost.
+		 * It tells us about the thrashing-threshold.
+		 */
 		ra_size = offset - ra->la_index;
 		update_ra_thrash_bytes(mapping->backing_dev_info, ra_size);
 
-		/* And be cooperative: the system may be hunting for memory. */
+		/* Be cooperative: the system may be hunting for memory. */
 		ra_size = MIN_RA_PAGES + ra_size / 2;
 	}
 
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
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
