From: akpm@linux-foundation.org
Subject: - blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:29:49 -0800
Message-ID: <200712080129.lB81TnD0013428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35031 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159AbXLHBj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:39:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI driver:  move hard coded pin_req to board file
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
