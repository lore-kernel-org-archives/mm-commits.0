From: akpm@linux-foundation.org
Subject: + 3c59x-check-return-of-pci_enable_device.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:49:11 -0700
Message-ID: <200707232149.l6NLnBsC013704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35731 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932281AbXGWVuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark@hindley.org.uk, klassert@mathematik.tu-chemnitz.de


The patch titled
     3c59x: check return of pci_enable_device()
has been added to the -mm tree.  Its filename is
     3c59x-check-return-of-pci_enable_device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 3c59x: check return of pci_enable_device()
From: Mark Hindley <mark@hindley.org.uk>

Check return of pci_enable_device in vortex_up().

Signed-off-by: Mark Hindley <mark@hindley.org.uk>
Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c59x.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/net/3c59x.c~3c59x-check-return-of-pci_enable_device drivers/net/3c59x.c
--- a/drivers/net/3c59x.c~3c59x-check-return-of-pci_enable_device
+++ a/drivers/net/3c59x.c
@@ -1489,13 +1489,17 @@ vortex_up(struct net_device *dev)
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
