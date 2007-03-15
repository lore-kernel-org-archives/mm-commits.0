From: akpm@linux-foundation.org
Subject: + natsemi-avoid-intrstatus-lossage-if-rx-state-machine-resets.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:50:20 -0800
Message-ID: <200703151850.l2FIoMb2023302@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35521 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbXCOSub (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@sirena.org.uk


The patch titled
     natsemi: avoid IntrStatus lossage if RX state machine resets
has been added to the -mm tree.  Its filename is
     natsemi-avoid-intrstatus-lossage-if-rx-state-machine-resets.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: natsemi: avoid IntrStatus lossage if RX state machine resets
From: Mark Brown <broonie@sirena.org.uk>

This patch fixes the poll routine for the natsemi driver so that if the driver
detects an RX state machine lockup then no interrupts will be lost while the
driver recovers from that.

Signed-off-by: Mark Brown <broonie@sirena.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/natsemi.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/net/natsemi.c~natsemi-avoid-intrstatus-lossage-if-rx-state-machine-resets drivers/net/natsemi.c
--- a/drivers/net/natsemi.c~natsemi-avoid-intrstatus-lossage-if-rx-state-machine-resets
+++ a/drivers/net/natsemi.c
@@ -2169,6 +2169,14 @@ static int natsemi_poll(struct net_devic
 			       dev->name, np->intr_status,
 			       readl(ioaddr + IntrMask));
 
+		/* netdev_rx() may read IntrStatus again if the RX state
+		 * machine falls over so do it first. */
+		if (np->intr_status &
+		    (IntrRxDone | IntrRxIntr | RxStatusFIFOOver |
+		     IntrRxErr | IntrRxOverrun)) {
+			netdev_rx(dev, &work_done, work_to_do);
+		}
+
 		if (np->intr_status &
 		    (IntrTxDone | IntrTxIntr | IntrTxIdle | IntrTxErr)) {
 			spin_lock(&np->lock);
@@ -2180,12 +2188,6 @@ static int natsemi_poll(struct net_devic
 		if (np->intr_status & IntrAbnormalSummary)
 			netdev_error(dev, np->intr_status);
 
-		if (np->intr_status &
-		    (IntrRxDone | IntrRxIntr | RxStatusFIFOOver |
-		     IntrRxErr | IntrRxOverrun)) {
-			netdev_rx(dev, &work_done, work_to_do);
-		}
-
 		*budget -= work_done;
 		dev->quota -= work_done;
 
_

Patches currently in -mm which might be from broonie@sirena.org.uk are

natsemi-consistently-use-interrupt-enable-disable-functions.patch
natsemi-fix-napi-for-interrupt-sharing.patch
natsemi-avoid-intrstatus-lossage-if-rx-state-machine-resets.patch
