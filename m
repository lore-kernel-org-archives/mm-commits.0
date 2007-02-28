From: akpm@linux-foundation.org
Subject: - spidernet-compile-break.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:52:46 -0800
Message-ID: <200702282352.l1SNqkvs031022@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48270 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649AbXB1Xwt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     spidernet: compile break
has been removed from the -mm tree.  Its filename was
     spidernet-compile-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spidernet: compile break
From: Linas Vepstas <linas@austin.ibm.com>

As of 2.6.20-git4, the spider_net driver does not compile.  This appears to be
due to some archaic usage involving kobjects.

It also fixes a nasty double-free during ifdown of the interface.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/spider_net.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-compile-break drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-compile-break
+++ a/drivers/net/spider_net.c
@@ -1906,8 +1906,7 @@ spider_net_stop(struct net_device *netde
 	spider_net_write_reg(card, SPIDER_NET_GHIINT1MSK, 0);
 	spider_net_write_reg(card, SPIDER_NET_GHIINT2MSK, 0);
 
-	/* free_irq(netdev->irq, netdev);*/
-	free_irq(to_pci_dev(netdev->dev.parent)->irq, netdev);
+	free_irq(netdev->irq, netdev);
 
 	spider_net_write_reg(card, SPIDER_NET_GDTDMACCNTR,
 			     SPIDER_NET_DMA_TX_FEND_VALUE);
@@ -1919,8 +1918,6 @@ spider_net_stop(struct net_device *netde
 	spider_net_release_tx_chain(card, 1);
 	spider_net_free_rx_chain_contents(card);
 
-	spider_net_free_rx_chain_contents(card);
-
 	spider_net_free_chain(card, &card->tx_chain);
 	spider_net_free_chain(card, &card->rx_chain);
 
_

Patches currently in -mm which might be from linas@austin.ibm.com are

s2io-add-pci-error-recovery-support.patch
