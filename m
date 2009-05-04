From: akpm@linux-foundation.org
Subject: + ia64-remove-obsolete-no_irq_type.patch added to -mm tree
Date: Mon, 04 May 2009 15:05:40 -0700
Message-ID: <200905042205.n44M5eod027479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbZEDWII (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 18:08:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, tony.luck@intel.com


The patch titled
     ia64: remove obsolete no_irq_type
has been added to the -mm tree.  Its filename is
     ia64-remove-obsolete-no_irq_type.patch

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
Subject: ia64: remove obsolete no_irq_type
From: Thomas Gleixner <tglx@linutronix.de>

The defines and typedefs (hw_interrupt_type, no_irq_type, irq_desc_t) have
been kept around for migration reasons.  After more than two years it's
time to remove them finally.

This patch cleans up one of the remaining users.  When all such patches
hit mainline we can remove the defines and typedefs finally.

Impact: cleanup

convert the last remaining users to no_irq_chip

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/sim/hpsim_irq.c |    2 +-
 arch/ia64/kernel/iosapic.c   |    2 +-
 arch/ia64/sn/kernel/irq.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/ia64/hp/sim/hpsim_irq.c~ia64-remove-obsolete-no_irq_type arch/ia64/hp/sim/hpsim_irq.c
--- a/arch/ia64/hp/sim/hpsim_irq.c~ia64-remove-obsolete-no_irq_type
+++ a/arch/ia64/hp/sim/hpsim_irq.c
@@ -45,7 +45,7 @@ hpsim_irq_init (void)
 
 	for (i = 0; i < NR_IRQS; ++i) {
 		idesc = irq_desc + i;
-		if (idesc->chip == &no_irq_type)
+		if (idesc->chip == &no_irq_chip)
 			idesc->chip = &irq_type_hp_sim;
 	}
 }
diff -puN arch/ia64/kernel/iosapic.c~ia64-remove-obsolete-no_irq_type arch/ia64/kernel/iosapic.c
--- a/arch/ia64/kernel/iosapic.c~ia64-remove-obsolete-no_irq_type
+++ a/arch/ia64/kernel/iosapic.c
@@ -648,7 +648,7 @@ register_intr (unsigned int gsi, int irq
 
 	idesc = irq_desc + irq;
 	if (irq_type != NULL && idesc->chip != irq_type) {
-		if (idesc->chip != &no_irq_type)
+		if (idesc->chip != &no_irq_chip)
 			printk(KERN_WARNING
 			       "%s: changing vector %d from %s to %s\n",
 			       __func__, irq_to_vector(irq),
diff -puN arch/ia64/sn/kernel/irq.c~ia64-remove-obsolete-no_irq_type arch/ia64/sn/kernel/irq.c
--- a/arch/ia64/sn/kernel/irq.c~ia64-remove-obsolete-no_irq_type
+++ a/arch/ia64/sn/kernel/irq.c
@@ -299,7 +299,7 @@ void sn_irq_init(void)
 	ia64_last_device_vector = IA64_SN2_LAST_DEVICE_VECTOR;
 
 	for (i = 0; i < NR_IRQS; i++) {
-		if (base_desc[i].chip == &no_irq_type) {
+		if (base_desc[i].chip == &no_irq_chip) {
 			base_desc[i].chip = &irq_type_sn;
 		}
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

