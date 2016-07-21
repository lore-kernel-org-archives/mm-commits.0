From: akpm@linux-foundation.org
Subject: +
 rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters.patch added
 to -mm tree
Date: Thu, 21 Jul 2016 11:40:22 -0700
Message-ID: <57911716.gjU9k2LROlzAtDzY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbcGUSkX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jul 2016 14:40:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721_dma: add channel mask and queue size parameters
has been added to the -mm tree.  Its filename is
     rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters.patch

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
Subject: rapidio/tsi721_dma: add channel mask and queue size parameters

Add module parameters to allow load time configuration of DMA channels.

Depending on application, performance of DMA data transfers can benefit
from adjusted sizes of buffer descriptor ring and/or transaction requests
queue.

Having HW DMA channel selector mask allows to define which channels (from
seven available) are controlled by the mport device driver and reserve
some of them for direct use by other drivers.

Link: http://lkml.kernel.org/r/1469125134-16523-5-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Tested-by: Barry Wood <barry.wood@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rapidio/tsi721.txt     |   14 +++++++++++++
 drivers/rapidio/devices/tsi721.h     |    2 -
 drivers/rapidio/devices/tsi721_dma.c |   26 ++++++++++++++++---------
 3 files changed, 32 insertions(+), 10 deletions(-)

