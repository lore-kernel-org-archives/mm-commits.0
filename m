From: akpm@linux-foundation.org
Subject: + parisc-remove-obsolete-hw_interrupt_type.patch added to -mm tree
Date: Mon, 04 May 2009 15:05:55 -0700
Message-ID: <200905042205.n44M5u3A027615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbZEDWVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 18:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, kyle@mcmartin.ca


The patch titled
     parisc: remove obsolete hw_interrupt_type
has been added to the -mm tree.  Its filename is
     parisc-remove-obsolete-hw_interrupt_type.patch

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
Subject: parisc: remove obsolete hw_interrupt_type
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
Cc: Kyle McMartin <kyle@mcmartin.ca>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/irq.c |    2 +-
 drivers/parisc/dino.c    |    2 +-
 drivers/parisc/eisa.c    |    2 +-
 drivers/parisc/gsc.c     |    4 ++--
 drivers/parisc/gsc.h     |    2 +-
 drivers/parisc/iosapic.c |    2 +-
 drivers/parisc/superio.c |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/parisc/kernel/irq.c~parisc-remove-obsolete-hw_interrupt_type arch/parisc/kernel/irq.c
--- a/arch/parisc/kernel/irq.c~parisc-remove-obsolete-hw_interrupt_type
+++ a/arch/parisc/kernel/irq.c
@@ -142,7 +142,7 @@ static void cpu_set_affinity_irq(unsigne
 }
 #endif
 
-static struct hw_interrupt_type cpu_interrupt_type = {
+static struct irq_chip cpu_interrupt_type = {
 	.typename	= "CPU",
 	.startup	= cpu_startup_irq,
 	.shutdown	= cpu_disable_irq,
diff -puN drivers/parisc/dino.c~parisc-remove-obsolete-hw_interrupt_type drivers/parisc/dino.c
--- a/drivers/parisc/dino.c~parisc-remove-obsolete-hw_interrupt_type
+++ a/drivers/parisc/dino.c
@@ -353,7 +353,7 @@ static unsigned int dino_startup_irq(uns
 	return 0;
 }
 
-static struct hw_interrupt_type dino_interrupt_type = {
+static struct irq_chip dino_interrupt_type = {
 	.typename	= "GSC-PCI",
 	.startup	= dino_startup_irq,
 	.shutdown	= dino_disable_irq,
diff -puN drivers/parisc/eisa.c~parisc-remove-obsolete-hw_interrupt_type drivers/parisc/eisa.c
--- a/drivers/parisc/eisa.c~parisc-remove-obsolete-hw_interrupt_type
+++ a/drivers/parisc/eisa.c
@@ -188,7 +188,7 @@ static unsigned int eisa_startup_irq(uns
 	return 0;
 }
 
-static struct hw_interrupt_type eisa_interrupt_type = {
+static struct irq_chip eisa_interrupt_type = {
 	.typename =	"EISA",
 	.startup =	eisa_startup_irq,
 	.shutdown =	eisa_disable_irq,
diff -puN drivers/parisc/gsc.c~parisc-remove-obsolete-hw_interrupt_type drivers/parisc/gsc.c
--- a/drivers/parisc/gsc.c~parisc-remove-obsolete-hw_interrupt_type
+++ a/drivers/parisc/gsc.c
@@ -148,7 +148,7 @@ static unsigned int gsc_asic_startup_irq
 	return 0;
 }
 
-static struct hw_interrupt_type gsc_asic_interrupt_type = {
+static struct irq_chip gsc_asic_interrupt_type = {
 	.typename =	"GSC-ASIC",
 	.startup =	gsc_asic_startup_irq,
 	.shutdown =	gsc_asic_disable_irq,
@@ -158,7 +158,7 @@ static struct hw_interrupt_type gsc_asic
 	.end =		no_end_irq,
 };
 
-int gsc_assign_irq(struct hw_interrupt_type *type, void *data)
+int gsc_assign_irq(struct irq_chip *type, void *data)
 {
 	static int irq = GSC_IRQ_BASE;
 	struct irq_desc *desc;
diff -puN drivers/parisc/gsc.h~parisc-remove-obsolete-hw_interrupt_type drivers/parisc/gsc.h
--- a/drivers/parisc/gsc.h~parisc-remove-obsolete-hw_interrupt_type
+++ a/drivers/parisc/gsc.h
@@ -38,7 +38,7 @@ struct gsc_asic {
 int gsc_common_setup(struct parisc_device *parent, struct gsc_asic *gsc_asic);
 int gsc_alloc_irq(struct gsc_irq *dev);			/* dev needs an irq */
 int gsc_claim_irq(struct gsc_irq *dev, int irq);	/* dev needs this irq */
-int gsc_assign_irq(struct hw_interrupt_type *type, void *data);
+int gsc_assign_irq(struct irq_chip *type, void *data);
 int gsc_find_local_irq(unsigned int irq, int *global_irq, int limit);
 void gsc_fixup_irqs(struct parisc_device *parent, void *ctrl,
 		void (*choose)(struct parisc_device *child, void *ctrl));
diff -puN drivers/parisc/iosapic.c~parisc-remove-obsolete-hw_interrupt_type drivers/parisc/iosapic.c
--- a/drivers/parisc/iosapic.c~parisc-remove-obsolete-hw_interrupt_type
+++ a/drivers/parisc/iosapic.c
@@ -727,7 +727,7 @@ static void iosapic_set_affinity_irq(uns
 }
 #endif
 
-static struct hw_interrupt_type iosapic_interrupt_type = {
+static struct irq_chip iosapic_interrupt_type = {
 	.typename =	"IO-SAPIC-level",
 	.startup =	iosapic_startup_irq,
 	.shutdown =	iosapic_disable_irq,
diff -puN drivers/parisc/superio.c~parisc-remove-obsolete-hw_interrupt_type drivers/parisc/superio.c
--- a/drivers/parisc/superio.c~parisc-remove-obsolete-hw_interrupt_type
+++ a/drivers/parisc/superio.c
@@ -325,7 +325,7 @@ static unsigned int superio_startup_irq(
 	return 0;
 }
 
-static struct hw_interrupt_type superio_interrupt_type = {
+static struct irq_chip superio_interrupt_type = {
 	.typename =	SUPERIO,
 	.startup =	superio_startup_irq,
 	.shutdown =	superio_disable_irq,
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

