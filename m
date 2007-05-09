From: akpm@linux-foundation.org
Subject: - char-cyclades-get-rid-of-phys-addresses.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:46 -0700
Message-ID: <200705090257.l492vkrF010227@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032634AbXEIC5v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, get rid of phys addresses
has been removed from the -mm tree.  Its filename was
     char-cyclades-get-rid-of-phys-addresses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, get rid of phys addresses
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-get-rid-of-phys-addresses drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-get-rid-of-phys-addresses
+++ a/drivers/char/cyclades.c
@@ -4797,9 +4797,7 @@ static void __devinit plx_init(void __io
 	cy_writel(addr + initctl, readl(addr + initctl) & ~0x20000000);
 }
 
-static int __devinit cy_init_Ze(unsigned long cy_pci_phys0,
-		unsigned long cy_pci_phys2,
-		struct RUNTIME_9060 __iomem *cy_pci_addr0,
+static int __devinit cy_init_Ze(struct RUNTIME_9060 __iomem *cy_pci_addr0,
 		int cy_pci_irq, struct pci_dev *pdev)
 {
 	void __iomem *cy_pci_addr2;
@@ -4869,7 +4867,7 @@ static int __devinit cy_pci_probe(struct
 {
 	unsigned char cyy_rev_id;
 	int cy_pci_irq;
-	__u32 cy_pci_phys0, cy_pci_phys2, mailbox;
+	__u32 mailbox;
 	void __iomem *cy_pci_addr0, *cy_pci_addr2;
 	unsigned int device_id;
 	unsigned short j, cy_pci_nchan, plx_ver;
@@ -4883,8 +4881,6 @@ static int __devinit cy_pci_probe(struct
 
 	/* read PCI configuration area */
 	cy_pci_irq = pdev->irq;
-	cy_pci_phys0 = pci_resource_start(pdev, 0);
-	cy_pci_phys2 = pci_resource_start(pdev, 2);
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &cyy_rev_id);
 
 	device_id = pdev->device & ~PCI_DEVICE_ID_MASK;
@@ -5038,8 +5034,7 @@ static int __devinit cy_pci_probe(struct
 		}
 
 		if (mailbox == ZE_V1) {
-			retval = cy_init_Ze(cy_pci_phys0, cy_pci_phys2,
-					cy_pci_addr0, cy_pci_irq, pdev);
+			retval = cy_init_Ze(cy_pci_addr0, cy_pci_irq, pdev);
 			return retval;
 		} else {
 			cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Zwin);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
