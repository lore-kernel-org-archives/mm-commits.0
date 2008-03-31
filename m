From: akpm@linux-foundation.org
Subject: - pata_sil680-only-enable-mmio-on-cell-blades.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:19:11 -0700
Message-ID: <200803312019.m2VKJBTW024186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079AbYCaUUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:20:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@ozlabs.org, alan@redhat.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     pata_sil680: only enable MMIO on Cell blades
has been removed from the -mm tree.  Its filename was
     pata_sil680-only-enable-mmio-on-cell-blades.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

