From: akpm@osdl.org
Subject: - kvm-make-vcpu_load-and-vcpu_put-arch-operations.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:12 -0800
Message-ID: <200612100755.kBA7tCMP017856@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59805 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760429AbWLJHzP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: make vcpu_load() and vcpu_put() arch operations
has been removed from the -mm tree.  Its filename was
     kvm-make-vcpu_load-and-vcpu_put-arch-operations.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: make vcpu_load() and vcpu_put() arch operations
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |   19 ++++++++++
 drivers/kvm/kvm_main.c |   73 ++++-----------------------------------
 drivers/kvm/vmx.c      |   56 +++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+), 64 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-make-vcpu_load-and-vcpu_put-arch-operations drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-make-vcpu_load-and-vcpu_put-arch-operations
+++ a/drivers/kvm/kvm.h
@@ -260,6 +260,9 @@ struct kvm_arch_ops {
 	int (*hardware_setup)(void);               /* __init */
 	void (*hardware_unsetup)(void);            /* __exit */
 
+	struct kvm_vcpu *(*vcpu_load)(struct kvm_vcpu *vcpu);
+	void (*vcpu_put)(struct kvm_vcpu *vcpu);
+
 	int (*set_guest_debug)(struct kvm_vcpu *vcpu,
 			       struct kvm_debug_guest *dbg);
 	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata);
@@ -296,6 +299,8 @@ struct kvm_arch_ops {
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
 };
 
+void __vcpu_clear(void *arg); /* temporary hack */
+
 extern struct kvm_stat kvm_stat;
 extern struct kvm_arch_ops *kvm_arch_ops;
 
