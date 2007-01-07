From: akpm@osdl.org
Subject: - kvm-mmu-remove-invlpg-interception.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:36 -0800
Message-ID: <200701070759.l077xaQC013074@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40906 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466AbXAGH7p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Remove invlpg interception
has been removed from the -mm tree.  Its filename was
     kvm-mmu-remove-invlpg-interception.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
