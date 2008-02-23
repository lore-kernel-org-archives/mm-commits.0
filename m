From: akpm@linux-foundation.org
Subject: + spi-pxa2xx_spi-sparse-fixes.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:34:18 -0800
Message-ID: <200802230735.m1N7Z77o018331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764003AbYBWIEs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:04:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, nforrester@whoi.edu, stephen@streetfiresound.com


The patch titled
     spi: pxa2xx_spi "sparse" fixes
has been added to the -mm tree.  Its filename is
     spi-pxa2xx_spi-sparse-fixes.patch

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
@@ -66,8 +66,11 @@ MODULE_LICENSE("GPL");
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
@@ -105,7 +108,7 @@ struct driver_data {
 	u32 *null_dma_buf;
 
 	/* SSP register addresses */
-	void *ioaddr;
+	void __iomem *ioaddr;
 	u32 ssdr_physical;
 
 	/* SSP masks*/
@@ -172,7 +175,7 @@ static int flush(struct driver_data *drv
 {
 	unsigned long limit = loops_per_jiffy << 1;
 
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	do {
 		while (read_SSSR(reg) & SSSR_RNE) {
@@ -190,7 +193,7 @@ static void null_cs_control(u32 command)
 
 static int null_writer(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 	u8 n_bytes = drv_data->n_bytes;
 
 	if (((read_SSSR(reg) & 0x00000f00) == 0x00000f00)
@@ -205,7 +208,7 @@ static int null_writer(struct driver_dat
 
 static int null_reader(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 	u8 n_bytes = drv_data->n_bytes;
 
 	while ((read_SSSR(reg) & SSSR_RNE)
@@ -219,7 +222,7 @@ static int null_reader(struct driver_dat
 
 static int u8_writer(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	if (((read_SSSR(reg) & 0x00000f00) == 0x00000f00)
 		|| (drv_data->tx == drv_data->tx_end))
@@ -233,7 +236,7 @@ static int u8_writer(struct driver_data 
 
 static int u8_reader(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	while ((read_SSSR(reg) & SSSR_RNE)
 		&& (drv_data->rx < drv_data->rx_end)) {
@@ -246,7 +249,7 @@ static int u8_reader(struct driver_data 
 
 static int u16_writer(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	if (((read_SSSR(reg) & 0x00000f00) == 0x00000f00)
 		|| (drv_data->tx == drv_data->tx_end))
@@ -260,7 +263,7 @@ static int u16_writer(struct driver_data
 
 static int u16_reader(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	while ((read_SSSR(reg) & SSSR_RNE)
 		&& (drv_data->rx < drv_data->rx_end)) {
@@ -273,7 +276,7 @@ static int u16_reader(struct driver_data
 
 static int u32_writer(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	if (((read_SSSR(reg) & 0x00000f00) == 0x00000f00)
 		|| (drv_data->tx == drv_data->tx_end))
@@ -287,7 +290,7 @@ static int u32_writer(struct driver_data
 
 static int u32_reader(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	while ((read_SSSR(reg) & SSSR_RNE)
 		&& (drv_data->rx < drv_data->rx_end)) {
@@ -411,7 +414,7 @@ static void giveback(struct driver_data 
 		msg->complete(msg->context);
 }
 
-static int wait_ssp_rx_stall(void *ioaddr)
+static int wait_ssp_rx_stall(void const __iomem *ioaddr)
 {
 	unsigned long limit = loops_per_jiffy << 1;
 
@@ -431,9 +434,9 @@ static int wait_dma_channel_stop(int cha
 	return limit;
 }
 
-void dma_error_stop(struct driver_data *drv_data, const char *msg)
+static void dma_error_stop(struct driver_data *drv_data, const char *msg)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	/* Stop and reset */
 	DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
@@ -455,7 +458,7 @@ void dma_error_stop(struct driver_data *
 
 static void dma_transfer_complete(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 	struct spi_message *msg = drv_data->cur_msg;
 
 	/* Clear and disable interrupts on SSP and DMA channels*/
@@ -535,7 +538,7 @@ static void dma_handler(int channel, voi
 static irqreturn_t dma_transfer(struct driver_data *drv_data)
 {
 	u32 irq_status;
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	irq_status = read_SSSR(reg) & drv_data->mask_sr;
 	if (irq_status & SSSR_ROR) {
@@ -569,7 +572,7 @@ static irqreturn_t dma_transfer(struct d
 
 static void int_error_stop(struct driver_data *drv_data, const char* msg)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	/* Stop and reset SSP */
 	write_SSSR(drv_data->clear_sr, reg);
@@ -587,7 +590,7 @@ static void int_error_stop(struct driver
 
 static void int_transfer_complete(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	/* Stop SSP */
 	write_SSSR(drv_data->clear_sr, reg);
@@ -613,7 +616,7 @@ static void int_transfer_complete(struct
 
 static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
 {
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	u32 irq_mask = (read_SSCR1(reg) & SSCR1_TIE) ?
 			drv_data->mask_sr : drv_data->mask_sr & ~SSSR_TFS;
@@ -674,7 +677,7 @@ static irqreturn_t interrupt_transfer(st
 static irqreturn_t ssp_int(int irq, void *dev_id)
 {
 	struct driver_data *drv_data = dev_id;
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 
 	if (!drv_data->cur_msg) {
 
@@ -694,7 +697,8 @@ static irqreturn_t ssp_int(int irq, void
 	return drv_data->transfer_handler(drv_data);
 }
 
-int set_dma_burst_and_threshold(struct chip_data *chip, struct spi_device *spi,
+static int set_dma_burst_and_threshold(struct chip_data *chip,
+				struct spi_device *spi,
 				u8 bits_per_word, u32 *burst_code,
 				u32 *threshold)
 {
@@ -808,7 +812,7 @@ static void pump_transfers(unsigned long
 	struct spi_transfer *previous = NULL;
 	struct chip_data *chip = NULL;
 	struct ssp_device *ssp = drv_data->ssp;
-	void *reg = drv_data->ioaddr;
+	void __iomem *reg = drv_data->ioaddr;
 	u32 clk_div = 0;
 	u8 bits = 0;
 	u32 speed = 0;
@@ -1337,7 +1341,7 @@ static int __init pxa2xx_spi_probe(struc
 	struct device *dev = &pdev->dev;
 	struct pxa2xx_spi_master *platform_info;
 	struct spi_master *master;
-	struct driver_data *drv_data = 0;
+	struct driver_data *drv_data = NULL;
 	struct ssp_device *ssp;
 	int status = 0;
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

atmel_spi-fix-clock-polarity.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
git-avr32.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
usb-ehci-tolerates-some-buggy-devices.patch
rtc-cmos-display-hpet-emulation-mode.patch
spi-pxa2xx_spi-sparse-fixes.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
