From: akpm@linux-foundation.org
Subject: - rapidio-add-rapidio-connection-info-print-out-and-re-training-for-break-connection.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:51:21 -0700
Message-ID: <200804300551.m3U5pLSG030215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757616AbYD3Fv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: add RapidIO connection info print out and re-training for break connection
has been removed from the -mm tree.  Its filename was
     rapidio-add-rapidio-connection-info-print-out-and-re-training-for-break-connection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: add RapidIO connection info print out and re-training for break connection
From: Zhang Wei <wei.zhang@freescale.com>

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   71 ++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-add-rapidio-connection-info-print-out-and-re-training-for-break-connection arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-add-rapidio-connection-info-print-out-and-re-training-for-break-connection
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -942,6 +942,48 @@ static int fsl_rio_get_cmdline(char *s)
 
 __setup("riohdid=", fsl_rio_get_cmdline);
 
+static inline void fsl_rio_info(struct device *dev, u32 ccsr)
+{
+	const char *str;
+	if (ccsr & 1) {
+		/* Serial phy */
+		switch (ccsr >> 30) {
+		case 0:
+			str = "1";
+			break;
+		case 1:
+			str = "4";
+			break;
+		default:
+			str = "Unknown";
+			break;;
+		}
+		dev_info(dev, "Hardware port width: %s\n", str);
+
+		switch ((ccsr >> 27) & 7) {
+		case 0:
+			str = "Single-lane 0";
+			break;
+		case 1:
+			str = "Single-lane 2";
+			break;
+		case 2:
+			str = "Four-lane";
+			break;
+		default:
+			str = "Unknown";
+			break;
+		}
+		dev_info(dev, "Training connection status: %s\n", str);
+	} else {
+		/* Parallel phy */
+		if (!(ccsr & 0x80000000))
+			dev_info(dev, "Output port operating in 8-bit mode\n");
+		if (!(ccsr & 0x08000000))
+			dev_info(dev, "Input port operating in 8-bit mode\n");
+	}
+}
+
 /**
  * fsl_rio_setup - Setup MPC85xx RapidIO interface
  * @fsl_rio_setup - Setup Freescale PowerPC RapidIO interface
@@ -1055,6 +1097,35 @@ int fsl_rio_setup(struct of_device *dev)
 			(port->phy_type == RIO_PHY_PARALLEL) ? "parallel" :
 			((port->phy_type == RIO_PHY_SERIAL) ? "serial" :
 			 "unknown"));
+	/* Checking the port training status */
+	if (in_be32((priv->regs_win + RIO_ESCSR)) & 1) {
+		dev_err(&dev->dev, "Port is not ready. "
+				   "Try to restart connection...\n");
+		switch (port->phy_type) {
+		case RIO_PHY_SERIAL:
+			/* Disable ports */
+			out_be32(priv->regs_win + RIO_CCSR, 0);
+			/* Set 1x lane */
+			setbits32(priv->regs_win + RIO_CCSR, 0x02000000);
+			/* Enable ports */
+			setbits32(priv->regs_win + RIO_CCSR, 0x00600000);
+			break;
+		case RIO_PHY_PARALLEL:
+			/* Disable ports */
+			out_be32(priv->regs_win + RIO_CCSR, 0x22000000);
+			/* Enable ports */
+			out_be32(priv->regs_win + RIO_CCSR, 0x44000000);
+			break;
+		}
+		msleep(100);
+		if (in_be32((priv->regs_win + RIO_ESCSR)) & 1) {
+			dev_err(&dev->dev, "Port restart failed.\n");
+			rc = -ENOLINK;
+			goto err;
+		}
+		dev_info(&dev->dev, "Port restart success!\n");
+	}
+	fsl_rio_info(&dev->dev, ccsr);
 
 	port->sys_size = (in_be32((priv->regs_win + RIO_PEF_CAR))
 					& RIO_PEF_CTLS) >> 4;
_

Patches currently in -mm which might be from wei.zhang@freescale.com are

origin.patch
rapidio-add-memory-mapping-driver-to-rapidio.patch
rapidio-add-rapidio-space-allocation-bitmap-arithmetic.patch
rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch
rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
rapidio-fix-docbook-references.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

