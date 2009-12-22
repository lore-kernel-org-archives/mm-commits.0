From: akpm@linux-foundation.org
Subject: [nacked] uml-irq-register-race-condition.patch removed from -mm tree
Date: Mon, 21 Dec 2009 16:30:44 -0800
Message-ID: <200912220030.nBM0UiR6005587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594AbZLVAcy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 19:32:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew@lunn.ch, adobriyan@gmail.com, jdike@addtoit.com, mingo@elte.hu, tglx@linutronix.de, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     uml: IRQ register race condition
has been removed from the -mm tree.  Its filename was
     uml-irq-register-race-condition.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: IRQ register race condition
From: Andrew Lunn <andrew@lunn.ch>

There is a race condition in um_request_irq().  The SIGIO handling is
first enabled with the call to activate_fd().  The irq handler is then
registered with request_irq().  What can happen is that directly after
activate_fd() the SIGIO goes off and the IRQ source is disabled at the low
level, the pollfd is set to -1.  Since no irq handler has yet been
registered, the interrupt it left disabled at the low level.  The
interrupt handler is then registered, but its too late, the interrupt
source has been disabled at the lower level and is never re-enabled.  To
fix this race condition i swapped the order.  First request_irq() then
activate_fd() the interrupt sources.

There is a second bug.  In 2.6.31 there was a change to the way __do_IRQ()
and friends work for chained interrupt sources.  The old way was that all
chained interrupt handlers were called.  The new way is that the chain is
walked only until a handler returns IRQ_HANDLED or IRQ_WAKE_THREAD. 
uml_net_interrupt() would always return IRQ_HANDLED, irrespective of if
the device really did receive an interrupt or not.  This mean with the new
code only the first device on a chained interrupt ever got its interrupts
handled.  The second/third/...  device never got any interrupts processed.
 I changed uml_net_interrupt() to always return IRQ_NONE so that all
handlers get called on a chained interrupt.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/um/drivers/net_kern.c~uml-irq-register-race-condition arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-irq-register-race-condition
+++ a/arch/um/drivers/net_kern.c
@@ -145,7 +145,7 @@ static irqreturn_t uml_net_interrupt(int
 
 out:
 	spin_unlock(&lp->lock);
-	return IRQ_HANDLED;
+	return IRQ_NONE;
 }
 
 static int uml_net_open(struct net_device *dev)
diff -puN arch/um/kernel/irq.c~uml-irq-register-race-condition arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~uml-irq-register-race-condition
+++ a/arch/um/kernel/irq.c
@@ -346,13 +346,12 @@ int um_request_irq(unsigned int irq, int
 {
 	int err;
 
-	if (fd != -1) {
+	err = request_irq(irq, handler, irqflags, devname, dev_id);
+
+	if (!err && (fd != -1))
 		err = activate_fd(irq, fd, type, dev_id);
-		if (err)
-			return err;
-	}
 
-	return request_irq(irq, handler, irqflags, devname, dev_id);
+	return err;
 }
 
 EXPORT_SYMBOL(um_request_irq);
_

Patches currently in -mm which might be from andrew@lunn.ch are

linux-next.patch
uml-irq-register-race-condition.patch

