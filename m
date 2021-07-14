Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63C2C07E95
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9924561374
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237255AbhGNBQq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237198AbhGNBQq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Jul 2021 21:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA6C66136E;
        Wed, 14 Jul 2021 01:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626225235;
        bh=7SbjtiBGnWOMVdSrAffrAvuJRJ7RM4VwBG9cm4QoNwY=;
        h=Date:From:To:Subject:From;
        b=fBCGUx+/nRXbvOMSxutgCARXKSuHn1jri2Z/wPClAsDZo0cqTw7xNNa9fgqpgYta9
         cRzwPVNW8YyXLCl7y5bTwNEyFMQS9K3anM4YSOEoUpGIQNSHCN+JBHb8KcA61B1F2n
         gwjOJhuhDP7WnNPbn4HbE7SP8QxeMFj2V73tGOy4=
Date:   Tue, 13 Jul 2021 18:13:54 -0700
From:   akpm@linux-foundation.org
To:     fengguang.wu@intel.com, jack@suse.cz, mm-commits@vger.kernel.org,
        stapelberg+linux@google.com
Subject:  + writeback-reliably-update-bandwidth-estimation.patch
 added to -mm tree
Message-ID: <20210714011354.K0_4DnHM_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: reliably update bandwidth estimation
has been added to the -mm tree.  Its filename is
     writeback-reliably-update-bandwidth-estimation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-reliably-update-bandwidth-estimation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-reliably-update-bandwidth-estimation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: writeback: reliably update bandwidth estimation

Currently we trigger writeback bandwidth estimation from
balance_dirty_pages() and from wb_writeback().  However neither of these
need to trigger when the system is relatively idle and writeback is
triggered e.g.  from fsync(2).  Make sure writeback estimates happen
reliably by triggering them from do_writepages().

Link: https://lkml.kernel.org/r/20210713104716.22868-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Michael Stapelberg <stapelberg+linux@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c           |    3 --
 include/linux/backing-dev.h |   19 ++++++++++++++++
 include/linux/writeback.h   |    1 
 mm/page-writeback.c         |   39 +++++++++++++++++++++++-----------
 4 files changed, 46 insertions(+), 16 deletions(-)

