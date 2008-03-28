From: akpm@linux-foundation.org
Subject: - fsldma-remove-config_fsl_dma_selftest-keep-fsl_dma_self_test-running-always.patch removed from -mm tree
Date: Fri, 28 Mar 2008 14:04:58 -0700
Message-ID: <200803282104.m2SL4w2f009860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbYC1VFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 17:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, mm-commits@vger.kernel.org


The patch titled
     fsldma: remove CONFIG_FSL_DMA_SELFTEST, keep fsl_dma_self_test() running always
has been removed from the -mm tree.  Its filename was
     fsldma-remove-config_fsl_dma_selftest-keep-fsl_dma_self_test-running-always.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsldma: remove CONFIG_FSL_DMA_SELFTEST, keep fsl_dma_self_test() running always
From: Zhang Wei <wei.zhang@freescale.com>

Always enabling the fsl_dma_self_test() to ensure the DMA controller should
works well after the driver probed.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/Kconfig  |    8 --------
 drivers/dma/fsldma.c |   13 +++----------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff -puN drivers/dma/Kconfig~fsldma-remove-config_fsl_dma_selftest-keep-fsl_dma_self_test-running-always drivers/dma/Kconfig
--- a/drivers/dma/Kconfig~fsldma-remove-config_fsl_dma_selftest-keep-fsl_dma_self_test-running-always
+++ a/drivers/dma/Kconfig
@@ -46,14 +46,6 @@ config FSL_DMA
 	  MPC8560/40, MPC8555, MPC8548 and MPC8641 processors.
 	  The MPC8349, MPC8360 is also supported.
 
-config FSL_DMA_SELFTEST
-	bool "Enable the self test for each DMA channel"
-	depends on FSL_DMA
-	default y
-	---help---
-	  Enable the self test for each DMA channel. A self test will be
-	  performed after the channel probed to ensure the DMA works well.
-
 config DMA_ENGINE
 	bool
 
diff -puN drivers/dma/fsldma.c~fsldma-remove-config_fsl_dma_selftest-keep-fsl_dma_self_test-running-always drivers/dma/fsldma.c
--- a/drivers/dma/fsldma.c~fsldma-remove-config_fsl_dma_selftest-keep-fsl_dma_self_test-running-always
+++ a/drivers/dma/fsldma.c
@@ -769,15 +769,13 @@ static void dma_do_tasklet(unsigned long
 	fsl_chan_ld_cleanup(fsl_chan);
 }
 
-#ifdef FSL_DMA_CALLBACKTEST
-static void fsl_dma_callback_test(struct fsl_dma_chan *fsl_chan)
+static void fsl_dma_callback_test(void *param)
 {
+	struct fsl_dma_chan *fsl_chan = param;
 	if (fsl_chan)
-		dev_info(fsl_chan->dev, "selftest: callback is ok!\n");
+		dev_dbg(fsl_chan->dev, "selftest: callback is ok!\n");
 }
-#endif
 
-#ifdef CONFIG_FSL_DMA_SELFTEST
 static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 {
 	struct dma_chan *chan;
@@ -868,13 +866,11 @@ static int fsl_dma_self_test(struct fsl_
 	cookie = fsl_dma_tx_submit(tx3);
 	cookie = fsl_dma_tx_submit(tx2);
 
-#ifdef FSL_DMA_CALLBACKTEST
 	if (dma_has_cap(DMA_INTERRUPT, ((struct fsl_dma_device *)
 	    dev_get_drvdata(fsl_chan->dev->parent))->common.cap_mask)) {
 		tx3->callback = fsl_dma_callback_test;
 		tx3->callback_param = fsl_chan;
 	}
-#endif
 	fsl_dma_memcpy_issue_pending(chan);
 	msleep(2);
 
@@ -899,7 +895,6 @@ out:
 	kfree(src);
 	return err;
 }
-#endif
 
 static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 			const struct of_device_id *match)
@@ -990,11 +985,9 @@ static int __devinit of_fsl_dma_chan_pro
 		}
 	}
 
-#ifdef CONFIG_FSL_DMA_SELFTEST
 	err = fsl_dma_self_test(new_fsl_chan);
 	if (err)
 		goto err;
-#endif
 
 	dev_info(&dev->dev, "#%d (%s), irq %d\n", new_fsl_chan->id,
 				match->compatible, new_fsl_chan->irq);
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
git-async-tx.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

