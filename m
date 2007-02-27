From: akpm@linux-foundation.org
Subject: + natsemi-fix-detection-of-vanilla-natsemi-cards.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:54:19 -0800
Message-ID: <200702272054.l1RKsNaj028230@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51530 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbXB0Uyq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:54:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@sirena.org.uk, rct@gherkin.frus.com


The patch titled
     natsemi: fix detection of vanilla natsemi cards
has been added to the -mm tree.  Its filename is
     natsemi-fix-detection-of-vanilla-natsemi-cards.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: natsemi: fix detection of vanilla natsemi cards
From: Mark Brown <broonie@sirena.org.uk>

Bob Tracy <rct@gherkin.frus.com> reported that the addition of support for
Aculab E1/T1 cPCI carrier cards broke detection of vanilla natsemi cards. 
This patch fixes that: the problem is that the driver-specific ta in the
PCI device table is an index into a second table and this had not been
updated for the vanilla cards.

This patch fixes the problem minimally.

Signed-off-by: Mark Brown <broonie@sirena.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/natsemi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/natsemi.c~natsemi-fix-detection-of-vanilla-natsemi-cards drivers/net/natsemi.c
--- a/drivers/net/natsemi.c~natsemi-fix-detection-of-vanilla-natsemi-cards
+++ a/drivers/net/natsemi.c
@@ -260,7 +260,7 @@ static const struct {
 
 static const struct pci_device_id natsemi_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_NS, 0x0020, 0x12d9,     0x000c,     0, 0, 0 },
-	{ PCI_VENDOR_ID_NS, 0x0020, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VENDOR_ID_NS, 0x0020, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1 },
 	{ }	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, natsemi_pci_tbl);
_

Patches currently in -mm which might be from broonie@sirena.org.uk are

natsemi-fix-detection-of-vanilla-natsemi-cards.patch
