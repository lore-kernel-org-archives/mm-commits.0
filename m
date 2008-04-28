From: akpm@linux-foundation.org
Subject: - spi-pxa2xx_spi-sparse-fixes.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:49 -0700
Message-ID: <200804282155.m3SLtn0j018153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935555AbYD1V4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, nforrester@whoi.edu, stephen@streetfiresound.com, mm-commits@vger.kernel.org


The patch titled
     spi: pxa2xx_spi "sparse" fixes
has been removed from the -mm tree.  Its filename was
     spi-pxa2xx_spi-sparse-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: pxa2xx_spi "sparse" fixes
From: David Brownell <david-b@pacbell.net>

Various cleanups to pxa2xx_spi suggested by "sparse": make sure that
register addresess are "void __iomem *", and make a few functions properly
static.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ned Forrester <nforrester@whoi.edu>
Cc: Stephen Street <stephen@streetfiresound.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |   52 +++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff -puN drivers/spi/pxa2xx_spi.c~spi-pxa2xx_spi-sparse-fixes drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-pxa2xx_spi-sparse-fixes
+++ a/drivers/spi/pxa2xx_spi.c
@@ -67,8 +67,11 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 				| SSCR1_SPH | SSCR1_SPO | SSCR1_LBM)
 
 #define DEFINE_SSP_REG(reg, off) \
-static inline u32 read_##reg(void *p) { return __raw_readl(p + (off)); } \
-static inline void write_##reg(u32 v, void *p) { __raw_writel(v, p + (off)); }
+static inline u32 read_##reg(void const __iomem *p) \
+{ return __raw_readl(p + (off)); } \
+\
+static inline void write_##reg(u32 v, void __iomem *p) \
+{ __raw_writel(v, p + (off)); }
 
 DEFINE_SSP_REG(SSCR0, 0x00)
 DEFINE_SSP_REG(SSCR1, 0x04)
@@ -106,7 +109,7 @@ struct driver_data {
 	u32 *null_dma_buf;
 
 	/* SSP register addresses */
-	void *ioaddr;
+	void __iomem *ioaddr;
 	u32 ssdr_physical;
 
 	/* SSP masks*/
@@ -173,7 +176,7 @@ static int flush(struct driver_data *drv
 {
 	unsigned long limit = loops_per_jiffy << 1;
 
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	do {
 		while (read_SSSR(reg) & SSSR_RNE) {
@@ -191,7 +194,7 @@ static void null_cs_control(u32 command)
 
 static int null_writer(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 	u8 n_bytes = drv_data->n_bytes;
 
 	if (((read_SSSR(reg) & 0x00000f00) == 0x00000f00)
@@ -206,7 +209,7 @@ static int null_writer(struct driver_dat
 
 static int null_reader(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 	u8 n_bytes = drv_data->n_bytes;
 
 	while ((read_SSSR(reg) & SSSR_RNE)
@@ -220,7 +223,7 @@ static int null_reader(struct driver_dat
 
 static int u8_writer(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	if (((read_SSSR(reg) & 0x00000f00) == 0x00000f00)
 		|| (drv_data->tx == drv_data->tx_end))
@@ -234,7 +237,7 @@ static int u8_writer(struct driver_data 
 
 static int u8_reader(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	while ((read_SSSR(reg) & SSSR_RNE)
 		&& (drv_data->rx < drv_data->rx_end)) {
@@ -247,7 +250,7 @@ static int u8_reader(struct driver_data 
 
 static int u16_writer(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	if (((read_SSSR(reg) & 0x00000f00) == 0x00000f00)
 		|| (drv_data->tx == drv_data->tx_end))
@@ -261,7 +264,7 @@ static int u16_writer(struct driver_data
 
 static int u16_reader(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	while ((read_SSSR(reg) & SSSR_RNE)
 		&& (drv_data->rx < drv_data->rx_end)) {
@@ -274,7 +277,7 @@ static int u16_reader(struct driver_data
 
 static int u32_writer(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	if (((read_SSSR(reg) & 0x00000f00) == 0x00000f00)
 		|| (drv_data->tx == drv_data->tx_end))
@@ -288,7 +291,7 @@ static int u32_writer(struct driver_data
 
 static int u32_reader(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	while ((read_SSSR(reg) & SSSR_RNE)
 		&& (drv_data->rx < drv_data->rx_end)) {
@@ -412,7 +415,7 @@ static void giveback(struct driver_data 
 		msg->complete(msg->context);
 }
 
-static int wait_ssp_rx_stall(void *ioaddr)
+static int wait_ssp_rx_stall(void const __iomem *ioaddr)
 {
 	unsigned long limit = loops_per_jiffy << 1;
 
@@ -432,9 +435,9 @@ static int wait_dma_channel_stop(int cha
 	return limit;
 }
 
-void dma_error_stop(struct driver_data *drv_data, const char *msg)
+static void dma_error_stop(struct driver_data *drv_data, const char *msg)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	/* Stop and reset */
 	DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
@@ -456,7 +459,7 @@ void dma_error_stop(struct driver_data *
 
 static void dma_transfer_complete(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 	struct spi_message *msg = drv_data->cur_msg;
 
 	/* Clear and disable interrupts on SSP and DMA channels*/
@@ -536,7 +539,7 @@ static void dma_handler(int channel, voi
 static irqreturn_t dma_transfer(struct driver_data *drv_data)
 {
 	u32 irq_status;
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	irq_status = read_SSSR(reg) & drv_data->mask_sr;
 	if (irq_status & SSSR_ROR) {
@@ -570,7 +573,7 @@ static irqreturn_t dma_transfer(struct d
 
 static void int_error_stop(struct driver_data *drv_data, const char* msg)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	/* Stop and reset SSP */
 	write_SSSR(drv_data->clear_sr, reg);
@@ -588,7 +591,7 @@ static void int_error_stop(struct driver
 
 static void int_transfer_complete(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	/* Stop SSP */
 	write_SSSR(drv_data->clear_sr, reg);
@@ -614,7 +617,7 @@ static void int_transfer_complete(struct
 
 static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	u32 irq_mask = (read_SSCR1(reg) & SSCR1_TIE) ?
 			drv_data->mask_sr : drv_data->mask_sr & ~SSSR_TFS;
@@ -675,7 +678,7 @@ static irqreturn_t interrupt_transfer(st
 static irqreturn_t ssp_int(int irq, void *dev_id)
 {
 	struct driver_data *drv_data = dev_id;
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	if (!drv_data->cur_msg) {
 
@@ -695,7 +698,8 @@ static irqreturn_t ssp_int(int irq, void
 	return drv_data->transfer_handler(drv_data);
 }
 
-int set_dma_burst_and_threshold(struct chip_data *chip, struct spi_device *spi,
+static int set_dma_burst_and_threshold(struct chip_data *chip,
+				struct spi_device *spi,
 				u8 bits_per_word, u32 *burst_code,
 				u32 *threshold)
 {
@@ -809,7 +813,7 @@ static void pump_transfers(unsigned long
 	struct spi_transfer *previous = NULL;
 	struct chip_data *chip = NULL;
 	struct ssp_device *ssp = drv_data->ssp;
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 	u32 clk_div = 0;
 	u8 bits = 0;
 	u32 speed = 0;
@@ -1338,7 +1342,7 @@ static int __init pxa2xx_spi_probe(struc
 	struct device *dev = &pdev->dev;
 	struct pxa2xx_spi_master *platform_info;
 	struct spi_master *master;
-	struct driver_data *drv_data = 0;
+	struct driver_data *drv_data = NULL;
 	struct ssp_device *ssp;
 	int status = 0;
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
git-acpi.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
git-mmc.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
remove-duplicated-unlikely-in-is_err.patch

