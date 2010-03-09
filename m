From: akpm@linux-foundation.org
Subject: [merged] mmc-at91_mci-use-dma-buffer-for-read.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:40 -0800
Message-ID: <201003091908.o29J8eRv031460__45554.264370776$1268162567$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633Ab0CITWX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wolfgang.mues@auerswald.de, avictor.za@gmail.com, linux-mmc@vger.kernel.org, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     mmc: at91_mci: use DMA buffer for read
has been removed from the -mm tree.  Its filename was
     mmc-at91_mci-use-dma-buffer-for-read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: at91_mci: use DMA buffer for read
From: Wolfgang Muees <wolfgang.mues@auerswald.de>

Convert the read to use the DMA buffer as well.  The old code was doing
double-buffering DMA with the PDC; no way to make it work.  Replace it
with a single-PDC approach.  It also simplify things removing the need for
a pre_dma_read() function.

[nicolas.ferre@atmel.com coding style modifications]
Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |  128 ++++++++--------------------------
 1 file changed, 32 insertions(+), 96 deletions(-)

diff -puN drivers/mmc/host/at91_mci.c~mmc-at91_mci-use-dma-buffer-for-read drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-at91_mci-use-dma-buffer-for-read
+++ a/drivers/mmc/host/at91_mci.c
@@ -251,80 +251,14 @@ static inline void at91_mci_sg_to_dma(st
 }
 
 /*
- * Prepare a dma read
- */
-static void at91_mci_pre_dma_read(struct at91mci_host *host)
-{
-	int i;
-	struct scatterlist *sg;
-	struct mmc_command *cmd;
-	struct mmc_data *data;
-
-	pr_debug("pre dma read\n");
-
-	cmd = host->cmd;
-	if (!cmd) {
-		pr_debug("no command\n");
-		return;
-	}
-
-	data = cmd->data;
-	if (!data) {
-		pr_debug("no data\n");
-		return;
-	}
-
-	for (i = 0; i < 2; i++) {
-		/* nothing left to transfer */
-		if (host->transfer_index >= data->sg_len) {
-			pr_debug("Nothing left to transfer (index = %d)\n", host->transfer_index);
-			break;
-		}
-
-		/* Check to see if this needs filling */
-		if (i == 0) {
-			if (at91_mci_read(host, ATMEL_PDC_RCR) != 0) {
-				pr_debug("Transfer active in current\n");
-				continue;
-			}
-		}
-		else {
-			if (at91_mci_read(host, ATMEL_PDC_RNCR) != 0) {
-				pr_debug("Transfer active in next\n");
-				continue;
-			}
-		}
-
-		/* Setup the next transfer */
-		pr_debug("Using transfer index %d\n", host->transfer_index);
-
-		sg = &data->sg[host->transfer_index++];
-		pr_debug("sg = %p\n", sg);
-
-		sg->dma_address = dma_map_page(NULL, sg_page(sg), sg->offset, sg->length, DMA_FROM_DEVICE);
-
-		pr_debug("dma address = %08X, length = %d\n", sg->dma_address, sg->length);
-
-		if (i == 0) {
-			at91_mci_write(host, ATMEL_PDC_RPR, sg->dma_address);
-			at91_mci_write(host, ATMEL_PDC_RCR, (data->blksz & 0x3) ? sg->length : sg->length / 4);
-		}
-		else {
-			at91_mci_write(host, ATMEL_PDC_RNPR, sg->dma_address);
-			at91_mci_write(host, ATMEL_PDC_RNCR, (data->blksz & 0x3) ? sg->length : sg->length / 4);
-		}
-	}
-
-	pr_debug("pre dma read done\n");
-}
-
-/*
  * Handle after a dma read
  */
 static void at91_mci_post_dma_read(struct at91mci_host *host)
 {
 	struct mmc_command *cmd;
 	struct mmc_data *data;
+	unsigned int len, i, size;
+	unsigned *dmabuf = host->buffer;
 
 	pr_debug("post dma read\n");
 
@@ -340,42 +274,39 @@ static void at91_mci_post_dma_read(struc
 		return;
 	}
 
-	while (host->in_use_index < host->transfer_index) {
-		struct scatterlist *sg;
+	size = data->blksz * data->blocks;
+	len = data->sg_len;
 
-		pr_debug("finishing index %d\n", host->in_use_index);
+	at91_mci_write(host, AT91_MCI_IDR, AT91_MCI_ENDRX);
+	at91_mci_write(host, AT91_MCI_IER, AT91_MCI_RXBUFF);
 
-		sg = &data->sg[host->in_use_index++];
+	for (i = 0; i < len; i++) {
+		struct scatterlist *sg;
+		int amount;
+		unsigned int *sgbuffer;
 
-		pr_debug("Unmapping page %08X\n", sg->dma_address);
+		sg = &data->sg[i];
 
-		dma_unmap_page(NULL, sg->dma_address, sg->length, DMA_FROM_DEVICE);
+		sgbuffer = kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
+		amount = min(size, sg->length);
+		size -= amount;
 
 		if (cpu_is_at91rm9200()) {	/* AT91RM9200 errata */
-			unsigned int *buffer;
 			int index;
-
-			/* Swap the contents of the buffer */
-			buffer = kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
-			pr_debug("buffer = %p, length = %d\n", buffer, sg->length);
-
-			for (index = 0; index < (sg->length / 4); index++)
-				buffer[index] = swab32(buffer[index]);
-
-			kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
+			for (index = 0; index < (amount / 4); index++)
+				sgbuffer[index] = swab32(*dmabuf++);
+		} else {
+			char *tmpv = (char *)dmabuf;
+			memcpy(sgbuffer, tmpv, amount);
+			tmpv += amount;
+			dmabuf = (unsigned *)tmpv;
 		}
 
-		flush_dcache_page(sg_page(sg));
-
-		data->bytes_xfered += sg->length;
-	}
-
-	/* Is there another transfer to trigger? */
-	if (host->transfer_index < data->sg_len)
-		at91_mci_pre_dma_read(host);
-	else {
-		at91_mci_write(host, AT91_MCI_IDR, AT91_MCI_ENDRX);
-		at91_mci_write(host, AT91_MCI_IER, AT91_MCI_RXBUFF);
+		kunmap_atomic(((void *)sgbuffer)-sg->offset, KM_BIO_SRC_IRQ);
+		dmac_flush_range((void *)sgbuffer, ((void *)sgbuffer) + amount);
+		data->bytes_xfered += amount;
+		if (size == 0)
+			break;
 	}
 
 	pr_debug("post dma read done\n");
@@ -610,7 +541,12 @@ static void at91_mci_send_command(struct
 				 */
 				host->total_length = 0;
 
-				at91_mci_pre_dma_read(host);
+				at91_mci_write(host, ATMEL_PDC_RPR, host->physical_address);
+				at91_mci_write(host, ATMEL_PDC_RCR, (data->blksz & 0x3) ?
+					(blocks * block_length) : (blocks * block_length) / 4);
+				at91_mci_write(host, ATMEL_PDC_RNPR, 0);
+				at91_mci_write(host, ATMEL_PDC_RNCR, 0);
+
 				ier = AT91_MCI_ENDRX /* | AT91_MCI_RXBUFF */;
 			}
 			else {
_

Patches currently in -mm which might be from wolfgang.mues@auerswald.de are


