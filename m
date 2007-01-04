From: akpm@osdl.org
Subject: + kvm-mmu-remove-invlpg-interception.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:12:04 -0800
Message-ID: <200701041912.l04JC4Mx028341@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:45015 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965095AbXADTMX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:12:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Remove invlpg interception
has been added to the -mm tree.  Its filename is
     kvm-mmu-remove-invlpg-interception.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: Remove invlpg interception
From: Avi Kivity <avi@qumranet.com>

Since we write protect shadowed guest page tables, there is no need to trap
page invalidations (the guest will always change the mapping before issuing
the invlpg instruction).

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    1 
 drivers/kvm/kvm_main.c |    4 ---
 drivers/kvm/mmu.c      |   43 ---------------------------------------
 drivers/kvm/svm.c      |    1 
 drivers/kvm/vmx.c      |   13 -----------
 5 files changed, 62 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-mmu-remove-invlpg-interception drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-mmu-remove-invlpg-interception
+++ a/drivers/kvm/kvm.h
@@ -158,7 +158,6 @@ struct kvm_vcpu;
 struct kvm_mmu {
 	void (*new_cr3)(struct kvm_vcpu *vcpu);
 	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err);
-	void (*inval_page)(struct kvm_vcpu *vcpu, gva_t gva);
 	void (*free)(struct kvm_vcpu *vcpu);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva);
 	hpa_t root_hpa;
diff -puN drivers/kvm/kvm_main.c~kvm-mmu-remove-invlpg-interception drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-mmu-remove-invlpg-interception
+++ a/drivers/kvm/kvm_main.c
@@ -943,10 +943,6 @@ static unsigned long get_segment_base(st
 
 int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address)
 {
-	spin_lock(&vcpu->kvm->lock);
-	vcpu->mmu.inval_page(vcpu, address);
-	spin_unlock(&vcpu->kvm->lock);
-	kvm_arch_ops->invlpg(vcpu, address);
 	return X86EMUL_CONTINUE;
 }
 
diff -puN drivers/kvm/mmu.c~kvm-mmu-remove-invlpg-interception drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-remove-invlpg-interception
+++ a/drivers/kvm/mmu.c
@@ -767,10 +767,6 @@ static int nonpaging_page_fault(struct k
 	return nonpaging_map(vcpu, addr & PAGE_MASK, paddr);
 }
 
