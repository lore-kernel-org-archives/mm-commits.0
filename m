From: akpm@linux-foundation.org
Subject: - readahead-initial-method.patch removed from -mm tree
Date: Tue, 08 May 2007 01:14:45 -0700
Message-ID: <200705080814.l488EjT5018989@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934641AbXEHIP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: initial method
has been removed from the -mm tree.  Its filename was
     readahead-initial-method.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: initial method
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Aggressive readahead policy for read on start-of-file.

Instead of selecting a conservative readahead size,
it tries to do large readahead in the first place.

However we have to watch on two cases:
	- do not ruin the hit rate for file-head-checkers
	- do not lead to thrashing for memory tight systems

In most cases, the threat of file-head-peakers is neglectable. So a simple
user tunable parameter is used. Users can try a larger initial read-ahead
size:
	echo 128 > /sys/block/sda/queue/initial_ra_kb

It benefits the many-small-files case:

adaptive readahead: avg 10.3 seconds
====================================

stock readahead: avg 12.3 seconds
=================================

The rxvt-unicode-7.7 being benchmarked is a dir with many .C/.h/.o files.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff -puN mm/readahead.c~readahead-initial-method mm/readahead.c
--- a/mm/readahead.c~readahead-initial-method
+++ a/mm/readahead.c
@@ -1458,6 +1458,42 @@ has_history_pages:
 	return 1;
 }
 
+/*
+ * Read-ahead on start of file.
+ *
+ * We want to be as aggressive as possible, _and_
+ * 	- do not ruin the hit rate for file-head-peekers
+ * 	- do not lead to thrashing for memory tight systems
+ */
+static unsigned long
+initial_readahead(struct address_space *mapping, struct file *filp,
+		struct file_ra_state *ra, unsigned long req_size)
+{
+	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	unsigned long thrash_pages = bdi->ra_thrash_bytes >> PAGE_CACHE_SHIFT;
+	unsigned long ra_size;
+	unsigned long la_size;
+
+	ra_size = req_size;
+
+	/* user imposed minimal size */
+	if (ra_size < bdi->ra_pages0)
+		ra_size = bdi->ra_pages0;
+
+	/* no read-ahead thrashing */
+	if (ra_size > thrash_pages)
+		ra_size = thrash_pages;
+
+	/* do look-ahead on large(>= 32KB) read-ahead */
+	la_size = ra_size / LOOKAHEAD_RATIO;
+
+	ra_set_class(ra, RA_CLASS_INITIAL);
+	ra_set_index(ra, 0, 0);
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
