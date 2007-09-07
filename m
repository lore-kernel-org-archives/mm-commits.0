From: akpm@linux-foundation.org
Subject: - 3c59x-check-return-of-pci_enable_device.patch removed from -mm tree
Date: Thu, 06 Sep 2007 17:42:30 -0700
Message-ID: <200709070042.l870gU8a016041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964854AbXIGAnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2007 20:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark@hindley.org.uk, klassert@mathematik.tu-chemnitz.de, mm-commits@vger.kernel.org


The patch titled
     3c59x: check return of pci_enable_device()
has been removed from the -mm tree.  Its filename was
     3c59x-check-return-of-pci_enable_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 3c59x: check return of pci_enable_device()
From: Mark Hindley <mark@hindley.org.uk>

Check return of pci_enable_device in vortex_up().

Also modify vortex_up to return error to callers.  Handle failure of
vortex_up in vortex_open and vortex_resume.

Signed-off-by: Mark Hindley <mark@hindley.org.uk>
Cc: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c59x.c |   36 ++++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 12 deletions(-)

diff -puN drivers/net/3c59x.c~3c59x-check-return-of-pci_enable_device drivers/net/3c59x.c
--- a/drivers/net/3c59x.c~3c59x-check-return-of-pci_enable_device
+++ a/drivers/net/3c59x.c
@@ -705,7 +705,7 @@ static struct {
 
 static int vortex_probe1(struct device *gendev, void __iomem *ioaddr, int irq,
 				   int chip_idx, int card_idx);
-static void vortex_up(struct net_device *dev);
+static int vortex_up(struct net_device *dev);
 static void vortex_down(struct net_device *dev, int final);
 static int vortex_open(struct net_device *dev);
 static void mdio_sync(void __iomem *ioaddr, int bits);
@@ -841,8 +841,11 @@ static int vortex_resume(struct pci_dev 
 			return -EBUSY;
 		}
 		if (netif_running(dev)) {
-			vortex_up(dev);
-			netif_device_attach(dev);
+			err = vortex_up(dev);
+			if (err)
+				return err;
+			else
+				netif_device_attach(dev);
 		}
 	}
 	return 0;
@@ -1484,19 +1487,24 @@ static void vortex_check_media(struct ne
 	}
 }
 
-static void
+static int
 vortex_up(struct net_device *dev)
 {
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
+			goto err_out;
+		}
 	}
 
 	/* Before initializing select the active media port. */
@@ -1661,6 +1669,8 @@ vortex_up(struct net_device *dev)
 	if (vp->cb_fn_base)			/* The PCMCIA people are idiots.  */
 		iowrite32(0x8000, vp->cb_fn_base + 4);
 	netif_start_queue (dev);
+err_out:
+	return err;
 }
 
 static int
@@ -1674,7 +1684,7 @@ vortex_open(struct net_device *dev)
 	if ((retval = request_irq(dev->irq, vp->full_bus_master_rx ?
 				&boomerang_interrupt : &vortex_interrupt, IRQF_SHARED, dev->name, dev))) {
 		printk(KERN_ERR "%s: Could not reserve IRQ %d\n", dev->name, dev->irq);
-		goto out;
+		goto err;
 	}
 
 	if (vp->full_bus_master_rx) { /* Boomerang bus master. */
@@ -1703,20 +1713,22 @@ vortex_open(struct net_device *dev)
 				}
 			}
 			retval = -ENOMEM;
-			goto out_free_irq;
+			goto err_free_irq;
 		}
 		/* Wrap the ring. */
 		vp->rx_ring[i-1].next = cpu_to_le32(vp->rx_ring_dma);
 	}
 
-	vortex_up(dev);
-	return 0;
+	retval = vortex_up(dev);
+	if (!retval)
+		goto out;
 
-out_free_irq:
+err_free_irq:
 	free_irq(dev->irq, dev);
-out:
+err:
 	if (vortex_debug > 1)
 		printk(KERN_ERR "%s: vortex_open() fails: returning %d\n", dev->name, retval);
+out:
 	return retval;
 }
 
_

Patches currently in -mm which might be from mark@hindley.org.uk are

git-netdev-all.patch
