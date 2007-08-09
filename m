From: akpm@linux-foundation.org
Subject: - alpm-store-interrupt-value.patch removed from -mm tree
Date: Thu, 09 Aug 2007 14:59:24 -0700
Message-ID: <200708092159.l79LxOXd021705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbXHIV7i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:59:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ALPM: store interrupt value
has been removed from the -mm tree.  Its filename was
     alpm-store-interrupt-value.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ALPM: store interrupt value
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Use a stored value for which interrupts to enable.  Changing this allows us to
selectively turn off certain interrupts later and have them stay off.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/ata/ahci.c~alpm-store-interrupt-value drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~alpm-store-interrupt-value
+++ a/drivers/ata/ahci.c
@@ -175,6 +175,7 @@ enum {
 	AHCI_FLAG_32BIT_ONLY		= (1 << 28), /* force 32bit */
 	AHCI_FLAG_MV_PATA		= (1 << 29), /* PATA port */
 	AHCI_FLAG_NO_MSI		= (1 << 30), /* no PCI MSI */
+	AHCI_FLAG_NO_HOTPLUG		= (1 << 31), /* ignore PxSERR.DIAG.N */
 
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
@@ -215,6 +216,7 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_d2h:1;
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
+	u32 			intr_mask;	/* interrupts to enable */
 };
 
 static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
@@ -1511,6 +1513,7 @@ static void ahci_thaw(struct ata_port *a
 	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
+	struct ahci_port_priv *pp = ap->private_data;
 
 	/* clear IRQ */
 	tmp = readl(port_mmio + PORT_IRQ_STAT);
@@ -1518,7 +1521,7 @@ static void ahci_thaw(struct ata_port *a
 	writel(1 << ap->port_no, mmio + HOST_IRQ_STAT);
 
 	/* turn IRQ back on */
-	writel(DEF_PORT_IRQ, port_mmio + PORT_IRQ_MASK);
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
 }
 
 static void ahci_error_handler(struct ata_port *ap)
@@ -1672,6 +1675,12 @@ static int ahci_port_start(struct ata_po
 	pp->cmd_tbl = mem;
 	pp->cmd_tbl_dma = mem_dma;
 
+	/*
+ 	 * Save off initial list of interrupts to be enabled.
+ 	 * This could be changed later
+ 	 */
+	pp->intr_mask = DEF_PORT_IRQ;
+
 	ap->private_data = pp;
 
 	/* engage engines, captain */
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-libata-all.patch
alpm-store-interrupt-value.patch
alpm-enable-link-power-management-for-ata-drivers.patch
alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
libata-check-for-an-support.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
libata-send-event-when-an-received.patch
acpiphp_ibm-add-missing-n.patch
cpqphp_ctrlc-remove-dead-code.patch
acpi-bay-send-envp-with-uevent-fix.patch
acpi-dock-send-key=value-pair-instead-of-plain-value.patch
