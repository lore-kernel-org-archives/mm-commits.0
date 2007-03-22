From: akpm@linux-foundation.org
Subject: + mv643xx_eth-add-mv643xx_eth_shutdown-function.patch added to -mm tree
Date: Thu, 22 Mar 2007 14:12:26 -0700
Message-ID: <200703222112.l2MLCQvF030463@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51948 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbXCVVPl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 17:15:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dale@farnsworth.org


The patch titled
     mv643xx_eth: add mv643xx_eth_shutdown function
has been added to the -mm tree.  Its filename is
     mv643xx_eth-add-mv643xx_eth_shutdown-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mv643xx_eth-add-mv643xx_eth_shutdown-function.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
