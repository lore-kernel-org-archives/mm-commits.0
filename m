From: akpm@linux-foundation.org
Subject: - readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:27 -0700
Message-ID: <200705080815.l488FR7l019055@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934655AbXEHIR7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: remove parameter ra_max from thrashing_recovery_readahead()
has been removed from the -mm tree.  Its filename was
     readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch

This patch was dropped because an updated version will be merged

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
@@ -1570,9 +1570,8 @@ try_backward_prefetching(struct file_ra_
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
@@ -1685,8 +1684,7 @@ page_cache_readahead_adaptive(struct add
 	 * Recover from possible thrashing.
 	 */
 	if (!page && offset - ra->prev_index <= 1 && ra_has_index(ra, offset))
-		return thrashing_recovery_readahead(mapping, filp, ra,
-								offset, ra_max);
+		return thrashing_recovery_readahead(mapping, filp, ra, offset);
 
 	/*
 	 * State based sequential read-ahead.
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
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
