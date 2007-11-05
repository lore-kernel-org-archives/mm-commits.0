From: akpm@linux-foundation.org
Subject: + blackfin-spi-driver-use-void-__iomem-for-regs_base.patch added to -mm tree
Date: Mon, 05 Nov 2007 15:49:59 -0800
Message-ID: <200711052349.lA5Nnxl8025992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53731 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbXKEXu2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:50:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, david-b@pacbell.net


The patch titled
     Blackfin SPI driver: use void __iomem * for regs_base
has been added to the -mm tree.  Its filename is
     blackfin-spi-driver-use-void-__iomem-for-regs_base.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin SPI driver: use void __iomem * for regs_base
From: Bryan Wu <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-use-void-__iomem-for-regs_base drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-use-void-__iomem-for-regs_base
+++ a/drivers/spi/spi_bfin5xx.c
@@ -78,7 +78,7 @@ struct driver_data {
 	struct spi_master *master;
 
 	/* Regs base of SPI controller */
-	u32 regs_base;
+	void __iomem *regs_base;
 
 	/* BFIN hookup */
 	struct bfin5xx_spi_master *master_info;
@@ -1311,9 +1311,8 @@ static int __init bfin5xx_spi_probe(stru
 		goto out_error_get_res;
 	}
 
-	drv_data->regs_base = (u32) ioremap(res->start,
-					(res->end - res->start + 1));
-	if (!drv_data->regs_base) {
+	drv_data->regs_base = ioremap(res->start, (res->end - res->start + 1));
+	if (drv_data->regs_base == NULL) {
 		dev_err(dev, "Cannot map IO\n");
 		status = -ENXIO;
 		goto out_error_ioremap;
@@ -1352,7 +1351,7 @@ static int __init bfin5xx_spi_probe(stru
 		goto out_error;
 	}
 
-	dev_info(dev, "%s, Version %s, regs_base@0x%08x, dma channel@%d\n",
+	dev_info(dev, "%s, Version %s, regs_base@%p, dma channel@%d\n",
 		DRV_DESC, DRV_VERSION, drv_data->regs_base,
 		drv_data->dma_channel);
 	return status;
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
