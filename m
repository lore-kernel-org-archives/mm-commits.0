From: akpm@linux-foundation.org
Subject: [patch 80/96] ARM: KVM: move asmlinkage before type
Date: Wed, 12 Jul 2017 14:37:05 -0700
Message-ID: <20170712213705.BnVto4LDo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55196 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754113AbdGLVhZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:37:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, christoffer.dall@linaro.org, joe@perches.com, linux@armlinux.org.uk, marc.zyngier@arm.com, mm-commits@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: ARM: KVM: move asmlinkage before type

asmlinkage is either 'extern "C"' or blank.

Move the uses of asmlinkage before the return types to be similar
to the rest of the kernel.

Link: http://lkml.kernel.org/r/005b8e120650c6a13b541e420f4e3605603fe9e6.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krcmar <rkrcmar@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/kvm_hyp.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/arm/include/asm/kvm_hyp.h~arm-kvm-move-asmlinkage-before-type arch/arm/include/asm/kvm_hyp.h
--- a/arch/arm/include/asm/kvm_hyp.h~arm-kvm-move-asmlinkage-before-type
+++ a/arch/arm/include/asm/kvm_hyp.h
@@ -110,8 +110,8 @@ void __sysreg_restore_state(struct kvm_c
 void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
 
-void asmlinkage __vfp_save_state(struct vfp_hard_struct *vfp);
-void asmlinkage __vfp_restore_state(struct vfp_hard_struct *vfp);
+asmlinkage void __vfp_save_state(struct vfp_hard_struct *vfp);
+asmlinkage void __vfp_restore_state(struct vfp_hard_struct *vfp);
 static inline bool __vfp_enabled(void)
 {
 	return !(read_sysreg(HCPTR) & (HCPTR_TCP(11) | HCPTR_TCP(10)));
@@ -120,8 +120,8 @@ static inline bool __vfp_enabled(void)
 void __hyp_text __banked_save_state(struct kvm_cpu_context *ctxt);
 void __hyp_text __banked_restore_state(struct kvm_cpu_context *ctxt);
 
-int asmlinkage __guest_enter(struct kvm_vcpu *vcpu,
+asmlinkage int __guest_enter(struct kvm_vcpu *vcpu,
 			     struct kvm_cpu_context *host);
-int asmlinkage __hyp_do_panic(const char *, int, u32);
+asmlinkage int __hyp_do_panic(const char *, int, u32);
 
 #endif /* __ARM_KVM_HYP_H__ */
_
