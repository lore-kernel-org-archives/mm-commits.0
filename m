From: akpm@linux-foundation.org
Subject: + avr32-remove-obsolete-hw_interrupt_type.patch added to -mm tree
Date: Mon, 04 May 2009 15:05:49 -0700
Message-ID: <200905042205.n44M5oba027591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757302AbZEDWIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 18:08:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, skinnemoen@atmel.com


The patch titled
     avr32: remove obsolete hw_interrupt_type
has been added to the -mm tree.  Its filename is
     avr32-remove-obsolete-hw_interrupt_type.patch

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
x86-simplify-highmem-related-kconfig-entries.patch
x86-enable-gart-iommu-only-after-setting-up-protection-methods.patch
kernel-time-tick-broadcastc-tick_broadcast_device-can-become-static.patch
timers-allow-deferrable-timers-for-intervals-tv2-tv5-to-be-deferred.patch
time-move-calc_load-call-out-from-xtime_lock-protection.patch
time-avoid-possible-endless-loop-when-using-jiffies-clocksource-and-oneshot-mode-clockevent.patch
clockevent-export-register_device-and-delta2ns.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch
revert-genirq-assert-that-irq-handlers-are-indeed-running-in-hardirq-context.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
ia64-remove-obsolete-no_irq_type.patch
ia64-remove-obsolete-irq_desc_t-typedef.patch
drivers-mfd-remove-obsolete-irq_desc_t-typedef.patch
alpha-remove-obsolete-hw_interrupt_type.patch
avr32-remove-obsolete-hw_interrupt_type.patch
ia64-remove-obsolete-hw_interrupt_type.patch
m32r-remove-obsolete-hw_interrupt_type.patch
parisc-remove-obsolete-hw_interrupt_type.patch
um-remove-obsolete-hw_interrupt_type.patch

