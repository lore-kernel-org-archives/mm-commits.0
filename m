From: akpm@osdl.org
Subject: - kvm-avoid-using-vmx-instruction-directly.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:53:23 -0800
Message-ID: <200612100753.kBA7rNFc017721@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59630 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760375AbWLJHx0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:53:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Avoid using vmx instruction directly
has been removed from the -mm tree.  Its filename was
     kvm-avoid-using-vmx-instruction-directly.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Avoid using vmx instruction directly
From: Avi Kivity <avi@qumranet.com>

Some users have an older assembler installed which doesn't grok the vmx
instructions.

Fix by encoding the instruction opcodes directly.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |   10 ++++++++++
 drivers/kvm/kvm_main.c |   29 +++++++++++++++--------------
 2 files changed, 25 insertions(+), 14 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-avoid-using-vmx-instruction-directly drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-avoid-using-vmx-instruction-directly
+++ a/drivers/kvm/kvm.h
@@ -378,6 +378,16 @@ static inline struct kvm_mmu_page *page_
 	return (struct kvm_mmu_page *)page->private;
 }
 
+#define ASM_VMX_VMCLEAR_RAX       ".byte 0x66, 0x0f, 0xc7, 0x30"
+#define ASM_VMX_VMLAUNCH          ".byte 0x0f, 0x01, 0xc2"
+#define ASM_VMX_VMRESUME          ".byte 0x0f, 0x01, 0xc3"
+#define ASM_VMX_VMPTRLD_RAX       ".byte 0x0f, 0xc7, 0x30"
+#define ASM_VMX_VMREAD_RDX_RAX    ".byte 0x0f, 0x78, 0xd0"
+#define ASM_VMX_VMWRITE_RAX_RDX   ".byte 0x0f, 0x79, 0xd0"
+#define ASM_VMX_VMWRITE_RSP_RDX   ".byte 0x0f, 0x79, 0xd4"
+#define ASM_VMX_VMXOFF            ".byte 0x0f, 0x01, 0xc4"
+#define ASM_VMX_VMXON_RAX         ".byte 0xf3, 0x0f, 0xc7, 0x30"
+
 #ifdef __x86_64__
 
 /*
diff -puN drivers/kvm/kvm_main.c~kvm-avoid-using-vmx-instruction-directly drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-avoid-using-vmx-instruction-directly
+++ a/drivers/kvm/kvm_main.c
@@ -405,8 +405,8 @@ static void vmcs_clear(struct vmcs *vmcs
 	u64 phys_addr = __pa(vmcs);
 	u8 error;
 
-	asm volatile ("vmclear %1; setna %0"
-		       : "=m"(error) : "m"(phys_addr) : "cc", "memory" );
+	asm volatile (ASM_VMX_VMCLEAR_RAX "; setna %0"
+		       : "=g"(error) : "a"(&phys_addr) : "cc", "memory" );
 	if (error)
 		printk(KERN_ERR "kvm: vmclear fail: %p/%llx\n",
 		       vmcs, phys_addr);
@@ -448,8 +448,8 @@ static struct kvm_vcpu *__vcpu_load(stru
 		u8 error;
 
 		per_cpu(current_vmcs, cpu) = vcpu->vmcs;
-		asm volatile ("vmptrld %1; setna %0"
-			       : "=m"(error) : "m"(phys_addr) : "cc" );
+		asm volatile (ASM_VMX_VMPTRLD_RAX "; setna %0"
+			       : "=g"(error) : "a"(&phys_addr) : "cc" );
 		if (error)
 			printk(KERN_ERR "kvm: vmptrld %p/%llx fail\n",
 			       vcpu->vmcs, phys_addr);
@@ -572,12 +572,12 @@ static __init void kvm_enable(void *garb
 		/* enable and lock */
 		wrmsrl(MSR_IA32_FEATURE_CONTROL, old | 5);
 	write_cr4(read_cr4() | CR4_VMXE); /* FIXME: not cpu hotplug safe */
-	asm volatile ("vmxon %0" : : "m"(phys_addr) : "memory", "cc");
+	asm volatile (ASM_VMX_VMXON_RAX : : "a"(&phys_addr) : "memory", "cc");
 }
 
 static void kvm_disable(void *garbage)
 {
-	asm volatile ("vmxoff" : : : "cc");
+	asm volatile (ASM_VMX_VMXOFF : : : "cc");
 }
 
 static int kvm_dev_open(struct inode *inode, struct file *filp)
