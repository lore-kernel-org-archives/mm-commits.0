From: akpm@linux-foundation.org
Subject: - readahead-backward-prefetching-method.patch removed from -mm tree
Date: Tue, 08 May 2007 01:14:48 -0700
Message-ID: <200705080814.l488Enjf018993@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934638AbXEHIPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:15:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: backward prefetching method
has been removed from the -mm tree.  Its filename was
     readahead-backward-prefetching-method.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: backward prefetching method
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Readahead policy for reading backward.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff -puN mm/readahead.c~readahead-backward-prefetching-method mm/readahead.c
--- a/mm/readahead.c~readahead-backward-prefetching-method
+++ a/mm/readahead.c
@@ -1494,6 +1494,52 @@ initial_readahead(struct address_space *
 	return ra_submit(ra, mapping, filp);
 }
 
+/*
+ * Backward prefetching.
+ *
+ * No look-ahead and thrashing safety guard: should be unnecessary.
+ *
+ * Important for certain scientific arenas(i.e. structural analysis).
+ */
+static int
+try_backward_prefetching(struct file_ra_state *ra, pgoff_t offset,
+			 unsigned long size, unsigned long ra_max)
+{
+	pgoff_t prev = ra->prev_index;
+
+	/* Reading backward? */
+	if (offset >= prev)
+		return 0;
+
+	/* Close enough? */
+	size += readahead_hit_rate;
+	if (offset + 2 * size <= prev)
+		return 0;
+
+	if (ra_class_new(ra) == RA_CLASS_BACKWARD && ra_has_index(ra, prev)) {
+		prev = ra->la_index;
+		size += 2 * ra_readahead_size(ra);
+	} else
+		size *= 2;
+
+	if (size > ra_max)
+		size = ra_max;
+	if (size > prev)
+		size = prev;
+
+	/* The readahead-request covers the read-request? */
+	if (offset < prev - size)
+		return 0;
+
+	offset = prev - size;
+
+	ra_set_class(ra, RA_CLASS_BACKWARD);
+	ra_set_index(ra, offset, offset);
+	ra_set_size(ra, size, 0);
+
+	return 1;
+}
+
 #endif /* CONFIG_ADAPTIVE_READAHEAD */
 
 /*
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
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
