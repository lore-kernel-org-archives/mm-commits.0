From: akpm@linux-foundation.org
Subject: - sata_promise-fix-hardreset-hotplug-quirk.patch removed from -mm tree
Date: Tue, 25 Mar 2008 15:20:42 -0700
Message-ID: <200803252220.m2PMKggW016493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755049AbYCYWU7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:20:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikpe@it.uu.se, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sata_promise: fix hardreset hotplug quirk
has been removed from the -mm tree.  Its filename was
     sata_promise-fix-hardreset-hotplug-quirk.patch

This patch was dropped because Jeff merged other stuff and wrecked it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sata_promise: fix hardreset hotplug quirk
From: Mikael Pettersson <mikpe@it.uu.se>

There is an undocumented hardware quirk in Promise's SATA controllers, where a
SATA COMRESET causes the controller to signal hotplug events.  These
unexpected interrupts confuse libata's error handler and cause a sequence of
failed reset attempts until EH finally gives up.

This has not been a common problem so far, but the pending libata
hardreset-by-default changes makes it a critical issue.

The solution is to disable hotplug events before a reset, and to reenable them
afterwards.  (Promise's driver uses the same solution.)

This patch adds SATA-specific versions of ->freeze() and ->thaw() that also
disable and enable hotplug events.  PATA ports continue to use the old
versions of ->freeze() and ->thaw().

Although SATA hotplug status and control is per-port, it resides in a single
register shared by all ports.  Therefore accesses to it must be serialised:
the controller's host->lock is used for that.  The interrupt handler is also
adjusted so its hotplug register accesses are inside the region protected by
host->lock.

Tested on various chips (SATA300TX4, SATA300TX2plus, SATAII150TX4, FastTrack
TX4000) with various combinations of SATA and PATA disks, with and without the
pending hardreset-by-default changes.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_promise.c |  115 ++++++++++++++++++++++++++++-------
 1 file changed, 94 insertions(+), 21 deletions(-)

diff -puN drivers/ata/sata_promise.c~sata_promise-fix-hardreset-hotplug-quirk drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~sata_promise-fix-hardreset-hotplug-quirk
+++ a/drivers/ata/sata_promise.c
@@ -46,7 +46,7 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_promise"
-#define DRV_VERSION	"2.11"
+#define DRV_VERSION	"2.12"
 
 enum {
 	PDC_MAX_PORTS		= 4,
@@ -145,7 +145,9 @@ static int pdc_old_sata_check_atapi_dma(
 static void pdc_irq_clear(struct ata_port *ap);
 static unsigned int pdc_qc_issue_prot(struct ata_queued_cmd *qc);
 static void pdc_freeze(struct ata_port *ap);
+static void pdc_sata_freeze(struct ata_port *ap);
 static void pdc_thaw(struct ata_port *ap);
+static void pdc_sata_thaw(struct ata_port *ap);
 static void pdc_pata_error_handler(struct ata_port *ap);
 static void pdc_sata_error_handler(struct ata_port *ap);
 static void pdc_post_internal_cmd(struct ata_queued_cmd *qc);
@@ -180,8 +182,8 @@ static const struct ata_port_operations 
 
 	.qc_prep		= pdc_qc_prep,
 	.qc_issue		= pdc_qc_issue_prot,
-	.freeze			= pdc_freeze,
-	.thaw			= pdc_thaw,
+	.freeze			= pdc_sata_freeze,
+	.thaw			= pdc_sata_thaw,
 	.error_handler		= pdc_sata_error_handler,
 	.post_internal_cmd	= pdc_post_internal_cmd,
 	.cable_detect		= pdc_sata_cable_detect,
@@ -205,8 +207,8 @@ static const struct ata_port_operations 
 
 	.qc_prep		= pdc_qc_prep,
 	.qc_issue		= pdc_qc_issue_prot,
-	.freeze			= pdc_freeze,
-	.thaw			= pdc_thaw,
+	.freeze			= pdc_sata_freeze,
+	.thaw			= pdc_sata_thaw,
 	.error_handler		= pdc_sata_error_handler,
 	.post_internal_cmd	= pdc_post_internal_cmd,
 	.cable_detect		= pdc_sata_cable_detect,
@@ -631,6 +633,78 @@ static void pdc_qc_prep(struct ata_queue
 	}
 }
 
+static int pdc_is_sataii_tx4(unsigned long flags)
+{
+	const unsigned long mask = PDC_FLAG_GEN_II | PDC_FLAG_4_PORTS;
+	return (flags & mask) == mask;
+}
+
+static unsigned int pdc_port_no_to_ata_no(unsigned int port_no,
+					  int is_sataii_tx4)
+{
+	static const unsigned char sataii_tx4_port_remap[4] = { 3, 1, 0, 2};
+	return is_sataii_tx4 ? sataii_tx4_port_remap[port_no] : port_no;
+}
+
+static unsigned int pdc_sata_nr_ports(const struct ata_port *ap)
+{
+	return (ap->flags & PDC_FLAG_4_PORTS) ? 4 : 2;
+}
+
+static unsigned int pdc_sata_ata_port_to_ata_no(const struct ata_port *ap)
+{
+	const struct ata_host *host = ap->host;
+	unsigned int nr_ports = pdc_sata_nr_ports(ap);
+	unsigned int i;
+
+	for(i = 0; i < nr_ports && host->ports[i] != ap; ++i)
+		;
+	BUG_ON(i >= nr_ports);
+	return pdc_port_no_to_ata_no(i, pdc_is_sataii_tx4(ap->flags));
+}
+
+static unsigned int pdc_sata_hotplug_offset(const struct ata_port *ap)
+{
+	return (ap->flags & PDC_FLAG_GEN_II) ? PDC2_SATA_PLUG_CSR : PDC_SATA_PLUG_CSR;
+}	
+
+static void pdc_sata_disable_hotplug(const struct ata_port *ap)
+{
+	struct ata_host *host = ap->host;
+	void __iomem *host_mmio = host->iomap[PDC_MMIO_BAR];
+	unsigned int hotplug_offset = pdc_sata_hotplug_offset(ap);
+	unsigned int ata_no = pdc_sata_ata_port_to_ata_no(ap);
+	u32 hotplug_status;
+
+	spin_lock(&host->lock);
+
+	hotplug_status = readl(host_mmio + hotplug_offset);
+	hotplug_status |= 0x11 << (ata_no + 16);
+	writel(hotplug_status, host_mmio + hotplug_offset);
+	readl(host_mmio + hotplug_offset); /* flush */
+
+	spin_unlock(&host->lock);
+}
+
+static void pdc_sata_enable_hotplug(const struct ata_port *ap)
+{
+	struct ata_host *host = ap->host;
+	void __iomem *host_mmio = host->iomap[PDC_MMIO_BAR];
+	unsigned int hotplug_offset = pdc_sata_hotplug_offset(ap);
+	unsigned int ata_no = pdc_sata_ata_port_to_ata_no(ap);
+	u32 hotplug_status;
+
+	spin_lock(&host->lock);
+
+	hotplug_status = readl(host_mmio + hotplug_offset);
+	hotplug_status |= 0x11 << ata_no;
+	hotplug_status &= ~(0x11 << (ata_no + 16));
+	writel(hotplug_status, host_mmio + hotplug_offset);
+	readl(host_mmio + hotplug_offset); /* flush */
+
+	spin_unlock(&host->lock);
+}
+
 static void pdc_freeze(struct ata_port *ap)
 {
 	void __iomem *mmio = ap->ioaddr.cmd_addr;
@@ -643,6 +717,12 @@ static void pdc_freeze(struct ata_port *
 	readl(mmio + PDC_CTLSTAT); /* flush */
 }
 
+static void pdc_sata_freeze(struct ata_port *ap)
+{
+	pdc_sata_disable_hotplug(ap);
+	pdc_freeze(ap);
+}
+
 static void pdc_thaw(struct ata_port *ap)
 {
 	void __iomem *mmio = ap->ioaddr.cmd_addr;
@@ -658,6 +738,12 @@ static void pdc_thaw(struct ata_port *ap
 	readl(mmio + PDC_CTLSTAT); /* flush */
 }
 
+static void pdc_sata_thaw(struct ata_port *ap)
+{
+	pdc_thaw(ap);
+	pdc_sata_enable_hotplug(ap);
+}
+
 static void pdc_common_error_handler(struct ata_port *ap, ata_reset_fn_t hardreset)
 {
 	if (!(ap->pflags & ATA_PFLAG_FROZEN))
@@ -765,19 +851,6 @@ static void pdc_irq_clear(struct ata_por
 	readl(mmio + PDC_INT_SEQMASK);
 }
 
-static int pdc_is_sataii_tx4(unsigned long flags)
-{
-	const unsigned long mask = PDC_FLAG_GEN_II | PDC_FLAG_4_PORTS;
-	return (flags & mask) == mask;
-}
-
-static unsigned int pdc_port_no_to_ata_no(unsigned int port_no,
-					  int is_sataii_tx4)
-{
-	static const unsigned char sataii_tx4_port_remap[4] = { 3, 1, 0, 2};
-	return is_sataii_tx4 ? sataii_tx4_port_remap[port_no] : port_no;
-}
-
 static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
@@ -799,6 +872,8 @@ static irqreturn_t pdc_interrupt(int irq
 
 	mmio_base = host->iomap[PDC_MMIO_BAR];
 
+	spin_lock(&host->lock);
+
 	/* read and clear hotplug flags for all ports */
 	if (host->ports[0]->flags & PDC_FLAG_GEN_II)
 		hotplug_offset = PDC2_SATA_PLUG_CSR;
@@ -814,11 +889,9 @@ static irqreturn_t pdc_interrupt(int irq
 
 	if (mask == 0xffffffff && hotplug_status == 0) {
 		VPRINTK("QUICK EXIT 2\n");
-		return IRQ_NONE;
+		goto done_irq;
 	}
 
-	spin_lock(&host->lock);
