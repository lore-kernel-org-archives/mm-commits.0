From: akpm@linux-foundation.org
Subject: + b44-fix-resume-request_irq-after-hw-reset.patch added to -mm tree
Date: Thu, 21 Oct 2010 14:40:30 -0700
Message-ID: <201010212140.o9LLeUQE005259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758328Ab0JUVkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 17:40:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: james@albanarts.com, zambrano@broadcom.com


The patch titled
     b44: fix resume, request_irq after hw reset
has been added to the -mm tree.  Its filename is
     b44-fix-resume-request_irq-after-hw-reset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: b44: fix resume, request_irq after hw reset
From: James Hogan <james@albanarts.com>

On resume, call request_irq() after resetting the hardware rather than
before.  It's a shared interrupt so the handler could be called
immediately if another device on the same irq interrupts (and will be
called immediately if CONFIG_DEBUG_SHIRQ=y), but unless the hardware is
reinitialised with b44_init_hw() the read of the interrupt status register
will hang the system.

Signed-off-by: James Hogan <james@albanarts.com>
Cc: Gary Zambrano <zambrano@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/b44.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN drivers/net/b44.c~b44-fix-resume-request_irq-after-hw-reset drivers/net/b44.c
--- a/drivers/net/b44.c~b44-fix-resume-request_irq-after-hw-reset
+++ a/drivers/net/b44.c
@@ -2296,18 +2296,27 @@ static int b44_resume(struct ssb_device 
 	if (!netif_running(dev))
 		return 0;
 
+	spin_lock_irq(&bp->lock);
+	b44_init_rings(bp);
+	b44_init_hw(bp, B44_FULL_RESET);
+	spin_unlock_irq(&bp->lock);
+
+	/*
+	 * As a shared interrupt, the handler can be called immediately. To be
+	 * able to check the interrupt status the hardware must already be
+	 * powered back on (b44_init_hw).
+	 */
 	rc = request_irq(dev->irq, b44_interrupt, IRQF_SHARED, dev->name, dev);
 	if (rc) {
 		netdev_err(dev, "request_irq failed\n");
+		spin_lock_irq(&bp->lock);
+		b44_halt(bp);
+		b44_free_rings(bp);
+		spin_unlock_irq(&bp->lock);
 		return rc;
 	}
 
-	spin_lock_irq(&bp->lock);
