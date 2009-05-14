From: akpm@linux-foundation.org
Subject: [merged] powerpc-fsl_rio-use-law-address-from-device-tree.patch removed from -mm tree
Date: Thu, 14 May 2009 09:10:37 -0700
Message-ID: <200905141610.n4EGAbDf008128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbZENQLO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 May 2009 12:11:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leoli@freescale.com, benh@kernel.crashing.org, galak@gate.crashing.org, mporter@kernel.crashing.org, zw@zh-kernel.org, mm-commits@vger.kernel.org


The patch titled
     powerpc/fsl_rio: use LAW address from device tree
has been removed from the -mm tree.  Its filename was
     powerpc-fsl_rio-use-law-address-from-device-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc/fsl_rio: use LAW address from device tree
From: Li Yang <leoli@freescale.com>

Instead of fixed address in old code.

Signed-off-by: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Zhang Wei <zw@zh-kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~powerpc-fsl_rio-use-law-address-from-device-tree arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~powerpc-fsl_rio-use-law-address-from-device-tree
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -1077,8 +1077,9 @@ int fsl_rio_setup(struct of_device *dev)
 
 	INIT_LIST_HEAD(&port->dbells);
 	port->iores.start = law_start;
-	port->iores.end = law_start + law_size;
+	port->iores.end = law_start + law_size - 1;
 	port->iores.flags = IORESOURCE_MEM;
+	port->iores.name = "rio_io_win";
 
 	priv->bellirq = irq_of_parse_and_map(dev->node, 2);
 	priv->txirq = irq_of_parse_and_map(dev->node, 3);
@@ -1156,14 +1157,15 @@ int fsl_rio_setup(struct of_device *dev)
 		out_be32((priv->regs_win + RIO_ISR_AACR), RIO_ISR_AACR_AA);
 
 	/* Configure maintenance transaction window */
-	out_be32(&priv->maint_atmu_regs->rowbar, 0x000c0000);
-	out_be32(&priv->maint_atmu_regs->rowar, 0x80077015);
+	out_be32(&priv->maint_atmu_regs->rowbar, law_start >> 12);
+	out_be32(&priv->maint_atmu_regs->rowar, 0x80077015);	/* 4M */
 
 	priv->maint_win = ioremap(law_start, RIO_MAINT_WIN_SIZE);
 
 	/* Configure outbound doorbell window */
-	out_be32(&priv->dbell_atmu_regs->rowbar, 0x000c0400);
-	out_be32(&priv->dbell_atmu_regs->rowar, 0x8004200b);
+	out_be32(&priv->dbell_atmu_regs->rowbar,
+			(law_start + RIO_MAINT_WIN_SIZE) >> 12);
+	out_be32(&priv->dbell_atmu_regs->rowar, 0x8004200b);	/* 4k */
 	fsl_rio_doorbell_init(port);
 
 	return 0;
_

Patches currently in -mm which might be from leoli@freescale.com are

linux-next.patch
rapidio-add-common-mapping-apis-for-rapidio-memory-access.patch
powerpc-add-memory-map-support-to-freescale-rapidio-block.patch
rionet-add-memory-access-to-simulated-ethernet-over-rapidio.patch
rio-warn_unused_result-warnings-fix.patch

