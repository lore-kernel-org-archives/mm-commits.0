From: akpm@linux-foundation.org
Subject: + um-remove-obsolete-hw_interrupt_type.patch added to -mm tree
Date: Mon, 04 May 2009 15:05:58 -0700
Message-ID: <200905042205.n44M5wCk027620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbZEDWWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 18:22:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, jdike@addtoit.com


The patch titled
     um: remove obsolete hw_interrupt_type
has been added to the -mm tree.  Its filename is
     um-remove-obsolete-hw_interrupt_type.patch

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

