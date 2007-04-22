From: akpm@linux-foundation.org
Subject: - resurrect-the-vmi-lazy-mode-fixes.patch removed from -mm tree
Date: Sat, 21 Apr 2007 21:12:15 -0700
Message-ID: <200704220412.l3M4CF8H019278@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932279AbXDVEMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 00:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Resurrect the VMI lazy mode fixes
has been removed from the -mm tree.  Its filename was
     resurrect-the-vmi-lazy-mode-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Resurrect the VMI lazy mode fixes
From: Zachary Amsden <zach@vmware.com>

Code changes and cleanup in the paravirt-ops queue caused the original fix for
this in 2.6.21 to create conflicts.  The easiest thing to do was back it out
before applying the queue.  In that case, this fix brings it back with the
newly right properly tidied up paravirt-ops code.

Wheee!

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/vmi.c~resurrect-the-vmi-lazy-mode-fixes arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~resurrect-the-vmi-lazy-mode-fixes
+++ a/arch/i386/kernel/vmi.c
@@ -69,6 +69,7 @@ static struct {
 	void (*flush_tlb)(int);
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
+  	void (*set_lazy_mode)(int mode);
 } vmi_ops;
 
 /* XXX move this to alternative.h */
@@ -553,6 +554,26 @@ vmi_startup_ipi_hook(int phys_apicid, un
 }
 #endif
 
+static void vmi_set_lazy_mode(enum paravirt_lazy_mode mode)
+{
+	static DEFINE_PER_CPU(int, lazy_mode);
+
+	if (!vmi_ops.set_lazy_mode)
+		return;
+
+	/* Modes should never nest or overlap */
+	BUG_ON(__get_cpu_var(lazy_mode) && !(mode == PARAVIRT_LAZY_NONE ||
+					     mode == PARAVIRT_LAZY_FLUSH));
+
+	if (mode == PARAVIRT_LAZY_FLUSH) {
+		vmi_ops.set_lazy_mode(0);
+		vmi_ops.set_lazy_mode(__get_cpu_var(lazy_mode));
+	} else {
+		vmi_ops.set_lazy_mode(mode);
+		__get_cpu_var(lazy_mode) = mode;
+	}
+}
+
 static inline int __init check_vmi_rom(struct vrom_header *rom)
 {
 	struct pci_header *pci;
@@ -777,7 +798,7 @@ static inline int __init activate_vmi(vo
 	para_wrap(load_esp0, vmi_load_esp0, set_kernel_stack, UpdateKernelStack);
 	para_fill(set_iopl_mask, SetIOPLMask);
 	para_fill(io_delay, IODelay);
-	para_fill(set_lazy_mode, SetLazyMode);
+	para_wrap(set_lazy_mode, vmi_set_lazy_mode, set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
 	para_wrap(flush_tlb_user, vmi_flush_tlb_user, flush_tlb, FlushTLB);
_

Patches currently in -mm which might be from zach@vmware.com are

fix-buslogic-to-stop-using-check_region.patch
i386-sysenter-arch-pages-fix.patch
i386-acpi-remove-earlyquirk-warning.patch
i386-mcheck-p4-grotesque-and-needless-warning-fix.patch
i386-pgd-clone-under-lock-fix.patch
vmi-supports-compat-vdso.patch
resurrect-the-vmi-lazy-mode-fixes-fix.patch
vmi-kmap_atomic_pte-fix.patch
vmi-timer-update.patch
i386-pte-drop-ptep_get_and_clear-paravirt-op.patch
i386-pte-clear-optimization.patch
i386-pte-xchg-optimization.patch
i386-pte-simplify-ops.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
