From: akpm@linux-foundation.org
Subject: - 3c59x-check-return-of-pci_enable_device.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:52:05 -0700
Message-ID: <200708140552.l7E5q5TL001536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S941817AbXHNFxF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark@hindley.org.uk, klassert@mathematik.tu-chemnitz.de, mm-commits@vger.kernel.org


The patch titled
     3c59x: check return of pci_enable_device()
has been removed from the -mm tree.  Its filename was
     3c59x-check-return-of-pci_enable_device.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: 3c59x: check return of pci_enable_device()
From: Mark Hindley <mark@hindley.org.uk>

Check return of pci_enable_device in vortex_up().

Signed-off-by: Mark Hindley <mark@hindley.org.uk>
Acked-by: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c59x.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/net/3c59x.c~3c59x-check-return-of-pci_enable_device drivers/net/3c59x.c
--- a/drivers/net/3c59x.c~3c59x-check-return-of-pci_enable_device
+++ a/drivers/net/3c59x.c
@@ -1490,13 +1490,17 @@ vortex_up(struct net_device *dev)
 	struct vortex_private *vp = netdev_priv(dev);
 	void __iomem *ioaddr = vp->ioaddr;
 	unsigned int config;
-	int i, mii_reg1, mii_reg5;
+	int i, mii_reg1, mii_reg5, err;
 
 	if (VORTEX_PCI(vp)) {
 		pci_set_power_state(VORTEX_PCI(vp), PCI_D0);	/* Go active */
 		if (vp->pm_state_valid)
 			pci_restore_state(VORTEX_PCI(vp));
-		pci_enable_device(VORTEX_PCI(vp));
+		err = pci_enable_device(VORTEX_PCI(vp));
+		if (err) {
+			printk(KERN_WARNING "%s: Could not enable device \n",
+				dev->name);
+		}
 	}
 
 	/* Before initializing select the active media port. */
_

Patches currently in -mm which might be from mark@hindley.org.uk are

3c59x-check-return-of-pci_enable_device.patch