-static void nonpaging_inval_page(struct kvm_vcpu *vcpu, gva_t addr)
-{
-}
-
 static void nonpaging_free(struct kvm_vcpu *vcpu)
 {
 	mmu_free_roots(vcpu);
@@ -782,7 +778,6 @@ static int nonpaging_init_context(struct
 
 	context->new_cr3 = nonpaging_new_cr3;
 	context->page_fault = nonpaging_page_fault;
-	context->inval_page = nonpaging_inval_page;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
 	context->free = nonpaging_free;
 	context->root_level = 0;
@@ -895,42 +890,6 @@ static int may_access(u64 pte, int write
 	return 1;
 }
 
-/*
- * Remove a shadow pte.
- */
-static void paging_inval_page(struct kvm_vcpu *vcpu, gva_t addr)
-{
-	hpa_t page_addr = vcpu->mmu.root_hpa;
-	int level = vcpu->mmu.shadow_root_level;
-
-	++kvm_stat.invlpg;
-
-	for (; ; level--) {
-		u32 index = PT64_INDEX(addr, level);
-		u64 *table = __va(page_addr);
-
-		if (level == PT_PAGE_TABLE_LEVEL ) {
-			rmap_remove(vcpu->kvm, &table[index]);
-			table[index] = 0;
-			return;
-		}
-
-		if (!is_present_pte(table[index]))
-			return;
-
-		page_addr = table[index] & PT64_BASE_ADDR_MASK;
-
-		if (level == PT_DIRECTORY_LEVEL &&
-			  (table[index] & PT_SHADOW_PS_MARK)) {
-			table[index] = 0;
-			release_pt_page_64(vcpu, page_addr, PT_PAGE_TABLE_LEVEL);
-
-			kvm_arch_ops->tlb_flush(vcpu);
-			return;
-		}
-	}
-}
-
 static void paging_free(struct kvm_vcpu *vcpu)
 {
 	nonpaging_free(vcpu);
@@ -951,7 +910,6 @@ static int paging64_init_context_common(
 	ASSERT(is_pae(vcpu));
 	context->new_cr3 = paging_new_cr3;
 	context->page_fault = paging64_page_fault;
-	context->inval_page = paging_inval_page;
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->free = paging_free;
 	context->root_level = level;
@@ -974,7 +932,6 @@ static int paging32_init_context(struct 
 
 	context->new_cr3 = paging_new_cr3;
 	context->page_fault = paging32_page_fault;
-	context->inval_page = paging_inval_page;
 	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->free = paging_free;
 	context->root_level = PT32_ROOT_LEVEL;
diff -puN drivers/kvm/svm.c~kvm-mmu-remove-invlpg-interception drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-mmu-remove-invlpg-interception
+++ a/drivers/kvm/svm.c
@@ -497,7 +497,6 @@ static void init_vmcb(struct vmcb *vmcb)
 		/*              (1ULL << INTERCEPT_SELECTIVE_CR0) | */
 				(1ULL << INTERCEPT_CPUID) |
 				(1ULL << INTERCEPT_HLT) |
-				(1ULL << INTERCEPT_INVLPG) |
 				(1ULL << INTERCEPT_INVLPGA) |
 				(1ULL << INTERCEPT_IOIO_PROT) |
 				(1ULL << INTERCEPT_MSR_PROT) |
diff -puN drivers/kvm/vmx.c~kvm-mmu-remove-invlpg-interception drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-mmu-remove-invlpg-interception
+++ a/drivers/kvm/vmx.c
@@ -1059,7 +1059,6 @@ static int vmx_vcpu_setup(struct kvm_vcp
 			       | CPU_BASED_CR8_LOAD_EXITING    /* 20.6.2 */
 			       | CPU_BASED_CR8_STORE_EXITING   /* 20.6.2 */
 			       | CPU_BASED_UNCOND_IO_EXITING   /* 20.6.2 */
-			       | CPU_BASED_INVDPG_EXITING
 			       | CPU_BASED_MOV_DR_EXITING
 			       | CPU_BASED_USE_TSC_OFFSETING   /* 21.3 */
 			);
@@ -1438,17 +1437,6 @@ static int handle_io(struct kvm_vcpu *vc
 	return 0;
 }
 
-static int handle_invlpg(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
-{
-	u64 address = vmcs_read64(EXIT_QUALIFICATION);
-	int instruction_length = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
-	spin_lock(&vcpu->kvm->lock);
-	vcpu->mmu.inval_page(vcpu, address);
-	spin_unlock(&vcpu->kvm->lock);
-	vmcs_writel(GUEST_RIP, vmcs_readl(GUEST_RIP) + instruction_length);
-	return 1;
-}
-
 static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u64 exit_qualification;
@@ -1636,7 +1624,6 @@ static int (*kvm_vmx_exit_handlers[])(st
 	[EXIT_REASON_EXCEPTION_NMI]           = handle_exception,
 	[EXIT_REASON_EXTERNAL_INTERRUPT]      = handle_external_interrupt,
 	[EXIT_REASON_IO_INSTRUCTION]          = handle_io,
-	[EXIT_REASON_INVLPG]                  = handle_invlpg,
 	[EXIT_REASON_CR_ACCESS]               = handle_cr,
 	[EXIT_REASON_DR_ACCESS]               = handle_dr,
 	[EXIT_REASON_CPUID]                   = handle_cpuid,
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
