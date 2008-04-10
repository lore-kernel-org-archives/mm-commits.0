From: akpm@linux-foundation.org
Subject: - spi-spi_bfin5xx-fix-probe-sequencing.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:01:02 -0700
Message-ID: <200804102001.m3AK12mQ014944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759324AbYDJUMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:12:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitja.makarov@gmail.com, cooloney@kernel.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: spi_bfin5xx: fix probe() sequencing
has been removed from the -mm tree.  Its filename was
     spi-spi_bfin5xx-fix-probe-sequencing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: spi_bfin5xx: fix probe() sequencing
From: Vitja Makarov <vitja.makarov@gmail.com>

Fix bug in SPI probe: first initialize peripheral pins, and just after
register spi master device.  This fixes problems with SPI drivers built-in
kernel.

Singed-off-by: Vitja Makarov <vitja.makarov@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin5xx-fix-probe-sequencing drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin5xx-fix-probe-sequencing
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1294,6 +1294,12 @@ static int __init bfin5xx_spi_probe(stru
 		goto out_error_queue_alloc;
 	}
 
+	status = peripheral_request_list(drv_data->pin_req, DRV_NAME);
+	if (status != 0) {
+		dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
+		goto out_error_queue_alloc;
+	}
+
 	/* Register with the SPI framework */
 	platform_set_drvdata(pdev, drv_data);
 	status = spi_register_master(master);
@@ -1302,12 +1308,6 @@ static int __init bfin5xx_spi_probe(stru
 		goto out_error_queue_alloc;
 	}
 
-	status = peripheral_request_list(drv_data->pin_req, DRV_NAME);
-	if (status != 0) {
-		dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
-		goto out_error;
-	}
