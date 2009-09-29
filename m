From: akpm@linux-foundation.org
Subject: + s3cmci-dma-fixes.patch added to -mm tree
Date: Tue, 29 Sep 2009 15:57:20 -0700
Message-ID: <200909292257.n8TMvKGv026013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802AbZI2W5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 18:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, linux-mmc@vger.kernel.org


The patch titled
     s3cmci: DMA fixes
has been added to the -mm tree.  Its filename is
     s3cmci-dma-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3cmci: DMA fixes
From: Ben Dooks <ben@simtec.co.uk>

Fixes for the DMA transfer mode of the driver to try and improve the state
of the code:

- Ensure that dma_complete is set during the end of the command phase
  so that transfers do not stall awaiting the completion

- Update the DMA debugging to provide a bit more useful information
  such as how many DMA descriptors where not processed and print the
  DMA addresses in hexadecimal.

- Fix the DMA channel request code to actually request DMA for the
  S3CMCI block instead of whatever '0' signified.

- Add fallback to PIO if we cannot get the DMA channel, as many of the
  devices with this block only have a limited number of DMA channels.

- Only try and claim and free the DMA channel if we are trying to use it.

This improves the driver DMA code to the point where it can now identify a
card and read the partition table.  However the DMA can still stall when
trying to move data between the host and memory.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |   62 +++++++++++++++++++++++++++---------
 drivers/mmc/host/s3cmci.h |    3 -
 2 files changed, 47 insertions(+), 18 deletions(-)

diff -puN drivers/mmc/host/s3cmci.c~s3cmci-dma-fixes drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~s3cmci-dma-fixes
+++ a/drivers/mmc/host/s3cmci.c
@@ -183,6 +183,21 @@ static inline bool s3cmci_host_usedma(st
 #endif
 }
 
+/**
+ * s3cmci_host_canpio - return true if host has pio code available
+ *
+ * Return true if the driver has been compiled with the PIO support code
+ * available.
+ */
+static inline bool s3cmci_host_canpio(void)
+{
+#ifdef CONFIG_MMC_S3C_PIO
+	return true;
+#else
+	return false;
+#endif
+}
+
 static inline u32 enable_imask(struct s3cmci_host *host, u32 imask)
 {
 	u32 newmask;
@@ -786,6 +801,7 @@ static void s3cmci_dma_done_callback(str
 	dbg(host, dbg_dma, "DMA FINISHED Size:%i DSTA:%08x DCNT:%08x\n",
 		size, mci_dsta, mci_dcnt);
 
+	host->dma_complete = 1;
 	host->complete_what = COMPLETION_FINALIZE;
 
 out:
@@ -816,7 +832,8 @@ static void finalize_request(struct s3cm
 	if (cmd->data && (cmd->error == 0) &&
 	    (cmd->data->error == 0)) {
 		if (s3cmci_host_usedma(host) && (!host->dma_complete)) {
-			dbg(host, dbg_dma, "DMA Missing!\n");
+			dbg(host, dbg_dma, "DMA Missing (%d)!\n",
+			    host->dma_complete);
 			return;
 		}
 	}
@@ -1065,7 +1082,7 @@ static int s3cmci_prepare_pio(struct s3c
 static int s3cmci_prepare_dma(struct s3cmci_host *host, struct mmc_data *data)
 {
 	int dma_len, i;
-	int rw = (data->flags & MMC_DATA_WRITE) ? 1 : 0;
+	int rw = data->flags & MMC_DATA_WRITE;
 
 	BUG_ON((data->flags & BOTH_DIR) == BOTH_DIR);
 
@@ -1073,7 +1090,7 @@ static int s3cmci_prepare_dma(struct s3c
 	s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_FLUSH);
 
 	dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
-			     (rw) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+			     rw ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 
 	if (dma_len == 0)
 		return -ENOMEM;
@@ -1084,11 +1101,11 @@ static int s3cmci_prepare_dma(struct s3c
 	for (i = 0; i < dma_len; i++) {
 		int res;
 
-		dbg(host, dbg_dma, "enqueue %i:%u@%u\n", i,
-			sg_dma_address(&data->sg[i]),
-			sg_dma_len(&data->sg[i]));
+		dbg(host, dbg_dma, "enqueue %i: %08x@%u\n", i,
+		    sg_dma_address(&data->sg[i]),
+		    sg_dma_len(&data->sg[i]));
 
-		res = s3c2410_dma_enqueue(host->dma, (void *) host,
+		res = s3c2410_dma_enqueue(host->dma, host,
 					  sg_dma_address(&data->sg[i]),
 					  sg_dma_len(&data->sg[i]));
 
@@ -1581,8 +1598,6 @@ static int __devinit s3cmci_probe(struct
 	host->complete_what 	= COMPLETION_NONE;
 	host->pio_active 	= XFER_NONE;
 
-	host->dma		= S3CMCI_DMA;
-
 #ifdef CONFIG_MMC_S3C_PIODMA
 	host->dodma		= host->pdata->dma;
 #endif
@@ -1665,10 +1680,21 @@ static int __devinit s3cmci_probe(struct
 		gpio_direction_input(host->pdata->gpio_wprotect);
 	}
 
-	if (s3c2410_dma_request(S3CMCI_DMA, &s3cmci_dma_client, NULL) < 0) {
-		dev_err(&pdev->dev, "unable to get DMA channel.\n");
-		ret = -EBUSY;
-		goto probe_free_gpio_wp;
+	/* depending on the dma state, get a dma channel to use. */
+
+	if (s3cmci_host_usedma(host)) {
+		host->dma = s3c2410_dma_request(DMACH_SDI, &s3cmci_dma_client,
+						host);
+		if (host->dma < 0) {
+			dev_err(&pdev->dev, "cannot get DMA channel.\n");
+			if (!s3cmci_host_canpio()) {
+				ret = -EBUSY;
+				goto probe_free_gpio_wp;
+			} else {
+				dev_warn(&pdev->dev, "falling back to PIO.\n");
+				host->dodma = 0;
+			}
+		}
 	}
 
 	host->clk = clk_get(&pdev->dev, "sdi");
@@ -1676,7 +1702,7 @@ static int __devinit s3cmci_probe(struct
 		dev_err(&pdev->dev, "failed to find clock source.\n");
 		ret = PTR_ERR(host->clk);
 		host->clk = NULL;
-		goto probe_free_host;
+		goto probe_free_dma;
 	}
 
 	ret = clk_enable(host->clk);
@@ -1738,6 +1764,10 @@ static int __devinit s3cmci_probe(struct
  clk_free:
 	clk_put(host->clk);
 
+ probe_free_dma:
+	if (s3cmci_host_usedma(host))
+		s3c2410_dma_free(host->dma, &s3cmci_dma_client);
+
  probe_free_gpio_wp:
 	if (host->pdata->gpio_wprotect)
 		gpio_free(host->pdata->gpio_wprotect);
@@ -1796,7 +1826,9 @@ static int __devexit s3cmci_remove(struc
 	clk_put(host->clk);
 
 	tasklet_disable(&host->pio_tasklet);
-	s3c2410_dma_free(S3CMCI_DMA, &s3cmci_dma_client);
+
+	if (s3cmci_host_usedma(host))
+		s3c2410_dma_free(host->dma, &s3cmci_dma_client);
 
 	free_irq(host->irq, host);
 
diff -puN drivers/mmc/host/s3cmci.h~s3cmci-dma-fixes drivers/mmc/host/s3cmci.h
--- a/drivers/mmc/host/s3cmci.h~s3cmci-dma-fixes
+++ a/drivers/mmc/host/s3cmci.h
@@ -8,9 +8,6 @@
  * published by the Free Software Foundation.
  */
 
-/* FIXME: DMA Resource management ?! */
-#define S3CMCI_DMA 0
