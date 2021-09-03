Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C2DC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFAE460184
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350030AbhICU5I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234144AbhICU5G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70DCE601FD;
        Fri,  3 Sep 2021 20:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702565;
        bh=FUzcnmtAuA67VtV0t9pqqd7So3+QcngnwXfTFRYHaVc=;
        h=Date:From:To:Subject:From;
        b=UrQbhCy30HFRyaj/DXXp5oa/yFkeDCtXHqhTY4O+OHDdSInvtKGcVOBExPP+if21a
         cVvhZteWa9Kcj2wZqXzwkCXvecb7QPBTIFgk84O8UJ0yE2B+q5nPv0Z1cgixGuB1hP
         3LWogLnwZNvDVLCmOUyRhZQUadM5gYT0MPzM8gSg=
Date:   Fri, 03 Sep 2021 13:56:05 -0700
From:   akpm@linux-foundation.org
To:     fengguang.wu@intel.com, jack@suse.cz, mm-commits@vger.kernel.org,
        stapelberg+linux@google.com
Subject:  [merged]
 writeback-use-read_once-for-unlocked-reads-of-writeback-stats.patch removed
 from -mm tree
Message-ID: <20210903205605.7ZhHl8BWN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: use READ_ONCE for unlocked reads of writeback stats
has been removed from the -mm tree.  Its filename was
     writeback-use-read_once-for-unlocked-reads-of-writeback-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 mm/page-writeback.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

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
@@ -1369,7 +1369,7 @@ static void __wb_update_bandwidth(struct
 
 	wb->dirtied_stamp = dirtied;
 	wb->written_stamp = written;
-	wb->bw_time_stamp = now;
+	WRITE_ONCE(wb->bw_time_stamp, now);
 	spin_unlock(&wb->list_lock);
 }
 
@@ -1393,7 +1393,7 @@ static void wb_bandwidth_estimate_start(
 		spin_lock(&wb->list_lock);
 		wb->dirtied_stamp = wb_stat(wb, WB_DIRTIED);
 		wb->written_stamp = wb_stat(wb, WB_WRITTEN);
-		wb->bw_time_stamp = now;
+		WRITE_ONCE(wb->bw_time_stamp, now);
 		spin_unlock(&wb->list_lock);
 	}
 }
@@ -1418,7 +1418,7 @@ static unsigned long dirty_poll_interval
 static unsigned long wb_max_pause(struct bdi_writeback *wb,
 				  unsigned long wb_dirty)
 {
-	unsigned long bw = wb->avg_write_bandwidth;
+	unsigned long bw = READ_ONCE(wb->avg_write_bandwidth);
 	unsigned long t;
 
 	/*
@@ -1440,8 +1440,8 @@ static long wb_min_pause(struct bdi_writ
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
@@ -1721,12 +1721,12 @@ free_running:
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
@@ -2376,7 +2376,8 @@ int do_writepages(struct address_space *
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


