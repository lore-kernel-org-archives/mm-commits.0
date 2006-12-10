From: akpm@osdl.org
Subject: - kvm-make-vcpu-creation-and-destruction-arch-operations.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:15 -0800
Message-ID: <200612100755.kBA7tFa7017861@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59815 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760558AbWLJHzT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: make vcpu creation and destruction arch operations
has been removed from the -mm tree.  Its filename was
     kvm-make-vcpu-creation-and-destruction-arch-operations.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: make vcpu creation and destruction arch operations
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    5 +-
 drivers/kvm/kvm_main.c |   74 +-----------------------------------
 drivers/kvm/vmx.c      |   79 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 85 insertions(+), 73 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-make-vcpu-creation-and-destruction-arch-operations drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-make-vcpu-creation-and-destruction-arch-operations
+++ a/drivers/kvm/kvm.h
@@ -260,6 +260,9 @@ struct kvm_arch_ops {
 	int (*hardware_setup)(void);               /* __init */
 	void (*hardware_unsetup)(void);            /* __exit */
 
+	int (*vcpu_create)(struct kvm_vcpu *vcpu);
+	void (*vcpu_free)(struct kvm_vcpu *vcpu);
+
 	struct kvm_vcpu *(*vcpu_load)(struct kvm_vcpu *vcpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 
@@ -299,8 +302,6 @@ struct kvm_arch_ops {
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
 };
 
-void __vcpu_clear(void *arg); /* temporary hack */
-
 extern struct kvm_stat kvm_stat;
 extern struct kvm_arch_ops *kvm_arch_ops;
 
diff -puN drivers/kvm/kvm_main.c~kvm-make-vcpu-creation-and-destruction-arch-operations drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-make-vcpu-creation-and-destruction-arch-operations
+++ a/drivers/kvm/kvm_main.c
@@ -204,31 +204,6 @@ int kvm_write_guest(struct kvm_vcpu *vcp
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest);
 
-static void vmcs_clear(struct vmcs *vmcs)
-{
-	u64 phys_addr = __pa(vmcs);
-	u8 error;
-
-	asm volatile (ASM_VMX_VMCLEAR_RAX "; setna %0"
-		      : "=g"(error) : "a"(&phys_addr), "m"(phys_addr)
-		      : "cc", "memory");
-	if (error)
-		printk(KERN_ERR "kvm: vmclear fail: %p/%llx\n",
-		       vmcs, phys_addr);
-}
-
-void __vcpu_clear(void *arg)
-{
-	struct kvm_vcpu *vcpu = arg;
-	int cpu = smp_processor_id();
-
-	if (vcpu->cpu == cpu)
-		vmcs_clear(vcpu->vmcs);
-	if (per_cpu(current_vmcs, cpu) == vcpu->vmcs)
-		per_cpu(current_vmcs, cpu) = 0;
-}
-EXPORT_SYMBOL_GPL(__vcpu_clear);
-
 static int vcpu_slot(struct kvm_vcpu *vcpu)
 {
 	return vcpu - vcpu->kvm->vcpus;
@@ -256,33 +231,6 @@ static void vcpu_put(struct kvm_vcpu *vc
 	mutex_unlock(&vcpu->mutex);
 }
 
-struct vmcs *alloc_vmcs_cpu(int cpu)
-{
-	int node = cpu_to_node(cpu);
-	struct page *pages;
-	struct vmcs *vmcs;
-
-	pages = alloc_pages_node(node, GFP_KERNEL, vmcs_descriptor.order);
-	if (!pages)
-		return 0;
-	vmcs = page_address(pages);
-	memset(vmcs, 0, vmcs_descriptor.size);
-	vmcs->revision_id = vmcs_descriptor.revision_id; /* vmcs revision id */
-	return vmcs;
-}
-EXPORT_SYMBOL_GPL(alloc_vmcs_cpu);
-
-static struct vmcs *alloc_vmcs(void)
-{
-	return alloc_vmcs_cpu(smp_processor_id());
-}
-
-void free_vmcs(struct vmcs *vmcs)
-{
-	free_pages((unsigned long)vmcs, vmcs_descriptor.order);
-}
-EXPORT_SYMBOL_GPL(free_vmcs);
-
 static int kvm_dev_open(struct inode *inode, struct file *filp)
 {
 	struct kvm *kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
@@ -335,18 +283,9 @@ static void kvm_free_physmem(struct kvm 
 		kvm_free_physmem_slot(&kvm->memslots[i], 0);
 }
 
-static void kvm_free_vmcs(struct kvm_vcpu *vcpu)
-{
-	if (vcpu->vmcs) {
-		on_each_cpu(__vcpu_clear, vcpu, 0, 1);
-		free_vmcs(vcpu->vmcs);
-		vcpu->vmcs = 0;
-	}
-}
-
 static void kvm_free_vcpu(struct kvm_vcpu *vcpu)
 {
-	kvm_free_vmcs(vcpu);
+	kvm_arch_ops->vcpu_free(vcpu);
 	kvm_mmu_destroy(vcpu);
 }
 
@@ -598,7 +537,6 @@ static int kvm_dev_ioctl_create_vcpu(str
 {
 	int r;
 	struct kvm_vcpu *vcpu;
-	struct vmcs *vmcs;
 
 	r = -EINVAL;
 	if (n < 0 || n >= KVM_MAX_VCPUS)
@@ -619,14 +557,9 @@ static int kvm_dev_ioctl_create_vcpu(str
 
 	vcpu->cpu = -1;  /* First load will set up TR */
 	vcpu->kvm = kvm;
-	vmcs = alloc_vmcs();
-	if (!vmcs) {
-		mutex_unlock(&vcpu->mutex);
+	r = kvm_arch_ops->vcpu_create(vcpu);
+	if (r < 0)
 		goto out_free_vcpus;
-	}
-	vmcs_clear(vmcs);
-	vcpu->vmcs = vmcs;
-	vcpu->launched = 0;
 
 	kvm_arch_ops->vcpu_load(vcpu);
 
@@ -643,6 +576,7 @@ static int kvm_dev_ioctl_create_vcpu(str
 
 out_free_vcpus:
 	kvm_free_vcpu(vcpu);
+	mutex_unlock(&vcpu->mutex);
 out:
 	return r;
 }
diff -puN drivers/kvm/vmx.c~kvm-make-vcpu-creation-and-destruction-arch-operations drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-vcpu-creation-and-destruction-arch-operations
+++ a/drivers/kvm/vmx.c
@@ -79,6 +79,30 @@ static const u32 vmx_msr_index[] = {
 
 struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr);
 
+static void vmcs_clear(struct vmcs *vmcs)
+{
+	u64 phys_addr = __pa(vmcs);
+	u8 error;
+
+	asm volatile (ASM_VMX_VMCLEAR_RAX "; setna %0"
+		      : "=g"(error) : "a"(&phys_addr), "m"(phys_addr)
+		      : "cc", "memory");
+	if (error)
+		printk(KERN_ERR "kvm: vmclear fail: %p/%llx\n",
+		       vmcs, phys_addr);
+}
+
+static void __vcpu_clear(void *arg)
+{
+	struct kvm_vcpu *vcpu = arg;
+	int cpu = smp_processor_id();
+
+	if (vcpu->cpu == cpu)
+		vmcs_clear(vcpu->vmcs);
+	if (per_cpu(current_vmcs, cpu) == vcpu->vmcs)
+		per_cpu(current_vmcs, cpu) = 0;
+}
+
 /*
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
@@ -451,7 +475,30 @@ static __init void setup_vmcs_descriptor
 	vmcs_descriptor.revision_id = vmx_msr_low;
 };
 
-void free_vmcs(struct vmcs *vmcs);
+static struct vmcs *alloc_vmcs_cpu(int cpu)
+{
+	int node = cpu_to_node(cpu);
+	struct page *pages;
+	struct vmcs *vmcs;
+
+	pages = alloc_pages_node(node, GFP_KERNEL, vmcs_descriptor.order);
+	if (!pages)
+		return 0;
+	vmcs = page_address(pages);
+	memset(vmcs, 0, vmcs_descriptor.size);
+	vmcs->revision_id = vmcs_descriptor.revision_id; /* vmcs revision id */
+	return vmcs;
+}
+
+static struct vmcs *alloc_vmcs(void)
+{
+	return alloc_vmcs_cpu(smp_processor_id());
+}
+
+static void free_vmcs(struct vmcs *vmcs)
+{
+	free_pages((unsigned long)vmcs, vmcs_descriptor.order);
+}
 
 static __exit void free_kvm_area(void)
 {
@@ -1792,6 +1839,33 @@ static void vmx_inject_page_fault(struct
 
 }
 
+static void vmx_free_vmcs(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->vmcs) {
+		on_each_cpu(__vcpu_clear, vcpu, 0, 1);
+		free_vmcs(vcpu->vmcs);
+		vcpu->vmcs = 0;
+	}
+}
+
+static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
+{
+	vmx_free_vmcs(vcpu);
+}
+
+static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct vmcs *vmcs;
+
+	vmcs = alloc_vmcs();
+	if (!vmcs)
+		return -ENOMEM;
+	vmcs_clear(vmcs);
+	vcpu->vmcs = vmcs;
+	vcpu->launched = 0;
+	return 0;
+}
+
 static struct kvm_arch_ops vmx_arch_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -1800,6 +1874,9 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.hardware_enable = hardware_enable,
 	.hardware_disable = hardware_disable,
 
+	.vcpu_create = vmx_create_vcpu,
+	.vcpu_free = vmx_free_vcpu,
+
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
 
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

