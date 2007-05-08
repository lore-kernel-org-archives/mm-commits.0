From: akpm@linux-foundation.org
Subject: - readahead-initial-method-user-recommended-size.patch removed from -mm tree
Date: Tue, 08 May 2007 01:14:41 -0700
Message-ID: <200705080814.l488Efa3018981@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934638AbXEHIPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:15:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: initial method - user recommended size
has been removed from the -mm tree.  Its filename was
     readahead-initial-method-user-recommended-size.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: initial method - user recommended size
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

backing_dev_info.ra_pages0 is a user configurable parameter that controls
the readahead size on start-of-file.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN block/ll_rw_blk.c~readahead-initial-method-user-recommended-size block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~readahead-initial-method-user-recommended-size
+++ a/block/ll_rw_blk.c
@@ -3881,6 +3881,24 @@ queue_ra_store(struct request_queue *q, 
 	return ret;
 }
 
+static ssize_t queue_initial_ra_show(struct request_queue *q, char *page)
+{
+	int kb = q->backing_dev_info.ra_pages0 << (PAGE_CACHE_SHIFT - 10);
+
+	return queue_var_show(kb, (page));
+}
+
+static ssize_t
+queue_initial_ra_store(struct request_queue *q, const char *page, size_t count)
+{
+	unsigned long kb;
+	ssize_t ret = queue_var_store(&kb, page, count);
+
+	q->backing_dev_info.ra_pages0 = kb >> (PAGE_CACHE_SHIFT - 10);
+
+	return ret;
+}
+
 static ssize_t queue_max_sectors_show(struct request_queue *q, char *page)
 {
 	int max_sectors_kb = q->max_sectors >> 1;
@@ -3938,6 +3956,12 @@ static struct queue_sysfs_entry queue_ra
 	.store = queue_ra_store,
 };
 
+static struct queue_sysfs_entry queue_initial_ra_entry = {
+	.attr = {.name = "read_ahead_initial_kb", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_initial_ra_show,
+	.store = queue_initial_ra_store,
+};
+
 static struct queue_sysfs_entry queue_max_sectors_entry = {
 	.attr = {.name = "max_sectors_kb", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_max_sectors_show,
@@ -3958,6 +3982,7 @@ static struct queue_sysfs_entry queue_io
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
+	&queue_initial_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
 	&queue_iosched_entry.attr,
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
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
