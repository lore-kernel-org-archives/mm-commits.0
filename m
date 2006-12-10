From: akpm@osdl.org
Subject: - kvm-make-the-guest-debugger-an-arch-operation.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:53:57 -0800
Message-ID: <200612100753.kBA7rvMs017759@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59681 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760389AbWLJHyA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:54:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: make the guest debugger an arch operation
has been removed from the -mm tree.  Its filename was
     kvm-make-the-guest-debugger-an-arch-operation.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: make the guest debugger an arch operation
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    3 ++
 drivers/kvm/kvm_main.c |   43 ++++--------------------------------
 drivers/kvm/vmx.c      |   46 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 38 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-make-the-guest-debugger-an-arch-operation drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-make-the-guest-debugger-an-arch-operation
+++ a/drivers/kvm/kvm.h
@@ -242,6 +242,9 @@ struct kvm_arch_ops {
 	void (*hardware_disable)(void *dummy);
 	int (*hardware_setup)(void);               /* __init */
 	void (*hardware_unsetup)(void);            /* __exit */
+
+	int (*set_guest_debug)(struct kvm_vcpu *vcpu,
+			       struct kvm_debug_guest *dbg);
 };
 
 extern struct kvm_stat kvm_stat;
diff -puN drivers/kvm/kvm_main.c~kvm-make-the-guest-debugger-an-arch-operation drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-make-the-guest-debugger-an-arch-operation
+++ a/drivers/kvm/kvm_main.c
@@ -611,6 +611,7 @@ unsigned long vmcs_readl(unsigned long f
 		      : "=a"(value) : "d"(field) : "cc");
 	return value;
 }
+EXPORT_SYMBOL_GPL(vmcs_readl);
 
 void vmcs_writel(unsigned long field, unsigned long value)
 {
@@ -622,6 +623,7 @@ void vmcs_writel(unsigned long field, un
 		printk(KERN_ERR "vmwrite error: reg %lx value %lx (err %d)\n",
 		       field, value, vmcs_read32(VM_INSTRUCTION_ERROR));
 }
+EXPORT_SYMBOL_GPL(vmcs_writel);
 
 static void vmcs_write16(unsigned long field, u16 value)
 {
@@ -3231,9 +3233,7 @@ static int kvm_dev_ioctl_debug_guest(str
 				     struct kvm_debug_guest *dbg)
 {
 	struct kvm_vcpu *vcpu;
-	unsigned long dr7 = 0x400;
-	u32 exception_bitmap;
-	int old_singlestep;
+	int r;
 
 	if (dbg->vcpu < 0 || dbg->vcpu >= KVM_MAX_VCPUS)
 		return -EINVAL;
@@ -3241,44 +3241,11 @@ static int kvm_dev_ioctl_debug_guest(str
 	if (!vcpu)
 		return -ENOENT;
 
-	exception_bitmap = vmcs_read32(EXCEPTION_BITMAP);
-	old_singlestep = vcpu->guest_debug.singlestep;
-
-	vcpu->guest_debug.enabled = dbg->enabled;
-	if (vcpu->guest_debug.enabled) {
-		int i;
-
-		dr7 |= 0x200;  /* exact */
-		for (i = 0; i < 4; ++i) {
-			if (!dbg->breakpoints[i].enabled)
-				continue;
-			vcpu->guest_debug.bp[i] = dbg->breakpoints[i].address;
-			dr7 |= 2 << (i*2);    /* global enable */
-			dr7 |= 0 << (i*4+16); /* execution breakpoint */
-		}
-
-		exception_bitmap |= (1u << 1);  /* Trap debug exceptions */
-
-		vcpu->guest_debug.singlestep = dbg->singlestep;
-	} else {
-		exception_bitmap &= ~(1u << 1); /* Ignore debug exceptions */
-		vcpu->guest_debug.singlestep = 0;
-	}
-
-	if (old_singlestep && !vcpu->guest_debug.singlestep) {
-		unsigned long flags;
-
-		flags = vmcs_readl(GUEST_RFLAGS);
-		flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_RF);
-		vmcs_writel(GUEST_RFLAGS, flags);
-	}
-
-	vmcs_write32(EXCEPTION_BITMAP, exception_bitmap);
-	vmcs_writel(GUEST_DR7, dr7);
+	r = kvm_arch_ops->set_guest_debug(vcpu, dbg);
 
 	vcpu_put(vcpu);
 
-	return 0;
+	return r;
 }
 
 static long kvm_dev_ioctl(struct file *filp,
diff -puN drivers/kvm/vmx.c~kvm-make-the-guest-debugger-an-arch-operation drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-the-guest-debugger-an-arch-operation
+++ a/drivers/kvm/vmx.c
@@ -31,6 +31,50 @@ extern struct vmcs_descriptor {
 	u32 revision_id;
 } vmcs_descriptor;
 
+static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
+{
+	unsigned long dr7 = 0x400;
+	u32 exception_bitmap;
+	int old_singlestep;
+
+	exception_bitmap = vmcs_read32(EXCEPTION_BITMAP);
+	old_singlestep = vcpu->guest_debug.singlestep;
+
+	vcpu->guest_debug.enabled = dbg->enabled;
+	if (vcpu->guest_debug.enabled) {
+		int i;
+
+		dr7 |= 0x200;  /* exact */
+		for (i = 0; i < 4; ++i) {
+			if (!dbg->breakpoints[i].enabled)
+				continue;
+			vcpu->guest_debug.bp[i] = dbg->breakpoints[i].address;
+			dr7 |= 2 << (i*2);    /* global enable */
+			dr7 |= 0 << (i*4+16); /* execution breakpoint */
+		}
+
+		exception_bitmap |= (1u << 1);  /* Trap debug exceptions */
+
+		vcpu->guest_debug.singlestep = dbg->singlestep;
+	} else {
+		exception_bitmap &= ~(1u << 1); /* Ignore debug exceptions */
+		vcpu->guest_debug.singlestep = 0;
+	}
+
+	if (old_singlestep && !vcpu->guest_debug.singlestep) {
+		unsigned long flags;
+
+		flags = vmcs_readl(GUEST_RFLAGS);
+		flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_RF);
+		vmcs_writel(GUEST_RFLAGS, flags);
+	}
+
+	vmcs_write32(EXCEPTION_BITMAP, exception_bitmap);
+	vmcs_writel(GUEST_DR7, dr7);
+
+	return 0;
+}
+
 static __init int cpu_has_kvm_support(void)
 {
 	unsigned long ecx = cpuid_ecx(1);
@@ -123,6 +167,8 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.hardware_unsetup = hardware_unsetup,
 	.hardware_enable = hardware_enable,
 	.hardware_disable = hardware_disable,
+
+	.set_guest_debug = set_guest_debug,
 };
 
 static int __init vmx_init(void)
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

