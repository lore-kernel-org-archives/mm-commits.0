From: akpm@linux-foundation.org
Subject: + rapidio-tsi721_dma-fix-hardware-error-handling.patch added to
 -mm tree
Date: Mon, 08 Feb 2016 13:22:53 -0800
Message-ID: <56b9072d.AO4ttu9FJ/4mQtKv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbcBHVWy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721_dma: fix hardware error handling
has been added to the -mm tree.  Its filename is
     rapidio-tsi721_dma-fix-hardware-error-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721_dma-fix-hardware-error-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721_dma-fix-hardware-error-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721_dma: fix hardware error handling

Add DMA channel re-initialization after an error to avoid termination
of all pending transfer requests.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Reported-by: Barry Wood <barry.wood@idt.com>
Tested-by: Barry Wood <barry.wood@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721_dma.c |   82 ++++++++++++++++++++++---
 1 file changed, 73 insertions(+), 9 deletions(-)

diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-fix-hardware-error-handling drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-fix-hardware-error-handling
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -282,7 +282,7 @@ void tsi721_bdma_handler(struct tsi721_b
 	/* Disable BDMA channel interrupts */
 	iowrite32(0, bdma_chan->regs + TSI721_DMAC_INTE);
 	if (bdma_chan->active)
-		tasklet_schedule(&bdma_chan->tasklet);
+		tasklet_hi_schedule(&bdma_chan->tasklet);
 }
 
 #ifdef CONFIG_PCI_MSI
@@ -298,7 +298,7 @@ static irqreturn_t tsi721_bdma_msix(int
 	struct tsi721_bdma_chan *bdma_chan = ptr;
 
 	if (bdma_chan->active)
-		tasklet_schedule(&bdma_chan->tasklet);
+		tasklet_hi_schedule(&bdma_chan->tasklet);
 	return IRQ_HANDLED;
 }
 #endif /* CONFIG_PCI_MSI */
@@ -584,13 +584,71 @@ static void tsi721_dma_tasklet(unsigned
 	iowrite32(dmac_int, bdma_chan->regs + TSI721_DMAC_INT);
 
 	if (dmac_int & TSI721_DMAC_INT_ERR) {
+		int i = 10000;
+		struct tsi721_tx_desc *desc;
+
+		desc = bdma_chan->active_tx;
 		dmac_sts = ioread32(bdma_chan->regs + TSI721_DMAC_STS);
 		tsi_err(&bdma_chan->dchan.dev->device,
-			"ERR - DMAC%d_STS = 0x%x",
-			bdma_chan->id, dmac_sts);
+			"DMAC%d_STS = 0x%x did=%d raddr=0x%llx",
+			bdma_chan->id, dmac_sts, desc->destid, desc->rio_addr);
+
+		/* Re-initialize DMA channel if possible */
+
+		if ((dmac_sts & TSI721_DMAC_STS_ABORT) == 0)
+			goto err_out;
+
+		tsi721_clr_stat(bdma_chan);
 
 		spin_lock(&bdma_chan->lock);
+
+		/* Put DMA channel into init state */
+		iowrite32(TSI721_DMAC_CTL_INIT,
+			  bdma_chan->regs + TSI721_DMAC_CTL);
+		do {
+			udelay(1);
+			dmac_sts = ioread32(bdma_chan->regs + TSI721_DMAC_STS);
+			i--;
+		} while ((dmac_sts & TSI721_DMAC_STS_ABORT) && i);
+
+		if (dmac_sts & TSI721_DMAC_STS_ABORT) {
+			tsi_err(&bdma_chan->dchan.dev->device,
+				"Failed to re-initiate DMAC%d",	bdma_chan->id);
+			spin_unlock(&bdma_chan->lock);
+			goto err_out;
+		}
+
+		/* Setup DMA descriptor pointers */
+		iowrite32(((u64)bdma_chan->bd_phys >> 32),
+			bdma_chan->regs + TSI721_DMAC_DPTRH);
+		iowrite32(((u64)bdma_chan->bd_phys & TSI721_DMAC_DPTRL_MASK),
+			bdma_chan->regs + TSI721_DMAC_DPTRL);
+
+		/* Setup descriptor status FIFO */
+		iowrite32(((u64)bdma_chan->sts_phys >> 32),
+			bdma_chan->regs + TSI721_DMAC_DSBH);
+		iowrite32(((u64)bdma_chan->sts_phys & TSI721_DMAC_DSBL_MASK),
+			bdma_chan->regs + TSI721_DMAC_DSBL);
+		iowrite32(TSI721_DMAC_DSSZ_SIZE(bdma_chan->sts_size),
+			bdma_chan->regs + TSI721_DMAC_DSSZ);
+
+		/* Clear interrupt bits */
+		iowrite32(TSI721_DMAC_INT_ALL,
+			bdma_chan->regs + TSI721_DMAC_INT);
+
+		ioread32(bdma_chan->regs + TSI721_DMAC_INT);
+
+		bdma_chan->wr_count = bdma_chan->wr_count_next = 0;
+		bdma_chan->sts_rdptr = 0;
+		udelay(10);
+
+		desc = bdma_chan->active_tx;
+		desc->status = DMA_ERROR;
+		dma_cookie_complete(&desc->txd);
+		list_add(&desc->desc_node, &bdma_chan->free_list);
 		bdma_chan->active_tx = NULL;
+		if (bdma_chan->active)
+			tsi721_advance_work(bdma_chan, NULL);
 		spin_unlock(&bdma_chan->lock);
 	}
 
