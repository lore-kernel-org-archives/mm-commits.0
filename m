From: akpm@linux-foundation.org
Subject: - move-functions-declarations-to-header-file.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:06 -0700
Message-ID: <200707192010.l6JKA6gE020641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36684 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756658AbXGSUPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Move functions declarations to header file
has been removed from the -mm tree.  Its filename was
     move-functions-declarations-to-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Move functions declarations to header file
From: Glauber de Oliveira Costa <gcosta@redhat.com>

Some interrupt entry points are currently defined in i8259.c They probably
belong in a header.  Right now, their only user is init_IRQ, justifying
their declaration in-file.  But when virtualization comes in, we may be
interested in using that functions in late initializations.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/i8259.c  |   18 ------------------
 include/asm-x86_64/hw_irq.h |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 18 deletions(-)

diff -puN arch/x86_64/kernel/i8259.c~move-functions-declarations-to-header-file arch/x86_64/kernel/i8259.c
--- a/arch/x86_64/kernel/i8259.c~move-functions-declarations-to-header-file
+++ a/arch/x86_64/kernel/i8259.c
@@ -444,24 +444,6 @@ void __init init_ISA_irqs (void)
 	}
 }
 
-void apic_timer_interrupt(void);
-void spurious_interrupt(void);
-void error_interrupt(void);
-void reschedule_interrupt(void);
-void call_function_interrupt(void);
-void irq_move_cleanup_interrupt(void);
-void invalidate_interrupt0(void);
-void invalidate_interrupt1(void);
-void invalidate_interrupt2(void);
-void invalidate_interrupt3(void);
-void invalidate_interrupt4(void);
-void invalidate_interrupt5(void);
-void invalidate_interrupt6(void);
-void invalidate_interrupt7(void);
-void thermal_interrupt(void);
-void threshold_interrupt(void);
-void i8254_timer_resume(void);
-
 static void setup_timer_hardware(void)
 {
 	outb_p(0x34,0x43);		/* binary, mode 2, LSB/MSB, ch 0 */
diff -puN include/asm-x86_64/hw_irq.h~move-functions-declarations-to-header-file include/asm-x86_64/hw_irq.h
--- a/include/asm-x86_64/hw_irq.h~move-functions-declarations-to-header-file
+++ a/include/asm-x86_64/hw_irq.h
@@ -95,6 +95,26 @@
 
 
 #ifndef __ASSEMBLY__
+
+/* Interrupt handlers registered during init_IRQ */
+void apic_timer_interrupt(void);
+void spurious_interrupt(void);
+void error_interrupt(void);
+void reschedule_interrupt(void);
+void call_function_interrupt(void);
+void irq_move_cleanup_interrupt(void);
+void invalidate_interrupt0(void);
+void invalidate_interrupt1(void);
+void invalidate_interrupt2(void);
+void invalidate_interrupt3(void);
+void invalidate_interrupt4(void);
+void invalidate_interrupt5(void);
+void invalidate_interrupt6(void);
+void invalidate_interrupt7(void);
+void thermal_interrupt(void);
+void threshold_interrupt(void);
+void i8254_timer_resume(void);
+
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
 extern void __setup_vector_irq(int cpu);
_

Patches currently in -mm which might be from gcosta@redhat.com are
