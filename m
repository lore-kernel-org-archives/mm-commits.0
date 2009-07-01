From: akpm@linux-foundation.org
Subject: + msm_sdccc-move-overly-indented-code-to-separate-function.patch added to -mm tree
Date: Wed, 01 Jul 2009 15:52:01 -0700
Message-ID: <200907012252.n61Mq1NN003684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751AbZGAWxL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 18:53:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, drzeus-list@drzeus.cx, pavel@ucw.cz, san@android.com, swetland@google.com


The patch titled
     msm_sdcc.c: move overly indented code to separate function
has been added to the -mm tree.  Its filename is
     msm_sdccc-move-overly-indented-code-to-separate-function.patch

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
Subject: msm_sdcc.c: move overly indented code to separate function
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: San Mehat <san@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/msm_sdcc.c |  132 ++++++++++++++++------------------
 1 file changed, 63 insertions(+), 69 deletions(-)

diff -puN drivers/mmc/host/msm_sdcc.c~msm_sdccc-move-overly-indented-code-to-separate-function drivers/mmc/host/msm_sdcc.c
--- a/drivers/mmc/host/msm_sdcc.c~msm_sdccc-move-overly-indented-code-to-separate-function
+++ a/drivers/mmc/host/msm_sdcc.c
@@ -584,6 +584,67 @@ static void msmsdcc_do_cmdirq(struct msm
 		msmsdcc_start_data(host, cmd->data);
 }
 
+static void
+msmsdcc_handle_irq_data(struct msmsdcc_host *host, u32 status,
+			void __iomem *base)
+{
+	struct mmc_data *data = host->curr.data;
+
+	if (!data)
+		return;
+
+	/* Check for data errors */
+	if (status & (MCI_DATACRCFAIL | MCI_DATATIMEOUT |
+		      MCI_TXUNDERRUN | MCI_RXOVERRUN)) {
+		msmsdcc_data_err(host, data, status);
+		host->curr.data_xfered = 0;
+		if (host->dma.sg)
+			msm_dmov_stop_cmd(host->dma.channel,
+					  &host->dma.hdr, 0);
+		else {
+			msmsdcc_stop_data(host);
+			if (!data->stop)
+				msmsdcc_request_end(host, data->mrq);
+			else
+				msmsdcc_start_command(host, data->stop, 0);
+		}
+	}
+
+	/* Check for data done */
+	if (!host->curr.got_dataend && (status & MCI_DATAEND))
+		host->curr.got_dataend = 1;
+
+	if (!host->curr.got_datablkend && (status & MCI_DATABLOCKEND))
+		host->curr.got_datablkend = 1;
+
+	/*
+	 * If DMA is still in progress, we complete via the completion handler
+	 */
+	if (host->curr.got_dataend && host->curr.got_datablkend &&
+	    !host->dma.busy) {
+		/*
+		 * There appears to be an issue in the controller where
+		 * if you request a small block transfer (< fifo size),
+		 * you may get your DATAEND/DATABLKEND irq without the
+		 * PIO data irq.
+		 *
+		 * Check to see if there is still data to be read,
+		 * and simulate a PIO irq.
+		 */
+		if (readl(base + MMCISTATUS) & MCI_RXDATAAVLBL)
+			msmsdcc_pio_irq(1, host);
+
+		msmsdcc_stop_data(host);
+		if (!data->error)
+			host->curr.data_xfered = host->curr.xfer_size;
+
+		if (!data->stop)
+			msmsdcc_request_end(host, data->mrq);
+		else
+			msmsdcc_start_command(host, data->stop, 0);
+	}
+}
+
 static irqreturn_t
 msmsdcc_irq(int irq, void *dev_id)
 {
@@ -596,79 +657,12 @@ msmsdcc_irq(int irq, void *dev_id)
 	spin_lock(&host->lock);
 
 	do {
-		struct mmc_data *data;
 		status = readl(base + MMCISTATUS);
 
-		status &= (readl(base + MMCIMASK0) |
-					      MCI_DATABLOCKENDMASK);
+		status &= (readl(base + MMCIMASK0) | MCI_DATABLOCKENDMASK);
 		writel(status, base + MMCICLEAR);
 
-		data = host->curr.data;
-		if (data) {
-			/* Check for data errors */
-			if (status & (MCI_DATACRCFAIL|MCI_DATATIMEOUT|
-				      MCI_TXUNDERRUN|MCI_RXOVERRUN)) {
-				msmsdcc_data_err(host, data, status);
-				host->curr.data_xfered = 0;
-				if (host->dma.sg)
-					msm_dmov_stop_cmd(host->dma.channel,
-							  &host->dma.hdr, 0);
-				else {
-					msmsdcc_stop_data(host);
-					if (!data->stop)
-						msmsdcc_request_end(host,
-								    data->mrq);
-					else
-						msmsdcc_start_command(host,
-								     data->stop,
-								     0);
-				}
-			}
-
-			/* Check for data done */
-			if (!host->curr.got_dataend && (status & MCI_DATAEND))
-				host->curr.got_dataend = 1;
-
-			if (!host->curr.got_datablkend &&
-			    (status & MCI_DATABLOCKEND)) {
-				host->curr.got_datablkend = 1;
-			}
-
-			if (host->curr.got_dataend &&
-			    host->curr.got_datablkend) {
-				/*
-				 * If DMA is still in progress, we complete
-				 * via the completion handler
-				 */
-				if (!host->dma.busy) {
-					/*
-					 * There appears to be an issue in the
-					 * controller where if you request a
-					 * small block transfer (< fifo size),
-					 * you may get your DATAEND/DATABLKEND
-					 * irq without the PIO data irq.
-					 *
-					 * Check to see if theres still data
-					 * to be read, and simulate a PIO irq.
-					 */
-					if (readl(base + MMCISTATUS) &
-							       MCI_RXDATAAVLBL)
-						msmsdcc_pio_irq(1, host);
-
-					msmsdcc_stop_data(host);
-					if (!data->error)
-						host->curr.data_xfered =
-							host->curr.xfer_size;
