From: akpm@linux-foundation.org
Subject: + umem-fix-up-unplugging.patch added to -mm tree
Date: Wed, 04 Apr 2012 14:48:03 -0700
Message-ID: <20120404214803.D5FFFA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:43430 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757137Ab2DDVsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 17:48:05 -0400
Received: by qcsp5 with SMTP id p5so97867qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 14:48:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glorioustao@gmail.com, Tao.Guo@emc.com, axboe@kernel.dk, neilb@suse.de


The patch titled
     Subject: umem: fix up unplugging
has been added to the -mm tree.  Its filename is
     umem-fix-up-unplugging.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tao Guo <glorioustao@gmail.com>
Subject: umem: fix up unplugging

We need to implement unplugging to make umem start to work, or I/O
will never be triggered.

Signed-off-by: Tao Guo <Tao.Guo@emc.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
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
Subject: Subject: umem: fix up unplugging

Patches currently in -mm which might be from glorioustao@gmail.com are

umem-fix-up-unplugging.patch

