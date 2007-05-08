From: akpm@linux-foundation.org
Subject: - readahead-initial-method-guiding-sizes.patch removed from -mm tree
Date: Tue, 08 May 2007 01:14:35 -0700
Message-ID: <200705080814.l488EZLH018975@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934638AbXEHIPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:15:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: initial method - guiding sizes
has been removed from the -mm tree.  Its filename was
     readahead-initial-method-guiding-sizes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: initial method - guiding sizes
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Introduce three guiding sizes for the initial readahead method.
	- ra_pages0:	   min readahead on start-of-file
	- ra_thrash_bytes: estimated thrashing threshold

ra_thrash_bytes defaults to large value:
	- most systems don't have the danger of thrashing
	- it increases slowly and drops rapidly

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c           |    1 +
 include/linux/backing-dev.h |    2 ++
 mm/readahead.c              |    5 +++++
 3 files changed, 8 insertions(+)

diff -puN block/ll_rw_blk.c~readahead-initial-method-guiding-sizes block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~readahead-initial-method-guiding-sizes
+++ a/block/ll_rw_blk.c
@@ -1839,6 +1839,7 @@ request_queue_t *blk_alloc_queue_node(gf
 	q->kobj.ktype = &queue_ktype;
 	kobject_init(&q->kobj);
 
+	q->backing_dev_info = default_backing_dev_info;
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
 
diff -puN include/linux/backing-dev.h~readahead-initial-method-guiding-sizes include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~readahead-initial-method-guiding-sizes
+++ a/include/linux/backing-dev.h
@@ -26,6 +26,8 @@ typedef int (congested_fn)(void *, int);
 
 struct backing_dev_info {
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
+	unsigned long ra_pages0; /* min readahead on start of file */
+	unsigned long ra_thrash_bytes;	/* estimated thrashing threshold */
 	unsigned long state;	/* Always use atomic bitops on this */
 	unsigned int capabilities; /* Device capabilities */
 	congested_fn *congested_fn; /* Function pointer if device is md/dm */
diff -puN mm/readahead.c~readahead-initial-method-guiding-sizes mm/readahead.c
--- a/mm/readahead.c~readahead-initial-method-guiding-sizes
+++ a/mm/readahead.c
@@ -37,6 +37,9 @@ EXPORT_SYMBOL(default_unplug_io_fn);
  * Adaptive read-ahead parameters.
  */
 
+/* Default initial read-ahead size. */
+#define INITIAL_RA_PAGES  DIV_ROUND_UP(64*1024, PAGE_CACHE_SIZE)
+
 /* In laptop mode, poll delayed look-ahead on every ## pages read. */
 #define LAPTOP_POLL_INTERVAL 16
 
@@ -116,6 +119,8 @@ static void ra_account(struct file_ra_st
 
 struct backing_dev_info default_backing_dev_info = {
 	.ra_pages	= MAX_RA_PAGES,
+	.ra_pages0	= INITIAL_RA_PAGES,
+	.ra_thrash_bytes = MAX_RA_PAGES * PAGE_CACHE_SIZE,
 	.state		= 0,
 	.capabilities	= BDI_CAP_MAP_COPY,
 	.unplug_io_fn	= default_unplug_io_fn,
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
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
