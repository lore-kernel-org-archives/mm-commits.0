From: akpm@linux-foundation.org
Subject: + net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch added to -mm tree
Date: Thu, 04 Sep 2008 14:25:24 -0700
Message-ID: <200809042125.m84LPOjJ031922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296AbYIDV0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 17:26:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, aabdulla@nvidia.com, jeff@garzik.org, jgarzik@redhat.com, ranma+kernel@tdiedrich.de, rjw@sisk.pl


The patch titled
     net: forcedeth: call restore mac addr in nv_shutdown path
has been added to the -mm tree.  Its filename is
     net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch

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
+		printk(KERN_DEBUG "nv_probe: set workarund bit for reversed mac addr\n");
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

origin.patch
forcedeth-fix-kexec-regression.patch
linux-next.patch
dyn_array-use-%pf-instead-of-print_fn_descriptor_symbol.patch
dyn_array-fix-typo.patch
net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch
x86-delay-early-cpu-initialization-until-cpuid-is-done.patch
x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx.patch

