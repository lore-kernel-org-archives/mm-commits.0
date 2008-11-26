From: akpm@linux-foundation.org
Subject: + irq-free-setup_irq-interrupt-using-free_irq.patch added to -mm tree
Date: Tue, 25 Nov 2008 16:03:25 -0800
Message-ID: <200811260003.mAQ03P6p030711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbYKZADn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 19:03:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@igel.co.jp, lethal@linux-sh.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     irq: free setup_irq() interrupt using free_irq()
has been added to the -mm tree.  Its filename is
     irq-free-setup_irq-interrupt-using-free_irq.patch

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
Subject: irq: free setup_irq() interrupt using free_irq()
From: Magnus Damm <damm@igel.co.jp>

Add support for using free_irq() on interrupts allocated with setup_irq().
 Without this patch the kernel will try to kfree() the struct irqaction
passed as argument to setup_irq().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |    2 ++
 kernel/irq/manage.c       |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/interrupt.h~irq-free-setup_irq-interrupt-using-free_irq include/linux/interrupt.h
--- a/include/linux/interrupt.h~irq-free-setup_irq-interrupt-using-free_irq
+++ a/include/linux/interrupt.h
@@ -48,6 +48,7 @@
  * IRQF_IRQPOLL - Interrupt is used for polling (only the interrupt that is
  *                registered first in an shared interrupt is considered for
  *                performance reasons)
+ * IRQF_STATIC - Interrupt requested with setup_irq(), do not kfree().
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -57,6 +58,7 @@
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
+#define IRQF_STATIC		0x00002000
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
diff -puN kernel/irq/manage.c~irq-free-setup_irq-interrupt-using-free_irq kernel/irq/manage.c
--- a/kernel/irq/manage.c~irq-free-setup_irq-interrupt-using-free_irq
+++ a/kernel/irq/manage.c
@@ -550,6 +550,7 @@ int setup_irq(unsigned int irq, struct i
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
+	act->flags |= IRQF_STATIC;
 	return __setup_irq(irq, desc, act);
 }
 
@@ -626,7 +627,8 @@ void free_irq(unsigned int irq, void *de
 				local_irq_restore(flags);
 			}
 #endif
-			kfree(action);
+			if (!(action->flags & IRQF_STATIC))
+				kfree(action);
 			return;
 		}
 		printk(KERN_ERR "Trying to free already-free IRQ %d\n", irq);
_

Patches currently in -mm which might be from damm@igel.co.jp are

linux-next.patch
irq-free-setup_irq-interrupt-using-free_irq.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
vmcore-remove-saved_max_pfn-check.patch

