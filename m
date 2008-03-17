From: akpm@linux-foundation.org
Subject: - fsldma-add-a-completed-cookie-updated-action-in-dma-finish-interrupt.patch removed from -mm tree
Date: Mon, 17 Mar 2008 14:00:58 -0700
Message-ID: <200803172100.m2HL0woA030902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757285AbYCQVBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, bigeasy@linutronix.de, dan.j.williams@intel.com, shannon.nelson@intel.com, mm-commits@vger.kernel.org


The patch titled
     fsldma: add a completed cookie updated action in DMA finish interrupt
has been removed from the -mm tree.  Its filename was
     fsldma-add-a-completed-cookie-updated-action-in-dma-finish-interrupt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsldma: add a completed cookie updated action in DMA finish interrupt
From: Zhang Wei <wei.zhang@freescale.com>

The patch 'fsldma: do not cleanup descriptors in hardirq context' (commit
222ccf9ab838a1ca7163969fabd2cddc10403fb5) removed descriptors cleanup function
to tasklet but the completed cookie do not updated.  Thus, the DMA controller
will get lots of duplicated transfer interrupts.  Just make a completed cookie
update in interrupt handler.  And keep other cleanup jobs in tasklet function.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/fsldma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/fsldma.c~fsldma-add-a-completed-cookie-updated-action-in-dma-finish-interrupt drivers/dma/fsldma.c
--- a/drivers/dma/fsldma.c~fsldma-add-a-completed-cookie-updated-action-in-dma-finish-interrupt
+++ a/drivers/dma/fsldma.c
@@ -513,7 +513,6 @@ static void fsl_chan_ld_cleanup(struct f
 
 	spin_lock_irqsave(&fsl_chan->desc_lock, flags);
 
-	fsl_dma_update_completed_cookie(fsl_chan);
 	dev_dbg(fsl_chan->dev, "chan completed_cookie = %d\n",
 			fsl_chan->completed_cookie);
 	list_for_each_entry_safe(desc, _desc, &fsl_chan->ld_queue, node) {
@@ -677,6 +676,7 @@ static irqreturn_t fsl_dma_chan_do_inter
 		dev_dbg(fsl_chan->dev, "event: clndar %p, nlndar %p\n",
 			(void *)get_cdar(fsl_chan), (void *)get_ndar(fsl_chan));
 		stat &= ~FSL_DMA_SR_EOSI;
+		fsl_dma_update_completed_cookie(fsl_chan);
 	}
 
 	/* If it current transfer is the end-of-transfer,
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
git-async-tx.patch

