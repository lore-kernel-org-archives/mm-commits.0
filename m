From: akpm@osdl.org
Subject: + kvm-mmu-fix-cmpxchg8b-emulation.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:12:20 -0800
Message-ID: <200701041912.l04JCKdA028383@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:45031 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965083AbXADTM2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:12:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Fix cmpxchg8b emulation
has been added to the -mm tree.  Its filename is
     kvm-mmu-fix-cmpxchg8b-emulation.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kvm-fix-gfp_kernel-alloc-in-atomic-section-bug.patch
kvm-use-raw_smp_processor_id-instead-of-smp_processor_id-where-applicable.patch
kvm-recover-after-an-arch-module-load-failure.patch
kvm-improve-interrupt-response.patch
kvm-prevent-stale-bits-in-cr0-and-cr4.patch
kvm-mmu-implement-simple-reverse-mapping.patch
kvm-mmu-teach-the-page-table-walker-to-track-guest-page-table-gfns.patch
kvm-mmu-load-the-pae-pdptrs-on-cr3-change-like-the-processor-does.patch
kvm-mmu-fold-fetch_guest-into-init_walker.patch
kvm-mu-special-treatment-for-shadow-pae-root-pages.patch
kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode.patch
kvm-mmu-make-the-shadow-page-tables-also-special-case-pae.patch
kvm-mmu-make-kvm_mmu_alloc_page-return-a-kvm_mmu_page-pointer.patch
kvm-mmu-shadow-page-table-caching.patch
kvm-mmu-write-protect-guest-pages-when-a-shadow-is-created-for-them.patch
kvm-mmu-let-the-walker-extract-the-target-page-gfn-from-the-pte.patch
kvm-mmu-support-emulated-writes-into-ram.patch
kvm-mmu-zap-shadow-page-table-entries-on-writes-to-guest-page-tables.patch
kvm-mmu-if-emulating-an-instruction-fails-try-unprotecting-the-page.patch
kvm-mmu-implement-child-shadow-unlinking.patch
kvm-mmu-kvm_mmu_put_page-only-removes-one-link-to-the-page.patch
kvm-mmu-oom-handling.patch
kvm-mmu-remove-invlpg-interception.patch
kvm-mmu-remove-release_pt_page_64.patch
kvm-mmu-handle-misaligned-accesses-to-write-protected-guest-page-tables.patch
kvm-mmu-ove-is_empty_shadow_page-above-kvm_mmu_free_page.patch
kvm-mmu-ensure-freed-shadow-pages-are-clean.patch
kvm-mmu-if-an-empty-shadow-page-is-not-empty-report-more-info.patch
kvm-mmu-page-table-write-flood-protection.patch
kvm-mmu-never-free-a-shadow-page-actively-serving-as-a-root.patch
kvm-mmu-fix-cmpxchg8b-emulation.patch
kvm-mmu-treat-user-mode-faults-as-a-hint-that-a-page-is-no-longer-a-page-table.patch
kvm-mmu-free-pages-on-kvm-destruction.patch
kvm-mmu-replace-atomic-allocations-by-preallocated-objects.patch
kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace.patch
kvm-mmu-flush-guest-tlb-when-reducing-permissions-on-a-pte.patch
kvm-mmu-destroy-mmu-while-we-still-have-a-vcpu-left.patch
kvm-mmu-add-audit-code-to-check-mappings-etc-are-correct.patch
