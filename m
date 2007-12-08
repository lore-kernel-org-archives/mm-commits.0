From: akpm@linux-foundation.org
Subject: - spi-bfin-spi-uses-portmux-calls.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:29:04 -0800
Message-ID: <200712080129.lB81T4Tb013377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754453AbXLHBjj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:39:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, bryan.wu@analog.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: bfin spi uses portmux calls
has been removed from the -mm tree.  Its filename was
     spi-bfin-spi-uses-portmux-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: bfin spi uses portmux calls
From: Michael Hennerich <michael.hennerich@analog.com>

Use new Blackfin portmux interface, add error handling.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c                 |   28 +++++++++++++++-----
 include/asm-blackfin/mach-bf533/portmux.h |    2 -
 2 files changed, 23 insertions(+), 7 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-bfin-spi-uses-portmux-calls drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-bfin-spi-uses-portmux-calls
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1167,6 +1167,21 @@ static inline int destroy_queue(struct d
 	return 0;
 }
 
+static int setup_pin_mux(int action)
+{
+
+	u16 pin_req[] = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0};
+
+	if (action) {
+		if (peripheral_request_list(pin_req, DRV_NAME))
+			return -EFAULT;
+	} else {
+		peripheral_free_list(pin_req);
+	}
+
+	return 0;
+}
+
 static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1184,12 +1199,9 @@ static int __init bfin5xx_spi_probe(stru
 		return -ENOMEM;
 	}
 
-	if (peripheral_request(P_SPI0_SCK, DRV_NAME) ||
-		 peripheral_request(P_SPI0_MISO, DRV_NAME) ||
-		 peripheral_request(P_SPI0_MOSI, DRV_NAME)) {
-
+	if (setup_pin_mux(1)) {
 		dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
-		goto out_error_queue_alloc;
+		goto out_error;
 	}
 
 	drv_data = spi_master_get_devdata(master);
@@ -1225,9 +1237,11 @@ static int __init bfin5xx_spi_probe(stru
 	dev_dbg(&pdev->dev, "controller probe successfully\n");
 	return status;
 
-      out_error_queue_alloc:
+out_error_queue_alloc:
 	destroy_queue(drv_data);
+out_error:
 	spi_master_put(master);
+
 	return status;
 }
 
@@ -1257,6 +1271,8 @@ static int __devexit bfin5xx_spi_remove(
 	/* Disconnect from the SPI framework */
 	spi_unregister_master(drv_data->master);
 
+	setup_pin_mux(0);
+
 	/* Prevent double remove */
 	platform_set_drvdata(pdev, NULL);
 
diff -puN include/asm-blackfin/mach-bf533/portmux.h~spi-bfin-spi-uses-portmux-calls include/asm-blackfin/mach-bf533/portmux.h
--- a/include/asm-blackfin/mach-bf533/portmux.h~spi-bfin-spi-uses-portmux-calls
+++ a/include/asm-blackfin/mach-bf533/portmux.h
@@ -42,7 +42,7 @@
 #define P_SPORT0_DRPRI	(P_DONTCARE)
 
 #define P_SPI0_MOSI	(P_DONTCARE)
-#define P_SPI0_MIS0	(P_DONTCARE)
+#define P_SPI0_MISO	(P_DONTCARE)
 #define P_SPI0_SCK	(P_DONTCARE)
 #define P_SPI0_SSEL7	(P_DEFINED | P_IDENT(GPIO_PF7))
 #define P_SPI0_SSEL6	(P_DEFINED | P_IDENT(GPIO_PF6))
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

origin.patch
git-mtd.patch
