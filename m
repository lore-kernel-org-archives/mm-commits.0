From: akpm@linux-foundation.org
Subject: [merged] cciss-remove-no-longer-needed-sendcmd-reject-processing-code.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:56:25 -0700
Message-ID: <200906101756.n5AHuPhp008488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047AbZFJR4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:56:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: remove no longer needed sendcmd reject processing code
has been removed from the -mm tree.  Its filename was
     cciss-remove-no-longer-needed-sendcmd-reject-processing-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: remove no longer needed sendcmd reject processing code
From: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

Now that the cciss SCSI error handling routines operate with interrupts
enabled, we no longer need to maintain the list of command completions
that sendcmd() might inadvertantly scoop up, since now it only runs at
driver init time, and there won't be any other commands for it to scoop
up.  So we can remove that list and the code that adds to it and processes
it.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   98 +---------------------------------------
 drivers/block/cciss.h |    9 ---
 2 files changed, 3 insertions(+), 104 deletions(-)

diff -puN drivers/block/cciss.c~cciss-remove-no-longer-needed-sendcmd-reject-processing-code drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-remove-no-longer-needed-sendcmd-reject-processing-code
+++ a/drivers/block/cciss.c
@@ -2612,51 +2612,6 @@ static unsigned long pollcomplete(int ct
 	return 1;
 }
 
-static int add_sendcmd_reject(__u8 cmd, int ctlr, unsigned long complete)
-{
-	/* We get in here if sendcmd() is polling for completions
-	   and gets some command back that it wasn't expecting --
-	   something other than that which it just sent down.
-	   Ordinarily, that shouldn't happen, but it can happen when
-	   the scsi tape stuff gets into error handling mode, and
-	   starts using sendcmd() to try to abort commands and
-	   reset tape drives.  In that case, sendcmd may pick up
-	   completions of commands that were sent to logical drives
-	   through the block i/o system, or cciss ioctls completing, etc.
-	   In that case, we need to save those completions for later
-	   processing by the interrupt handler.
-	 */
-
-#ifdef CONFIG_CISS_SCSI_TAPE
-	struct sendcmd_reject_list *srl = &hba[ctlr]->scsi_rejects;
-
-	/* If it's not the scsi tape stuff doing error handling, (abort */
-	/* or reset) then we don't expect anything weird. */
-	if (cmd != CCISS_RESET_MSG && cmd != CCISS_ABORT_MSG) {
-#endif
-		printk(KERN_WARNING "cciss cciss%d: SendCmd "
-		       "Invalid command list address returned! (%lx)\n",
-		       ctlr, complete);
-		/* not much we can do. */
-#ifdef CONFIG_CISS_SCSI_TAPE
-		return 1;
-	}
-
-	/* We've sent down an abort or reset, but something else
-	   has completed */
-	if (srl->ncompletions >= (hba[ctlr]->nr_cmds + 2)) {
-		/* Uh oh.  No room to save it for later... */
-		printk(KERN_WARNING "cciss%d: Sendcmd: Invalid command addr, "
-		       "reject list overflow, command lost!\n", ctlr);
-		return 1;
-	}
-	/* Save it for later */
-	srl->complete[srl->ncompletions] = complete;
-	srl->ncompletions++;
-#endif
-	return 0;
-}
-
 /* Send command c to controller h and poll for it to complete.
  * Turns interrupts off on the board.  Used at driver init time
  * and during SCSI error recovery.
@@ -2701,11 +2656,10 @@ resend_cmd1:
 			break;
 		}
 
-		/* If it's not the cmd we're looking for, save it for later */
+		/* Make sure it's the command we're expecting. */
 		if ((complete & ~CISS_ERROR_BIT) != c->busaddr) {
-			if (add_sendcmd_reject(c->Request.CDB[0],
-				h->ctlr, complete) != 0)
-				BUG(); /* we are hosed if we get here. */
+			printk(KERN_WARNING "cciss%d: Unexpected command "
+				"completion.\n", h->ctlr);
 			continue;
 		}
 
@@ -2770,11 +2724,6 @@ resend_cmd1:
 	buff_dma_handle.val32.upper = c->SG[0].Addr.upper;
 	pci_unmap_single(h->pdev, (dma_addr_t) buff_dma_handle.val,
 			 c->SG[0].Len, PCI_DMA_BIDIRECTIONAL);
