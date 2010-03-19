From: akpm@linux-foundation.org
Subject: [to-be-updated] genirq-introduce-irqf_allow_nested-flag-for-request_irq.patch removed from -mm tree
Date: Fri, 19 Mar 2010 16:34:18 -0700
Message-ID: <201003192334.o2JNYIPl018573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812Ab0CSXex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:34:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maz@misterjones.org, joachim.eastwood@jotron.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     genirq: introduce IRQF_ALLOW_NESTED flag for request_irq()
has been removed from the -mm tree.  Its filename was
     genirq-introduce-irqf_allow_nested-flag-for-request_irq.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genirq: introduce IRQF_ALLOW_NESTED flag for request_irq()
From: Marc Zyngier <maz@misterjones.org>

Now that we enjoy threaded interrupts, we're starting to see irq_chip
implementations (wm831x, pca953x) that make use of threaded interrupts for
the controller, and nested interrupts for the client interrupt.  It all
works very well, with one drawback:

Drivers requesting an IRQ must now know whether the handler will run in a
thread context of not, and call request_threaded_irq() or request_irq()
accordingly.

The problem is that the requesting driver sometimes doesn't know about the
nature of the interrupt, specially when the interrupt controller is a
discrete chip (typically a GPIO expander connected over I2C) that can be
connected to a wide variety of otherwise perfectly supported hardware.

The following patch introduces the IRQF_ALLOW_NESTED flag, that acts as a
"contract" between the driver and the genirq framework.  By using this
flag as part of the request_irq() call, the driver informs the genirq
framework that the handler will happily run either in hardirq or nested
context, without any ill effect.

The benefit of this is a single API for drivers.  It still requires the
driver to be audited, and the flag added to the request_irq() call.

Of course, this goes against Linus choice of having separate APIs for both
cases.  The only alternative I can imagine for this is to use
request_threaded_irq() with the same function provided for both the
handler and the threaded handler.  Ugly...

This patch has been tested on ARM and Blackfin platforms.

Signed-off-by: Marc Zyngier <maz@misterjones.org>
Tested-by: Joachim Eastwood <joachim.eastwood@jotron.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |    3 +++
 kernel/irq/manage.c       |   12 +++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff -puN include/linux/interrupt.h~genirq-introduce-irqf_allow_nested-flag-for-request_irq include/linux/interrupt.h
--- a/include/linux/interrupt.h~genirq-introduce-irqf_allow_nested-flag-for-request_irq
+++ a/include/linux/interrupt.h
@@ -52,6 +52,8 @@
  * IRQF_ONESHOT - Interrupt is not reenabled after the hardirq handler finished.
  *                Used by threaded interrupts which need to keep the
  *                irq line disabled until the threaded handler has been run.
+ * IRQF_ALLOW_NESTED - Handler can be either run as hardirq or nested
+ *		       interrupt.
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -62,6 +64,7 @@
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
 #define IRQF_ONESHOT		0x00002000
+#define IRQF_ALLOW_NESTED	0x00004000
 
 /*
  * Bits used by threaded handlers:
diff -puN kernel/irq/manage.c~genirq-introduce-irqf_allow_nested-flag-for-request_irq kernel/irq/manage.c
--- a/kernel/irq/manage.c~genirq-introduce-irqf_allow_nested-flag-for-request_irq
+++ a/kernel/irq/manage.c
@@ -641,12 +641,18 @@ __setup_irq(unsigned int irq, struct irq
 
 	/*
 	 * Check whether the interrupt nests into another interrupt
-	 * thread.
+	 * thread. Nested interrupt must provide a thread function
+	 * unless it raises the IRQF_ALLOW_NESTED flag.
 	 */
 	nested = desc->status & IRQ_NESTED_THREAD;
 	if (nested) {
-		if (!new->thread_fn)
-			return -EINVAL;
+		if (!new->thread_fn) {
+			if (new->flags & IRQF_ALLOW_NESTED)
+				new->thread_fn = new->handler;
+			else
+				return -EINVAL;
+		}
+
 		/*
 		 * Replace the primary handler which was provided from
 		 * the driver for non nested interrupt handling by the
_

Patches currently in -mm which might be from maz@misterjones.org are

origin.patch
genirq-introduce-irqf_allow_nested-flag-for-request_irq.patch

