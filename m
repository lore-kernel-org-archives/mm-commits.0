From: akpm@linux-foundation.org
Subject: - char-cyclades-init-ze-immediately.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:01 -0700
Message-ID: <200705090257.l492v1GV010125@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032679AbXEIC5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, init Ze immediately
has been removed from the -mm tree.  Its filename was
     char-cyclades-init-ze-immediately.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, init Ze immediately
From: Jiri Slaby <jirislaby@gmail.com>

There will be no other choice after introducing pci probing anyway.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   59 +++++---------------------------------
 1 file changed, 8 insertions(+), 51 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-init-ze-immediately drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-init-ze-immediately
+++ a/drivers/char/cyclades.c
@@ -4714,12 +4714,14 @@ static void plx_init(void __iomem * addr
 static int __devinit cy_init_Ze(unsigned long cy_pci_phys0,
 		unsigned long cy_pci_phys2,
 		struct RUNTIME_9060 __iomem *cy_pci_addr0,
-		void __iomem *cy_pci_addr2, int cy_pci_irq,
-		struct pci_dev *pdev)
+		int cy_pci_irq, struct pci_dev *pdev)
 {
+	void __iomem *cy_pci_addr2;
 	unsigned int j;
 	unsigned short cy_pci_nchan;
 
+	cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Ze_win);
+
 	readl(&cy_pci_addr0->mail_box_0);
 #ifdef CY_PCI_DEBUG
 	printk("Cyclades-Z/PCI: relocate winaddr=0x%lx ctladdr=0x%lx\n",
@@ -4816,11 +4818,6 @@ static int __init cy_detect_pci(void)
 	unsigned short i, j, cy_pci_nchan, plx_ver;
 	unsigned short device_id, dev_index = 0;
 	__u32 mailbox;
-	__u32 ZeIndex = 0;
-	void __iomem *Ze_addr0[NR_CARDS], *Ze_addr2[NR_CARDS];
-	__u32 Ze_phys0[NR_CARDS], Ze_phys2[NR_CARDS];
-	unsigned char Ze_irq[NR_CARDS];
-	struct pci_dev *Ze_pdev[NR_CARDS];
 	int retval;
 
 	for (i = 0; i < NR_CARDS; i++) {
@@ -5042,24 +5039,10 @@ static int __init cy_detect_pci(void)
 			}
 
 			if (mailbox == ZE_V1) {
-				cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Ze_win);
-				if (ZeIndex == NR_CARDS) {
-					printk("Cyclades-Ze/PCI found at "
-						"0x%lx but no more cards can "
-						"be used.\nChange NR_CARDS in "
-						"cyclades.c and recompile "
-						"kernel.\n",
-						(ulong)cy_pci_phys2);
-				} else {
-					Ze_phys0[ZeIndex] = cy_pci_phys0;
-					Ze_phys2[ZeIndex] = cy_pci_phys2;
-					Ze_addr0[ZeIndex] = cy_pci_addr0;
-					Ze_addr2[ZeIndex] = cy_pci_addr2;
-					Ze_irq[ZeIndex] = cy_pci_irq;
-					Ze_pdev[ZeIndex] = pdev;
-					ZeIndex++;
-				}
-				i--;
+				retval = cy_init_Ze(cy_pci_phys0, cy_pci_phys2,
+						cy_pci_addr0, cy_pci_irq, pdev);
+				if (retval < 0)
+					i--;
 				continue;
 			} else {
 				cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Zwin);
@@ -5168,32 +5151,6 @@ static int __init cy_detect_pci(void)
 		}
 	}
 
-	for (; ZeIndex != 0 && i < NR_CARDS; i++) {
-		cy_pci_phys0 = Ze_phys0[0];
-		cy_pci_phys2 = Ze_phys2[0];
-		cy_pci_addr0 = Ze_addr0[0];
-		cy_pci_addr2 = Ze_addr2[0];
-		cy_pci_irq = Ze_irq[0];
-		pdev = Ze_pdev[0];
-		for (j = 0; j < ZeIndex - 1; j++) {
-			Ze_phys0[j] = Ze_phys0[j + 1];
-			Ze_phys2[j] = Ze_phys2[j + 1];
-			Ze_addr0[j] = Ze_addr0[j + 1];
-			Ze_addr2[j] = Ze_addr2[j + 1];
-			Ze_irq[j] = Ze_irq[j + 1];
-			Ze_pdev[j] = Ze_pdev[j + 1];
-		}
-		ZeIndex--;
-		retval = cy_init_Ze(cy_pci_phys0, cy_pci_phys2, cy_pci_addr0,
-					cy_pci_addr2, cy_pci_irq, pdev);
-		if (retval < 0)
-			return i;
-	}
-	if (ZeIndex != 0) {
-		printk("Cyclades-Ze/PCI found at 0x%x but no more cards can be "
-			"used.\nChange NR_CARDS in cyclades.c and recompile "
-			"kernel.\n", (unsigned int)Ze_phys2[0]);
-	}
 	return i;
 #else
 	return 0;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
