From: akpm@linux-foundation.org
Subject: [to-be-updated] virtio-blk-convert-to-batch-completion.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:29:14 -0700
Message-ID: <20130321222914.A330931C299@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45491 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830Ab3CUW3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:29:16 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so22553qcs.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:29:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: virtio-blk: convert to batch completion
has been removed from the -mm tree.  Its filename was
     virtio-blk-convert-to-batch-completion.patch

This patch was dropped because an updated version will be merged

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
Cc: Theodore Ts'o <tytso@mit.edu>
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

mtip32xx-convert-to-batch-completion.patch
aio-fix-aio_read_events_ring-types.patch
aio-document-clarify-aio_read_events-and-shadow_tail.patch
aio-correct-calculation-of-available-events.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch

