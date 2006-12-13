From: akpm@osdl.org
Subject: - spi-stabilize-pio-mode-transfers-on-pxa2xx-systems.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:51:49 -0800
Message-ID: <200612130651.kBD6pn8v030376@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57299 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964969AbWLMGwV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:52:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stephen@streetfiresound.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: stabilize PIO mode transfers on PXA2xx systems
has been removed from the -mm tree.  Its filename was
     spi-stabilize-pio-mode-transfers-on-pxa2xx-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: stabilize PIO mode transfers on PXA2xx systems
From: Stephen Street <stephen@streetfiresound.com>

Stabilize PIO mode transfers against a range of word sizes and FIFO
thresholds and fixes word size setup/override issues.

1) 16 and 32 bit DMA/PIO transfers broken due to timing differences.
2) Potential for bad transfer counts due to transfer size assumptions.
3) Setup function broken is multiple ways.
4) Per transfer bit_per_word changes break DMA setup in pump_tranfers.
5) False positive timeout are not errors.
6) Changes in pxa2xx_spi_chip not effective in calls to setup.
7) Timeout scaling wrong for PXA255 NSSP.
8) Driver leaks memory while busy during unloading.

Known issues:

SPI_CS_HIGH and SPI_LSB_FIRST settings in struct spi_device are not handled.

Testing:

This patch has been test against the "random length, random bits/word,
random data (verified on loopback) and stepped baud rate by octaves
(3.6MHz to 115kHz)" test.  It is robust in PIO mode, using any
combination of tx and rx thresholds, and also in DMA mode (which
internally computes the thresholds).

Much thanks to Ned Forrester for exhaustive reviews, fixes and testing.
The driver is substantially better for his efforts.

Signed-off-by: Stephen Street <stephen@streetfiresound.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/spi/pxa2xx              |   16 
 drivers/spi/pxa2xx_spi.c              |  737 ++++++++++++++----------
 include/asm-arm/arch-pxa/pxa2xx_spi.h |    5 
 3 files changed, 451 insertions(+), 307 deletions(-)

diff -puN Documentation/spi/pxa2xx~spi-stabilize-pio-mode-transfers-on-pxa2xx-systems Documentation/spi/pxa2xx
--- a/Documentation/spi/pxa2xx~spi-stabilize-pio-mode-transfers-on-pxa2xx-systems
+++ a/Documentation/spi/pxa2xx
@@ -102,7 +102,7 @@ struct pxa2xx_spi_chip {
 	u8 tx_threshold;
 	u8 rx_threshold;
 	u8 dma_burst_size;
-	u32 timeout_microsecs;
+	u32 timeout;
 	u8 enable_loopback;
 	void (*cs_control)(u32 command);
 };
@@ -121,7 +121,7 @@ the PXA2xx "Developer Manual" sections o
 to determine the correct value. An SSP configured for byte-wide transfers would
 use a value of 8.
 
-The "pxa2xx_spi_chip.timeout_microsecs" fields is used to efficiently handle
+The "pxa2xx_spi_chip.timeout" fields is used to efficiently handle
 trailing bytes in the SSP receiver fifo.  The correct value for this field is
 dependent on the SPI bus speed ("spi_board_info.max_speed_hz") and the specific
 slave device.  Please note that the PXA2xx SSP 1 does not support trailing byte
@@ -162,18 +162,18 @@ static void cs8405a_cs_control(u32 comma
 }
 
 static struct pxa2xx_spi_chip cs8415a_chip_info = {
-	.tx_threshold = 12, /* SSP hardward FIFO threshold */
-	.rx_threshold = 4, /* SSP hardward FIFO threshold */
+	.tx_threshold = 8, /* SSP hardward FIFO threshold */
+	.rx_threshold = 8, /* SSP hardward FIFO threshold */
 	.dma_burst_size = 8, /* Byte wide transfers used so 8 byte bursts */
-	.timeout_microsecs = 64, /* Wait at least 64usec to handle trailing */
+	.timeout = 235, /* See Intel documentation */
 	.cs_control = cs8415a_cs_control, /* Use external chip select */
 };
 
 static struct pxa2xx_spi_chip cs8405a_chip_info = {
-	.tx_threshold = 12, /* SSP hardward FIFO threshold */
-	.rx_threshold = 4, /* SSP hardward FIFO threshold */
+	.tx_threshold = 8, /* SSP hardward FIFO threshold */
+	.rx_threshold = 8, /* SSP hardward FIFO threshold */
 	.dma_burst_size = 8, /* Byte wide transfers used so 8 byte bursts */
-	.timeout_microsecs = 64, /* Wait at least 64usec to handle trailing */
+	.timeout = 235, /* See Intel documentation */
 	.cs_control = cs8405a_cs_control, /* Use external chip select */
 };
 
diff -puN drivers/spi/pxa2xx_spi.c~spi-stabilize-pio-mode-transfers-on-pxa2xx-systems drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-stabilize-pio-mode-transfers-on-pxa2xx-systems
+++ a/drivers/spi/pxa2xx_spi.c
@@ -49,6 +49,14 @@ MODULE_LICENSE("GPL");
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
 #define IS_DMA_ALIGNED(x) (((u32)(x)&0x07)==0)
 
+/* for testing SSCR1 changes that require SSP restart, basically
+ * everything except the service and interrupt enables */
+#define SSCR1_CHANGE_MASK (SSCR1_TTELP | SSCR1_TTE | SSCR1_EBCEI | SSCR1_SCFR \
+				| SSCR1_ECRA | SSCR1_ECRB | SSCR1_SCLKDIR \
+				| SSCR1_RWOT | SSCR1_TRAIL | SSCR1_PINTE \
+				| SSCR1_STRF | SSCR1_EFWR |SSCR1_RFT \
+				| SSCR1_TFT | SSCR1_SPH | SSCR1_SPO | SSCR1_LBM)
+
 #define DEFINE_SSP_REG(reg, off) \
 static inline u32 read_##reg(void *p) { return __raw_readl(p + (off)); } \
 static inline void write_##reg(u32 v, void *p) { __raw_writel(v, p + (off)); }
@@ -123,8 +131,8 @@ struct driver_data {
 	u8 n_bytes;
 	u32 dma_width;
 	int cs_change;
-	void (*write)(struct driver_data *drv_data);
-	void (*read)(struct driver_data *drv_data);
+	int (*write)(struct driver_data *drv_data);
+	int (*read)(struct driver_data *drv_data);
 	irqreturn_t (*transfer_handler)(struct driver_data *drv_data);
 	void (*cs_control)(u32 command);
 };
@@ -132,7 +140,6 @@ struct driver_data {
 struct chip_data {
 	u32 cr0;
 	u32 cr1;
-	u32 to;
 	u32 psp;
 	u32 timeout;
 	u8 n_bytes;
@@ -143,8 +150,8 @@ struct chip_data {
 	u8 enable_dma;
 	u8 bits_per_word;
 	u32 speed_hz;
-	void (*write)(struct driver_data *drv_data);
-	void (*read)(struct driver_data *drv_data);
+	int (*write)(struct driver_data *drv_data);
+	int (*read)(struct driver_data *drv_data);
 	void (*cs_control)(u32 command);
 };
 
@@ -166,114 +173,118 @@ static int flush(struct driver_data *drv
 	return limit;
 }
 
-static void restore_state(struct driver_data *drv_data)
-{
-	void *reg = drv_data->ioaddr;
-
-	/* Clear status and disable clock */
-	write_SSSR(drv_data->clear_sr, reg);
-	write_SSCR0(drv_data->cur_chip->cr0 & ~SSCR0_SSE, reg);
-
-	/* Load the registers */
-	write_SSCR1(drv_data->cur_chip->cr1, reg);
-	write_SSCR0(drv_data->cur_chip->cr0, reg);
-	if (drv_data->ssp_type != PXA25x_SSP) {
-		write_SSTO(0, reg);
-		write_SSPSP(drv_data->cur_chip->psp, reg);
-	}
-}
-
 static void null_cs_control(u32 command)
 {
 }
 
-static void null_writer(struct driver_data *drv_data)
+static int null_writer(struct driver_data *drv_data)
 {
 	void *reg = drv_data->ioaddr;
 	u8 n_bytes = drv_data->n_bytes;
 
-	while ((read_SSSR(reg) & SSSR_TNF)
-			&& (drv_data->tx < drv_data->tx_end)) {
-		write_SSDR(0, reg);
-		drv_data->tx += n_bytes;
-	}
+	if (((read_SSSR(reg) & 0x00000f00) == 0x00000f00)
+		|| (drv_data->tx == drv_data->tx_end))
+		return 0;
+
+	write_SSDR(0, reg);
+	drv_data->tx += n_bytes;
+
+	return 1;
 }
 
-static void null_reader(struct driver_data *drv_data)
+static int null_reader(struct driver_data *drv_data)
 {
 	void *reg = drv_data->ioaddr;
 	u8 n_bytes = drv_data->n_bytes;
 
 	while ((read_SSSR(reg) & SSSR_RNE)
-			&& (drv_data->rx < drv_data->rx_end)) {
+		&& (drv_data->rx < drv_data->rx_end)) {
 		read_SSDR(reg);
 		drv_data->rx += n_bytes;
 	}
+
+	return drv_data->rx == drv_data->rx_end;
 }
 
-static void u8_writer(struct driver_data *drv_data)
+static int u8_writer(struct driver_data *drv_data)
 {
 	void *reg = drv_data->ioaddr;
 
-	while ((read_SSSR(reg) & SSSR_TNF)
-			&& (drv_data->tx < drv_data->tx_end)) {
-		write_SSDR(*(u8 *)(drv_data->tx), reg);
-		++drv_data->tx;
-	}
+	if (((read_SSSR(reg) & 0x00000f00) == 0x00000f00)
+		|| (drv_data->tx == drv_data->tx_end))
+		return 0;
+
+	write_SSDR(*(u8 *)(drv_data->tx), reg);
+	++drv_data->tx;
+
+	return 1;
 }
 
-static void u8_reader(struct driver_data *drv_data)
+static int u8_reader(struct driver_data *drv_data)
 {
 	void *reg = drv_data->ioaddr;
 
 	while ((read_SSSR(reg) & SSSR_RNE)
-			&& (drv_data->rx < drv_data->rx_end)) {
+		&& (drv_data->rx < drv_data->rx_end)) {
 		*(u8 *)(drv_data->rx) = read_SSDR(reg);
 		++drv_data->rx;
 	}
+
+	return drv_data->rx == drv_data->rx_end;
 }
 
-static void u16_writer(struct driver_data *drv_data)
+static int u16_writer(struct driver_data *drv_data)
 {
 	void *reg = drv_data->ioaddr;
 
-	while ((read_SSSR(reg) & SSSR_TNF)
-			&& (drv_data->tx < drv_data->tx_end)) {
-		write_SSDR(*(u16 *)(drv_data->tx), reg);
-		drv_data->tx += 2;
-	}
+	if (((read_SSSR(reg) & 0x00000f00) == 0x00000f00)
+		|| (drv_data->tx == drv_data->tx_end))
+		return 0;
+
+	write_SSDR(*(u16 *)(drv_data->tx), reg);
+	drv_data->tx += 2;
+
+	return 1;
 }
 
-static void u16_reader(struct driver_data *drv_data)
+static int u16_reader(struct driver_data *drv_data)
 {
 	void *reg = drv_data->ioaddr;
 
 	while ((read_SSSR(reg) & SSSR_RNE)
-			&& (drv_data->rx < drv_data->rx_end)) {
+		&& (drv_data->rx < drv_data->rx_end)) {
 		*(u16 *)(drv_data->rx) = read_SSDR(reg);
 		drv_data->rx += 2;
 	}
+
+	return drv_data->rx == drv_data->rx_end;
 }
-static void u32_writer(struct driver_data *drv_data)
+
+static int u32_writer(struct driver_data *drv_data)
 {
 	void *reg = drv_data->ioaddr;
 
-	while ((read_SSSR(reg) & SSSR_TNF)
-			&& (drv_data->tx < drv_data->tx_end)) {
-		write_SSDR(*(u32 *)(drv_data->tx), reg);
-		drv_data->tx += 4;
-	}
+	if (((read_SSSR(reg) & 0x00000f00) == 0x00000f00)
+		|| (drv_data->tx == drv_data->tx_end))
+		return 0;
+
+	write_SSDR(*(u32 *)(drv_data->tx), reg);
+	drv_data->tx += 4;
+
+	return 1;
 }
 
-static void u32_reader(struct driver_data *drv_data)
+static int u32_reader(struct driver_data *drv_data)
 {
 	void *reg = drv_data->ioaddr;
 
 	while ((read_SSSR(reg) & SSSR_RNE)
-			&& (drv_data->rx < drv_data->rx_end)) {
+		&& (drv_data->rx < drv_data->rx_end)) {
 		*(u32 *)(drv_data->rx) = read_SSDR(reg);
 		drv_data->rx += 4;
 	}
+
+	return drv_data->rx == drv_data->rx_end;
 }
 
 static void *next_transfer(struct driver_data *drv_data)
@@ -409,257 +420,239 @@ static int wait_dma_channel_stop(int cha
 	return limit;
 }
 
-static void dma_handler(int channel, void *data)
+void dma_error_stop(struct driver_data *drv_data, const char *msg)
 {
-	struct driver_data *drv_data = data;
-	struct spi_message *msg = drv_data->cur_msg;
 	void *reg = drv_data->ioaddr;
-	u32 irq_status = DCSR(channel) & DMA_INT_MASK;
-	u32 trailing_sssr = 0;
 
-	if (irq_status & DCSR_BUSERR) {
+	/* Stop and reset */
+	DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
+	DCSR(drv_data->tx_channel) = RESET_DMA_CHANNEL;
+	write_SSSR(drv_data->clear_sr, reg);
+	write_SSCR1(read_SSCR1(reg) & ~drv_data->dma_cr1, reg);
+	if (drv_data->ssp_type != PXA25x_SSP)
+		write_SSTO(0, reg);
+	flush(drv_data);
+	write_SSCR0(read_SSCR0(reg) & ~SSCR0_SSE, reg);
 
-		/* Disable interrupts, clear status and reset DMA */
-		write_SSCR0(read_SSCR0(reg) & ~SSCR0_SSE, reg);
-		write_SSCR1(read_SSCR1(reg) & ~drv_data->dma_cr1, reg);
-		if (drv_data->ssp_type != PXA25x_SSP)
-			write_SSTO(0, reg);
-		write_SSSR(drv_data->clear_sr, reg);
-		DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
-		DCSR(drv_data->tx_channel) = RESET_DMA_CHANNEL;
+	unmap_dma_buffers(drv_data);
 
-		if (flush(drv_data) == 0)
-			dev_err(&drv_data->pdev->dev,
-					"dma_handler: flush fail\n");
+	dev_err(&drv_data->pdev->dev, "%s\n", msg);
 
-		unmap_dma_buffers(drv_data);
+	drv_data->cur_msg->state = ERROR_STATE;
+	tasklet_schedule(&drv_data->pump_transfers);
+}
+
+static void dma_transfer_complete(struct driver_data *drv_data)
+{
+	void *reg = drv_data->ioaddr;
+	struct spi_message *msg = drv_data->cur_msg;
+
+	/* Clear and disable interrupts on SSP and DMA channels*/
+	write_SSCR1(read_SSCR1(reg) & ~drv_data->dma_cr1, reg);
+	write_SSSR(drv_data->clear_sr, reg);
+	DCSR(drv_data->tx_channel) = RESET_DMA_CHANNEL;
+	DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
+
+	if (wait_dma_channel_stop(drv_data->rx_channel) == 0)
+		dev_err(&drv_data->pdev->dev,
+			"dma_handler: dma rx channel stop failed\n");
+
+	if (wait_ssp_rx_stall(drv_data->ioaddr) == 0)
+		dev_err(&drv_data->pdev->dev,
+			"dma_transfer: ssp rx stall failed\n");
+
+	unmap_dma_buffers(drv_data);
+
+	/* update the buffer pointer for the amount completed in dma */
+	drv_data->rx += drv_data->len -
+			(DCMD(drv_data->rx_channel) & DCMD_LENGTH);
+
+	/* read trailing data from fifo, it does not matter how many
+	 * bytes are in the fifo just read until buffer is full
+	 * or fifo is empty, which ever occurs first */
+	drv_data->read(drv_data);
+
+	/* return count of what was actually read */
+	msg->actual_length += drv_data->len -
+				(drv_data->rx_end - drv_data->rx);
+
+	/* Release chip select if requested, transfer delays are
+	 * handled in pump_transfers */
+	if (drv_data->cs_change)
+		drv_data->cs_control(PXA2XX_CS_DEASSERT);
+
+	/* Move to next transfer */
+	msg->state = next_transfer(drv_data);
+
+	/* Schedule transfer tasklet */
+	tasklet_schedule(&drv_data->pump_transfers);
+}
+
+static void dma_handler(int channel, void *data)
+{
+	struct driver_data *drv_data = data;
+	u32 irq_status = DCSR(channel) & DMA_INT_MASK;
+
+	if (irq_status & DCSR_BUSERR) {
 
 		if (channel == drv_data->tx_channel)
-			dev_err(&drv_data->pdev->dev,
-				"dma_handler: bad bus address on "
-				"tx channel %d, source %x target = %x\n",
-				channel, DSADR(channel), DTADR(channel));
+			dma_error_stop(drv_data,
+					"dma_handler: "
+					"bad bus address on tx channel");
 		else
-			dev_err(&drv_data->pdev->dev,
-				"dma_handler: bad bus address on "
-				"rx channel %d, source %x target = %x\n",
-				channel, DSADR(channel), DTADR(channel));
-
-		msg->state = ERROR_STATE;
-		tasklet_schedule(&drv_data->pump_transfers);
+			dma_error_stop(drv_data,
+					"dma_handler: "
+					"bad bus address on rx channel");
+		return;
 	}
 
 	/* PXA255x_SSP has no timeout interrupt, wait for tailing bytes */
-	if ((drv_data->ssp_type == PXA25x_SSP)
-		&& (channel == drv_data->tx_channel)
-		&& (irq_status & DCSR_ENDINTR)) {
+	if ((channel == drv_data->tx_channel)
+		&& (irq_status & DCSR_ENDINTR)
+		&& (drv_data->ssp_type == PXA25x_SSP)) {
 
 		/* Wait for rx to stall */
 		if (wait_ssp_rx_stall(drv_data->ioaddr) == 0)
 			dev_err(&drv_data->pdev->dev,
 				"dma_handler: ssp rx stall failed\n");
 
-		/* Clear and disable interrupts on SSP and DMA channels*/
-		write_SSCR1(read_SSCR1(reg) & ~drv_data->dma_cr1, reg);
-		write_SSSR(drv_data->clear_sr, reg);
-		DCSR(drv_data->tx_channel) = RESET_DMA_CHANNEL;
-		DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
-		if (wait_dma_channel_stop(drv_data->rx_channel) == 0)
-			dev_err(&drv_data->pdev->dev,
-				"dma_handler: dma rx channel stop failed\n");
-
-		unmap_dma_buffers(drv_data);
-
-		/* Read trailing bytes */
-		/* Calculate number of trailing bytes, read them */
-		trailing_sssr = read_SSSR(reg);
-		if ((trailing_sssr & 0xf008) != 0xf000) {
-			drv_data->rx = drv_data->rx_end -
-					(((trailing_sssr >> 12) & 0x0f) + 1);
-			drv_data->read(drv_data);
-		}
-		msg->actual_length += drv_data->len;
-
-		/* Release chip select if requested, transfer delays are
-		 * handled in pump_transfers */
-		if (drv_data->cs_change)
-			drv_data->cs_control(PXA2XX_CS_DEASSERT);
-
-		/* Move to next transfer */
-		msg->state = next_transfer(drv_data);
-
-		/* Schedule transfer tasklet */
-		tasklet_schedule(&drv_data->pump_transfers);
+		/* finish this transfer, start the next */
+		dma_transfer_complete(drv_data);
 	}
 }
 
 static irqreturn_t dma_transfer(struct driver_data *drv_data)
 {
 	u32 irq_status;
-	u32 trailing_sssr = 0;
-	struct spi_message *msg = drv_data->cur_msg;
 	void *reg = drv_data->ioaddr;
 
 	irq_status = read_SSSR(reg) & drv_data->mask_sr;
 	if (irq_status & SSSR_ROR) {
-		/* Clear and disable interrupts on SSP and DMA channels*/
-		write_SSCR0(read_SSCR0(reg) & ~SSCR0_SSE, reg);
-		write_SSCR1(read_SSCR1(reg) & ~drv_data->dma_cr1, reg);
-		if (drv_data->ssp_type != PXA25x_SSP)
-			write_SSTO(0, reg);
-		write_SSSR(drv_data->clear_sr, reg);
-		DCSR(drv_data->tx_channel) = RESET_DMA_CHANNEL;
-		DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
-		unmap_dma_buffers(drv_data);
-
-		if (flush(drv_data) == 0)
-			dev_err(&drv_data->pdev->dev,
-					"dma_transfer: flush fail\n");
-
-		dev_warn(&drv_data->pdev->dev, "dma_transfer: fifo overun\n");
-
-		drv_data->cur_msg->state = ERROR_STATE;
-		tasklet_schedule(&drv_data->pump_transfers);
-
+		dma_error_stop(drv_data, "dma_transfer: fifo overrun");
 		return IRQ_HANDLED;
 	}
 
 	/* Check for false positive timeout */
-	if ((irq_status & SSSR_TINT) && DCSR(drv_data->tx_channel) & DCSR_RUN) {
+	if ((irq_status & SSSR_TINT)
+		&& (DCSR(drv_data->tx_channel) & DCSR_RUN)) {
 		write_SSSR(SSSR_TINT, reg);
 		return IRQ_HANDLED;
 	}
 
 	if (irq_status & SSSR_TINT || drv_data->rx == drv_data->rx_end) {
 
-		/* Clear and disable interrupts on SSP and DMA channels*/
-		write_SSCR1(read_SSCR1(reg) & ~drv_data->dma_cr1, reg);
+		/* Clear and disable timeout interrupt, do the rest in
+		 * dma_transfer_complete */
 		if (drv_data->ssp_type != PXA25x_SSP)
 			write_SSTO(0, reg);
-		write_SSSR(drv_data->clear_sr, reg);
-		DCSR(drv_data->tx_channel) = RESET_DMA_CHANNEL;
-		DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
 
-		if (wait_dma_channel_stop(drv_data->rx_channel) == 0)
-			dev_err(&drv_data->pdev->dev,
-				"dma_transfer: dma rx channel stop failed\n");
+		/* finish this transfer, start the next */
+		dma_transfer_complete(drv_data);
 
-		if (wait_ssp_rx_stall(drv_data->ioaddr) == 0)
-			dev_err(&drv_data->pdev->dev,
-				"dma_transfer: ssp rx stall failed\n");
+		return IRQ_HANDLED;
+	}
 
-		unmap_dma_buffers(drv_data);
+	/* Opps problem detected */
+	return IRQ_NONE;
+}
 
-		/* Calculate number of trailing bytes, read them */
-		trailing_sssr = read_SSSR(reg);
-		if ((trailing_sssr & 0xf008) != 0xf000) {
-			drv_data->rx = drv_data->rx_end -
-					(((trailing_sssr >> 12) & 0x0f) + 1);
-			drv_data->read(drv_data);
-		}
-		msg->actual_length += drv_data->len;
+static void int_error_stop(struct driver_data *drv_data, const char* msg)
+{
+	void *reg = drv_data->ioaddr;
+
+	/* Stop and reset SSP */
+	write_SSSR(drv_data->clear_sr, reg);
+	write_SSCR1(read_SSCR1(reg) & ~drv_data->int_cr1, reg);
+	if (drv_data->ssp_type != PXA25x_SSP)
+		write_SSTO(0, reg);
+	flush(drv_data);
+	write_SSCR0(read_SSCR0(reg) & ~SSCR0_SSE, reg);
 
-		/* Release chip select if requested, transfer delays are
-		 * handled in pump_transfers */
-		if (drv_data->cs_change)
-			drv_data->cs_control(PXA2XX_CS_DEASSERT);
+	dev_err(&drv_data->pdev->dev, "%s\n", msg);
 
-		/* Move to next transfer */
-		msg->state = next_transfer(drv_data);
+	drv_data->cur_msg->state = ERROR_STATE;
+	tasklet_schedule(&drv_data->pump_transfers);
+}
 
-		/* Schedule transfer tasklet */
-		tasklet_schedule(&drv_data->pump_transfers);
+static void int_transfer_complete(struct driver_data *drv_data)
+{
+	void *reg = drv_data->ioaddr;
 
-		return IRQ_HANDLED;
-	}
+	/* Stop SSP */
+	write_SSSR(drv_data->clear_sr, reg);
+	write_SSCR1(read_SSCR1(reg) & ~drv_data->int_cr1, reg);
+	if (drv_data->ssp_type != PXA25x_SSP)
+		write_SSTO(0, reg);
 
-	/* Opps problem detected */
-	return IRQ_NONE;
+	/* Update total byte transfered return count actual bytes read */
+	drv_data->cur_msg->actual_length += drv_data->len -
+				(drv_data->rx_end - drv_data->rx);
+
+	/* Release chip select if requested, transfer delays are
+	 * handled in pump_transfers */
+	if (drv_data->cs_change)
+		drv_data->cs_control(PXA2XX_CS_DEASSERT);
+
+	/* Move to next transfer */
+	drv_data->cur_msg->state = next_transfer(drv_data);
+
+	/* Schedule transfer tasklet */
+	tasklet_schedule(&drv_data->pump_transfers);
 }
 
 static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
 {
-	struct spi_message *msg = drv_data->cur_msg;
 	void *reg = drv_data->ioaddr;
-	unsigned long limit = loops_per_jiffy << 1;
-	u32 irq_status;
+
 	u32 irq_mask = (read_SSCR1(reg) & SSCR1_TIE) ?
 			drv_data->mask_sr : drv_data->mask_sr & ~SSSR_TFS;
 
-	while ((irq_status = read_SSSR(reg) & irq_mask)) {
+	u32 irq_status = read_SSSR(reg) & irq_mask;
 
-		if (irq_status & SSSR_ROR) {
-
-			/* Clear and disable interrupts */
-			write_SSCR0(read_SSCR0(reg) & ~SSCR0_SSE, reg);
-			write_SSCR1(read_SSCR1(reg) & ~drv_data->int_cr1, reg);
-			if (drv_data->ssp_type != PXA25x_SSP)
-				write_SSTO(0, reg);
-			write_SSSR(drv_data->clear_sr, reg);
-
-			if (flush(drv_data) == 0)
-				dev_err(&drv_data->pdev->dev,
-					"interrupt_transfer: flush fail\n");
-
-			/* Stop the SSP */
-
-			dev_warn(&drv_data->pdev->dev,
-					"interrupt_transfer: fifo overun\n");
+	if (irq_status & SSSR_ROR) {
+		int_error_stop(drv_data, "interrupt_transfer: fifo overrun");
+		return IRQ_HANDLED;
+	}
 
-			msg->state = ERROR_STATE;
-			tasklet_schedule(&drv_data->pump_transfers);
+	if (irq_status & SSSR_TINT) {
+		write_SSSR(SSSR_TINT, reg);
+		if (drv_data->read(drv_data)) {
+			int_transfer_complete(drv_data);
+			return IRQ_HANDLED;
+		}
+	}
 
+	/* Drain rx fifo, Fill tx fifo and prevent overruns */
+	do {
+		if (drv_data->read(drv_data)) {
+			int_transfer_complete(drv_data);
 			return IRQ_HANDLED;
 		}
+	} while (drv_data->write(drv_data));
 
-		/* Look for false positive timeout */
-		if ((irq_status & SSSR_TINT)
-				&& (drv_data->rx < drv_data->rx_end))
-			write_SSSR(SSSR_TINT, reg);
-
-		/* Pump data */
-		drv_data->read(drv_data);
-		drv_data->write(drv_data);
-
-		if (drv_data->tx == drv_data->tx_end) {
-			/* Disable tx interrupt */
-			write_SSCR1(read_SSCR1(reg) & ~SSCR1_TIE, reg);
-			irq_mask = drv_data->mask_sr & ~SSSR_TFS;
-
-			/* PXA25x_SSP has no timeout, read trailing bytes */
-			if (drv_data->ssp_type == PXA25x_SSP) {
-				while ((read_SSSR(reg) & SSSR_BSY) && limit--)
-					drv_data->read(drv_data);
+	if (drv_data->read(drv_data)) {
+		int_transfer_complete(drv_data);
+		return IRQ_HANDLED;
+	}
 
-				if (limit == 0)
-					dev_err(&drv_data->pdev->dev,
+	if (drv_data->tx == drv_data->tx_end) {
+		write_SSCR1(read_SSCR1(reg) & ~SSCR1_TIE, reg);
+		/* PXA25x_SSP has no timeout, read trailing bytes */
+		if (drv_data->ssp_type == PXA25x_SSP) {
+			if (!wait_ssp_rx_stall(reg))
+			{
+				int_error_stop(drv_data, "interrupt_transfer: "
+						"rx stall failed");
+				return IRQ_HANDLED;
+			}
+			if (!drv_data->read(drv_data))
+			{
+				int_error_stop(drv_data,
 						"interrupt_transfer: "
-						"trailing byte read failed\n");
+						"trailing byte read failed");
+				return IRQ_HANDLED;
 			}
-		}
-
-		if ((irq_status & SSSR_TINT)
-				|| (drv_data->rx == drv_data->rx_end)) {
-
-			/* Clear timeout */
-			write_SSCR1(read_SSCR1(reg) & ~drv_data->int_cr1, reg);
-			if (drv_data->ssp_type != PXA25x_SSP)
-				write_SSTO(0, reg);
-			write_SSSR(drv_data->clear_sr, reg);
-
-			/* Update total byte transfered */
-			msg->actual_length += drv_data->len;
-
-			/* Release chip select if requested, transfer delays are
-			 * handled in pump_transfers */
-			if (drv_data->cs_change)
-				drv_data->cs_control(PXA2XX_CS_DEASSERT);
-
-			/* Move to next transfer */
-			msg->state = next_transfer(drv_data);
-
-			/* Schedule transfer tasklet */
-			tasklet_schedule(&drv_data->pump_transfers);
+			int_transfer_complete(drv_data);
 		}
 	}
 
@@ -681,7 +674,7 @@ static irqreturn_t ssp_int(int irq, void
 		write_SSSR(drv_data->clear_sr, reg);
 
 		dev_err(&drv_data->pdev->dev, "bad message state "
-				"in interrupt handler");
+			"in interrupt handler\n");
 
 		/* Never fail */
 		return IRQ_HANDLED;
@@ -690,6 +683,102 @@ static irqreturn_t ssp_int(int irq, void
 	return drv_data->transfer_handler(drv_data);
 }
 
+int set_dma_burst_and_threshold(struct chip_data *chip, struct spi_device *spi,
+				u8 bits_per_word, u32 *burst_code,
+				u32 *threshold)
+{
+	struct pxa2xx_spi_chip *chip_info =
+			(struct pxa2xx_spi_chip *)spi->controller_data;
+	int bytes_per_word;
+	int burst_bytes;
+	int thresh_words;
+	int req_burst_size;
+	int retval = 0;
+
+	/* Set the threshold (in registers) to equal the same amount of data
+	 * as represented by burst size (in bytes).  The computation below
+	 * is (burst_size rounded up to nearest 8 byte, word or long word)
+	 * divided by (bytes/register); the tx threshold is the inverse of
+	 * the rx, so that there will always be enough data in the rx fifo
+	 * to satisfy a burst, and there will always be enough space in the
+	 * tx fifo to accept a burst (a tx burst will overwrite the fifo if
+	 * there is not enough space), there must always remain enough empty
+	 * space in the rx fifo for any data loaded to the tx fifo.
+	 * Whenever burst_size (in bytes) equals bits/word, the fifo threshold
+	 * will be 8, or half the fifo;
+	 * The threshold can only be set to 2, 4 or 8, but not 16, because
+	 * to burst 16 to the tx fifo, the fifo would have to be empty;
+	 * however, the minimum fifo trigger level is 1, and the tx will
+	 * request service when the fifo is at this level, with only 15 spaces.
+	 */
+
+	/* find bytes/word */
+	if (bits_per_word <= 8)
+		bytes_per_word = 1;
+	else if (bits_per_word <= 16)
+		bytes_per_word = 2;
+	else
+		bytes_per_word = 4;
+
+	/* use struct pxa2xx_spi_chip->dma_burst_size if available */
+	if (chip_info)
+		req_burst_size = chip_info->dma_burst_size;
+	else {
+		switch (chip->dma_burst_size) {
+		default:
+			/* if the default burst size is not set,
+			 * do it now */
+			chip->dma_burst_size = DCMD_BURST8;
+		case DCMD_BURST8:
+			req_burst_size = 8;
+			break;
+		case DCMD_BURST16:
+			req_burst_size = 16;
+			break;
+		case DCMD_BURST32:
+			req_burst_size = 32;
+			break;
+		}
+	}
+	if (req_burst_size <= 8) {
+		*burst_code = DCMD_BURST8;
+		burst_bytes = 8;
+	} else if (req_burst_size <= 16) {
+		if (bytes_per_word == 1) {
+			/* don't burst more than 1/2 the fifo */
+			*burst_code = DCMD_BURST8;
+			burst_bytes = 8;
+			retval = 1;
+		} else {
+			*burst_code = DCMD_BURST16;
+			burst_bytes = 16;
+		}
+	} else {
+		if (bytes_per_word == 1) {
+			/* don't burst more than 1/2 the fifo */
+			*burst_code = DCMD_BURST8;
+			burst_bytes = 8;
+			retval = 1;
+		} else if (bytes_per_word == 2) {
+			/* don't burst more than 1/2 the fifo */
+			*burst_code = DCMD_BURST16;
+			burst_bytes = 16;
+			retval = 1;
+		} else {
+			*burst_code = DCMD_BURST32;
+			burst_bytes = 32;
+		}
+	}
+
+	thresh_words = burst_bytes / bytes_per_word;
+
+	/* thresh_words will be between 2 and 8 */
+	*threshold = (SSCR1_RxTresh(thresh_words) & SSCR1_RFT)
+			| (SSCR1_TxTresh(16-thresh_words) & SSCR1_TFT);
+
+	return retval;
+}
+
 static void pump_transfers(unsigned long data)
 {
 	struct driver_data *drv_data = (struct driver_data *)data;
@@ -702,6 +791,9 @@ static void pump_transfers(unsigned long
 	u8 bits = 0;
 	u32 speed = 0;
 	u32 cr0;
+	u32 cr1;
+	u32 dma_thresh = drv_data->cur_chip->dma_threshold;
+	u32 dma_burst = drv_data->cur_chip->dma_burst_size;
 
 	/* Get current state information */
 	message = drv_data->cur_msg;
@@ -731,6 +823,16 @@ static void pump_transfers(unsigned long
 			udelay(previous->delay_usecs);
 	}
 
+	/* Check transfer length */
+	if (transfer->len > 8191)
+	{
+		dev_warn(&drv_data->pdev->dev, "pump_transfers: transfer "
+				"length greater than 8191\n");
+		message->status = -EINVAL;
+		giveback(drv_data);
+		return;
+	}
+
 	/* Setup the transfer state based on the type of transfer */
 	if (flush(drv_data) == 0) {
 		dev_err(&drv_data->pdev->dev, "pump_transfers: flush failed\n");
@@ -747,17 +849,15 @@ static void pump_transfers(unsigned long
 	drv_data->rx_end = drv_data->rx + transfer->len;
 	drv_data->rx_dma = transfer->rx_dma;
 	drv_data->tx_dma = transfer->tx_dma;
-	drv_data->len = transfer->len;
+	drv_data->len = transfer->len & DCMD_LENGTH;
 	drv_data->write = drv_data->tx ? chip->write : null_writer;
 	drv_data->read = drv_data->rx ? chip->read : null_reader;
 	drv_data->cs_change = transfer->cs_change;
 
 	/* Change speed and bit per word on a per transfer */
+	cr0 = chip->cr0;
 	if (transfer->speed_hz || transfer->bits_per_word) {
 
-		/* Disable clock */
-		write_SSCR0(chip->cr0 & ~SSCR0_SSE, reg);
-		cr0 = chip->cr0;
 		bits = chip->bits_per_word;
 		speed = chip->speed_hz;
 
@@ -796,15 +896,24 @@ static void pump_transfers(unsigned long
 			drv_data->write = drv_data->write != null_writer ?
 						u32_writer : null_writer;
 		}
+		/* if bits/word is changed in dma mode, then must check the
+		 * thresholds and burst also */
+		if (chip->enable_dma) {
+			if (set_dma_burst_and_threshold(chip, message->spi,
+							bits, &dma_burst,
+							&dma_thresh))
+				if (printk_ratelimit())
+					dev_warn(&message->spi->dev,
+						"pump_transfer: "
+						"DMA burst size reduced to "
+						"match bits_per_word\n");
+		}
 
 		cr0 = clk_div
 			| SSCR0_Motorola
 			| SSCR0_DataSize(bits > 16 ? bits - 16 : bits)
 			| SSCR0_SSE
 			| (bits > 16 ? SSCR0_EDSS : 0);
-
-		/* Start it back up */
-		write_SSCR0(cr0, reg);
 	}
 
 	message->state = RUNNING_STATE;
@@ -823,13 +932,13 @@ static void pump_transfers(unsigned long
 			/* No target address increment */
 			DCMD(drv_data->rx_channel) = DCMD_FLOWSRC
 							| drv_data->dma_width
-							| chip->dma_burst_size
+							| dma_burst
 							| drv_data->len;
 		else
 			DCMD(drv_data->rx_channel) = DCMD_INCTRGADDR
 							| DCMD_FLOWSRC
 							| drv_data->dma_width
-							| chip->dma_burst_size
+							| dma_burst
 							| drv_data->len;
 
 		/* Setup tx DMA Channel */
@@ -840,13 +949,13 @@ static void pump_transfers(unsigned long
 			/* No source address increment */
 			DCMD(drv_data->tx_channel) = DCMD_FLOWTRG
 							| drv_data->dma_width
-							| chip->dma_burst_size
+							| dma_burst
 							| drv_data->len;
 		else
 			DCMD(drv_data->tx_channel) = DCMD_INCSRCADDR
 							| DCMD_FLOWTRG
 							| drv_data->dma_width
-							| chip->dma_burst_size
+							| dma_burst
 							| drv_data->len;
 
 		/* Enable dma end irqs on SSP to detect end of transfer */
@@ -856,16 +965,11 @@ static void pump_transfers(unsigned long
 		/* Fix me, need to handle cs polarity */
 		drv_data->cs_control(PXA2XX_CS_ASSERT);
 
-		/* Go baby, go */
+		/* Clear status and start DMA engine */
+		cr1 = chip->cr1 | dma_thresh | drv_data->dma_cr1;
 		write_SSSR(drv_data->clear_sr, reg);
 		DCSR(drv_data->rx_channel) |= DCSR_RUN;
 		DCSR(drv_data->tx_channel) |= DCSR_RUN;
-		if (drv_data->ssp_type != PXA25x_SSP)
-			write_SSTO(chip->timeout, reg);
-		write_SSCR1(chip->cr1
-				| chip->dma_threshold
-				| drv_data->dma_cr1,
-				reg);
 	} else {
 		/* Ensure we have the correct interrupt handler	*/
 		drv_data->transfer_handler = interrupt_transfer;
@@ -873,14 +977,25 @@ static void pump_transfers(unsigned long
 		/* Fix me, need to handle cs polarity */
 		drv_data->cs_control(PXA2XX_CS_ASSERT);
 
-		/* Go baby, go */
+		/* Clear status  */
+		cr1 = chip->cr1 | chip->threshold | drv_data->int_cr1;
 		write_SSSR(drv_data->clear_sr, reg);
+	}
+
+	/* see if we need to reload the config registers */
+	if ((read_SSCR0(reg) != cr0)
+		|| (read_SSCR1(reg) & SSCR1_CHANGE_MASK) !=
+			(cr1 & SSCR1_CHANGE_MASK)) {
+
+		write_SSCR0(cr0 & ~SSCR0_SSE, reg);
 		if (drv_data->ssp_type != PXA25x_SSP)
 			write_SSTO(chip->timeout, reg);
-		write_SSCR1(chip->cr1
-				| chip->threshold
-				| drv_data->int_cr1,
-				reg);
+		write_SSCR1(cr1, reg);
+		write_SSCR0(cr0, reg);
+	} else {
+		if (drv_data->ssp_type != PXA25x_SSP)
+			write_SSTO(chip->timeout, reg);
+		write_SSCR1(cr1, reg);
 	}
 }
 
@@ -915,9 +1030,9 @@ static void pump_messages(struct work_st
 						struct spi_transfer,
 						transfer_list);
 
-	/* Setup the SSP using the per chip configuration */
+	/* prepare to setup the SSP, in pump_transfers, using the per
+	 * chip configuration */
 	drv_data->cur_chip = spi_get_ctldata(drv_data->cur_msg->spi);
-	restore_state(drv_data);
 
 	/* Mark as busy and launch transfers */
 	tasklet_schedule(&drv_data->pump_transfers);
@@ -963,63 +1078,77 @@ static int setup(struct spi_device *spi)
 		spi->bits_per_word = 8;
 
 	if (drv_data->ssp_type != PXA25x_SSP
-			&& (spi->bits_per_word < 4 || spi->bits_per_word > 32))
+		&& (spi->bits_per_word < 4 || spi->bits_per_word > 32)) {
+		dev_err(&spi->dev, "failed setup: ssp_type=%d, bits/wrd=%d "
+				"b/w not 4-32 for type non-PXA25x_SSP\n",
+				drv_data->ssp_type, spi->bits_per_word);
 		return -EINVAL;
-	else if (spi->bits_per_word < 4 || spi->bits_per_word > 16)
+	}
+	else if (drv_data->ssp_type == PXA25x_SSP
+			&& (spi->bits_per_word < 4
+				|| spi->bits_per_word > 16)) {
+		dev_err(&spi->dev, "failed setup: ssp_type=%d, bits/wrd=%d "
+				"b/w not 4-16 for type PXA25x_SSP\n",
+				drv_data->ssp_type, spi->bits_per_word);
 		return -EINVAL;
+	}
 
-	/* Only alloc (or use chip_info) on first setup */
+	/* Only alloc on first setup */
 	chip = spi_get_ctldata(spi);
-	if (chip == NULL) {
+	if (!chip) {
 		chip = kzalloc(sizeof(struct chip_data), GFP_KERNEL);
-		if (!chip)
+		if (!chip) {
+			dev_err(&spi->dev,
+				"failed setup: can't allocate chip data\n");
 			return -ENOMEM;
+		}
 
 		chip->cs_control = null_cs_control;
 		chip->enable_dma = 0;
-		chip->timeout = SSP_TIMEOUT(1000);
+		chip->timeout = 1000;
 		chip->threshold = SSCR1_RxTresh(1) | SSCR1_TxTresh(1);
 		chip->dma_burst_size = drv_data->master_info->enable_dma ?
 					DCMD_BURST8 : 0;
-
-		chip_info = spi->controller_data;
 	}
 
+	/* protocol drivers may change the chip settings, so...
+	 * if chip_info exists, use it */
+	chip_info = spi->controller_data;
+
 	/* chip_info isn't always needed */
+	chip->cr1 = 0;
 	if (chip_info) {
 		if (chip_info->cs_control)
 			chip->cs_control = chip_info->cs_control;
 
-		chip->timeout = SSP_TIMEOUT(chip_info->timeout_microsecs);
+		chip->timeout = chip_info->timeout;
 
-		chip->threshold = SSCR1_RxTresh(chip_info->rx_threshold)
-					| SSCR1_TxTresh(chip_info->tx_threshold);
+		chip->threshold = (SSCR1_RxTresh(chip_info->rx_threshold) &
+								SSCR1_RFT) |
+				(SSCR1_TxTresh(chip_info->tx_threshold) &
+								SSCR1_TFT);
 
 		chip->enable_dma = chip_info->dma_burst_size != 0
 					&& drv_data->master_info->enable_dma;
 		chip->dma_threshold = 0;
 
-		if (chip->enable_dma) {
-			if (chip_info->dma_burst_size <= 8) {
-				chip->dma_threshold = SSCR1_RxTresh(8)
-							| SSCR1_TxTresh(8);
-				chip->dma_burst_size = DCMD_BURST8;
-			} else if (chip_info->dma_burst_size <= 16) {
-				chip->dma_threshold = SSCR1_RxTresh(16)
-							| SSCR1_TxTresh(16);
-				chip->dma_burst_size = DCMD_BURST16;
-			} else {
-				chip->dma_threshold = SSCR1_RxTresh(32)
-							| SSCR1_TxTresh(32);
-				chip->dma_burst_size = DCMD_BURST32;
-			}
-		}
-
-
 		if (chip_info->enable_loopback)
 			chip->cr1 = SSCR1_LBM;
 	}
 
+	/* set dma burst and threshold outside of chip_info path so that if
+	 * chip_info goes away after setting chip->enable_dma, the
+	 * burst and threshold can still respond to changes in bits_per_word */
+	if (chip->enable_dma) {
+		/* set up legal burst and threshold for dma */
+		if (set_dma_burst_and_threshold(chip, spi, spi->bits_per_word,
+						&chip->dma_burst_size,
+						&chip->dma_threshold)) {
+			dev_warn(&spi->dev, "in setup: DMA burst size reduced "
+					"to match bits_per_word\n");
+		}
+	}
+
 	if (drv_data->ioaddr == SSP1_VIRT)
 		clk_div = SSP1_SerClkDiv(spi->max_speed_hz);
 	else if (drv_data->ioaddr == SSP2_VIRT)
@@ -1027,7 +1156,11 @@ static int setup(struct spi_device *spi)
 	else if (drv_data->ioaddr == SSP3_VIRT)
 		clk_div = SSP3_SerClkDiv(spi->max_speed_hz);
 	else
+	{
+		dev_err(&spi->dev, "failed setup: unknown IO address=0x%p\n",
+			drv_data->ioaddr);
 		return -ENODEV;
+	}
 	chip->speed_hz = spi->max_speed_hz;
 
 	chip->cr0 = clk_div
@@ -1071,7 +1204,6 @@ static int setup(struct spi_device *spi)
 		chip->write = u32_writer;
 	} else {
 		dev_err(&spi->dev, "invalid wordsize\n");
-		kfree(chip);
 		return -ENODEV;
 	}
 	chip->bits_per_word = spi->bits_per_word;
@@ -1162,6 +1294,12 @@ static int destroy_queue(struct driver_d
 	int status;
 
 	status = stop_queue(drv_data);
+	/* we are unloading the module or failing to load (only two calls
+	 * to this routine), and neither call can handle a return value.
+	 * However, destroy_workqueue calls flush_workqueue, and that will
+	 * block until all work is done.  If the reason that stop_queue
+	 * timed out is that the work will never finish, then it does no
+	 * good to call destroy_workqueue, so return anyway. */
 	if (status != 0)
 		return status;
 
@@ -1360,7 +1498,16 @@ static int pxa2xx_spi_remove(struct plat
 	/* Remove the queue */
 	status = destroy_queue(drv_data);
 	if (status != 0)
-		return status;
+		/* the kernel does not check the return status of this
+		 * this routine (mod->exit, within the kernel).  Therefore
+		 * nothing is gained by returning from here, the module is
+		 * going away regardless, and we should not leave any more
+		 * resources allocated than necessary.  We cannot free the
+		 * message memory in drv_data->queue, but we can release the
+		 * resources below.  I think the kernel should honor -EBUSY
+		 * returns but... */
+		dev_err(&pdev->dev, "pxa2xx_spi_remove: workqueue will not "
+			"complete, message memory not freed\n");
 
 	/* Disable the SSP at the peripheral and SOC level */
 	write_SSCR0(0, drv_data->ioaddr);
diff -puN include/asm-arm/arch-pxa/pxa2xx_spi.h~spi-stabilize-pio-mode-transfers-on-pxa2xx-systems include/asm-arm/arch-pxa/pxa2xx_spi.h
--- a/include/asm-arm/arch-pxa/pxa2xx_spi.h~spi-stabilize-pio-mode-transfers-on-pxa2xx-systems
+++ a/include/asm-arm/arch-pxa/pxa2xx_spi.h
@@ -27,16 +27,13 @@
 #define SSP1_SerClkDiv(x) (((CLOCK_SPEED_HZ/2/(x+1))<<8)&0x0000ff00)
 #define SSP2_SerClkDiv(x) (((CLOCK_SPEED_HZ/(x+1))<<8)&0x000fff00)
 #define SSP3_SerClkDiv(x) (((CLOCK_SPEED_HZ/(x+1))<<8)&0x000fff00)
-#define SSP_TIMEOUT_SCALE (2712)
 #elif defined(CONFIG_PXA27x)
 #define CLOCK_SPEED_HZ 13000000
 #define SSP1_SerClkDiv(x) (((CLOCK_SPEED_HZ/(x+1))<<8)&0x000fff00)
 #define SSP2_SerClkDiv(x) (((CLOCK_SPEED_HZ/(x+1))<<8)&0x000fff00)
 #define SSP3_SerClkDiv(x) (((CLOCK_SPEED_HZ/(x+1))<<8)&0x000fff00)
-#define SSP_TIMEOUT_SCALE (769)
 #endif
 
-#define SSP_TIMEOUT(x) ((x*10000)/SSP_TIMEOUT_SCALE)
 #define SSP1_VIRT ((void *)(io_p2v(__PREG(SSCR0_P(1)))))
 #define SSP2_VIRT ((void *)(io_p2v(__PREG(SSCR0_P(2)))))
 #define SSP3_VIRT ((void *)(io_p2v(__PREG(SSCR0_P(3)))))
@@ -63,7 +60,7 @@ struct pxa2xx_spi_chip {
 	u8 tx_threshold;
 	u8 rx_threshold;
 	u8 dma_burst_size;
-	u32 timeout_microsecs;
+	u32 timeout;
 	u8 enable_loopback;
 	void (*cs_control)(u32 command);
 };
_

Patches currently in -mm which might be from stephen@streetfiresound.com are

origin.patch

