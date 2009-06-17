From: akpm@linux-foundation.org
Subject: [merged] um-remove-obsolete-hw_interrupt_type.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:59 -0700
Message-ID: <200906171836.n5HIaxXX002986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760259AbZFQSiA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:38:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     um: remove obsolete hw_interrupt_type
has been removed from the -mm tree.  Its filename was
     um-remove-obsolete-hw_interrupt_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: remove obsolete hw_interrupt_type
From: Thomas Gleixner <tglx@linutronix.de>

The defines and typedefs (hw_interrupt_type, no_irq_type, irq_desc_t) have
been kept around for migration reasons.  After more than two years it's
time to remove them finally.

This patch cleans up one of the remaining users.  When all such patches
hit mainline we can remove the defines and typedefs finally.

Impact: cleanup

Convert the last remaining users to struct irq_chip and remove the
define.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/irq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/um/kernel/irq.c~um-remove-obsolete-hw_interrupt_type arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~um-remove-obsolete-hw_interrupt_type
+++ a/arch/um/kernel/irq.c
@@ -358,7 +358,7 @@ EXPORT_SYMBOL(um_request_irq);
 EXPORT_SYMBOL(reactivate_fd);
 
 /*
- * hw_interrupt_type must define (startup || enable) &&
+ * irq_chip must define (startup || enable) &&
  * (shutdown || disable) && end
  */
 static void dummy(unsigned int irq)
@@ -366,7 +366,7 @@ static void dummy(unsigned int irq)
 }
 
 /* This is used for everything else than the timer. */
-static struct hw_interrupt_type normal_irq_type = {
+static struct irq_chip normal_irq_type = {
 	.typename = "SIGIO",
 	.release = free_irq_by_irq_and_dev,
 	.disable = dummy,
@@ -375,7 +375,7 @@ static struct hw_interrupt_type normal_i
 	.end = dummy
 };
 
-static struct hw_interrupt_type SIGVTALRM_irq_type = {
+static struct irq_chip SIGVTALRM_irq_type = {
 	.typename = "SIGVTALRM",
 	.release = free_irq_by_irq_and_dev,
 	.shutdown = dummy, /* never called */
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
ia64-remove-obsolete-no_irq_type.patch
ia64-remove-obsolete-irq_desc_t-typedef.patch
ia64-remove-obsolete-hw_interrupt_type.patch
parisc-remove-obsolete-hw_interrupt_type.patch
x86-fix-cpufreq-tsc-scaling.patch

