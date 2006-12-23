From: akpm@osdl.org
Subject: - smc911x-fix-netpoll-compilation-faliure.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:58 -0800
Message-ID: <200612230753.kBN7rwZb010174@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbWLWHyi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:54:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, jeff@garzik.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     smc911x: fix netpoll compilation faliure
has been removed from the -mm tree.  Its filename was
     smc911x-fix-netpoll-compilation-faliure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: smc911x: fix netpoll compilation faliure
From: Vitaly Wool <vitalywool@gmail.com>

Fix the compilation failure for smc911x.c when NET_POLL_CONTROLLER is set.

Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/smc911x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/smc911x.c~smc911x-fix-netpoll-compilation-faliure drivers/net/smc911x.c
--- a/drivers/net/smc911x.c~smc911x-fix-netpoll-compilation-faliure
+++ a/drivers/net/smc911x.c
@@ -1331,7 +1331,7 @@ smc911x_rx_dma_irq(int dma, void *data)
 static void smc911x_poll_controller(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	smc911x_interrupt(dev->irq, dev, NULL);
+	smc911x_interrupt(dev->irq, dev);
 	enable_irq(dev->irq);
 }
 #endif
_

Patches currently in -mm which might be from vitalywool@gmail.com are

origin.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch

