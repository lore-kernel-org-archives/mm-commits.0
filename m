From: akpm@linux-foundation.org
Subject: - spi-spi_bfin-cleanups-error-handling.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:29:07 -0800
Message-ID: <200712080129.lB81T7Cf013380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34423 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754028AbXLHB3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:29:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, dbrownell@users.sourceforge.net, michael.hennerich@analog.com, mm-commits@vger.kernel.org


The patch titled
     spi: spi_bfin cleanups, error handling
has been removed from the -mm tree.  Its filename was
     spi-spi_bfin-cleanups-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: spi_bfin cleanups, error handling
From: Bryan Wu <bryan.wu@analog.com>

Cleanup and error handling

 - add error handling in SPI bus driver with selecting clients
 - use proper defines to access Blackfin MMRs
 - remove useless SSYNCs
 - cleaner use of portmux calls

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |  109 +++++++++++++++---------------------
 1 file changed, 46 insertions(+), 63 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin-cleanups-error-handling drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin-cleanups-error-handling
+++ a/drivers/spi/spi_bfin5xx.c
@@ -59,10 +59,9 @@ MODULE_LICENSE("GPL");
 
 #define DEFINE_SPI_REG(reg, off) \
 static inline u16 read_##reg(void) \
-            { return *(volatile unsigned short*)(SPI0_REGBASE + off); } \
+	{ return bfin_read16(SPI0_REGBASE + off); } \
 static inline void write_##reg(u16 v) \
-            {*(volatile unsigned short*)(SPI0_REGBASE + off) = v;\
-             SSYNC();}
+	{bfin_write16(SPI0_REGBASE + off, v); }
 
 DEFINE_SPI_REG(CTRL, 0x00)
 DEFINE_SPI_REG(FLAG, 0x04)
@@ -145,7 +144,6 @@ static void bfin_spi_enable(struct drive
 
 	cr = read_CTRL();
 	write_CTRL(cr | BIT_CTL_ENABLE);
-	SSYNC();
 }
 
 static void bfin_spi_disable(struct driver_data *drv_data)
@@ -154,7 +152,6 @@ static void bfin_spi_disable(struct driv
 
 	cr = read_CTRL();
 	write_CTRL(cr & (~BIT_CTL_ENABLE));
-	SSYNC();
 }
 
 /* Caculate the SPI_BAUD register value based on input HZ */
@@ -182,52 +179,44 @@ static int flush(struct driver_data *drv
 	return limit;
 }
 
+#define MAX_SPI0_SSEL	7
+
 /* stop controller and re-config current chip*/
-static void restore_state(struct driver_data *drv_data)
+static int restore_state(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
+	int ret = 0;
+	u16 ssel[MAX_SPI0_SSEL] = {P_SPI0_SSEL1, P_SPI0_SSEL2, P_SPI0_SSEL3,
+					P_SPI0_SSEL4, P_SPI0_SSEL5,
+					P_SPI0_SSEL6, P_SPI0_SSEL7,};
 
 	/* Clear status and disable clock */
 	write_STAT(BIT_STAT_CLR);
 	bfin_spi_disable(drv_data);
 	dev_dbg(&drv_data->pdev->dev, "restoring spi ctl state\n");
 
+	/* Load the registers */
+	write_CTRL(chip->ctl_reg);
+	write_BAUD(chip->baud);
+	write_FLAG(chip->flag);
+
 	if (!chip->chip_select_requested) {
+		int i = chip->chip_select_num;
 
-		dev_dbg(&drv_data->pdev->dev,
-		"chip select number is %d\n", chip->chip_select_num);
+		dev_dbg(&drv_data->pdev->dev, "chip select number is %d\n", i);
 
-		switch (chip->chip_select_num) {
-		case 1:
-			peripheral_request(P_SPI0_SSEL1, DRV_NAME);
-			break;
-		case 2:
-			peripheral_request(P_SPI0_SSEL2, DRV_NAME);
-			break;
-		case 3:
-			peripheral_request(P_SPI0_SSEL3, DRV_NAME);
-			break;
-		case 4:
-			peripheral_request(P_SPI0_SSEL4, DRV_NAME);
-			break;
-		case 5:
-			peripheral_request(P_SPI0_SSEL5, DRV_NAME);
-			break;
-		case 6:
-			peripheral_request(P_SPI0_SSEL6, DRV_NAME);
-			break;
-		case 7:
-			peripheral_request(P_SPI0_SSEL7, DRV_NAME);
-			break;
-		}
+		if ((i > 0) && (i <= MAX_SPI0_SSEL))
+			ret = peripheral_request(ssel[i-1], DRV_NAME);
 
 		chip->chip_select_requested = 1;
 	}
 
-	/* Load the registers */
-	write_CTRL(chip->ctl_reg);
-	write_BAUD(chip->baud);
-	write_FLAG(chip->flag);
+	if (ret)
+		dev_dbg(&drv_data->pdev->dev,
+			": request chip select number %d failed\n",
+			chip->chip_select_num);
+
+	return ret;
 }
 
 /* used to kick off transfer in rx mode */
