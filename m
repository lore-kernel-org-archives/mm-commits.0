From: akpm@osdl.org
Subject: + spider-fix-gregkh-driver-network-device.patch added to -mm tree
Date: Mon, 29 Jan 2007 16:51:28 -0800
Message-ID: <200701300051.l0U0pS50004611@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35670 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965281AbXA3Avh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 19:51:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, Jens.Osterkamp@de.ibm.com, greg@kroah.com, utz.bacher@de.ibm.com


The patch titled
     Fix compilation problem with spider network driver on 2.6.20-rc6-mm2
has been added to the -mm tree.  Its filename is
     spider-fix-gregkh-driver-network-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix compilation problem with spider network driver on 2.6.20-rc6-mm2
From: Bernhard Walle <bwalle@suse.de>

Fixes compilation with 2.6.20-rc6-mm1.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Utz Bacher <utz.bacher@de.ibm.com>
Cc: Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/spider_net.c~spider-fix-gregkh-driver-network-device drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spider-fix-gregkh-driver-network-device
+++ a/drivers/net/spider_net.c
@@ -1906,8 +1906,7 @@ spider_net_stop(struct net_device *netde
 	spider_net_write_reg(card, SPIDER_NET_GHIINT1MSK, 0);
 	spider_net_write_reg(card, SPIDER_NET_GHIINT2MSK, 0);
 
-	/* free_irq(netdev->irq, netdev);*/
-	free_irq(to_pci_dev(netdev->class_dev.dev)->irq, netdev);
+	free_irq(card->pdev->irq, netdev);
 
 	spider_net_write_reg(card, SPIDER_NET_GDTDMACCNTR,
 			     SPIDER_NET_DMA_TX_FEND_VALUE);
_

Patches currently in -mm which might be from bwalle@suse.de are

spider-fix-gregkh-driver-network-device.patch
