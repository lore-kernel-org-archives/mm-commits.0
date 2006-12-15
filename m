From: akpm@osdl.org
Subject: + smc911x-fix-netpoll-compilation-faliure.patch added to -mm tree
Date: Fri, 15 Dec 2006 12:43:27 -0800
Message-ID: <200612152043.kBFKhRth029191@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43053 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964793AbWLOUnq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 15:43:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vitalywool@gmail.com, jeff@garzik.org


The patch titled
     smc911x: fix netpoll compilation faliure
has been added to the -mm tree.  Its filename is
     smc911x-fix-netpoll-compilation-faliure.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: smc911x: fix netpoll compilation faliure
From: Vitaly Wool <vitalywool@gmail.com>

Fix the compilation failure for smc911x.c when NET_POLL_CONTROLLER is set.

Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/smc911x.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

smc911x-fix-netpoll-compilation-faliure.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch

