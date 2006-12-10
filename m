From: akpm@osdl.org
Subject: - kvm-make-msr-accessors-arch-operations.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:54:00 -0800
Message-ID: <200612100754.kBA7s0G1017762@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59687 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760491AbWLJHyD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:54:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: make msr accessors arch operations
has been removed from the -mm tree.  Its filename was
     kvm-make-msr-accessors-arch-operations.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: make msr accessors arch operations
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    4 +
 drivers/kvm/kvm_main.c |  127 ++--------------------------------
 drivers/kvm/vmx.c      |  142 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 156 insertions(+), 117 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-make-msr-accessors-arch-operations drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-make-msr-accessors-arch-operations
+++ a/drivers/kvm/kvm.h
@@ -245,6 +245,8 @@ struct kvm_arch_ops {
 
 	int (*set_guest_debug)(struct kvm_vcpu *vcpu,
 			       struct kvm_debug_guest *dbg);
+	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata);
+	int (*set_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 };
 
 extern struct kvm_stat kvm_stat;
@@ -401,6 +403,8 @@ static inline struct kvm_mmu_page *page_
 #define ASM_VMX_VMXOFF            ".byte 0x0f, 0x01, 0xc4"
 #define ASM_VMX_VMXON_RAX         ".byte 0xf3, 0x0f, 0xc7, 0x30"
 
+#define MSR_IA32_TIME_STAMP_COUNTER		0x010
+
 #ifdef __x86_64__
 
 /*
diff -puN drivers/kvm/kvm_main.c~kvm-make-msr-accessors-arch-operations drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-make-msr-accessors-arch-operations
+++ a/drivers/kvm/kvm_main.c
@@ -122,7 +122,6 @@ static const u32 vmx_msr_index[] = {
 #define TSS_REDIRECTION_SIZE (256 / 8)
 #define RMODE_TSS_SIZE (TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
 
-#define MSR_IA32_TIME_STAMP_COUNTER		0x010
 #define MSR_IA32_FEATURE_CONTROL 		0x03a
 #define MSR_IA32_VMX_PINBASED_CTLS_MSR		0x481
 #define MSR_IA32_VMX_PROCBASED_CTLS_MSR		0x482
@@ -143,7 +142,7 @@ static const u32 vmx_msr_index[] = {
 #define HOST_IS_64 0
 #endif
 
-static struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr)
+struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr)
 {
 	int i;
 
@@ -152,6 +151,7 @@ static struct vmx_msr_entry *find_msr_en
 			return &vcpu->guest_msrs[i];
 	return 0;
 }
+EXPORT_SYMBOL_GPL(find_msr_entry);
 
 struct descriptor_table {
 	u16 limit;
@@ -657,7 +657,7 @@ static void inject_gp(struct kvm_vcpu *v
  * reads and returns guest's timestamp counter "register"
  * guest_tsc = host_tsc + tsc_offset    -- 21.3
  */
-static u64 guest_read_tsc(void)
+u64 guest_read_tsc(void)
 {
 	u64 host_tsc, tsc_offset;
 
@@ -665,18 +665,20 @@ static u64 guest_read_tsc(void)
 	tsc_offset = vmcs_read64(TSC_OFFSET);
 	return host_tsc + tsc_offset;
 }
+EXPORT_SYMBOL_GPL(guest_read_tsc);
 
 /*
  * writes 'guest_tsc' into guest's timestamp counter "register"
  * guest_tsc = host_tsc + tsc_offset ==> tsc_offset = guest_tsc - host_tsc
  */
-static void guest_write_tsc(u64 guest_tsc)
+void guest_write_tsc(u64 guest_tsc)
 {
 	u64 host_tsc;
 
 	rdtscll(host_tsc);
 	vmcs_write64(TSC_OFFSET, guest_tsc - host_tsc);
 }
+EXPORT_SYMBOL_GPL(guest_write_tsc);
 
 static void update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
