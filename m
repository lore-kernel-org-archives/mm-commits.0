From: akpm@linux-foundation.org
Subject: [merged] umem-fix-up-unplugging.patch removed from -mm tree
Date: Fri, 08 Jun 2012 12:41:43 -0700
Message-ID: <20120608194143.63618A022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:44261 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933251Ab2FHTlp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 15:41:45 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so125162lag.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 12:41:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glorioustao@gmail.com, Tao.Guo@emc.com, axboe@kernel.dk, neilb@suse.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: umem: fix up unplugging
has been removed from the -mm tree.  Its filename was
     umem-fix-up-unplugging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Tao Guo <glorioustao@gmail.com>
Subject: umem: fix up unplugging

In 7eaceaccab5f40bbf ("block: remove per-queue plugging"), Jens removed
the whole mm_unplug_device() function, which used to be the trigger to
make umem start to work.

We need to implement unplugging to make umem start to work, or I/O will
never be triggered.

Signed-off-by: Tao Guo <Tao.Guo@emc.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/umem.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/block/umem.c~umem-fix-up-unplugging drivers/block/umem.c
--- a/drivers/block/umem.c~umem-fix-up-unplugging
+++ a/drivers/block/umem.c
@@ -513,6 +513,15 @@ static void process_page(unsigned long d
 	}
 }
 
+static void mm_unplug(struct blk_plug_cb *cb)
+{
+	struct cardinfo *card = cb->q->queuedata;
+
+	spin_lock_irq(&card->lock);
+	activate(card);
+	spin_unlock_irq(&card->lock);
+}
+
 static void mm_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct cardinfo *card = q->queuedata;
@@ -523,6 +532,8 @@ static void mm_make_request(struct reque
 	*card->biotail = bio;
 	bio->bi_next = NULL;
 	card->biotail = &bio->bi_next;
+	if (bio->bi_rw & REQ_SYNC || !blk_check_plugged(q, mm_unplug))
+		activate(card);
 	spin_unlock_irq(&card->lock);
 
 	return;
_

Patches currently in -mm which might be from glorioustao@gmail.com are

linux-next.patch

