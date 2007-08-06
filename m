From: akpm@linux-foundation.org
Subject: + ich8-cf-timeout-regression.patch added to -mm tree
Date: Mon, 06 Aug 2007 13:08:04 -0700
Message-ID: <200708062008.l76K84Ar012407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46029 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760035AbXHFUIO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 16:08:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.blueman@gmail.com, htejun@gmail.com


The patch titled
     ICH8 CF timeout fix
has been added to the -mm tree.  Its filename is
     ich8-cf-timeout-regression.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ICH8 CF timeout fix
From: "Daniel J Blueman" <daniel.blueman@gmail.com>

On 03/08/07, Tejun Heo <htejun@gmail.com> wrote:
> Daniel J Blueman wrote:
> > The ICH8 south-bridge I have is the mobile variant and does come
> > equipped with native parallel IDE - see page 447:
> > http://download.intel.com/design/chipsets/datashts/31305603.pdf . I do
> > see 35MB/s with DMA enabled from my CF on the 1 in 15 times the
> > libata-kernel does work.
> >
> > I can dump off and decode the configuration registers for the timing
> > and bus master registers in the working and non-working libata cases,
> > and the legacy ATA working case and see what's different.
>
> Does the attached patch change anything?

This addresses the issue 100%!

Due to the differences between the ICH8 non-mobile and mobile
variants, I've cooked the change into a new initialisation structure
for the ICH8M in the attached patch, if that helps at all.

The changes thus affect (correct) behaviour on the ICH8M in IDE mode
only...so should be safe for inclusion. There may be a similar
situation with ICH9Ms also.

(akpm: needs a sane changelog)

Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_piix.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff -puN drivers/ata/ata_piix.c~ich8-cf-timeout-regression drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~ich8-cf-timeout-regression
+++ a/drivers/ata/ata_piix.c
@@ -129,7 +129,8 @@ enum {
 	ich6_sata_ahci		= 7,
 	ich6m_sata_ahci		= 8,
 	ich8_sata_ahci		= 9,
-	piix_pata_mwdma		= 10,	/* PIIX3 MWDMA only */
+	ich8m_sata_ahci		= 10,
+	piix_pata_mwdma		= 11,	/* PIIX3 MWDMA only */
 
 	/* constants for mapping table */
 	P0			= 0,  /* port 0 */
@@ -240,7 +241,7 @@ static const struct pci_device_id piix_p
 	/* SATA Controller 2 IDE (ICH8) */
 	{ 0x8086, 0x2825, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* Mobile SATA Controller IDE (ICH8M) */
-	{ 0x8086, 0x2828, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	{ 0x8086, 0x2828, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8m_sata_ahci },
 	/* SATA Controller IDE (ICH9) */
 	{ 0x8086, 0x2920, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller IDE (ICH9) */
@@ -436,7 +437,19 @@ static const struct piix_map_db ich8_map
 		/* PM   PS   SM   SS       MAP */
 		{  P0,  P2,  P1,  P3 }, /* 00b (hardwired when in AHCI) */
 		{  RV,  RV,  RV,  RV },
-		{  IDE,  IDE,  NA,  NA }, /* 10b (IDE mode) */
+		{ IDE, IDE,  NA,  NA }, /* 10b (IDE mode) */
+		{  RV,  RV,  RV,  RV },
+	},
+};
+
+static const struct piix_map_db ich8m_map_db = {
+	.mask = 0x3,
+	.port_enable = 0x3,
+	.map = {
+		/* PM   PS   SM   SS       MAP */
+		{  P0,  P2,  P1,  P3 }, /* 00b (hardwired when in AHCI) */
+		{  RV,  RV,  RV,  RV },
+		{  P0,  P2, IDE, IDE }, /* 10b (IDE mode) */
 		{  RV,  RV,  RV,  RV },
 	},
 };
@@ -447,6 +460,7 @@ static const struct piix_map_db *piix_ma
 	[ich6_sata_ahci]	= &ich6_map_db,
 	[ich6m_sata_ahci]	= &ich6m_map_db,
 	[ich8_sata_ahci]	= &ich8_map_db,
+	[ich8m_sata_ahci]	= &ich8m_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -552,7 +566,18 @@ static struct ata_port_info piix_port_in
 		.port_ops	= &piix_sata_ops,
 	},
 
-	/* piix_pata_mwdma: 10:  PIIX3 MWDMA only */
+	/* ich8m_sata_ahci: 10 */
+	{
+		.sht		= &piix_sht,
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
+				  PIIX_FLAG_AHCI,
+		.pio_mask	= 0x1f,	/* pio0-4 */
+		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	/* piix_pata_mwdma: 11:  PIIX3 MWDMA only */
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS,
_

Patches currently in -mm which might be from daniel.blueman@gmail.com are

ich8-cf-timeout-regression.patch
