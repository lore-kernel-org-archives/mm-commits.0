From: akpm@linux-foundation.org
Subject: + memstick-add-start-and-stop-methods-to-memstick-device.patch added to -mm tree
Date: Sun, 08 Jun 2008 14:30:11 -0700
Message-ID: <200806082130.m58LUBWG021327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755604AbYFHVaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 17:30:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oakad@yahoo.com


The patch titled
     memstick: add "start" and "stop" methods to memstick device
has been added to the -mm tree.  Its filename is
     memstick-add-start-and-stop-methods-to-memstick-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: add "start" and "stop" methods to memstick device
From: Alex Dubov <oakad@yahoo.com>

In some cases it may be desirable to ensure that associated driver is not
going to access the media in some period of time.  "start" and "stop"
methods are provided therefore to allow it.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c    |   11 ++++++--
 drivers/memstick/core/mspro_block.c |   33 ++++++++++++++++++++++++++
 include/linux/memstick.h            |    4 +++
 3 files changed, 45 insertions(+), 3 deletions(-)

diff -puN drivers/memstick/core/memstick.c~memstick-add-start-and-stop-methods-to-memstick-device drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-add-start-and-stop-methods-to-memstick-device
+++ a/drivers/memstick/core/memstick.c
@@ -432,8 +432,11 @@ static void memstick_check(struct work_s
 
 	dev_dbg(&host->dev, "memstick_check started\n");
 	mutex_lock(&host->lock);
-	if (!host->card)
-		memstick_power_on(host);
+	if (!host->card) {
+		if (memstick_power_on(host))
+			goto out_power_off;
+	} else
+		host->card->stop(host->card);
 
 	card = memstick_alloc_card(host);
 
@@ -451,7 +454,8 @@ static void memstick_check(struct work_s
 			    || !(host->card->check(host->card))) {
 				device_unregister(&host->card->dev);
 				host->card = NULL;
-			}
+			} else
+				host->card->start(host->card);
 		}
 
 		if (!host->card) {
@@ -464,6 +468,7 @@ static void memstick_check(struct work_s
 			kfree(card);
 	}
 
+out_power_off:
 	if (!host->card)
 		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
 
diff -puN drivers/memstick/core/mspro_block.c~memstick-add-start-and-stop-methods-to-memstick-device drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-add-start-and-stop-methods-to-memstick-device
+++ a/drivers/memstick/core/mspro_block.c
@@ -752,6 +752,37 @@ static int mspro_block_has_request(struc
 	return rc;
 }
 
+static void mspro_block_stop(struct memstick_dev *card)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	int rc = 0;
+	unsigned long flags;
+
+	while (1) {
+		spin_lock_irqsave(&msb->q_lock, flags);
+		if (!msb->has_request) {
+			blk_stop_queue(msb->queue);
+			rc = 1;
+		}
+		spin_unlock_irqrestore(&msb->q_lock, flags);
+
+		if (rc)
+			break;
+
+		wait_for_completion(&card->mrq_complete);
+	}
+}
+
+static void mspro_block_start(struct memstick_dev *card)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	unsigned long flags;
+
+	spin_lock_irqsave(&msb->q_lock, flags);
+	blk_start_queue(msb->queue);
+	spin_unlock_irqrestore(&msb->q_lock, flags);
+}
+
 static int mspro_block_queue_thread(void *data)
 {
 	struct memstick_dev *card = data;
@@ -1272,6 +1303,8 @@ static int mspro_block_probe(struct mems
 	rc = mspro_block_init_disk(card);
 	if (!rc) {
 		card->check = mspro_block_check_card;
+		card->stop = mspro_block_stop;
+		card->start = mspro_block_start;
 		return 0;
 	}
 
diff -puN include/linux/memstick.h~memstick-add-start-and-stop-methods-to-memstick-device include/linux/memstick.h
--- a/include/linux/memstick.h~memstick-add-start-and-stop-methods-to-memstick-device
+++ a/include/linux/memstick.h
@@ -263,6 +263,10 @@ struct memstick_dev {
 	/* Get next request from the media driver.                         */
 	int                      (*next_request)(struct memstick_dev *card,
 						 struct memstick_request **mrq);
+	/* Tell the media driver to stop doing things                      */
+	void                     (*stop)(struct memstick_dev *card);
+	/* Allow the media driver to continue                              */
+	void                     (*start)(struct memstick_dev *card);
 
 	struct device            dev;
 };
_

Patches currently in -mm which might be from oakad@yahoo.com are

memstick-allow-set_param-method-to-return-an-error-code.patch
memstick-add-start-and-stop-methods-to-memstick-device.patch
revert-linux-next-changes-to-make-memstick-use-fully-asynchronous-request-processing-apply.patch
memstick-use-fully-asynchronous-request-processing.patch
revert-revert-linux-next-changes-to-make-memstick-use-fully-asynchronous-request-processing-apply.patch

