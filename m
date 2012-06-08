From: akpm@linux-foundation.org
Subject: [merged] block-move-general-unplug-callback-function-from-md-raid-to-blk-core.patch removed from -mm tree
Date: Fri, 08 Jun 2012 12:41:41 -0700
Message-ID: <20120608194141.61577A022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:48722 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251Ab2FHTlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 15:41:42 -0400
Received: by mail-vc0-f202.google.com with SMTP id fl13so203777vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 12:41:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glorioustao@gmail.com, Tao.Guo@emc.com, axboe@kernel.dk, neilb@suse.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: block: move general unplug callback function from md/raid to blk-core
has been removed from the -mm tree.  Its filename was
     block-move-general-unplug-callback-function-from-md-raid-to-blk-core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Tao Guo <glorioustao@gmail.com>
Subject: block: move general unplug callback function from md/raid to blk-core

Other components may also require an unplug callback, so move this
function from md/raid to block generic layer.

Signed-off-by: Tao Guo <Tao.Guo@emc.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c       |   36 ++++++++++++++++++++++++++-
 block/blk-settings.c   |    1 
 block/blk.h            |    1 
 drivers/md/md.c        |   51 +++------------------------------------
 drivers/md/md.h        |    3 --
 drivers/md/raid1.c     |    2 -
 drivers/md/raid5.c     |    4 +--
 include/linux/blkdev.h |    8 +++++-
 8 files changed, 51 insertions(+), 55 deletions(-)

diff -puN block/blk-core.c~block-move-general-unplug-callback-function-from-md-raid-to-blk-core block/blk-core.c
--- a/block/blk-core.c~block-move-general-unplug-callback-function-from-md-raid-to-blk-core
+++ a/block/blk-core.c
@@ -2840,6 +2840,39 @@ void blk_start_plug(struct blk_plug *plu
 }
 EXPORT_SYMBOL(blk_start_plug);
 
+/* Check that an unplug wakeup will come shortly.
+ */
+bool blk_check_plugged(struct request_queue *q, plug_cb_fn cb_fn)
+{
+	struct blk_plug *plug = current->plug;
+	struct blk_plug_cb *cb;
+
+	if (!plug)
+		return false;
+
+	list_for_each_entry(cb, &plug->cb_list, list) {
+		if (cb->cb_fn == cb_fn && cb->q == q) {
+			/* Already on the list, move to top */
+			if (cb != list_first_entry(&plug->cb_list,
+						    struct blk_plug_cb,
+						    list))
+				list_move(&cb->list, &plug->cb_list);
+			return true;
+		}
+	}
+	/* Not currently on the callback list */
+	cb = kmalloc(sizeof(*cb), GFP_ATOMIC);
+	if (!cb)
+		return false;
+
+	cb->q = q;
+	cb->cb_fn = cb_fn;
+	atomic_inc(&q->plug_cnt);
+	list_add(&cb->list, &plug->cb_list);
+	return true;
+}
+EXPORT_SYMBOL(blk_check_plugged);
+
 static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
 {
 	struct request *rqa = container_of(a, struct request, queuelist);
@@ -2897,7 +2930,8 @@ static void flush_plug_callbacks(struct 
 							  struct blk_plug_cb,
 							  list);
 		list_del(&cb->list);
-		cb->callback(cb);
+		cb->cb_fn(cb);
+		kfree(cb);
 	}
 }
 
