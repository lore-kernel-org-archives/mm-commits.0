From: akpm@linux-foundation.org
Subject: + natsemi-improve-diagnostics-for-dspcfg-workaround.patch added to -mm tree
Date: Thu, 03 May 2007 12:59:09 -0700
Message-ID: <200705031959.l43Jx9qJ018596@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbXECUDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 16:03:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@sirena.org.uk, jeff@garzik.org, thockin@hockin.org


The patch titled
     natsemi: Improve diagnostics for DspCfg workaround
has been added to the -mm tree.  Its filename is
     natsemi-improve-diagnostics-for-dspcfg-workaround.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: natsemi: Improve diagnostics for DspCfg workaround
From: Mark Brown <broonie@sirena.org.uk>

The natsemi driver has a workaround for broken hardware which resets itself
from time to time.  There is a diagnostic message for this workaround but it
is not printed by default, making the driver behavior more obscure than it
needs to be.  Make the message be displayed by default.

Signed-off-by: Mark Brown <broonie@sirena.org.uk>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/natsemi.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/natsemi.c~natsemi-improve-diagnostics-for-dspcfg-workaround drivers/net/natsemi.c
--- a/drivers/net/natsemi.c~natsemi-improve-diagnostics-for-dspcfg-workaround
+++ a/drivers/net/natsemi.c
@@ -1756,7 +1756,7 @@ static void netdev_timer(unsigned long d
 		if (dspcfg != np->dspcfg) {
 			if (!netif_queue_stopped(dev)) {
 				spin_unlock_irq(&np->lock);
-				if (netif_msg_hw(np))
+				if (netif_msg_drv(np))
 					printk(KERN_NOTICE "%s: possible phy reset: "
 						"re-initializing\n", dev->name);
 				disable_irq(dev->irq);
_

Patches currently in -mm which might be from broonie@sirena.org.uk are

natsemi-improve-diagnostics-for-dspcfg-workaround.patch
subject-natsemi-allow-users-to-disable-workaround-for.patch
