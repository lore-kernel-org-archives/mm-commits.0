From: akpm@linux-foundation.org
Subject: + mmc-at91_mci-typo.patch added to -mm tree
Date: Tue, 26 Jun 2007 00:06:21 -0700
Message-ID: <200706260706.l5Q76LTi020595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38645 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100AbXFZHGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 03:06:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@rfo.atmel.com, drzeus@drzeus.cx


The patch titled
     mmc: at91_mci typo
has been added to the -mm tree.  Its filename is
     mmc-at91_mci-typo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mmc: at91_mci typo
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>

Typo fix in at91_mci driver : standardized the typo (at91_mci everywhere)

Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/mmc/host/at91_mci.c~mmc-at91_mci-typo drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-at91_mci-typo
+++ a/drivers/mmc/host/at91_mci.c
@@ -131,7 +131,7 @@ struct at91mci_host
 /*
  * Copy from sg to a dma block - used for transfers
  */
-static inline void at91mci_sg_to_dma(struct at91mci_host *host, struct mmc_data *data)
+static inline void at91_mci_sg_to_dma(struct at91mci_host *host, struct mmc_data *data)
 {
 	unsigned int len, i, size;
 	unsigned *dmabuf = host->buffer;
@@ -180,7 +180,7 @@ static inline void at91mci_sg_to_dma(str
 /*
  * Prepare a dma read
  */
-static void at91mci_pre_dma_read(struct at91mci_host *host)
+static void at91_mci_pre_dma_read(struct at91mci_host *host)
 {
 	int i;
 	struct scatterlist *sg;
@@ -248,7 +248,7 @@ static void at91mci_pre_dma_read(struct 
 /*
  * Handle after a dma read
  */
-static void at91mci_post_dma_read(struct at91mci_host *host)
+static void at91_mci_post_dma_read(struct at91mci_host *host)
 {
 	struct mmc_command *cmd;
 	struct mmc_data *data;
@@ -299,7 +299,7 @@ static void at91mci_post_dma_read(struct
 
 	/* Is there another transfer to trigger? */
 	if (host->transfer_index < data->sg_len)
-		at91mci_pre_dma_read(host);
+		at91_mci_pre_dma_read(host);
 	else {
 		at91_mci_write(host, AT91_MCI_IER, AT91_MCI_RXBUFF);
 		at91_mci_write(host, ATMEL_PDC_PTCR, ATMEL_PDC_RXTDIS | ATMEL_PDC_TXTDIS);
@@ -464,7 +464,7 @@ static unsigned int at91_mci_send_comman
 			host->buffer = NULL;
 			host->total_length = 0;
 
-			at91mci_pre_dma_read(host);
+			at91_mci_pre_dma_read(host);
 			ier = AT91_MCI_ENDRX /* | AT91_MCI_RXBUFF */;
 		}
 		else {
@@ -476,7 +476,7 @@ static unsigned int at91_mci_send_comman
 						  host->total_length,
 						  &host->physical_address, GFP_KERNEL);
 
-			at91mci_sg_to_dma(host, data);
+			at91_mci_sg_to_dma(host, data);
 
 			pr_debug("Transmitting %d bytes\n", host->total_length);
 
@@ -506,7 +506,7 @@ static unsigned int at91_mci_send_comman
 /*
  * Wait for a command to complete
  */
-static void at91mci_process_command(struct at91mci_host *host, struct mmc_command *cmd)
+static void at91_mci_process_command(struct at91mci_host *host, struct mmc_command *cmd)
 {
 	unsigned int ier;
 
@@ -521,15 +521,15 @@ static void at91mci_process_command(stru
 /*
  * Process the next step in the request
  */
-static void at91mci_process_next(struct at91mci_host *host)
+static void at91_mci_process_next(struct at91mci_host *host)
 {
 	if (!(host->flags & FL_SENT_COMMAND)) {
 		host->flags |= FL_SENT_COMMAND;
-		at91mci_process_command(host, host->request->cmd);
+		at91_mci_process_command(host, host->request->cmd);
 	}
 	else if ((!(host->flags & FL_SENT_STOP)) && host->request->stop) {
 		host->flags |= FL_SENT_STOP;
-		at91mci_process_command(host, host->request->stop);
+		at91_mci_process_command(host, host->request->stop);
 	}
 	else
 		mmc_request_done(host->mmc, host->request);
@@ -538,7 +538,7 @@ static void at91mci_process_next(struct 
 /*
  * Handle a command that has been completed
  */
-static void at91mci_completed_command(struct at91mci_host *host)
+static void at91_mci_completed_command(struct at91mci_host *host)
 {
 	struct mmc_command *cmd = host->cmd;
 	unsigned int status;
@@ -583,7 +583,7 @@ static void at91mci_completed_command(st
 	else
 		cmd->error = MMC_ERR_NONE;
 
-	at91mci_process_next(host);
+	at91_mci_process_next(host);
 }
 
 /*
@@ -595,7 +595,7 @@ static void at91_mci_request(struct mmc_
 	host->request = mrq;
 	host->flags = 0;
 
-	at91mci_process_next(host);
+	at91_mci_process_next(host);
 }
 
 /*
@@ -708,7 +708,7 @@ static irqreturn_t at91_mci_irq(int irq,
 
 		if (int_status & AT91_MCI_ENDRX) {
 			pr_debug("Receive has ended\n");
-			at91mci_post_dma_read(host);
+			at91_mci_post_dma_read(host);
 		}
 
 		if (int_status & AT91_MCI_NOTBUSY) {
@@ -737,7 +737,7 @@ static irqreturn_t at91_mci_irq(int irq,
 	if (completed) {
 		pr_debug("Completed command\n");
 		at91_mci_write(host, AT91_MCI_IDR, 0xffffffff);
-		at91mci_completed_command(host);
+		at91_mci_completed_command(host);
 	} else
 		at91_mci_write(host, AT91_MCI_IDR, int_status);
 
_

Patches currently in -mm which might be from nicolas.ferre@rfo.atmel.com are

git-arm.patch
mmc-at91_mci-typo.patch
atmel_serial-fix-break-handling.patch
