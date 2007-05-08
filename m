From: akpm@linux-foundation.org
Subject: - readahead-state-based-method.patch removed from -mm tree
Date: Tue, 08 May 2007 01:14:11 -0700
Message-ID: <200705080814.l488EBoj018954@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934630AbXEHIOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: state based method
has been removed from the -mm tree.  Its filename was
     readahead-state-based-method.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: state based method
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

This is the fast code path of adaptive read-ahead.

MAJOR STEPS
===========

        - estimate a thrashing safe ra_size;
        - assemble the next read-ahead request in file_ra_state;
        - submit it.

THE REFERENCE MODEL
===================

        1. inactive list has constant length and page flow speed
        2. the observed stream receives a steady flow of read requests
        3. no page activation, so that the inactive list forms a pipe

With that we get the picture showed below.

 |<------------------------- constant length ------------------------->|
 <<<<<<<<<<<<<<<<<<<<<<<<< steady flow of pages <<<<<<<<<<<<<<<<<<<<<<<<
 +---------------------------------------------------------------------+
 |tail                        inactive list                        head|
 |   =======                  ==========----                           |
 |   chunk A(stale pages)     chunk B(stale + fresh pages)             |
 +---------------------------------------------------------------------+

REAL WORLD ISSUES
=================

Real world workloads will always have fluctuations (violation of assumption
1 and 2). To counteract it, a tunable parameter readahead_ratio is introduced
to make the estimation conservative enough. Violation of assumption 3 will
not lead to thrashing, it is there just for simplicity of discussion.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |  169 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 169 insertions(+)

diff -puN mm/readahead.c~readahead-state-based-method mm/readahead.c
--- a/mm/readahead.c~readahead-state-based-method
+++ a/mm/readahead.c
@@ -23,6 +23,8 @@ void default_unplug_io_fn(struct backing
 }
 EXPORT_SYMBOL(default_unplug_io_fn);
 
