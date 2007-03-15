From: akpm@linux-foundation.org
Subject: + natsemi-consistently-use-interrupt-enable-disable-functions.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:50:15 -0800
Message-ID: <200703151850.l2FIoH01023295@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35518 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbXCOSua (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:50:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@sirena.org.uk


The patch titled
     natsemi: consistently use interrupt enable/disable functions
has been added to the -mm tree.  Its filename is
     natsemi-consistently-use-interrupt-enable-disable-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: natsemi: consistently use interrupt enable/disable functions
From: Mark Brown <broonie@sirena.org.uk>

The natsemi drivers include functions for enabling and disabling interrupts
from the chip but these are not used in all code paths.  This patch changes
the code paths that touch the interrupt enable register to use the functions. 
In all cases this adds an extra PCI read to post the operation but since none
of these are in fast paths this shouldn't be too much of a problem.

Signed-off-by: Mark Brown <broonie@sirena.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/natsemi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/natsemi.c~natsemi-consistently-use-interrupt-enable-disable-functions drivers/net/natsemi.c
--- a/drivers/net/natsemi.c~natsemi-consistently-use-interrupt-enable-disable-functions
+++ a/drivers/net/natsemi.c
@@ -1712,7 +1712,7 @@ static void init_registers(struct net_de
 
 	/* Enable interrupts by setting the interrupt mask. */
 	writel(DEFAULT_INTR, ioaddr + IntrMask);
-	writel(1, ioaddr + IntrEnable);
+	natsemi_irq_enable(dev);
 
 	writel(RxOn | TxOn, ioaddr + ChipCmd);
 	writel(StatsClear, ioaddr + StatsCtrl); /* Clear Stats */
@@ -3071,7 +3071,7 @@ static void enable_wol_mode(struct net_d
 		 * Could be used to send a netlink message.
 		 */
 		writel(WOLPkt | LinkChange, ioaddr + IntrMask);
-		writel(1, ioaddr + IntrEnable);
+		natsemi_irq_enable(dev);
 	}
 }
 
@@ -3202,7 +3202,7 @@ static int natsemi_suspend (struct pci_d
 		disable_irq(dev->irq);
 		spin_lock_irq(&np->lock);
 
-		writel(0, ioaddr + IntrEnable);
+		natsemi_irq_disable(dev);
 		np->hands_off = 1;
 		natsemi_stop_rxtx(dev);
 		netif_stop_queue(dev);
_

Patches currently in -mm which might be from broonie@sirena.org.uk are

natsemi-consistently-use-interrupt-enable-disable-functions.patch
natsemi-fix-napi-for-interrupt-sharing.patch
natsemi-avoid-intrstatus-lossage-if-rx-state-machine-resets.patch
