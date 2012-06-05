From: akpm@linux-foundation.org
Subject: + umem-fix-up-unplugging.patch added to -mm tree
Date: Tue, 05 Jun 2012 16:23:23 -0700
Message-ID: <20120605232324.069B3A0297@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:44838 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab2FEXXY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 19:23:24 -0400
Received: by yenl3 with SMTP id l3so655622yen.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 16:23:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glorioustao@gmail.com, Tao.Guo@emc.com, axboe@kernel.dk, neilb@suse.de, stable@vger.kernel.org


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
Subject: Subject: umem: fix up unplugging

Patches currently in -mm which might be from glorioustao@gmail.com are

block-move-general-unplug-callback-function-from-md-raid-to-blk-core.patch
umem-fix-up-unplugging.patch

