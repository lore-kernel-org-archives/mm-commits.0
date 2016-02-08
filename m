From: akpm@linux-foundation.org
Subject: +
 rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch added to -mm tree
Date: Mon, 08 Feb 2016 13:22:49 -0800
Message-ID: <56b90729.JovGNhlHgSPqm3L0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbcBHVWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721_dma: update error reporting from prep_sg callback
has been added to the -mm tree.  Its filename is
     rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch

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
Subject: rapidio/tsi721_dma: update error reporting from prep_sg callback

Switch to returning error-valued pointer instead of simple NULL pointer. 
This allows to properly identify situation when request queue is full and
therefore gives to upper layer an option to retry operation later.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721_dma.c |   37 ++++++++++++++-----------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -767,7 +767,7 @@ struct dma_async_tx_descriptor *tsi721_p
 			void *tinfo)
 {
 	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
-	struct tsi721_tx_desc *desc, *_d;
+	struct tsi721_tx_desc *desc;
 	struct rio_dma_ext *rext = tinfo;
 	enum dma_rtype rtype;
 	struct dma_async_tx_descriptor *txd = NULL;
@@ -775,7 +775,7 @@ struct dma_async_tx_descriptor *tsi721_p
 	if (!sgl || !sg_len) {
 		tsi_err(&dchan->dev->device, "DMAC%d No SG list",
 			bdma_chan->id);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	tsi_debug(DMA, &dchan->dev->device, "DMAC%d %s", bdma_chan->id,
@@ -800,28 +800,33 @@ struct dma_async_tx_descriptor *tsi721_p
 		tsi_err(&dchan->dev->device,
 			"DMAC%d Unsupported DMA direction option",
 			bdma_chan->id);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	spin_lock_bh(&bdma_chan->lock);
 
-	list_for_each_entry_safe(desc, _d, &bdma_chan->free_list, desc_node) {
-		if (async_tx_test_ack(&desc->txd)) {
-			list_del_init(&desc->desc_node);
-			desc->destid = rext->destid;
-			desc->rio_addr = rext->rio_addr;
-			desc->rio_addr_u = 0;
-			desc->rtype = rtype;
-			desc->sg_len	= sg_len;
-			desc->sg	= sgl;
-			txd		= &desc->txd;
-			txd->flags	= flags;
-			break;
-		}
+	if (!list_empty(&bdma_chan->free_list)) {
+		desc = list_first_entry(&bdma_chan->free_list,
+				struct tsi721_tx_desc, desc_node);
+		list_del_init(&desc->desc_node);
+		desc->destid = rext->destid;
+		desc->rio_addr = rext->rio_addr;
+		desc->rio_addr_u = 0;
+		desc->rtype = rtype;
+		desc->sg_len	= sg_len;
+		desc->sg	= sgl;
+		txd		= &desc->txd;
+		txd->flags	= flags;
 	}
 
 	spin_unlock_bh(&bdma_chan->lock);
 
+	if (!txd) {
+		tsi_debug(DMA, &dchan->dev->device,
+			  "DMAC%d free TXD is not available", bdma_chan->id);
+		return ERR_PTR(-EBUSY);
+	}
+
 	return txd;
 }
 
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