diff -puN Documentation/rapidio/tsi721.txt~rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters Documentation/rapidio/tsi721.txt
--- a/Documentation/rapidio/tsi721.txt~rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters
+++ a/Documentation/rapidio/tsi721.txt
@@ -25,6 +25,20 @@ fully compatible with RIONET driver (Eth
         This parameter can be changed dynamically.
         Use CONFIG_RAPIDIO_DEBUG=y to enable debug output at the top level.
 
+- 'dma_desc_per_channel' - This parameter defines number of hardware buffer
+        descriptors allocated for each registered Tsi721 DMA channel.
+        Its default value is 128.
+
+- 'dma_txqueue_sz' - DMA transactions queue size. Defines number of pending
+        transaction requests that can be accepted by each DMA channel.
+        Default value is 16.
+
+- 'dma_sel' - DMA channel selection mask. Bitmask that defines which hardware
+        DMA channels (0 ... 6) will be registered with DmaEngine core.
+        If bit is set to 1, the corresponding DMA channel will be registered.
+        DMA channels not selected by this mask will not be used by this device
+        driver. Default value is 0x7f (use all channels).
+
 II. Known problems
 
   None.
diff -puN drivers/rapidio/devices/tsi721.h~rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters drivers/rapidio/devices/tsi721.h
--- a/drivers/rapidio/devices/tsi721.h~rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters
+++ a/drivers/rapidio/devices/tsi721.h
@@ -661,7 +661,7 @@ enum dma_rtype {
  */
 #define TSI721_DMA_CHNUM	TSI721_DMA_MAXCH
 
-#define TSI721_DMACH_MAINT	0	/* DMA channel for maint requests */
+#define TSI721_DMACH_MAINT	7	/* DMA channel for maint requests */
 #define TSI721_DMACH_MAINT_NBD	32	/* Number of BDs for maint requests */
 
 #define TSI721_DMACH_DMA	1	/* DMA channel for data transfers */
diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -36,18 +36,26 @@
 
 #include "tsi721.h"
 
-#define TSI721_DMA_TX_QUEUE_SZ	16	/* number of transaction descriptors */
-
 #ifdef CONFIG_PCI_MSI
 static irqreturn_t tsi721_bdma_msix(int irq, void *ptr);
 #endif
 static int tsi721_submit_sg(struct tsi721_tx_desc *desc);
 
 static unsigned int dma_desc_per_channel = 128;
-module_param(dma_desc_per_channel, uint, S_IWUSR | S_IRUGO);
+module_param(dma_desc_per_channel, uint, S_IRUGO);
 MODULE_PARM_DESC(dma_desc_per_channel,
 		 "Number of DMA descriptors per channel (default: 128)");
 
+static unsigned int dma_txqueue_sz = 16;
+module_param(dma_txqueue_sz, uint, S_IRUGO);
+MODULE_PARM_DESC(dma_txqueue_sz,
+		 "DMA Transactions Queue Size (default: 16)");
+
+static u8 dma_sel = 0x7f;
+module_param(dma_sel, byte, S_IRUGO);
+MODULE_PARM_DESC(dma_sel,
+		 "DMA Channel Selection Mask (default: 0x7f = all)");
+
 static inline struct tsi721_bdma_chan *to_tsi721_chan(struct dma_chan *chan)
 {
 	return container_of(chan, struct tsi721_bdma_chan, dchan);
@@ -732,7 +740,7 @@ static int tsi721_alloc_chan_resources(s
 	tsi_debug(DMA, &dchan->dev->device, "DMAC%d", bdma_chan->id);
 
 	if (bdma_chan->bd_base)
-		return TSI721_DMA_TX_QUEUE_SZ;
+		return dma_txqueue_sz;
 
 	/* Initialize BDMA channel */
 	if (tsi721_bdma_ch_init(bdma_chan, dma_desc_per_channel)) {
@@ -742,7 +750,7 @@ static int tsi721_alloc_chan_resources(s
 	}
 
 	/* Allocate queue of transaction descriptors */
-	desc = kcalloc(TSI721_DMA_TX_QUEUE_SZ, sizeof(struct tsi721_tx_desc),
+	desc = kcalloc(dma_txqueue_sz, sizeof(struct tsi721_tx_desc),
 			GFP_ATOMIC);
 	if (!desc) {
 		tsi_err(&dchan->dev->device,
@@ -754,7 +762,7 @@ static int tsi721_alloc_chan_resources(s
 
 	bdma_chan->tx_desc = desc;
 
-	for (i = 0; i < TSI721_DMA_TX_QUEUE_SZ; i++) {
+	for (i = 0; i < dma_txqueue_sz; i++) {
 		dma_async_tx_descriptor_init(&desc[i].txd, dchan);
 		desc[i].txd.tx_submit = tsi721_tx_submit;
 		desc[i].txd.flags = DMA_CTRL_ACK;
@@ -766,7 +774,7 @@ static int tsi721_alloc_chan_resources(s
 	bdma_chan->active = true;
 	tsi721_bdma_interrupt_enable(bdma_chan, 1);
 
-	return TSI721_DMA_TX_QUEUE_SZ;
+	return dma_txqueue_sz;
 }
 
 static void tsi721_sync_dma_irq(struct tsi721_bdma_chan *bdma_chan)
@@ -962,7 +970,7 @@ void tsi721_dma_stop_all(struct tsi721_d
 	int i;
 
 	for (i = 0; i < TSI721_DMA_MAXCH; i++) {
-		if (i != TSI721_DMACH_MAINT)
+		if ((i != TSI721_DMACH_MAINT) && (dma_sel & (1 << i)))
 			tsi721_dma_stop(&priv->bdma[i]);
 	}
 }
@@ -979,7 +987,7 @@ int tsi721_register_dma(struct tsi721_de
 	for (i = 0; i < TSI721_DMA_MAXCH; i++) {
 		struct tsi721_bdma_chan *bdma_chan = &priv->bdma[i];
 
-		if (i == TSI721_DMACH_MAINT)
+		if ((i == TSI721_DMACH_MAINT) || (dma_sel & (1 << i)) == 0)
 			continue;
 
 		bdma_chan->regs = priv->regs + TSI721_DMAC_BASE(i);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-rapidio-channelized-messaging-driver.patch
rapidio-documentation-fix-mangled-paragraph-in-mport_cdev.patch
rapidio-fix-return-value-description-for-dma_prep-functions.patch
rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters.patch
rapidio-tsi721-add-pcie-mrrs-override-parameter.patch
rapidio-tsi721-add-messaging-mbox-selector-parameter.patch
rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call.patch
rapidio-fix-error-handling-in-mbox-request-release-functions.patch
rapidio-idt_gen2-fix-locking-warning.patch
rapidio-change-inbound-window-size-type-to-u64.patch
rapidio-modify-for-rev3-specification-changes.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch
rapidio-switches-add-driver-for-idt-gen3-switches.patch

