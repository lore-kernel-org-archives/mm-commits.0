From: akpm@linux-foundation.org
Subject: + vmi-apic-ops.patch added to -mm tree
Date: Thu, 01 Mar 2007 19:37:28 -0800
Message-ID: <200703020337.l223bSRF031362@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39705 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422806AbXCBDhc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 22:37:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com, anthony@codemonkey.ws


The patch titled
     vmi: apic ops
has been added to the -mm tree.  Its filename is
     vmi-apic-ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vmi: apic ops
From: Zachary Amsden <zach@vmware.com>

Use para_fill instead of directly setting the APIC ops to the result of the
vmi_get_function call - this allows one to implement a VMI ROM without
implementing APIC functions, just using the native APIC functions.

While doing this, I realized that there is a lot more cleanup that should have
been done.  Basically, we should never assume that the ROM implements a
specific set of functions, and always allow fallback to the native
implementation.

This is critical for future compatibility.

Signed-off-by: Anthony Liguori <anthony@codemonkey.ws>
Signed-off-by: Zachary Amsden <zach@vmware.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c |  164 +++++++++++++++++++++------------------
 include/asm-i386/vmi.h |    1 
 2 files changed, 92 insertions(+), 73 deletions(-)

diff -puN arch/i386/kernel/vmi.c~vmi-apic-ops arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~vmi-apic-ops
+++ a/arch/i386/kernel/vmi.c
@@ -54,6 +54,7 @@ static int disable_sep;
 static int disable_tsc;
 static int disable_mtrr;
 static int disable_noidle;
