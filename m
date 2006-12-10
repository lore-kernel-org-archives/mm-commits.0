From: akpm@osdl.org
Subject: - kvm-use-the-idt-and-gdt-accessors-in-realmode-emulation.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:54:55 -0800
Message-ID: <200612100754.kBA7stdt017827@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59767 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760420AbWLJHy5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:54:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: use the idt and gdt accessors in realmode emulation
has been removed from the -mm tree.  Its filename was
     kvm-use-the-idt-and-gdt-accessors-in-realmode-emulation.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: use the idt and gdt accessors in realmode emulation
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-use-the-idt-and-gdt-accessors-in-realmode-emulation drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-use-the-idt-and-gdt-accessors-in-realmode-emulation
+++ a/drivers/kvm/kvm_main.c
@@ -1211,14 +1211,16 @@ static u64 mk_cr_64(u64 curr_cr, u32 new
 
 void realmode_lgdt(struct kvm_vcpu *vcpu, u16 limit, unsigned long base)
 {
-	vmcs_writel(GUEST_GDTR_BASE, base);
-	vmcs_write32(GUEST_GDTR_LIMIT, limit);
+	struct descriptor_table dt = { limit, base };
+
+	kvm_arch_ops->set_gdt(vcpu, &dt);
 }
 
 void realmode_lidt(struct kvm_vcpu *vcpu, u16 limit, unsigned long base)
 {
-	vmcs_writel(GUEST_IDTR_BASE, base);
-	vmcs_write32(GUEST_IDTR_LIMIT, limit);
+	struct descriptor_table dt = { limit, base };
+
+	kvm_arch_ops->set_idt(vcpu, &dt);
 }
 
 void realmode_lmsw(struct kvm_vcpu *vcpu, unsigned long msw,
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

