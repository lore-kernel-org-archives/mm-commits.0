From: akpm@linux-foundation.org
Subject: + virtio-blk-convert-to-batch-completion.patch added to -mm tree
Date: Thu, 03 Jan 2013 15:41:45 -0800
Message-ID: <20130103234146.C724D20006C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:34162 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab3ACXlv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 18:41:51 -0500
Received: by mail-la0-f74.google.com with SMTP id ej20so394892lab.5
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 15:41:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: virtio-blk: convert to batch completion
has been added to the -mm tree.  Its filename is
     virtio-blk-convert-to-batch-completion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: virtio-blk: convert to batch completion

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/virtio_blk.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff -puN drivers/block/virtio_blk.c~virtio-blk-convert-to-batch-completion drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c~virtio-blk-convert-to-batch-completion
+++ a/drivers/block/virtio_blk.c
@@ -210,7 +210,8 @@ static void virtblk_bio_send_flush_work(
 	virtblk_bio_send_flush(vbr);
 }
 
-static inline void virtblk_request_done(struct virtblk_req *vbr)
+static inline void virtblk_request_done(struct virtblk_req *vbr,
+					struct batch_complete *batch)
 {
 	struct virtio_blk *vblk = vbr->vblk;
 	struct request *req = vbr->req;
@@ -224,11 +225,12 @@ static inline void virtblk_request_done(
 		req->errors = (error != 0);
 	}
 
-	__blk_end_request_all(req, error);
+	blk_end_request_all_batch(req, error, batch);
 	mempool_free(vbr, vblk->pool);
 }
 
-static inline void virtblk_bio_flush_done(struct virtblk_req *vbr)
+static inline void virtblk_bio_flush_done(struct virtblk_req *vbr,
+					  struct batch_complete *batch)
 {
 	struct virtio_blk *vblk = vbr->vblk;
 
@@ -237,12 +239,13 @@ static inline void virtblk_bio_flush_don
 		INIT_WORK(&vbr->work, virtblk_bio_send_data_work);
 		queue_work(virtblk_wq, &vbr->work);
 	} else {
-		bio_endio(vbr->bio, virtblk_result(vbr));
+		bio_endio_batch(vbr->bio, virtblk_result(vbr), batch);
 		mempool_free(vbr, vblk->pool);
 	}
 }
 
-static inline void virtblk_bio_data_done(struct virtblk_req *vbr)
+static inline void virtblk_bio_data_done(struct virtblk_req *vbr,
+					 struct batch_complete *batch)
 {
 	struct virtio_blk *vblk = vbr->vblk;
 
@@ -252,17 +255,18 @@ static inline void virtblk_bio_data_done
 		INIT_WORK(&vbr->work, virtblk_bio_send_flush_work);
 		queue_work(virtblk_wq, &vbr->work);
 	} else {
-		bio_endio(vbr->bio, virtblk_result(vbr));
+		bio_endio_batch(vbr->bio, virtblk_result(vbr), batch);
 		mempool_free(vbr, vblk->pool);
 	}
 }
 
-static inline void virtblk_bio_done(struct virtblk_req *vbr)
+static inline void virtblk_bio_done(struct virtblk_req *vbr,
+				    struct batch_complete *batch)
 {
 	if (unlikely(vbr->flags & VBLK_IS_FLUSH))
-		virtblk_bio_flush_done(vbr);
+		virtblk_bio_flush_done(vbr, batch);
 	else
-		virtblk_bio_data_done(vbr);
+		virtblk_bio_data_done(vbr, batch);
 }
 
 static void virtblk_done(struct virtqueue *vq)
@@ -272,16 +276,19 @@ static void virtblk_done(struct virtqueu
 	struct virtblk_req *vbr;
 	unsigned long flags;
 	unsigned int len;
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	spin_lock_irqsave(vblk->disk->queue->queue_lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
 		while ((vbr = virtqueue_get_buf(vblk->vq, &len)) != NULL) {
 			if (vbr->bio) {
-				virtblk_bio_done(vbr);
+				virtblk_bio_done(vbr, &batch);
 				bio_done = true;
 			} else {
-				virtblk_request_done(vbr);
+				virtblk_request_done(vbr, &batch);
 				req_done = true;
 			}
 		}
@@ -291,6 +298,8 @@ static void virtblk_done(struct virtqueu
 		blk_start_queue(vblk->disk->queue);
 	spin_unlock_irqrestore(vblk->disk->queue->queue_lock, flags);
 
+	batch_complete(&batch);
+
 	if (bio_done)
 		wake_up(&vblk->queue_wait);
 }
_

Patches currently in -mm which might be from koverstreet@google.com are

mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-smoosh-struct-kiocb.patch

