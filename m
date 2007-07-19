From: akpm@linux-foundation.org
Subject: + serial-mpsc-fix-coding-style-and-whitespace-issues.patch added to -mm tree
Date: Thu, 19 Jul 2007 14:41:26 -0700
Message-ID: <200707192141.l6JLfQ9g024475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760139AbXGSVmy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 17:42:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgreer@mvista.com


The patch titled
     serial: MPSC: Fix coding style and whitespace issues
has been added to the -mm tree.  Its filename is
     serial-mpsc-fix-coding-style-and-whitespace-issues.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: MPSC: Fix coding style and whitespace issues
From: "Mark A. Greer" <mgreer@mvista.com>

Fix up mpsc.c to be aligned with Documentation/CodingStyle.  Also fix up some
whitespace issues.

Signed-off-by: Mark A. Greer <mgreer@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mpsc.c |  684 ++++++++++++++++------------------------
 1 files changed, 283 insertions(+), 401 deletions(-)

diff -puN drivers/serial/mpsc.c~serial-mpsc-fix-coding-style-and-whitespace-issues drivers/serial/mpsc.c
--- a/drivers/serial/mpsc.c~serial-mpsc-fix-coding-style-and-whitespace-issues
+++ a/drivers/serial/mpsc.c
@@ -93,9 +93,8 @@
 #define	MPSC_TXBE_SIZE		dma_get_cache_alignment()
 #define	MPSC_TXB_SIZE		(MPSC_TXR_ENTRIES * MPSC_TXBE_SIZE)
 
-#define	MPSC_DMA_ALLOC_SIZE	(MPSC_RXR_SIZE + MPSC_RXB_SIZE +	\
-				MPSC_TXR_SIZE + MPSC_TXB_SIZE +		\
-				dma_get_cache_alignment() /* for alignment */)
+#define	MPSC_DMA_ALLOC_SIZE	(MPSC_RXR_SIZE + MPSC_RXB_SIZE + MPSC_TXR_SIZE \
+		+ MPSC_TXB_SIZE + dma_get_cache_alignment() /* for alignment */)
 
 /* Rx and Tx Ring entry descriptors -- assume entry size is <= cacheline size */
 struct mpsc_rx_desc {
@@ -266,8 +265,8 @@ struct mpsc_port_info *mpsc_device_remov
 #define	SDMA_DESC_CMDSTAT_EI		(1<<23)
 #define	SDMA_DESC_CMDSTAT_O		(1<<31)
 
-#define SDMA_DESC_DFLT			(SDMA_DESC_CMDSTAT_O |	\
-					SDMA_DESC_CMDSTAT_EI)
+#define SDMA_DESC_DFLT			(SDMA_DESC_CMDSTAT_O \
+		| SDMA_DESC_CMDSTAT_EI)
 
 #define	SDMA_SDC_RFT			(1<<0)
 #define	SDMA_SDC_SFM			(1<<1)
@@ -291,10 +290,10 @@ struct mpsc_port_info *mpsc_device_remov
 #define	SDMA_1_CAUSE_TXBUF		(1<<10)
 #define	SDMA_1_CAUSE_TXEND		(1<<11)
 
-#define	SDMA_CAUSE_RX_MASK	(SDMA_0_CAUSE_RXBUF | SDMA_0_CAUSE_RXERR | \
-	SDMA_1_CAUSE_RXBUF | SDMA_1_CAUSE_RXERR)
-#define	SDMA_CAUSE_TX_MASK	(SDMA_0_CAUSE_TXBUF | SDMA_0_CAUSE_TXEND | \
-	SDMA_1_CAUSE_TXBUF | SDMA_1_CAUSE_TXEND)
+#define	SDMA_CAUSE_RX_MASK	(SDMA_0_CAUSE_RXBUF | SDMA_0_CAUSE_RXERR \
+		| SDMA_1_CAUSE_RXBUF | SDMA_1_CAUSE_RXERR)
+#define	SDMA_CAUSE_TX_MASK	(SDMA_0_CAUSE_TXBUF | SDMA_0_CAUSE_TXEND \
+		| SDMA_1_CAUSE_TXBUF | SDMA_1_CAUSE_TXEND)
 
 /* SDMA Interrupt registers */
 #define	SDMA_INTR_CAUSE			0x0000
@@ -308,11 +307,11 @@ struct mpsc_port_info *mpsc_device_remov
  * Define how this driver is known to the outside (we've been assigned a
  * range on the "Low-density serial ports" major).
  */
-#define MPSC_MAJOR		204
-#define MPSC_MINOR_START	44
-#define	MPSC_DRIVER_NAME	"MPSC"
-#define	MPSC_DEV_NAME		"ttyMM"
-#define	MPSC_VERSION		"1.00"
+#define MPSC_MAJOR			204
+#define MPSC_MINOR_START		44
+#define	MPSC_DRIVER_NAME		"MPSC"
+#define	MPSC_DEV_NAME			"ttyMM"
+#define	MPSC_VERSION			"1.00"
 
 static struct mpsc_port_info mpsc_ports[MPSC_NUM_CTLRS];
 static struct mpsc_shared_regs mpsc_shared_regs;
