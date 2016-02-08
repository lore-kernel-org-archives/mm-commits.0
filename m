From: akpm@linux-foundation.org
Subject: + rapidio-tsi721_dma-fix-pending-transaction-queue-handling.patch added to -mm tree
Date: Mon, 08 Feb 2016 13:22:04 -0800
Message-ID: <56b906fc.yuGsCJAaZ7JT/qGF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbcBHVWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721_dma: fix pending transaction queue handling
has been added to the -mm tree.  Its filename is
     rapidio-tsi721_dma-fix-pending-transaction-queue-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721_dma-fix-pending-transaction-queue-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721_dma-fix-pending-transaction-queue-handling.patch

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
Subject: rapidio/tsi721_dma: fix pending transaction queue handling

Fix pending DMA request queue handling to avoid broken ordering during
concurrent request submissions.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.h     |    2 
 drivers/rapidio/devices/tsi721_dma.c |   60 ++++++++++++-------------
 2 files changed, 32 insertions(+), 30 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.h~rapidio-tsi721_dma-fix-pending-transaction-queue-handling drivers/rapidio/devices/tsi721.h
--- a/drivers/rapidio/devices/tsi721.h~rapidio-tsi721_dma-fix-pending-transaction-queue-handling
+++ a/drivers/rapidio/devices/tsi721.h
@@ -674,7 +674,7 @@ struct tsi721_bdma_chan {
 	struct dma_chan		dchan;
 	struct tsi721_tx_desc	*tx_desc;
 	spinlock_t		lock;
-	struct list_head	active_list;
+	struct tsi721_tx_desc	*active_tx;
 	struct list_head	queue;
 	struct list_head	free_list;
 	struct tasklet_struct	tasklet;
diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-fix-pending-transaction-queue-handling drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-fix-pending-transaction-queue-handling
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -63,14 +63,6 @@ struct tsi721_tx_desc *to_tsi721_desc(st
 	return container_of(txd, struct tsi721_tx_desc, txd);
 }
 
-static inline
-struct tsi721_tx_desc *tsi721_dma_first_active(
-				struct tsi721_bdma_chan *bdma_chan)
-{
-	return list_first_entry(&bdma_chan->active_list,
-				struct tsi721_tx_desc, desc_node);
-}
-
 static int tsi721_bdma_ch_init(struct tsi721_bdma_chan *bdma_chan, int bd_num)
 {
 	struct tsi721_dma_desc *bd_ptr;
@@ -534,23 +526,30 @@ entry_done:
 	return err;
 }
 
-static void tsi721_advance_work(struct tsi721_bdma_chan *bdma_chan)
+static void tsi721_advance_work(struct tsi721_bdma_chan *bdma_chan,
+				struct tsi721_tx_desc *desc)
 {
-	struct tsi721_tx_desc *desc;
 	int err;
 
 	dev_dbg(bdma_chan->dchan.device->dev, "%s: Enter\n", __func__);
 
+	if (!tsi721_dma_is_idle(bdma_chan))
+		return;
+
 	/*
-	 * If there are any new transactions in the queue add them
-	 * into the processing list
-	 */
-	if (!list_empty(&bdma_chan->queue))
-		list_splice_init(&bdma_chan->queue, &bdma_chan->active_list);
+	 * If there is no data transfer in progress, fetch new descriptor from
+	 * the pending queue.
+	*/
+
+	if (desc == NULL && bdma_chan->active_tx == NULL &&
+					!list_empty(&bdma_chan->queue)) {
+		desc = list_first_entry(&bdma_chan->queue,
+					struct tsi721_tx_desc, desc_node);
+		list_del_init((&desc->desc_node));
+		bdma_chan->active_tx = desc;
+	}
 
-	/* Start new transaction (if available) */
-	if (!list_empty(&bdma_chan->active_list)) {
-		desc = tsi721_dma_first_active(bdma_chan);
+	if (desc) {
 		err = tsi721_submit_sg(desc);
 		if (!err)
 			tsi721_start_dma(bdma_chan);
@@ -581,6 +580,10 @@ static void tsi721_dma_tasklet(unsigned
 		dev_err(bdma_chan->dchan.device->dev,
 			"%s: DMA ERROR - DMAC%d_STS = 0x%x\n",
 			__func__, bdma_chan->id, dmac_sts);
+
+		spin_lock(&bdma_chan->lock);
+		bdma_chan->active_tx = NULL;
+		spin_unlock(&bdma_chan->lock);
 	}
 
 	if (dmac_int & TSI721_DMAC_INT_STFULL) {
@@ -594,7 +597,7 @@ static void tsi721_dma_tasklet(unsigned
 
 		tsi721_clr_stat(bdma_chan);
 		spin_lock(&bdma_chan->lock);
-		desc = tsi721_dma_first_active(bdma_chan);
+		desc = bdma_chan->active_tx;
 
 		if (desc->sg_len == 0) {
 			dma_async_tx_callback callback = NULL;
@@ -606,14 +609,15 @@ static void tsi721_dma_tasklet(unsigned
 				callback = desc->txd.callback;
 				param = desc->txd.callback_param;
 			}
-			list_move(&desc->desc_node, &bdma_chan->free_list);
+			list_add(&desc->desc_node, &bdma_chan->free_list);
+			bdma_chan->active_tx = NULL;
 			spin_unlock(&bdma_chan->lock);
 			if (callback)
 				callback(param);
 			spin_lock(&bdma_chan->lock);
 		}
 
-		tsi721_advance_work(bdma_chan);
+		tsi721_advance_work(bdma_chan, bdma_chan->active_tx);
 		spin_unlock(&bdma_chan->lock);
 	}
 
@@ -720,9 +724,6 @@ static void tsi721_free_chan_resources(s
 	if (bdma_chan->bd_base == NULL)
 		return;
 
-	BUG_ON(!list_empty(&bdma_chan->active_list));
-	BUG_ON(!list_empty(&bdma_chan->queue));
-
 	tsi721_bdma_interrupt_enable(bdma_chan, 0);
 	bdma_chan->active = false;
 	tsi721_sync_dma_irq(bdma_chan);
@@ -745,11 +746,11 @@ static void tsi721_issue_pending(struct
 
 	dev_dbg(dchan->device->dev, "%s: Enter\n", __func__);
 
+	spin_lock_bh(&bdma_chan->lock);
 	if (tsi721_dma_is_idle(bdma_chan) && bdma_chan->active) {
-		spin_lock_bh(&bdma_chan->lock);
-		tsi721_advance_work(bdma_chan);
-		spin_unlock_bh(&bdma_chan->lock);
+		tsi721_advance_work(bdma_chan, NULL);
 	}
+	spin_unlock_bh(&bdma_chan->lock);
 }
 
 static
@@ -839,7 +840,8 @@ static int tsi721_terminate_all(struct d
 		} while ((dmac_int & TSI721_DMAC_INT_SUSP) == 0);
 	}
 
-	list_splice_init(&bdma_chan->active_list, &list);
+	if (bdma_chan->active_tx)
+		list_add(&bdma_chan->active_tx->desc_node, &list);
 	list_splice_init(&bdma_chan->queue, &list);
 
 	list_for_each_entry_safe(desc, _d, &list, desc_node)
@@ -875,7 +877,7 @@ int tsi721_register_dma(struct tsi721_de
 
 		spin_lock_init(&bdma_chan->lock);
 
-		INIT_LIST_HEAD(&bdma_chan->active_list);
+		bdma_chan->active_tx = NULL;
 		INIT_LIST_HEAD(&bdma_chan->queue);
 		INIT_LIST_HEAD(&bdma_chan->free_list);
 
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

