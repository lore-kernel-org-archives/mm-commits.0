From: akpm@linux-foundation.org
Subject: - cfq-iosched-fix-queue-depth-detection.patch removed from -mm tree
Date: Tue, 02 Sep 2008 13:41:53 -0700
Message-ID: <200809022041.m82KfrkX011670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbYIBUmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 16:42:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaronc@gelato.unsw.edu.au, mm-commits@vger.kernel.org


The patch titled
     cfq-iosched: fix queue depth detection
has been removed from the -mm tree.  Its filename was
     cfq-iosched-fix-queue-depth-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cfq-iosched: fix queue depth detection
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>

CFQ's detection of queueing devices assumes a non-queuing device and
detects if the queue depth reaches a certain threshold.  Under some
workloads (e.g.  synchronous reads), CFQ effectively forces a unit queue
depth, thus defeating the detection logic.  This leads to poor performance
on queuing hardware, since the idle window remains enabled.

This patch inverts the sense of the logic: assume a queuing-capable
device, and detect if the depth does not exceed the threshold.

Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cfq-iosched.c |   47 +++++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 9 deletions(-)

diff -puN block/cfq-iosched.c~cfq-iosched-fix-queue-depth-detection block/cfq-iosched.c
--- a/block/cfq-iosched.c~cfq-iosched-fix-queue-depth-detection
+++ a/block/cfq-iosched.c
@@ -39,6 +39,7 @@ static int cfq_slice_idle = HZ / 125;
 #define CFQ_MIN_TT		(2)
 
 #define CFQ_SLICE_SCALE		(5)
+#define CFQ_HW_QUEUE_MIN	(5)
 
 #define RQ_CIC(rq)		\
 	((struct cfq_io_context *) (rq)->elevator_private)
@@ -86,7 +87,14 @@ struct cfq_data {
 
 	int rq_in_driver;
 	int sync_flight;
+
+	/*
+	 * queue-depth detection
+	 */
+	int rq_queued;
 	int hw_tag;
+	int hw_tag_samples;
+	int rq_in_driver_peak;
 
 	/*
 	 * idle window management
@@ -654,15 +662,6 @@ static void cfq_activate_request(struct 
 	cfq_log_cfqq(cfqd, RQ_CFQQ(rq), "activate rq, drv=%d",
 						cfqd->rq_in_driver);
 
-	/*
-	 * If the depth is larger 1, it really could be queueing. But lets
-	 * make the mark a little higher - idling could still be good for
-	 * low queueing, and a low queueing number could also just indicate
-	 * a SCSI mid layer like behaviour where limit+1 is often seen.
-	 */
-	if (!cfqd->hw_tag && cfqd->rq_in_driver > 4)
-		cfqd->hw_tag = 1;
-
 	cfqd->last_position = rq->hard_sector + rq->hard_nr_sectors;
 }
 
@@ -686,6 +685,7 @@ static void cfq_remove_request(struct re
 	list_del_init(&rq->queuelist);
 	cfq_del_rq_rb(rq);
 
+	cfqq->cfqd->rq_queued--;
 	if (rq_is_meta(rq)) {
 		WARN_ON(!cfqq->meta_pending);
 		cfqq->meta_pending--;
@@ -1833,6 +1833,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
 {
 	struct cfq_io_context *cic = RQ_CIC(rq);
 
+	cfqd->rq_queued++;
 	if (rq_is_meta(rq))
 		cfqq->meta_pending++;
 
@@ -1880,6 +1881,31 @@ static void cfq_insert_request(struct re
 	cfq_rq_enqueued(cfqd, cfqq, rq);
 }
 
+/*
+ * Update hw_tag based on peak queue depth over 50 samples under
+ * sufficient load.
+ */
+static void cfq_update_hw_tag(struct cfq_data *cfqd)
+{
+	if (cfqd->rq_in_driver > cfqd->rq_in_driver_peak)
+		cfqd->rq_in_driver_peak = cfqd->rq_in_driver;
+
+	if (cfqd->rq_queued <= CFQ_HW_QUEUE_MIN &&
+	    cfqd->rq_in_driver <= CFQ_HW_QUEUE_MIN)
+		return;
+
+	if (cfqd->hw_tag_samples++ < 50)
+		return;
+
+	if (cfqd->rq_in_driver_peak >= CFQ_HW_QUEUE_MIN)
+		cfqd->hw_tag = 1;
+	else
+		cfqd->hw_tag = 0;
+
+	cfqd->hw_tag_samples = 0;
+	cfqd->rq_in_driver_peak = 0;
+}
+
 static void cfq_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
@@ -1890,6 +1916,8 @@ static void cfq_completed_request(struct
 	now = jiffies;
 	cfq_log_cfqq(cfqd, cfqq, "complete");
 
+	cfq_update_hw_tag(cfqd);
+
 	WARN_ON(!cfqd->rq_in_driver);
 	WARN_ON(!cfqq->dispatched);
 	cfqd->rq_in_driver--;
@@ -2200,6 +2228,7 @@ static void *cfq_init_queue(struct reque
 	cfqd->cfq_slice[1] = cfq_slice_sync;
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
+	cfqd->hw_tag = 1;
 
 	return cfqd;
 }
_

Patches currently in -mm which might be from aaronc@gelato.unsw.edu.au are

linux-next.patch

