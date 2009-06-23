From: akpm@linux-foundation.org
Subject: [to-be-updated] powerpc-add-memory-map-support-to-freescale-rapidio-block.patch removed from -mm tree
Date: Mon, 22 Jun 2009 22:18:55 -0700
Message-ID: <200906230518.n5N5ItBV010456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbZFWFTD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 01:19:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leoli@freescale.com, benh@kernel.crashing.org, galak@gate.crashing.org, mporter@kernel.crashing.org, zw@zh-kernel.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: add memory map support to Freescale RapidIO block
has been removed from the -mm tree.  Its filename was
     powerpc-add-memory-map-support-to-freescale-rapidio-block.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: add memory map support to Freescale RapidIO block
From: Li Yang <leoli@freescale.com>

The RIO memory map functions are used to support direct IO memory access
to RapidIO space.  The patch adds its support for Freescale RapidIO block
driver.

Signed-off-by: Zhang Wei <zw@zh-kernel.org>
Signed-off-by: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |  212 ++++++++++++++++++++++++++++++++
 1 file changed, 212 insertions(+)

diff -puN arch/powerpc/sysdev/fsl_rio.c~powerpc-add-memory-map-support-to-freescale-rapidio-block arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~powerpc-add-memory-map-support-to-freescale-rapidio-block
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -31,6 +31,9 @@
 #define IRQ_RIO_TX(m)		(((struct rio_priv *)(m->priv))->txirq)
 #define IRQ_RIO_RX(m)		(((struct rio_priv *)(m->priv))->rxirq)
 
+#define IS_64BIT_DMA		((sizeof(dma_addr_t) == 8) ? 1 : 0)
+#define IS_64BIT_PHYS		((sizeof(phys_addr_t) == 8) ? 1 : 0)
+
 #define RIO_ATMU_REGS_OFFSET	0x10c00
 #define RIO_P_MSG_REGS_OFFSET	0x11000
 #define RIO_S_MSG_REGS_OFFSET	0x13000
@@ -40,6 +43,15 @@
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
@@ -83,6 +95,15 @@ struct rio_atmu_regs {
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
@@ -341,6 +362,188 @@ fsl_rio_config_write(struct rio_mport *m
 }
 
 /**
+ * fsl_rio_map_inb_mem -- Mapping inbound memory region.
+ * @mport: RapidIO master port
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
+static int fsl_rio_map_inb_mem(struct rio_mport *mport, dma_addr_t lstart,
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
+		dev_err(mport->dev, "The local address 0x%llx can not be "
+			"aligned to the same size 0x%llx with the RapidIO "
+			"space address 0x%llx!\n", (unsigned long long)lstart,
+			(unsigned long long)size, (unsigned long long)rstart);
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
+	out_be32(&inbatmu->riwtar, ((IS_64BIT_DMA ? (lstart >> 32)
+				& 0xf : 0) << 20) | ((lstart >> 12) & 0xfffff));
+	out_be32(&inbatmu->riwbar, ((IS_64BIT_DMA ? (rstart >> 32)
+				& 0x3 : 0) << 20) | ((rstart >> 12) & 0xfffff));
+	out_be32(&inbatmu->riwar, 0x80000000 | (0xf << 20)
+				| ((flags & 0xff) << 12)
+				| (__ilog2(size) - 1));
+	return 0;
+}
+
+/**
+ * fsl_rio_map_outb_mem -- Mapping outbound memory region.
+ * @mport: RapidIO master port
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
+static int fsl_rio_map_outb_mem(struct rio_mport *mport, phys_addr_t lstart,
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
+		dev_err(mport->dev, "The local address 0x%llx can not be "
+			"aligned to the same size 0x%llx with the RapidIO "
+			"space address 0x%llx!\n", (unsigned long long)lstart,
+			(unsigned long long)size, (unsigned long long)rstart);
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
+			| ((IS_64BIT_PHYS ? (rstart >> 32) & 0x3 : 0) << 20)
+			| ((rstart >> 12) & 0xfffff));
+	if (mport->phy_type == RIO_PHY_SERIAL)
+		out_be32(&outbatmu->rowtear, tid >> 10);
+	out_be32(&outbatmu->rowbar, ((IS_64BIT_PHYS ?
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
+ * @mport: RapidIO master port
+ * @lstart: Local memory space start address.
+ */
+static void fsl_rio_unmap_inb_mem(struct rio_mport *mport,
+				dma_addr_t lstart)
+{
+	int i;
+	struct rio_priv *priv = mport->priv;
+	struct rio_inb_atmu_regs __iomem *inbatmu = (struct rio_inb_atmu_regs *)
+			(priv->regs_win + RIO_INB_ATMU_REGS_OFFSET) - 1;
+
+	/* Search for inbound ATMU */
+	for (i = 1; i <= RIO_MAX_INB_ATMU ; i++, inbatmu--) {
+		u32 tar = ((IS_64BIT_DMA ? (lstart >> 32) & 0xf : 0) << 20)
+			| ((lstart >> 12) & 0xfffff);
+		if (inbatmu->riwtar == tar) {
+			out_be32(&inbatmu->riwar, ~(RIO_ATMU_EN_MASK));
+			return;
+		}
+	}
+}
+
+/**
+ * fsl_rio_unmap_outb_mem -- Unmapping outbound memory region.
+ * @mport: RapidIO master port
+ * @lstart: Local memory space start address.
+ */
+static void fsl_rio_unmap_outb_mem(struct rio_mport *mport,
+				phys_addr_t lstart)
+{
+	int i;
+	struct rio_priv *priv = mport->priv;
+	struct rio_atmu_regs __iomem *outbatmu = (struct rio_atmu_regs *)
+			(priv->regs_win + RIO_ATMU_REGS_OFFSET) + 1;
+
+	/* Search for outbound ATMU */
+	for (i = 1; i <= RIO_MAX_OUTB_ATMU ; i++, outbatmu++) {
+		u32 bar = ((IS_64BIT_PHYS ? (lstart >> 32) & 0xf : 0) << 20)
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
@@ -951,6 +1154,13 @@ static int fsl_rio_get_cmdline(char *s)
 
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
@@ -1066,6 +1276,7 @@ int fsl_rio_setup(struct of_device *dev)
 	port = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
 	port->id = 0;
 	port->index = 0;
+	port->dev = &dev->dev;
 
 	priv = kzalloc(sizeof(struct rio_priv), GFP_KERNEL);
 	if (!priv) {
@@ -1094,6 +1305,7 @@ int fsl_rio_setup(struct of_device *dev)
 	priv->dev = &dev->dev;
 
 	port->ops = ops;
+	port->mops = &fsl_mem_ops;
 	port->host_deviceid = fsl_rio_get_hdid(port->id);
 
 	port->priv = priv;
_

Patches currently in -mm which might be from leoli@freescale.com are

origin.patch
powerpc-add-memory-map-support-to-freescale-rapidio-block.patch
rionet-add-memory-access-to-simulated-ethernet-over-rapidio.patch

