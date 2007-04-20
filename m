From: akpm@linux-foundation.org
Subject: + cfq-debugging-stuff.patch added to -mm tree
Date: Thu, 19 Apr 2007 20:36:14 -0700
Message-ID: <200704200336.l3K3aEZv006088@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbXDTDgT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 23:36:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jens.axboe@oracle.com


The patch titled
     cfq debugging stuff
has been added to the -mm tree.  Its filename is
     cfq-debugging-stuff.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -586,12 +586,15 @@ static void cfq_remove_request(struct re
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
@@ -1298,6 +1301,8 @@ static void cfq_exit_single_io_context(s
 {
 	struct cfq_data *cfqd = cic->key;
 
+	WARN_ON_ONCE(irqs_disabled());
+
 	if (cfqd) {
 		request_queue_t *q = cfqd->queue;
 
@@ -1766,6 +1771,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
 	/*
 	 * check if this request is a better next-serve candidate)) {
 	 */
+	WARN_ON_ONCE(!irqs_disabled());
 	cfqq->next_rq = cfq_choose_req(cfqd, cfqq->next_rq, rq);
 	BUG_ON(!cfqq->next_rq);
 
@@ -2093,6 +2099,7 @@ static void cfq_exit_queue(elevator_t *e
 
 	cfq_shutdown_timer_wq(cfqd);
 
+	WARN_ON_ONCE(irqs_disabled());
 	spin_lock_irq(q->queue_lock);
 
 	if (cfqd->active_queue)
diff -puN block/ll_rw_blk.c~cfq-debugging-stuff block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~cfq-debugging-stuff
+++ a/block/ll_rw_blk.c
@@ -1603,6 +1603,8 @@ EXPORT_SYMBOL(__generic_unplug_device);
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
