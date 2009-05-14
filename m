From: akpm@linux-foundation.org
Subject: [merged] avr32-remove-obsolete-hw_interrupt_type.patch removed from -mm tree
Date: Thu, 14 May 2009 09:10:32 -0700
Message-ID: <200905141610.n4EGAWg6008099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbZENQLN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 May 2009 12:11:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, skinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     avr32: remove obsolete hw_interrupt_type
has been removed from the -mm tree.  Its filename was
     avr32-remove-obsolete-hw_interrupt_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: avr32: remove obsolete hw_interrupt_type
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
Cc: Haavard Skinnemoen <skinnemoen@atmel.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/hw_irq.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/avr32/include/asm/hw_irq.h~avr32-remove-obsolete-hw_interrupt_type arch/avr32/include/asm/hw_irq.h
--- a/arch/avr32/include/asm/hw_irq.h~avr32-remove-obsolete-hw_interrupt_type
+++ a/arch/avr32/include/asm/hw_irq.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_AVR32_HW_IRQ_H
 #define __ASM_AVR32_HW_IRQ_H
 
-static inline void hw_resend_irq(struct hw_interrupt_type *h, unsigned int i)
+static inline void hw_resend_irq(struct irq_chip *h, unsigned int i)
 {
 	/* Nothing to do */
 }
_

Patches currently in -mm which might be from tglx@linutronix.de are

linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
x86-enable-gart-iommu-only-after-setting-up-protection-methods.patch
time-move-calc_load-call-out-from-xtime_lock-protection.patch
time-move-pit_tick_rate-to-linux-timexh.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch
ia64-remove-obsolete-no_irq_type.patch
ia64-remove-obsolete-irq_desc_t-typedef.patch
ia64-remove-obsolete-hw_interrupt_type.patch
drivers-mfd-remove-obsolete-irq_desc_t-typedef.patch
parisc-remove-obsolete-hw_interrupt_type.patch
mfd-pcf50633-fix-unsafe-disable_irq.patch
alpha-remove-obsolete-hw_interrupt_type.patch
m32r-remove-obsolete-hw_interrupt_type.patch
um-remove-obsolete-hw_interrupt_type.patch
kmap_types-make-most-arches-use-generic-header-file.patch
remove-put_cpu_no_resched.patch
remove-put_cpu_no_resched-fix.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch

