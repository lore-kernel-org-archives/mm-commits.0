From: akpm@linux-foundation.org
Subject: [merged] mmc-atmel-mci-prevent-kernel-oops-while-removing-card.patch removed from -mm tree
Date: Wed, 12 May 2010 10:58:14 -0400
Message-ID: <201005121759.o4CHxgdS011526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752Ab0ELSDR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:03:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, hskinnemoen@atmel.com, linux-mmc@vger.kernel.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc: atmel-mci: prevent kernel oops while removing card
has been removed from the -mm tree.  Its filename was
     mmc-atmel-mci-prevent-kernel-oops-while-removing-card.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: atmel-mci: prevent kernel oops while removing card
From: Nicolas Ferre <nicolas.ferre@atmel.com>

The removing of an SD card in certain circumstances can lead to a kernel
oops if we do not make sure that the "data" field of the host structure is
valid.  This patch adds a test in atmci_dma_cleanup() function and also
calls atmci_stop_dma() before throwing away the reference to data.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: <linux-mmc@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/atmel-mci.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-prevent-kernel-oops-while-removing-card drivers/mmc/host/atmel-mci.c
--- a/drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-prevent-kernel-oops-while-removing-card
+++ a/drivers/mmc/host/atmel-mci.c
@@ -569,9 +569,10 @@ static void atmci_dma_cleanup(struct atm
 {
 	struct mmc_data			*data = host->data;
 
-	dma_unmap_sg(&host->pdev->dev, data->sg, data->sg_len,
-		     ((data->flags & MMC_DATA_WRITE)
-		      ? DMA_TO_DEVICE : DMA_FROM_DEVICE));
+	if (data)
+		dma_unmap_sg(&host->pdev->dev, data->sg, data->sg_len,
+			     ((data->flags & MMC_DATA_WRITE)
+			      ? DMA_TO_DEVICE : DMA_FROM_DEVICE));
 }
 
 static void atmci_stop_dma(struct atmel_mci *host)
@@ -1099,8 +1100,8 @@ static void atmci_command_complete(struc
 			"command error: status=0x%08x\n", status);
 
 		if (cmd->data) {
-			host->data = NULL;
 			atmci_stop_dma(host);
+			host->data = NULL;
 			mci_writel(host, IDR, MCI_NOTBUSY
 					| MCI_TXRDY | MCI_RXRDY
 					| ATMCI_DATA_ERROR_FLAGS);
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

origin.patch
linux-next.patch
mmc-atmel-mci-enable-sd-high-speed-support.patch
mmc-atmel-mci-add-support-for-sdio-interrupts.patch

