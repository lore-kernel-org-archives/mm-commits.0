From: akpm@linux-foundation.org
Subject: + smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch added to -mm tree
Date: Thu, 27 Mar 2008 12:32:06 -0700
Message-ID: <200803271932.m2RJW6W4018580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756712AbYC0TcY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 15:32:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonic.zhang@analog.com, cooloney@kernel.org, jeff@garzik.org


The patch titled
     smc91x driver: fix bug: print warning only in interrupt mode
has been added to the -mm tree.  Its filename is
     smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smc91x driver: fix bug: print warning only in interrupt mode
From: Sonic Zhang <sonic.zhang@analog.com>

http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3956

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc91x.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/net/smc91x.c~smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode drivers/net/smc91x.c
--- a/drivers/net/smc91x.c~smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode
+++ a/drivers/net/smc91x.c
@@ -1326,9 +1326,11 @@ static irqreturn_t smc_interrupt(int irq
 	SMC_SET_INT_MASK(lp, mask);
 	spin_unlock(&lp->lock);
 
+#ifndef CONFIG_NET_POLL_CONTROLLER
 	if (timeout == MAX_IRQ_LOOPS)
 		PRINTK("%s: spurious interrupt (mask = 0x%02x)\n",
 		       dev->name, mask);
+#endif
 	DBG(3, "%s: Interrupt done (%d loops)\n",
 	       dev->name, MAX_IRQ_LOOPS - timeout);
 
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch

