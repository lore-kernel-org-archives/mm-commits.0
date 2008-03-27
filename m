From: akpm@linux-foundation.org
Subject: + fsldma-split-the-mpc83xx-event-from-mpc85xx-and-refine-irq-codes.patch added to -mm tree
Date: Thu, 27 Mar 2008 01:11:45 -0700
Message-ID: <200803270811.m2R8Bjv3025093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755233AbYC0IMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 04:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wei.zhang@freescale.com, dan.j.williams@intel.com, shannon.nelson@intel.com


The patch titled
     fsldma: split the MPC83xx event from MPC85xx and refine irq codes.
has been added to the -mm tree.  Its filename is
     fsldma-split-the-mpc83xx-event-from-mpc85xx-and-refine-irq-codes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsldma: split the MPC83xx event from MPC85xx and refine irq codes.
From: Zhang Wei <wei.zhang@freescale.com>

Split MPC83xx EOCDI event from MPC85xx EOLNI event, which is
also need to update cookie and start the next transfer.
The DMA channel irq handler function code is refined.
The patch is tested on MPC8377MDS board.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/fsldma.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff -puN drivers/dma/fsldma.c~fsldma-split-the-mpc83xx-event-from-mpc85xx-and-refine-irq-codes drivers/dma/fsldma.c
--- a/drivers/dma/fsldma.c~fsldma-split-the-mpc83xx-event-from-mpc85xx-and-refine-irq-codes
+++ a/drivers/dma/fsldma.c
@@ -689,6 +689,8 @@ static irqreturn_t fsl_dma_chan_do_inter
 {
 	struct fsl_dma_chan *fsl_chan = (struct fsl_dma_chan *)data;
 	u32 stat;
+	int update_cookie = 0;
+	int xfer_ld_q = 0;
 
 	stat = get_sr(fsl_chan);
 	dev_dbg(fsl_chan->dev, "event: channel %d, stat = 0x%x\n",
@@ -713,8 +715,8 @@ static irqreturn_t fsl_dma_chan_do_inter
 			 * Now, update the completed cookie, and continue the
 			 * next uncompleted transfer.
 			 */
-			fsl_dma_update_completed_cookie(fsl_chan);
-			fsl_chan_xfer_ld_queue(fsl_chan);
+			update_cookie = 1;
+			xfer_ld_q = 1;
 		}
 		stat &= ~FSL_DMA_SR_PE;
 	}
@@ -727,19 +729,33 @@ static irqreturn_t fsl_dma_chan_do_inter
 		dev_dbg(fsl_chan->dev, "event: clndar %p, nlndar %p\n",
 			(void *)get_cdar(fsl_chan), (void *)get_ndar(fsl_chan));
 		stat &= ~FSL_DMA_SR_EOSI;
-		fsl_dma_update_completed_cookie(fsl_chan);
+		update_cookie = 1;
+	}
+
+	/* For MPC8349, EOCDI event need to update cookie
+	 * and start the next transfer if it exist.
+	 */
+	if (stat & FSL_DMA_SR_EOCDI) {
+		dev_dbg(fsl_chan->dev, "event: End-of-Chain link INT\n");
+		stat &= ~FSL_DMA_SR_EOCDI;
+		update_cookie = 1;
+		xfer_ld_q = 1;
 	}
 
 	/* If it current transfer is the end-of-transfer,
 	 * we should clear the Channel Start bit for
 	 * prepare next transfer.
 	 */
-	if (stat & (FSL_DMA_SR_EOLNI | FSL_DMA_SR_EOCDI)) {
+	if (stat & FSL_DMA_SR_EOLNI) {
 		dev_dbg(fsl_chan->dev, "event: End-of-link INT\n");
 		stat &= ~FSL_DMA_SR_EOLNI;
-		fsl_chan_xfer_ld_queue(fsl_chan);
+		xfer_ld_q = 1;
 	}
 
+	if (update_cookie)
+		fsl_dma_update_completed_cookie(fsl_chan);
+	if (xfer_ld_q)
+		fsl_chan_xfer_ld_queue(fsl_chan);
 	if (stat)
 		dev_dbg(fsl_chan->dev, "event: unhandled sr 0x%02x\n",
 					stat);
_

Patches currently in -mm which might be from wei.zhang@freescale.com are

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
fsldma-remove-config_fsl_dma_selftest-keep-fsl_dma_self_test-running-always.patch
fsldma-split-the-mpc83xx-event-from-mpc85xx-and-refine-irq-codes.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

