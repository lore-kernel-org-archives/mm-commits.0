From: akpm@linux-foundation.org
Subject: + spi-spi_bfin-uses-portmux-for-additional-busses.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:42:38 -0700
Message-ID: <200710302242.l9UMgcgT031704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541AbXJ3Wmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonic.zhang@analog.com, bryan.wu@analog.com, dbrownell@users.sourceforge.net


The patch titled
     spi: spi_bfin uses portmux for additional busses
has been added to the -mm tree.  Its filename is
     spi-spi_bfin-uses-portmux-for-additional-busses.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: spi_bfin uses portmux for additional busses
From: Sonic Zhang <sonic.zhang@analog.com>

Use portmux mechanism to support SPI busses 1 and 2, instead of just the
original bus 0.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   51 +++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin-uses-portmux-for-additional-busses drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin-uses-portmux-for-additional-busses
+++ a/drivers/spi/spi_bfin5xx.c
@@ -209,17 +209,26 @@ static void cs_deactive(struct chip_data
 	write_FLAG(flag);
 }
 
-#define MAX_SPI0_SSEL	7
+#define MAX_SPI_SSEL	7
 
 /* stop controller and re-config current chip*/
 static int restore_state(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 	int ret = 0;
-	u16 ssel[MAX_SPI0_SSEL] = {P_SPI0_SSEL1, P_SPI0_SSEL2, P_SPI0_SSEL3,
-					P_SPI0_SSEL4, P_SPI0_SSEL5,
-					P_SPI0_SSEL6, P_SPI0_SSEL7,};
-
+	u16 ssel[3][MAX_SPI_SSEL] = {
+		{P_SPI0_SSEL1, P_SPI0_SSEL2, P_SPI0_SSEL3,
+		P_SPI0_SSEL4, P_SPI0_SSEL5,
+		P_SPI0_SSEL6, P_SPI0_SSEL7},
+
+		{P_SPI1_SSEL1, P_SPI1_SSEL2, P_SPI1_SSEL3,
+		P_SPI1_SSEL4, P_SPI1_SSEL5,
+		P_SPI1_SSEL6, P_SPI1_SSEL7},
+
+		{P_SPI2_SSEL1, P_SPI2_SSEL2, P_SPI2_SSEL3,
+		P_SPI2_SSEL4, P_SPI2_SSEL5,
+		P_SPI2_SSEL6, P_SPI2_SSEL7},
+	};
 	/* Clear status and disable clock */
 	write_STAT(BIT_STAT_CLR);
 	bfin_spi_disable(drv_data);
@@ -234,9 +243,9 @@ static int restore_state(struct driver_d
 		int i = chip->chip_select_num;
 
 		dev_dbg(&drv_data->pdev->dev, "chip select number is %d\n", i);
-
-		if ((i > 0) && (i <= MAX_SPI0_SSEL))
-			ret = peripheral_request(ssel[i-1], DRV_NAME);
+		if ((i > 0) && (i <= MAX_SPI_SSEL))
+			ret = peripheral_request(
+				ssel[drv_data->master->bus_num][i-1], DRV_NAME);
 
 		chip->chip_select_requested = 1;
 	}
@@ -329,7 +338,6 @@ static void u8_reader(struct driver_data
 	write_TDBR(0xFFFF);
 
 	dummy_read();
-
 	while (drv_data->rx < drv_data->rx_end - 1) {
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
@@ -640,7 +648,6 @@ static void pump_transfers(unsigned long
 	message = drv_data->cur_msg;
 	transfer = drv_data->cur_transfer;
 	chip = drv_data->cur_chip;
-
 	/*
 	 * if msg is error or done, report it back using complete() callback
 	 */
@@ -1206,16 +1213,20 @@ static inline int destroy_queue(struct d
 	return 0;
 }
 
-static int setup_pin_mux(int action)
+static int setup_pin_mux(int action, int bus_num)
 {
 
-	u16 pin_req[] = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0};
+	u16 pin_req[3][4] = {
+		{P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
+		{P_SPI1_SCK, P_SPI1_MISO, P_SPI1_MOSI, 0},
+		{P_SPI2_SCK, P_SPI2_MISO, P_SPI2_MOSI, 0},
+	};
 
 	if (action) {
-		if (peripheral_request_list(pin_req, DRV_NAME))
+		if (peripheral_request_list(pin_req[bus_num], DRV_NAME))
 			return -EFAULT;
 	} else {
-		peripheral_free_list(pin_req);
+		peripheral_free_list(pin_req[bus_num]);
 	}
 
 	return 0;
@@ -1239,11 +1250,6 @@ static int __init bfin5xx_spi_probe(stru
 		return -ENOMEM;
 	}
 
-	if (setup_pin_mux(1)) {
-		dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
-		goto out_error;
-	}
-
 	drv_data = spi_master_get_devdata(master);
 	drv_data->master = master;
 	drv_data->master_info = platform_info;
@@ -1298,6 +1304,11 @@ static int __init bfin5xx_spi_probe(stru
 		goto out_error_queue_alloc;
 	}
 
+	if (setup_pin_mux(1, master->bus_num)) {
+		dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
+		goto out_error;
+	}
+
 	dev_info(dev, "%s, Version %s, regs_base @ 0x%08x\n",
 		DRV_DESC, DRV_VERSION, spi_regs_base);
 	return status;
@@ -1340,7 +1351,7 @@ static int __devexit bfin5xx_spi_remove(
 	/* Disconnect from the SPI framework */
 	spi_unregister_master(drv_data->master);
 
-	setup_pin_mux(0);
+	setup_pin_mux(0, drv_data->master->bus_num);
 
 	/* Prevent double remove */
 	platform_set_drvdata(pdev, NULL);
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

origin.patch
spi-spi_bfin-uses-portmux-for-additional-busses.patch
spi-spi_bfin-rearrange-portmux-calls.patch
spi-spi_bfin-change-handling-of-communication-parameters.patch
spi-spi_bfin-relocate-spin-waits.patch
spi-spi_bfin-resequence-dma-start-stop.patch