+static int disable_vmi_timer;
 
 /* Cached VMI operations */
 struct {
@@ -661,12 +662,12 @@ static inline int __init probe_vmi_rom(v
 void vmi_bringup(void)
 {
  	/* We must establish the lowmem mapping for MMU ops to work */
-	if (vmi_rom)
+	if (vmi_ops.set_linear_mapping)
 		vmi_ops.set_linear_mapping(0, __PAGE_OFFSET, max_low_pfn, 0);
 }
 
 /*
- * Return a pointer to the VMI function or a NOP stub
+ * Return a pointer to a VMI function or NULL if unimplemented
  */
 static void *vmi_get_function(int vmicall)
 {
@@ -677,12 +678,13 @@ static void *vmi_get_function(int vmical
 	if (rel->type == VMI_RELOCATION_CALL_REL)
 		return (void *)rel->eip;
 	else
-		return (void *)vmi_nop;
+		return NULL;
 }
 
 /*
  * Helper macro for making the VMI paravirt-ops fill code readable.
- * For unimplemented operations, fall back to default.
+ * For unimplemented operations, fall back to default, unless nop
+ * is returned by the ROM.
  */
 #define para_fill(opname, vmicall)				\
 do {								\
@@ -691,9 +693,29 @@ do {								\
 	if (rel->type != VMI_RELOCATION_NONE) {			\
 		BUG_ON(rel->type != VMI_RELOCATION_CALL_REL);	\
 		paravirt_ops.opname = (void *)rel->eip;		\
+	} else if (rel->type == VMI_RELOCATION_NOP) 		\
+		paravirt_ops.opname = (void *)vmi_nop;		\
+} while (0)
+
+/*
+ * Helper macro for making the VMI paravirt-ops fill code readable.
+ * For cached operations which do not match the VMI ROM ABI and must
+ * go through a tranlation stub.  Ignore NOPs, since it is not clear
+ * a NOP * VMI function corresponds to a NOP paravirt-op when the
+ * functions are not in 1-1 correspondence.
+ */
+#define para_wrap(opname, wrapper, cache, vmicall)		\
+do {								\
+	reloc = call_vrom_long_func(vmi_rom, get_reloc,		\
+				    VMI_CALL_##vmicall);	\
+	BUG_ON(rel->type == VMI_RELOCATION_JUMP_REL);		\
+	if (rel->type == VMI_RELOCATION_CALL_REL) {		\
+		paravirt_ops.opname = wrapper;			\
+		vmi_ops.cache = (void *)rel->eip;		\
 	}							\
 } while (0)
 
+
 /*
  * Activate the VMI interface and switch into paravirtualized mode
  */
@@ -730,13 +752,8 @@ static inline int __init activate_vmi(vo
 	 *  rdpmc is not yet used in Linux
 	 */
 
-	/* CPUID is special, so very special */
-	reloc = call_vrom_long_func(vmi_rom, get_reloc,	VMI_CALL_CPUID);
-	if (rel->type != VMI_RELOCATION_NONE) {
-		BUG_ON(rel->type != VMI_RELOCATION_CALL_REL);
-		vmi_ops.cpuid = (void *)rel->eip;
-		paravirt_ops.cpuid = vmi_cpuid;
-	}
+	/* CPUID is special, so very special it gets wrapped like a present */
+	para_wrap(cpuid, vmi_cpuid, cpuid, CPUID);
 
 	para_fill(clts, CLTS);
 	para_fill(get_debugreg, GetDR);
@@ -753,6 +770,7 @@ static inline int __init activate_vmi(vo
 	para_fill(restore_fl, SetInterruptMask);
 	para_fill(irq_disable, DisableInterrupts);
 	para_fill(irq_enable, EnableInterrupts);
+
 	/* irq_save_disable !!! sheer pain */
 	patch_offset(&irq_save_disable_callout[IRQ_PATCH_INT_MASK],
 		     (char *)paravirt_ops.save_fl);
@@ -760,26 +778,18 @@ static inline int __init activate_vmi(vo
 		     (char *)paravirt_ops.irq_disable);
 
 	para_fill(wbinvd, WBINVD);
+	para_fill(read_tsc, RDTSC);
+
+	/* The following we emulate with trap and emulate for now */
 	/* paravirt_ops.read_msr = vmi_rdmsr */
 	/* paravirt_ops.write_msr = vmi_wrmsr */
-	para_fill(read_tsc, RDTSC);
 	/* paravirt_ops.rdpmc = vmi_rdpmc */
 
-	/* TR interface doesn't pass TR value */
-	reloc = call_vrom_long_func(vmi_rom, get_reloc,	VMI_CALL_SetTR);
-	if (rel->type != VMI_RELOCATION_NONE) {
-		BUG_ON(rel->type != VMI_RELOCATION_CALL_REL);
-		vmi_ops.set_tr = (void *)rel->eip;
-		paravirt_ops.load_tr_desc = vmi_set_tr;
-	}
+	/* TR interface doesn't pass TR value, wrap */
+	para_wrap(load_tr_desc, vmi_set_tr, set_tr, SetTR);
 
 	/* LDT is special, too */
-	reloc = call_vrom_long_func(vmi_rom, get_reloc,	VMI_CALL_SetLDT);
-	if (rel->type != VMI_RELOCATION_NONE) {
-		BUG_ON(rel->type != VMI_RELOCATION_CALL_REL);
-		vmi_ops._set_ldt = (void *)rel->eip;
-		paravirt_ops.set_ldt = vmi_set_ldt;
-	}
+	para_wrap(set_ldt, vmi_set_ldt, _set_ldt, SetLDT);
 
 	para_fill(load_gdt, SetGDT);
 	para_fill(load_idt, SetIDT);
@@ -790,25 +800,14 @@ static inline int __init activate_vmi(vo
 	para_fill(write_ldt_entry, WriteLDTEntry);
 	para_fill(write_gdt_entry, WriteGDTEntry);
 	para_fill(write_idt_entry, WriteIDTEntry);
-	reloc = call_vrom_long_func(vmi_rom, get_reloc,
-				    VMI_CALL_UpdateKernelStack);
-	if (rel->type != VMI_RELOCATION_NONE) {
-		BUG_ON(rel->type != VMI_RELOCATION_CALL_REL);
-		vmi_ops.set_kernel_stack = (void *)rel->eip;
-		paravirt_ops.load_esp0 = vmi_load_esp0;
-	}
-
+	para_wrap(load_esp0, vmi_load_esp0, set_kernel_stack, UpdateKernelStack);
 	para_fill(set_iopl_mask, SetIOPLMask);
-	paravirt_ops.io_delay = (void *)vmi_nop;
-
+	para_fill(io_delay, IODelay);
 	para_fill(set_lazy_mode, SetLazyMode);
 
-	reloc = call_vrom_long_func(vmi_rom, get_reloc, VMI_CALL_FlushTLB);
-	if (rel->type != VMI_RELOCATION_NONE) {
-		vmi_ops.flush_tlb = (void *)rel->eip;
-		paravirt_ops.flush_tlb_user = vmi_flush_tlb_user;
-		paravirt_ops.flush_tlb_kernel = vmi_flush_tlb_kernel;
-	}
+	/* user and kernel flush are just handled with different flags to FlushTLB */
+	para_wrap(flush_tlb_user, vmi_flush_tlb_user, flush_tlb, FlushTLB);
+	para_wrap(flush_tlb_kernel, vmi_flush_tlb_kernel, flush_tlb, FlushTLB);
 	para_fill(flush_tlb_single, InvalPage);
 
 	/*
@@ -823,28 +822,40 @@ static inline int __init activate_vmi(vo
 	vmi_ops.set_pte = vmi_get_function(VMI_CALL_SetPxE);
 	vmi_ops.update_pte = vmi_get_function(VMI_CALL_UpdatePxE);
 #endif
-	vmi_ops.set_linear_mapping = vmi_get_function(VMI_CALL_SetLinearMapping);
-	vmi_ops.allocate_page = vmi_get_function(VMI_CALL_AllocatePage);
-	vmi_ops.release_page = vmi_get_function(VMI_CALL_ReleasePage);
 
-	paravirt_ops.map_pt_hook = vmi_map_pt_hook;
-	paravirt_ops.alloc_pt = vmi_allocate_pt;
-	paravirt_ops.alloc_pd = vmi_allocate_pd;
-	paravirt_ops.alloc_pd_clone = vmi_allocate_pd_clone;
-	paravirt_ops.release_pt = vmi_release_pt;
-	paravirt_ops.release_pd = vmi_release_pd;
-	paravirt_ops.set_pte = vmi_set_pte;
-	paravirt_ops.set_pte_at = vmi_set_pte_at;
-	paravirt_ops.set_pmd = vmi_set_pmd;
-	paravirt_ops.pte_update = vmi_update_pte;
-	paravirt_ops.pte_update_defer = vmi_update_pte_defer;
+	if (vmi_ops.set_pte) {
+		paravirt_ops.set_pte = vmi_set_pte;
+		paravirt_ops.set_pte_at = vmi_set_pte_at;
+		paravirt_ops.set_pmd = vmi_set_pmd;
 #ifdef CONFIG_X86_PAE
-	paravirt_ops.set_pte_atomic = vmi_set_pte_atomic;
-	paravirt_ops.set_pte_present = vmi_set_pte_present;
-	paravirt_ops.set_pud = vmi_set_pud;
-	paravirt_ops.pte_clear = vmi_pte_clear;
-	paravirt_ops.pmd_clear = vmi_pmd_clear;
+		paravirt_ops.set_pte_atomic = vmi_set_pte_atomic;
+		paravirt_ops.set_pte_present = vmi_set_pte_present;
+		paravirt_ops.set_pud = vmi_set_pud;
+		paravirt_ops.pte_clear = vmi_pte_clear;
+		paravirt_ops.pmd_clear = vmi_pmd_clear;
 #endif
+	}
+
+	if (vmi_ops.update_pte) {
+		paravirt_ops.pte_update = vmi_update_pte;
+		paravirt_ops.pte_update_defer = vmi_update_pte_defer;
+	}
+
+	vmi_ops.allocate_page = vmi_get_function(VMI_CALL_AllocatePage);
+	if (vmi_ops.allocate_page) {
+		paravirt_ops.alloc_pt = vmi_allocate_pt;
+		paravirt_ops.alloc_pd = vmi_allocate_pd;
+		paravirt_ops.alloc_pd_clone = vmi_allocate_pd_clone;
+	}
+
+	vmi_ops.release_page = vmi_get_function(VMI_CALL_ReleasePage);
+	if (vmi_ops.release_page) {
+		paravirt_ops.release_pt = vmi_release_pt;
+		paravirt_ops.release_pd = vmi_release_pd;
+	}
+	para_wrap(map_pt_hook, vmi_map_pt_hook, set_linear_mapping,
+		  SetLinearMapping);
+
 	/*
 	 * These MUST always be patched.  Don't support indirect jumps
 	 * through these operations, as the VMI interface may use either
@@ -856,21 +867,20 @@ static inline int __init activate_vmi(vo
 	paravirt_ops.iret = (void *)0xbadbab0;
 
 #ifdef CONFIG_SMP
-	paravirt_ops.startup_ipi_hook = vmi_startup_ipi_hook;
-	vmi_ops.set_initial_ap_state = vmi_get_function(VMI_CALL_SetInitialAPState);
+	para_wrap(startup_ipi_hook, vmi_startup_ipi_hook, set_initial_ap_state, SetInitialAPState);
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	paravirt_ops.apic_read = vmi_get_function(VMI_CALL_APICRead);
-	paravirt_ops.apic_write = vmi_get_function(VMI_CALL_APICWrite);
-	paravirt_ops.apic_write_atomic = vmi_get_function(VMI_CALL_APICWrite);
+	para_fill(apic_read, APICRead);
+	para_fill(apic_write, APICWrite);
+	para_fill(apic_write_atomic, APICWrite);
 #endif
 
 	/*
 	 * Check for VMI timer functionality by probing for a cycle frequency method
 	 */
 	reloc = call_vrom_long_func(vmi_rom, get_reloc, VMI_CALL_GetCycleFrequency);
-	if (rel->type != VMI_RELOCATION_NONE) {
+	if (!disable_vmi_timer && rel->type != VMI_RELOCATION_NONE) {
 		vmi_timer_ops.get_cycle_frequency = (void *)rel->eip;
 		vmi_timer_ops.get_cycle_counter =
 			vmi_get_function(VMI_CALL_GetCycleCounter);
@@ -890,13 +900,19 @@ static inline int __init activate_vmi(vo
 #endif
 		paravirt_ops.get_scheduled_cycles = vmi_get_sched_cycles;
  		paravirt_ops.get_cpu_khz = vmi_cpu_khz;
+
+		/* We have true wallclock functions; disable CMOS clock sync */
+		no_sync_cmos_clock = 1;
+	} else {
+		disable_noidle = 1;
+		disable_vmi_timer = 1;
 	}
-	if (!disable_noidle)
+
+	/* No idle HZ mode only works if VMI timer and no idle is enabled */
+	if (disable_noidle || disable_vmi_timer)
 		para_fill(safe_halt, Halt);
-	else {
-		vmi_ops.halt = vmi_get_function(VMI_CALL_Halt);
-		paravirt_ops.safe_halt = vmi_safe_halt;
-	}
+	else
+		para_wrap(safe_halt, vmi_safe_halt, halt, Halt);
 
 	/*
 	 * Alternative instruction rewriting doesn't happen soon enough
@@ -932,10 +948,9 @@ void __init vmi_init(void)
 	activate_vmi();
 
 #ifdef CONFIG_X86_IO_APIC
+	/* This is virtual hardware; timer routing is wired correctly */
 	no_timer_check = 1;
 #endif
-	no_sync_cmos_clock = 1;
-
 	local_irq_restore(flags & X86_EFLAGS_IF);
 }
 
@@ -959,6 +974,9 @@ static int __init parse_vmi(char *arg)
 	} else if (!strcmp(arg, "disable_mtrr")) {
 		clear_bit(X86_FEATURE_MTRR, boot_cpu_data.x86_capability);
 		disable_mtrr = 1;
+	} else if (!strcmp(arg, "disable_timer")) {
+		disable_vmi_timer = 1;
+		disable_noidle = 1;
 	} else if (!strcmp(arg, "disable_noidle"))
 		disable_noidle = 1;
 	return 0;
diff -puN include/asm-i386/vmi.h~vmi-apic-ops include/asm-i386/vmi.h
--- a/include/asm-i386/vmi.h~vmi-apic-ops
+++ a/include/asm-i386/vmi.h
@@ -97,6 +97,7 @@
 #define VMI_CALL_SetInitialAPState	62
 #define VMI_CALL_APICWrite		63
 #define VMI_CALL_APICRead		64
+#define VMI_CALL_IODelay		65
 #define VMI_CALL_SetLazyMode		73
 
 /*
_

Patches currently in -mm which might be from zach@vmware.com are

vmi-timer-fixes-round-two.patch
vmi-sched-clock-paravirt-op-fix.patch
vmi-cpu-cycles-fix.patch
vmi-fix-highpte.patch
vmi-paravirt-drop-udelay-op.patch
vmi-pit-override.patch
vmi-fix-nohz-compile.patch
vmi-apic-ops.patch
vmi-smp-fixes.patch
make-struct-vmi_ops-static.patch
xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
xen-paravirt_ops-add-common-patching-machinery.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
