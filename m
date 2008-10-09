From: akpm@linux-foundation.org
Subject: - net-add-net-poll-support-for-atl2-driver.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:28:14 -0700
Message-ID: <200810092228.m99MSEKY006055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194AbYJIW2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:28:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kexin.hao@windriver.com, jacliburn@bellsouth.net, mm-commits@vger.kernel.org


The patch titled
     net: add net poll support for atl2 driver
has been removed from the -mm tree.  Its filename was
     net-add-net-poll-support-for-atl2-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: add net poll support for atl2 driver
From: Kevin Hao <kexin.hao@windriver.com>

Add netconsole support for Atheros L2 10/100 network device.

Signed-off-by: Kevin Hao <kexin.hao@windriver.com>
Acked-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atlx/atl2.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/net/atlx/atl2.c~net-add-net-poll-support-for-atl2-driver drivers/net/atlx/atl2.c
--- a/drivers/net/atlx/atl2.c~net-add-net-poll-support-for-atl2-driver
+++ a/drivers/net/atlx/atl2.c
@@ -1329,6 +1329,15 @@ static void atl2_setup_pcicmd(struct pci
 	pci_write_config_dword(pdev, REG_PM_CTRLSTAT, 0);
 }
 
+#ifdef CONFIG_NET_POLL_CONTROLLER
+static void atl2_poll_controller(struct net_device *netdev)
+{
+	disable_irq(netdev->irq);
+	atl2_intr(netdev->irq, netdev);
+	enable_irq(netdev->irq);
+}
+#endif
+
 /*
  * atl2_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -1412,6 +1421,9 @@ static int __devinit atl2_probe(struct p
 	netdev->do_ioctl = &atl2_ioctl;
 	atl2_set_ethtool_ops(netdev);
 
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	netdev->poll_controller = atl2_poll_controller;
+#endif
 #ifdef HAVE_TX_TIMEOUT
 	netdev->tx_timeout = &atl2_tx_timeout;
 	netdev->watchdog_timeo = 5 * HZ;
_

Patches currently in -mm which might be from kexin.hao@windriver.com are

git-tip.patch
git-net.patch

