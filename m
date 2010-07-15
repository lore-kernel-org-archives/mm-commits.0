From: akpm@linux-foundation.org
Subject: + mmc_block-add-support-for-secure-discard.patch added to -mm tree
Date: Thu, 15 Jul 2010 12:26:19 -0700
Message-ID: <201007151926.o6FJQKGL014724__12152.0589026206$1279222049$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934522Ab0GOT1H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jul 2010 15:27:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, axboe@kernel.dk, bengardiner@nanometrics.ca, hch@lst.de, kmpark@infradead.org, linux-mmc@vger.kernel.org, madhu.cr@ti.com


The patch titled
     mmc_block: add support for secure discard
has been added to the -mm tree.  Its filename is
     mmc_block-add-support-for-secure-discard.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc_block: add support for secure discard
From: Adrian Hunter <adrian.hunter@nokia.com>

Secure discard is implemented by Secure Trim if the discard is unaligned
or Secure Erase otherwise.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kyungmin Park <kmpark@infradead.org>
Cc: Madhusudhan Chikkature <madhu.cr@ti.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/block.c |   46 ++++++++++++++++++++++++++++++++++---
 drivers/mmc/card/queue.c |    3 ++
 2 files changed, 46 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/card/block.c~mmc_block-add-support-for-secure-discard drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc_block-add-support-for-secure-discard
+++ a/drivers/mmc/card/block.c
@@ -280,6 +280,42 @@ out:
 	return err ? 0 : 1;
 }
 
+static int mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
+				       struct request *req)
+{
+	struct mmc_blk_data *md = mq->data;
+	struct mmc_card *card = md->queue.card;
+	unsigned int from, nr, arg;
+	int err = 0;
+
+	mmc_claim_host(card->host);
+
+	if (!mmc_can_secure_erase_trim(card)) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	from = blk_rq_pos(req);
+	nr = blk_rq_sectors(req);
+
+	if (mmc_can_trim(card) && !mmc_erase_group_aligned(card, from, nr))
+		arg = MMC_SECURE_TRIM1_ARG;
+	else
+		arg = MMC_SECURE_ERASE_ARG;
+
+	err = mmc_erase(card, from, nr, arg);
+	if (!err && arg == MMC_SECURE_TRIM1_ARG)
+		err = mmc_erase(card, from, nr, MMC_SECURE_TRIM2_ARG);
+out:
+	spin_lock_irq(&md->lock);
+	__blk_end_request(req, err, blk_rq_bytes(req));
+	spin_unlock_irq(&md->lock);
+
+	mmc_release_host(card->host);
+
+	return err ? 0 : 1;
+}
+
 static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 {
 	struct mmc_blk_data *md = mq->data;
@@ -510,10 +546,14 @@ static int mmc_blk_issue_rw_rq(struct mm
 
 static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 {
-	if (req->cmd_flags & REQ_DISCARD)
-		return mmc_blk_issue_discard_rq(mq, req);
-	else
+	if (req->cmd_flags & REQ_DISCARD) {
+		if (req->cmd_flags & REQ_SECURE)
+			return mmc_blk_issue_secdiscard_rq(mq, req);
+		else
+			return mmc_blk_issue_discard_rq(mq, req);
+	} else {
 		return mmc_blk_issue_rw_rq(mq, req);
+	}
 }
 
 static inline int mmc_blk_readonly(struct mmc_card *card)
diff -puN drivers/mmc/card/queue.c~mmc_block-add-support-for-secure-discard drivers/mmc/card/queue.c
--- a/drivers/mmc/card/queue.c~mmc_block-add-support-for-secure-discard
+++ a/drivers/mmc/card/queue.c
@@ -141,6 +141,9 @@ int mmc_init_queue(struct mmc_queue *mq,
 			mq->queue->limits.discard_alignment =
 							card->erase_size << 9;
 		}
+		if (mmc_can_secure_erase_trim(card))
+			queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD,
+						mq->queue);
 	}
 
 #ifdef CONFIG_MMC_BLOCK_BOUNCE
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

linux-next.patch
mmc-recognize-csd-structure.patch
mmc-recognize-csd-structure-fix.patch
mmc-split-mmc_sd_init_card.patch
mmc-implement-sd-combo-iomem-support.patch
mmc-omap-fix-for-bus-width-which-improves-sd-cards-peformance.patch
sdio-allow-non-standard-sdio-cards.patch
omap_hsmmc-add-init_card-pass-through-callback.patch
omap-pandora-pass-wl1251-information-to-sdio-core.patch
mmc-add-erase-secure-erase-trim-and-secure-trim-operations.patch
mmc_block-add-discard-support.patch
omap_hsmmc-add-erase-capability.patch
block-add-secure-discard.patch
mmc_block-add-support-for-secure-discard.patch

