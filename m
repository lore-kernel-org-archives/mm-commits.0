From: akpm@linux-foundation.org
Subject: - rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch removed from -mm tree
Date: Wed, 30 Apr 2008 15:25:29 -0700
Message-ID: <200804302225.m3UMPT72006694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761466AbYD3W0F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 18:26:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, galak@gate.crashing.org, mm-commits@vger.kernel.org


The patch titled
     rapidio: add the RapidIO master port maintance and doorbell window to space resources
has been removed from the -mm tree.  Its filename was
     rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch

This patch was dropped because an updated version will be merged

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

origin.patch
rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch
rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
rapidio-fix-docbook-references.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