@@ -373,6 +378,8 @@ int kvm_write_guest(struct kvm_vcpu *vcp
 void vmcs_writel(unsigned long field, unsigned long value);
 unsigned long vmcs_readl(unsigned long field);
 
+unsigned long segment_base(u16 selector);
+
 static inline struct page *_gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
@@ -501,6 +508,18 @@ static inline void get_idt(struct descri
 	asm ("sidt %0" : "=m"(*table));
 }
 
+static inline void get_gdt(struct descriptor_table *table)
+{
+	asm ("sgdt %0" : "=m"(*table));
+}
+
+static inline unsigned long read_tr_base(void)
+{
+	u16 tr;
+	asm ("str %0" : "=g"(tr));
+	return segment_base(tr);
+}
+
 #ifdef __x86_64__
 static inline unsigned long read_msr(unsigned long msr)
 {
diff -puN drivers/kvm/kvm_main.c~kvm-make-vcpu_load-and-vcpu_put-arch-operations drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-make-vcpu_load-and-vcpu_put-arch-operations
+++ a/drivers/kvm/kvm_main.c
@@ -85,11 +85,6 @@ struct vmx_msr_entry *find_msr_entry(str
 }
 EXPORT_SYMBOL_GPL(find_msr_entry);
 
-static void get_gdt(struct descriptor_table *table)
-{
-	asm ("sgdt %0" : "=m"(*table));
-}
-
 #ifdef __x86_64__
 // LDT or TSS descriptor in the GDT. 16 bytes.
 struct segment_descriptor_64 {
@@ -100,7 +95,7 @@ struct segment_descriptor_64 {
 
 #endif
 
-static unsigned long segment_base(u16 selector)
+unsigned long segment_base(u16 selector)
 {
 	struct descriptor_table gdt;
 	struct segment_descriptor *d;
@@ -126,17 +121,12 @@ static unsigned long segment_base(u16 se
 #endif
 	return v;
 }
-
-static unsigned long read_tr_base(void)
-{
-	u16 tr;
-	asm ("str %0" : "=g"(tr));
-	return segment_base(tr);
-}
+EXPORT_SYMBOL_GPL(segment_base);
 
 DEFINE_PER_CPU(struct vmcs *, vmxarea);
 EXPORT_SYMBOL_GPL(per_cpu__vmxarea); /* temporary hack */
-static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
+DEFINE_PER_CPU(struct vmcs *, current_vmcs);
+EXPORT_SYMBOL_GPL(per_cpu__current_vmcs); /* temporary hack */
 
 struct vmcs_descriptor {
 	int size;
@@ -227,7 +217,7 @@ static void vmcs_clear(struct vmcs *vmcs
 		       vmcs, phys_addr);
 }
 
-static void __vcpu_clear(void *arg)
+void __vcpu_clear(void *arg)
 {
 	struct kvm_vcpu *vcpu = arg;
 	int cpu = smp_processor_id();
@@ -237,6 +227,7 @@ static void __vcpu_clear(void *arg)
 	if (per_cpu(current_vmcs, cpu) == vcpu->vmcs)
 		per_cpu(current_vmcs, cpu) = 0;
 }
+EXPORT_SYMBOL_GPL(__vcpu_clear);
 
 static int vcpu_slot(struct kvm_vcpu *vcpu)
 {
@@ -244,53 +235,6 @@ static int vcpu_slot(struct kvm_vcpu *vc
 }
 
 /*
- * Switches to specified vcpu, until a matching vcpu_put(), but assumes
- * vcpu mutex is already taken.
- */
-static struct kvm_vcpu *__vcpu_load(struct kvm_vcpu *vcpu)
-{
-	u64 phys_addr = __pa(vcpu->vmcs);
-	int cpu;
-
-	cpu = get_cpu();
-
-	if (vcpu->cpu != cpu) {
-		smp_call_function(__vcpu_clear, vcpu, 0, 1);
-		vcpu->launched = 0;
-	}
-
-	if (per_cpu(current_vmcs, cpu) != vcpu->vmcs) {
-		u8 error;
-
-		per_cpu(current_vmcs, cpu) = vcpu->vmcs;
-		asm volatile (ASM_VMX_VMPTRLD_RAX "; setna %0"
-			      : "=g"(error) : "a"(&phys_addr), "m"(phys_addr)
-			      : "cc");
-		if (error)
-			printk(KERN_ERR "kvm: vmptrld %p/%llx fail\n",
-			       vcpu->vmcs, phys_addr);
-	}
-
-	if (vcpu->cpu != cpu) {
-		struct descriptor_table dt;
-		unsigned long sysenter_esp;
-
-		vcpu->cpu = cpu;
-		/*
-		 * Linux uses per-cpu TSS and GDT, so set these when switching
-		 * processors.
-		 */
-		vmcs_writel(HOST_TR_BASE, read_tr_base()); /* 22.2.4 */
-		get_gdt(&dt);
-		vmcs_writel(HOST_GDTR_BASE, dt.base);   /* 22.2.4 */
-
-		rdmsrl(MSR_IA32_SYSENTER_ESP, sysenter_esp);
-		vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
-	}
-	return vcpu;
-}
-
-/*
  * Switches to specified vcpu, until a matching vcpu_put()
  */
 static struct kvm_vcpu *vcpu_load(struct kvm *kvm, int vcpu_slot)
@@ -302,11 +246,12 @@ static struct kvm_vcpu *vcpu_load(struct
 		mutex_unlock(&vcpu->mutex);
 		return 0;
 	}
-	return __vcpu_load(vcpu);
+	return kvm_arch_ops->vcpu_load(vcpu);
 }
 
 static void vcpu_put(struct kvm_vcpu *vcpu)
 {
+	kvm_arch_ops->vcpu_put(vcpu);
 	put_cpu();
 	mutex_unlock(&vcpu->mutex);
 }
@@ -683,7 +628,7 @@ static int kvm_dev_ioctl_create_vcpu(str
 	vcpu->vmcs = vmcs;
 	vcpu->launched = 0;
 
-	__vcpu_load(vcpu);
+	kvm_arch_ops->vcpu_load(vcpu);
 
 	r = kvm_arch_ops->vcpu_setup(vcpu);
 	if (r >= 0)
diff -puN drivers/kvm/vmx.c~kvm-make-vcpu_load-and-vcpu_put-arch-operations drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-vcpu_load-and-vcpu_put-arch-operations
+++ a/drivers/kvm/vmx.c
@@ -31,6 +31,7 @@ MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
 DECLARE_PER_CPU(struct vmcs *, vmxarea);
+DECLARE_PER_CPU(struct vmcs *, current_vmcs);
 
 #ifdef __x86_64__
 #define HOST_IS_64 1
@@ -78,6 +79,58 @@ static const u32 vmx_msr_index[] = {
 
 struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr);
 
+/*
+ * Switches to specified vcpu, until a matching vcpu_put(), but assumes
+ * vcpu mutex is already taken.
+ */
+static struct kvm_vcpu *vmx_vcpu_load(struct kvm_vcpu *vcpu)
+{
+	u64 phys_addr = __pa(vcpu->vmcs);
+	int cpu;
+
+	cpu = get_cpu();
+
+	if (vcpu->cpu != cpu) {
+		smp_call_function(__vcpu_clear, vcpu, 0, 1);
+		vcpu->launched = 0;
+	}
+
+	if (per_cpu(current_vmcs, cpu) != vcpu->vmcs) {
+		u8 error;
+
+		per_cpu(current_vmcs, cpu) = vcpu->vmcs;
+		asm volatile (ASM_VMX_VMPTRLD_RAX "; setna %0"
+			      : "=g"(error) : "a"(&phys_addr), "m"(phys_addr)
+			      : "cc");
+		if (error)
+			printk(KERN_ERR "kvm: vmptrld %p/%llx fail\n",
+			       vcpu->vmcs, phys_addr);
+	}
+
+	if (vcpu->cpu != cpu) {
+		struct descriptor_table dt;
+		unsigned long sysenter_esp;
+
+		vcpu->cpu = cpu;
+		/*
+		 * Linux uses per-cpu TSS and GDT, so set these when switching
+		 * processors.
+		 */
+		vmcs_writel(HOST_TR_BASE, read_tr_base()); /* 22.2.4 */
+		get_gdt(&dt);
+		vmcs_writel(HOST_GDTR_BASE, dt.base);   /* 22.2.4 */
+
+		rdmsrl(MSR_IA32_SYSENTER_ESP, sysenter_esp);
+		vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
+	}
+	return vcpu;
+}
+
+static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	put_cpu();
+}
+
 static unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 {
 	return vmcs_readl(GUEST_RFLAGS);
@@ -1747,6 +1800,9 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.hardware_enable = hardware_enable,
 	.hardware_disable = hardware_disable,
 
+	.vcpu_load = vmx_vcpu_load,
+	.vcpu_put = vmx_vcpu_put,
+
 	.set_guest_debug = set_guest_debug,
 	.get_msr = vmx_get_msr,
 	.set_msr = vmx_set_msr,
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