@@ -328,8 +327,7 @@ static void mpsc_release_port(struct uar
  *
  ******************************************************************************
  */
-static void
-mpsc_brg_init(struct mpsc_port_info *pi, u32 clk_src)
+static void mpsc_brg_init(struct mpsc_port_info *pi, u32 clk_src)
 {
 	u32	v;
 
@@ -345,11 +343,9 @@ mpsc_brg_init(struct mpsc_port_info *pi,
 
 	writel(readl(pi->brg_base + BRG_BTR) & 0xffff0000,
 		pi->brg_base + BRG_BTR);
-	return;
 }
 
-static void
-mpsc_brg_enable(struct mpsc_port_info *pi)
+static void mpsc_brg_enable(struct mpsc_port_info *pi)
 {
 	u32	v;
 
@@ -359,11 +355,9 @@ mpsc_brg_enable(struct mpsc_port_info *p
 	if (pi->mirror_regs)
 		pi->BRG_BCR_m = v;
 	writel(v, pi->brg_base + BRG_BCR);
-	return;
 }
 
-static void
-mpsc_brg_disable(struct mpsc_port_info *pi)
+static void mpsc_brg_disable(struct mpsc_port_info *pi)
 {
 	u32	v;
 
@@ -373,21 +367,19 @@ mpsc_brg_disable(struct mpsc_port_info *
 	if (pi->mirror_regs)
 		pi->BRG_BCR_m = v;
 	writel(v, pi->brg_base + BRG_BCR);
-	return;
 }
 
-static inline void
-mpsc_set_baudrate(struct mpsc_port_info *pi, u32 baud)
+/*
+ * To set the baud, we adjust the CDV field in the BRG_BCR reg.
+ * From manual: Baud = clk / ((CDV+1)*2) ==> CDV = (clk / (baud*2)) - 1.
+ * However, the input clock is divided by 16 in the MPSC b/c of how
+ * 'MPSC_MMCRH' was set up so we have to divide the 'clk' used in our
+ * calculation by 16 to account for that.  So the real calculation
+ * that accounts for the way the mpsc is set up is:
+ * CDV = (clk / (baud*2*16)) - 1 ==> CDV = (clk / (baud << 5)) - 1.
+ */
+static void mpsc_set_baudrate(struct mpsc_port_info *pi, u32 baud)
 {
-	/*
-	 * To set the baud, we adjust the CDV field in the BRG_BCR reg.
-	 * From manual: Baud = clk / ((CDV+1)*2) ==> CDV = (clk / (baud*2)) - 1.
-	 * However, the input clock is divided by 16 in the MPSC b/c of how
-	 * 'MPSC_MMCRH' was set up so we have to divide the 'clk' used in our
-	 * calculation by 16 to account for that.  So the real calculation
-	 * that accounts for the way the mpsc is set up is:
-	 * CDV = (clk / (baud*2*16)) - 1 ==> CDV = (clk / (baud << 5)) - 1.
-	 */
 	u32	cdv = (pi->port.uartclk / (baud << 5)) - 1;
 	u32	v;
 
@@ -399,8 +391,6 @@ mpsc_set_baudrate(struct mpsc_port_info 
 		pi->BRG_BCR_m = v;
 	writel(v, pi->brg_base + BRG_BCR);
 	mpsc_brg_enable(pi);
-
-	return;
 }
 
 /*
@@ -411,13 +401,12 @@ mpsc_set_baudrate(struct mpsc_port_info 
  ******************************************************************************
  */
 
-static void
-mpsc_sdma_burstsize(struct mpsc_port_info *pi, u32 burst_size)
+static void mpsc_sdma_burstsize(struct mpsc_port_info *pi, u32 burst_size)
 {
 	u32	v;
 
 	pr_debug("mpsc_sdma_burstsize[%d]: burst_size: %d\n",
-	    pi->port.line, burst_size);
+			pi->port.line, burst_size);
 
 	burst_size >>= 3; /* Divide by 8 b/c reg values are 8-byte chunks */
 
@@ -432,11 +421,9 @@ mpsc_sdma_burstsize(struct mpsc_port_inf
 
 	writel((readl(pi->sdma_base + SDMA_SDC) & (0x3 << 12)) | (v << 12),
 		pi->sdma_base + SDMA_SDC);
-	return;
 }
 
-static void
-mpsc_sdma_init(struct mpsc_port_info *pi, u32 burst_size)
+static void mpsc_sdma_init(struct mpsc_port_info *pi, u32 burst_size)
 {
 	pr_debug("mpsc_sdma_init[%d]: burst_size: %d\n", pi->port.line,
 		burst_size);
@@ -444,11 +431,9 @@ mpsc_sdma_init(struct mpsc_port_info *pi
 	writel((readl(pi->sdma_base + SDMA_SDC) & 0x3ff) | 0x03f,
 		pi->sdma_base + SDMA_SDC);
 	mpsc_sdma_burstsize(pi, burst_size);
-	return;
 }
 
-static inline u32
-mpsc_sdma_intr_mask(struct mpsc_port_info *pi, u32 mask)
+static u32 mpsc_sdma_intr_mask(struct mpsc_port_info *pi, u32 mask)
 {
 	u32	old, v;
 
@@ -471,15 +456,14 @@ mpsc_sdma_intr_mask(struct mpsc_port_inf
 	return old & 0xf;
 }
 
-static inline void
-mpsc_sdma_intr_unmask(struct mpsc_port_info *pi, u32 mask)
+static void mpsc_sdma_intr_unmask(struct mpsc_port_info *pi, u32 mask)
 {
 	u32	v;
 
 	pr_debug("mpsc_sdma_intr_unmask[%d]: mask: 0x%x\n", pi->port.line,mask);
 
-	v = (pi->mirror_regs) ? pi->shared_regs->SDMA_INTR_MASK_m :
-		readl(pi->shared_regs->sdma_intr_base + SDMA_INTR_MASK);
+	v = (pi->mirror_regs) ? pi->shared_regs->SDMA_INTR_MASK_m
+		: readl(pi->shared_regs->sdma_intr_base + SDMA_INTR_MASK);
 
 	mask &= 0xf;
 	if (pi->port.line)
@@ -489,41 +473,35 @@ mpsc_sdma_intr_unmask(struct mpsc_port_i
 	if (pi->mirror_regs)
 		pi->shared_regs->SDMA_INTR_MASK_m = v;
 	writel(v, pi->shared_regs->sdma_intr_base + SDMA_INTR_MASK);
-	return;
 }
 
-static inline void
-mpsc_sdma_intr_ack(struct mpsc_port_info *pi)
+static void mpsc_sdma_intr_ack(struct mpsc_port_info *pi)
 {
 	pr_debug("mpsc_sdma_intr_ack[%d]: Acknowledging IRQ\n", pi->port.line);
 
 	if (pi->mirror_regs)
 		pi->shared_regs->SDMA_INTR_CAUSE_m = 0;
-	writeb(0x00, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE +
-	       pi->port.line);
-	return;
+	writeb(0x00, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE
+			+ pi->port.line);
 }
 
-static inline void
-mpsc_sdma_set_rx_ring(struct mpsc_port_info *pi, struct mpsc_rx_desc *rxre_p)
+static void mpsc_sdma_set_rx_ring(struct mpsc_port_info *pi,
+		struct mpsc_rx_desc *rxre_p)
 {
 	pr_debug("mpsc_sdma_set_rx_ring[%d]: rxre_p: 0x%x\n",
-		pi->port.line, (u32) rxre_p);
+		pi->port.line, (u32)rxre_p);
 
 	writel((u32)rxre_p, pi->sdma_base + SDMA_SCRDP);
-	return;
 }
 
-static inline void
-mpsc_sdma_set_tx_ring(struct mpsc_port_info *pi, struct mpsc_tx_desc *txre_p)
+static void mpsc_sdma_set_tx_ring(struct mpsc_port_info *pi,
+		struct mpsc_tx_desc *txre_p)
 {
 	writel((u32)txre_p, pi->sdma_base + SDMA_SFTDP);
 	writel((u32)txre_p, pi->sdma_base + SDMA_SCTDP);
-	return;
 }
 
-static inline void
-mpsc_sdma_cmd(struct mpsc_port_info *pi, u32 val)
+static void mpsc_sdma_cmd(struct mpsc_port_info *pi, u32 val)
 {
 	u32	v;
 
@@ -535,46 +513,40 @@ mpsc_sdma_cmd(struct mpsc_port_info *pi,
 	wmb();
 	writel(v, pi->sdma_base + SDMA_SDCM);
 	wmb();
-	return;
 }
 
-static inline uint
-mpsc_sdma_tx_active(struct mpsc_port_info *pi)
+static uint mpsc_sdma_tx_active(struct mpsc_port_info *pi)
 {
 	return readl(pi->sdma_base + SDMA_SDCM) & SDMA_SDCM_TXD;
 }
 
-static inline void
-mpsc_sdma_start_tx(struct mpsc_port_info *pi)
+static void mpsc_sdma_start_tx(struct mpsc_port_info *pi)
 {
 	struct mpsc_tx_desc *txre, *txre_p;
 
 	/* If tx isn't running & there's a desc ready to go, start it */
 	if (!mpsc_sdma_tx_active(pi)) {
-		txre = (struct mpsc_tx_desc *)(pi->txr +
-			(pi->txr_tail * MPSC_TXRE_SIZE));
-		dma_cache_sync(pi->port.dev, (void *) txre, MPSC_TXRE_SIZE, DMA_FROM_DEVICE);
+		txre = (struct mpsc_tx_desc *)(pi->txr
+				+ (pi->txr_tail * MPSC_TXRE_SIZE));
+		dma_cache_sync(pi->port.dev, (void *)txre, MPSC_TXRE_SIZE,
+				DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			invalidate_dcache_range((ulong)txre,
-				(ulong)txre + MPSC_TXRE_SIZE);
+					(ulong)txre + MPSC_TXRE_SIZE);
 #endif
 
 		if (be32_to_cpu(txre->cmdstat) & SDMA_DESC_CMDSTAT_O) {
-			txre_p = (struct mpsc_tx_desc *)(pi->txr_p +
-							 (pi->txr_tail *
-							  MPSC_TXRE_SIZE));
+			txre_p = (struct mpsc_tx_desc *)
+				(pi->txr_p + (pi->txr_tail * MPSC_TXRE_SIZE));
 
 			mpsc_sdma_set_tx_ring(pi, txre_p);
 			mpsc_sdma_cmd(pi, SDMA_SDCM_STD | SDMA_SDCM_TXD);
 		}
 	}
-
-	return;
 }
 
-static inline void
-mpsc_sdma_stop(struct mpsc_port_info *pi)
+static void mpsc_sdma_stop(struct mpsc_port_info *pi)
 {
 	pr_debug("mpsc_sdma_stop[%d]: Stopping SDMA\n", pi->port.line);
 
@@ -589,8 +561,6 @@ mpsc_sdma_stop(struct mpsc_port_info *pi
 	/* Disable interrupts */
 	mpsc_sdma_intr_mask(pi, 0xf);
 	mpsc_sdma_intr_ack(pi);
-
-	return;
 }
 
 /*
@@ -601,8 +571,7 @@ mpsc_sdma_stop(struct mpsc_port_info *pi
  ******************************************************************************
  */
 
-static void
-mpsc_hw_init(struct mpsc_port_info *pi)
+static void mpsc_hw_init(struct mpsc_port_info *pi)
 {
 	u32	v;
 
@@ -624,8 +593,7 @@ mpsc_hw_init(struct mpsc_port_info *pi)
 		v = (v & ~0xf0f) | 0x100;
 		pi->shared_regs->MPSC_TCRR_m = v;
 		writel(v, pi->shared_regs->mpsc_routing_base + MPSC_TCRR);
-	}
-	else {
+	} else {
 		v = readl(pi->shared_regs->mpsc_routing_base + MPSC_MRR);
 		v &= ~0x1c7;
 		writel(v, pi->shared_regs->mpsc_routing_base + MPSC_MRR);
@@ -642,7 +610,7 @@ mpsc_hw_init(struct mpsc_port_info *pi)
 	/* Put MPSC in UART mode & enabel Tx/Rx egines */
 	writel(0x000004c4, pi->mpsc_base + MPSC_MMCRL);
 
-	/* No preamble, 16x divider, low-latency,  */
+	/* No preamble, 16x divider, low-latency, */
 	writel(0x04400400, pi->mpsc_base + MPSC_MMCRH);
 
 	if (pi->mirror_regs) {
@@ -659,12 +627,9 @@ mpsc_hw_init(struct mpsc_port_info *pi)
 	writel(0, pi->mpsc_base + MPSC_CHR_8);
 	writel(0, pi->mpsc_base + MPSC_CHR_9);
 	writel(0, pi->mpsc_base + MPSC_CHR_10);
-
-	return;
 }
 
-static inline void
-mpsc_enter_hunt(struct mpsc_port_info *pi)
+static void mpsc_enter_hunt(struct mpsc_port_info *pi)
 {
 	pr_debug("mpsc_enter_hunt[%d]: Hunting...\n", pi->port.line);
 
@@ -673,20 +638,16 @@ mpsc_enter_hunt(struct mpsc_port_info *p
 			pi->mpsc_base + MPSC_CHR_2);
 		/* Erratum prevents reading CHR_2 so just delay for a while */
 		udelay(100);
-	}
-	else {
+	} else {
 		writel(readl(pi->mpsc_base + MPSC_CHR_2) | MPSC_CHR_2_EH,
-			pi->mpsc_base + MPSC_CHR_2);
+				pi->mpsc_base + MPSC_CHR_2);
 
 		while (readl(pi->mpsc_base + MPSC_CHR_2) & MPSC_CHR_2_EH)
 			udelay(10);
 	}
-
-	return;
 }
 
-static inline void
-mpsc_freeze(struct mpsc_port_info *pi)
+static void mpsc_freeze(struct mpsc_port_info *pi)
 {
 	u32	v;
 
@@ -699,11 +660,9 @@ mpsc_freeze(struct mpsc_port_info *pi)
 	if (pi->mirror_regs)
 		pi->MPSC_MPCR_m = v;
 	writel(v, pi->mpsc_base + MPSC_MPCR);
-	return;
 }
 
-static inline void
-mpsc_unfreeze(struct mpsc_port_info *pi)
+static void mpsc_unfreeze(struct mpsc_port_info *pi)
 {
 	u32	v;
 
@@ -716,11 +675,9 @@ mpsc_unfreeze(struct mpsc_port_info *pi)
 	writel(v, pi->mpsc_base + MPSC_MPCR);
 
 	pr_debug("mpsc_unfreeze[%d]: Unfrozen\n", pi->port.line);
-	return;
 }
 
-static inline void
-mpsc_set_char_length(struct mpsc_port_info *pi, u32 len)
+static void mpsc_set_char_length(struct mpsc_port_info *pi, u32 len)
 {
 	u32	v;
 
@@ -733,11 +690,9 @@ mpsc_set_char_length(struct mpsc_port_in
 	if (pi->mirror_regs)
 		pi->MPSC_MPCR_m = v;
 	writel(v, pi->mpsc_base + MPSC_MPCR);
-	return;
 }
 
-static inline void
-mpsc_set_stop_bit_length(struct mpsc_port_info *pi, u32 len)
+static void mpsc_set_stop_bit_length(struct mpsc_port_info *pi, u32 len)
 {
 	u32	v;
 
@@ -752,11 +707,9 @@ mpsc_set_stop_bit_length(struct mpsc_por
 	if (pi->mirror_regs)
 		pi->MPSC_MPCR_m = v;
 	writel(v, pi->mpsc_base + MPSC_MPCR);
-	return;
 }
 
-static inline void
-mpsc_set_parity(struct mpsc_port_info *pi, u32 p)
+static void mpsc_set_parity(struct mpsc_port_info *pi, u32 p)
 {
 	u32	v;
 
@@ -771,7 +724,6 @@ mpsc_set_parity(struct mpsc_port_info *p
 	if (pi->mirror_regs)
 		pi->MPSC_CHR_2_m = v;
 	writel(v, pi->mpsc_base + MPSC_CHR_2);
-	return;
 }
 
 /*
@@ -782,8 +734,7 @@ mpsc_set_parity(struct mpsc_port_info *p
  ******************************************************************************
  */
 
-static void
-mpsc_init_hw(struct mpsc_port_info *pi)
+static void mpsc_init_hw(struct mpsc_port_info *pi)
 {
 	pr_debug("mpsc_init_hw[%d]: Initializing\n", pi->port.line);
 
@@ -792,12 +743,9 @@ mpsc_init_hw(struct mpsc_port_info *pi)
 	mpsc_sdma_init(pi, dma_get_cache_alignment());	/* burst a cacheline */
 	mpsc_sdma_stop(pi);
 	mpsc_hw_init(pi);
-
-	return;
 }
 
-static int
-mpsc_alloc_ring_mem(struct mpsc_port_info *pi)
+static int mpsc_alloc_ring_mem(struct mpsc_port_info *pi)
 {
 	int rc = 0;
 
@@ -808,11 +756,10 @@ mpsc_alloc_ring_mem(struct mpsc_port_inf
 		if (!dma_supported(pi->port.dev, 0xffffffff)) {
 			printk(KERN_ERR "MPSC: Inadequate DMA support\n");
 			rc = -ENXIO;
-		}
-		else if ((pi->dma_region = dma_alloc_noncoherent(pi->port.dev,
-			MPSC_DMA_ALLOC_SIZE, &pi->dma_region_p, GFP_KERNEL))
-			== NULL) {
-
+		} else if ((pi->dma_region = dma_alloc_noncoherent(pi->port.dev,
+						MPSC_DMA_ALLOC_SIZE,
+						&pi->dma_region_p, GFP_KERNEL))
+				== NULL) {
 			printk(KERN_ERR "MPSC: Can't alloc Desc region\n");
 			rc = -ENOMEM;
 		}
@@ -821,23 +768,19 @@ mpsc_alloc_ring_mem(struct mpsc_port_inf
 	return rc;
 }
 
-static void
-mpsc_free_ring_mem(struct mpsc_port_info *pi)
+static void mpsc_free_ring_mem(struct mpsc_port_info *pi)
 {
 	pr_debug("mpsc_free_ring_mem[%d]: Freeing ring mem\n", pi->port.line);
 
 	if (pi->dma_region) {
 		dma_free_noncoherent(pi->port.dev, MPSC_DMA_ALLOC_SIZE,
-			  pi->dma_region, pi->dma_region_p);
+				pi->dma_region, pi->dma_region_p);
 		pi->dma_region = NULL;
-		pi->dma_region_p = (dma_addr_t) NULL;
+		pi->dma_region_p = (dma_addr_t)NULL;
 	}
-
-	return;
 }
 
-static void
-mpsc_init_rings(struct mpsc_port_info *pi)
+static void mpsc_init_rings(struct mpsc_port_info *pi)
 {
 	struct mpsc_rx_desc *rxre;
 	struct mpsc_tx_desc *txre;
@@ -855,8 +798,8 @@ mpsc_init_rings(struct mpsc_port_info *p
 	 * Descriptors & buffers are multiples of cacheline size and must be
 	 * cacheline aligned.
 	 */
-	dp = ALIGN((u32) pi->dma_region, dma_get_cache_alignment());
-	dp_p = ALIGN((u32) pi->dma_region_p, dma_get_cache_alignment());
+	dp = ALIGN((u32)pi->dma_region, dma_get_cache_alignment());
+	dp_p = ALIGN((u32)pi->dma_region_p, dma_get_cache_alignment());
 
 	/*
 	 * Partition dma region into rx ring descriptor, rx buffers,
@@ -867,8 +810,8 @@ mpsc_init_rings(struct mpsc_port_info *p
 	dp += MPSC_RXR_SIZE;
 	dp_p += MPSC_RXR_SIZE;
 
-	pi->rxb = (u8 *) dp;
-	pi->rxb_p = (u8 *) dp_p;
+	pi->rxb = (u8 *)dp;
+	pi->rxb_p = (u8 *)dp_p;
 	dp += MPSC_RXB_SIZE;
 	dp_p += MPSC_RXB_SIZE;
 
@@ -879,8 +822,8 @@ mpsc_init_rings(struct mpsc_port_info *p
 	dp += MPSC_TXR_SIZE;
 	dp_p += MPSC_TXR_SIZE;
 
-	pi->txb = (u8 *) dp;
-	pi->txb_p = (u8 *) dp_p;
+	pi->txb = (u8 *)dp;
+	pi->txb_p = (u8 *)dp_p;
 
 	pi->txr_head = 0;
 	pi->txr_tail = 0;
@@ -896,10 +839,9 @@ mpsc_init_rings(struct mpsc_port_info *p
 
 		rxre->bufsize = cpu_to_be16(MPSC_RXBE_SIZE);
 		rxre->bytecnt = cpu_to_be16(0);
-		rxre->cmdstat = cpu_to_be32(SDMA_DESC_CMDSTAT_O |
-					    SDMA_DESC_CMDSTAT_EI |
-					    SDMA_DESC_CMDSTAT_F |
-					    SDMA_DESC_CMDSTAT_L);
+		rxre->cmdstat = cpu_to_be32(SDMA_DESC_CMDSTAT_O
+				| SDMA_DESC_CMDSTAT_EI | SDMA_DESC_CMDSTAT_F
+				| SDMA_DESC_CMDSTAT_L);
 		rxre->link = cpu_to_be32(dp_p + MPSC_RXRE_SIZE);
 		rxre->buf_ptr = cpu_to_be32(bp_p);
 
@@ -929,19 +871,19 @@ mpsc_init_rings(struct mpsc_port_info *p
 	}
 	txre->link = cpu_to_be32(pi->txr_p);	/* Wrap last back to first */
 
-	dma_cache_sync(pi->port.dev, (void *) pi->dma_region, MPSC_DMA_ALLOC_SIZE,
-		DMA_BIDIRECTIONAL);
+	dma_cache_sync(pi->port.dev, (void *)pi->dma_region,
+			MPSC_DMA_ALLOC_SIZE, DMA_BIDIRECTIONAL);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			flush_dcache_range((ulong)pi->dma_region,
-				(ulong)pi->dma_region + MPSC_DMA_ALLOC_SIZE);
+					(ulong)pi->dma_region
+					+ MPSC_DMA_ALLOC_SIZE);
 #endif
 
 	return;
 }
 
-static void
-mpsc_uninit_rings(struct mpsc_port_info *pi)
+static void mpsc_uninit_rings(struct mpsc_port_info *pi)
 {
 	pr_debug("mpsc_uninit_rings[%d]: Uninitializing rings\n",pi->port.line);
 
@@ -959,12 +901,9 @@ mpsc_uninit_rings(struct mpsc_port_info 
 	pi->txb_p = NULL;
 	pi->txr_head = 0;
 	pi->txr_tail = 0;
-
-	return;
 }
 
-static int
-mpsc_make_ready(struct mpsc_port_info *pi)
+static int mpsc_make_ready(struct mpsc_port_info *pi)
 {
 	int rc;
 
@@ -989,8 +928,7 @@ mpsc_make_ready(struct mpsc_port_info *p
  ******************************************************************************
  */
 
-static inline int
-mpsc_rx_intr(struct mpsc_port_info *pi)
+static int mpsc_rx_intr(struct mpsc_port_info *pi)
 {
 	struct mpsc_rx_desc *rxre;
 	struct tty_struct *tty = pi->port.info->tty;
@@ -1003,21 +941,24 @@ mpsc_rx_intr(struct mpsc_port_info *pi)
 
 	rxre = (struct mpsc_rx_desc *)(pi->rxr + (pi->rxr_posn*MPSC_RXRE_SIZE));
 
-	dma_cache_sync(pi->port.dev, (void *)rxre, MPSC_RXRE_SIZE, DMA_FROM_DEVICE);
+	dma_cache_sync(pi->port.dev, (void *)rxre, MPSC_RXRE_SIZE,
+			DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 	if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 		invalidate_dcache_range((ulong)rxre,
-			(ulong)rxre + MPSC_RXRE_SIZE);
+				(ulong)rxre + MPSC_RXRE_SIZE);
 #endif
 
 	/*
 	 * Loop through Rx descriptors handling ones that have been completed.
 	 */
-	while (!((cmdstat = be32_to_cpu(rxre->cmdstat)) & SDMA_DESC_CMDSTAT_O)){
+	while (!((cmdstat = be32_to_cpu(rxre->cmdstat))
+				& SDMA_DESC_CMDSTAT_O)) {
 		bytes_in = be16_to_cpu(rxre->bytecnt);
 
 		/* Following use of tty struct directly is deprecated */
-		if (unlikely(tty_buffer_request_room(tty, bytes_in) < bytes_in)) {
+		if (unlikely(tty_buffer_request_room(tty, bytes_in)
+					< bytes_in)) {
 			if (tty->low_latency)
 				tty_flip_buffer_push(tty);
 			/*
@@ -1027,11 +968,12 @@ mpsc_rx_intr(struct mpsc_port_info *pi)
 		}
 
 		bp = pi->rxb + (pi->rxr_posn * MPSC_RXBE_SIZE);
-		dma_cache_sync(pi->port.dev, (void *) bp, MPSC_RXBE_SIZE, DMA_FROM_DEVICE);
+		dma_cache_sync(pi->port.dev, (void *)bp, MPSC_RXBE_SIZE,
+				DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			invalidate_dcache_range((ulong)bp,
-				(ulong)bp + MPSC_RXBE_SIZE);
+					(ulong)bp + MPSC_RXBE_SIZE);
 #endif
 
 		/*
@@ -1042,8 +984,9 @@ mpsc_rx_intr(struct mpsc_port_info *pi)
 		 * we'll assume there is no data in the buffer.
 		 * If there is...it gets lost.
 		 */
-		if (unlikely(cmdstat & (SDMA_DESC_CMDSTAT_BR |
-			SDMA_DESC_CMDSTAT_FR | SDMA_DESC_CMDSTAT_OR))) {
+		if (unlikely(cmdstat & (SDMA_DESC_CMDSTAT_BR
+						| SDMA_DESC_CMDSTAT_FR
+						| SDMA_DESC_CMDSTAT_OR))) {
 
 			pi->port.icount.rx++;
 
@@ -1052,11 +995,11 @@ mpsc_rx_intr(struct mpsc_port_info *pi)
 
 				if (uart_handle_break(&pi->port))
 					goto next_frame;
-			}
-			else if (cmdstat & SDMA_DESC_CMDSTAT_FR)/* Framing */
+			} else if (cmdstat & SDMA_DESC_CMDSTAT_FR) {
 				pi->port.icount.frame++;
-			else if (cmdstat & SDMA_DESC_CMDSTAT_OR) /* Overrun */
+			} else if (cmdstat & SDMA_DESC_CMDSTAT_OR) {
 				pi->port.icount.overrun++;
+			}
 
 			cmdstat &= pi->port.read_status_mask;
 
@@ -1076,12 +1019,12 @@ mpsc_rx_intr(struct mpsc_port_info *pi)
 			goto next_frame;
 		}
 
-		if ((unlikely(cmdstat & (SDMA_DESC_CMDSTAT_BR |
-			SDMA_DESC_CMDSTAT_FR | SDMA_DESC_CMDSTAT_OR))) &&
-			!(cmdstat & pi->port.ignore_status_mask))
-
+		if ((unlikely(cmdstat & (SDMA_DESC_CMDSTAT_BR
+						| SDMA_DESC_CMDSTAT_FR
+						| SDMA_DESC_CMDSTAT_OR)))
+				&& !(cmdstat & pi->port.ignore_status_mask)) {
 			tty_insert_flip_char(tty, *bp, flag);
-		else {
+		} else {
 			for (i=0; i<bytes_in; i++)
 				tty_insert_flip_char(tty, *bp++, TTY_NORMAL);
 
@@ -1091,29 +1034,29 @@ mpsc_rx_intr(struct mpsc_port_info *pi)
 next_frame:
 		rxre->bytecnt = cpu_to_be16(0);
 		wmb();
-		rxre->cmdstat = cpu_to_be32(SDMA_DESC_CMDSTAT_O |
-					    SDMA_DESC_CMDSTAT_EI |
-					    SDMA_DESC_CMDSTAT_F |
-					    SDMA_DESC_CMDSTAT_L);
+		rxre->cmdstat = cpu_to_be32(SDMA_DESC_CMDSTAT_O
+				| SDMA_DESC_CMDSTAT_EI | SDMA_DESC_CMDSTAT_F
+				| SDMA_DESC_CMDSTAT_L);
 		wmb();
-		dma_cache_sync(pi->port.dev, (void *)rxre, MPSC_RXRE_SIZE, DMA_BIDIRECTIONAL);
+		dma_cache_sync(pi->port.dev, (void *)rxre, MPSC_RXRE_SIZE,
+				DMA_BIDIRECTIONAL);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			flush_dcache_range((ulong)rxre,
-				(ulong)rxre + MPSC_RXRE_SIZE);
+					(ulong)rxre + MPSC_RXRE_SIZE);
 #endif
 
 		/* Advance to next descriptor */
 		pi->rxr_posn = (pi->rxr_posn + 1) & (MPSC_RXR_ENTRIES - 1);
-		rxre = (struct mpsc_rx_desc *)(pi->rxr +
-			(pi->rxr_posn * MPSC_RXRE_SIZE));
-		dma_cache_sync(pi->port.dev, (void *)rxre, MPSC_RXRE_SIZE, DMA_FROM_DEVICE);
+		rxre = (struct mpsc_rx_desc *)
+			(pi->rxr + (pi->rxr_posn * MPSC_RXRE_SIZE));
+		dma_cache_sync(pi->port.dev, (void *)rxre, MPSC_RXRE_SIZE,
+				DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			invalidate_dcache_range((ulong)rxre,
-				(ulong)rxre + MPSC_RXRE_SIZE);
+					(ulong)rxre + MPSC_RXRE_SIZE);
 #endif
-
 		rc = 1;
 	}
 
@@ -1125,42 +1068,38 @@ next_frame:
 	return rc;
 }
 
-static inline void
-mpsc_setup_tx_desc(struct mpsc_port_info *pi, u32 count, u32 intr)
+static void mpsc_setup_tx_desc(struct mpsc_port_info *pi, u32 count, u32 intr)
 {
 	struct mpsc_tx_desc *txre;
 
-	txre = (struct mpsc_tx_desc *)(pi->txr +
-		(pi->txr_head * MPSC_TXRE_SIZE));
+	txre = (struct mpsc_tx_desc *)(pi->txr
+			+ (pi->txr_head * MPSC_TXRE_SIZE));
 
 	txre->bytecnt = cpu_to_be16(count);
 	txre->shadow = txre->bytecnt;
 	wmb();			/* ensure cmdstat is last field updated */
-	txre->cmdstat = cpu_to_be32(SDMA_DESC_CMDSTAT_O | SDMA_DESC_CMDSTAT_F |
-				    SDMA_DESC_CMDSTAT_L | ((intr) ?
-							   SDMA_DESC_CMDSTAT_EI
-							   : 0));
+	txre->cmdstat = cpu_to_be32(SDMA_DESC_CMDSTAT_O | SDMA_DESC_CMDSTAT_F
+			| SDMA_DESC_CMDSTAT_L
+			| ((intr) ? SDMA_DESC_CMDSTAT_EI : 0));
 	wmb();
-	dma_cache_sync(pi->port.dev, (void *) txre, MPSC_TXRE_SIZE, DMA_BIDIRECTIONAL);
+	dma_cache_sync(pi->port.dev, (void *)txre, MPSC_TXRE_SIZE,
+			DMA_BIDIRECTIONAL);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 	if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 		flush_dcache_range((ulong)txre,
-			(ulong)txre + MPSC_TXRE_SIZE);
+				(ulong)txre + MPSC_TXRE_SIZE);
 #endif
-
-	return;
 }
 
-static inline void
-mpsc_copy_tx_data(struct mpsc_port_info *pi)
+static void mpsc_copy_tx_data(struct mpsc_port_info *pi)
 {
 	struct circ_buf *xmit = &pi->port.info->xmit;
 	u8 *bp;
 	u32 i;
 
 	/* Make sure the desc ring isn't full */
-	while (CIRC_CNT(pi->txr_head, pi->txr_tail, MPSC_TXR_ENTRIES) <
-	       (MPSC_TXR_ENTRIES - 1)) {
+	while (CIRC_CNT(pi->txr_head, pi->txr_tail, MPSC_TXR_ENTRIES)
+			< (MPSC_TXR_ENTRIES - 1)) {
 		if (pi->port.x_char) {
 			/*
 			 * Ideally, we should use the TCS field in
@@ -1174,11 +1113,11 @@ mpsc_copy_tx_data(struct mpsc_port_info 
 			*bp = pi->port.x_char;
 			pi->port.x_char = 0;
 			i = 1;
-		}
-		else if (!uart_circ_empty(xmit) && !uart_tx_stopped(&pi->port)){
-			i = min((u32) MPSC_TXBE_SIZE,
-				(u32) uart_circ_chars_pending(xmit));
-			i = min(i, (u32) CIRC_CNT_TO_END(xmit->head, xmit->tail,
+		} else if (!uart_circ_empty(xmit)
+				&& !uart_tx_stopped(&pi->port)) {
+			i = min((u32)MPSC_TXBE_SIZE,
+				(u32)uart_circ_chars_pending(xmit));
+			i = min(i, (u32)CIRC_CNT_TO_END(xmit->head, xmit->tail,
 				UART_XMIT_SIZE));
 			bp = pi->txb + (pi->txr_head * MPSC_TXBE_SIZE);
 			memcpy(bp, &xmit->buf[xmit->tail], i);
@@ -1186,27 +1125,25 @@ mpsc_copy_tx_data(struct mpsc_port_info 
 
 			if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 				uart_write_wakeup(&pi->port);
-		}
-		else /* All tx data copied into ring bufs */
+		} else { /* All tx data copied into ring bufs */
 			return;
+		}
 
-		dma_cache_sync(pi->port.dev, (void *) bp, MPSC_TXBE_SIZE, DMA_BIDIRECTIONAL);
+		dma_cache_sync(pi->port.dev, (void *)bp, MPSC_TXBE_SIZE,
+				DMA_BIDIRECTIONAL);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			flush_dcache_range((ulong)bp,
-				(ulong)bp + MPSC_TXBE_SIZE);
+					(ulong)bp + MPSC_TXBE_SIZE);
 #endif
 		mpsc_setup_tx_desc(pi, i, 1);
 
 		/* Advance to next descriptor */
 		pi->txr_head = (pi->txr_head + 1) & (MPSC_TXR_ENTRIES - 1);
 	}
-
-	return;
 }
 
-static inline int
-mpsc_tx_intr(struct mpsc_port_info *pi)
+static int mpsc_tx_intr(struct mpsc_port_info *pi)
 {
 	struct mpsc_tx_desc *txre;
 	int rc = 0;
@@ -1215,14 +1152,15 @@ mpsc_tx_intr(struct mpsc_port_info *pi)
 	spin_lock_irqsave(&pi->tx_lock, iflags);
 
 	if (!mpsc_sdma_tx_active(pi)) {
-		txre = (struct mpsc_tx_desc *)(pi->txr +
-			(pi->txr_tail * MPSC_TXRE_SIZE));
+		txre = (struct mpsc_tx_desc *)(pi->txr
+				+ (pi->txr_tail * MPSC_TXRE_SIZE));
 
-		dma_cache_sync(pi->port.dev, (void *) txre, MPSC_TXRE_SIZE, DMA_FROM_DEVICE);
+		dma_cache_sync(pi->port.dev, (void *)txre, MPSC_TXRE_SIZE,
+				DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			invalidate_dcache_range((ulong)txre,
-				(ulong)txre + MPSC_TXRE_SIZE);
+					(ulong)txre + MPSC_TXRE_SIZE);
 #endif
 
 		while (!(be32_to_cpu(txre->cmdstat) & SDMA_DESC_CMDSTAT_O)) {
@@ -1234,14 +1172,14 @@ mpsc_tx_intr(struct mpsc_port_info *pi)
 			if (pi->txr_head == pi->txr_tail)
 				break;
 
-			txre = (struct mpsc_tx_desc *)(pi->txr +
-				(pi->txr_tail * MPSC_TXRE_SIZE));
-			dma_cache_sync(pi->port.dev, (void *) txre, MPSC_TXRE_SIZE,
-				DMA_FROM_DEVICE);
+			txre = (struct mpsc_tx_desc *)(pi->txr
+					+ (pi->txr_tail * MPSC_TXRE_SIZE));
+			dma_cache_sync(pi->port.dev, (void *)txre,
+					MPSC_TXRE_SIZE, DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 			if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 				invalidate_dcache_range((ulong)txre,
-					(ulong)txre + MPSC_TXRE_SIZE);
+						(ulong)txre + MPSC_TXRE_SIZE);
 #endif
 		}
 
@@ -1258,8 +1196,7 @@ mpsc_tx_intr(struct mpsc_port_info *pi)
  * the interrupt, then handle any completed Rx/Tx descriptors.  When done
  * handling those descriptors, we restart the Rx/Tx engines if they're stopped.
  */
-static irqreturn_t
-mpsc_sdma_intr(int irq, void *dev_id)
+static irqreturn_t mpsc_sdma_intr(int irq, void *dev_id)
 {
 	struct mpsc_port_info *pi = dev_id;
 	ulong iflags;
@@ -1286,8 +1223,7 @@ mpsc_sdma_intr(int irq, void *dev_id)
  *
  ******************************************************************************
  */
-static uint
-mpsc_tx_empty(struct uart_port *port)
+static uint mpsc_tx_empty(struct uart_port *port)
 {
 	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
 	ulong iflags;
@@ -1300,21 +1236,18 @@ mpsc_tx_empty(struct uart_port *port)
 	return rc;
 }
 
-static void
-mpsc_set_mctrl(struct uart_port *port, uint mctrl)
+static void mpsc_set_mctrl(struct uart_port *port, uint mctrl)
 {
 	/* Have no way to set modem control lines AFAICT */
-	return;
 }
 
-static uint
-mpsc_get_mctrl(struct uart_port *port)
+static uint mpsc_get_mctrl(struct uart_port *port)
 {
 	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
 	u32 mflags, status;
 
-	status = (pi->mirror_regs) ? pi->MPSC_CHR_10_m :
-		readl(pi->mpsc_base + MPSC_CHR_10);
+	status = (pi->mirror_regs) ? pi->MPSC_CHR_10_m
+		: readl(pi->mpsc_base + MPSC_CHR_10);
 
 	mflags = 0;
 	if (status & 0x1)
@@ -1325,19 +1258,16 @@ mpsc_get_mctrl(struct uart_port *port)
 	return mflags | TIOCM_DSR;	/* No way to tell if DSR asserted */
 }
 
-static void
-mpsc_stop_tx(struct uart_port *port)
+static void mpsc_stop_tx(struct uart_port *port)
 {
 	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
 
 	pr_debug("mpsc_stop_tx[%d]\n", port->line);
 
 	mpsc_freeze(pi);
-	return;
 }
 
-static void
-mpsc_start_tx(struct uart_port *port)
+static void mpsc_start_tx(struct uart_port *port)
 {
 	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
 	unsigned long iflags;
@@ -1351,11 +1281,9 @@ mpsc_start_tx(struct uart_port *port)
 	spin_unlock_irqrestore(&pi->tx_lock, iflags);
 
 	pr_debug("mpsc_start_tx[%d]\n", port->line);
-	return;
 }
 
-static void
-mpsc_start_rx(struct mpsc_port_info *pi)
+static void mpsc_start_rx(struct mpsc_port_info *pi)
 {
 	pr_debug("mpsc_start_rx[%d]: Starting...\n", pi->port.line);
 
@@ -1363,11 +1291,9 @@ mpsc_start_rx(struct mpsc_port_info *pi)
 		mpsc_enter_hunt(pi);
 		mpsc_sdma_cmd(pi, SDMA_SDCM_ERD);
 	}
-	return;
 }
 
-static void
-mpsc_stop_rx(struct uart_port *port)
+static void mpsc_stop_rx(struct uart_port *port)
 {
 	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
 
@@ -1378,27 +1304,22 @@ mpsc_stop_rx(struct uart_port *port)
 				pi->mpsc_base + MPSC_CHR_2);
 		/* Erratum prevents reading CHR_2 so just delay for a while */
 		udelay(100);
-	}
-	else {
+	} else {
 		writel(readl(pi->mpsc_base + MPSC_CHR_2) | MPSC_CHR_2_RA,
-			pi->mpsc_base + MPSC_CHR_2);
+				pi->mpsc_base + MPSC_CHR_2);
 
 		while (readl(pi->mpsc_base + MPSC_CHR_2) & MPSC_CHR_2_RA)
 			udelay(10);
 	}
 
 	mpsc_sdma_cmd(pi, SDMA_SDCM_AR);
-	return;
 }
 
-static void
-mpsc_enable_ms(struct uart_port *port)
+static void mpsc_enable_ms(struct uart_port *port)
 {
-	return;			/* Not supported */
 }
 
-static void
-mpsc_break_ctl(struct uart_port *port, int ctl)
+static void mpsc_break_ctl(struct uart_port *port, int ctl)
 {
 	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
 	ulong	flags;
@@ -1411,12 +1332,9 @@ mpsc_break_ctl(struct uart_port *port, i
 		pi->MPSC_CHR_1_m = v;
 	writel(v, pi->mpsc_base + MPSC_CHR_1);
 	spin_unlock_irqrestore(&pi->port.lock, flags);
-
-	return;
 }
 
-static int
-mpsc_startup(struct uart_port *port)
+static int mpsc_startup(struct uart_port *port)
 {
 	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
 	u32 flag = 0;
@@ -1434,20 +1352,19 @@ mpsc_startup(struct uart_port *port)
 			flag = IRQF_SHARED;
 
 		if (request_irq(pi->port.irq, mpsc_sdma_intr, flag,
-				"mpsc-sdma", pi))
+					"mpsc-sdma", pi))
 			printk(KERN_ERR "MPSC: Can't get SDMA IRQ %d\n",
-			       pi->port.irq);
+					pi->port.irq);
 
 		mpsc_sdma_intr_unmask(pi, 0xf);
-		mpsc_sdma_set_rx_ring(pi, (struct mpsc_rx_desc *)(pi->rxr_p +
-			(pi->rxr_posn * MPSC_RXRE_SIZE)));
+		mpsc_sdma_set_rx_ring(pi, (struct mpsc_rx_desc *)(pi->rxr_p
+					+ (pi->rxr_posn * MPSC_RXRE_SIZE)));
 	}
 
 	return rc;
 }
 
-static void
-mpsc_shutdown(struct uart_port *port)
+static void mpsc_shutdown(struct uart_port *port)
 {
 	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
 
@@ -1455,11 +1372,9 @@ mpsc_shutdown(struct uart_port *port)
 
 	mpsc_sdma_stop(pi);
 	free_irq(pi->port.irq, pi);
-	return;
 }
 
-static void
-mpsc_set_termios(struct uart_port *port, struct ktermios *termios,
+static void mpsc_set_termios(struct uart_port *port, struct ktermios *termios,
 		 struct ktermios *old)
 {
 	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
@@ -1519,8 +1434,8 @@ mpsc_set_termios(struct uart_port *port,
 	pi->port.read_status_mask = SDMA_DESC_CMDSTAT_OR;
 
 	if (termios->c_iflag & INPCK)
-		pi->port.read_status_mask |= SDMA_DESC_CMDSTAT_PE |
-		    SDMA_DESC_CMDSTAT_FR;
+		pi->port.read_status_mask |= SDMA_DESC_CMDSTAT_PE
+			| SDMA_DESC_CMDSTAT_FR;
 
 	if (termios->c_iflag & (BRKINT | PARMRK))
 		pi->port.read_status_mask |= SDMA_DESC_CMDSTAT_BR;
@@ -1529,8 +1444,8 @@ mpsc_set_termios(struct uart_port *port,
 	pi->port.ignore_status_mask = 0;
 
 	if (termios->c_iflag & IGNPAR)
-		pi->port.ignore_status_mask |= SDMA_DESC_CMDSTAT_PE |
-		    SDMA_DESC_CMDSTAT_FR;
+		pi->port.ignore_status_mask |= SDMA_DESC_CMDSTAT_PE
+			| SDMA_DESC_CMDSTAT_FR;
 
 	if (termios->c_iflag & IGNBRK) {
 		pi->port.ignore_status_mask |= SDMA_DESC_CMDSTAT_BR;
@@ -1550,25 +1465,21 @@ mpsc_set_termios(struct uart_port *port,
 	}
 
 	spin_unlock_irqrestore(&pi->port.lock, flags);
-	return;
 }
 
-static const char *
-mpsc_type(struct uart_port *port)
+static const char *mpsc_type(struct uart_port *port)
 {
 	pr_debug("mpsc_type[%d]: port type: %s\n", port->line,MPSC_DRIVER_NAME);
 	return MPSC_DRIVER_NAME;
 }
 
-static int
-mpsc_request_port(struct uart_port *port)
+static int mpsc_request_port(struct uart_port *port)
 {
 	/* Should make chip/platform specific call */
 	return 0;
 }
 
-static void
-mpsc_release_port(struct uart_port *port)
+static void mpsc_release_port(struct uart_port *port)
 {
 	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
 
@@ -1577,18 +1488,13 @@ mpsc_release_port(struct uart_port *port
 		mpsc_free_ring_mem(pi);
 		pi->ready = 0;
 	}
-
-	return;
 }
 
-static void
-mpsc_config_port(struct uart_port *port, int flags)
+static void mpsc_config_port(struct uart_port *port, int flags)
 {
-	return;
 }
 
-static int
-mpsc_verify_port(struct uart_port *port, struct serial_struct *ser)
+static int mpsc_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
 	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
 	int rc = 0;
@@ -1614,22 +1520,22 @@ mpsc_verify_port(struct uart_port *port,
 }
 
 static struct uart_ops mpsc_pops = {
-	.tx_empty     = mpsc_tx_empty,
-	.set_mctrl    = mpsc_set_mctrl,
-	.get_mctrl    = mpsc_get_mctrl,
-	.stop_tx      = mpsc_stop_tx,
-	.start_tx     = mpsc_start_tx,
-	.stop_rx      = mpsc_stop_rx,
-	.enable_ms    = mpsc_enable_ms,
-	.break_ctl    = mpsc_break_ctl,
-	.startup      = mpsc_startup,
-	.shutdown     = mpsc_shutdown,
-	.set_termios  = mpsc_set_termios,
-	.type         = mpsc_type,
-	.release_port = mpsc_release_port,
-	.request_port = mpsc_request_port,
-	.config_port  = mpsc_config_port,
-	.verify_port  = mpsc_verify_port,
+	.tx_empty	= mpsc_tx_empty,
+	.set_mctrl	= mpsc_set_mctrl,
+	.get_mctrl	= mpsc_get_mctrl,
+	.stop_tx	= mpsc_stop_tx,
+	.start_tx	= mpsc_start_tx,
+	.stop_rx	= mpsc_stop_rx,
+	.enable_ms	= mpsc_enable_ms,
+	.break_ctl	= mpsc_break_ctl,
+	.startup	= mpsc_startup,
+	.shutdown	= mpsc_shutdown,
+	.set_termios	= mpsc_set_termios,
+	.type		= mpsc_type,
+	.release_port	= mpsc_release_port,
+	.request_port	= mpsc_request_port,
+	.config_port	= mpsc_config_port,
+	.verify_port	= mpsc_verify_port,
 };
 
 /*
@@ -1641,8 +1547,7 @@ static struct uart_ops mpsc_pops = {
  */
 
 #ifdef CONFIG_SERIAL_MPSC_CONSOLE
-static void
-mpsc_console_write(struct console *co, const char *s, uint count)
+static void mpsc_console_write(struct console *co, const char *s, uint count)
 {
 	struct mpsc_port_info *pi = &mpsc_ports[co->index];
 	u8 *bp, *dp, add_cr = 0;
@@ -1671,8 +1576,7 @@ mpsc_console_write(struct console *co, c
 			if (add_cr) {
 				*(dp++) = '\r';
 				add_cr = 0;
-			}
-			else {
+			} else {
 				*(dp++) = *s;
 
 				if (*(s++) == '\n') { /* add '\r' after '\n' */
@@ -1684,11 +1588,12 @@ mpsc_console_write(struct console *co, c
 			count--;
 		}
 
-		dma_cache_sync(pi->port.dev, (void *) bp, MPSC_TXBE_SIZE, DMA_BIDIRECTIONAL);
+		dma_cache_sync(pi->port.dev, (void *)bp, MPSC_TXBE_SIZE,
+				DMA_BIDIRECTIONAL);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			flush_dcache_range((ulong)bp,
-				(ulong)bp + MPSC_TXBE_SIZE);
+					(ulong)bp + MPSC_TXBE_SIZE);
 #endif
 		mpsc_setup_tx_desc(pi, i, 0);
 		pi->txr_head = (pi->txr_head + 1) & (MPSC_TXR_ENTRIES - 1);
@@ -1701,11 +1606,9 @@ mpsc_console_write(struct console *co, c
 	}
 
 	spin_unlock_irqrestore(&pi->tx_lock, iflags);
-	return;
 }
 
-static int __init
-mpsc_console_setup(struct console *co, char *options)
+static int __init mpsc_console_setup(struct console *co, char *options)
 {
 	struct mpsc_port_info *pi;
 	int baud, bits, parity, flow;
@@ -1734,17 +1637,16 @@ mpsc_console_setup(struct console *co, c
 }
 
 static struct console mpsc_console = {
-	.name   = MPSC_DEV_NAME,
-	.write  = mpsc_console_write,
-	.device = uart_console_device,
-	.setup  = mpsc_console_setup,
-	.flags  = CON_PRINTBUFFER,
-	.index  = -1,
-	.data   = &mpsc_reg,
+	.name	= MPSC_DEV_NAME,
+	.write	= mpsc_console_write,
+	.device	= uart_console_device,
+	.setup	= mpsc_console_setup,
+	.flags	= CON_PRINTBUFFER,
+	.index	= -1,
+	.data	= &mpsc_reg,
 };
 
-static int __init
-mpsc_late_console_init(void)
+static int __init mpsc_late_console_init(void)
 {
 	pr_debug("mpsc_late_console_init: Enter\n");
 
@@ -1766,43 +1668,40 @@ late_initcall(mpsc_late_console_init);
  *
  ******************************************************************************
  */
-static void
-mpsc_resource_err(char *s)
+static void mpsc_resource_err(char *s)
 {
 	printk(KERN_WARNING "MPSC: Platform device resource error in %s\n", s);
-	return;
 }
 
-static int
-mpsc_shared_map_regs(struct platform_device *pd)
+static int mpsc_shared_map_regs(struct platform_device *pd)
 {
 	struct resource	*r;
 
 	if ((r = platform_get_resource(pd, IORESOURCE_MEM,
-		MPSC_ROUTING_BASE_ORDER)) && request_mem_region(r->start,
-		MPSC_ROUTING_REG_BLOCK_SIZE, "mpsc_routing_regs")) {
-
+					MPSC_ROUTING_BASE_ORDER))
+			&& request_mem_region(r->start,
+				MPSC_ROUTING_REG_BLOCK_SIZE,
+				"mpsc_routing_regs")) {
 		mpsc_shared_regs.mpsc_routing_base = ioremap(r->start,
-			MPSC_ROUTING_REG_BLOCK_SIZE);
+				MPSC_ROUTING_REG_BLOCK_SIZE);
 		mpsc_shared_regs.mpsc_routing_base_p = r->start;
-	}
-	else {
+	} else {
 		mpsc_resource_err("MPSC routing base");
 		return -ENOMEM;
 	}
 
 	if ((r = platform_get_resource(pd, IORESOURCE_MEM,
-		MPSC_SDMA_INTR_BASE_ORDER)) && request_mem_region(r->start,
-		MPSC_SDMA_INTR_REG_BLOCK_SIZE, "sdma_intr_regs")) {
-
+					MPSC_SDMA_INTR_BASE_ORDER))
+			&& request_mem_region(r->start,
+				MPSC_SDMA_INTR_REG_BLOCK_SIZE,
+				"sdma_intr_regs")) {
 		mpsc_shared_regs.sdma_intr_base = ioremap(r->start,
 			MPSC_SDMA_INTR_REG_BLOCK_SIZE);
 		mpsc_shared_regs.sdma_intr_base_p = r->start;
-	}
-	else {
+	} else {
 		iounmap(mpsc_shared_regs.mpsc_routing_base);
 		release_mem_region(mpsc_shared_regs.mpsc_routing_base_p,
-			MPSC_ROUTING_REG_BLOCK_SIZE);
+				MPSC_ROUTING_REG_BLOCK_SIZE);
 		mpsc_resource_err("SDMA intr base");
 		return -ENOMEM;
 	}
@@ -1810,18 +1709,17 @@ mpsc_shared_map_regs(struct platform_dev
 	return 0;
 }
 
-static void
-mpsc_shared_unmap_regs(void)
+static void mpsc_shared_unmap_regs(void)
 {
 	if (!mpsc_shared_regs.mpsc_routing_base) {
 		iounmap(mpsc_shared_regs.mpsc_routing_base);
 		release_mem_region(mpsc_shared_regs.mpsc_routing_base_p,
-			MPSC_ROUTING_REG_BLOCK_SIZE);
+				MPSC_ROUTING_REG_BLOCK_SIZE);
 	}
 	if (!mpsc_shared_regs.sdma_intr_base) {
 		iounmap(mpsc_shared_regs.sdma_intr_base);
 		release_mem_region(mpsc_shared_regs.sdma_intr_base_p,
-			MPSC_SDMA_INTR_REG_BLOCK_SIZE);
+				MPSC_SDMA_INTR_REG_BLOCK_SIZE);
 	}
 
 	mpsc_shared_regs.mpsc_routing_base = NULL;
@@ -1829,19 +1727,17 @@ mpsc_shared_unmap_regs(void)
 
 	mpsc_shared_regs.mpsc_routing_base_p = 0;
 	mpsc_shared_regs.sdma_intr_base_p = 0;
-
-	return;
 }
 
-static int
-mpsc_shared_drv_probe(struct platform_device *dev)
+static int mpsc_shared_drv_probe(struct platform_device *dev)
 {
 	struct mpsc_shared_pdata	*pdata;
 	int				 rc = -ENODEV;
 
 	if (dev->id == 0) {
-		if (!(rc = mpsc_shared_map_regs(dev)))  {
-			pdata = (struct mpsc_shared_pdata *)dev->dev.platform_data;
+		if (!(rc = mpsc_shared_map_regs(dev))) {
+			pdata = (struct mpsc_shared_pdata *)
+				dev->dev.platform_data;
 
 			mpsc_shared_regs.MPSC_MRR_m = pdata->mrr_val;
 			mpsc_shared_regs.MPSC_RCRR_m= pdata->rcrr_val;
@@ -1858,8 +1754,7 @@ mpsc_shared_drv_probe(struct platform_de
 	return rc;
 }
 
-static int
-mpsc_shared_drv_remove(struct platform_device *dev)
+static int mpsc_shared_drv_remove(struct platform_device *dev)
 {
 	int	rc = -ENODEV;
 
@@ -1880,7 +1775,7 @@ static struct platform_driver mpsc_share
 	.probe	= mpsc_shared_drv_probe,
 	.remove	= mpsc_shared_drv_remove,
 	.driver	= {
-		.name = MPSC_SHARED_NAME,
+		.name	= MPSC_SHARED_NAME,
 	},
 };
 
@@ -1892,55 +1787,51 @@ static struct platform_driver mpsc_share
  ******************************************************************************
  */
 static struct uart_driver mpsc_reg = {
-	.owner       = THIS_MODULE,
-	.driver_name = MPSC_DRIVER_NAME,
-	.dev_name    = MPSC_DEV_NAME,
-	.major       = MPSC_MAJOR,
-	.minor       = MPSC_MINOR_START,
-	.nr          = MPSC_NUM_CTLRS,
-	.cons        = MPSC_CONSOLE,
+	.owner		= THIS_MODULE,
+	.driver_name	= MPSC_DRIVER_NAME,
+	.dev_name	= MPSC_DEV_NAME,
+	.major		= MPSC_MAJOR,
+	.minor		= MPSC_MINOR_START,
+	.nr		= MPSC_NUM_CTLRS,
+	.cons		= MPSC_CONSOLE,
 };
 
-static int
-mpsc_drv_map_regs(struct mpsc_port_info *pi, struct platform_device *pd)
+static int mpsc_drv_map_regs(struct mpsc_port_info *pi,
+		struct platform_device *pd)
 {
 	struct resource	*r;
 
-	if ((r = platform_get_resource(pd, IORESOURCE_MEM, MPSC_BASE_ORDER)) &&
-		request_mem_region(r->start, MPSC_REG_BLOCK_SIZE, "mpsc_regs")){
-
+	if ((r = platform_get_resource(pd, IORESOURCE_MEM, MPSC_BASE_ORDER))
+			&& request_mem_region(r->start, MPSC_REG_BLOCK_SIZE,
+			"mpsc_regs")) {
 		pi->mpsc_base = ioremap(r->start, MPSC_REG_BLOCK_SIZE);
 		pi->mpsc_base_p = r->start;
-	}
-	else {
+	} else {
 		mpsc_resource_err("MPSC base");
-		return -ENOMEM;
+		goto err;
 	}
 
 	if ((r = platform_get_resource(pd, IORESOURCE_MEM,
-		MPSC_SDMA_BASE_ORDER)) && request_mem_region(r->start,
-		MPSC_SDMA_REG_BLOCK_SIZE, "sdma_regs")) {
-
+					MPSC_SDMA_BASE_ORDER))
+			&& request_mem_region(r->start,
+				MPSC_SDMA_REG_BLOCK_SIZE, "sdma_regs")) {
 		pi->sdma_base = ioremap(r->start,MPSC_SDMA_REG_BLOCK_SIZE);
 		pi->sdma_base_p = r->start;
-	}
-	else {
+	} else {
 		mpsc_resource_err("SDMA base");
 		if (pi->mpsc_base) {
 			iounmap(pi->mpsc_base);
 			pi->mpsc_base = NULL;
 		}
-		return -ENOMEM;
+		goto err;
 	}
 
 	if ((r = platform_get_resource(pd,IORESOURCE_MEM,MPSC_BRG_BASE_ORDER))
-		&& request_mem_region(r->start, MPSC_BRG_REG_BLOCK_SIZE,
-		"brg_regs")) {
-
+			&& request_mem_region(r->start,
+				MPSC_BRG_REG_BLOCK_SIZE, "brg_regs")) {
 		pi->brg_base = ioremap(r->start, MPSC_BRG_REG_BLOCK_SIZE);
 		pi->brg_base_p = r->start;
-	}
-	else {
+	} else {
 		mpsc_resource_err("BRG base");
 		if (pi->mpsc_base) {
 			iounmap(pi->mpsc_base);
@@ -1950,14 +1841,15 @@ mpsc_drv_map_regs(struct mpsc_port_info 
 			iounmap(pi->sdma_base);
 			pi->sdma_base = NULL;
 		}
-		return -ENOMEM;
+		goto err;
 	}
-
 	return 0;
+
+err:
+	return -ENOMEM;
 }
 
-static void
-mpsc_drv_unmap_regs(struct mpsc_port_info *pi)
+static void mpsc_drv_unmap_regs(struct mpsc_port_info *pi)
 {
 	if (!pi->mpsc_base) {
 		iounmap(pi->mpsc_base);
@@ -1979,13 +1871,10 @@ mpsc_drv_unmap_regs(struct mpsc_port_inf
 	pi->mpsc_base_p = 0;
 	pi->sdma_base_p = 0;
 	pi->brg_base_p = 0;
-
-	return;
 }
 
-static void
-mpsc_drv_get_platform_data(struct mpsc_port_info *pi,
-	struct platform_device *pd, int num)
+static void mpsc_drv_get_platform_data(struct mpsc_port_info *pi,
+		struct platform_device *pd, int num)
 {
 	struct mpsc_pdata	*pdata;
 
@@ -2020,12 +1909,9 @@ mpsc_drv_get_platform_data(struct mpsc_p
 	pi->shared_regs = &mpsc_shared_regs;
 
 	pi->port.irq = platform_get_irq(pd, 0);
-
-	return;
 }
 
-static int
-mpsc_drv_probe(struct platform_device *dev)
+static int mpsc_drv_probe(struct platform_device *dev)
 {
 	struct mpsc_port_info	*pi;
 	int			rc = -ENODEV;
@@ -2041,47 +1927,46 @@ mpsc_drv_probe(struct platform_device *d
 			if (!(rc = mpsc_make_ready(pi))) {
 				spin_lock_init(&pi->tx_lock);
 				if (!(rc = uart_add_one_port(&mpsc_reg,
-					&pi->port)))
+								&pi->port))) {
 					rc = 0;
-				else {
-					mpsc_release_port(
-						(struct uart_port *)pi);
+				} else {
+					mpsc_release_port((struct uart_port *)
+							pi);
 					mpsc_drv_unmap_regs(pi);
 				}
-			}
-			else
+			} else {
 				mpsc_drv_unmap_regs(pi);
+			}
 		}
 	}
 
 	return rc;
 }
 
-static int
-mpsc_drv_remove(struct platform_device *dev)
+static int mpsc_drv_remove(struct platform_device *dev)
 {
 	pr_debug("mpsc_drv_exit: Removing MPSC %d\n", dev->id);
 
 	if (dev->id < MPSC_NUM_CTLRS) {
 		uart_remove_one_port(&mpsc_reg, &mpsc_ports[dev->id].port);
-		mpsc_release_port((struct uart_port *)&mpsc_ports[dev->id].port);
+		mpsc_release_port((struct uart_port *)
+				&mpsc_ports[dev->id].port);
 		mpsc_drv_unmap_regs(&mpsc_ports[dev->id]);
 		return 0;
-	}
-	else
+	} else {
 		return -ENODEV;
+	}
 }
 
 static struct platform_driver mpsc_driver = {
 	.probe	= mpsc_drv_probe,
 	.remove	= mpsc_drv_remove,
 	.driver	= {
-		.name = MPSC_CTLR_NAME,
+		.name	= MPSC_CTLR_NAME,
 	},
 };
 
-static int __init
-mpsc_drv_init(void)
+static int __init mpsc_drv_init(void)
 {
 	int	rc;
 
@@ -2096,24 +1981,21 @@ mpsc_drv_init(void)
 				platform_driver_unregister(&mpsc_shared_driver);
 				uart_unregister_driver(&mpsc_reg);
 			}
-		}
-		else
+		} else {
 			uart_unregister_driver(&mpsc_reg);
+		}
 	}
 
 	return rc;
-
 }
 
-static void __exit
-mpsc_drv_exit(void)
+static void __exit mpsc_drv_exit(void)
 {
 	platform_driver_unregister(&mpsc_driver);
 	platform_driver_unregister(&mpsc_shared_driver);
 	uart_unregister_driver(&mpsc_reg);
 	memset(mpsc_ports, 0, sizeof(mpsc_ports));
 	memset(&mpsc_shared_regs, 0, sizeof(mpsc_shared_regs));
-	return;
 }
 
 module_init(mpsc_drv_init);
_

Patches currently in -mm which might be from mgreer@mvista.com are

origin.patch
serial-mpsc-remove-race-between-rx-stop-restart.patch
serial-mpsc-stop-rx-engine-when-cread-cleared.patch
serial-mpsc-remove-duplicate-support_sysrq-definition.patch
serial-mpsc-fix-coding-style-and-whitespace-issues.patch
