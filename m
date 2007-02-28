From: akpm@linux-foundation.org
Subject: - sata_promise-simplify-port-setup.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:52:07 -0800
Message-ID: <200702282352.l1SNq7to030967@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48205 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609AbXB1XwO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikpe@it.uu.se, mm-commits@vger.kernel.org


The patch titled
     sata_promise: simplify port setup
has been removed from the -mm tree.  Its filename was
     sata_promise-simplify-port-setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_promise: simplify port setup
From: Mikael Pettersson <mikpe@it.uu.se>

Each place in pdc_ata_init_one() that initialises a SATA port first calls
pdc_ata_setup_port(), and then manually assigns the port's ->scr_addr. 
Simplify the code by extending pdc_ata_setup_port() to also handle scr_addr
initialisation; for PATA ports we pass NULL as scr_addr.

The initialisation of the PATA-only 20619 redundantly set up scr_addr for
the ports.  Remove this.

Tested on 20619, 20575, and 20775 chips.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_promise.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff -puN drivers/ata/sata_promise.c~sata_promise-simplify-port-setup drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~sata_promise-simplify-port-setup
+++ a/drivers/ata/sata_promise.c
@@ -776,7 +776,8 @@ static int pdc_old_check_atapi_dma(struc
 	return pdc_check_atapi_dma(qc);
 }
 
-static void pdc_ata_setup_port(struct ata_ioports *port, void __iomem *base)
+static void pdc_ata_setup_port(struct ata_ioports *port, void __iomem *base,
+			       void __iomem *scr_addr)
 {
 	port->cmd_addr		= base;
 	port->data_addr		= base;
@@ -791,6 +792,7 @@ static void pdc_ata_setup_port(struct at
 	port->status_addr	= base + 0x1c;
 	port->altstatus_addr	=
 	port->ctl_addr		= base + 0x38;
+	port->scr_addr		= scr_addr;
 }
 
 
@@ -903,11 +905,8 @@ static int pdc_ata_init_one (struct pci_
 
 	base = probe_ent->iomap[PDC_MMIO_BAR];
 
-	pdc_ata_setup_port(&probe_ent->port[0], base + 0x200);
-	pdc_ata_setup_port(&probe_ent->port[1], base + 0x280);
-
-	probe_ent->port[0].scr_addr = base + 0x400;
-	probe_ent->port[1].scr_addr = base + 0x500;
+	pdc_ata_setup_port(&probe_ent->port[0], base + 0x200, base + 0x400);
+	pdc_ata_setup_port(&probe_ent->port[1], base + 0x280, base + 0x500);
 
 	/* notice 4-port boards */
 	switch (board_idx) {
@@ -916,12 +915,8 @@ static int pdc_ata_init_one (struct pci_
 		/* Fall through */
 	case board_20319:
        		probe_ent->n_ports = 4;
-
-		pdc_ata_setup_port(&probe_ent->port[2], base + 0x300);
-		pdc_ata_setup_port(&probe_ent->port[3], base + 0x380);
-
-		probe_ent->port[2].scr_addr = base + 0x600;
-		probe_ent->port[3].scr_addr = base + 0x700;
+		pdc_ata_setup_port(&probe_ent->port[2], base + 0x300, base + 0x600);
+		pdc_ata_setup_port(&probe_ent->port[3], base + 0x380, base + 0x700);
 		break;
 	case board_2057x:
 		hp->flags |= PDC_FLAG_GEN_II;
@@ -931,7 +926,7 @@ static int pdc_ata_init_one (struct pci_
 		tmp = readb(base + PDC_FLASH_CTL+1);
 		if (!(tmp & 0x80)) {
 			probe_ent->n_ports = 3;
-			pdc_ata_setup_port(&probe_ent->port[2], base + 0x300);
+			pdc_ata_setup_port(&probe_ent->port[2], base + 0x300, NULL);
 			hp->port_flags[2] = ATA_FLAG_SLAVE_POSS;
 			printk(KERN_INFO DRV_NAME " PATA port found\n");
 		} else
@@ -941,12 +936,8 @@ static int pdc_ata_init_one (struct pci_
 		break;
 	case board_20619:
 		probe_ent->n_ports = 4;
-
-		pdc_ata_setup_port(&probe_ent->port[2], base + 0x300);
-		pdc_ata_setup_port(&probe_ent->port[3], base + 0x380);
-
-		probe_ent->port[2].scr_addr = base + 0x600;
-		probe_ent->port[3].scr_addr = base + 0x700;
+		pdc_ata_setup_port(&probe_ent->port[2], base + 0x300, NULL);
+		pdc_ata_setup_port(&probe_ent->port[3], base + 0x380, NULL);
 		break;
 	default:
 		BUG();
_

Patches currently in -mm which might be from mikpe@it.uu.se are