+#include <asm/div64.h>
+
 /*
  * Convienent macros for min/max read-ahead pages.
  * Note that MAX_RA_PAGES is rounded down, while MIN_RA_PAGES is rounded up.
@@ -929,6 +931,173 @@ static unsigned long ra_submit(struct fi
 	return actual;
 }
 
+/*
+ * Deduce the read-ahead/look-ahead size from primitive values.
+ *
+ * Input:
+ *	- @ra_size stores the estimated thrashing-threshold.
+ *	- @la_size stores the look-ahead size of previous request.
+ */
+static int adjust_rala(unsigned long ra_max,
+			unsigned long *ra_size, unsigned long *la_size)
+{
+	/*
+	 * Cancel asynchrous read-ahead,
+	 * if there is a major upsurge of load, or fall of this stream's speed.
+	 */
+	if (*ra_size <= *la_size * 2) {
+		ra_account(NULL, RA_EVENT_READAHEAD_SHRINK, *ra_size);
+		return 0;
+	}
+
+	/*
+	 * Substract the old look-ahead to get real safe size for the next
+	 * read-ahead request.
+	 */
+	*ra_size -= *la_size;
+
+	/*
+	 * Set new la_size according to the (still large) ra_size.
+	 */
+	*la_size = *ra_size / LOOKAHEAD_RATIO;
+
+	return 1;
+}
+
+static void limit_rala(unsigned long ra_max, unsigned long la_old,
+			unsigned long *ra_size, unsigned long *la_size)
+{
+	unsigned long stream_shift;
+
+	/*
+	 * Protect against too small I/O sizes,
+	 * by mapping [0, 4*min] to [min, 4*min].
+	 */
+	if (*ra_size < 4 * MIN_RA_PAGES)
+		*ra_size = MIN_RA_PAGES + *ra_size * 3 / 4;
+
+	/*
+	 * Apply basic upper limits.
+	 */
+	if (*ra_size > ra_max)
+		*ra_size = ra_max;
+	if (*la_size > *ra_size)
+		*la_size = *ra_size;
+
+	/*
+	 * Make sure stream_shift is not too small.
+	 * (So that the next global_shift will not be too small.)
+	 */
+	stream_shift = la_old + (*ra_size - *la_size);
+	if (stream_shift < *ra_size / 4)
+		*la_size -= (*ra_size / 4 - stream_shift);
+}
+
+/*
+ * The function estimates two values:
+ * 1. thrashing-threshold for the current stream
+ *    It is returned to make the next read-ahead request.
+ * 2. the remained safe space for the current chunk
+ *    It will be checked to ensure that the current chunk is safe.
+ *
+ * The computation will be pretty accurate under heavy load, and will vibrate
+ * more on light load(with small global_shift), so the grow speed of ra_size
+ * must be limited, and a moderate large stream_shift must be insured.
+ *
+ * The following figure illustrates the formula used in the function:
+ * 	While the stream reads stream_shift pages inside the chunks,
+ * 	the chunks are shifted global_shift pages inside inactive_list.
+ * So
+ * 	thrashing_threshold = free_mem * stream_shift / global_shift;
+ *
+ *
+ *      chunk A                    chunk B
+ *                          |<=============== global_shift ================|
+ *  +-------------+         +-------------------+                          |
+ *  |       #     |         |           #       |            inactive_list |
+ *  +-------------+         +-------------------+                     head |
+ *          |---->|         |---------->|
+ *             |                  |
+ *             +-- stream_shift --+
+ */
+static unsigned long compute_thrashing_threshold(struct file_ra_state *ra,
+							unsigned long *remain)
+{
+	unsigned long global_size;
+	unsigned long global_shift;
+	unsigned long stream_shift;
+	unsigned long ra_size;
+	uint64_t ll;
+
+	global_size = nr_free_inactive_pages_node(numa_node_id());
+	global_shift = nr_scanned_pages_node(numa_node_id()) - ra->age;
+	global_shift |= 1UL;
+	stream_shift = ra_invoke_interval(ra);
+
+	/* future safe space */
+	ll = (uint64_t) stream_shift * global_size;
+	do_div(ll, global_shift);
+	ra_size = ll;
+
+	/* remained safe space */
+	if (global_size > global_shift) {
+		ll = (uint64_t) stream_shift * (global_size - global_shift);
+		do_div(ll, global_shift);
+		*remain = ll;
+	} else
+		*remain = 0;
+
+	ddprintk("compute_thrashing_threshold: "
+			"at %lu ra %lu=%lu*%lu/%lu, remain %lu for %lu\n",
+			ra->readahead_index, ra_size,
+			stream_shift, global_size, global_shift,
+			*remain, ra_lookahead_size(ra));
+
+	return ra_size;
+}
+
+/*
+ * Main function for file_ra_state based read-ahead.
+ */
+static unsigned long
+state_based_readahead(struct address_space *mapping, struct file *filp,
+			struct file_ra_state *ra,
+			struct page *page, pgoff_t offset,
+			unsigned long req_size, unsigned long ra_max)
+{
+	unsigned long ra_old, ra_size;
+	unsigned long la_old, la_size;
+	unsigned long remain_space;
+	unsigned long growth_limit;
+
+	la_old = la_size = ra->readahead_index - offset;
+	ra_old = ra_readahead_size(ra);
+	ra_size = compute_thrashing_threshold(ra, &remain_space);
+	ra_size = ra_size * readahead_ratio / 100;
+
+	if (page && remain_space <= la_size) {
+		rescue_pages(page, la_size);
+		return 0;
+	}
+
+	growth_limit = req_size;
+	growth_limit += ra_max / 16;
+	growth_limit += (2 + readahead_ratio / 64) * ra_old;
+	if (growth_limit > ra_max)
+	    growth_limit = ra_max;
+
+	if (!adjust_rala(growth_limit, &ra_size, &la_size))
+		return 0;
+
+	limit_rala(growth_limit, la_old, &ra_size, &la_size);
+
+	ra_set_class(ra, RA_CLASS_STATE);
+	ra_set_index(ra, offset, ra->readahead_index);
+	ra_set_size(ra, ra_size, la_size);
+
+	return ra_submit(ra, mapping, filp);
+}
+
 #endif /* CONFIG_ADAPTIVE_READAHEAD */
 
 /*
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
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
