From: akpm@linux-foundation.org
Subject: - spi-use-simplified-spi_sync-calling-convention.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:28:58 -0800
Message-ID: <200712080128.lB81SwJP013365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40503 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911AbXLHB3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:29:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marc.pignat@hevs.ch, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: use simplified spi_sync() calling convention
has been removed from the -mm tree.  Its filename was
     spi-use-simplified-spi_sync-calling-convention.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: use simplified spi_sync() calling convention
From: Marc Pignat <marc.pignat@hevs.ch>

Given the patch which simplifies the spi_sync calling convention, this one
updates the callers of that routine which tried using it according to the
previous specification.  (Most didn't.)

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ads7846.c |   13 ++++++-------
 drivers/mmc/host/mmc_spi.c          |   10 ----------
 drivers/rtc/rtc-max6902.c           |   12 +++---------
 3 files changed, 9 insertions(+), 26 deletions(-)

diff -puN drivers/input/touchscreen/ads7846.c~spi-use-simplified-spi_sync-calling-convention drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~spi-use-simplified-spi_sync-calling-convention
+++ a/drivers/input/touchscreen/ads7846.c
@@ -267,13 +267,12 @@ static int ads7846_read12_ser(struct dev
 	ts->irq_disabled = 0;
 	enable_irq(spi->irq);
 
-	if (req->msg.status)
-		status = req->msg.status;
-
-	/* on-wire is a must-ignore bit, a BE12 value, then padding */
-	sample = be16_to_cpu(req->sample);
-	sample = sample >> 3;
-	sample &= 0x0fff;
+	if (status == 0) {
+		/* on-wire is a must-ignore bit, a BE12 value, then padding */
+		sample = be16_to_cpu(req->sample);
+		sample = sample >> 3;
+		sample &= 0x0fff;
+	}
 
 	kfree(req);
 	return status ? status : sample;
diff -puN drivers/mmc/host/mmc_spi.c~spi-use-simplified-spi_sync-calling-convention drivers/mmc/host/mmc_spi.c
--- a/drivers/mmc/host/mmc_spi.c~spi-use-simplified-spi_sync-calling-convention
+++ a/drivers/mmc/host/mmc_spi.c
@@ -176,8 +176,6 @@ mmc_spi_readbytes(struct mmc_spi_host *h
 				DMA_FROM_DEVICE);
 
 	status = spi_sync(host->spi, &host->readback);
-	if (status == 0)
-		status = host->readback.status;
 
 	if (host->dma_dev)
 		dma_sync_single_for_cpu(host->dma_dev,
@@ -480,8 +478,6 @@ mmc_spi_command_send(struct mmc_spi_host
 				DMA_BIDIRECTIONAL);
 	}
 	status = spi_sync(host->spi, &host->m);
-	if (status == 0)
-		status = host->m.status;
 
 	if (host->dma_dev)
 		dma_sync_single_for_cpu(host->dma_dev,
@@ -624,8 +620,6 @@ mmc_spi_writeblock(struct mmc_spi_host *
 				DMA_BIDIRECTIONAL);
 
 	status = spi_sync(spi, &host->m);
-	if (status == 0)
-		status = host->m.status;
 
 	if (status != 0) {
 		dev_dbg(&spi->dev, "write error (%d)\n", status);
@@ -726,8 +720,6 @@ mmc_spi_readblock(struct mmc_spi_host *h
 		}
 
 		status = spi_sync(spi, &host->m);
-		if (status == 0)
-			status = host->m.status;
 
 		if (host->dma_dev) {
 			dma_sync_single_for_cpu(host->dma_dev,
@@ -905,8 +897,6 @@ mmc_spi_data_do(struct mmc_spi_host *hos
 					DMA_BIDIRECTIONAL);
 
 		tmp = spi_sync(spi, &host->m);
-		if (tmp == 0)
-			tmp = host->m.status;
 
 		if (host->dma_dev)
 			dma_sync_single_for_cpu(host->dma_dev,
diff -puN drivers/rtc/rtc-max6902.c~spi-use-simplified-spi_sync-calling-convention drivers/rtc/rtc-max6902.c
--- a/drivers/rtc/rtc-max6902.c~spi-use-simplified-spi_sync-calling-convention
+++ a/drivers/rtc/rtc-max6902.c
@@ -89,13 +89,9 @@ static int max6902_get_reg(struct device
 
 	/* do the i/o */
 	status = spi_sync(spi, &message);
-	if (status == 0)
-		status = message.status;
-	else
-		return status;
-
-	*data = chip->rx_buf[1];
 
+	if (status == 0)
+		*data = chip->rx_buf[1];
 	return status;
 }
 
@@ -125,9 +121,7 @@ static int max6902_get_datetime(struct d
 
 	/* do the i/o */
 	status = spi_sync(spi, &message);
-	if (status == 0)
-		status = message.status;
-	else
+	if (status)
 		return status;
 
 	/* The chip sends data in this order:
_

Patches currently in -mm which might be from marc.pignat@hevs.ch are

origin.patch
