From: akpm@linux-foundation.org
Subject: + sata_nv-fix-adma-freeze-thaw-irq_clear-issues.patch added to -mm tree
Date: Wed, 09 May 2007 13:42:04 -0700
Message-ID: <200705092042.l49Kg4kd000552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401AbXEIUmm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 16:42:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hancockr@shaw.ca, htejun@gmail.com, jeff@garzik.org


The patch titled
     sata_nv: fix ADMA freeze/thaw/irq_clear issues
has been added to the -mm tree.  Its filename is
     sata_nv-fix-adma-freeze-thaw-irq_clear-issues.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_nv: fix ADMA freeze/thaw/irq_clear issues
From: Robert Hancock <hancockr@shaw.ca>

This patch fixes some problems with ADMA-capable controllers with regard to
freeze, thaw and irq_clear libata callbacks.  Freeze and thaw didn't switch
the ADMA-specific interrupts on or off, and more critically the irq_clear
function didn't respect the restriction that the notifier clear registers
for both ports have to be written at the same time even when only one port
is being cleared.  This could result in timeouts on one port when error
handling (i.e.  as a result of hotplug) occurred on the other port.

As well, this fixes some issues in the interrupt handler: we shouldn't
check any ADMA status if the port has ADMA switched off because of an ATAPI
device, and it also checks to see if any ADMA interrupt has been raised
even when we are in port-register mode.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |   90 ++++++++++++++++++++++++++++++++++------
 1 files changed, 77 insertions(+), 13 deletions(-)

diff -puN drivers/ata/sata_nv.c~sata_nv-fix-adma-freeze-thaw-irq_clear-issues drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-fix-adma-freeze-thaw-irq_clear-issues
+++ a/drivers/ata/sata_nv.c
@@ -257,6 +257,8 @@ static void nv_adma_port_stop(struct ata
 static int nv_adma_port_suspend(struct ata_port *ap, pm_message_t mesg);
 static int nv_adma_port_resume(struct ata_port *ap);
 #endif
+static void nv_adma_freeze(struct ata_port *ap);
+static void nv_adma_thaw(struct ata_port *ap);
 static void nv_adma_error_handler(struct ata_port *ap);
 static void nv_adma_host_stop(struct ata_host *host);
 static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc);
@@ -438,8 +440,8 @@ static const struct ata_port_operations 
 	.bmdma_status		= ata_bmdma_status,
 	.qc_prep		= nv_adma_qc_prep,
 	.qc_issue		= nv_adma_qc_issue,
-	.freeze			= nv_ck804_freeze,
-	.thaw			= nv_ck804_thaw,
+	.freeze			= nv_adma_freeze,
+	.thaw			= nv_adma_thaw,
 	.error_handler		= nv_adma_error_handler,
 	.post_internal_cmd	= nv_adma_post_internal_cmd,
 	.data_xfer		= ata_data_xfer,
@@ -810,7 +812,15 @@ static irqreturn_t nv_adma_interrupt(int
 			u32 gen_ctl;
 			u32 notifier, notifier_error;
 
-			/* if in ATA register mode, use standard ata interrupt handler */
+			/* if ADMA is disabled, use standard ata interrupt handler */
+			if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) {
+				u8 irq_stat = readb(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804)
+					>> (NV_INT_PORT_SHIFT * i);
+				handled += nv_host_intr(ap, irq_stat);
+				continue;
+			}
+
+			/* if in ATA register mode, check for standard interrupts */
 			if (pp->flags & NV_ADMA_PORT_REGISTER_MODE) {
 				u8 irq_stat = readb(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804)
 					>> (NV_INT_PORT_SHIFT * i);
@@ -820,7 +830,6 @@ static irqreturn_t nv_adma_interrupt(int
 					    command is active, to prevent losing interrupts. */
 					irq_stat |= NV_INT_DEV;
 				handled += nv_host_intr(ap, irq_stat);
-				continue;
 			}
 
 			notifier = readl(mmio + NV_ADMA_NOTIFIER);
@@ -906,22 +915,77 @@ static irqreturn_t nv_adma_interrupt(int
 	return IRQ_RETVAL(handled);
 }
 
+static void nv_adma_freeze(struct ata_port *ap)
+{
+	struct nv_adma_port_priv *pp = ap->private_data;
+	void __iomem *mmio = pp->ctl_block;
+	u16 tmp;
+
+	nv_ck804_freeze(ap);
+
+	if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)
+		return;
+
+	/* clear any outstanding CK804 notifications */
+	writeb( NV_INT_ALL << (ap->port_no * NV_INT_PORT_SHIFT),
+		ap->host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804);
+
+	/* Disable interrupt */
+	tmp = readw(mmio + NV_ADMA_CTL);
+	writew( tmp & ~(NV_ADMA_CTL_AIEN | NV_ADMA_CTL_HOTPLUG_IEN),
+		mmio + NV_ADMA_CTL);
+	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+}
+
+static void nv_adma_thaw(struct ata_port *ap)
+{
+	struct nv_adma_port_priv *pp = ap->private_data;
+	void __iomem *mmio = pp->ctl_block;
+	u16 tmp;
+
+	nv_ck804_thaw(ap);
+
+	if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)
+		return;
+
+	/* Enable interrupt */
+	tmp = readw(mmio + NV_ADMA_CTL);
+	writew( tmp | (NV_ADMA_CTL_AIEN | NV_ADMA_CTL_HOTPLUG_IEN),
+		mmio + NV_ADMA_CTL);
+	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+}
+
 static void nv_adma_irq_clear(struct ata_port *ap)
 {
 	struct nv_adma_port_priv *pp = ap->private_data;
 	void __iomem *mmio = pp->ctl_block;
-	u16 status = readw(mmio + NV_ADMA_STAT);
-	u32 notifier = readl(mmio + NV_ADMA_NOTIFIER);
-	u32 notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
-	void __iomem *dma_stat_addr = ap->ioaddr.bmdma_addr + ATA_DMA_STATUS;
+	u32 notifier_clears[2];
+
+	if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) {
+		ata_bmdma_irq_clear(ap);
+		return;
+	}
+
+	/* clear any outstanding CK804 notifications */
+	writeb( NV_INT_ALL << (ap->port_no * NV_INT_PORT_SHIFT),
+		ap->host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804);
 
 	/* clear ADMA status */
-	writew(status, mmio + NV_ADMA_STAT);
-	writel(notifier | notifier_error,
-	       pp->notifier_clear_block);
+	writew(0xffff, mmio + NV_ADMA_STAT);
 
-	/** clear legacy status */
-	iowrite8(ioread8(dma_stat_addr), dma_stat_addr);
+	/* clear notifiers - note both ports need to be written with
+	   something even though we are only clearing on one */
+	if (ap->port_no == 0) {
+		notifier_clears[0] = 0xFFFFFFFF;
+		notifier_clears[1] = 0;
+	} else {
+		notifier_clears[0] = 0;
+		notifier_clears[1] = 0xFFFFFFFF;
+	}
+	pp = ap->host->ports[0]->private_data;
+	writel(notifier_clears[0], pp->notifier_clear_block);
+	pp = ap->host->ports[1]->private_data;
+	writel(notifier_clears[1], pp->notifier_clear_block);
 }
 
 static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc)
_

Patches currently in -mm which might be from hancockr@shaw.ca are

origin.patch
sata_nv-fix-adma-freeze-thaw-irq_clear-issues.patch
