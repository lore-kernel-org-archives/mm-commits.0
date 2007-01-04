From: akpm@osdl.org
Subject: + kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:11:40 -0800
Message-ID: <200701041911.l04JBeLN028292@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44910 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030181AbXADTLt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:11:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Use the guest pdptrs instead of mapping cr3 in pae mode
has been added to the -mm tree.  Its filename is
     kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: Use the guest pdptrs instead of mapping cr3 in pae mode
From: Avi Kivity <avi@qumranet.com>

This lets us not write protect a partial page, and is anyway what a real
processor does.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c    |    2 ++
 drivers/kvm/paging_tmpl.h |   28 ++++++++++++++++++----------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode
+++ a/drivers/kvm/kvm_main.c
@@ -1491,6 +1491,8 @@ static int kvm_dev_ioctl_set_sregs(struc
 
 	mmu_reset_needed |= vcpu->cr4 != sregs->cr4;
 	kvm_arch_ops->set_cr4(vcpu, sregs->cr4);
+	if (!is_long_mode(vcpu) && is_pae(vcpu))
+		load_pdptrs(vcpu, vcpu->cr3);
 
 	if (mmu_reset_needed)
 		kvm_mmu_reset_context(vcpu);
diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode
+++ a/drivers/kvm/paging_tmpl.h
@@ -67,18 +67,28 @@ static void FNAME(walk_addr)(struct gues
 	hpa_t hpa;
 	struct kvm_memory_slot *slot;
 	pt_element_t *ptep;
+	pt_element_t root;
 
 	walker->level = vcpu->mmu.root_level;
-	walker->table_gfn = (vcpu->cr3 & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
+	walker->table = NULL;
+	root = vcpu->cr3;
+#if PTTYPE == 64
+	if (!is_long_mode(vcpu)) {
+		walker->ptep = &vcpu->pdptrs[(addr >> 30) & 3];
+		root = *walker->ptep;
+		if (!(root & PT_PRESENT_MASK))
+			return;
+		--walker->level;
+	}
+#endif
+	walker->table_gfn = (root & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 	slot = gfn_to_memslot(vcpu->kvm, walker->table_gfn);
-	hpa = safe_gpa_to_hpa(vcpu, vcpu->cr3 & PT64_BASE_ADDR_MASK);
+	hpa = safe_gpa_to_hpa(vcpu, root & PT64_BASE_ADDR_MASK);
 	walker->table = kmap_atomic(pfn_to_page(hpa >> PAGE_SHIFT), KM_USER0);
 
 	ASSERT((!is_long_mode(vcpu) && is_pae(vcpu)) ||
 	       (vcpu->cr3 & ~(PAGE_MASK | CR3_FLAGS_MASK)) == 0);
 
-	walker->table = (pt_element_t *)( (unsigned long)walker->table |
-		(unsigned long)(vcpu->cr3 & ~(PAGE_MASK | CR3_FLAGS_MASK)) );
 	walker->inherited_ar = PT_USER_MASK | PT_WRITABLE_MASK;
 
 	for (;;) {
@@ -89,11 +99,8 @@ static void FNAME(walk_addr)(struct gues
 		ASSERT(((unsigned long)walker->table & PAGE_MASK) ==
 		       ((unsigned long)ptep & PAGE_MASK));
 
-		/* Don't set accessed bit on PAE PDPTRs */
-		if (vcpu->mmu.root_level != 3 || walker->level != 3)
-			if ((*ptep & (PT_PRESENT_MASK | PT_ACCESSED_MASK))
-			    == PT_PRESENT_MASK)
-				*ptep |= PT_ACCESSED_MASK;
+		if (is_present_pte(*ptep) && !(*ptep &  PT_ACCESSED_MASK))
+			*ptep |= PT_ACCESSED_MASK;
 
 		if (!is_present_pte(*ptep) ||
 		    walker->level == PT_PAGE_TABLE_LEVEL ||
@@ -116,7 +123,8 @@ static void FNAME(walk_addr)(struct gues
 
 static void FNAME(release_walker)(struct guest_walker *walker)
 {
-	kunmap_atomic(walker->table, KM_USER0);
+	if (walker->table)
+		kunmap_atomic(walker->table, KM_USER0);
 }
 
 static void FNAME(set_pte)(struct kvm_vcpu *vcpu, u64 guest_pte,
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
