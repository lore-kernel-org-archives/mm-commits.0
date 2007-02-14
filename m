From: akpm@linux-foundation.org
Subject: + natsemi-support-aculab-e1-t1-pmxc-cpci-carrier-cards.patch added to -mm tree
Date: Wed, 14 Feb 2007 15:41:29 -0800
Message-ID: <200702142341.l1ENfTCS013037@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51381 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964821AbXBNXlr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 18:41:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@sirena.org.uk, jgarzik@pobox.com, thockin@hockin.org


The patch titled
     natsemi: Support Aculab E1/T1 PMXc cPCI carrier cards
has been added to the -mm tree.  Its filename is
     natsemi-support-aculab-e1-t1-pmxc-cpci-carrier-cards.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: natsemi: Support Aculab E1/T1 PMXc cPCI carrier cards
From: Mark Brown <broonie@sirena.org.uk>

Aculab E1/T1 PMXc cPCI carrier card cards present a natsemi on the cPCI
bus with an oversized EEPROM using a direct MII<->MII connection with no
PHY.  This patch adds a new device table entry supporting these cards.

Signed-off-by: Mark Brown <broonie@sirena.org.uk>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/natsemi.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/net/natsemi.c~natsemi-support-aculab-e1-t1-pmxc-cpci-carrier-cards drivers/net/natsemi.c
--- a/drivers/net/natsemi.c~natsemi-support-aculab-e1-t1-pmxc-cpci-carrier-cards
+++ a/drivers/net/natsemi.c
@@ -244,6 +244,9 @@ enum {
 	MII_EN_SCRM	= 0x0004,	/* enable scrambler (tp) */
 };
 
+enum {
+	NATSEMI_FLAG_IGNORE_PHY		= 0x1,
+};
 
 /* array of board data directly indexed by pci_tbl[x].driver_data */
 static const struct {
@@ -251,10 +254,12 @@ static const struct {
 	unsigned long flags;
 	unsigned int eeprom_size;
 } natsemi_pci_info[] __devinitdata = {
+	{ "Aculab E1/T1 PMXc cPCI carrier card", NATSEMI_FLAG_IGNORE_PHY, 128 },
 	{ "NatSemi DP8381[56]", 0, 24 },
 };
 
 static const struct pci_device_id natsemi_pci_tbl[] __devinitdata = {
+	{ PCI_VENDOR_ID_NS, 0x0020, 0x12d9,     0x000c,     0, 0, 0 },
 	{ PCI_VENDOR_ID_NS, 0x0020, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ }	/* terminate list */
 };
@@ -811,7 +816,10 @@ static int __devinit natsemi_probe1 (str
 	np->hands_off = 0;
 	np->intr_status = 0;
 	np->eeprom_size = natsemi_pci_info[chip_idx].eeprom_size;
-	np->ignore_phy = 0;
+	if (natsemi_pci_info[chip_idx].flags & NATSEMI_FLAG_IGNORE_PHY)
+		np->ignore_phy = 1;
+	else
+		np->ignore_phy = 0;
 
 	/* Initial port:
 	 * - If configured to ignore the PHY set up for external.
_

Patches currently in -mm which might be from broonie@sirena.org.uk are

natsemi-add-support-for-using-mii-port-with-no-phy.patch
natsemi-add-support-for-using-mii-port-with-no-phy-update.patch
natsemi-support-aculab-e1-t1-pmxc-cpci-carrier-cards.patch