@@ -285,7 +274,6 @@ static void u8_cs_chg_writer(struct driv
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (read_STAT() & BIT_STAT_TXS)
@@ -293,13 +281,13 @@ static void u8_cs_chg_writer(struct driv
 		while (!(read_STAT() & BIT_STAT_SPIF))
 			continue;
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->tx;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
+
 }
 
 static void u8_reader(struct driver_data *drv_data)
@@ -331,7 +319,6 @@ static void u8_cs_chg_reader(struct driv
 
 	while (drv_data->rx < drv_data->rx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		read_RDBR();	/* kick off */
 		while (!(read_STAT() & BIT_STAT_RXS))
@@ -340,13 +327,13 @@ static void u8_cs_chg_reader(struct driv
 			continue;
 		*(u8 *) (drv_data->rx) = read_SHAW();
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->rx;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
+
 }
 
 static void u8_duplex(struct driver_data *drv_data)
@@ -370,7 +357,7 @@ static void u8_cs_chg_duplex(struct driv
 
 	while (drv_data->rx < drv_data->rx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
+
 
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (!(read_STAT() & BIT_STAT_SPIF))
@@ -379,14 +366,14 @@ static void u8_cs_chg_duplex(struct driv
 			continue;
 		*(u8 *) (drv_data->rx) = read_RDBR();
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->rx;
 		++drv_data->tx;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
+
 }
 
 static void u16_writer(struct driver_data *drv_data)
@@ -412,7 +399,6 @@ static void u16_cs_chg_writer(struct dri
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while ((read_STAT() & BIT_STAT_TXS))
@@ -420,13 +406,12 @@ static void u16_cs_chg_writer(struct dri
 		while (!(read_STAT() & BIT_STAT_SPIF))
 			continue;
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->tx += 2;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
 }
 
 static void u16_reader(struct driver_data *drv_data)
@@ -454,7 +439,6 @@ static void u16_cs_chg_reader(struct dri
 
 	while (drv_data->rx < drv_data->rx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		read_RDBR();	/* kick off */
 		while (!(read_STAT() & BIT_STAT_RXS))
@@ -463,13 +447,12 @@ static void u16_cs_chg_reader(struct dri
 			continue;
 		*(u16 *) (drv_data->rx) = read_SHAW();
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->rx += 2;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
 }
 
 static void u16_duplex(struct driver_data *drv_data)
@@ -493,7 +476,6 @@ static void u16_cs_chg_duplex(struct dri
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while (!(read_STAT() & BIT_STAT_SPIF))
@@ -502,14 +484,13 @@ static void u16_cs_chg_duplex(struct dri
 			continue;
 		*(u16 *) (drv_data->rx) = read_RDBR();
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
 }
 
 /* test if ther is more transfer to be done */
@@ -811,7 +792,6 @@ static void pump_transfers(unsigned long
 				"IO duplex: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
-			SSYNC();
 
 			drv_data->duplex(drv_data);
 
@@ -826,7 +806,6 @@ static void pump_transfers(unsigned long
 				"IO write: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
-			SSYNC();
 
 			drv_data->write(drv_data);
 
@@ -841,7 +820,6 @@ static void pump_transfers(unsigned long
 				"IO read: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
-			SSYNC();
 
 			drv_data->read(drv_data);
 			if (drv_data->rx != drv_data->rx_end)
@@ -892,6 +870,14 @@ static void pump_messages(struct work_st
 	/* Extract head of queue */
 	drv_data->cur_msg = list_entry(drv_data->queue.next,
 				       struct spi_message, queue);
+
+	/* Setup the SSP using the per chip configuration */
+	drv_data->cur_chip = spi_get_ctldata(drv_data->cur_msg->spi);
+	if (restore_state(drv_data)) {
+		spin_unlock_irqrestore(&drv_data->lock, flags);
+		return;
+	};
+
 	list_del_init(&drv_data->cur_msg->queue);
 
 	/* Initial message state */
@@ -899,13 +885,10 @@ static void pump_messages(struct work_st
 	drv_data->cur_transfer = list_entry(drv_data->cur_msg->transfers.next,
 					    struct spi_transfer, transfer_list);
 
-	/* Setup the SSP using the per chip configuration */
-	drv_data->cur_chip = spi_get_ctldata(drv_data->cur_msg->spi);
-	restore_state(drv_data);
-	dev_dbg(&drv_data->pdev->dev,
-		"got a message to pump, state is set to: baud %d, flag 0x%x, ctl 0x%x\n",
-   		drv_data->cur_chip->baud, drv_data->cur_chip->flag,
-   		drv_data->cur_chip->ctl_reg);
+	dev_dbg(&drv_data->pdev->dev, "got a message to pump, "
+		"state is set to: baud %d, flag 0x%x, ctl 0x%x\n",
+		drv_data->cur_chip->baud, drv_data->cur_chip->flag,
+		drv_data->cur_chip->ctl_reg);
 
 	dev_dbg(&drv_data->pdev->dev,
 		"the first transfer len is %d\n",
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
git-mtd.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch
kernel-printkc-concerns-about-the-console-handover.patch
remove-mm_ptovvtop.patch
blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz.patch
blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler.patch
blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs.patch
blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp.patch
blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch
blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment.patch
blackfin-rtc-driver-convert-sync-wait-to-use-the-irq-write-complete-notice.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
d_path-make-d_path-use-a-struct-path.patch
