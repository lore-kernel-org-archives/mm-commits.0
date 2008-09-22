From: akpm@linux-foundation.org
Subject: - net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch removed from -mm tree
Date: Mon, 22 Sep 2008 00:12:12 -0700
Message-ID: <200809220712.m8M7CCwE028718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462AbYIVHN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 03:13:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, aabdulla@nvidia.com, jeff@garzik.org, jgarzik@redhat.com, ranma+kernel@tdiedrich.de, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     net: forcedeth: call restore mac addr in nv_shutdown path
has been removed from the -mm tree.  Its filename was
     net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: forcedeth: call restore mac addr in nv_shutdown path
From: Yinghai Lu <yhlu.kernel@gmail.com>

after

| commit f735a2a1a4f2a0f5cd823ce323e82675990469e2
| Author: Tobias Diedrich <ranma+kernel@tdiedrich.de>
| Date:   Sun May 18 15:02:37 2008 +0200
|
|    [netdrvr] forcedeth: setup wake-on-lan before shutting down
|
|    When hibernating in 'shutdown' mode, after saving the image the suspend hook
|    is not called again.
|    However, if the device is in promiscous mode, wake-on-lan will not work.
|    This adds a shutdown hook to setup wake-on-lan before the final shutdown.
|
|    Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>
|    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

my servers with nvidia ck804 and mcp55 will reverse mac address with kexec.

it turns out that we need to restore the mac addr in nv_shutdown().

[akpm@linux-foundation.org: fix typo in printk]
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN drivers/net/forcedeth.c~net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2 drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2
+++ a/drivers/net/forcedeth.c
@@ -5651,6 +5651,7 @@ static int __devinit nv_probe(struct pci
 		dev->dev_addr[4] = (np->orig_mac[0] >>  8) & 0xff;
 		dev->dev_addr[5] = (np->orig_mac[0] >>  0) & 0xff;
 		writel(txreg|NVREG_TRANSMITPOLL_MAC_ADDR_REV, base + NvRegTransmitPoll);
+		printk(KERN_DEBUG "nv_probe: set workaround bit for reversed mac addr\n");
 	}
 	memcpy(dev->perm_addr, dev->dev_addr, dev->addr_len);
 
@@ -5898,14 +5899,12 @@ static void nv_restore_phy(struct net_de
 	}
 }
 
-static void __devexit nv_remove(struct pci_dev *pci_dev)
+static void nv_restore_mac_addr(struct pci_dev *pci_dev)
 {
 	struct net_device *dev = pci_get_drvdata(pci_dev);
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
 
-	unregister_netdev(dev);
-
 	/* special op: write back the misordered MAC address - otherwise
 	 * the next nv_probe would see a wrong address.
 	 */
@@ -5913,6 +5912,15 @@ static void __devexit nv_remove(struct p
 	writel(np->orig_mac[1], base + NvRegMacAddrB);
 	writel(readl(base + NvRegTransmitPoll) & ~NVREG_TRANSMITPOLL_MAC_ADDR_REV,
 	       base + NvRegTransmitPoll);
+}
+
+static void __devexit nv_remove(struct pci_dev *pci_dev)
+{
+	struct net_device *dev = pci_get_drvdata(pci_dev);
+
+	unregister_netdev(dev);
+
+	nv_restore_mac_addr(pci_dev);
 
 	/* restore any phy related changes */
 	nv_restore_phy(dev);
@@ -5990,6 +5998,8 @@ static void nv_shutdown(struct pci_dev *
 	if (netif_running(dev))
 		nv_close(dev);
 
+	nv_restore_mac_addr(pdev);
+
 	pci_disable_device(pdev);
 	if (system_state == SYSTEM_POWER_OFF) {
 		if (pci_enable_wake(pdev, PCI_D3cold, np->wolenabled))
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

linux-next.patch
fix-x86-sparse_irq-needs-spin_lock-in-allocations.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch

