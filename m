From: akpm@linux-foundation.org
Subject: + arm-kvm-move-asmlinkage-before-type.patch added to -mm tree
Date: Wed, 05 Jul 2017 13:45:06 -0700
Message-ID: <595d4fd2.tfL+dA0EU1x4tIEa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54652 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753115AbdGEUpH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 16:45:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, christoffer.dall@linaro.org, linux@armlinux.org.uk, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: KVM: move asmlinkage before type
has been added to the -mm tree.  Its filename is
     arm-kvm-move-asmlinkage-before-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-kvm-move-asmlinkage-before-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-kvm-move-asmlinkage-before-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch
checkpatch-improve-macro-reuse-test.patch
checkpatch-improve-multi-line-alignment-test.patch
checkpatch-improve-the-storage_class-test.patch
arm-kvm-move-asmlinkage-before-type.patch
arm-hp-jornada-7xx-move-inline-before-return-type.patch
cris-gpio-move-inline-before-return-type.patch
frv-tlbflush-move-asmlinkage-before-return-type.patch
ia64-move-inline-before-return-type.patch
ia64-sn-pci-move-inline-before-type.patch
m68k-coldfire-move-inline-before-return-type.patch
mips-smp-move-asmlinkage-before-return-type.patch
sh-move-inline-before-return-type.patch
x86-efi-move-asmlinkage-before-return-type.patch
drivers-s390-move-static-and-inline-before-return-type.patch
drivers-tty-serial-move-inline-before-return-type.patch
usb-serial-safe_serial-move-__inline__-before-return-type.patch
video-fbdev-intelfb-move-inline-before-return-type.patch
video-fbdev-omap-move-inline-before-return-type.patch
arm-samsung-usb-ohci-move-inline-before-return-type.patch
alsa-opl4-move-inline-before-return-type.patch

