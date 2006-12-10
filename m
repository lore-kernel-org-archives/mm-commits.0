From: akpm@osdl.org
Subject: - kvm-dynamically-determine-which-msrs-to-load-and-save.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:53:16 -0800
Message-ID: <200612100753.kBA7rGkj017715@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59622 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760458AbWLJHxT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:53:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm: Dynamically determine which msrs to load and save
has been removed from the -mm tree.  Its filename was
     kvm-dynamically-determine-which-msrs-to-load-and-save.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: kvm: Dynamically determine which msrs to load and save
From: Avi Kivity <avi@qumranet.com>

Different cpus have different msrs available.  The Core (not Core 2)
cpu lacks the STAR msr, so kvm faults when accessing it.

Fix by determining which msrs are available dynamically, and only loading
and saving available msrs.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    1 
 drivers/kvm/kvm_main.c |   74 ++++++++++++++++++++++-----------------
 2 files changed, 44 insertions(+), 31 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-dynamically-determine-which-msrs-to-load-and-save drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-dynamically-determine-which-msrs-to-load-and-save
+++ a/drivers/kvm/kvm.h
@@ -174,6 +174,7 @@ struct kvm_vcpu {
 	unsigned long cr8;
 	u64 shadow_efer;
 	u64 apic_base;
+	int nmsrs;
 	struct vmx_msr_entry *guest_msrs;
 	struct vmx_msr_entry *host_msrs;
 
diff -puN drivers/kvm/kvm_main.c~kvm-dynamically-determine-which-msrs-to-load-and-save drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-dynamically-determine-which-msrs-to-load-and-save
+++ a/drivers/kvm/kvm_main.c
@@ -98,22 +98,21 @@ static struct kvm_vmx_segment_field {
 };
 
 static const u32 vmx_msr_index[] = {
-	MSR_EFER, MSR_K6_STAR,
 #ifdef __x86_64__
-	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR
+	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR, MSR_KERNEL_GS_BASE,
 #endif
+	MSR_EFER, MSR_K6_STAR,
 };
 #define NR_VMX_MSR (sizeof(vmx_msr_index) / sizeof(*vmx_msr_index))
 
-
 #ifdef __x86_64__
 /*
  * avoid save/load MSR_SYSCALL_MASK and MSR_LSTAR by std vt
  * mechanism (cpu bug AA24)
  */
-#define NUM_AUTO_MSRS (NR_VMX_MSR-2)
+#define NR_BAD_MSRS 2
 #else
-#define NUM_AUTO_MSRS NR_VMX_MSR
+#define NR_BAD_MSRS 0
 #endif
 
 #define TSS_IOPB_BASE_OFFSET 0x66
@@ -146,8 +145,8 @@ static struct vmx_msr_entry *find_msr_en
 {
 	int i;
 
-	for (i = 0; i < NR_VMX_MSR; ++i)
-		if (vmx_msr_index[i] == msr)
+	for (i = 0; i < vcpu->nmsrs; ++i)
+		if (vcpu->guest_msrs[i].index == msr)
 			return &vcpu->guest_msrs[i];
 	return 0;
 }
@@ -1182,6 +1181,7 @@ static int kvm_vcpu_setup(struct kvm_vcp
 	int i;
 	int ret;
 	u64 tsc;
+	int nr_good_msrs;
 
 
 	if (!init_rmode_tss(vcpu->kvm)) {
@@ -1315,12 +1315,6 @@ static int kvm_vcpu_setup(struct kvm_vcp
 	rdmsrl(MSR_IA32_SYSENTER_EIP, a);
 	vmcs_writel(HOST_IA32_SYSENTER_EIP, a);   /* 22.2.3 */
 
-	vmcs_write32_fixedbits(MSR_IA32_VMX_EXIT_CTLS_MSR, VM_EXIT_CONTROLS,
-		     	       (HOST_IS_64 << 9));  /* 22.2,1, 20.7.1 */
-	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, NUM_AUTO_MSRS); /* 22.2.2 */
-	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, NUM_AUTO_MSRS);  /* 22.2.2 */
-	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, NUM_AUTO_MSRS); /* 22.2.2 */
-
 	ret = -ENOMEM;
 	vcpu->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!vcpu->guest_msrs)
@@ -1331,18 +1325,34 @@ static int kvm_vcpu_setup(struct kvm_vcp
 
 	for (i = 0; i < NR_VMX_MSR; ++i) {
 		u32 index = vmx_msr_index[i];
+		u32 data_low, data_high;
 		u64 data;
+		int j = vcpu->nmsrs;
 
-		rdmsrl(index, data);
-		vcpu->host_msrs[i].index = index;
-		vcpu->host_msrs[i].reserved = 0;
-		vcpu->host_msrs[i].data = data;
-		vcpu->guest_msrs[i] = vcpu->host_msrs[i];
-	}
+		if (rdmsr_safe(index, &data_low, &data_high) < 0)
+			continue;
+		data = data_low | ((u64)data_high << 32);
+		vcpu->host_msrs[j].index = index;
+		vcpu->host_msrs[j].reserved = 0;
+		vcpu->host_msrs[j].data = data;
+		vcpu->guest_msrs[j] = vcpu->host_msrs[j];
+		++vcpu->nmsrs;
+	}
+	printk("msrs: %d\n", vcpu->nmsrs);
+
+	nr_good_msrs = vcpu->nmsrs - NR_BAD_MSRS;
+	vmcs_writel(VM_ENTRY_MSR_LOAD_ADDR,
+		    virt_to_phys(vcpu->guest_msrs + NR_BAD_MSRS));
+	vmcs_writel(VM_EXIT_MSR_STORE_ADDR,
+		    virt_to_phys(vcpu->guest_msrs + NR_BAD_MSRS));
+	vmcs_writel(VM_EXIT_MSR_LOAD_ADDR,
+		    virt_to_phys(vcpu->host_msrs + NR_BAD_MSRS));
+	vmcs_write32_fixedbits(MSR_IA32_VMX_EXIT_CTLS_MSR, VM_EXIT_CONTROLS,
+		     	       (HOST_IS_64 << 9));  /* 22.2,1, 20.7.1 */
+	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, nr_good_msrs); /* 22.2.2 */
+	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, nr_good_msrs);  /* 22.2.2 */
+	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, nr_good_msrs); /* 22.2.2 */
 
-	vmcs_writel(VM_ENTRY_MSR_LOAD_ADDR, virt_to_phys(vcpu->guest_msrs));
-	vmcs_writel(VM_EXIT_MSR_STORE_ADDR, virt_to_phys(vcpu->guest_msrs));
-	vmcs_writel(VM_EXIT_MSR_LOAD_ADDR, virt_to_phys(vcpu->host_msrs));
 
 	/* 22.2.1, 20.8.1 */
 	vmcs_write32_fixedbits(MSR_IA32_VMX_ENTRY_CTLS_MSR,
@@ -2607,18 +2617,20 @@ static void kvm_guest_debug_pre(struct k
 	}
 }
 
-static void load_msrs(struct vmx_msr_entry *e)
+static void load_msrs(struct vmx_msr_entry *e, int n)
 {
 	int i;
 
-	for (i = NUM_AUTO_MSRS; i < NR_VMX_MSR; ++i)
+	for (i = 0; i < n; ++i)
 		wrmsrl(e[i].index, e[i].data);
 }
 
-static void save_msrs(struct vmx_msr_entry *e, int msr_index)
+static void save_msrs(struct vmx_msr_entry *e, int n)
 {
-	for (; msr_index < NR_VMX_MSR; ++msr_index)
-		rdmsrl(e[msr_index].index, e[msr_index].data);
+	int i;
+
+	for (i = 0; i < n; ++i)
+		rdmsrl(e[i].index, e[i].data);
 }
 
 static int kvm_dev_ioctl_run(struct kvm *kvm, struct kvm_run *kvm_run)
@@ -2679,8 +2691,8 @@ again:
 	fx_save(vcpu->host_fx_image);
 	fx_restore(vcpu->guest_fx_image);
 
-	save_msrs(vcpu->host_msrs, 0);
-	load_msrs(vcpu->guest_msrs);
+	save_msrs(vcpu->host_msrs, vcpu->nmsrs);
+	load_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
 
 	asm (
 		/* Store host registers */
@@ -2803,8 +2815,8 @@ again:
 
 	++kvm_stat.exits;
 
-	save_msrs(vcpu->guest_msrs, NUM_AUTO_MSRS);
-	load_msrs(vcpu->host_msrs);
+	save_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
+	load_msrs(vcpu->host_msrs, NR_BAD_MSRS);
 
 	fx_save(vcpu->guest_fx_image);
 	fx_restore(vcpu->host_fx_image);
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-dynamically-determine-which-msrs-to-load-and-save.patch
kvm-fix-calculation-of-initial-value-of-rdx-register.patch
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

