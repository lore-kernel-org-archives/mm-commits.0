From: akpm@linux-foundation.org
Subject: - spider-fix-gregkh-driver-network-device.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:23:59 -0800
Message-ID: <200702100524.l1A5Nxm3004566@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36686 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbXBJFY3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:24:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, Jens.Osterkamp@de.ibm.com, greg@kroah.com, utz.bacher@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Fix compilation problem with spider network driver on 2.6.20-rc6-mm2
has been removed from the -mm tree.  Its filename was
     spider-fix-gregkh-driver-network-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix compilation problem with spider network driver on 2.6.20-rc6-mm2
From: Bernhard Walle <bwalle@suse.de>

Fixes compilation with 2.6.20-rc6-mm1.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Utz Bacher <utz.bacher@de.ibm.com>
Cc: Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/spider_net.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/spider_net.c~spider-fix-gregkh-driver-network-device drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spider-fix-gregkh-driver-network-device
+++ a/drivers/net/spider_net.c
@@ -1913,8 +1913,7 @@ spider_net_stop(struct net_device *netde
 	spider_net_write_reg(card, SPIDER_NET_GHIINT1MSK, 0);
 	spider_net_write_reg(card, SPIDER_NET_GHIINT2MSK, 0);
 
-	/* free_irq(netdev->irq, netdev);*/
-	free_irq(to_pci_dev(netdev->class_dev.dev)->irq, netdev);
+	free_irq(card->pdev->irq, netdev);
 
 	spider_net_write_reg(card, SPIDER_NET_GDTDMACCNTR,
 			     SPIDER_NET_DMA_TX_FEND_VALUE);
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
