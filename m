From: akpm@linux-foundation.org
Subject: [to-be-updated] umem-fix-up-unplugging.patch removed from -mm tree
Date: Wed, 23 May 2012 13:34:41 -0700
Message-ID: <20120523203442.49676A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:39379 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2EWUen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 16:34:43 -0400
Received: by ghbz15 with SMTP id z15so191709ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 13:34:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glorioustao@gmail.com, Tao.Guo@emc.com, axboe@kernel.dk, neilb@suse.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: umem: fix up unplugging
has been removed from the -mm tree.  Its filename was
     umem-fix-up-unplugging.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Tao Guo <glorioustao@gmail.com>
Subject: umem: fix up unplugging

Fix a regression introduced by 7eaceaccab5f40 ("block: remove per-queue
plugging").  In that patch, Jens removed the whole mm_unplug_device()
function, which used to be the trigger to make umem start to work.

We need to implement unplugging to make umem start to work, or I/O
will never be triggered.

Signed-off-by: Tao Guo <Tao.Guo@emc.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/umem.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff -puN drivers/block/umem.c~umem-fix-up-unplugging drivers/block/umem.c
--- a/drivers/block/umem.c~umem-fix-up-unplugging
+++ a/drivers/block/umem.c
@@ -111,7 +111,8 @@ struct cardinfo {
 	int		current_idx;
 	sector_t	current_sector;
 
-	struct request_queue *queue;
+	struct request_queue	*queue;
+	struct blk_plug_cb	plug_cb;
 
 	struct mm_page {
 		dma_addr_t		page_dma;
@@ -513,6 +514,33 @@ static void process_page(unsigned long d
 	}
 }
 
+static void mm_unplug(struct blk_plug_cb *cb)
+{
+	struct cardinfo *card = container_of(cb, struct cardinfo, plug_cb);
+
+	spin_lock_irq(&card->lock);
+	activate(card);
+	spin_unlock_irq(&card->lock);
+}
+
+int mm_check_plugged(struct cardinfo *card)
+{
+	struct blk_plug *plug = current->plug;
+	struct cardinfo *c;
+
+	if (!plug)
+		return 0;
+
+	list_for_each_entry(c, &plug->cb_list, plug_cb.list) {
+		if (c == card)
+			return 1;
+	}
+
+	/* set up unplug callback */
+	list_add(&card->plug_cb.list, &plug->cb_list);
+	return 1;
+}
+
 static void mm_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct cardinfo *card = q->queuedata;
@@ -523,6 +551,8 @@ static void mm_make_request(struct reque
 	*card->biotail = bio;
 	bio->bi_next = NULL;
 	card->biotail = &bio->bi_next;
+	if (bio->bi_rw & REQ_SYNC || !mm_check_plugged(card))
+		activate(card);
 	spin_unlock_irq(&card->lock);
 
 	return;
@@ -884,6 +914,7 @@ static int __devinit mm_pci_probe(struct
 	blk_queue_make_request(card->queue, mm_make_request);
 	card->queue->queue_lock = &card->lock;
 	card->queue->queuedata = card;
+	card->plug_cb.callback = mm_unplug;
 
 	tasklet_init(&card->tasklet, process_page, (unsigned long)card);
 
_

Patches currently in -mm which might be from glorioustao@gmail.com are


