From: akpm@google.com
Subject: [wrecked] tracex86-add-tracepoint-to-x86-timer-interrupt-handler.patch removed from -mm tree
Date: Tue, 27 Sep 2011 12:06:18 -0700
Message-ID: <201109271906.p8RJ6IA3016901@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:18305 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1I0TGh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2011 15:06:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vnagarnaik@google.com, a.p.zijlstra@chello.nl, dhsharp@google.com, fweisbec@gmail.com, mingo@redhat.com, mrubin@google.com, rostedt@goodmis.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: trace,x86: add tracepoint to x86 timer interrupt handler
has been removed from the -mm tree.  Its filename was
     tracex86-add-tracepoint-to-x86-timer-interrupt-handler.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: trace,x86: add tracepoint to x86 timer interrupt handler

The x86 timer interrupt handler is the only handler not traced in the
irq/irq_handler_{entry|exit} trace events.

Add tracepoints to the interrupt handler to trace it.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/time.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN arch/x86/kernel/time.c~tracex86-add-tracepoint-to-x86-timer-interrupt-handler arch/x86/kernel/time.c
--- a/arch/x86/kernel/time.c~tracex86-add-tracepoint-to-x86-timer-interrupt-handler
+++ a/arch/x86/kernel/time.c
@@ -52,6 +52,13 @@ unsigned long profile_pc(struct pt_regs 
 }
 EXPORT_SYMBOL(profile_pc);
 
+static irqreturn_t timer_interrupt(int irq, void *dev_id);
+static struct irqaction irq0  = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
+	.name = "timer"
+};
+
 /*
  * Default timer interrupt handler for PIT/HPET
  */
@@ -60,7 +67,9 @@ static irqreturn_t timer_interrupt(int i
 	/* Keep nmi watchdog up to date */
 	inc_irq_stat(irq0_irqs);
 
+	trace_irq_handler_entry(irq, &irq0);
 	global_clock_event->event_handler(global_clock_event);
+	trace_irq_handler_exit(irq, &irq0, 1);
 
 	/* MCA bus quirk: Acknowledge irq0 by setting bit 7 in port 0x61 */
 	if (MCA_bus)
@@ -69,12 +78,6 @@ static irqreturn_t timer_interrupt(int i
 	return IRQ_HANDLED;
 }
 
-static struct irqaction irq0  = {
-	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
-	.name = "timer"
-};
