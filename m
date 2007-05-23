From: akpm@linux-foundation.org
Subject: - fix-crash-with-irqpoll-due-to-the-irqf_irqpoll-flag.patch removed from -mm tree
Date: Wed, 23 May 2007 14:51:57 -0700
Message-ID: <200705232151.l4NLpwfl002083@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755439AbXEWVwx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 17:52:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, tglx@linutronix.de, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Fix crash with irqpoll due to the IRQF_IRQPOLL flag
has been removed from the -mm tree.  Its filename was
     fix-crash-with-irqpoll-due-to-the-irqf_irqpoll-flag.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Fix crash with irqpoll due to the IRQF_IRQPOLL flag
From: Bernhard Walle <bwalle@suse.de>

o System crashes if booted with irqpoll command line option.

o Problem happens because Inside note_interrupt() we are accessing
  desc->action->flag without taking the desc->lock. While accessing it
  somebody goes ahead and unregisters the irq handler hence desc->action
  is NULL. By the time note_interrupt() checks it, it crashes.

o In that system it is irq 4 serving the serial driver.

o Take the desc->lock before accessing desc->action->flag.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/spurious.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff -puN kernel/irq/spurious.c~fix-crash-with-irqpoll-due-to-the-irqf_irqpoll-flag kernel/irq/spurious.c
--- a/kernel/irq/spurious.c~fix-crash-with-irqpoll-due-to-the-irqf_irqpoll-flag
+++ a/kernel/irq/spurious.c
@@ -138,6 +138,8 @@ report_bad_irq(unsigned int irq, struct 
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
+	int call_misrouted_irq = 0;
+
 	if (unlikely(action_ret != IRQ_HANDLED)) {
 		desc->irqs_unhandled++;
 		if (unlikely(action_ret != IRQ_NONE))
@@ -146,9 +148,24 @@ void note_interrupt(unsigned int irq, st
 
 	if (unlikely(irqfixup)) {
 		/* Don't punish working computers */
-		if ((irqfixup == 2 && ((irq == 0) ||
-				(desc->action->flags & IRQF_IRQPOLL))) ||
-				action_ret == IRQ_NONE) {
+		if (action_ret == IRQ_NONE)
+			/* Nobody handled irq. Possibly a misrouted one. */
+			call_misrouted_irq = 1;
+		else if (irqfixup == 2) {
+			/* irqpoll is enabled. Is this the irq driving
+			 * polling.
+			 */
+			if (irq == 0)
+				call_misrouted_irq = 1;
+			else {
+				spin_lock(&desc->lock);
+				if (desc->action &&
+					(desc->action->flags & IRQF_IRQPOLL))
+					call_misrouted_irq = 1;
+				spin_unlock(&desc->lock);
+			}
+		}
+		if (call_misrouted_irq) {
 			int ok = misrouted_irq(irq);
 			if (action_ret == IRQ_NONE)
 				desc->irqs_unhandled -= ok;
_

Patches currently in -mm which might be from bwalle@suse.de are

git-r8169.patch
scsi-remove-__gfp_dma.patch
fix-crash-with-irqpoll-due-to-the-irqf_irqpoll-flag.patch