--- a/fs/fs-writeback.c~writeback-reliably-update-bandwidth-estimation
+++ a/fs/fs-writeback.c
@@ -2001,7 +2001,6 @@ static long writeback_inodes_wb(struct b
 static long wb_writeback(struct bdi_writeback *wb,
 			 struct wb_writeback_work *work)
 {
-	unsigned long wb_start = jiffies;
 	long nr_pages = work->nr_pages;
 	unsigned long dirtied_before = jiffies;
 	struct inode *inode;
@@ -2055,8 +2054,6 @@ static long wb_writeback(struct bdi_writ
 			progress = __writeback_inodes_wb(wb, work);
 		trace_writeback_written(wb, work);
 
-		wb_update_bandwidth(wb, wb_start);
-
 		/*
 		 * Did we write something? Try for more
 		 *
--- a/include/linux/backing-dev.h~writeback-reliably-update-bandwidth-estimation
+++ a/include/linux/backing-dev.h
@@ -288,6 +288,17 @@ static inline struct bdi_writeback *inod
 	return inode->i_wb;
 }
 
+static inline struct bdi_writeback *inode_to_wb_wbc(
+				struct inode *inode,
+				struct writeback_control *wbc)
+{
+	/*
+	 * If wbc does not have inode attached, it means cgroup writeback was
+ 	 * disabled when wbc started. Just use the default wb in that case.
+	 */
+	return wbc->wb ? wbc->wb : &inode_to_bdi(inode)->wb;
+}
+
 /**
  * unlocked_inode_to_wb_begin - begin unlocked inode wb access transaction
  * @inode: target inode
@@ -366,6 +377,14 @@ static inline struct bdi_writeback *inod
 	return &inode_to_bdi(inode)->wb;
 }
 
+static inline struct bdi_writeback *inode_to_wb_wbc(
+				struct inode *inode,
+				struct writeback_control *wbc)
+{
+	return inode_to_wb(inode);
+}
+
+
 static inline struct bdi_writeback *
 unlocked_inode_to_wb_begin(struct inode *inode, struct wb_lock_cookie *cookie)
 {
--- a/include/linux/writeback.h~writeback-reliably-update-bandwidth-estimation
+++ a/include/linux/writeback.h
@@ -379,7 +379,6 @@ int dirty_writeback_centisecs_handler(st
 void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty);
 unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thresh);
 
-void wb_update_bandwidth(struct bdi_writeback *wb, unsigned long start_time);
 void balance_dirty_pages_ratelimited(struct address_space *mapping);
 bool wb_over_bg_thresh(struct bdi_writeback *wb);
 
--- a/mm/page-writeback.c~writeback-reliably-update-bandwidth-estimation
+++ a/mm/page-writeback.c
@@ -1332,7 +1332,6 @@ static void wb_update_dirty_ratelimit(st
 
 static void __wb_update_bandwidth(struct dirty_throttle_control *gdtc,
 				  struct dirty_throttle_control *mdtc,
-				  unsigned long start_time,
 				  bool update_ratelimit)
 {
 	struct bdi_writeback *wb = gdtc->wb;
@@ -1352,13 +1351,6 @@ static void __wb_update_bandwidth(struct
 	dirtied = percpu_counter_read(&wb->stat[WB_DIRTIED]);
 	written = percpu_counter_read(&wb->stat[WB_WRITTEN]);
 
-	/*
-	 * Skip quiet periods when disk bandwidth is under-utilized.
-	 * (at least 1s idle time between two flusher runs)
-	 */
-	if (elapsed > HZ && time_before(wb->bw_time_stamp, start_time))
-		goto snapshot;
-
 	if (update_ratelimit) {
 		domain_update_bandwidth(gdtc, now);
 		wb_update_dirty_ratelimit(gdtc, dirtied, elapsed);
@@ -1374,17 +1366,36 @@ static void __wb_update_bandwidth(struct
 	}
 	wb_update_write_bandwidth(wb, elapsed, written);
 
-snapshot:
 	wb->dirtied_stamp = dirtied;
 	wb->written_stamp = written;
 	wb->bw_time_stamp = now;
 }
 
-void wb_update_bandwidth(struct bdi_writeback *wb, unsigned long start_time)
+static void wb_update_bandwidth(struct bdi_writeback *wb)
 {
 	struct dirty_throttle_control gdtc = { GDTC_INIT(wb) };
 
-	__wb_update_bandwidth(&gdtc, NULL, start_time, false);
+	spin_lock(&wb->list_lock);
+	__wb_update_bandwidth(&gdtc, NULL, false);
+	spin_unlock(&wb->list_lock);
+}
+
+/* Interval after which we consider wb idle and don't estimate bandwidth */
+#define WB_BANDWIDTH_IDLE_JIF (HZ)
+
+static void wb_bandwidth_estimate_start(struct bdi_writeback *wb)
+{
+	unsigned long now = jiffies;
+	unsigned long elapsed = now - READ_ONCE(wb->bw_time_stamp);
+
+	if (elapsed > WB_BANDWIDTH_IDLE_JIF &&
+	    !atomic_read(&wb->writeback_inodes)) {
+		spin_lock(&wb->list_lock);
+		wb->dirtied_stamp = wb_stat(wb, WB_DIRTIED);
+		wb->written_stamp = wb_stat(wb, WB_WRITTEN);
+		wb->bw_time_stamp = now;
+		spin_unlock(&wb->list_lock);
+	}
 }
 
 /*
@@ -1713,7 +1724,7 @@ free_running:
 		if (time_is_before_jiffies(wb->bw_time_stamp +
 					   BANDWIDTH_INTERVAL)) {
 			spin_lock(&wb->list_lock);
-			__wb_update_bandwidth(gdtc, mdtc, start_time, true);
+			__wb_update_bandwidth(gdtc, mdtc, true);
 			spin_unlock(&wb->list_lock);
 		}
 
@@ -2347,9 +2358,12 @@ EXPORT_SYMBOL(generic_writepages);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;
+	struct bdi_writeback *wb;
 
 	if (wbc->nr_to_write <= 0)
 		return 0;
+	wb = inode_to_wb_wbc(mapping->host, wbc);
+	wb_bandwidth_estimate_start(wb);
 	while (1) {
 		if (mapping->a_ops->writepages)
 			ret = mapping->a_ops->writepages(mapping, wbc);
@@ -2360,6 +2374,7 @@ int do_writepages(struct address_space *
 		cond_resched();
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	}
+	wb_update_bandwidth(wb);
 	return ret;
 }
 
_

Patches currently in -mm which might be from jack@suse.cz are

writeback-track-number-of-inodes-under-writeback.patch
writeback-reliably-update-bandwidth-estimation.patch
writeback-fix-bandwidth-estimate-for-spiky-workload.patch
writeback-rename-domain_update_bandwidth.patch
writeback-use-read_once-for-unlocked-reads-of-writeback-stats.patch

