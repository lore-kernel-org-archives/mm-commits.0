From: akpm@linux-foundation.org
Subject: - rapidio-add-serial-rapidio-controller-support-which-includes-mpc8548-mpc8641.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:51:19 -0700
Message-ID: <200804300551.m3U5pJWD030212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758875AbYD3FvZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: add serial RapidIO controller support, which includes MPC8548, MPC8641
has been removed from the -mm tree.  Its filename was
     rapidio-add-serial-rapidio-controller-support-which-includes-mpc8548-mpc8641.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: add serial RapidIO controller support, which includes MPC8548, MPC8641
From: Zhang Wei <wei.zhang@freescale.com>

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   75 +++++++++++++++++++++++++++-----
 include/linux/rio.h           |    6 ++
 2 files changed, 70 insertions(+), 11 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-add-serial-rapidio-controller-support-which-includes-mpc8548-mpc8641 arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-add-serial-rapidio-controller-support-which-includes-mpc8548-mpc8641
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -21,6 +21,7 @@
 #include <linux/rio.h>
 #include <linux/rio_drv.h>
 #include <linux/of_platform.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 
@@ -30,7 +31,12 @@
 #define IRQ_RIO_RX(m)		(((struct rio_priv *)(m->priv))->rxirq)
 
 #define RIO_ATMU_REGS_OFFSET	0x10c00
-#define RIO_MSG_REGS_OFFSET	0x11000
+#define RIO_P_MSG_REGS_OFFSET	0x11000
+#define RIO_S_MSG_REGS_OFFSET	0x13000
+#define RIO_ESCSR		0x158
+#define RIO_CCSR		0x15c
+#define RIO_ISR_AACR		0x10120
+#define RIO_ISR_AACR_AA		0x1	/* Accept All ID */
 #define RIO_MAINT_WIN_SIZE	0x400000
 #define RIO_DBELL_WIN_SIZE	0x1000
 
@@ -69,7 +75,7 @@
 
 struct rio_atmu_regs {
 	u32 rowtar;
-	u32 pad1;
+	u32 rowtear;
 	u32 rowbar;
 	u32 pad2;
 	u32 rowar;
@@ -95,7 +101,15 @@ struct rio_msg_regs {
 	u32 ifqdpar;
 	u32 pad6;
 	u32 ifqepar;
-	u32 pad7[250];
+	u32 pad7[226];
+	u32 odmr;
+	u32 odsr;
+	u32 res0[4];
+	u32 oddpr;
+	u32 oddatr;
+	u32 res1[3];
+	u32 odretcr;
+	u32 res2[12];
 	u32 dmr;
 	u32 dsr;
 	u32 pad8;
@@ -175,8 +189,22 @@ static int fsl_rio_doorbell_send(struct 
 	struct rio_priv *priv = mport->priv;
 	pr_debug("fsl_doorbell_send: index %d destid %4.4x data %4.4x\n",
 		 index, destid, data);
-	out_be32(&priv->dbell_atmu_regs->rowtar, destid << 22);
-	out_be16(priv->dbell_win, data);
+	switch (mport->phy_type) {
+	case RIO_PHY_PARALLEL:
+		out_be32(&priv->dbell_atmu_regs->rowtar, destid << 22);
+		out_be16(priv->dbell_win, data);
+		break;
+	case RIO_PHY_SERIAL:
+		/* In the serial version silicons, such as MPC8548, MPC8641,
+		 * below operations is must be.
+		 */
+		out_be32(&priv->msg_regs->odmr, 0x00000000);
+		out_be32(&priv->msg_regs->odretcr, 0x00000004);
+		out_be32(&priv->msg_regs->oddpr, destid << 16);
+		out_be32(&priv->msg_regs->oddatr, data);
+		out_be32(&priv->msg_regs->odmr, 0x00000001);
+		break;
+	}
 
 	return 0;
 }
@@ -342,11 +370,22 @@ rio_hw_add_outb_message(struct rio_mport
 		memset(priv->msg_tx_ring.virt_buffer[priv->msg_tx_ring.tx_slot]
 				+ len, 0, RIO_MAX_MSG_SIZE - len);
 
-	/* Set mbox field for message */
-	desc->dport = mbox & 0x3;
+	switch (mport->phy_type) {
+	case RIO_PHY_PARALLEL:
+		/* Set mbox field for message */
+		desc->dport = mbox & 0x3;
 
-	/* Enable EOMI interrupt, set priority, and set destid */
-	desc->dattr = 0x28000000 | (rdev->destid << 2);
+		/* Enable EOMI interrupt, set priority, and set destid */
+		desc->dattr = 0x28000000 | (rdev->destid << 2);
+		break;
+	case RIO_PHY_SERIAL:
+		/* Set mbox field for message, and set destid */
+		desc->dport = (rdev->destid << 16) | (mbox & 0x3);
+
+		/* Enable EOMI interrupt and priority */
+		desc->dattr = 0x28000000;
+		break;
+	}
 
 	/* Set transfer size aligned to next power of 2 (in double words) */
 	desc->dwcnt = is_power_of_2(len) ? len : 1 << get_bitmask_order(len);
@@ -920,6 +959,7 @@ int fsl_rio_setup(struct of_device *dev)
 	const u32 *dt_range, *cell;
 	struct resource regs;
 	int rlen;
+	u32 ccsr;
 	u64 law_start, law_size;
 	int paw, aw, sw;
 
@@ -1008,6 +1048,14 @@ int fsl_rio_setup(struct of_device *dev)
 
 	priv->regs_win = ioremap(regs.start, regs.end - regs.start + 1);
 
+	/* Probe the master port phy type */
+	ccsr = in_be32(priv->regs_win + RIO_CCSR);
+	port->phy_type = (ccsr & 1) ? RIO_PHY_SERIAL : RIO_PHY_PARALLEL;
+	dev_info(&dev->dev, "RapidIO PHY type: %s\n",
+			(port->phy_type == RIO_PHY_PARALLEL) ? "parallel" :
+			((port->phy_type == RIO_PHY_SERIAL) ? "serial" :
+			 "unknown"));
+
 	port->sys_size = (in_be32((priv->regs_win + RIO_PEF_CAR))
 					& RIO_PEF_CTLS) >> 4;
 	dev_info(&dev->dev, "RapidIO Common Transport System size: %d\n",
@@ -1017,8 +1065,13 @@ int fsl_rio_setup(struct of_device *dev)
 					+ RIO_ATMU_REGS_OFFSET);
 	priv->maint_atmu_regs = priv->atmu_regs + 1;
 	priv->dbell_atmu_regs = priv->atmu_regs + 2;
-	priv->msg_regs = (struct rio_msg_regs *)(priv->regs_win
-							+ RIO_MSG_REGS_OFFSET);
+	priv->msg_regs = (struct rio_msg_regs *)(priv->regs_win +
+				((port->phy_type == RIO_PHY_SERIAL) ?
+				RIO_S_MSG_REGS_OFFSET : RIO_P_MSG_REGS_OFFSET));
+
+	/* Set to receive any dist ID for serial RapidIO controller. */
+	if (port->phy_type == RIO_PHY_SERIAL)
+		out_be32((priv->regs_win + RIO_ISR_AACR), RIO_ISR_AACR_AA);
 
 	/* Configure maintenance transaction window */
 	out_be32(&priv->maint_atmu_regs->rowbar, 0x000c0000);
diff -puN include/linux/rio.h~rapidio-add-serial-rapidio-controller-support-which-includes-mpc8548-mpc8641 include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-serial-rapidio-controller-support-which-includes-mpc8548-mpc8641
+++ a/include/linux/rio.h
@@ -145,6 +145,11 @@ struct rio_dbell {
 	void *dev_id;
 };
 
+enum rio_phy_type {
+	RIO_PHY_PARALLEL,
+	RIO_PHY_SERIAL,
+};
+
 /**
  * struct rio_mport - RIO master port info
  * @dbells: List of doorbell events
@@ -178,6 +183,7 @@ struct rio_mport {
 				 * 0 - Small size. 256 devices.
 				 * 1 - Large size, 65536 devices.
 				 */
+	enum rio_phy_type phy_type;	/* RapidIO phy type */
 	unsigned char name[40];
 	void *priv;		/* Master port private data */
 };
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

