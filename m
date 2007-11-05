From: akpm@linux-foundation.org
Subject: + blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch added to -mm tree
Date: Mon, 05 Nov 2007 15:50:01 -0800
Message-ID: <200711052350.lA5No2OX025998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754174AbXKEXuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:50:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, david-b@pacbell.net


The patch titled
     Blackfin SPI driver:  move hard coded pin_req to board file
has been added to the -mm tree.  Its filename is
     blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin SPI driver:  move hard coded pin_req to board file
From: Bryan Wu <bryan.wu@analog.com>

Remove some sort of bloaty code, try to get these pin_req arrays built at compile-time

 - move this static things to the blackfin board file
 - add pin_req array to struct bfin5xx_spi_master
 - tested on BF537/BF548 with SPI flash

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c          |   28 ++++++---------------------
 include/asm-blackfin/bfin5xx_spi.h |    1 
 2 files changed, 8 insertions(+), 21 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-move-hard-coded-pin_req-to-board-file drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-move-hard-coded-pin_req-to-board-file
+++ a/drivers/spi/spi_bfin5xx.c
@@ -80,6 +80,9 @@ struct driver_data {
 	/* Regs base of SPI controller */
 	void __iomem *regs_base;
 
+	/* Pin request list */
+	u16 *pin_req;
+
 	/* BFIN hookup */
 	struct bfin5xx_spi_master *master_info;
 
@@ -1255,25 +1258,6 @@ static inline int destroy_queue(struct d
 	return 0;
 }
 
-static int setup_pin_mux(int action, int bus_num)
-{
-
-	u16 pin_req[3][4] = {
-		{P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
-		{P_SPI1_SCK, P_SPI1_MISO, P_SPI1_MOSI, 0},
-		{P_SPI2_SCK, P_SPI2_MISO, P_SPI2_MOSI, 0},
-	};
-
-	if (action) {
-		if (peripheral_request_list(pin_req[bus_num], DRV_NAME))
-			return -EFAULT;
-	} else {
-		peripheral_free_list(pin_req[bus_num]);
-	}
-
-	return 0;
-}
-
 static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1296,6 +1280,7 @@ static int __init bfin5xx_spi_probe(stru
 	drv_data->master = master;
 	drv_data->master_info = platform_info;
 	drv_data->pdev = pdev;
+	drv_data->pin_req = platform_info->pin_req;
 
 	master->bus_num = pdev->id;
 	master->num_chipselect = platform_info->num_chipselect;
@@ -1346,7 +1331,8 @@ static int __init bfin5xx_spi_probe(stru
 		goto out_error_queue_alloc;
 	}
 
-	if (setup_pin_mux(1, master->bus_num)) {
+	status = peripheral_request_list(drv_data->pin_req, DRV_NAME);
+	if (status != 0) {
 		dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
 		goto out_error;
 	}
@@ -1394,7 +1380,7 @@ static int __devexit bfin5xx_spi_remove(
 	/* Disconnect from the SPI framework */
 	spi_unregister_master(drv_data->master);
 
-	setup_pin_mux(0, drv_data->master->bus_num);
+	peripheral_free_list(drv_data->pin_req);
 
 	/* Prevent double remove */
 	platform_set_drvdata(pdev, NULL);
diff -puN include/asm-blackfin/bfin5xx_spi.h~blackfin-spi-driver-move-hard-coded-pin_req-to-board-file include/asm-blackfin/bfin5xx_spi.h
--- a/include/asm-blackfin/bfin5xx_spi.h~blackfin-spi-driver-move-hard-coded-pin_req-to-board-file
+++ a/include/asm-blackfin/bfin5xx_spi.h
@@ -152,6 +152,7 @@
 struct bfin5xx_spi_master {
 	u16 num_chipselect;
 	u8 enable_dma;
+	u16 pin_req[4];
 };
 
 /* spi_board_info.controller_data for SPI slave devices,
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
git-mtd.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch
kernel-printkc-concerns-about-the-console-handover.patch
remove-mm_ptovvtop.patch
spi-initial-bf54x-spi-support.patch
spi-bfin-spi-uses-portmux-calls.patch
spi-spi_bfin-cleanups-error-handling.patch
spi-spi_bfin-handles-spi_transfercs_change.patch
spi-spi_bfin-dont-bypass-spi-framework.patch
spi-spi_bfin-uses-platform-device-resources.patch
spi-spi_bfin-uses-portmux-for-additional-busses.patch
spi-spi_bfin-rearrange-portmux-calls.patch
spi-spi_bfin-change-handling-of-communication-parameters.patch
spi-spi_bfin-relocate-spin-waits.patch
spi-spi_bfin-handle-multiple-spi_masters.patch
spi-spi_bfin-bugfix-for-816-bit-word-sizes.patch
spi-spi_bfin-update-handling-of-delay-after-deselect.patch
spi-spi_bfin-resequence-dma-start-stop.patch
blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch
blackfin-spi-driver-use-void-__iomem-for-regs_base.patch
blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch
blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
d_path-make-d_path-use-a-struct-path.patch
