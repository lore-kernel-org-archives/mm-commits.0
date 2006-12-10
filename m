From: akpm@osdl.org
Subject: - kvm-x86-emulator-fix-emulator-mov-cr-decoding.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:53:09 -0800
Message-ID: <200612100753.kBA7r9eh017709@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59607 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760436AbWLJHxM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:53:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yaniv@qumranet.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Fix emulator mov cr decoding
has been removed from the -mm tree.  Its filename was
     kvm-x86-emulator-fix-emulator-mov-cr-decoding.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Fix emulator mov cr decoding
From: Yaniv Kamay <yaniv@qumranet.com>

Decoding of the mov cr instructions was wrong.

Signed-off-by: Yaniv Kamay <yaniv@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/x86_emulate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/x86_emulate.c~kvm-x86-emulator-fix-emulator-mov-cr-decoding drivers/kvm/x86_emulate.c
--- a/drivers/kvm/x86_emulate.c~kvm-x86-emulator-fix-emulator-mov-cr-decoding
+++ a/drivers/kvm/x86_emulate.c
@@ -1276,13 +1276,13 @@ twobyte_special_insn:
 		b = insn_fetch(u8, 1, _eip);
 		if ((b & 0xc0) != 0xc0)
 			goto cannot_emulate;
-		_regs[(b >> 3) & 7] = realmode_get_cr(ctxt->vcpu, b & 7);
+		_regs[b & 7] = realmode_get_cr(ctxt->vcpu, (b >> 3) & 7);
 		break;
 	case 0x22: /* mov reg, cr */
 		b = insn_fetch(u8, 1, _eip);
 		if ((b & 0xc0) != 0xc0)
 			goto cannot_emulate;
-		realmode_set_cr(ctxt->vcpu, b & 7, _regs[(b >> 3) & 7] & -1u,
+		realmode_set_cr(ctxt->vcpu, (b >> 3) & 7, _regs[b & 7] & -1u,
 				&_eflags);
 		break;
 	case 0xc7:		/* Grp9 (cmpxchg8b) */
_

Patches currently in -mm which might be from yaniv@qumranet.com are

kvm-userspace-interface.patch
kvm-x86-emulator-fix-emulator-mov-cr-decoding.patch
kvm-amd-svm-add-architecture-definitions-for-amd-svm.patch
kvm-amd-svm-enhance-x86-emulator.patch
kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu.patch
kvm-amd-svm-add-data-structures.patch
kvm-amd-svm-implementation.patch

