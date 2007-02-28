From: akpm@linux-foundation.org
Subject: - sata_nv-kill-old-private-bmdma-helper-functions.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:52:03 -0800
Message-ID: <200702282352.l1SNq3dB030961@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48186 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932572AbXB1XwF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hancockr@shaw.ca, mm-commits@vger.kernel.org


The patch titled
     sata_nv: kill old private BMDMA helper functions
has been removed from the -mm tree.  Its filename was
     sata_nv-kill-old-private-bmdma-helper-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_nv: kill old private BMDMA helper functions
From: Robert Hancock <hancockr@shaw.ca>

sata_nv implemented its own copies of the BMDMA helper functions for ADMA,
since the ADMA BMDMA status registers are PIO while the other registers are
MMIO, and this was the only way to handle this previously.  Now that we
have iomap support, the standard routines should just work, so use them. 
The only thing we need to override as far as ADMA and BMDMA is the
post_internal_cmd callback, where we should only call ata_post_internal_cmd
if we are in port-register mode.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |   84 ++++------------------------------------
 1 files changed, 10 insertions(+), 74 deletions(-)

diff -puN drivers/ata/sata_nv.c~sata_nv-kill-old-private-bmdma-helper-functions drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-kill-old-private-bmdma-helper-functions
+++ a/drivers/ata/sata_nv.c
@@ -255,10 +255,7 @@ static int nv_adma_port_suspend(struct a
 static int nv_adma_port_resume(struct ata_port *ap);
 static void nv_adma_error_handler(struct ata_port *ap);
 static void nv_adma_host_stop(struct ata_host *host);
-static void nv_adma_bmdma_setup(struct ata_queued_cmd *qc);
-static void nv_adma_bmdma_start(struct ata_queued_cmd *qc);
-static void nv_adma_bmdma_stop(struct ata_queued_cmd *qc);
-static u8 nv_adma_bmdma_status(struct ata_port *ap);
+static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc);
 
 enum nv_host_type
 {
@@ -433,16 +430,16 @@ static const struct ata_port_operations 
 	.exec_command		= ata_exec_command,
 	.check_status		= ata_check_status,
 	.dev_select		= ata_std_dev_select,
-	.bmdma_setup		= nv_adma_bmdma_setup,
-	.bmdma_start		= nv_adma_bmdma_start,
-	.bmdma_stop		= nv_adma_bmdma_stop,
-	.bmdma_status		= nv_adma_bmdma_status,
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
 	.qc_prep		= nv_adma_qc_prep,
 	.qc_issue		= nv_adma_qc_issue,
 	.freeze			= nv_ck804_freeze,
 	.thaw			= nv_ck804_thaw,
 	.error_handler		= nv_adma_error_handler,
-	.post_internal_cmd	= nv_adma_bmdma_stop,
+	.post_internal_cmd	= nv_adma_post_internal_cmd,
 	.data_xfer		= ata_data_xfer,
 	.irq_handler		= nv_adma_interrupt,
 	.irq_clear		= nv_adma_irq_clear,
@@ -899,73 +896,12 @@ static void nv_adma_irq_clear(struct ata
 	iowrite8(ioread8(dma_stat_addr), dma_stat_addr);
 }
 
-static void nv_adma_bmdma_setup(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	unsigned int rw = (qc->tf.flags & ATA_TFLAG_WRITE);
-	struct nv_adma_port_priv *pp = ap->private_data;
-	u8 dmactl;
-
-	if(!(pp->flags & NV_ADMA_PORT_REGISTER_MODE)) {
-		WARN_ON(1);
-		return;
-	}
-
-	/* load PRD table addr. */
-	iowrite32(ap->prd_dma, ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
-
-	/* specify data direction, triple-check start bit is clear */
-	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-	dmactl &= ~(ATA_DMA_WR | ATA_DMA_START);
-	if (!rw)
-		dmactl |= ATA_DMA_WR;
-
-	iowrite8(dmactl, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
-	/* issue r/w command */
-	ata_exec_command(ap, &qc->tf);
-}
-
-static void nv_adma_bmdma_start(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct nv_adma_port_priv *pp = ap->private_data;
-	u8 dmactl;
-
-	if(!(pp->flags & NV_ADMA_PORT_REGISTER_MODE)) {
-		WARN_ON(1);
-		return;
-	}
-
-	/* start host DMA transaction */
-	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-	iowrite8(dmactl | ATA_DMA_START,
-		 ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-}
-
-static void nv_adma_bmdma_stop(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct nv_adma_port_priv *pp = ap->private_data;
-
-	if(!(pp->flags & NV_ADMA_PORT_REGISTER_MODE))
-		return;
-
-	/* clear start/stop bit */
-	iowrite8(ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD) & ~ATA_DMA_START,
-		 ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
-	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_altstatus(ap);        /* dummy read */
-}
-
-static u8 nv_adma_bmdma_status(struct ata_port *ap)
+static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc)
 {
-	struct nv_adma_port_priv *pp = ap->private_data;
-
-	WARN_ON(!(pp->flags & NV_ADMA_PORT_REGISTER_MODE));
+	struct nv_adma_port_priv *pp = qc->ap->private_data;
 
-	return ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+	if(pp->flags & NV_ADMA_PORT_REGISTER_MODE)
+		ata_bmdma_post_internal_cmd(qc);
 }
 
 static int nv_adma_port_start(struct ata_port *ap)
_

Patches currently in -mm which might be from hancockr@shaw.ca are

sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
libata-add-ncq-blacklist-entries-from-silicon-image-windows.patch