@@ -619,16 +677,19 @@ static void tsi721_dma_tasklet(unsigned
 			}
 			list_add(&desc->desc_node, &bdma_chan->free_list);
 			bdma_chan->active_tx = NULL;
-			tsi721_advance_work(bdma_chan, NULL);
+			if (bdma_chan->active)
+				tsi721_advance_work(bdma_chan, NULL);
 			spin_unlock(&bdma_chan->lock);
 			if (callback)
 				callback(param);
 		} else {
-			tsi721_advance_work(bdma_chan, bdma_chan->active_tx);
+			if (bdma_chan->active)
+				tsi721_advance_work(bdma_chan,
+						    bdma_chan->active_tx);
 			spin_unlock(&bdma_chan->lock);
 		}
 	}
-
+err_out:
 	/* Re-Enable BDMA channel interrupts */
 	iowrite32(TSI721_DMAC_INT_ALL, bdma_chan->regs + TSI721_DMAC_INTE);
 }
@@ -841,7 +902,6 @@ static int tsi721_terminate_all(struct d
 {
 	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
 	struct tsi721_tx_desc *desc, *_d;
-	u32 dmac_int;
 	LIST_HEAD(list);
 
 	tsi_debug(DMA, &dchan->dev->device, "DMAC%d", bdma_chan->id);
@@ -850,7 +910,10 @@ static int tsi721_terminate_all(struct d
 
 	bdma_chan->active = false;
 
-	if (!tsi721_dma_is_idle(bdma_chan)) {
+	while (!tsi721_dma_is_idle(bdma_chan)) {
+
+		udelay(5);
+#if (0)
 		/* make sure to stop the transfer */
 		iowrite32(TSI721_DMAC_CTL_SUSP,
 			  bdma_chan->regs + TSI721_DMAC_CTL);
@@ -859,6 +922,7 @@ static int tsi721_terminate_all(struct d
 		do {
 			dmac_int = ioread32(bdma_chan->regs + TSI721_DMAC_INT);
 		} while ((dmac_int & TSI721_DMAC_INT_SUSP) == 0);
+#endif
 	}
 
 	if (bdma_chan->active_tx)
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-tsi721-fix-hardcoded-mrrs-setting.patch
rapidio-tsi721-add-check-for-overlapped-ib-window-mappings.patch
rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window.patch
rapidio-tsi721_dma-fix-pending-transaction-queue-handling.patch
rapidio-add-query_mport-operation.patch
rapidio-tsi721-add-query_mport-callback.patch
rapidio-add-shutdown-notification-for-rapidio-devices.patch
rapidio-tsi721-add-shutdown-notification-callback.patch
rapidio-rionet-add-shutdown-event-handling.patch
rapidio-rework-common-rio-device-add-delete-routines.patch
rapidio-move-net-allocation-into-core-code.patch
rapidio-add-core-mport-removal-support.patch
rapidio-tsi721-add-hw-specific-mport-removal.patch
powerpc-fsl_rio-changes-to-mport-registration.patch
rapidio-rionet-add-locking-into-add-remove-device.patch
rapidio-rionet-add-mport-removal-handling.patch
rapidio-add-lock-protection-for-doorbell-list.patch
rapidio-move-rio_local_set_device_id-function-to-the-common-core.patch
rapidio-move-rio_pw_enable-into-core-code.patch
rapidio-add-global-inbound-port-write-interfaces.patch
rapidio-tsi721-fix-locking-in-ob_msg-processing.patch
rapidio-add-outbound-window-support.patch
rapidio-tsi721-add-outbound-windows-mapping-support.patch
rapidio-tsi721-add-filtered-debug-output.patch
rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch
rapidio-tsi721_dma-fix-synchronization-issues.patch
rapidio-tsi721_dma-fix-hardware-error-handling.patch
rapidio-add-mport-char-device-driver.patch

