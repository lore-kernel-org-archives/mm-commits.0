From: akpm@linux-foundation.org
Subject: + rapidio-tsi721-add-query_mport-callback.patch added to -mm tree
Date: Mon, 08 Feb 2016 13:22:08 -0800
Message-ID: <56b90700.PT4poJEfdj2b+rlt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbcBHVWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: add query_mport callback
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-add-query_mport-callback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721-add-query_mport-callback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721-add-query_mport-callback.patch

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
Subject: rapidio/tsi721: add query_mport callback

Add device-specific implementation of query_mport callback function.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |   34 +++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-query_mport-callback drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-query_mport-callback
+++ a/drivers/rapidio/devices/tsi721.c
@@ -2288,6 +2288,39 @@ static int tsi721_messages_init(struct t
 }
 
 /**
+ * tsi721_query_mport - Fetch inbound message from the Tsi721 MSG Queue
+ * @mport: Master port implementing the Inbound Messaging Engine
+ * @mbox: Inbound mailbox number
+ *
+ * Returns pointer to the message on success or NULL on failure.
+ */
+static int tsi721_query_mport(struct rio_mport *mport,
+			      struct rio_mport_attr *attr)
+{
+	struct tsi721_device *priv = mport->priv;
+	u32 rval;
+
+	rval = ioread32(priv->regs + (0x100 + RIO_PORT_N_ERR_STS_CSR(0)));
+	if (rval & RIO_PORT_N_ERR_STS_PORT_OK) {
+		rval = ioread32(priv->regs + (0x100 + RIO_PORT_N_CTL2_CSR(0)));
+		attr->link_speed = (rval & RIO_PORT_N_CTL2_SEL_BAUD) >> 28;
+		rval = ioread32(priv->regs + (0x100 + RIO_PORT_N_CTL_CSR(0)));
+		attr->link_width = (rval & RIO_PORT_N_CTL_IPW) >> 27;
+	} else
+		attr->link_speed = RIO_LINK_DOWN;
+
+#ifdef CONFIG_RAPIDIO_DMA_ENGINE
+	attr->flags = RIO_MPORT_DMA | RIO_MPORT_DMA_SG;
+	attr->dma_max_sge = 0;
+	attr->dma_max_size = TSI721_BDMA_MAX_BCOUNT;
+	attr->dma_align = 0;
+#else
+	attr->flags = 0;
+#endif
+	return 0;
+}
+
+/**
  * tsi721_disable_ints - disables all device interrupts
  * @priv: pointer to tsi721 private data
  */
@@ -2372,6 +2405,7 @@ static int tsi721_setup_mport(struct tsi
 	ops->get_inb_message = tsi721_get_inb_message;
 	ops->map_inb = tsi721_rio_map_inb_mem;
 	ops->unmap_inb = tsi721_rio_unmap_inb_mem;
+	ops->query_mport = tsi721_query_mport;
 
 	mport = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
 	if (!mport) {
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

