From: akpm@linux-foundation.org
Subject: + rapidio-add-rapidio-connection-info-print-out-and-re-training-for-break-connection.patch added to -mm tree
Date: Tue, 11 Mar 2008 21:24:16 -0700
Message-ID: <200803120424.m2C4OG5I009840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbYCLEYj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 00:24:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wei.zhang@freescale.com


The patch titled
     rapidio: add RapidIO connection info print out and re-training for break connection
has been added to the -mm tree.  Its filename is
     rapidio-add-rapidio-connection-info-print-out-and-re-training-for-break-connection.patch

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

