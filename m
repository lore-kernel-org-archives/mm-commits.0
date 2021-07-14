Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829DEC07E95
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B18D613A9
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbhGNBQt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237198AbhGNBQt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Jul 2021 21:16:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B234561374;
        Wed, 14 Jul 2021 01:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626225237;
        bh=g2k19iesuYAD5eYIN3ynhNC24TOV4xoXJSPJcYdUlTk=;
        h=Date:From:To:Subject:From;
        b=TJ0f+6DymI0xFQIVs9/fCl7zQ5hnUYg4psB5z3OXtS+uJ6xPbbYQUuN3QPp9fqCLL
         jrF7THTaIb9ePSoh9iN6lSx3llXCyQSlcDYISysX69P6zj3dHOyszD1uZXJ93uHLT3
         4dGikXTEBDlnrc8BOMcvG4XQGreM+hP3dWr1QjBY=
Date:   Tue, 13 Jul 2021 18:13:57 -0700
From:   akpm@linux-foundation.org
To:     fengguang.wu@intel.com, jack@suse.cz, mm-commits@vger.kernel.org,
        stapelberg+linux@google.com
Subject:  +
 writeback-fix-bandwidth-estimate-for-spiky-workload.patch added to -mm tree
Message-ID: <20210714011357.CteH19Pmo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: fix bandwidth estimate for spiky workload
has been added to the -mm tree.  Its filename is
     writeback-fix-bandwidth-estimate-for-spiky-workload.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-fix-bandwidth-estimate-for-spiky-workload.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-fix-bandwidth-estimate-for-spiky-workload.patch

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
 mm/backing-dev.c                 |   10 ++++++++
 mm/page-writeback.c              |   35 +++++++++++++++--------------
 4 files changed, 31 insertions(+), 16 deletions(-)

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
@@ -1340,14 +1340,7 @@ static void __wb_update_bandwidth(struct
 	unsigned long dirtied;
 	unsigned long written;
 
-	lockdep_assert_held(&wb->list_lock);
-
-	/*
-	 * rate-limit, only update once every 200ms.
-	 */
-	if (elapsed < BANDWIDTH_INTERVAL)
-		return;
-
+	spin_lock(&wb->list_lock);
 	dirtied = percpu_counter_read(&wb->stat[WB_DIRTIED]);
 	written = percpu_counter_read(&wb->stat[WB_WRITTEN]);
 
@@ -1369,15 +1362,14 @@ static void __wb_update_bandwidth(struct
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
@@ -1722,11 +1714,8 @@ free_running:
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
@@ -2374,7 +2363,13 @@ int do_writepages(struct address_space *
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
 
@@ -2754,6 +2749,14 @@ static void wb_inode_writeback_start(str
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

writeback-track-number-of-inodes-under-writeback.patch
writeback-reliably-update-bandwidth-estimation.patch
writeback-fix-bandwidth-estimate-for-spiky-workload.patch
writeback-rename-domain_update_bandwidth.patch
writeback-use-read_once-for-unlocked-reads-of-writeback-stats.patch