@@ -669,7 +669,8 @@ unsigned long vmcs_readl(unsigned long f
 {
 	unsigned long value;
 
-	asm volatile ("vmread %1, %0" : "=g"(value) : "r"(field) : "cc");
+	asm volatile (ASM_VMX_VMREAD_RDX_RAX
+		      : "=a"(value) : "d"(field) : "cc");
 	return value;
 }
 
@@ -677,8 +678,8 @@ void vmcs_writel(unsigned long field, un
 {
 	u8 error;
 
-	asm volatile ("vmwrite %1, %2; setna %0"
-		       : "=g"(error) : "r"(value), "r"(field) : "cc" );
+	asm volatile (ASM_VMX_VMWRITE_RAX_RDX "; setna %0"
+		       : "=q"(error) : "a"(value), "d"(field) : "cc" );
 	if (error)
 		printk(KERN_ERR "vmwrite error: reg %lx value %lx (err %d)\n",
 		       field, value, vmcs_read32(VM_INSTRUCTION_ERROR));
@@ -2698,10 +2699,10 @@ again:
 		"push %%r8;  push %%r9;  push %%r10; push %%r11;"
 		"push %%r12; push %%r13; push %%r14; push %%r15;"
 		"push %%rcx \n\t"
-		"vmwrite %%rsp, %2 \n\t"
+		ASM_VMX_VMWRITE_RSP_RDX "\n\t"
 #else
 		"pusha; push %%ecx \n\t"
-		"vmwrite %%esp, %2 \n\t"
+		ASM_VMX_VMWRITE_RSP_RDX "\n\t"
 #endif
 		/* Check if vmlaunch of vmresume is needed */
 		"cmp $0, %1 \n\t"
@@ -2737,9 +2738,9 @@ again:
 #endif
 		/* Enter guest mode */
 		"jne launched \n\t"
-		"vmlaunch \n\t"
+		ASM_VMX_VMLAUNCH "\n\t"
 		"jmp kvm_vmx_return \n\t"
-		"launched: vmresume \n\t"
+		"launched: " ASM_VMX_VMRESUME "\n\t"
 		".globl kvm_vmx_return \n\t"
 		"kvm_vmx_return: "
 		/* Save guest registers, load host registers, keep flags */
@@ -2786,7 +2787,7 @@ again:
 		"setbe %0 \n\t"
 		"popf \n\t"
 	      : "=g" (fail)
-	      : "r"(vcpu->launched), "r"((unsigned long)HOST_RSP),
+	      : "r"(vcpu->launched), "d"((unsigned long)HOST_RSP),
 		"c"(vcpu),
 		[rax]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RAX])),
 		[rbx]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RBX])),
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-avoid-using-vmx-instruction-directly.patch
kvm-avoid-using-vmx-instruction-directly-fix-asm-constraints.patch
kvm-expose-interrupt-bitmap.patch
kvm-add-time-stamp-counter-msr-and-accessors.patch
kvm-expose-msrs-to-userspace.patch
kvm-expose-msrs-to-userspace-v2.patch
kvm-create-kvm-intelko-module.patch
kvm-make-dev-registration-happen-when-the-arch.patch
kvm-make-hardware-detection-an-arch-operation.patch
kvm-make-the-per-cpu-enable-disable-functions-arch.patch
kvm-make-the-hardware-setup-operations-non-percpu.patch
kvm-make-the-guest-debugger-an-arch-operation.patch
kvm-make-msr-accessors-arch-operations.patch
kvm-make-the-segment-accessors-arch-operations.patch
kvm-cache-guest-cr4-in-vcpu-structure.patch
kvm-cache-guest-cr0-in-vcpu-structure.patch
kvm-add-get_segment_base-arch-accessor.patch
kvm-add-idt-and-gdt-descriptor-accessors.patch
kvm-make-syncing-the-register-file-to-the-vcpu.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation-build-fix.patch
kvm-move-the-vmx-exit-handlers-to-vmxc.patch
kvm-make-vcpu_setup-an-arch-operation.patch
kvm-make-__set_cr0-and-dependencies-arch-operations.patch
kvm-make-__set_cr4-an-arch-operation.patch
kvm-make-__set_efer-an-arch-operation.patch
kvm-make-__set_efer-an-arch-operation-build-fix.patch
kvm-make-set_cr3-and-tlb-flushing-arch-operations.patch
kvm-make-inject_page_fault-an-arch-operation.patch
kvm-make-inject_gp-an-arch-operation.patch
kvm-use-the-idt-and-gdt-accessors-in-realmode-emulation.patch
kvm-use-the-general-purpose-register-accessors-rather.patch
kvm-move-the-vmx-tsc-accessors-to-vmxc.patch
kvm-access-rflags-through-an-arch-operation.patch
kvm-move-the-vmx-segment-field-definitions-to-vmxc.patch
kvm-add-an-arch-accessor-for-cs-d-b-and-l-bits.patch
kvm-add-a-set_cr0_no_modeswitch-arch-accessor.patch
kvm-make-vcpu_load-and-vcpu_put-arch-operations.patch
kvm-make-vcpu-creation-and-destruction-arch-operations.patch
kvm-move-vmcs-static-variables-to-vmxc.patch
kvm-make-is_long_mode-an-arch-operation.patch
kvm-use-the-tlb-flush-arch-operation-instead-of-an.patch
kvm-remove-guest_cpl.patch
kvm-move-vmcs-accessors-to-vmxc.patch
kvm-move-vmx-helper-inlines-to-vmxc.patch
kvm-remove-vmx-includes-from-arch-independent-code.patch
kvm-amd-svm-add-architecture-definitions-for-amd-svm.patch
kvm-amd-svm-enhance-x86-emulator.patch
kvm-amd-svm-enhance-x86-emulator-fix-mov-to-from-control-register-emulation.patch
kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu.patch
kvm-amd-svm-add-data-structures.patch
kvm-amd-svm-implementation.patch
kvm-amd-svm-implementation-avoid-three-more-new-instructions.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
kvm-amd-svm-implementation-printk-log-levels.patch
kvm-amd-svm-plumbing.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
kvm-load-i386-segment-bases.patch

