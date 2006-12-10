From: akpm@osdl.org
Subject: - kvm-amd-svm-enhance-x86-emulator-fix-mov-to-from-control-register-emulation.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:43 -0800
Message-ID: <200612100755.kBA7thUG017897@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59868 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760579AbWLJHzp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Fix mov to/from control register emulation, with r8-r15 as gpr
has been removed from the -mm tree.  Its filename was
     kvm-amd-svm-enhance-x86-emulator-fix-mov-to-from-control-register-emulation.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Fix mov to/from control register emulation, with r8-r15 as gpr
From: Avi Kivity <avi@qumranet.com>

Use the standrd modrm decoder instead of special casing these instructions.
This fixes mov %rX, %crY with X >= 8 or Y >= 8.

The fix only applies to AMD SVM, as Intel vmx decodes the instruction for us.
It cures the FC5 installer crashing when loading the xor module.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/x86_emulate.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/kvm/x86_emulate.c~kvm-amd-svm-enhance-x86-emulator-fix-mov-to-from-control-register-emulation drivers/kvm/x86_emulate.c
--- a/drivers/kvm/x86_emulate.c~kvm-amd-svm-enhance-x86-emulator-fix-mov-to-from-control-register-emulation
+++ a/drivers/kvm/x86_emulate.c
@@ -155,7 +155,8 @@ static u8 twobyte_table[256] = {
 	/* 0x10 - 0x1F */
 	0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x20 - 0x2F */
-	ImplicitOps, ModRM, ImplicitOps, ModRM, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	ModRM | ImplicitOps, ModRM, ModRM | ImplicitOps, ModRM, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x30 - 0x3F */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x40 - 0x47 */
@@ -1303,17 +1304,14 @@ twobyte_special_insn:
 		emulate_clts(ctxt->vcpu);
 		break;
 	case 0x20: /* mov cr, reg */
-		b = insn_fetch(u8, 1, _eip);
-		if ((b & 0xc0) != 0xc0)
+		if (modrm_mod != 3)
 			goto cannot_emulate;
-		_regs[b & 7] = realmode_get_cr(ctxt->vcpu, (b >> 3) & 7);
+		_regs[modrm_rm] = realmode_get_cr(ctxt->vcpu, modrm_reg);
 		break;
 	case 0x22: /* mov reg, cr */
-		b = insn_fetch(u8, 1, _eip);
-		if ((b & 0xc0) != 0xc0)
+		if (modrm_mod != 3)
 			goto cannot_emulate;
-		realmode_set_cr(ctxt->vcpu, (b >> 3) & 7, _regs[b & 7] & -1u,
-				&_eflags);
+		realmode_set_cr(ctxt->vcpu, modrm_reg, modrm_val, &_eflags);
 		break;
 	case 0xc7:		/* Grp9 (cmpxchg8b) */
 #if defined(__i386__)
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

