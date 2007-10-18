From: akpm@linux-foundation.org
Subject: - compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:35 -0700
Message-ID: <200710180701.l9I71ZBh031188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45301 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763755AbXJRHQ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Compile handle_percpu_irq even for uniprocessor kernels
has been removed from the -mm tree.  Its filename was
     compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Compile handle_percpu_irq even for uniprocessor kernels
From: Ralf Baechle <ralf@linux-mips.org>

Compiling handle_percpu_irq only on uniprocessor generates an artificial
special case so a typical use like:

  set_irq_chip_and_handler(irq, &some_irq_type, handle_percpu_irq);

needs to be conditionally compiled only on SMP systems as well and an
alternative UP construct is usually needed - for no good reason.

This fixes uniprocessor configurations for some MIPS SMP systems.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/chip.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/irq/chip.c~compile-handle_percpu_irq-even-for-uniprocessor-kernels kernel/irq/chip.c
--- a/kernel/irq/chip.c~compile-handle_percpu_irq-even-for-uniprocessor-kernels
+++ a/kernel/irq/chip.c
@@ -503,7 +503,6 @@ out_unlock:
 	spin_unlock(&desc->lock);
 }
 
-#ifdef CONFIG_SMP
 /**
  *	handle_percpu_IRQ - Per CPU local irq handler
  *	@irq:	the interrupt number
@@ -529,8 +528,6 @@ handle_percpu_irq(unsigned int irq, stru
 		desc->chip->eoi(irq);
 }
 
-#endif /* CONFIG_SMP */
-
 void
 __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name)
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
netport_conc-fix-build-errors-and-warnings.patch
au1100fb-fix-modpost-warnings.patch
logoc-get-rid-of-mips_machgroup.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
replace-__attribute_pure__-with-__pure.patch
