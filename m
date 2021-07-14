Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083D9C07E95
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5D8C6136E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237292AbhGNBQx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237281AbhGNBQx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Jul 2021 21:16:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D038A61370;
        Wed, 14 Jul 2021 01:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626225243;
        bh=km9XRV0M+QCNMBaLuPu0DT6lUYm6q9HrT95tgsiF+I0=;
        h=Date:From:To:Subject:From;
        b=V4xM/8m1V9rW2Jn1YIotCW60zencODf/AXKgEAWSWdUY0OH4AGNGwGo4TYjOSYpS7
         7EJVa5ukdEZXtBQd5khVfZlVvKvmEsa5cZg0M5nlMQPkKkY99ppUbqkVaT63dh04XY
         rBB8eQvVc5XytnE6g6qd9kTjg6tpcqs5xHj6sOwI=
Date:   Tue, 13 Jul 2021 18:14:02 -0700
From:   akpm@linux-foundation.org
To:     fengguang.wu@intel.com, jack@suse.cz, mm-commits@vger.kernel.org,
        stapelberg+linux@google.com
Subject:  +
 writeback-use-read_once-for-unlocked-reads-of-writeback-stats.patch added
 to -mm tree
Message-ID: <20210714011402.FdNaYYXTi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: use READ_ONCE for unlocked reads of writeback stats
has been added to the -mm tree.  Its filename is
     writeback-use-read_once-for-unlocked-reads-of-writeback-stats.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-use-read_once-for-unlocked-reads-of-writeback-stats.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-use-read_once-for-unlocked-reads-of-writeback-stats.patch

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
Subject: writeback: use READ_ONCE for unlocked reads of writeback stats

We do some unlocked reads of writeback statistics like
avg_write_bandwidth, dirty_ratelimit, or bw_time_stamp.  Generally we are
fine with getting somewhat out-of-date values but actually getting
different values in various parts of the functions because the compiler
decided to reload value from original memory location could confuse
calculations.  Use READ_ONCE for these unlocked accesses and WRITE_ONCE
for the updates to be on the safe side.

Link: https://lkml.kernel.org/r/20210713104716.22868-5-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Michael Stapelberg <stapelberg+linux@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/mm/page-writeback.c~writeback-use-read_once-for-unlocked-reads-of-writeback-stats
+++ a/mm/page-writeback.c
@@ -183,7 +183,7 @@ static struct fprop_local_percpu *wb_mem
 static void wb_min_max_ratio(struct bdi_writeback *wb,
 			     unsigned long *minp, unsigned long *maxp)
 {
-	unsigned long this_bw = wb->avg_write_bandwidth;
+	unsigned long this_bw = READ_ONCE(wb->avg_write_bandwidth);
 	unsigned long tot_bw = atomic_long_read(&wb->bdi->tot_write_bandwidth);
 	unsigned long long min = wb->bdi->min_ratio;
 	unsigned long long max = wb->bdi->max_ratio;
@@ -892,7 +892,7 @@ static long long pos_ratio_polynom(unsig
 static void wb_position_ratio(struct dirty_throttle_control *dtc)
 {
 	struct bdi_writeback *wb = dtc->wb;
-	unsigned long write_bw = wb->avg_write_bandwidth;
+	unsigned long write_bw = READ_ONCE(wb->avg_write_bandwidth);
 	unsigned long freerun = dirty_freerun_ceiling(dtc->thresh, dtc->bg_thresh);
 	unsigned long limit = hard_dirty_limit(dtc_dom(dtc), dtc->thresh);
 	unsigned long wb_thresh = dtc->wb_thresh;
@@ -1115,7 +1115,7 @@ out:
 					&wb->bdi->tot_write_bandwidth) <= 0);
 	}
 	wb->write_bandwidth = bw;
-	wb->avg_write_bandwidth = avg;
+	WRITE_ONCE(wb->avg_write_bandwidth, avg);
 }
 
 static void update_dirty_limit(struct dirty_throttle_control *dtc)
