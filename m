From: akpm@linux-foundation.org
Subject: - mv643xx_eth-add-mv643xx_eth_shutdown-function.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:05:34 -0800
Message-ID: <200703260105.l2Q15Ybu008719@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38735 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933464AbXCZBIq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dale@farnsworth.org, mm-commits@vger.kernel.org


The patch titled
     mv643xx_eth: add mv643xx_eth_shutdown function
has been removed from the -mm tree.  Its filename was
     mv643xx_eth-add-mv643xx_eth_shutdown-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mv643xx_eth: add mv643xx_eth_shutdown function
From: Dale Farnsworth <dale@farnsworth.org>

mv643xx_eth_shutdown is needed for kexec.

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/mv643xx_eth.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+)

diff -puN drivers/net/mv643xx_eth.c~mv643xx_eth-add-mv643xx_eth_shutdown-function drivers/net/mv643xx_eth.c
--- a/drivers/net/mv643xx_eth.c~mv643xx_eth-add-mv643xx_eth_shutdown-function
+++ a/drivers/net/mv643xx_eth.c
@@ -1516,9 +1516,23 @@ static int mv643xx_eth_shared_remove(str
 	return 0;
 }
 
+static void mv643xx_eth_shutdown(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+	struct mv643xx_private *mp = netdev_priv(dev);
+	unsigned int port_num = mp->port_num;
+
+	/* Mask all interrupts on ethernet port */
+	mv_write(MV643XX_ETH_INTERRUPT_MASK_REG(port_num), 0);
+	mv_read (MV643XX_ETH_INTERRUPT_MASK_REG(port_num));
+
+	eth_port_reset(port_num);
+}
+
 static struct platform_driver mv643xx_eth_driver = {
 	.probe = mv643xx_eth_probe,
 	.remove = mv643xx_eth_remove,
+	.shutdown = mv643xx_eth_shutdown,
 	.driver = {
 		.name = MV643XX_ETH_NAME,
 	},
_

Patches currently in -mm which might be from dale@farnsworth.org are

rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
