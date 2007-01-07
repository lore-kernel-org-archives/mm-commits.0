From: akpm@osdl.org
Subject: - kvm-mmu-fix-cmpxchg8b-emulation.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:52 -0800
Message-ID: <200701070759.l077xqk7013101@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40940 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473AbXAGH75 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Fix cmpxchg8b emulation
has been removed from the -mm tree.  Its filename was
     kvm-mmu-fix-cmpxchg8b-emulation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Fix cmpxchg8b emulation
From: Avi Kivity <avi@qumranet.com>

cmpxchg8b uses edx:eax as the compare operand, not edi:eax.

cmpxchg8b is used by 32-bit pae guests to set page table entries atomically,
and this is emulated touching shadowed guest page tables.

Also, implement it for 32-bit hosts.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c    |   27 +++++++++++++++++++++++++++
 drivers/kvm/x86_emulate.c |    2 +-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/kvm_main.c~kvm-mmu-fix-cmpxchg8b-emulation drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-mmu-fix-cmpxchg8b-emulation
+++ a/drivers/kvm/kvm_main.c
@@ -936,6 +936,30 @@ static int emulator_cmpxchg_emulated(uns
 	return emulator_write_emulated(addr, new, bytes, ctxt);
 }
 
+#ifdef CONFIG_X86_32
+
+static int emulator_cmpxchg8b_emulated(unsigned long addr,
+				       unsigned long old_lo,
+				       unsigned long old_hi,
+				       unsigned long new_lo,
+				       unsigned long new_hi,
+				       struct x86_emulate_ctxt *ctxt)
+{
+	static int reported;
+	int r;
+
+	if (!reported) {
+		reported = 1;
+		printk(KERN_WARNING "kvm: emulating exchange8b as write\n");
+	}
+	r = emulator_write_emulated(addr, new_lo, 4, ctxt);
+	if (r != X86EMUL_CONTINUE)
+		return r;
+	return emulator_write_emulated(addr+4, new_hi, 4, ctxt);
+}
+
+#endif
+
 static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
 	return kvm_arch_ops->get_segment_base(vcpu, seg);
@@ -1010,6 +1034,9 @@ struct x86_emulate_ops emulate_ops = {
 	.read_emulated       = emulator_read_emulated,
 	.write_emulated      = emulator_write_emulated,
 	.cmpxchg_emulated    = emulator_cmpxchg_emulated,
+#ifdef CONFIG_X86_32
+	.cmpxchg8b_emulated  = emulator_cmpxchg8b_emulated,
+#endif
 };
 
 int emulate_instruction(struct kvm_vcpu *vcpu,
diff -puN drivers/kvm/x86_emulate.c~kvm-mmu-fix-cmpxchg8b-emulation drivers/kvm/x86_emulate.c
--- a/drivers/kvm/x86_emulate.c~kvm-mmu-fix-cmpxchg8b-emulation
+++ a/drivers/kvm/x86_emulate.c
@@ -1323,7 +1323,7 @@ twobyte_special_insn:
 							 ctxt)) != 0))
 				goto done;
 			if ((old_lo != _regs[VCPU_REGS_RAX])
-			    || (old_hi != _regs[VCPU_REGS_RDI])) {
+			    || (old_hi != _regs[VCPU_REGS_RDX])) {
 				_regs[VCPU_REGS_RAX] = old_lo;
 				_regs[VCPU_REGS_RDX] = old_hi;
 				_eflags &= ~EFLG_ZF;
_

Patches currently in -mm which might be from avi@qumranet.com are
