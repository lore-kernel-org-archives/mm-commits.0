From: akpm@linux-foundation.org
Subject: + sata_promise-cleanups.patch added to -mm tree
Date: Tue, 26 Jun 2007 00:04:49 -0700
Message-ID: <200706260704.l5Q74n4c020569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbXFZHFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 03:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikpe@it.uu.se, htejun@gmail.com, jeff@garzik.org


The patch titled
     sata_promise: cleanups
has been added to the -mm tree.  Its filename is
     sata_promise-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_promise: cleanups
From: Mikael Pettersson <mikpe@it.uu.se>

This patch applies some trivial cleanups to sata_promise:
- repair whitespace damage
- correct comment at board_2057x_pata definition
- pull SATAII TX4 support code out to separate functions
- rename ata_nr to ata_no for consistency with libata's port_no
- remove some init-time debug printks (requested by Jeff)

This patch should cause no behavioural changes, except for the removed
printks.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_promise.c |   56 ++++++++++++++---------------------
 1 file changed, 23 insertions(+), 33 deletions(-)

diff -puN drivers/ata/sata_promise.c~sata_promise-cleanups drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~sata_promise-cleanups
+++ a/drivers/ata/sata_promise.c
@@ -45,8 +45,7 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_promise"
-#define DRV_VERSION	"2.07"
-
+#define DRV_VERSION	"2.08"
 
 enum {
 	PDC_MAX_PORTS		= 4,
@@ -94,7 +93,7 @@ enum {
 	board_20319		= 2,	/* FastTrak S150 TX4 */
 	board_20619		= 3,	/* FastTrak TX4000 */
 	board_2057x		= 4,	/* SATAII150 Tx2plus */
-	board_2057x_pata	= 5,	/* SATAII150 Tx2plus */
+	board_2057x_pata	= 5,	/* SATAII150 Tx2plus PATA port */
 	board_40518		= 6,	/* SATAII150 Tx4 */
 
 	PDC_HAS_PATA		= (1 << 1), /* PDC20375/20575 has PATA */
@@ -124,7 +123,6 @@ enum {
 	PDC_FLAG_4_PORTS	= (1 << 26), /* 4 ports */
 };
 
-
 struct pdc_port_priv {
 	u8			*pkt;
 	dma_addr_t		pkt_dma;
@@ -340,7 +338,6 @@ static const struct pci_device_id pdc_at
 	{ }	/* terminate list */
 };
 
-
 static struct pci_driver pdc_ata_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= pdc_ata_pci_tbl,
@@ -348,7 +345,6 @@ static struct pci_driver pdc_ata_pci_dri
 	.remove			= ata_pci_remove_one,
 };
 
-
 static int pdc_common_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->host->dev;
@@ -438,7 +434,6 @@ static u32 pdc_sata_scr_read (struct ata
 	return readl(ap->ioaddr.scr_addr + (sc_reg * 4));
 }
 
-
 static void pdc_sata_scr_write (struct ata_port *ap, unsigned int sc_reg,
 			       u32 val)
 {
@@ -657,8 +652,8 @@ static void pdc_error_intr(struct ata_po
 	ata_port_abort(ap);
 }
 
-static inline unsigned int pdc_host_intr( struct ata_port *ap,
-                                          struct ata_queued_cmd *qc)
+static inline unsigned int pdc_host_intr(struct ata_port *ap,
+					 struct ata_queued_cmd *qc)
 {
 	unsigned int handled = 0;
 	void __iomem *port_mmio = ap->ioaddr.cmd_addr;
@@ -685,10 +680,10 @@ static inline unsigned int pdc_host_intr
 		handled = 1;
 		break;
 
-        default:
+	default:
 		ap->stats.idle_irq++;
 		break;
-        }
+	}
 
 	return handled;
 }
@@ -701,6 +696,18 @@ static void pdc_irq_clear(struct ata_por
 	readl(mmio + PDC_INT_SEQMASK);
 }
 
+static inline int pdc_is_sataii_tx4(unsigned long flags)
+{
+	const unsigned long mask = PDC_FLAG_GEN_II | PDC_FLAG_4_PORTS;
+	return (flags & mask) == mask;
+}
+
+static inline unsigned int pdc_port_no_to_ata_no(unsigned int port_no, int is_sataii_tx4)
+{
+	static const unsigned char sataii_tx4_port_remap[4] = { 3, 1, 0, 2};
+	return is_sataii_tx4 ? sataii_tx4_port_remap[port_no] : port_no;
+}
+
 static irqreturn_t pdc_interrupt (int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
@@ -807,7 +814,6 @@ static void pdc_tf_load_mmio(struct ata_
 	ata_tf_load(ap, tf);
 }
 
-
 static void pdc_exec_command_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 {
 	WARN_ON (tf->protocol == ATA_PROT_DMA ||
@@ -867,7 +873,6 @@ static void pdc_ata_setup_port(struct at
 	ap->ioaddr.scr_addr		= scr_addr;
 }
 
-
 static void pdc_host_init(struct ata_host *host)
 {
 	void __iomem *mmio = host->iomap[PDC_MMIO_BAR];
@@ -955,10 +960,8 @@ static int pdc_ata_init_one (struct pci_
 
 	if (pi->flags & PDC_FLAG_SATA_PATA) {
 		u8 tmp = readb(base + PDC_FLASH_CTL+1);
-		if (!(tmp & 0x80)) {
+		if (!(tmp & 0x80))
 			ppi[n_ports++] = pi + 1;
-			dev_printk(KERN_INFO, &pdev->dev, "PATA port found\n");
-		}
 	}
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
@@ -968,22 +971,12 @@ static int pdc_ata_init_one (struct pci_
 	}
 	host->iomap = pcim_iomap_table(pdev);
 
-	is_sataii_tx4 = 0;
-	if ((pi->flags & (PDC_FLAG_GEN_II|PDC_FLAG_4_PORTS)) == (PDC_FLAG_GEN_II|PDC_FLAG_4_PORTS)) {
-		is_sataii_tx4 = 1;
-		dev_printk(KERN_INFO, &pdev->dev, "applying SATAII TX4 port numbering workaround\n");
-	}
+	is_sataii_tx4 = pdc_is_sataii_tx4(pi->flags);
 	for (i = 0; i < host->n_ports; i++) {
-		static const unsigned char sataii_tx4_port_remap[4] = { 3, 1, 0, 2};
-		int ata_nr;
-
-		ata_nr = i;
-		if (is_sataii_tx4)
-			ata_nr = sataii_tx4_port_remap[i];
-
+		unsigned int ata_no = pdc_port_no_to_ata_no(i, is_sataii_tx4);
 		pdc_ata_setup_port(host->ports[i],
-				   base + 0x200 + ata_nr * 0x80,
-				   base + 0x400 + ata_nr * 0x100);
+				   base + 0x200 + ata_no * 0x80,
+				   base + 0x400 + ata_no * 0x100);
 	}
 
 	/* initialize adapter */
@@ -1002,19 +995,16 @@ static int pdc_ata_init_one (struct pci_
 				 &pdc_ata_sht);
 }
 
-
 static int __init pdc_ata_init(void)
 {
 	return pci_register_driver(&pdc_ata_pci_driver);
 }
 
-
 static void __exit pdc_ata_exit(void)
 {
 	pci_unregister_driver(&pdc_ata_pci_driver);
 }
 
-
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Promise ATA TX2/TX4/TX4000 low-level driver");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from mikpe@it.uu.se are

sata_promise-cleanups.patch
sata_promise-sata-hotplug-support.patch
