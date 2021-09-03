Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27884C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11C8E60184
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350002AbhICU5D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349849AbhICU5C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BCBF601FD;
        Fri,  3 Sep 2021 20:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702561;
        bh=Jb6sTFKltPqf1qkHeREbjtUx4jlx80cjD8qn+aUMPRE=;
        h=Date:From:To:Subject:From;
        b=kboLZtH0FzwsR9gIMhRJ+JADZx5WjKOnryPSFl+srtEUMmfLE6Ikn53YA0MFTt/Jd
         qB7FgW30ctXKSQAlCHclZaTwCKEuq4KgMfkbMU5P2xTvNR7o9MG4q809z71zqC+rTv
         Gc9VG0ljdaeIo+Z0FOW5VaXKLJ6I1o4KBmRgj4X8=
Date:   Fri, 03 Sep 2021 13:56:01 -0700
From:   akpm@linux-foundation.org
To:     fengguang.wu@intel.com, jack@suse.cz, mm-commits@vger.kernel.org,
        stapelberg+linux@google.com
Subject:  [merged]
 writeback-fix-bandwidth-estimate-for-spiky-workload.patch removed from -mm
 tree
Message-ID: <20210903205601.MFUWtODQE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: fix bandwidth estimate for spiky workload
has been removed from the -mm tree.  Its filename was
     writeback-fix-bandwidth-estimate-for-spiky-workload.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: writeback: fix bandwidth estimate for spiky workload

Michael Stapelberg has reported that for workload with short big spikes of
writes (GCC linker seem to trigger this frequently) the write throughput
is heavily underestimated and tends to steadily sink until it reaches
zero.  This has rather bad impact on writeback throttling (causing
stalls).  The problem is that writeback throughput estimate gets updated
at most once per 200 ms.  One update happens early after we submit pages
for writeback (at that point writeout of only small fraction of pages is
completed and thus observed throughput is tiny).  Next update happens only
during the next write spike (updates happen only from inode writeback and
dirty throttling code) and if that is more than 1s after previous spike,
we decide system was idle and just ignore whatever was written until this
moment.

Fix the problem by making sure writeback throughput estimate is also
updated shortly after writeback completes to get reasonable estimate of
throughput for spiky workloads.

[jack@suse.cz: avoid division by 0 in wb_update_dirty_ratelimit()]
Link: https://lore.kernel.org/lkml/20210617095309.3542373-1-stapelberg+linux@google.com
Link: https://lkml.kernel.org/r/20210713104716.22868-3-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Michael Stapelberg <stapelberg+linux@google.com>
Tested-by: Michael Stapelberg <stapelberg+linux@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev-defs.h |    1 
 include/linux/writeback.h        |    1 
 mm/backing-dev.c                 |   10 +++++++
 mm/page-writeback.c              |   39 ++++++++++++++++++-----------
 4 files changed, 37 insertions(+), 14 deletions(-)

--- a/include/linux/backing-dev-defs.h~writeback-fix-bandwidth-estimate-for-spiky-workload
+++ a/include/linux/backing-dev-defs.h
@@ -143,6 +143,7 @@ struct bdi_writeback {
 	spinlock_t work_lock;		/* protects work_list & dwork scheduling */
 	struct list_head work_list;
 	struct delayed_work dwork;	/* work item used for writeback */
+	struct delayed_work bw_dwork;	/* work item used for bandwidth estimate */
 
 	unsigned long dirty_sleep;	/* last wait */
 
--- a/include/linux/writeback.h~writeback-fix-bandwidth-estimate-for-spiky-workload
+++ a/include/linux/writeback.h
@@ -379,6 +379,7 @@ int dirty_writeback_centisecs_handler(st
 void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty);
 unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thresh);
 
+void wb_update_bandwidth(struct bdi_writeback *wb);
 void balance_dirty_pages_ratelimited(struct address_space *mapping);
 bool wb_over_bg_thresh(struct bdi_writeback *wb);
 
--- a/mm/backing-dev.c~writeback-fix-bandwidth-estimate-for-spiky-workload
+++ a/mm/backing-dev.c
@@ -271,6 +271,14 @@ void wb_wakeup_delayed(struct bdi_writeb
 	spin_unlock_bh(&wb->work_lock);
 }
 
+static void wb_update_bandwidth_workfn(struct work_struct *work)
+{
+	struct bdi_writeback *wb = container_of(to_delayed_work(work),
+						struct bdi_writeback, bw_dwork);
+
+	wb_update_bandwidth(wb);
+}
+
 /*
  * Initial write bandwidth: 100 MB/s
  */
