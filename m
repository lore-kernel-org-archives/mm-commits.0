From: akpm@osdl.org
Subject: - piix-fix-82371mx-enablebits.patch removed from -mm tree
Date: Mon, 22 Jan 2007 13:11:03 -0800
Message-ID: <200701222111.l0MLB3Ob002213@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932783AbXAVVRd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 16:17:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     PIIX: fix 82371MX enablebits
has been removed from the -mm tree.  Its filename was
     piix-fix-82371mx-enablebits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PIIX: fix 82371MX enablebits
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

According to the datasheet, Intel 82371MX (MPIIX) actually has only a
single IDE channel mapped to the primary or secondary ports depending on
the value of the bit 14 of the IDETIM register at PCI config.  offset 0x6C
(the register at 0x6F which the driver refers to.  doesn't exist).  So,
disguise the controller as dual channel and set enablebits masks/values
such that only either primary or secondary channel is detected enabled. 
Also, preclude the IDE probing code from reading PCI BARs, this controller
just doesn't have them (it's not the separate PCI function like the other
PCI controllers), it only decodes the legacy addresses.

(Alan sayeth " MPIIX does not work with or without the change.  It needs its
own different driver and not to use setup-pci.  Huge job and since it works
well with libata who cares.  Ditto the early PIIX chip.")

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/piix.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/ide/pci/piix.c~piix-fix-82371mx-enablebits drivers/ide/pci/piix.c
--- a/drivers/ide/pci/piix.c~piix-fix-82371mx-enablebits
+++ a/drivers/ide/pci/piix.c
@@ -539,13 +539,19 @@ static ide_pci_device_t piix_pci_info[] 
 	/*  0 */ DECLARE_PIIX_DEV("PIIXa"),
 	/*  1 */ DECLARE_PIIX_DEV("PIIXb"),
 
-	{	/* 2 */
+	/*  2 */
+	{	/*
+		 * MPIIX actually has only a single IDE channel mapped to
+		 * the primary or secondary ports depending on the value
+		 * of the bit 14 of the IDETIM register at offset 0x6c
+		 */
 		.name		= "MPIIX",
 		.init_hwif	= init_hwif_piix,
 		.channels	= 2,
 		.autodma	= NODMA,
-		.enablebits	= {{0x6D,0x80,0x80}, {0x6F,0x80,0x80}},
+		.enablebits	= {{0x6d,0xc0,0x80}, {0x6d,0xc0,0xc0}},
 		.bootable	= ON_BOARD,
+		.flags		= IDEPCI_FLAG_ISA_PORTS
 	},
 
 	/*  3 */ DECLARE_PIIX_DEV("PIIX3"),
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

git-mtd.patch
3x59x-fix-pci-resource-management.patch
