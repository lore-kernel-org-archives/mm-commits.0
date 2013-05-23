From: akpm@linux-foundation.org
Subject: [to-be-updated] virtio-blk-convert-to-batch-completion.patch
 removed from -mm tree
Date: Thu, 23 May 2013 13:50:32 -0700
Message-ID: <519e8118.ZJOynbPZZpboT7a9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759370Ab3EWUud (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 16:50:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zab@redhat.com, viro@zeniv.linux.org.uk, tytso@mit.edu, smani@micron.com, sbradshaw@micron.com, rusty@rustcorp.com.au, mfasheh@suse.com, jmoyer@redhat.com, jlbec@evilplan.org, gregkh@linuxfoundation.org, bcrl@kvack.org, balbi@ti.com, axboe@kernel.dk, asamymuthupa@micron.com, koverstreet@google.com

Subject: [to-be-updated] virtio-blk-convert-to-batch-completion.patch removed from -mm tree
To: koverstreet@google.com,asamymuthupa@micron.com,axboe@kernel.dk,balbi@ti.com,bcrl@kvack.org,gregkh@linuxfoundation.org,jlbec@evilplan.org,jmoyer@redhat.com,mfasheh@suse.com,rusty@rustcorp.com.au,sbradshaw@micron.com,smani@micron.com,tytso@mit.edu,viro@zeniv.linux.org.uk,zab@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 13:50:32 -0700


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
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/virtio_blk.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff -puN drivers/block/virtio_blk.c~virtio-blk-convert-to-batch-completion drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c~virtio-blk-convert-to-batch-completion
+++ a/drivers/block/virtio_blk.c
@@ -217,7 +217,8 @@ static void virtblk_bio_send_flush_work(
 	virtblk_bio_send_flush(vbr);
 }
 
-static inline void virtblk_request_done(struct virtblk_req *vbr)
+static inline void virtblk_request_done(struct virtblk_req *vbr,
+					struct batch_complete *batch)
 {
 	struct virtio_blk *vblk = vbr->vblk;
 	struct request *req = vbr->req;
@@ -231,11 +232,12 @@ static inline void virtblk_request_done(
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
 
@@ -244,12 +246,13 @@ static inline void virtblk_bio_flush_don
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
 
@@ -259,17 +262,18 @@ static inline void virtblk_bio_data_done
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
@@ -279,16 +283,19 @@ static void virtblk_done(struct virtqueu
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
@@ -298,6 +305,8 @@ static void virtblk_done(struct virtqueu
 		blk_start_queue(vblk->disk->queue);
 	spin_unlock_irqrestore(vblk->disk->queue->queue_lock, flags);
 
+	batch_complete(&batch);
+
 	if (bio_done)
 		wake_up(&vblk->queue_wait);
 }
_

Patches currently in -mm which might be from koverstreet@google.com are

linux-next.patch
mtip32xx-convert-to-batch-completion.patch
aio-convert-the-ioctx-list-to-radix-tree.patch

