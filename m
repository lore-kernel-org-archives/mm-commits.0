From: akpm@linux-foundation.org
Subject: + um-migrate-from-__do_irq-to-generic_handle_irq.patch added to -mm tree
Date: Mon, 11 Oct 2010 15:16:54 -0700
Message-ID: <201010112216.o9BMGsiK021256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756703Ab0JKWRq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Oct 2010 18:17:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, a.p.zijlstra@chello.nl, jdike@addtoit.com, tglx@linutronix.de


The patch titled
     um: migrate from __do_IRQ() to generic_handle_irq()
has been added to the -mm tree.  Its filename is
     um-migrate-from-__do_irq-to-generic_handle_irq.patch

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
Subject: um: migrate from __do_IRQ() to generic_handle_irq()
From: Richard Weinberger <richard@nod.at>

This patch removes __do_IRQ() from user mode linux.  __do_IRQ is deprecated.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.um   |    3 +++
 arch/um/kernel/irq.c |   15 ++++-----------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff -puN arch/um/Kconfig.um~um-migrate-from-__do_irq-to-generic_handle_irq arch/um/Kconfig.um
--- a/arch/um/Kconfig.um~um-migrate-from-__do_irq-to-generic_handle_irq
+++ a/arch/um/Kconfig.um
@@ -120,6 +120,9 @@ config SMP
 
 	  If you don't know what to do, say N.
 
+config GENERIC_HARDIRQS_NO__DO_IRQ
+	def_bool y
+
 config NR_CPUS
 	int "Maximum number of CPUs (2-32)"
 	range 2 32
diff -puN arch/um/kernel/irq.c~um-migrate-from-__do_irq-to-generic_handle_irq arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~um-migrate-from-__do_irq-to-generic_handle_irq
+++ a/arch/um/kernel/irq.c
@@ -334,7 +334,7 @@ unsigned int do_IRQ(int irq, struct uml_
 {
 	struct pt_regs *old_regs = set_irq_regs((struct pt_regs *)regs);
 	irq_enter();
-	__do_IRQ(irq);
+	generic_handle_irq(irq);
 	irq_exit();
 	set_irq_regs(old_regs);
 	return 1;
@@ -391,17 +391,10 @@ void __init init_IRQ(void)
 {
 	int i;
 
-	irq_desc[TIMER_IRQ].status = IRQ_DISABLED;
-	irq_desc[TIMER_IRQ].action = NULL;
-	irq_desc[TIMER_IRQ].depth = 1;
-	irq_desc[TIMER_IRQ].chip = &SIGVTALRM_irq_type;
-	enable_irq(TIMER_IRQ);
+	set_irq_chip_and_handler(TIMER_IRQ, &SIGVTALRM_irq_type, handle_edge_irq);
+
 	for (i = 1; i < NR_IRQS; i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].action = NULL;
-		irq_desc[i].depth = 1;
-		irq_desc[i].chip = &normal_irq_type;
-		enable_irq(i);
+		set_irq_chip_and_handler(i, &normal_irq_type, handle_edge_irq);
 	}
 }
 
_

Patches currently in -mm which might be from richard@nod.at are

um-migrate-from-__do_irq-to-generic_handle_irq.patch