diff -puN block/blk-settings.c~block-move-general-unplug-callback-function-from-md-raid-to-blk-core block/blk-settings.c
--- a/block/blk-settings.c~block-move-general-unplug-callback-function-from-md-raid-to-blk-core
+++ a/block/blk-settings.c
@@ -181,6 +181,7 @@ void blk_queue_make_request(struct reque
 	blk_queue_dma_alignment(q, 511);
 	blk_queue_congestion_threshold(q);
 	q->nr_batching = BLK_BATCH_REQ;
+	atomic_set(&q->plug_cnt, 0);
 
 	blk_set_default_limits(&q->limits);
 
diff -puN block/blk.h~block-move-general-unplug-callback-function-from-md-raid-to-blk-core block/blk.h
--- a/block/blk.h~block-move-general-unplug-callback-function-from-md-raid-to-blk-core
+++ a/block/blk.h
@@ -33,7 +33,6 @@ bool __blk_end_bidi_request(struct reque
 void blk_rq_timed_out_timer(unsigned long data);
 void blk_delete_timer(struct request *);
 void blk_add_timer(struct request *);
-void __generic_unplug_device(struct request_queue *);
 
 /*
  * Internal atomic flags for request handling
diff -puN drivers/md/md.c~block-move-general-unplug-callback-function-from-md-raid-to-blk-core drivers/md/md.c
--- a/drivers/md/md.c~block-move-general-unplug-callback-function-from-md-raid-to-blk-core
+++ a/drivers/md/md.c
@@ -498,25 +498,11 @@ void md_flush_request(struct mddev *mdde
 }
 EXPORT_SYMBOL(md_flush_request);
 
-/* Support for plugging.
- * This mirrors the plugging support in request_queue, but does not
- * require having a whole queue or request structures.
- * We allocate an md_plug_cb for each md device and each thread it gets
- * plugged on.  This links tot the private plug_handle structure in the
- * personality data where we keep a count of the number of outstanding
- * plugs so other code can see if a plug is active.
- */
-struct md_plug_cb {
-	struct blk_plug_cb cb;
-	struct mddev *mddev;
-};
-
-static void plugger_unplug(struct blk_plug_cb *cb)
+static void mddev_unplug(struct blk_plug_cb *cb)
 {
-	struct md_plug_cb *mdcb = container_of(cb, struct md_plug_cb, cb);
-	if (atomic_dec_and_test(&mdcb->mddev->plug_cnt))
-		md_wakeup_thread(mdcb->mddev->thread);
-	kfree(mdcb);
+	struct mddev *mddev = cb->q->queuedata;
+	if (atomic_dec_and_test(&cb->q->plug_cnt))
+		md_wakeup_thread(mddev->thread);
 }
 
 /* Check that an unplug wakeup will come shortly.
@@ -524,33 +510,7 @@ static void plugger_unplug(struct blk_pl
  */
 int mddev_check_plugged(struct mddev *mddev)
 {
-	struct blk_plug *plug = current->plug;
-	struct md_plug_cb *mdcb;
-
-	if (!plug)
-		return 0;
-
-	list_for_each_entry(mdcb, &plug->cb_list, cb.list) {
-		if (mdcb->cb.callback == plugger_unplug &&
-		    mdcb->mddev == mddev) {
-			/* Already on the list, move to top */
-			if (mdcb != list_first_entry(&plug->cb_list,
-						    struct md_plug_cb,
-						    cb.list))
-				list_move(&mdcb->cb.list, &plug->cb_list);
-			return 1;
-		}
-	}
-	/* Not currently on the callback list */
-	mdcb = kmalloc(sizeof(*mdcb), GFP_ATOMIC);
-	if (!mdcb)
-		return 0;
-
-	mdcb->mddev = mddev;
-	mdcb->cb.callback = plugger_unplug;
-	atomic_inc(&mddev->plug_cnt);
-	list_add(&mdcb->cb.list, &plug->cb_list);
-	return 1;
+	return blk_check_plugged(mddev->queue, mddev_unplug);
 }
 EXPORT_SYMBOL_GPL(mddev_check_plugged);
 
@@ -602,7 +562,6 @@ void mddev_init(struct mddev *mddev)
 	atomic_set(&mddev->active, 1);
 	atomic_set(&mddev->openers, 0);
 	atomic_set(&mddev->active_io, 0);
-	atomic_set(&mddev->plug_cnt, 0);
 	spin_lock_init(&mddev->write_lock);
 	atomic_set(&mddev->flush_pending, 0);
 	init_waitqueue_head(&mddev->sb_wait);
diff -puN drivers/md/md.h~block-move-general-unplug-callback-function-from-md-raid-to-blk-core drivers/md/md.h
--- a/drivers/md/md.h~block-move-general-unplug-callback-function-from-md-raid-to-blk-core
+++ a/drivers/md/md.h
@@ -266,9 +266,6 @@ struct mddev {
 	int				new_chunk_sectors;
 	int				reshape_backwards;
 
-	atomic_t			plug_cnt;	/* If device is expecting
-							 * more bios soon.
-							 */
 	struct md_thread		*thread;	/* management thread */
 	struct md_thread		*sync_thread;	/* doing resync or reconstruct */
 	sector_t			curr_resync;	/* last block scheduled */
diff -puN drivers/md/raid1.c~block-move-general-unplug-callback-function-from-md-raid-to-blk-core drivers/md/raid1.c
--- a/drivers/md/raid1.c~block-move-general-unplug-callback-function-from-md-raid-to-blk-core
+++ a/drivers/md/raid1.c
@@ -2170,7 +2170,7 @@ static void raid1d(struct mddev *mddev)
 	blk_start_plug(&plug);
 	for (;;) {
 
-		if (atomic_read(&mddev->plug_cnt) == 0)
+		if (atomic_read(&mddev->queue->plug_cnt) == 0)
 			flush_pending_writes(conf);
 
 		spin_lock_irqsave(&conf->device_lock, flags);
diff -puN drivers/md/raid5.c~block-move-general-unplug-callback-function-from-md-raid-to-blk-core drivers/md/raid5.c
--- a/drivers/md/raid5.c~block-move-general-unplug-callback-function-from-md-raid-to-blk-core
+++ a/drivers/md/raid5.c
@@ -4521,7 +4521,7 @@ static void raid5d(struct mddev *mddev)
 	while (1) {
 		struct bio *bio;
 
-		if (atomic_read(&mddev->plug_cnt) == 0 &&
+		if (atomic_read(&mddev->queue->plug_cnt) == 0 &&
 		    !list_empty(&conf->bitmap_list)) {
 			/* Now is a good time to flush some bitmap updates */
 			conf->seq_flush++;
@@ -4531,7 +4531,7 @@ static void raid5d(struct mddev *mddev)
 			conf->seq_write = conf->seq_flush;
 			activate_bit_delay(conf);
 		}
-		if (atomic_read(&mddev->plug_cnt) == 0)
+		if (atomic_read(&mddev->queue->plug_cnt) == 0)
 			raid5_activate_delayed(conf);
 
 		while ((bio = remove_bio_from_retry(conf))) {
diff -puN include/linux/blkdev.h~block-move-general-unplug-callback-function-from-md-raid-to-blk-core include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-move-general-unplug-callback-function-from-md-raid-to-blk-core
+++ a/include/linux/blkdev.h
@@ -316,6 +316,9 @@ struct request_queue {
 	 * ll_rw_blk doesn't touch it.
 	 */
 	void			*queuedata;
+	atomic_t		plug_cnt;	/* If device is expecting
+						 * more bios soon.
+						 */
 
 	/*
 	 * various queue flags, see QUEUE_* below
@@ -914,12 +917,15 @@ struct blk_plug {
 
 struct blk_plug_cb {
 	struct list_head list;
-	void (*callback)(struct blk_plug_cb *);
+	struct request_queue *q;
+	void (*cb_fn)(struct blk_plug_cb *);
 };
+typedef void (plug_cb_fn) (struct blk_plug_cb *cb);
 
 extern void blk_start_plug(struct blk_plug *);
 extern void blk_finish_plug(struct blk_plug *);
 extern void blk_flush_plug_list(struct blk_plug *, bool);
+extern bool blk_check_plugged(struct request_queue *q, plug_cb_fn cb_fn);
 
 static inline void blk_flush_plug(struct task_struct *tsk)
 {
_

Patches currently in -mm which might be from glorioustao@gmail.com are

linux-next.patch

