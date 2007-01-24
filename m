From: akpm@osdl.org
Subject: - add-suport-for-marvell-88se6121-in-pata_marvell.patch removed from -mm tree
Date: Tue, 23 Jan 2007 16:42:13 -0800
Message-ID: <200701240042.l0O0gDw1004051@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44788 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965472AbXAXAme (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 19:42:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jareguero@telefonica.net, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     Add suport for Marvell 88SE6121 in pata_marvell
has been removed from the -mm tree.  Its filename was
     add-suport-for-marvell-88se6121-in-pata_marvell.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: Add suport for Marvell 88SE6121 in pata_marvell
From: Jose Alberto Reguero <jareguero@telefonica.net>

Marvell 88SE6121 is a ahci controller, but I can't make it work with the achi
driver.
This part:

+       else if (pdev->device == 0x6121) {
+               mmio_base = pci_iomap(pdev, 5, 0);
+               if (mmio_base == NULL) {
+                       return -ENOMEM;
+               }
+               /* turn on legacy mode */
+               writel(0, mmio_base + 0x04);
+               (void) readl(mmio_base + 0x04); /* flush */
+       }

put the ahci in legacy mode and work with pata_marvell.
Perhaps someone else can make it work whith the ahci driver.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/pata_marvell.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/ata/pata_marvell.c~add-suport-for-marvell-88se6121-in-pata_marvell drivers/ata/pata_marvell.c
--- a/drivers/ata/pata_marvell.c~add-suport-for-marvell-88se6121-in-pata_marvell
+++ a/drivers/ata/pata_marvell.c
@@ -49,7 +49,7 @@ static int marvell_pre_reset(struct ata_
 	devices = readl(barp + 0x0C);
 	pci_iounmap(pdev, barp);
 
-	if ((pdev->device == 0x6145) && (ap->port_no == 0) &&
+	if (((pdev->device == 0x6145) || (pdev->device == 0x6121)) && (ap->port_no == 0) &&
 	    (!(devices & 0x10)))	/* PATA enable ? */
 		return -ENOENT;
 
@@ -184,6 +184,16 @@ static int marvell_init_one (struct pci_
 
 	if (pdev->device == 0x6101)
 		n_port = 1;
+	else if (pdev->device == 0x6121) {
+		void __iomem *mmio_base = pci_iomap(pdev, 5, 0);
+
+		if (mmio_base == NULL)
+			return -ENOMEM;
+
+		/* turn on legacy mode */
+		writel(0, mmio_base + 0x04);
+		readl(mmio_base + 0x04);	/* flush */
+	}
 
 	return ata_pci_init_one(pdev, port_info, n_port);
 }
@@ -191,6 +201,7 @@ static int marvell_init_one (struct pci_
 static const struct pci_device_id marvell_pci_tbl[] = {
 	{ PCI_DEVICE(0x11AB, 0x6101), },
 	{ PCI_DEVICE(0x11AB, 0x6145), },
+	{ PCI_DEVICE(0x11AB, 0x6121), },
 	{ }	/* terminate list */
 };
 
_

Patches currently in -mm which might be from jareguero@telefonica.net are

add-suport-for-marvell-88se6121-in-pata_marvell.patch
