From: akpm@linux-foundation.org
Subject: - char-cyclades-remove-useless-fileds-from-cyclades_card.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:30 -0700
Message-ID: <200705090257.l492vUPn010199@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032786AbXEIC5d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, remove useless fileds from cyclades_card
has been removed from the -mm tree.  Its filename was
     char-cyclades-remove-useless-fileds-from-cyclades_card.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, remove useless fileds from cyclades_card
From: Jiri Slaby <jirislaby@gmail.com>

pde, ctl_phys and base_phys are useless -- they are never used.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |    9 ---------
 include/linux/cyclades.h |    3 ---
 2 files changed, 12 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-useless-fileds-from-cyclades_card drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-useless-fileds-from-cyclades_card
+++ a/drivers/char/cyclades.c
@@ -4914,15 +4914,12 @@ static int __devinit cy_init_Ze(unsigned
 #endif				/* CONFIG_CYZ_INTR */
 
 	/* set cy_card */
-	cy_card[j].base_phys = cy_pci_phys2;
-	cy_card[j].ctl_phys = cy_pci_phys0;
 	cy_card[j].base_addr = cy_pci_addr2;
 	cy_card[j].ctl_addr = cy_pci_addr0;
 	cy_card[j].irq = (int)cy_pci_irq;
 	cy_card[j].bus_index = 1;
 	cy_card[j].first_line = cy_next_channel;
 	cy_card[j].num_chips = -1;
-	cy_card[j].pdev = pdev;
 	cy_init_card(&cy_card[j], j);
 	pci_set_drvdata(pdev, &cy_card[j]);
 
@@ -5066,15 +5063,12 @@ static int __devinit cy_pci_probe(struct
 		}
 
 		/* set cy_card */
-		cy_card[j].base_phys = (ulong) cy_pci_phys2;
-		cy_card[j].ctl_phys = (ulong) cy_pci_phys0;
 		cy_card[j].base_addr = cy_pci_addr2;
 		cy_card[j].ctl_addr = cy_pci_addr0;
 		cy_card[j].irq = (int)cy_pci_irq;
 		cy_card[j].bus_index = 1;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = cy_pci_nchan / 4;
-		cy_card[j].pdev = pdev;
 		cy_init_card(&cy_card[j], j);
 		pci_set_drvdata(pdev, &cy_card[j]);
 
@@ -5253,15 +5247,12 @@ static int __devinit cy_pci_probe(struct
 #endif				/* CONFIG_CYZ_INTR */
 
 		/* set cy_card */
-		cy_card[j].base_phys = cy_pci_phys2;
-		cy_card[j].ctl_phys = cy_pci_phys0;
 		cy_card[j].base_addr = cy_pci_addr2;
 		cy_card[j].ctl_addr = cy_pci_addr0;
 		cy_card[j].irq = (int)cy_pci_irq;
 		cy_card[j].bus_index = 1;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = -1;
-		cy_card[j].pdev = pdev;
 		cy_init_card(&cy_card[j], j);
 		pci_set_drvdata(pdev, &cy_card[j]);
 
diff -puN include/linux/cyclades.h~char-cyclades-remove-useless-fileds-from-cyclades_card include/linux/cyclades.h
--- a/include/linux/cyclades.h~char-cyclades-remove-useless-fileds-from-cyclades_card
+++ a/include/linux/cyclades.h
@@ -509,8 +509,6 @@ struct ZFW_CTRL {
 
 /* Per card data structure */
 struct cyclades_card {
-    unsigned long base_phys;
-    unsigned long ctl_phys;
     void __iomem *base_addr;
     void __iomem *ctl_addr;
     int irq;
@@ -519,7 +517,6 @@ struct cyclades_card {
     int nports;		/* Number of ports in the card */
     int bus_index;	/* address shift - 0 for ISA, 1 for PCI */
     int	intr_enabled;	/* FW Interrupt flag - 0 disabled, 1 enabled */
-    struct pci_dev *pdev;
     spinlock_t card_lock;
 };
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
