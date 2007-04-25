From: akpm@linux-foundation.org
Subject: - cfq-debugging-stuff.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:37:37 -0700
Message-ID: <200704252037.l3PKbbDP012200@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993111AbXDYUhn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:37:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cfq debugging stuff
has been removed from the -mm tree.  Its filename was
     cfq-debugging-stuff.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: cfq debugging stuff
From: Jens Axboe <jens.axboe@oracle.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cfq-iosched.c |    7 +++++++
 block/ll_rw_blk.c   |    2 ++
 2 files changed, 9 insertions(+)

diff -puN block/cfq-iosched.c~cfq-debugging-stuff block/cfq-iosched.c
--- a/block/cfq-iosched.c~cfq-debugging-stuff
+++ a/block/cfq-iosched.c
@@ -645,12 +645,15 @@ static void cfq_remove_request(struct re
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 
+	WARN_ON_ONCE(!irqs_disabled());
 	if (cfqq->next_rq == rq)
 		cfqq->next_rq = cfq_find_next_rq(cfqq->cfqd, cfqq, rq);
 
 	list_del_init(&rq->queuelist);
 	cfq_del_rq_rb(rq);
 
+	WARN_ON_ONCE(!cfqq->next_rq && !RB_EMPTY_ROOT(&cfqq->sort_list));
+
 	if (rq_is_meta(rq)) {
 		WARN_ON(!cfqq->meta_pending);
 		cfqq->meta_pending--;
@@ -1257,6 +1260,8 @@ static void cfq_exit_single_io_context(s
 {
 	struct cfq_data *cfqd = cic->key;
 
+	WARN_ON_ONCE(irqs_disabled());
+
 	if (cfqd) {
 		request_queue_t *q = cfqd->queue;
 
@@ -1736,6 +1741,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
 	/*
 	 * check if this request is a better next-serve candidate)) {
 	 */
+	WARN_ON_ONCE(!irqs_disabled());
 	cfqq->next_rq = cfq_choose_req(cfqd, cfqq->next_rq, rq);
 	BUG_ON(!cfqq->next_rq);
 
@@ -2054,6 +2060,7 @@ static void cfq_exit_queue(elevator_t *e
 
 	cfq_shutdown_timer_wq(cfqd);
 
+	WARN_ON_ONCE(irqs_disabled());
 	spin_lock_irq(q->queue_lock);
 
 	if (cfqd->active_queue)
diff -puN block/ll_rw_blk.c~cfq-debugging-stuff block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~cfq-debugging-stuff
+++ a/block/ll_rw_blk.c
@@ -1602,6 +1602,8 @@ EXPORT_SYMBOL(__generic_unplug_device);
  **/
 void generic_unplug_device(request_queue_t *q)
 {
+	WARN_ON_ONCE(irqs_disabled());
+
 	spin_lock_irq(q->queue_lock);
 	__generic_unplug_device(q);
 	spin_unlock_irq(q->queue_lock);
_

Patches currently in -mm which might be from jens.axboe@oracle.com are

origin.patch
packet-fix-error-handling.patch
use-unchecked_isa_dma-in-sd_revalidate_disk.patch
git-block.patch
uml-batch-i-o-requests.patch
as-fix-antic_expire-check.patch
cciss-reformat-error-handling.patch
cciss-add-sg_io-ioctl-to-cciss.patch
cciss-set-rq-errors-more-correctly-in-driver.patch
lguest-the-block-driver.patch
cfq-debugging-stuff.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-oldcd.patch
