From: akpm@linux-foundation.org
Subject: - readahead-initial-method-thrashing-guard-size.patch removed from -mm tree
Date: Tue, 08 May 2007 01:14:38 -0700
Message-ID: <200705080814.l488EcrR018978@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934630AbXEHIPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: initial method - thrashing guard size
has been removed from the -mm tree.  Its filename was
     readahead-initial-method-thrashing-guard-size.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: initial method - thrashing guard size
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

backing_dev_info.ra_thrash_bytes is dynamicly updated to be a little above
the thrashing safe read-ahead size. It is used in the initial method where
the thrashing threshold for the particular reader is still unknown.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN mm/readahead.c~readahead-initial-method-thrashing-guard-size mm/readahead.c
--- a/mm/readahead.c~readahead-initial-method-thrashing-guard-size
+++ a/mm/readahead.c
@@ -790,6 +790,22 @@ out:
 }
 
 /*
+ * Update `backing_dev_info.ra_thrash_bytes' to be a _biased_ average of
+ * read-ahead sizes. Which makes it an a-bit-risky(*) estimation of the
+ * _minimal_ read-ahead thrashing threshold on the device.
+ *
+ * (*) Note that being a bit risky can _help_ overall performance.
+ */
+static void update_ra_thrash_bytes(struct backing_dev_info *bdi,
+							unsigned long ra_size)
+{
+	ra_size <<= PAGE_CACHE_SHIFT;
+	bdi->ra_thrash_bytes = (bdi->ra_thrash_bytes < ra_size) ?
+				(ra_size + bdi->ra_thrash_bytes * 127) / 128:
+				(ra_size + bdi->ra_thrash_bytes *   7) /   8;
+}
+
+/*
  * Some helpers for querying/building a read-ahead request.
  *
  * Diagram for some variable names used frequently:
@@ -1116,6 +1132,10 @@ state_based_readahead(struct address_spa
 
 	limit_rala(growth_limit, la_old, &ra_size, &la_size);
 
+	/* ra_size in its _steady_ state reflects thrashing threshold */
+	if (page && ra_old + ra_old / 8 >= ra_size)
+		update_ra_thrash_bytes(mapping->backing_dev_info, ra_size);
+
 	ra_set_class(ra, RA_CLASS_STATE);
 	ra_set_index(ra, offset, ra->readahead_index);
 	ra_set_size(ra, ra_size, la_size);
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
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
