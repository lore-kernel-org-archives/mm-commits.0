From: akpm@osdl.org
Subject: - i386-fix-the-verify_quirk_intel_irqbalance.patch removed from -mm tree
Date: Sat, 09 Dec 2006 17:52:36 -0800
Message-ID: <200612100152.kBA1qa0H010591@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40510 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759165AbWLJBwt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 20:52:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, ak@suse.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     i386: Fix the verify_quirk_intel_irqbalance()
has been removed from the -mm tree.  Its filename was
     i386-fix-the-verify_quirk_intel_irqbalance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: Fix the verify_quirk_intel_irqbalance()
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Fix the verify_quirk_intel_irqbalance().  genapic checks should really
happen only on affected versions of the E7520/E7320/E7525 based platforms.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/quirks.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/quirks.c~i386-fix-the-verify_quirk_intel_irqbalance arch/i386/kernel/quirks.c
--- a/arch/i386/kernel/quirks.c~i386-fix-the-verify_quirk_intel_irqbalance
+++ a/arch/i386/kernel/quirks.c
@@ -10,13 +10,38 @@
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
 static void __devinit verify_quirk_intel_irqbalance(struct pci_dev *dev)
 {
+	u8 config, rev;
+	u32 word;
+
+	/* BIOS may enable hardware IRQ balancing for
+	 * E7520/E7320/E7525(revision ID 0x9 and below)
+	 * based platforms.
+	 * For those platforms, make sure that the genapic is set to 'flat'
+	 */
+	pci_read_config_byte(dev, PCI_CLASS_REVISION, &rev);
+	if (rev > 0x9)
+		return;
+
+	/* enable access to config space*/
+	pci_read_config_byte(dev, 0xf4, &config);
+	pci_write_config_byte(dev, 0xf4, config|0x2);
+
+	/* read xTPR register */
+	raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
+
+	if (!(word & (1 << 13))) {
 #ifdef CONFIG_X86_64
-	if (genapic !=  &apic_flat)
-		panic("APIC mode must be flat on this system\n");
+		if (genapic !=  &apic_flat)
+			panic("APIC mode must be flat on this system\n");
 #elif defined(CONFIG_X86_GENERICARCH)
-	if (genapic != &apic_default)
-		panic("APIC mode must be default(flat) on this system. Use apic=default\n");
+		if (genapic != &apic_default)
+			panic("APIC mode must be default(flat) on this system. Use apic=default\n");
 #endif
+	}
+
+	/* put back the original value for config space*/
+	if (!(config & 0x2))
+		pci_write_config_byte(dev, 0xf4, config);
 }
 
 void __init quirk_intel_irqbalance(void)
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
sched-domain-increase-the-smt-busy-rebalance-interval.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
sched-decrease-number-of-load-balances.patch
sched-remove-lb_stopbalance-counter.patch
sched-optimize-activate_task-for-rt-task.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch

