From: akpm@linux-foundation.org
Subject: + rapidio-tsi721_dma-fix-synchronization-issues.patch added to
 -mm tree
Date: Mon, 08 Feb 2016 13:22:51 -0800
Message-ID: <56b9072b.EpUju8y7VGsnyZ3g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbcBHVWw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721_dma: fix synchronization issues
has been added to the -mm tree.  Its filename is
     rapidio-tsi721_dma-fix-synchronization-issues.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721_dma-fix-synchronization-issues.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721_dma-fix-synchronization-issues.patch

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
Subject: rapidio/tsi721_dma: fix synchronization issues

Fix synchronization issues found during testing using multiple DMA
transfer requests to the same channel:
- lost MSI-X interrupt notifications
- non-synchronized attempts to start DMA channel HW resulting in error
  message from the driver
- cookie tracking/update race conditions resulting in incorrect DMA
  transfer status report

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Reported-by: Barry Wood <barry.wood@idt.com>
Tested-by: Barry Wood <barry.wood@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721_dma.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-fix-synchronization-issues drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-fix-synchronization-issues
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -84,7 +84,7 @@ static int tsi721_bdma_ch_init(struct ts
 	 */
 	bd_ptr = dma_zalloc_coherent(dev,
 				(bd_num + 1) * sizeof(struct tsi721_dma_desc),
-				&bd_phys, GFP_KERNEL);
+				&bd_phys, GFP_ATOMIC);
 	if (!bd_ptr)
 		return -ENOMEM;
 
@@ -102,7 +102,7 @@ static int tsi721_bdma_ch_init(struct ts
 	sts_size = roundup_pow_of_two(sts_size);
 	sts_ptr = dma_zalloc_coherent(dev,
 				     sts_size * sizeof(struct tsi721_dma_sts),
-				     &sts_phys, GFP_KERNEL);
+				     &sts_phys, GFP_ATOMIC);
 	if (!sts_ptr) {
 		/* Free space allocated for DMA descriptors */
 		dma_free_coherent(dev,
@@ -297,7 +297,8 @@ static irqreturn_t tsi721_bdma_msix(int
 {
 	struct tsi721_bdma_chan *bdma_chan = ptr;
 
-	tsi721_bdma_handler(bdma_chan);
+	if (bdma_chan->active)
+		tasklet_schedule(&bdma_chan->tasklet);
 	return IRQ_HANDLED;
 }
 #endif /* CONFIG_PCI_MSI */
@@ -618,14 +619,14 @@ static void tsi721_dma_tasklet(unsigned
 			}
 			list_add(&desc->desc_node, &bdma_chan->free_list);
 			bdma_chan->active_tx = NULL;
+			tsi721_advance_work(bdma_chan, NULL);
 			spin_unlock(&bdma_chan->lock);
 			if (callback)
 				callback(param);
-			spin_lock(&bdma_chan->lock);
+		} else {
+			tsi721_advance_work(bdma_chan, bdma_chan->active_tx);
+			spin_unlock(&bdma_chan->lock);
 		}
-
-		tsi721_advance_work(bdma_chan, bdma_chan->active_tx);
-		spin_unlock(&bdma_chan->lock);
 	}
 
 	/* Re-Enable BDMA channel interrupts */
@@ -681,7 +682,7 @@ static int tsi721_alloc_chan_resources(s
 
 	/* Allocate queue of transaction descriptors */
 	desc = kcalloc(TSI721_DMA_TX_QUEUE_SZ, sizeof(struct tsi721_tx_desc),
-			GFP_KERNEL);
+			GFP_ATOMIC);
 	if (!desc) {
 		tsi_err(&dchan->dev->device,
 			"DMAC%d Failed to allocate logical descriptors",
@@ -744,7 +745,13 @@ static
 enum dma_status tsi721_tx_status(struct dma_chan *dchan, dma_cookie_t cookie,
 				 struct dma_tx_state *txstate)
 {
-	return dma_cookie_status(dchan, cookie, txstate);
+	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
+	enum dma_status	status;
+
+	spin_lock_bh(&bdma_chan->lock);
+	status = dma_cookie_status(dchan, cookie, txstate);
+	spin_unlock_bh(&bdma_chan->lock);
+	return status;
 }
 
 static void tsi721_issue_pending(struct dma_chan *dchan)
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