@@ -303,6 +311,7 @@ static int wb_init(struct bdi_writeback
 	spin_lock_init(&wb->work_lock);
 	INIT_LIST_HEAD(&wb->work_list);
 	INIT_DELAYED_WORK(&wb->dwork, wb_workfn);
+	INIT_DELAYED_WORK(&wb->bw_dwork, wb_update_bandwidth_workfn);
 	wb->dirty_sleep = jiffies;
 
 	err = fprop_local_init_percpu(&wb->completions, gfp);
@@ -351,6 +360,7 @@ static void wb_shutdown(struct bdi_write
 	mod_delayed_work(bdi_wq, &wb->dwork, 0);
 	flush_delayed_work(&wb->dwork);
 	WARN_ON(!list_empty(&wb->work_list));
+	flush_delayed_work(&wb->bw_dwork);
 }
 
 static void wb_exit(struct bdi_writeback *wb)
--- a/mm/page-writeback.c~writeback-fix-bandwidth-estimate-for-spiky-workload
+++ a/mm/page-writeback.c
@@ -1336,18 +1336,19 @@ static void __wb_update_bandwidth(struct
 {
 	struct bdi_writeback *wb = gdtc->wb;
 	unsigned long now = jiffies;
-	unsigned long elapsed = now - wb->bw_time_stamp;
+	unsigned long elapsed;
 	unsigned long dirtied;
 	unsigned long written;
 
-	lockdep_assert_held(&wb->list_lock);
+	spin_lock(&wb->list_lock);
 
 	/*
-	 * rate-limit, only update once every 200ms.
+	 * Lockless checks for elapsed time are racy and delayed update after
+	 * IO completion doesn't do it at all (to make sure written pages are
+	 * accounted reasonably quickly). Make sure elapsed >= 1 to avoid
+	 * division errors.
 	 */
-	if (elapsed < BANDWIDTH_INTERVAL)
-		return;
-
+	elapsed = max(now - wb->bw_time_stamp, 1UL);
 	dirtied = percpu_counter_read(&wb->stat[WB_DIRTIED]);
 	written = percpu_counter_read(&wb->stat[WB_WRITTEN]);
 
@@ -1369,15 +1370,14 @@ static void __wb_update_bandwidth(struct
 	wb->dirtied_stamp = dirtied;
 	wb->written_stamp = written;
 	wb->bw_time_stamp = now;
+	spin_unlock(&wb->list_lock);
 }
 
-static void wb_update_bandwidth(struct bdi_writeback *wb)
+void wb_update_bandwidth(struct bdi_writeback *wb)
 {
 	struct dirty_throttle_control gdtc = { GDTC_INIT(wb) };
 
-	spin_lock(&wb->list_lock);
 	__wb_update_bandwidth(&gdtc, NULL, false);
-	spin_unlock(&wb->list_lock);
 }
 
 /* Interval after which we consider wb idle and don't estimate bandwidth */
@@ -1722,11 +1722,8 @@ free_running:
 			wb->dirty_exceeded = 1;
 
 		if (time_is_before_jiffies(wb->bw_time_stamp +
-					   BANDWIDTH_INTERVAL)) {
-			spin_lock(&wb->list_lock);
+					   BANDWIDTH_INTERVAL))
 			__wb_update_bandwidth(gdtc, mdtc, true);
-			spin_unlock(&wb->list_lock);
-		}
 
 		/* throttle according to the chosen dtc */
 		dirty_ratelimit = wb->dirty_ratelimit;
@@ -2374,7 +2371,13 @@ int do_writepages(struct address_space *
 		cond_resched();
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	}
-	wb_update_bandwidth(wb);
+	/*
+	 * Usually few pages are written by now from those we've just submitted
+	 * but if there's constant writeback being submitted, this makes sure
+	 * writeback bandwidth is updated once in a while.
+	 */
+	if (time_is_before_jiffies(wb->bw_time_stamp + BANDWIDTH_INTERVAL))
+		wb_update_bandwidth(wb);
 	return ret;
 }
 
@@ -2754,6 +2757,14 @@ static void wb_inode_writeback_start(str
 static void wb_inode_writeback_end(struct bdi_writeback *wb)
 {
 	atomic_dec(&wb->writeback_inodes);
+	/*
+	 * Make sure estimate of writeback throughput gets updated after
+	 * writeback completed. We delay the update by BANDWIDTH_INTERVAL
+	 * (which is the interval other bandwidth updates use for batching) so
+	 * that if multiple inodes end writeback at a similar time, they get
+	 * batched into one bandwidth update.
+	 */
+	queue_delayed_work(bdi_wq, &wb->bw_dwork, BANDWIDTH_INTERVAL);
 }
 
 int test_clear_page_writeback(struct page *page)
_

Patches currently in -mm which might be from jack@suse.cz are


