From: akpm@linux-foundation.org
Subject: + vmi-paravirt-ops-bugfix-for-2621.patch added to -mm tree
Date: Sat, 31 Mar 2007 01:02:21 -0700
Message-ID: <200703310802.l2V82Lah018638@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42358 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbXCaICc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 31 Mar 2007 04:02:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com, ak@suse.de, jeremy@goop.org, rusty@rustcorp.com.au


The patch titled
     VMI paravirt-ops bugfix for 2.6.21
has been added to the -mm tree.  Its filename is
     vmi-paravirt-ops-bugfix-for-2621.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: VMI paravirt-ops bugfix for 2.6.21
From: Zachary Amsden <zach@vmware.com>

Critical bugfix; when using software RAID, potentially USB or AIO in
highmem configurations, drivers are allowed to use kmap_atomic from
interrupt context.  This is incompatible with the current implementation of
lazy MMU mode, and means the kmap will silently fail, causing either memory
corruption or kernel panics.  This bug is only visible with >970 megs of
RAM and extreme memory pressure, but nontheless extremely serious.

The fix is to disable interrupts on the CPU when entering a lazy MMU state;
this is totally safe, as preemption is already disabled, and lazy update
state can neither be nested nor overlapping.  Thus per-cpu variables to
track the state and flags can be used to disable interrupts during this
critical region.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/vmi.c~vmi-paravirt-ops-bugfix-for-2621 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~vmi-paravirt-ops-bugfix-for-2621
+++ a/arch/i386/kernel/vmi.c
@@ -69,6 +69,7 @@ struct {
 	void (*flush_tlb)(int);
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
+ 	void (*set_lazy_mode)(int mode);
 } vmi_ops;
 
 /* XXX move this to alternative.h */
@@ -574,6 +575,31 @@ vmi_startup_ipi_hook(int phys_apicid, un
 }
 #endif
 
+static void vmi_set_lazy_mode(int new_mode)
+{
+	static DEFINE_PER_CPU(int, mode);
+	static DEFINE_PER_CPU(unsigned long, flags);
+	int cpu = smp_processor_id();
+
+	if (!vmi_ops.set_lazy_mode)
+		return;
+
+	/*
+	 * Modes do not nest or overlap, so we can simply disable
+	 * irqs when entering a mode and re-enable when leaving.
+	 */
+	BUG_ON(per_cpu(mode, cpu) && new_mode);
+	BUG_ON(!new_mode && !per_cpu(mode, cpu));
+
+	if (new_mode)
+		local_irq_save(per_cpu(flags, cpu));
+	else
+		local_irq_restore(per_cpu(flags, cpu));
+
+	vmi_ops.set_lazy_mode(new_mode);
+	per_cpu(mode, cpu) = new_mode;
+}
+
 static inline int __init check_vmi_rom(struct vrom_header *rom)
 {
 	struct pci_header *pci;
@@ -804,7 +830,7 @@ static inline int __init activate_vmi(vo
 	para_wrap(load_esp0, vmi_load_esp0, set_kernel_stack, UpdateKernelStack);
 	para_fill(set_iopl_mask, SetIOPLMask);
 	para_fill(io_delay, IODelay);
-	para_fill(set_lazy_mode, SetLazyMode);
+	para_wrap(set_lazy_mode, vmi_set_lazy_mode, set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
 	para_wrap(flush_tlb_user, vmi_flush_tlb_user, flush_tlb, FlushTLB);
_

Patches currently in -mm which might be from zach@vmware.com are

vmi-paravirt-ops-bugfix-for-2621.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
