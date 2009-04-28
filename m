From: akpm@linux-foundation.org
Subject: [alternative-merged] diskstats-fix-discard-request-accounting.patch removed from -mm tree
Date: Tue, 28 Apr 2009 12:24:44 -0700
Message-ID: <200904281924.n3SJOiel020423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756157AbZD1T2S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 15:28:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: knikanth@suse.de, dwmw2@infradead.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     diskstats: fix discard request accounting
has been removed from the -mm tree.  Its filename was
     diskstats-fix-discard-request-accounting.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: diskstats: fix discard request accounting
From: Nikanth Karthikesan <knikanth@suse.de>

When 2 discard requests are merged, the stats gets updated, but we do not
update statistics normally when a discard request is issued or completed. 
For example the in_flight counter would be decremented when 2 discard
requests are merged, but it was not at all incremented when they were
issued, and in_flight counter will not be decremented, when they are
completed as well.

This patch fixes this by adding discard requests to the statistics.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c       |    4 ++--
 include/linux/blkdev.h |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN block/blk-core.c~diskstats-fix-discard-request-accounting block/blk-core.c
--- a/block/blk-core.c~diskstats-fix-discard-request-accounting
+++ a/block/blk-core.c
@@ -68,7 +68,7 @@ static void drive_stat_acct(struct reque
 	int rw = rq_data_dir(rq);
 	int cpu;
 
-	if (!blk_fs_request(rq) || !blk_do_io_stat(rq))
+	if (!rq_accountable(rq) || !blk_do_io_stat(rq))
 		return;
 
 	cpu = part_stat_lock();
@@ -1700,7 +1700,7 @@ static void blk_account_io_done(struct r
 	 * IO on queueing nor completion.  Accounting the containing
 	 * request is enough.
 	 */
-	if (blk_fs_request(req) && req != &req->q->bar_rq) {
+	if (rq_accountable(req) && req != &req->q->bar_rq) {
 		unsigned long duration = jiffies - req->start_time;
 		const int rw = rq_data_dir(req);
 		struct hd_struct *part;
diff -puN include/linux/blkdev.h~diskstats-fix-discard-request-accounting include/linux/blkdev.h
--- a/include/linux/blkdev.h~diskstats-fix-discard-request-accounting
+++ a/include/linux/blkdev.h
@@ -670,7 +670,9 @@ static inline void blk_clear_queue_full(
 	(REQ_NOMERGE | REQ_STARTED | REQ_HARDBARRIER | REQ_SOFTBARRIER)
 #define rq_mergeable(rq)	\
 	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
-	 (blk_discard_rq(rq) || blk_fs_request((rq))))
+	 (blk_discard_rq(rq) || blk_fs_request(rq)))
+#define rq_accountable(rq)	\
+	(blk_discard_rq(rq) || blk_fs_request(rq))
 
 /*
  * q->prep_rq_fn return values
_

Patches currently in -mm which might be from knikanth@suse.de are

linux-next.patch
diskstats-fix-discard-request-accounting.patch
block-turn-some-buggy-macros-into-c-functions.patch

