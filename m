From: akpm@linux-foundation.org
Subject: + ata-ahci-alpm-store-interrupt-value.patch added to -mm tree
Date: Thu, 05 Jul 2007 15:37:45 -0700
Message-ID: <200707052237.l65MbjaN022314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57681 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759819AbXGEWi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 18:38:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com, James.Bottomley@steeleye.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     ata ahci ALPM: Store interrupt value
has been added to the -mm tree.  Its filename is
     ata-ahci-alpm-store-interrupt-value.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ata ahci ALPM: Store interrupt value
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Use a stored value for which interrupts to enable.  Changing this allows us to
selectively turn off certain interrupts later and have them stay off.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/ata/ahci.c~ata-ahci-alpm-store-interrupt-value drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ata-ahci-alpm-store-interrupt-value
+++ a/drivers/ata/ahci.c
@@ -213,6 +213,7 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_d2h:1;
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
+	u32 			intr_mask;	/* interrupts to enable */
 };
 
 static u32 ahci_scr_read (struct ata_port *ap, unsigned int sc_reg);
@@ -1486,6 +1487,7 @@ static void ahci_thaw(struct ata_port *a
 	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
+	struct ahci_port_priv *pp = ap->private_data;
 
 	/* clear IRQ */
 	tmp = readl(port_mmio + PORT_IRQ_STAT);
@@ -1493,7 +1495,7 @@ static void ahci_thaw(struct ata_port *a
 	writel(1 << ap->port_no, mmio + HOST_IRQ_STAT);
 
 	/* turn IRQ back on */
-	writel(DEF_PORT_IRQ, port_mmio + PORT_IRQ_MASK);
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
 }
 
 static void ahci_error_handler(struct ata_port *ap)
@@ -1649,6 +1651,12 @@ static int ahci_port_start(struct ata_po
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

git-acpi.patch
libata-check-for-an-support.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
ata-ahci-alpm-store-interrupt-value.patch
ata-ahci-alpm-expose-power-management-policy-option-to-users.patch
ata-ahci-alpm-enable-link-power-management-for-ata-drivers.patch
ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
