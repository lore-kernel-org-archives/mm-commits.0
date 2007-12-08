From: akpm@linux-foundation.org
Subject: - blackfin-spi-driver-use-void-__iomem-for-regs_base.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:29:46 -0800
Message-ID: <200712080129.lB81TkXb013425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113AbXLHBjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:39:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI driver: use void __iomem * for regs_base
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-use-void-__iomem-for-regs_base.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