-#ifdef CONFIG_CISS_SCSI_TAPE
-	/* if we saved some commands for later, process them now. */
-	if (h->scsi_rejects.ncompletions > 0)
-		do_cciss_intr(0, h);
-#endif
 	return status;
 }
 
@@ -3195,44 +3144,18 @@ startio:
 
 static inline unsigned long get_next_completion(ctlr_info_t *h)
 {
-#ifdef CONFIG_CISS_SCSI_TAPE
-	/* Any rejects from sendcmd() lying around? Process them first */
-	if (h->scsi_rejects.ncompletions == 0)
-		return h->access.command_completed(h);
-	else {
-		struct sendcmd_reject_list *srl;
-		int n;
-		srl = &h->scsi_rejects;
-		n = --srl->ncompletions;
-		/* printk("cciss%d: processing saved reject\n", h->ctlr); */
-		printk("p");
-		return srl->complete[n];
-	}
-#else
 	return h->access.command_completed(h);
-#endif
 }
 
 static inline int interrupt_pending(ctlr_info_t *h)
 {
-#ifdef CONFIG_CISS_SCSI_TAPE
-	return (h->access.intr_pending(h)
-		|| (h->scsi_rejects.ncompletions > 0));
-#else
 	return h->access.intr_pending(h);
-#endif
 }
 
 static inline long interrupt_not_for_us(ctlr_info_t *h)
 {
-#ifdef CONFIG_CISS_SCSI_TAPE
-	return (((h->access.intr_pending(h) == 0) ||
-		 (h->interrupts_enabled == 0))
-		&& (h->scsi_rejects.ncompletions == 0));
-#else
 	return (((h->access.intr_pending(h) == 0) ||
 		 (h->interrupts_enabled == 0)));
-#endif
 }
 
 static irqreturn_t do_cciss_intr(int irq, void *dev_id)
@@ -4054,15 +3977,6 @@ static int __devinit cciss_init_one(stru
 		printk(KERN_ERR "cciss: out of memory");
 		goto clean4;
 	}
-#ifdef CONFIG_CISS_SCSI_TAPE
-	hba[i]->scsi_rejects.complete =
-	    kmalloc(sizeof(hba[i]->scsi_rejects.complete[0]) *
-		    (hba[i]->nr_cmds + 5), GFP_KERNEL);
-	if (hba[i]->scsi_rejects.complete == NULL) {
-		printk(KERN_ERR "cciss: out of memory");
-		goto clean4;
-	}
-#endif
 	spin_lock_init(&hba[i]->lock);
 
 	/* Initialize the pdev driver private data.
@@ -4122,9 +4036,6 @@ static int __devinit cciss_init_one(stru
 
 clean4:
 	kfree(inq_buff);
-#ifdef CONFIG_CISS_SCSI_TAPE
-	kfree(hba[i]->scsi_rejects.complete);
-#endif
 	kfree(hba[i]->cmd_pool_bits);
 	if (hba[i]->cmd_pool)
 		pci_free_consistent(hba[i]->pdev,
@@ -4242,9 +4153,6 @@ static void __devexit cciss_remove_one(s
 	pci_free_consistent(hba[i]->pdev, hba[i]->nr_cmds * sizeof(ErrorInfo_struct),
 			    hba[i]->errinfo_pool, hba[i]->errinfo_pool_dhandle);
 	kfree(hba[i]->cmd_pool_bits);
-#ifdef CONFIG_CISS_SCSI_TAPE
-	kfree(hba[i]->scsi_rejects.complete);
-#endif
 	/*
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
diff -puN drivers/block/cciss.h~cciss-remove-no-longer-needed-sendcmd-reject-processing-code drivers/block/cciss.h
--- a/drivers/block/cciss.h~cciss-remove-no-longer-needed-sendcmd-reject-processing-code
+++ a/drivers/block/cciss.h
@@ -53,14 +53,6 @@ typedef struct _drive_info_struct
 	char rev[REV_LEN + 1];       /* SCSI revision string */
 } drive_info_struct;
 
-#ifdef CONFIG_CISS_SCSI_TAPE
-
-struct sendcmd_reject_list {
-	int ncompletions;
-	unsigned long *complete; /* array of NR_CMDS tags */
-};
