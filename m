From: akpm@linux-foundation.org
Subject: + add-irqf_irqpoll-flag-common-code.patch added to -mm tree
Date: Tue, 27 Mar 2007 14:02:11 -0700
Message-ID: <200703272102.l2RL2BY4027669@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43035 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965419AbXC0VFA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 17:05:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, alan@lxorguk.ukuu.org.uk, grundler@google.com, kyle@mcmartin.ca, lethal@linux-sh.org, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, tony.luck@intel.com, willy@debian.org


The patch titled
     Add IRQF_IRQPOLL flag (common code)
has been added to the -mm tree.  Its filename is
     add-irqf_irqpoll-flag-common-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add IRQF_IRQPOLL flag (common code)
From: Bernhard Walle <bwalle@suse.de>

irqpoll is broken on some architectures that don't use the IRQ 0 for the timer
interrupt like IA64.  This patch adds a IRQF_IRQPOLL flag.

Each architecture is handled in a separate pach.  As I left the irq == 0 as
condition, this should not break existing architectures that use timer_irq ==
0 and that I did't address with that patch (because I don't know).


This patch:

This patch adds a IRQF_IRQPOLL flag that the interrupt registration code could
use for the interrupt it wants to use for IRQ polling.

Because this must not be the timer interrupt, an additional flag was added
instead of re-using the IRQF_TIMER constant.  Until all architectures will
have an IRQF_IRQPOLL interrupt, irq == 0 will stay as alternative as it should
not break anything.

Also, note_interrupt() is called on CPU-specific interrupts to be used as
interrupt source for IRQ polling.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Grant Grundler <grundler@google.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |    4 ++++
 kernel/irq/handle.c       |    2 ++
 kernel/irq/spurious.c     |    4 +++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff -puN include/linux/interrupt.h~add-irqf_irqpoll-flag-common-code include/linux/interrupt.h
--- a/include/linux/interrupt.h~add-irqf_irqpoll-flag-common-code
+++ a/include/linux/interrupt.h
@@ -44,6 +44,9 @@
  * IRQF_TIMER - Flag to mark this interrupt as timer interrupt
  * IRQF_PERCPU - Interrupt is per cpu
  * IRQF_NOBALANCING - Flag to exclude this interrupt from irq balancing
+ * IRQF_IRQPOLL - Interrupt is used for polling (only the interrupt that is
+ *                registered first in an shared interrupt is considered for
+ *                performance reasons)
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -52,6 +55,7 @@
 #define IRQF_TIMER		0x00000200
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
+#define IRQF_IRQPOLL		0x00001000
 
 /*
  * Migration helpers. Scheduled for removal in 1/2007
diff -puN kernel/irq/handle.c~add-irqf_irqpoll-flag-common-code kernel/irq/handle.c
--- a/kernel/irq/handle.c~add-irqf_irqpoll-flag-common-code
+++ a/kernel/irq/handle.c
@@ -180,6 +180,8 @@ fastcall unsigned int __do_IRQ(unsigned 
 		if (desc->chip->ack)
 			desc->chip->ack(irq);
 		action_ret = handle_IRQ_event(irq, desc->action);
+		if (!noirqdebug)
+			note_interrupt(irq, desc, action_ret);
 		desc->chip->end(irq);
 		return 1;
 	}
diff -puN kernel/irq/spurious.c~add-irqf_irqpoll-flag-common-code kernel/irq/spurious.c
--- a/kernel/irq/spurious.c~add-irqf_irqpoll-flag-common-code
+++ a/kernel/irq/spurious.c
@@ -146,7 +146,9 @@ void note_interrupt(unsigned int irq, st
 
 	if (unlikely(irqfixup)) {
 		/* Don't punish working computers */
-		if ((irqfixup == 2 && irq == 0) || action_ret == IRQ_NONE) {
+		if ((irqfixup == 2 && ((irq == 0) ||
+				(desc->action->flags & IRQF_IRQPOLL))) ||
+				action_ret == IRQ_NONE) {
 			int ok = misrouted_irq(irq);
 			if (action_ret == IRQ_NONE)
 				desc->irqs_unhandled -= ok;
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
git-r8169.patch
use-unchecked_isa_dma-in-sd_revalidate_disk.patch
x86_64-i386-add-command-line-length-to-boot-protocol.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-parisc.patch
add-irqf_irqpoll-flag-on-arm.patch
