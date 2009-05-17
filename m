From: akpm@linux-foundation.org
Subject: [merged] drivers-mfd-remove-obsolete-irq_desc_t-typedef.patch removed from -mm tree
Date: Sun, 17 May 2009 09:54:26 -0700
Message-ID: <200905171654.n4HGsQJM017135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbZEQQzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 17 May 2009 12:55:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     drivers/mfd: remove obsolete irq_desc_t typedef
has been removed from the -mm tree.  Its filename was
     drivers-mfd-remove-obsolete-irq_desc_t-typedef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
x86-enable-gart-iommu-only-after-setting-up-protection-methods.patch
time-move-calc_load-call-out-from-xtime_lock-protection.patch
time-move-pit_tick_rate-to-linux-timexh.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch
ia64-remove-obsolete-no_irq_type.patch
ia64-remove-obsolete-irq_desc_t-typedef.patch
ia64-remove-obsolete-hw_interrupt_type.patch
parisc-remove-obsolete-hw_interrupt_type.patch
alpha-remove-obsolete-hw_interrupt_type.patch
m32r-remove-obsolete-hw_interrupt_type.patch
um-remove-obsolete-hw_interrupt_type.patch
kmap_types-make-most-arches-use-generic-header-file.patch
remove-put_cpu_no_resched.patch
remove-put_cpu_no_resched-fix.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch

