From: akpm@osdl.org
Subject: - kvm-replace-__x86_64__-with-config_x86_64.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:00:33 -0800
Message-ID: <200612140600.kBE60XSG001676@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51353 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbWLNGAs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:00:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Replace __x86_64__ with CONFIG_X86_64
has been removed from the -mm tree.  Its filename was
     kvm-replace-__x86_64__-with-config_x86_64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Replace __x86_64__ with CONFIG_X86_64
From: Avi Kivity <avi@qumranet.com>

As per akpm's request.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h         |    8 +++----
 drivers/kvm/kvm_main.c    |   16 +++++++-------
 drivers/kvm/kvm_svm.h     |    2 -
 drivers/kvm/kvm_vmx.h     |    2 -
 drivers/kvm/svm.c         |   22 +++++++++----------
 drivers/kvm/vmx.c         |   40 ++++++++++++++++++------------------
 drivers/kvm/x86_emulate.c |    8 +++----
 drivers/kvm/x86_emulate.h |    2 -
 8 files changed, 50 insertions(+), 50 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-replace-__x86_64__-with-config_x86_64 drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-replace-__x86_64__-with-config_x86_64
+++ a/drivers/kvm/kvm.h
@@ -140,7 +140,7 @@ enum {
 	VCPU_REGS_RBP = 5,
 	VCPU_REGS_RSI = 6,
 	VCPU_REGS_RDI = 7,
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	VCPU_REGS_R8 = 8,
 	VCPU_REGS_R9 = 9,
 	VCPU_REGS_R10 = 10,
@@ -375,7 +375,7 @@ void set_cr4(struct kvm_vcpu *vcpu, unsi
 void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr0);
 void lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 void set_efer(struct kvm_vcpu *vcpu, u64 efer);
 #endif
 
@@ -485,7 +485,7 @@ static inline unsigned long read_tr_base
 	return segment_base(tr);
 }
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 static inline unsigned long read_msr(unsigned long msr)
 {
 	u64 value;
@@ -533,7 +533,7 @@ static inline u32 get_rdx_init_val(void)
 #define TSS_REDIRECTION_SIZE (256 / 8)
 #define RMODE_TSS_SIZE (TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 
 /*
  * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.  Therefore
diff -puN drivers/kvm/kvm_main.c~kvm-replace-__x86_64__-with-config_x86_64 drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-replace-__x86_64__-with-config_x86_64
+++ a/drivers/kvm/kvm_main.c
@@ -83,7 +83,7 @@ struct vmx_msr_entry *find_msr_entry(str
 }
 EXPORT_SYMBOL_GPL(find_msr_entry);
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 // LDT or TSS descriptor in the GDT. 16 bytes.
 struct segment_descriptor_64 {
 	struct segment_descriptor s;
@@ -115,7 +115,7 @@ unsigned long segment_base(u16 selector)
 	}
 	d = (struct segment_descriptor *)(table_base + (selector & ~7));
 	v = d->base_low | ((ul)d->base_mid << 16) | ((ul)d->base_high << 24);
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	if (d->system == 0
 	    && (d->type == 2 || d->type == 9 || d->type == 11))
 		v |= ((ul)((struct segment_descriptor_64 *)d)->base_higher) << 32;
@@ -351,7 +351,7 @@ void set_cr0(struct kvm_vcpu *vcpu, unsi
 	}
 
 	if (!is_paging(vcpu) && (cr0 & CR0_PG_MASK)) {
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 		if ((vcpu->shadow_efer & EFER_LME)) {
 			int cs_db, cs_l;
 
@@ -1120,7 +1120,7 @@ static int get_msr(struct kvm_vcpu *vcpu
 	return kvm_arch_ops->get_msr(vcpu, msr_index, pdata);
 }
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 
 void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
@@ -1243,7 +1243,7 @@ static int kvm_dev_ioctl_get_regs(struct
 	regs->rdi = vcpu->regs[VCPU_REGS_RDI];
 	regs->rsp = vcpu->regs[VCPU_REGS_RSP];
 	regs->rbp = vcpu->regs[VCPU_REGS_RBP];
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	regs->r8 = vcpu->regs[VCPU_REGS_R8];
 	regs->r9 = vcpu->regs[VCPU_REGS_R9];
 	regs->r10 = vcpu->regs[VCPU_REGS_R10];
@@ -1287,7 +1287,7 @@ static int kvm_dev_ioctl_set_regs(struct
 	vcpu->regs[VCPU_REGS_RDI] = regs->rdi;
 	vcpu->regs[VCPU_REGS_RSP] = regs->rsp;
 	vcpu->regs[VCPU_REGS_RBP] = regs->rbp;
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	vcpu->regs[VCPU_REGS_R8] = regs->r8;
 	vcpu->regs[VCPU_REGS_R9] = regs->r9;
 	vcpu->regs[VCPU_REGS_R10] = regs->r10;
@@ -1401,7 +1401,7 @@ static int kvm_dev_ioctl_set_sregs(struc
 	vcpu->cr8 = sregs->cr8;
 
 	mmu_reset_needed |= vcpu->shadow_efer != sregs->efer;
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	kvm_arch_ops->set_efer(vcpu, sregs->efer);
 #endif
 	vcpu->apic_base = sregs->apic_base;
@@ -1434,7 +1434,7 @@ static int kvm_dev_ioctl_set_sregs(struc
 static u32 msrs_to_save[] = {
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
 	MSR_K6_STAR,
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
 #endif
 	MSR_IA32_TIME_STAMP_COUNTER,
diff -puN drivers/kvm/kvm_svm.h~kvm-replace-__x86_64__-with-config_x86_64 drivers/kvm/kvm_svm.h
--- a/drivers/kvm/kvm_svm.h~kvm-replace-__x86_64__-with-config_x86_64
+++ a/drivers/kvm/kvm_svm.h
@@ -9,7 +9,7 @@
 #include "kvm.h"
 
 static const u32 host_save_msrs[] = {
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
 	MSR_FS_BASE, MSR_GS_BASE,
 #endif
diff -puN drivers/kvm/kvm_vmx.h~kvm-replace-__x86_64__-with-config_x86_64 drivers/kvm/kvm_vmx.h
--- a/drivers/kvm/kvm_vmx.h~kvm-replace-__x86_64__-with-config_x86_64
+++ a/drivers/kvm/kvm_vmx.h
@@ -1,7 +1,7 @@
 #ifndef __KVM_VMX_H
 #define __KVM_VMX_H
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 /*
  * avoid save/load MSR_SYSCALL_MASK and MSR_LSTAR by std vt
  * mechanism (cpu bug AA24)
diff -puN drivers/kvm/svm.c~kvm-replace-__x86_64__-with-config_x86_64 drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-replace-__x86_64__-with-config_x86_64
+++ a/drivers/kvm/svm.c
@@ -287,7 +287,7 @@ static void svm_hardware_enable(void *ga
 
 	struct svm_cpu_data *svm_data;
 	uint64_t efer;
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	struct desc_ptr gdt_descr;
 #else
 	struct Xgt_desc_struct gdt_descr;
@@ -397,7 +397,7 @@ static __init int svm_hardware_setup(voi
 	memset(msrpm_va, 0xff, PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER));
 	msrpm_base = page_to_pfn(msrpm_pages) << PAGE_SHIFT;
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	set_msr_interception(msrpm_va, MSR_GS_BASE, 1, 1);
 	set_msr_interception(msrpm_va, MSR_FS_BASE, 1, 1);
 	set_msr_interception(msrpm_va, MSR_KERNEL_GS_BASE, 1, 1);
@@ -704,7 +704,7 @@ static void svm_set_gdt(struct kvm_vcpu 
 
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	if (vcpu->shadow_efer & KVM_EFER_LME) {
 		if (!is_paging(vcpu) && (cr0 & CR0_PG_MASK)) {
 			vcpu->shadow_efer |= KVM_EFER_LMA;
@@ -1097,7 +1097,7 @@ static int svm_get_msr(struct kvm_vcpu *
 	case MSR_IA32_APICBASE:
 		*data = vcpu->apic_base;
 		break;
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	case MSR_STAR:
 		*data = vcpu->svm->vmcb->save.star;
 		break;
@@ -1149,7 +1149,7 @@ static int rdmsr_interception(struct kvm
 static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 {
 	switch (ecx) {
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	case MSR_EFER:
 		set_efer(vcpu, data);
 		break;
@@ -1172,7 +1172,7 @@ static int svm_set_msr(struct kvm_vcpu *
 	case MSR_IA32_APICBASE:
 		vcpu->apic_base = data;
 		break;
-#ifdef __x86_64___
+#ifdef CONFIG_X86_64_
 	case MSR_STAR:
 		vcpu->svm->vmcb->save.star = data;
 		break;
@@ -1387,7 +1387,7 @@ again:
 		load_db_regs(vcpu->svm->db_regs);
 	}
 	asm volatile (
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 		"push %%rbx; push %%rcx; push %%rdx;"
 		"push %%rsi; push %%rdi; push %%rbp;"
 		"push %%r8;  push %%r9;  push %%r10; push %%r11;"
@@ -1397,7 +1397,7 @@ again:
 		"push %%esi; push %%edi; push %%ebp;"
 #endif
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 		"mov %c[rbx](%[vcpu]), %%rbx \n\t"
 		"mov %c[rcx](%[vcpu]), %%rcx \n\t"
 		"mov %c[rdx](%[vcpu]), %%rdx \n\t"
@@ -1421,7 +1421,7 @@ again:
 		"mov %c[rbp](%[vcpu]), %%ebp \n\t"
 #endif
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 		/* Enter guest mode */
 		"push %%rax \n\t"
 		"mov %c[svm](%[vcpu]), %%rax \n\t"
@@ -1442,7 +1442,7 @@ again:
 #endif
 
 		/* Save guest registers, load host registers */
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 		"mov %%rbx, %c[rbx](%[vcpu]) \n\t"
 		"mov %%rcx, %c[rcx](%[vcpu]) \n\t"
 		"mov %%rdx, %c[rdx](%[vcpu]) \n\t"
@@ -1483,7 +1483,7 @@ again:
 		  [rsi]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RSI])),
 		  [rdi]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RDI])),
 		  [rbp]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RBP]))
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 		  ,[r8 ]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R8 ])),
 		  [r9 ]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R9 ])),
 		  [r10]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R10])),
