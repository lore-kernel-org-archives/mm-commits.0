From: akpm@osdl.org
Subject: - kvm-workaround-cr0cd-cache-disable-bit-leak-from-guest-to.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:52:35 -0800
Message-ID: <200612100752.kBA7qZ5C017666@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59554 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760400AbWLJHwi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:52:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Workaround cr0.cd (cache disable) bit leak from guest to host
has been removed from the -mm tree.  Its filename was
     kvm-workaround-cr0cd-cache-disable-bit-leak-from-guest-to.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Workaround cr0.cd (cache disable) bit leak from guest to host
From: Avi Kivity <avi@qumranet.com>

On Core-not-2 processors (or on laptops - not sure what the cause is), the
cache disable bit sometimes leaks from the guest cr0 to the host cr0.  This
leaves the host limping along at a snail's pace long after the guest has left.
 This might be a bug in the processor or in the smm (system management mode)
bios.

Workaround by giving the guest a virtual cr0.cd (and also cr0.nw for good
measure) and keeping the real bits always clear.

This makes sense even without the bug: the processor cache is a host resource,
not a guest resource, and the guest has no business disabling it.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    4 +++-
 drivers/kvm/kvm_main.c |    6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-workaround-cr0cd-cache-disable-bit-leak-from-guest-to drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-workaround-cr0cd-cache-disable-bit-leak-from-guest-to
+++ a/drivers/kvm/kvm.h
@@ -31,8 +31,10 @@
 #define CR4_VMXE_MASK (1ULL << 13)
 
 #define KVM_GUEST_CR0_MASK \
+	(CR0_PG_MASK | CR0_PE_MASK | CR0_WP_MASK | CR0_NE_MASK \
+	 | CR0_NW_MASK | CR0_CD_MASK)
+#define KVM_VM_CR0_ALWAYS_ON \
 	(CR0_PG_MASK | CR0_PE_MASK | CR0_WP_MASK | CR0_NE_MASK)
-#define KVM_VM_CR0_ALWAYS_ON KVM_GUEST_CR0_MASK
 
 #define KVM_GUEST_CR4_MASK \
 	(CR4_PSE_MASK | CR4_PAE_MASK | CR4_PGE_MASK | CR4_VMXE_MASK | CR4_VME_MASK)
diff -puN drivers/kvm/kvm_main.c~kvm-workaround-cr0cd-cache-disable-bit-leak-from-guest-to drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-workaround-cr0cd-cache-disable-bit-leak-from-guest-to
+++ a/drivers/kvm/kvm_main.c
@@ -927,7 +927,8 @@ static void __set_cr0(struct kvm_vcpu *v
 #endif
 
 	vmcs_writel(CR0_READ_SHADOW, cr0);
-	vmcs_writel(GUEST_CR0, cr0 | KVM_VM_CR0_ALWAYS_ON);
+	vmcs_writel(GUEST_CR0,
+		    (cr0 & ~KVM_GUEST_CR0_MASK) | KVM_VM_CR0_ALWAYS_ON);
 }
 
 static int pdptrs_have_reserved_bits_set(struct kvm_vcpu *vcpu,
@@ -2017,7 +2018,8 @@ static int kvm_dev_ioctl_set_sregs(struc
 	vcpu->rmode.active = ((sregs->cr0 & CR0_PE_MASK) == 0);
 	update_exception_bitmap(vcpu);
 	vmcs_writel(CR0_READ_SHADOW, sregs->cr0);
-	vmcs_writel(GUEST_CR0, sregs->cr0 | KVM_VM_CR0_ALWAYS_ON);
+	vmcs_writel(GUEST_CR0,
+		    (sregs->cr0 & ~KVM_GUEST_CR0_MASK) | KVM_VM_CR0_ALWAYS_ON);
 
 	mmu_reset_needed |=  guest_cr4() != sregs->cr4;
 	__set_cr4(vcpu, sregs->cr4);
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-workaround-cr0cd-cache-disable-bit-leak-from-guest-to.patch
kvm-vcpu-execution-loop.patch
kvm-define-exit-handlers.patch
kvm-define-exit-handlers-pass-fs-gs-segment-bases-to-x86-emulator.patch
kvm-less-common-exit-handlers.patch
kvm-less-common-exit-handlers-handle-rdmsrmsr_efer.patch
kvm-mmu.patch
kvm-mmu-mmu-honor-global-bit-on-huge-pages.patch
kvm-x86-emulator.patch
kvm-x86-emulator-x86-emulator-handle-smsw.patch
kvm-clarify-licensing.patch
kvm-x86-emulator-fix-emulator-mov-cr-decoding.patch
kvm-plumbing.patch
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

