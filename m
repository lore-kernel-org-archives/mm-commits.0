From: akpm@linux-foundation.org
Subject: - rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch removed from -mm tree
Date: Wed, 30 Apr 2008 15:25:27 -0700
Message-ID: <200804302225.m3UMPRWl006691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760798AbYD3W0D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 18:26:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, galak@gate.crashing.org, mm-commits@vger.kernel.org


The patch titled
     rapidio: add FSL RapidIO controller memory ops functions
has been removed from the -mm tree.  Its filename was
     rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: add FSL RapidIO controller memory ops functions
From: Zhang Wei <wei.zhang@freescale.com>

Add FSL RapidIO controller (MPC85xx, MPC86xx) memory operation functions,
which include map inbound/outbound window and unmap incound/outbound window.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |  204 ++++++++++++++++++++++++++++++++
 1 file changed, 204 insertions(+)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-add-fsl-rapidio-controller-memory-ops-functions arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-add-fsl-rapidio-controller-memory-ops-functions
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -30,6 +30,8 @@
 #define IRQ_RIO_TX(m)		(((struct rio_priv *)(m->priv))->txirq)
 #define IRQ_RIO_RX(m)		(((struct rio_priv *)(m->priv))->rxirq)
 
+#define IS_64BIT_RES ((sizeof(resource_size_t) == 8) ? 1 : 0)
+
 #define RIO_ATMU_REGS_OFFSET	0x10c00
 #define RIO_P_MSG_REGS_OFFSET	0x11000
 #define RIO_S_MSG_REGS_OFFSET	0x13000
@@ -39,6 +41,15 @@
 #define RIO_ISR_AACR_AA		0x1	/* Accept All ID */
 #define RIO_MAINT_WIN_SIZE	0x400000
 #define RIO_DBELL_WIN_SIZE	0x1000
+#define RIO_MAX_INB_ATMU	4
+#define RIO_MAX_OUTB_ATMU	8
+#define RIO_INB_ATMU_REGS_OFFSET	0x10de0
+#define RIO_ATMU_EN_MASK	0x80000000
+
+#define RIO_NREAD		0x4
+#define RIO_NWRITE		0x4
+#define RIO_NWRITE_R		0x5
+#define RIO_NREAD_R		0x5
 
 #define RIO_MSG_OMR_MUI		0x00000002
 #define RIO_MSG_OSR_TE		0x00000080
@@ -82,6 +93,15 @@ struct rio_atmu_regs {
 	u32 pad3[3];
 };
 
