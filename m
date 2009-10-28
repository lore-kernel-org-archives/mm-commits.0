From: akpm@linux-foundation.org
Subject: + uml-irq-register-race-condition.patch added to -mm tree
Date: Wed, 28 Oct 2009 13:24:40 -0700
Message-ID: <200910282024.n9SKOfhi004400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755399AbZJ1UZr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 16:25:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrew@lunn.ch, adobriyan@gmail.com, jdike@addtoit.com, mingo@elte.hu, tglx@linutronix.de, yinghai@kernel.org


The patch titled
     uml: IRQ register race condition
has been added to the -mm tree.  Its filename is
     uml-irq-register-race-condition.patch

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

uml-irq-register-race-condition.patch

