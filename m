From: akpm@linux-foundation.org
Subject: - fsldma-fix-the-dma-halt-when-using-dma_interrupt-async_tx-transfer.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:30:52 -0700
Message-ID: <200803212030.m2LKUqOX009025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761067AbYCUUbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:31:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, dan.j.williams@intel.com, shannon.nelson@intel.com, mm-commits@vger.kernel.org


The patch titled
     fsldma: fix the DMA halt when using DMA_INTERRUPT async_tx transfer.
has been removed from the -mm tree.  Its filename was
     fsldma-fix-the-dma-halt-when-using-dma_interrupt-async_tx-transfer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsldma: fix the DMA halt when using DMA_INTERRUPT async_tx transfer.
From: Zhang Wei <wei.zhang@freescale.com>

The DMA_INTERRUPT async_tx is a NULL transfer, thus the BCR(count register) is
0.  When the transfer started with a byte count of zero, the DMA controller
will triger a PE(programming error) event and halt, not a normal interrupt.  I
add special codes for PE event and DMA_INTERRUPT async_tx testing.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/fsldma.c |   30 ++++++++++++++++++++++++++++++
 drivers/dma/fsldma.h |    1 +
 2 files changed, 31 insertions(+)

diff -puN drivers/dma/fsldma.c~fsldma-fix-the-dma-halt-when-using-dma_interrupt-async_tx-transfer drivers/dma/fsldma.c
--- a/drivers/dma/fsldma.c~fsldma-fix-the-dma-halt-when-using-dma_interrupt-async_tx-transfer
+++ a/drivers/dma/fsldma.c
@@ -123,6 +123,11 @@ static dma_addr_t get_ndar(struct fsl_dm
 	return DMA_IN(fsl_chan, &fsl_chan->reg_base->ndar, 64);
 }
 
+static u32 get_bcr(struct fsl_dma_chan *fsl_chan)
+{
+	return DMA_IN(fsl_chan, &fsl_chan->reg_base->bcr, 32);
+}
+
 static int dma_is_idle(struct fsl_dma_chan *fsl_chan)
 {
 	u32 sr = get_sr(fsl_chan);
@@ -426,6 +431,9 @@ fsl_dma_prep_interrupt(struct dma_chan *
 	new->async_tx.cookie = -EBUSY;
 	new->async_tx.ack = 0;
 
+	/* Insert the link descriptor to the LD ring */
+	list_add_tail(&new->node, &new->async_tx.tx_list);
+
 	/* Set End-of-link to the last link descriptor of new list*/
 	set_ld_eol(fsl_chan, new);
 
@@ -694,6 +702,23 @@ static irqreturn_t fsl_dma_chan_do_inter
 	if (stat & FSL_DMA_SR_TE)
 		dev_err(fsl_chan->dev, "Transfer Error!\n");
 
+	/* Programming Error
+	 * The DMA_INTERRUPT async_tx is a NULL transfer, which will
+	 * triger a PE interrupt.
+	 */
+	if (stat & FSL_DMA_SR_PE) {
+		dev_dbg(fsl_chan->dev, "event: Programming Error INT\n");
+		if (get_bcr(fsl_chan) == 0) {
+			/* BCR register is 0, this is a DMA_INTERRUPT async_tx.
+			 * Now, update the completed cookie, and continue the
+			 * next uncompleted transfer.
+			 */
+			fsl_dma_update_completed_cookie(fsl_chan);
+			fsl_chan_xfer_ld_queue(fsl_chan);
+		}
+		stat &= ~FSL_DMA_SR_PE;
+	}
+
 	/* If the link descriptor segment transfer finishes,
 	 * we will recycle the used descriptor.
 	 */
@@ -834,6 +859,11 @@ static int fsl_dma_self_test(struct fsl_
 	tx3 = fsl_dma_prep_memcpy(chan, dma_dest, dma_src, test_size / 4, 0);
 	async_tx_ack(tx3);
 
+	/* Interrupt tx test */
+	tx1 = fsl_dma_prep_interrupt(chan);
+	async_tx_ack(tx1);
+	cookie = fsl_dma_tx_submit(tx1);
+
 	/* Test exchanging the prepared tx sort */
 	cookie = fsl_dma_tx_submit(tx3);
 	cookie = fsl_dma_tx_submit(tx2);
diff -puN drivers/dma/fsldma.h~fsldma-fix-the-dma-halt-when-using-dma_interrupt-async_tx-transfer drivers/dma/fsldma.h
--- a/drivers/dma/fsldma.h~fsldma-fix-the-dma-halt-when-using-dma_interrupt-async_tx-transfer
+++ a/drivers/dma/fsldma.h
@@ -40,6 +40,7 @@
 #define FSL_DMA_MR_EOTIE	0x00000080
 
 #define FSL_DMA_SR_CH		0x00000020
+#define FSL_DMA_SR_PE		0x00000010
 #define FSL_DMA_SR_CB		0x00000004
 #define FSL_DMA_SR_TE		0x00000080
 #define FSL_DMA_SR_EOSI		0x00000002
_

Patches currently in -mm which might be from wei.zhang@freescale.com are

origin.patch
rapidio-change-rio-function-mpc85xx_-to-fsl_.patch
rapidio-add-rapidio-option-to-kernel-configuration.patch
rapidio-move-include-asm-ppc-rioh-to-include-asm-powerpc-rioh.patch
rapidio-add-rapidio-multi-mport-support.patch
rapidio-add-of-tree-support-to-rapidio-controller-driver.patch
rapidio-change-the-kernel-configurated-rapidio-system-size-to-auto-probing.patch
rapidio-add-rapidio-node-into-mpc8641hpcn-dts-file.patch
rapidio-add-rapidio-node-probing-into-mpc86xx_hpcn-board-id-table.patch
rapidio-add-serial-rapidio-controller-support-which-includes-mpc8548-mpc8641.patch
rapidio-add-rapidio-connection-info-print-out-and-re-training-for-break-connection.patch
rapidio-add-memory-mapping-driver-to-rapidio.patch
rapidio-add-rapidio-space-allocation-bitmap-arithmetic.patch
rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch
rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
rapidio-change-rapidio-doorbell-source-and-target-id-field-to-16-bit.patch
rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
rapidio-fix-docbook-references.patch
git-async-tx.patch