@@ -1324,7 +1324,7 @@ static void wb_update_dirty_ratelimit(st
 	else
 		dirty_ratelimit -= step;
 
-	wb->dirty_ratelimit = max(dirty_ratelimit, 1UL);
+	WRITE_ONCE(wb->dirty_ratelimit, max(dirty_ratelimit, 1UL));
 	wb->balanced_dirty_ratelimit = balanced_dirty_ratelimit;
 
 	trace_bdi_dirty_ratelimit(wb, dirty_rate, task_ratelimit);
@@ -1336,11 +1336,12 @@ static void __wb_update_bandwidth(struct
 {
 	struct bdi_writeback *wb = gdtc->wb;
 	unsigned long now = jiffies;
-	unsigned long elapsed = now - wb->bw_time_stamp;
+	unsigned long elapsed;
 	unsigned long dirtied;
 	unsigned long written;
 
 	spin_lock(&wb->list_lock);
+	elapsed = now - wb->bw_time_stamp;
 	dirtied = percpu_counter_read(&wb->stat[WB_DIRTIED]);
 	written = percpu_counter_read(&wb->stat[WB_WRITTEN]);
 
@@ -1361,7 +1362,7 @@ static void __wb_update_bandwidth(struct
 
 	wb->dirtied_stamp = dirtied;
 	wb->written_stamp = written;
-	wb->bw_time_stamp = now;
+	WRITE_ONCE(wb->bw_time_stamp, now);
 	spin_unlock(&wb->list_lock);
 }
 
@@ -1385,7 +1386,7 @@ static void wb_bandwidth_estimate_start(
 		spin_lock(&wb->list_lock);
 		wb->dirtied_stamp = wb_stat(wb, WB_DIRTIED);
 		wb->written_stamp = wb_stat(wb, WB_WRITTEN);
-		wb->bw_time_stamp = now;
+		WRITE_ONCE(wb->bw_time_stamp, now);
 		spin_unlock(&wb->list_lock);
 	}
 }
@@ -1410,7 +1411,7 @@ static unsigned long dirty_poll_interval
 static unsigned long wb_max_pause(struct bdi_writeback *wb,
 				  unsigned long wb_dirty)
 {
-	unsigned long bw = wb->avg_write_bandwidth;
+	unsigned long bw = READ_ONCE(wb->avg_write_bandwidth);
 	unsigned long t;
 
 	/*
@@ -1432,8 +1433,8 @@ static long wb_min_pause(struct bdi_writ
 			 unsigned long dirty_ratelimit,
 			 int *nr_dirtied_pause)
 {
-	long hi = ilog2(wb->avg_write_bandwidth);
-	long lo = ilog2(wb->dirty_ratelimit);
+	long hi = ilog2(READ_ONCE(wb->avg_write_bandwidth));
+	long lo = ilog2(READ_ONCE(wb->dirty_ratelimit));
 	long t;		/* target pause */
 	long pause;	/* estimated next pause */
 	int pages;	/* target nr_dirtied_pause */
@@ -1713,12 +1714,12 @@ free_running:
 		if (dirty_exceeded && !wb->dirty_exceeded)
 			wb->dirty_exceeded = 1;
 
-		if (time_is_before_jiffies(wb->bw_time_stamp +
+		if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
 					   BANDWIDTH_INTERVAL))
 			__wb_update_bandwidth(gdtc, mdtc, true);
 
 		/* throttle according to the chosen dtc */
-		dirty_ratelimit = wb->dirty_ratelimit;
+		dirty_ratelimit = READ_ONCE(wb->dirty_ratelimit);
 		task_ratelimit = ((u64)dirty_ratelimit * sdtc->pos_ratio) >>
 							RATELIMIT_CALC_SHIFT;
 		max_pause = wb_max_pause(wb, sdtc->wb_dirty);
@@ -2368,7 +2369,8 @@ int do_writepages(struct address_space *
 	 * but if there's constant writeback being submitted, this makes sure
 	 * writeback bandwidth is updated once in a while.
 	 */
-	if (time_is_before_jiffies(wb->bw_time_stamp + BANDWIDTH_INTERVAL))
+	if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
+				   BANDWIDTH_INTERVAL))
 		wb_update_bandwidth(wb);
 	return ret;
 }
_

Patches currently in -mm which might be from jack@suse.cz are

writeback-track-number-of-inodes-under-writeback.patch
writeback-reliably-update-bandwidth-estimation.patch
writeback-fix-bandwidth-estimate-for-spiky-workload.patch
writeback-rename-domain_update_bandwidth.patch
writeback-use-read_once-for-unlocked-reads-of-writeback-stats.patch

