From: akpm@linux-foundation.org
Subject: + ata_piix-sata-2port-controller-port-map-fix.patch added to -mm tree
Date: Mon, 15 Oct 2007 13:39:45 -0700
Message-ID: <200710152039.l9FKdji6024001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33675 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755577AbXJOUjr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 16:39:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jason.d.gaston@intel.com


The patch titled
     ata_piix: SATA 2port controller port map fix
has been added to the -mm tree.  Its filename is
     ata_piix-sata-2port-controller-port-map-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ata_piix: SATA 2port controller port map fix
From: Jason Gaston <jason.d.gaston@intel.com>

Add a port map for ICH9 and ICH8 SATA controllers that have only 2 ports
available in that mode.

Signed-off-by: Jason Gaston <jason.d.gaston@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_piix.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff -puN drivers/ata/ata_piix.c~ata_piix-sata-2port-controller-port-map-fix drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~ata_piix-sata-2port-controller-port-map-fix
+++ a/drivers/ata/ata_piix.c
@@ -130,6 +130,7 @@ enum {
 	ich8_sata_ahci		= 9,
 	piix_pata_mwdma		= 10,	/* PIIX3 MWDMA only */
 	tolapai_sata_ahci	= 11,
+	ich9_2port_sata		= 12,
 
 	/* constants for mapping table */
 	P0			= 0,  /* port 0 */
@@ -238,19 +239,19 @@ static const struct pci_device_id piix_p
 	/* SATA Controller 1 IDE (ICH8) */
 	{ 0x8086, 0x2820, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller 2 IDE (ICH8) */
-	{ 0x8086, 0x2825, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	{ 0x8086, 0x2825, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
 	/* Mobile SATA Controller IDE (ICH8M) */
 	{ 0x8086, 0x2828, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller IDE (ICH9) */
 	{ 0x8086, 0x2920, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller IDE (ICH9) */
-	{ 0x8086, 0x2921, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	{ 0x8086, 0x2921, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
 	/* SATA Controller IDE (ICH9) */
-	{ 0x8086, 0x2926, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	{ 0x8086, 0x2926, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
 	/* SATA Controller IDE (ICH9M) */
-	{ 0x8086, 0x2928, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	{ 0x8086, 0x2928, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
 	/* SATA Controller IDE (ICH9M) */
-	{ 0x8086, 0x292d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	{ 0x8086, 0x292d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
 	/* SATA Controller IDE (ICH9M) */
 	{ 0x8086, 0x292e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller IDE (Tolapai) */
@@ -448,6 +449,18 @@ static const struct piix_map_db tolapai_
 	},
 };
 
+static const struct piix_map_db ich9_2port_map_db = {
+        .mask = 0x3,
+        .port_enable = 0x3,
+        .map = {
+                /* PM   PS   SM   SS       MAP */
+                {  P0,  NA,  P1,  NA }, /* 00b */
+                {  RV,  RV,  RV,  RV }, /* 01b */
+                {  RV,  RV,  RV,  RV }, /* 10b */
+                {  RV,  RV,  RV,  RV },
+        },
+};
+
 static const struct piix_map_db *piix_map_db_table[] = {
 	[ich5_sata]		= &ich5_map_db,
 	[ich6_sata]		= &ich6_map_db,
@@ -455,6 +468,7 @@ static const struct piix_map_db *piix_ma
 	[ich6m_sata_ahci]	= &ich6m_map_db,
 	[ich8_sata_ahci]	= &ich8_map_db,
 	[tolapai_sata_ahci]	= &tolapai_map_db,
+	[ich9_2port_sata]	= &ich9_2port_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -570,6 +584,17 @@ static struct ata_port_info piix_port_in
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
+
+	/* ich9_2port_sata: 12: */
+	{
+		.sht		= &piix_sht,
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
+				  PIIX_FLAG_AHCI,
+		.pio_mask	= 0x1f,	/* pio0-4 */
+		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
 };
 
 static struct pci_bits piix_enable_bits[] = {
_

Patches currently in -mm which might be from jason.d.gaston@intel.com are

origin.patch
ata_piix-sata-2port-controller-port-map-fix.patch