diff -puN drivers/kvm/vmx.c~kvm-replace-__x86_64__-with-config_x86_64 drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-replace-__x86_64__-with-config_x86_64
+++ a/drivers/kvm/vmx.c
@@ -34,7 +34,7 @@ MODULE_LICENSE("GPL");
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 #define HOST_IS_64 1
 #else
 #define HOST_IS_64 0
@@ -71,7 +71,7 @@ static struct kvm_vmx_segment_field {
 };
 
 static const u32 vmx_msr_index[] = {
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR, MSR_KERNEL_GS_BASE,
 #endif
 	MSR_EFER, MSR_K6_STAR,
@@ -138,7 +138,7 @@ static u32 vmcs_read32(unsigned long fie
 
 static u64 vmcs_read64(unsigned long field)
 {
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	return vmcs_readl(field);
 #else
 	return vmcs_readl(field) | ((u64)vmcs_readl(field+1) << 32);
@@ -168,7 +168,7 @@ static void vmcs_write32(unsigned long f
 
 static void vmcs_write64(unsigned long field, u64 value)
 {
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	vmcs_writel(field, value);
 #else
 	vmcs_writel(field, value);
@@ -297,7 +297,7 @@ static void guest_write_tsc(u64 guest_ts
 
 static void reload_tss(void)
 {
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 
 	/*
 	 * VT restores TR but not its size.  Useless.
@@ -328,7 +328,7 @@ static int vmx_get_msr(struct kvm_vcpu *
 	}
 
 	switch (msr_index) {
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	case MSR_FS_BASE:
 		data = vmcs_readl(GUEST_FS_BASE);
 		break;
@@ -391,7 +391,7 @@ static int vmx_set_msr(struct kvm_vcpu *
 {
 	struct vmx_msr_entry *msr;
 	switch (msr_index) {
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	case MSR_FS_BASE:
 		vmcs_writel(GUEST_FS_BASE, data);
 		break;
@@ -726,7 +726,7 @@ static void enter_rmode(struct kvm_vcpu 
 	fix_rmode_seg(VCPU_SREG_FS, &vcpu->rmode.fs);
 }
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 
 static void enter_lmode(struct kvm_vcpu *vcpu)
 {
@@ -768,7 +768,7 @@ static void vmx_set_cr0(struct kvm_vcpu 
 	if (!vcpu->rmode.active && !(cr0 & CR0_PE_MASK))
 		enter_rmode(vcpu);
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	if (vcpu->shadow_efer & EFER_LME) {
 		if (!is_paging(vcpu) && (cr0 & CR0_PG_MASK))
 			enter_lmode(vcpu);
@@ -809,7 +809,7 @@ static void vmx_set_cr4(struct kvm_vcpu 
 	vcpu->cr4 = cr4;
 }
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 
 static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
@@ -1096,7 +1096,7 @@ static int vmx_vcpu_setup(struct kvm_vcp
 	vmcs_write16(HOST_FS_SELECTOR, read_fs());    /* 22.2.4 */
 	vmcs_write16(HOST_GS_SELECTOR, read_gs());    /* 22.2.4 */
 	vmcs_write16(HOST_SS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	rdmsrl(MSR_FS_BASE, a);
 	vmcs_writel(HOST_FS_BASE, a); /* 22.2.4 */
 	rdmsrl(MSR_GS_BASE, a);
@@ -1174,7 +1174,7 @@ static int vmx_vcpu_setup(struct kvm_vcp
 	vcpu->cr0 = 0x60000010;
 	vmx_set_cr0(vcpu, vcpu->cr0); // enter rmode
 	vmx_set_cr4(vcpu, 0);
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	vmx_set_efer(vcpu, 0);
 #endif
 
@@ -1690,7 +1690,7 @@ again:
 		vmcs_write16(HOST_GS_SELECTOR, 0);
 	}
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	vmcs_writel(HOST_FS_BASE, read_msr(MSR_FS_BASE));
 	vmcs_writel(HOST_GS_BASE, read_msr(MSR_GS_BASE));
 #else
@@ -1714,7 +1714,7 @@ again:
 	asm (
 		/* Store host registers */
 		"pushf \n\t"
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 		"push %%rax; push %%rbx; push %%rdx;"
 		"push %%rsi; push %%rdi; push %%rbp;"
 		"push %%r8;  push %%r9;  push %%r10; push %%r11;"
@@ -1728,7 +1728,7 @@ again:
 		/* Check if vmlaunch of vmresume is needed */
 		"cmp $0, %1 \n\t"
 		/* Load guest registers.  Don't clobber flags. */
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 		"mov %c[cr2](%3), %%rax \n\t"
 		"mov %%rax, %%cr2 \n\t"
 		"mov %c[rax](%3), %%rax \n\t"
@@ -1765,7 +1765,7 @@ again:
 		".globl kvm_vmx_return \n\t"
 		"kvm_vmx_return: "
 		/* Save guest registers, load host registers, keep flags */
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 		"xchg %3,     0(%%rsp) \n\t"
 		"mov %%rax, %c[rax](%3) \n\t"
 		"mov %%rbx, %c[rbx](%3) \n\t"
@@ -1817,7 +1817,7 @@ again:
 		[rsi]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RSI])),
 		[rdi]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RDI])),
 		[rbp]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RBP])),
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 		[r8 ]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R8 ])),
 		[r9 ]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R9 ])),
 		[r10]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R10])),
