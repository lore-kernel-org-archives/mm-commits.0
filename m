From: akpm@linux-foundation.org
Subject: - readahead-thrashing-recovery-method.patch removed from -mm tree
Date: Tue, 08 May 2007 01:14:52 -0700
Message-ID: <200705080814.l488EqnW018996@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934643AbXEHIPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:15:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: thrashing recovery method
has been removed from the -mm tree.  Its filename was
     readahead-thrashing-recovery-method.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: thrashing recovery method
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Readahead policy after thrashing.

It tries to recover gracefully from the thrashing.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff -puN mm/readahead.c~readahead-thrashing-recovery-method mm/readahead.c
--- a/mm/readahead.c~readahead-thrashing-recovery-method
+++ a/mm/readahead.c
@@ -1540,6 +1540,48 @@ try_backward_prefetching(struct file_ra_
 	return 1;
 }
 
+/*
+ * Readahead thrashing recovery.
+ */
+static unsigned long
+thrashing_recovery_readahead(struct address_space *mapping,
+				struct file *filp, struct file_ra_state *ra,
+				pgoff_t offset, unsigned long ra_max)
+{
+	unsigned long ra_size;
+
+#ifdef CONFIG_DEBUG_READAHEAD
+	if (probe_page(mapping, offset - 1))
+		ra_account(ra, RA_EVENT_READAHEAD_MUTILATE,
+						ra->readahead_index - offset);
+	ra_account(ra, RA_EVENT_READAHEAD_THRASHING,
+						ra->readahead_index - offset);
+#endif
+
+	if (offset < ra->ra_index) {
+		/*
+		 * Thrashed when we are in [la_index, ra_index), i.e.
+		 * the old chunk is lost soon after the new one is allocated.
+		 * Ensure that we recover all needed pages in the old chunk.
+		 * And futher keep the lookahead_index untouched.
+		 */
+		ra_size = ra->lookahead_index - offset;
+	} else {
+		/* After thrashing, we know the exact thrashing-threshold. */
+		ra_size = offset - ra->la_index;
+		update_ra_thrash_bytes(mapping->backing_dev_info, ra_size);
+
+		/* And be cooperative: the system may be hunting for memory. */
+		ra_size = MIN_RA_PAGES + ra_size / 2;
+	}
+
+	ra_set_class(ra, RA_CLASS_THRASHING);
+	ra_set_index(ra, offset, offset);
+	ra_set_size(ra, ra_size, 0);
+
+	return ra_submit(ra, mapping, filp);
+}
+
 #endif /* CONFIG_ADAPTIVE_READAHEAD */
 
 /*
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
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
