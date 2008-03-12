From: akpm@linux-foundation.org
Subject: + rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch added to -mm tree
Date: Tue, 11 Mar 2008 21:24:24 -0700
Message-ID: <200803120424.m2C4OOo5009854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593AbYCLEYl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 00:24:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wei.zhang@freescale.com


The patch titled
     rapidio: add the RapidIO master port maintance and doorbell window to space resources
has been added to the -mm tree.  Its filename is
     rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch

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
Subject: rapidio: add the RapidIO master port maintance and doorbell window to space resources
From: Zhang Wei <wei.zhang@freescale.com>

Add the RapidIO master port maintance and doorbell IO windows to RIO space
resources.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   26 +++++++++++++++++++++-----
 include/linux/rio.h           |    1 +
 2 files changed, 22 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -192,6 +192,8 @@ struct rio_priv {
 	int bellirq;
 	int txirq;
 	int rxirq;
+	struct resource maint_res;
+	struct resource dbell_res;
 };
 
 /**
@@ -1362,15 +1364,29 @@ int fsl_rio_setup(struct of_device *dev)
 		out_be32((priv->regs_win + RIO_ISR_AACR), RIO_ISR_AACR_AA);
 
 	/* Configure maintenance transaction window */
-	out_be32(&priv->maint_atmu_regs->rowbar, 0x000c0000);
-	out_be32(&priv->maint_atmu_regs->rowar, 0x80077015);
+	rio_init_io_res(&priv->maint_res, law_start, RIO_MAINT_WIN_SIZE,
+			"maint_win", RIO_RESOURCE_MAINT);
+	rc = rio_request_io_region(port, &priv->maint_res);
+	if (rc) {
+		dev_err(&dev->dev, "request maint window error!\n");
+		goto err;
+	}
+	out_be32(&priv->maint_atmu_regs->rowbar, (law_start >> 12) & 0xffffff);
+	out_be32(&priv->maint_atmu_regs->rowar, 0x80077000
+					| (__ilog2(RIO_MAINT_WIN_SIZE) - 1));
 
 	priv->maint_win = ioremap(law_start, RIO_MAINT_WIN_SIZE);
 
 	/* Configure outbound doorbell window */
-	out_be32(&priv->dbell_atmu_regs->rowbar, 0x000c0400);
-	out_be32(&priv->dbell_atmu_regs->rowar, 0x8004200b);
-	fsl_rio_doorbell_init(port);
+	rio_init_io_res(&priv->dbell_res, law_start + RIO_MAINT_WIN_SIZE,
+			RIO_DBELL_WIN_SIZE, "dbell_win", RIO_RESOURCE_DOORBELL);
+	out_be32(&priv->dbell_atmu_regs->rowbar, (priv->dbell_res.start >> 12)
+							& 0xffffff);
+	out_be32(&priv->dbell_atmu_regs->rowar, 0x80042000
+					| (__ilog2(RIO_DBELL_WIN_SIZE) - 1));
+	rc = fsl_rio_doorbell_init(port);
+	if (rc)
+		goto err;
 
 	return 0;
 err:
diff -puN include/linux/rio.h~rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources
+++ a/include/linux/rio.h
@@ -257,6 +257,7 @@ struct rio_ops {
 #define RIO_RESOURCE_MEM	0x00000100
 #define RIO_RESOURCE_DOORBELL	0x00000200
 #define RIO_RESOURCE_MAILBOX	0x00000400
+#define RIO_RESOURCE_MAINT	0x00000800
 
 #define RIO_RESOURCE_CACHEABLE	0x00010000
 #define RIO_RESOURCE_PCI	0x00020000
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

