From: akpm@linux-foundation.org
Subject: [to-be-updated] irq-free-setup_irq-interrupt-using-free_irq.patch removed from -mm tree
Date: Tue, 10 Mar 2009 15:01:54 -0700
Message-ID: <200903102201.n2AM1sri010209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757554AbZCJWE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 18:04:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@igel.co.jp, lethal@linux-sh.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     irq: free setup_irq() interrupt using free_irq()
has been removed from the -mm tree.  Its filename was
     irq-free-setup_irq-interrupt-using-free_irq.patch

This patch was dropped because an updated version will be merged

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

On Tue, 2 Dec 2008 10:15:46 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> no. Instead of twisting the code flow in this function even more, this 
> should be done cleanly by introducing a helper: __free_irq(), which takes 
> out the guts of free_irq() tha does the non-action related irqchip 
> machinery bits.
> 
> Then change free_irq() to call __free_irq() in the middle, and also 
> provide the __free_irq() function to architecture code. (but do not 
> export it to drivers as it's obviously a dangerous lowlevel facility)
> 

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |    2 ++
 kernel/irq/manage.c       |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/interrupt.h~irq-free-setup_irq-interrupt-using-free_irq include/linux/interrupt.h
--- a/include/linux/interrupt.h~irq-free-setup_irq-interrupt-using-free_irq
+++ a/include/linux/interrupt.h
@@ -49,6 +49,7 @@
  * IRQF_IRQPOLL - Interrupt is used for polling (only the interrupt that is
  *                registered first in an shared interrupt is considered for
  *                performance reasons)
+ * IRQF_STATIC - Interrupt requested with setup_irq(), do not kfree().
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -58,6 +59,7 @@
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
+#define IRQF_STATIC		0x00002000
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
diff -puN kernel/irq/manage.c~irq-free-setup_irq-interrupt-using-free_irq kernel/irq/manage.c
--- a/kernel/irq/manage.c~irq-free-setup_irq-interrupt-using-free_irq
+++ a/kernel/irq/manage.c
@@ -547,6 +547,7 @@ int setup_irq(unsigned int irq, struct i
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
+	act->flags |= IRQF_STATIC;
 	return __setup_irq(irq, desc, act);
 }
 
@@ -639,7 +640,8 @@ void free_irq(unsigned int irq, void *de
 		local_irq_restore(flags);
 	}
 #endif
-	kfree(action);
+	if (!(action->flags & IRQF_STATIC))
+		kfree(action);
 }
 EXPORT_SYMBOL(free_irq);
 
_

Patches currently in -mm which might be from damm@igel.co.jp are

linux-next.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-add-enable-and-disable-callbacks.patch
irq-free-setup_irq-interrupt-using-free_irq.patch
pm-rework-includes-remove-arch-ifdefs-v2.patch
pm-cleanup-includes.patch