@@ -1838,7 +1838,7 @@ again:
 	fx_save(vcpu->guest_fx_image);
 	fx_restore(vcpu->host_fx_image);
 
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
 #endif
 
@@ -1856,7 +1856,7 @@ again:
 			 */
 			local_irq_disable();
 			load_gs(gs_sel);
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 			wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
 #endif
 			local_irq_enable();
@@ -1966,7 +1966,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.set_cr0_no_modeswitch = vmx_set_cr0_no_modeswitch,
 	.set_cr3 = vmx_set_cr3,
 	.set_cr4 = vmx_set_cr4,
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	.set_efer = vmx_set_efer,
 #endif
 	.get_idt = vmx_get_idt,
diff -puN drivers/kvm/x86_emulate.c~kvm-replace-__x86_64__-with-config_x86_64 drivers/kvm/x86_emulate.c
--- a/drivers/kvm/x86_emulate.c~kvm-replace-__x86_64__-with-config_x86_64
+++ a/drivers/kvm/x86_emulate.c
@@ -238,7 +238,7 @@ struct operand {
  * any modified flags.
  */
 
-#if defined(__x86_64__)
+#if defined(CONFIG_X86_64)
 #define _LO32 "k"		/* force 32-bit operand */
 #define _STK  "%%rsp"		/* stack pointer */
 #elif defined(__i386__)
@@ -385,7 +385,7 @@ struct operand {
 	} while (0)
 
 /* Emulate an instruction with quadword operands (x86/64 only). */
-#if defined(__x86_64__)
+#if defined(CONFIG_X86_64)
 #define __emulate_2op_8byte(_op, _src, _dst, _eflags, _qx, _qy)           \
 	do {								  \
 		__asm__ __volatile__ (					  \
@@ -495,7 +495,7 @@ x86_emulate_memop(struct x86_emulate_ctx
 	case X86EMUL_MODE_PROT32:
 		op_bytes = ad_bytes = 4;
 		break;
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	case X86EMUL_MODE_PROT64:
 		op_bytes = 4;
 		ad_bytes = 8;
@@ -1341,7 +1341,7 @@ twobyte_special_insn:
 			}
 			break;
 		}
-#elif defined(__x86_64__)
+#elif defined(CONFIG_X86_64)
 		{
 			unsigned long old, new;
 			if ((rc = ops->read_emulated(cr2, &old, 8, ctxt)) != 0)
diff -puN drivers/kvm/x86_emulate.h~kvm-replace-__x86_64__-with-config_x86_64 drivers/kvm/x86_emulate.h
--- a/drivers/kvm/x86_emulate.h~kvm-replace-__x86_64__-with-config_x86_64
+++ a/drivers/kvm/x86_emulate.h
@@ -162,7 +162,7 @@ struct x86_emulate_ctxt {
 /* Host execution mode. */
 #if defined(__i386__)
 #define X86EMUL_MODE_HOST X86EMUL_MODE_PROT32
-#elif defined(__x86_64__)
+#elif defined(CONFIG_X86_64)
 #define X86EMUL_MODE_HOST X86EMUL_MODE_PROT64
 #endif
 
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-add-valid_vcpu-helper.patch
kvm-amd-svm-handle-msr_star-in-32-bit-mode.patch
kvm-amd-svm-save-and-restore-the-floating-point-unit.patch

