From: akpm@linux-foundation.org
Subject: - proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch removed from -mm tree
Date: Wed, 11 Apr 2007 16:20:21 -0700
Message-ID: <200704112320.l3BNKLXM017477@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35811 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbXDKXUc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 19:20:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@muc.de, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     Proper fix for highmem kmap_atomic functions for VMI for 2.6.21
has been removed from the -mm tree.  Its filename was
     proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Proper fix for highmem kmap_atomic functions for VMI for 2.6.21
From: Zachary Amsden <zach@vmware.com>

Since lazy MMU batching mode still allows interrupts to enter, it is
possible for interrupt handlers to try to use kmap_atomic, which fails when
lazy mode is active, since the PTE update to highmem will be delayed.  The
best workaround is to issue an explicit flush in kmap_atomic_functions
case; this is the only way nested PTE updates can happen in the interrupt
handler.

Thanks to Jeremy Fitzhardinge for noting the bug and suggestions on a fix.

This patch gets reverted again when we start 2.6.22 and the bug gets fixed
differently.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c        |   23 ++++++++++++++++++++++-
 arch/i386/mm/highmem.c        |    2 ++
 include/asm-generic/pgtable.h |    2 ++
 include/asm-i386/paravirt.h   |    3 +++
 4 files changed, 29 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/vmi.c~proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621
+++ a/arch/i386/kernel/vmi.c
@@ -69,6 +69,7 @@ struct {
 	void (*flush_tlb)(int);
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
+  	void (*set_lazy_mode)(int mode);
 } vmi_ops;
 
 /* XXX move this to alternative.h */
@@ -574,6 +575,26 @@ vmi_startup_ipi_hook(int phys_apicid, un
 }
 #endif
 
+static void vmi_set_lazy_mode(int mode)
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
@@ -804,7 +825,7 @@ static inline int __init activate_vmi(vo
 	para_wrap(load_esp0, vmi_load_esp0, set_kernel_stack, UpdateKernelStack);
 	para_fill(set_iopl_mask, SetIOPLMask);
 	para_fill(io_delay, IODelay);
-	para_fill(set_lazy_mode, SetLazyMode);
+	para_wrap(set_lazy_mode, vmi_set_lazy_mode, set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
 	para_wrap(flush_tlb_user, vmi_flush_tlb_user, flush_tlb, FlushTLB);
diff -puN arch/i386/mm/highmem.c~proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621 arch/i386/mm/highmem.c
--- a/arch/i386/mm/highmem.c~proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621
+++ a/arch/i386/mm/highmem.c
@@ -42,6 +42,7 @@ void *kmap_atomic(struct page *page, enu
 
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, mk_pte(page, kmap_prot));
+	arch_flush_lazy_mmu_mode();
 
 	return (void*) vaddr;
 }
@@ -82,6 +83,7 @@ void *kmap_atomic_pfn(unsigned long pfn,
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, pfn_pte(pfn, kmap_prot));
+	arch_flush_lazy_mmu_mode();
 
 	return (void*) vaddr;
 }
diff -puN include/asm-generic/pgtable.h~proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621 include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621
+++ a/include/asm-generic/pgtable.h
@@ -180,6 +180,7 @@ static inline void ptep_set_wrprotect(st
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 #define arch_enter_lazy_mmu_mode()	do {} while (0)
 #define arch_leave_lazy_mmu_mode()	do {} while (0)
+#define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif
 
 /*
@@ -193,6 +194,7 @@ static inline void ptep_set_wrprotect(st
 #ifndef __HAVE_ARCH_ENTER_LAZY_CPU_MODE
 #define arch_enter_lazy_cpu_mode()	do {} while (0)
 #define arch_leave_lazy_cpu_mode()	do {} while (0)
+#define arch_flush_lazy_cpu_mode()	do {} while (0)
 #endif
 
 /*
diff -puN include/asm-i386/paravirt.h~proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621
+++ a/include/asm-i386/paravirt.h
@@ -421,14 +421,17 @@ static inline void pmd_clear(pmd_t *pmdp
 #define PARAVIRT_LAZY_NONE 0
 #define PARAVIRT_LAZY_MMU  1
 #define PARAVIRT_LAZY_CPU  2
+#define PARAVIRT_LAZY_FLUSH 3
 
 #define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
 #define arch_enter_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_CPU)
 #define arch_leave_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
+#define arch_flush_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_FLUSH)
 
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 #define arch_enter_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_MMU)
 #define arch_leave_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
+#define arch_flush_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_FLUSH)
 
 /* These all sit in the .parainstructions section to tell us what to patch. */
 struct paravirt_patch {
_

Patches currently in -mm which might be from zach@vmware.com are

origin.patch
fix-buslogic-to-stop-using-check_region.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
i386-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
i386-make-compat_vdso-runtime-selectable.patch
i386-sysenter-arch-pages-fix.patch
i386-acpi-remove-earlyquirk-warning.patch
i386-mcheck-p4-grotesque-and-needless-warning-fix.patch
i386-pgd-clone-under-lock-fix.patch
vmi-supports-compat-vdso.patch
resurrect-the-vmi-lazy-mode-fixes.patch
resurrect-the-vmi-lazy-mode-fixes-fix.patch
vmi-kmap_atomic_pte-fix.patch
vmi-timer-update.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