+struct rio_inb_atmu_regs {
+	u32 riwtar;
+	u32 pad1;
+	u32 riwbar;
+	u32 pad2;
+	u32 riwar;
+	u32 pad3[3];
+};
+
 struct rio_msg_regs {
 	u32 omr;
 	u32 osr;
@@ -334,6 +354,182 @@ fsl_rio_config_write(struct rio_mport *m
 }
 
 /**
+ * fsl_rio_map_inb_mem -- Mapping inbound memory region.
+ * @lstart: Local memory space start address.
+ * @rstart: RapidIO space start address.
+ * @size: The mapping region size.
+ * @flags: Flags for mapping. 0 for using default flags.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the inbound mapping
+ * from rstart to lstart.
+ */
+static int fsl_rio_map_inb_mem(struct rio_mport *mport, resource_size_t lstart,
+		resource_size_t rstart,	resource_size_t size, u32 flags)
+{
+	int i;
+	struct rio_priv *priv = mport->priv;
+	struct rio_inb_atmu_regs __iomem *inbatmu = (struct rio_inb_atmu_regs *)
+				(priv->regs_win + RIO_INB_ATMU_REGS_OFFSET) - 1;
+	int size_ffs;
+	resource_size_t align;
+
+	if (flags == 0)
+		flags = (RIO_NREAD_R << 4) | RIO_NWRITE_R;
+
+	align = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	/* Align the size */
+	if ((lstart + size) > (_ALIGN_DOWN(lstart, align) + align)) {
+		size_ffs = __ffs(_ALIGN_DOWN(lstart + size - 1, align));
+		size = 1 << (size_ffs +	(((_ALIGN_DOWN(lstart, 1 << size_ffs) +
+				(1 << size_ffs)) < (lstart + size)) ? 1 : 0));
+	} else
+		size = align;
+
+	if ((lstart & (size - 1)) != (rstart & (size - 1))) {
+		dev_err(mport->dev, "The local address 0x%x can not be aligned "
+			"to the same size 0x%x with the RapidIO space "
+			"address 0x%x!\n", lstart, size, rstart);
+		return -EINVAL;
+	}
+
+	/* Search for free inbound ATMU */
+	for (i = 1;
+		(i <= RIO_MAX_INB_ATMU) && (inbatmu->riwar & RIO_ATMU_EN_MASK);
+		i++, inbatmu--)
+		;
+
+	if (i > RIO_MAX_INB_ATMU) {
+		dev_err(mport->dev, "No free inbound ATMU!\n");
+		return -EBUSY;
+	}
+	out_be32(&inbatmu->riwtar, ((IS_64BIT_RES ? (lstart >> 32)
+				& 0xf : 0) << 20) | ((lstart >> 12) & 0xfffff));
+	out_be32(&inbatmu->riwbar, ((IS_64BIT_RES ? (rstart >> 32)
+				& 0x3 : 0) << 20) | ((rstart >> 12) & 0xfffff));
+	out_be32(&inbatmu->riwar, 0x80000000 | (0xf << 20)
+				| ((flags & 0xff) << 12)
+				| (__ilog2(size) - 1));
+	return 0;
+}
+
+/**
+ * fsl_rio_map_outb_mem -- Mapping outbound memory region.
+ * @lstart: Local memory space start address.
+ * @rstart: RapidIO space start address.
+ * @size: The mapping region size.
+ * @tid: The target RapidIO device id.
+ * @flags: Flags for mapping. 0 for using default flags.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the outbound mapping
+ * from lstart to rstart.
+ */
+static int fsl_rio_map_outb_mem(struct rio_mport *mport, resource_size_t lstart,
+		resource_size_t rstart,	resource_size_t size,
+		u16 tid, u32 flags)
+{
+	int i;
+	struct rio_priv *priv = mport->priv;
+	struct rio_atmu_regs __iomem *outbatmu = (struct rio_atmu_regs *)
+			(priv->regs_win + RIO_ATMU_REGS_OFFSET) + 1;
+	int size_ffs;
+	resource_size_t align;
+
+	if (flags == 0)
+		flags = (RIO_NREAD << 4) | RIO_NWRITE_R;
+
+	align = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	/* Align the size */
+	if ((lstart + size) > (_ALIGN_DOWN(lstart, align) + align)) {
+		size_ffs = __ffs(_ALIGN_DOWN(lstart + size - 1, align));
+		size = 1 << (size_ffs +	(((_ALIGN_DOWN(lstart, 1 << size_ffs) +
+				(1 << size_ffs)) < (lstart + size)) ? 1 : 0));
+	} else
+		size = align;
+
+	if ((lstart & (size - 1)) != (rstart & (size - 1))) {
+		dev_err(mport->dev, "The local address 0x%x can not be aligned "
+			"to the same size 0x%x with the RapidIO space address "
+			"0x%x!\n", lstart, size, rstart);
+		return -EINVAL;
+	}
+
+	/* Search for free outbound ATMU */
+	for (i = 1;
+	      (i <= RIO_MAX_OUTB_ATMU) && (outbatmu->rowar & RIO_ATMU_EN_MASK);
+	      i++, outbatmu++)
+		;
+
+	if (i > RIO_MAX_OUTB_ATMU) {
+		dev_err(mport->dev, "No free outbound ATMU!\n");
+		return -EBUSY;
+	}
+	out_be32(&outbatmu->rowtar, ((tid & 0x3ff) << 22)
+			| ((IS_64BIT_RES ? (rstart >> 32) & 0x3 : 0) << 20)
+			| ((rstart >> 12) & 0xfffff));
+	if (mport->phy_type == RIO_PHY_SERIAL)
+		out_be32(&outbatmu->rowtear, tid >> 10);
+	out_be32(&outbatmu->rowbar, ((IS_64BIT_RES ?
+					(lstart >> 32) & 0xf : 0) << 20)
+					| ((lstart >> 12) & 0xfffff));
+	out_be32(&outbatmu->rowar, 0x80000000
+				| ((flags & 0xff) << 12)
+				| (__ilog2(size) - 1));
+	return 0;
+}
+
+/**
+ * fsl_rio_unmap_inb_mem -- Unmapping inbound memory region.
+ * @lstart: Local memory space start address.
+ */
+static void fsl_rio_unmap_inb_mem(struct rio_mport *mport,
+				resource_size_t lstart)
+{
+	int i;
+	struct rio_priv *priv = mport->priv;
+	struct rio_inb_atmu_regs __iomem *inbatmu = (struct rio_inb_atmu_regs *)
+			(priv->regs_win + RIO_INB_ATMU_REGS_OFFSET) - 1;
+
+	/* Search for inbound ATMU */
+	for (i = 1; i <= RIO_MAX_INB_ATMU ; i++, inbatmu--) {
+		u32 tar = ((IS_64BIT_RES ? (lstart >> 32) & 0xf : 0) << 20)
+			| ((lstart >> 12) & 0xfffff);
+		if (inbatmu->riwtar == tar) {
+			out_be32(&inbatmu->riwar, ~(RIO_ATMU_EN_MASK));
+			return;
+		}
+	}
+}
+
+/**
+ * fsl_rio_unmap_inb_mem -- Unmapping outbound memory region.
+ * @lstart: Local memory space start address.
+ */
+static void fsl_rio_unmap_outb_mem(struct rio_mport *mport,
+				resource_size_t lstart)
+{
+	int i;
+	struct rio_priv *priv = mport->priv;
+	struct rio_atmu_regs __iomem *outbatmu = (struct rio_atmu_regs *)
+			(priv->regs_win + RIO_ATMU_REGS_OFFSET) + 1;
+
+	/* Search for outbound ATMU */
+	for (i = 1; i <= RIO_MAX_OUTB_ATMU ; i++, outbatmu++) {
+		u32 bar = ((IS_64BIT_RES ? (lstart >> 32) & 0xf : 0) << 20)
+			| ((lstart >> 12) & 0xfffff);
+		if (outbatmu->rowbar == bar) {
+			out_be32(&outbatmu->rowar, ~(RIO_ATMU_EN_MASK));
+			return;
+		}
+	}
+}
+
+/**
  * rio_hw_add_outb_message - Add message to the MPC85xx outbound message queue
  * @mport: Master port with outbound message queue
  * @rdev: Target of outbound message
@@ -953,6 +1149,13 @@ static int fsl_rio_get_cmdline(char *s)
 
 __setup("riohdid=", fsl_rio_get_cmdline);
 
+static struct rio_mem_ops fsl_mem_ops = {
+	.map_inb = fsl_rio_map_inb_mem,
+	.map_outb = fsl_rio_map_outb_mem,
+	.unmap_inb = fsl_rio_unmap_inb_mem,
+	.unmap_outb = fsl_rio_unmap_outb_mem,
+};
+
 static inline void fsl_rio_info(struct device *dev, u32 ccsr)
 {
 	const char *str;
@@ -1096,6 +1299,7 @@ int fsl_rio_setup(struct of_device *dev)
 	strcpy(port->name, "RIO0 mport");
 
 	port->ops = ops;
+	port->mops = &fsl_mem_ops;
 	port->host_deviceid = fsl_rio_get_hdid(port->id);
 
 	port->priv = priv;
_

Patches currently in -mm which might be from wei.zhang@freescale.com are

origin.patch
rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch
rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
rapidio-fix-docbook-references.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

