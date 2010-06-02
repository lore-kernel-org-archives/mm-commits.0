From: akpm@linux-foundation.org
Subject: + cciss-enqueue-and-submit-io.patch added to -mm tree
Date: Wed, 02 Jun 2010 12:57:58 -0700
Message-ID: <201006021957.o52Jvwrq013703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932897Ab0FBT6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 15:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, jens.axboe@oracle.com, scameron@beardog.cce.hp.com


The patch titled
     cciss: enqueue and submit io
has been added to the -mm tree.  Its filename is
     cciss-enqueue-and-submit-io.patch

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
Subject: cciss: enqueue and submit io
From: Mike Miller <mike.miller@hp.com>

Clean up some code where we subit our io.  The same 5 lines appeared
several times.  Also helps for a following patch.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff -puN drivers/block/cciss.c~cciss-enqueue-and-submit-io drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-enqueue-and-submit-io
+++ a/drivers/block/cciss.c
@@ -257,6 +257,17 @@ static inline void removeQ(CommandList_s
 	hlist_del_init(&c->list);
 }
 
+static void enqueue_cmd_and_start_io(ctlr_info_t *h,
+	CommandList_struct *c)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&h->lock, flags);
+	addQ(&h->reqQ, c);
+	h->Qdepth++;
+	start_io(h);
+	spin_unlock_irqrestore(&h->lock, flags);
+}
+
 static void cciss_free_sg_chain_blocks(SGDescriptor_struct **cmd_sg_list,
 	int nr_cmds)
 {
@@ -1377,7 +1388,6 @@ static int cciss_ioctl(struct block_devi
 			CommandList_struct *c;
 			char *buff = NULL;
 			u64bit temp64;
-			unsigned long flags;
 			DECLARE_COMPLETION_ONSTACK(wait);
 
 			if (!arg)
@@ -1449,13 +1459,7 @@ static int cciss_ioctl(struct block_devi
 			}
 			c->waiting = &wait;
 
-			/* Put the request on the tail of the request queue */
-			spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-			addQ(&host->reqQ, c);
-			host->Qdepth++;
-			start_io(host);
-			spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
-
+			enqueue_cmd_and_start_io(host, c);
 			wait_for_completion(&wait);
 
 			/* unlock the buffers from DMA */
@@ -1495,7 +1499,6 @@ static int cciss_ioctl(struct block_devi
 			unsigned char **buff = NULL;
 			int *buff_size = NULL;
 			u64bit temp64;
-			unsigned long flags;
 			BYTE sg_used = 0;
 			int status = 0;
 			int i;
@@ -1602,12 +1605,7 @@ static int cciss_ioctl(struct block_devi
 				}
 			}
 			c->waiting = &wait;
-			/* Put the request on the tail of the request queue */
-			spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-			addQ(&host->reqQ, c);
-			host->Qdepth++;
-			start_io(host);
-			spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
+			enqueue_cmd_and_start_io(host, c);
 			wait_for_completion(&wait);
 			/* unlock the buffers from DMA */
 			for (i = 0; i < sg_used; i++) {
@@ -1729,8 +1727,8 @@ static void cciss_softirq_done(struct re
 	CommandList_struct *cmd = rq->completion_data;
 	ctlr_info_t *h = hba[cmd->ctlr];
 	SGDescriptor_struct *curr_sg = cmd->SG;
-	unsigned long flags;
 	u64bit temp64;
+	unsigned long flags;
 	int i, ddir;
 	int sg_index = 0;
 
@@ -2679,17 +2677,11 @@ static int sendcmd_withirq_core(ctlr_inf
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	u64bit buff_dma_handle;
-	unsigned long flags;
 	int return_status = IO_OK;
 
 resend_cmd2:
 	c->waiting = &wait;
-	/* Put the request on the tail of the queue and send it */
-	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
-	addQ(&h->reqQ, c);
-	h->Qdepth++;
-	start_io(h);
-	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	enqueue_cmd_and_start_io(h, c);
 
 	wait_for_completion(&wait);
 
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-enqueue-and-submit-io.patch
cciss-clean-up-interrupt-handler.patch
cciss-check-for-msi-in-interrupt_not_for_us.patch
cciss-make-interrupt-access-methods-return-type-bool.patch
cciss-add-performant-mode-support-for-stars-sirius.patch
cciss-new-controller-support-and-bump-driver-version.patch

