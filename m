From: akpm@linux-foundation.org
Subject: [merged] x86-fully-honor-nolapic.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:04:01 -0800
Message-ID: <200901261904.n0QJ41DL029364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754059AbZAZTEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:04:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, andi@firstfloor.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: fully honor "nolapic"
has been removed from the -mm tree.  Its filename was
     x86-fully-honor-nolapic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fully honor "nolapic"
From: "Jan Beulich" <jbeulich@novell.com>

"nolapic" should not only suppress SMP and use of the LAPIC, but it
also ought to have the effect of disabling all IO-APIC related activity
as well as PCI MSI and HT-IRQs.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic.c    |    7 ++++++-
 arch/x86/kernel/io_apic.c |    6 ++++++
 arch/x86/kernel/smpboot.c |    1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/apic.c~x86-fully-honor-nolapic arch/x86/kernel/apic.c
--- a/arch/x86/kernel/apic.c~x86-fully-honor-nolapic
+++ a/arch/x86/kernel/apic.c
@@ -1126,6 +1126,11 @@ void __cpuinit setup_local_APIC(void)
 	unsigned int value;
 	int i, j;
 
+	if (disable_apic) {
+		disable_ioapic_setup();
+		return;
+	}
+
 #ifdef CONFIG_X86_32
 	/* Pound the ESR really hard over the head with a big hammer - mbligh */
 	if (lapic_is_integrated() && esr_disable) {
@@ -1566,11 +1571,11 @@ int apic_version[MAX_APICS];
 
 int __init APIC_init_uniprocessor(void)
 {
-#ifdef CONFIG_X86_64
 	if (disable_apic) {
 		pr_info("Apic disabled\n");
 		return -1;
 	}
+#ifdef CONFIG_X86_64
 	if (!cpu_has_apic) {
 		disable_apic = 1;
 		pr_info("Apic disabled by BIOS\n");
diff -puN arch/x86/kernel/io_apic.c~x86-fully-honor-nolapic arch/x86/kernel/io_apic.c
--- a/arch/x86/kernel/io_apic.c~x86-fully-honor-nolapic
+++ a/arch/x86/kernel/io_apic.c
@@ -3258,6 +3258,9 @@ static int msi_compose_msg(struct pci_de
 	int err;
 	unsigned dest;
 
+	if (disable_apic)
+		return -ENXIO;
+
 	cfg = irq_cfg(irq);
 	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
 	if (err)
@@ -3726,6 +3729,9 @@ int arch_setup_ht_irq(unsigned int irq, 
 	struct irq_cfg *cfg;
 	int err;
 
+	if (disable_apic)
+		return -ENXIO;
+
 	cfg = irq_cfg(irq);
 	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
 	if (!err) {
diff -puN arch/x86/kernel/smpboot.c~x86-fully-honor-nolapic arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~x86-fully-honor-nolapic
+++ a/arch/x86/kernel/smpboot.c
@@ -1125,6 +1125,7 @@ static int __init smp_sanity_check(unsig
 		printk(KERN_ERR "... forcing use of dummy APIC emulation."
 				"(tell your hw vendor)\n");
 		smpboot_clear_io_apic();
+		disable_ioapic_setup();
 		return -1;
 	}
 
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch
x86-simplify-highmem-related-kconfig-entries.patch

