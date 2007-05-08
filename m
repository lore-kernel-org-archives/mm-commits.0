From: akpm@linux-foundation.org
Subject: - readahead-min-max-sizes.patch removed from -mm tree
Date: Tue, 08 May 2007 01:13:55 -0700
Message-ID: <200705080813.l488Dt26018939@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934690AbXEHIjB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:39:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: min/max sizes
has been removed from the -mm tree.  Its filename was
     readahead-min-max-sizes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: min/max sizes
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

- Enlarge VM_MAX_READAHEAD to 1024 if new read-ahead code is compiled in.
  This value is no longer tightly coupled with the thrashing problem,
  therefore constrained by it. The adaptive read-ahead logic merely takes
  it as an upper bound, and will not stick to it under memory pressure.

- Slightly enlarge minimal/initial read-ahead size on big memory systems.
  Memory bounty systems are less likely to suffer from thrashing on small
  read-ahead sizes. A bigger initial value helps the ra_size scaling up
  progress.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/linux/mm.h~readahead-min-max-sizes include/linux/mm.h
--- a/include/linux/mm.h~readahead-min-max-sizes
+++ a/include/linux/mm.h
@@ -1146,8 +1146,13 @@ extern struct page *filemap_fault(struct
 int write_one_page(struct page *page, int wait);
 
 /* readahead.c */
+#ifdef CONFIG_ADAPTIVE_READAHEAD
+#define VM_MAX_READAHEAD	1024	/* kbytes */
+#define VM_MIN_READAHEAD	32	/* kbytes (includes current page) */
+#else
 #define VM_MAX_READAHEAD	128	/* kbytes */
 #define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
+#endif
 #define VM_MAX_CACHE_HIT    	256	/* max pages in a row in cache before
 					 * turning readahead off */
 
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-min-max-sizes.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-state-based-method-check-node-id.patch
readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch
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
