From: akpm@linux-foundation.org
Subject: + pata_sil680-only-enable-mmio-on-cell-blades.patch added to -mm tree
Date: Tue, 25 Mar 2008 23:35:02 -0700
Message-ID: <200803260635.m2Q6Z2CG001418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbYCZGft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 02:35:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@ozlabs.org, alan@redhat.com, benh@kernel.crashing.org


The patch titled
     pata_sil680: only enable MMIO on Cell blades
has been added to the -mm tree.  Its filename is
     pata_sil680-only-enable-mmio-on-cell-blades.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pata_sil680: only enable MMIO on Cell blades
From: Benjamin Herrenschmidt <benh@ozlabs.org>

There have been reported regressions of the SIL 680 driver when using MMIO, so
this makes it only try MMIO on Cell blades where it's known to be necessary
(the host bridge doesn't do PIO on these).

We'll try to find the root problem with MMIO separately.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_sil680.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/ata/pata_sil680.c~pata_sil680-only-enable-mmio-on-cell-blades drivers/ata/pata_sil680.c
--- a/drivers/ata/pata_sil680.c~pata_sil680-only-enable-mmio-on-cell-blades
+++ a/drivers/ata/pata_sil680.c
@@ -229,7 +229,11 @@ static u8 sil680_init_chip(struct pci_de
 	dev_dbg(&pdev->dev, "sil680: BA5_EN = %d clock = %02X\n",
 		tmpbyte & 1, tmpbyte & 0x30);
 
-	*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
+	*try_mmio = 0;
+#ifdef CONFIG_PPC
+	if (machine_is(cell))
+		*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
+#endif
 
 	switch(tmpbyte & 0x30) {
 		case 0x00:
_

Patches currently in -mm which might be from benh@ozlabs.org are

pata_sil680-only-enable-mmio-on-cell-blades.patch

