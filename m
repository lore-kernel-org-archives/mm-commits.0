From: akpm@linux-foundation.org
Subject: [merged] ia64-remove-obsolete-no_irq_type.patch removed from -mm tree
Date: Thu, 18 Jun 2009 11:20:24 -0700
Message-ID: <200906181820.n5IIKOJC017965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954AbZFRSVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 14:21:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: remove obsolete no_irq_type
has been removed from the -mm tree.  Its filename was
     ia64-remove-obsolete-no_irq_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -46,7 +46,7 @@ hpsim_irq_init (void)
 
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
@@ -650,7 +650,7 @@ register_intr (unsigned int gsi, int irq
 
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
@@ -301,7 +301,7 @@ void sn_irq_init(void)
 	ia64_last_device_vector = IA64_SN2_LAST_DEVICE_VECTOR;
 
 	for (i = 0; i < NR_IRQS; i++) {
-		if (base_desc[i].chip == &no_irq_type) {
+		if (base_desc[i].chip == &no_irq_chip) {
 			base_desc[i].chip = &irq_type_sn;
 		}
 	}
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
parisc-remove-obsolete-hw_interrupt_type.patch

