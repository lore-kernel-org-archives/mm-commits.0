From: akpm@linux-foundation.org
Subject: - __do_irq-does-not-check-irq_disabled-when-irq_per_cpu-is-set.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:49 -0800
Message-ID: <200711152110.lAFLAn0l015691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932679AbXKOVSD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:18:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rja@sgi.com, bjorn.helgaas@hp.com, mingo@elte.hu, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     __do_IRQ does not check IRQ_DISABLED when IRQ_PER_CPU is set
has been removed from the -mm tree.  Its filename was
     __do_irq-does-not-check-irq_disabled-when-irq_per_cpu-is-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: __do_IRQ does not check IRQ_DISABLED when IRQ_PER_CPU is set
From: Russ Anderson <rja@sgi.com>

In __do_IRQ(), the normal case is that IRQ_DISABLED is checked and if set
the handler (handle_IRQ_event()) is not called.

Earlier in __do_IRQ(), if IRQ_PER_CPU is set the code does not check
IRQ_DISABLED and calls the handler even though IRQ_DISABLED is set.  This
behavior seems unintentional.

One user encountering this behavior is the CPE handler (in
arch/ia64/kernel/mca.c).  When the CPE handler encounters too many CPEs
(such as a solid single bit error), it sets up a polling timer and disables
the CPE interrupt (to avoid excessive overhead logging the stream of single
bit errors).  disable_irq_nosync() is called which sets IRQ_DISABLED.  The
IRQ_PER_CPU flag was previously set (in ia64_mca_late_init()).  The net
result is the CPE handler gets called even though it is marked disabled.

If the behavior of not checking IRQ_DISABLED when IRQ_PER_CPU is set is
intentional, it would be worthy of a comment describing the intended
behavior.  disable_irq_nosync() does call chip->disable() to provide a
chipset specifiec interface for disabling the interrupt, which avoids this
issue when used.

Signed-off-by: Russ Anderson <rja@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/handle.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/irq/handle.c~__do_irq-does-not-check-irq_disabled-when-irq_per_cpu-is-set kernel/irq/handle.c
--- a/kernel/irq/handle.c~__do_irq-does-not-check-irq_disabled-when-irq_per_cpu-is-set
+++ a/kernel/irq/handle.c
@@ -178,9 +178,11 @@ fastcall unsigned int __do_IRQ(unsigned 
 		 */
 		if (desc->chip->ack)
 			desc->chip->ack(irq);
-		action_ret = handle_IRQ_event(irq, desc->action);
-		if (!noirqdebug)
-			note_interrupt(irq, desc, action_ret);
+		if (likely(!(desc->status & IRQ_DISABLED))) {
+			action_ret = handle_IRQ_event(irq, desc->action);
+			if (!noirqdebug)
+				note_interrupt(irq, desc, action_ret);
+		}
 		desc->chip->end(irq);
 		return 1;
 	}
_

Patches currently in -mm which might be from rja@sgi.com are

origin.patch
