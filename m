From: akpm@linux-foundation.org
Subject: + rapidio-tsi721-fix-locking-in-ob_msg-processing.patch added to
 -mm tree
Date: Mon, 08 Feb 2016 13:22:40 -0800
Message-ID: <56b90720.4rHYvAy1EDOduqvu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbcBHVWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: fix locking in OB_MSG processing
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-fix-locking-in-ob_msg-processing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721-fix-locking-in-ob_msg-processing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721-fix-locking-in-ob_msg-processing.patch

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
Subject: rapidio/tsi721: fix locking in OB_MSG processing

- Add spinlock protection into outbound message queuing routine.

- Change outbound message interrupt handler to avoid deadlock when
  calling registered callback routine.

- Allow infinite retries for outbound messages to avoid retry threshold
  error signaling in systems with nodes that have slow message receive
  queue processing.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |   42 ++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-locking-in-ob_msg-processing drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-locking-in-ob_msg-processing
+++ a/drivers/rapidio/devices/tsi721.c
@@ -1453,11 +1453,14 @@ tsi721_add_outb_message(struct rio_mport
 	struct tsi721_device *priv = mport->priv;
 	struct tsi721_omsg_desc *desc;
 	u32 tx_slot;
+	unsigned long flags;
 
 	if (!priv->omsg_init[mbox] ||
 	    len > TSI721_MSG_MAX_SIZE || len < 8)
 		return -EINVAL;
 
+	spin_lock_irqsave(&priv->omsg_ring[mbox].lock, flags);
+
 	tx_slot = priv->omsg_ring[mbox].tx_slot;
 
 	/* Copy copy message into transfer buffer */
@@ -1469,9 +1472,11 @@ tsi721_add_outb_message(struct rio_mport
 	/* Build descriptor associated with buffer */
 	desc = priv->omsg_ring[mbox].omd_base;
 	desc[tx_slot].type_id = cpu_to_le32((DTYPE4 << 29) | rdev->destid);
+#ifdef TSI721_OMSG_DESC_INT
+	/* Request IOF_DONE interrupt generation for each N-th frame in queue */
 	if (tx_slot % 4 == 0)
 		desc[tx_slot].type_id |= cpu_to_le32(TSI721_OMD_IOF);
-
+#endif
 	desc[tx_slot].msg_info =
 		cpu_to_le32((mport->sys_size << 26) | (mbox << 22) |
 			    (0xe << 12) | (len & 0xff8));
@@ -1497,6 +1502,8 @@ tsi721_add_outb_message(struct rio_mport
 		priv->regs + TSI721_OBDMAC_DWRCNT(mbox));
 	ioread32(priv->regs + TSI721_OBDMAC_DWRCNT(mbox));
 
+	spin_unlock_irqrestore(&priv->omsg_ring[mbox].lock, flags);
+
 	return 0;
 }
 
@@ -1511,6 +1518,9 @@ static void tsi721_omsg_handler(struct t
 {
 	u32 omsg_int;
 	struct rio_mport *mport = &priv->mport;
+	void *dev_id = NULL;
+	u32 tx_slot = 0xffffffff;
+	int do_callback = 0;
 
 	spin_lock(&priv->omsg_ring[ch].lock);
 
@@ -1524,7 +1534,6 @@ static void tsi721_omsg_handler(struct t
 		u32 srd_ptr;
 		u64 *sts_ptr, last_ptr = 0, prev_ptr = 0;
 		int i, j;
-		u32 tx_slot;
 
 		/*
 		 * Find last successfully processed descriptor
@@ -1574,14 +1583,19 @@ static void tsi721_omsg_handler(struct t
 				goto no_sts_update;
 		}
 
+		if (tx_slot >= priv->omsg_ring[ch].size)
+			dev_dbg(&priv->pdev->dev,
+				  "OB_MSG tx_slot=%x > size=%x",
+				  tx_slot, priv->omsg_ring[ch].size);
+		WARN_ON(tx_slot >= priv->omsg_ring[ch].size);
+
 		/* Move slot index to the next message to be sent */
 		++tx_slot;
 		if (tx_slot == priv->omsg_ring[ch].size)
 			tx_slot = 0;
-		BUG_ON(tx_slot >= priv->omsg_ring[ch].size);
-		mport->outb_msg[ch].mcback(mport,
-				priv->omsg_ring[ch].dev_id, ch,
-				tx_slot);
+
+		dev_id = priv->omsg_ring[ch].dev_id;
+		do_callback = 1;
 	}
 
 no_sts_update:
@@ -1597,15 +1611,15 @@ no_sts_update:
 
 		iowrite32(TSI721_OBDMAC_INT_ERROR,
 				priv->regs + TSI721_OBDMAC_INT(ch));
-		iowrite32(TSI721_OBDMAC_CTL_INIT,
+		iowrite32(TSI721_OBDMAC_CTL_RETRY_THR | TSI721_OBDMAC_CTL_INIT,
 				priv->regs + TSI721_OBDMAC_CTL(ch));
 		ioread32(priv->regs + TSI721_OBDMAC_CTL(ch));
 
 		/* Inform upper level to clear all pending tx slots */
-		if (mport->outb_msg[ch].mcback)
-			mport->outb_msg[ch].mcback(mport,
-					priv->omsg_ring[ch].dev_id, ch,
-					priv->omsg_ring[ch].tx_slot);
+		dev_id = priv->omsg_ring[ch].dev_id;
+		tx_slot = priv->omsg_ring[ch].tx_slot;
+		do_callback = 1;
+
 		/* Synch tx_slot tracking */
 		iowrite32(priv->omsg_ring[ch].tx_slot,
 			priv->regs + TSI721_OBDMAC_DRDCNT(ch));
@@ -1627,6 +1641,9 @@ no_sts_update:
 	}
 
 	spin_unlock(&priv->omsg_ring[ch].lock);
+
+	if (mport->outb_msg[ch].mcback && do_callback)
+		mport->outb_msg[ch].mcback(mport, dev_id, ch, tx_slot);
 }
 
 /**
@@ -1768,7 +1785,8 @@ static int tsi721_open_outb_mbox(struct
 	mb();
 
 	/* Initialize Outbound Message engine */
-	iowrite32(TSI721_OBDMAC_CTL_INIT, priv->regs + TSI721_OBDMAC_CTL(mbox));
+	iowrite32(TSI721_OBDMAC_CTL_RETRY_THR | TSI721_OBDMAC_CTL_INIT,
+		  priv->regs + TSI721_OBDMAC_CTL(mbox));
 	ioread32(priv->regs + TSI721_OBDMAC_DWRCNT(mbox));
 	udelay(10);
 
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

