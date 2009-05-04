From: akpm@linux-foundation.org
Subject: + drivers-mfd-remove-obsolete-irq_desc_t-typedef.patch added to -mm tree
Date: Mon, 04 May 2009 15:05:44 -0700
Message-ID: <200905042205.n44M5kQ9027501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754021AbZEDWIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 18:08:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, dbrownell@users.sourceforge.net


The patch titled
     drivers/mfd: remove obsolete irq_desc_t typedef
has been added to the -mm tree.  Its filename is
     drivers-mfd-remove-obsolete-irq_desc_t-typedef.patch

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
Subject: drivers/mfd: remove obsolete irq_desc_t typedef
From: Thomas Gleixner <tglx@linutronix.de>

The defines and typedefs (hw_interrupt_type, no_irq_type, irq_desc_t) have
been kept around for migration reasons.  After more than two years it's
time to remove them finally.

This patch cleans up one of the remaining users.  When all such patches
hit mainline we can remove the defines and typedefs finally.

Impact: cleanup

Convert the last remaining users and remove the typedef.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/twl4030-irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/twl4030-irq.c~drivers-mfd-remove-obsolete-irq_desc_t-typedef drivers/mfd/twl4030-irq.c
--- a/drivers/mfd/twl4030-irq.c~drivers-mfd-remove-obsolete-irq_desc_t-typedef
+++ a/drivers/mfd/twl4030-irq.c
@@ -255,7 +255,7 @@ static int twl4030_irq_thread(void *data
  * thread.  All we do here is acknowledge and mask the interrupt and wakeup
  * the kernel thread.
  */
-static void handle_twl4030_pih(unsigned int irq, irq_desc_t *desc)
+static void handle_twl4030_pih(unsigned int irq, struct irq_desc *desc)
 {
 	/* Acknowledge, clear *AND* mask the interrupt... */
 	desc->chip->ack(irq);
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