@@ -2243,67 +2245,7 @@ static int handle_cpuid(struct kvm_vcpu 
  */
 static int get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 {
-	u64 data;
-	struct vmx_msr_entry *msr;
-
-	if (!pdata) {
-		printk(KERN_ERR "BUG: get_msr called with NULL pdata\n");
-		return -EINVAL;
-	}
-
-	switch (msr_index) {
-#ifdef __x86_64__
-	case MSR_FS_BASE:
-		data = vmcs_readl(GUEST_FS_BASE);
-		break;
-	case MSR_GS_BASE:
-		data = vmcs_readl(GUEST_GS_BASE);
-		break;
-	case MSR_EFER:
-		data = vcpu->shadow_efer;
-		break;
-#endif
-	case MSR_IA32_TIME_STAMP_COUNTER:
-		data = guest_read_tsc();
-		break;
-	case MSR_IA32_SYSENTER_CS:
-		data = vmcs_read32(GUEST_SYSENTER_CS);
-		break;
-	case MSR_IA32_SYSENTER_EIP:
-		data = vmcs_read32(GUEST_SYSENTER_EIP);
-		break;
-	case MSR_IA32_SYSENTER_ESP:
-		data = vmcs_read32(GUEST_SYSENTER_ESP);
-		break;
-	case MSR_IA32_MC0_CTL:
-	case MSR_IA32_MCG_STATUS:
-	case MSR_IA32_MCG_CAP:
-	case MSR_IA32_MC0_MISC:
-	case MSR_IA32_MC0_MISC+4:
-	case MSR_IA32_MC0_MISC+8:
-	case MSR_IA32_MC0_MISC+12:
-	case MSR_IA32_MC0_MISC+16:
-	case MSR_IA32_UCODE_REV:
-		/* MTRR registers */
-	case 0xfe:
-	case 0x200 ... 0x2ff:
-		data = 0;
-		break;
-	case MSR_IA32_APICBASE:
-		data = vcpu->apic_base;
-		break;
-	default:
-		msr = find_msr_entry(vcpu, msr_index);
-		if (!msr) {
-			printk(KERN_ERR "kvm: unhandled rdmsr: %x\n", msr_index);
-			return 1;
-		}
-		data = msr->data;
-		break;
-	}
-
-	*pdata = data;
-	return 0;
+	return kvm_arch_ops->get_msr(vcpu, msr_index, pdata);
 }
 
 static int handle_rdmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
@@ -2325,7 +2267,7 @@ static int handle_rdmsr(struct kvm_vcpu 
 
 #ifdef __x86_64__
 
-static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
+void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	struct vmx_msr_entry *msr;
 
@@ -2354,10 +2296,10 @@ static void set_efer(struct kvm_vcpu *vc
 	msr->data = efer;
 	skip_emulated_instruction(vcpu);
 }
+EXPORT_SYMBOL_GPL(set_efer);
 
 #endif
 
-
 /*
  * Writes msr value into into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -2365,56 +2307,7 @@ static void set_efer(struct kvm_vcpu *vc
  */
 static int set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
-	struct vmx_msr_entry *msr;
-	switch (msr_index) {
-#ifdef __x86_64__
-	case MSR_FS_BASE:
-		vmcs_writel(GUEST_FS_BASE, data);
-		break;
-	case MSR_GS_BASE:
-		vmcs_writel(GUEST_GS_BASE, data);
-		break;
-#endif
-	case MSR_IA32_SYSENTER_CS:
-		vmcs_write32(GUEST_SYSENTER_CS, data);
-		break;
-	case MSR_IA32_SYSENTER_EIP:
-		vmcs_write32(GUEST_SYSENTER_EIP, data);
-		break;
-	case MSR_IA32_SYSENTER_ESP:
-		vmcs_write32(GUEST_SYSENTER_ESP, data);
-		break;
-#ifdef __x86_64
-	case MSR_EFER:
-		set_efer(vcpu, data);
-		break;
-	case MSR_IA32_MC0_STATUS:
-		printk(KERN_WARNING "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n"
-			    , __FUNCTION__, data);
-		break;
-#endif
-	case MSR_IA32_TIME_STAMP_COUNTER: {
-		guest_write_tsc(data);
-		break;
-	}
-	case MSR_IA32_UCODE_REV:
-	case MSR_IA32_UCODE_WRITE:
-	case 0x200 ... 0x2ff: /* MTRRs */
-		break;
-	case MSR_IA32_APICBASE:
-		vcpu->apic_base = data;
-		break;
-	default:
-		msr = find_msr_entry(vcpu, msr_index);
-		if (!msr) {
-			printk(KERN_ERR "kvm: unhandled wrmsr: 0x%x\n", msr_index);
-			return 1;
-		}
-		msr->data = data;
-		break;
-	}
-
-	return 0;
+	return kvm_arch_ops->set_msr(vcpu, msr_index, data);
 }
 
 static int handle_wrmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
diff -puN drivers/kvm/vmx.c~kvm-make-msr-accessors-arch-operations drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-msr-accessors-arch-operations
+++ a/drivers/kvm/vmx.c
@@ -31,6 +31,146 @@ extern struct vmcs_descriptor {
 	u32 revision_id;
 } vmcs_descriptor;
 
+u64 guest_read_tsc(void);
+void guest_write_tsc(u64 guest_tsc);
+struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr);
+
+#ifdef __x86_64__
+
+void set_efer(struct kvm_vcpu *vcpu, u64 efer);
+
+#endif
+
+
+/*
+ * Reads an msr value (of 'msr_index') into 'pdata'.
+ * Returns 0 on success, non-0 otherwise.
+ * Assumes vcpu_load() was already called.
+ */
+static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
+{
+	u64 data;
+	struct vmx_msr_entry *msr;
+
+	if (!pdata) {
+		printk(KERN_ERR "BUG: get_msr called with NULL pdata\n");
+		return -EINVAL;
+	}
+
+	switch (msr_index) {
+#ifdef __x86_64__
+	case MSR_FS_BASE:
+		data = vmcs_readl(GUEST_FS_BASE);
+		break;
+	case MSR_GS_BASE:
+		data = vmcs_readl(GUEST_GS_BASE);
+		break;
+	case MSR_EFER:
+		data = vcpu->shadow_efer;
+		break;
+#endif
+	case MSR_IA32_TIME_STAMP_COUNTER:
+		data = guest_read_tsc();
+		break;
+	case MSR_IA32_SYSENTER_CS:
+		data = vmcs_read32(GUEST_SYSENTER_CS);
+		break;
+	case MSR_IA32_SYSENTER_EIP:
+		data = vmcs_read32(GUEST_SYSENTER_EIP);
+		break;
+	case MSR_IA32_SYSENTER_ESP:
+		data = vmcs_read32(GUEST_SYSENTER_ESP);
+		break;
+	case MSR_IA32_MC0_CTL:
+	case MSR_IA32_MCG_STATUS:
+	case MSR_IA32_MCG_CAP:
+	case MSR_IA32_MC0_MISC:
+	case MSR_IA32_MC0_MISC+4:
+	case MSR_IA32_MC0_MISC+8:
+	case MSR_IA32_MC0_MISC+12:
+	case MSR_IA32_MC0_MISC+16:
+	case MSR_IA32_UCODE_REV:
+		/* MTRR registers */
+	case 0xfe:
+	case 0x200 ... 0x2ff:
+		data = 0;
+		break;
+	case MSR_IA32_APICBASE:
+		data = vcpu->apic_base;
+		break;
+	default:
+		msr = find_msr_entry(vcpu, msr_index);
+		if (!msr) {
+			printk(KERN_ERR "kvm: unhandled rdmsr: %x\n", msr_index);
+			return 1;
+		}
+		data = msr->data;
+		break;
+	}
+
+	*pdata = data;
+	return 0;
+}
+
+/*
+ * Writes msr value into into the appropriate "register".
+ * Returns 0 on success, non-0 otherwise.
+ * Assumes vcpu_load() was already called.
+ */
+static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
+{
+	struct vmx_msr_entry *msr;
+	switch (msr_index) {
+#ifdef __x86_64__
+	case MSR_FS_BASE:
+		vmcs_writel(GUEST_FS_BASE, data);
+		break;
+	case MSR_GS_BASE:
+		vmcs_writel(GUEST_GS_BASE, data);
+		break;
+#endif
+	case MSR_IA32_SYSENTER_CS:
+		vmcs_write32(GUEST_SYSENTER_CS, data);
+		break;
+	case MSR_IA32_SYSENTER_EIP:
+		vmcs_write32(GUEST_SYSENTER_EIP, data);
+		break;
+	case MSR_IA32_SYSENTER_ESP:
+		vmcs_write32(GUEST_SYSENTER_ESP, data);
+		break;
+#ifdef __x86_64
+	case MSR_EFER:
+		set_efer(vcpu, data);
+		break;
+	case MSR_IA32_MC0_STATUS:
+		printk(KERN_WARNING "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n"
+			    , __FUNCTION__, data);
+		break;
+#endif
+	case MSR_IA32_TIME_STAMP_COUNTER: {
+		guest_write_tsc(data);
+		break;
+	}
+	case MSR_IA32_UCODE_REV:
+	case MSR_IA32_UCODE_WRITE:
+	case 0x200 ... 0x2ff: /* MTRRs */
+		break;
+	case MSR_IA32_APICBASE:
+		vcpu->apic_base = data;
+		break;
+	default:
+		msr = find_msr_entry(vcpu, msr_index);
+		if (!msr) {
+			printk(KERN_ERR "kvm: unhandled wrmsr: 0x%x\n", msr_index);
+			return 1;
+		}
+		msr->data = data;
+		break;
+	}
+
+	return 0;
+}
+
 static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
 {
 	unsigned long dr7 = 0x400;
@@ -169,6 +309,8 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.hardware_disable = hardware_disable,
 
 	.set_guest_debug = set_guest_debug,
+	.get_msr = vmx_get_msr,
+	.set_msr = vmx_set_msr,
 };
 
 static int __init vmx_init(void)
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

