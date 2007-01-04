From: akpm@osdl.org
Subject: + kvm-mmu-fold-fetch_guest-into-init_walker.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:11:36 -0800
Message-ID: <200701041911.l04JBa1n028286@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:44895 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965066AbXADTLo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:11:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Fold fetch_guest() into init_walker()
has been added to the -mm tree.  Its filename is
     kvm-mmu-fold-fetch_guest-into-init_walker.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: Fold fetch_guest() into init_walker()
From: Avi Kivity <avi@qumranet.com>

It is never necessary to fetch a guest entry from an intermediate page table
level (except for large pages), so avoid some confusion by always descending
into the lowest possible level.

Rename init_walker() to walk_addr() as it is no longer restricted to
initialization.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/paging_tmpl.h |  105 ++++++++++++++++--------------------
 1 files changed, 47 insertions(+), 58 deletions(-)

diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-fold-fetch_guest-into-init_walker drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-fold-fetch_guest-into-init_walker
+++ a/drivers/kvm/paging_tmpl.h
@@ -54,14 +54,19 @@ struct guest_walker {
 	int level;
 	gfn_t table_gfn;
 	pt_element_t *table;
+	pt_element_t *ptep;
 	pt_element_t inherited_ar;
 };
 
-static void FNAME(init_walker)(struct guest_walker *walker,
-			       struct kvm_vcpu *vcpu)
+/*
+ * Fetch a guest pte for a guest virtual address
+ */
+static void FNAME(walk_addr)(struct guest_walker *walker,
+			     struct kvm_vcpu *vcpu, gva_t addr)
 {
 	hpa_t hpa;
 	struct kvm_memory_slot *slot;
+	pt_element_t *ptep;
 
 	walker->level = vcpu->mmu.root_level;
 	walker->table_gfn = (vcpu->cr3 & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
@@ -75,6 +80,38 @@ static void FNAME(init_walker)(struct gu
 	walker->table = (pt_element_t *)( (unsigned long)walker->table |
 		(unsigned long)(vcpu->cr3 & ~(PAGE_MASK | CR3_FLAGS_MASK)) );
 	walker->inherited_ar = PT_USER_MASK | PT_WRITABLE_MASK;
+
+	for (;;) {
+		int index = PT_INDEX(addr, walker->level);
+		hpa_t paddr;
+
+		ptep = &walker->table[index];
+		ASSERT(((unsigned long)walker->table & PAGE_MASK) ==
+		       ((unsigned long)ptep & PAGE_MASK));
+
+		/* Don't set accessed bit on PAE PDPTRs */
+		if (vcpu->mmu.root_level != 3 || walker->level != 3)
+			if ((*ptep & (PT_PRESENT_MASK | PT_ACCESSED_MASK))
+			    == PT_PRESENT_MASK)
+				*ptep |= PT_ACCESSED_MASK;
+
+		if (!is_present_pte(*ptep) ||
+		    walker->level == PT_PAGE_TABLE_LEVEL ||
+		    (walker->level == PT_DIRECTORY_LEVEL &&
+		     (*ptep & PT_PAGE_SIZE_MASK) &&
+		     (PTTYPE == 64 || is_pse(vcpu))))
+			break;
+
+		if (walker->level != 3 || is_long_mode(vcpu))
+			walker->inherited_ar &= walker->table[index];
+		walker->table_gfn = (*ptep & PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
+		paddr = safe_gpa_to_hpa(vcpu, *ptep & PT_BASE_ADDR_MASK);
+		kunmap_atomic(walker->table, KM_USER0);
+		walker->table = kmap_atomic(pfn_to_page(paddr >> PAGE_SHIFT),
+					    KM_USER0);
+		--walker->level;
+	}
+	walker->ptep = ptep;
 }
 
 static void FNAME(release_walker)(struct guest_walker *walker)
@@ -110,41 +147,6 @@ static void FNAME(set_pde)(struct kvm_vc
 }
 
 /*
- * Fetch a guest pte from a specific level in the paging hierarchy.
- */
-static pt_element_t *FNAME(fetch_guest)(struct kvm_vcpu *vcpu,
-					struct guest_walker *walker,
-					int level,
-					gva_t addr)
-{
-
-	ASSERT(level > 0  && level <= walker->level);
-
-	for (;;) {
-		int index = PT_INDEX(addr, walker->level);
-		hpa_t paddr;
-
-		ASSERT(((unsigned long)walker->table & PAGE_MASK) ==
-		       ((unsigned long)&walker->table[index] & PAGE_MASK));
-		if (level == walker->level ||
-		    !is_present_pte(walker->table[index]) ||
-		    (walker->level == PT_DIRECTORY_LEVEL &&
-		     (walker->table[index] & PT_PAGE_SIZE_MASK) &&
-		     (PTTYPE == 64 || is_pse(vcpu))))
-			return &walker->table[index];
-		if (walker->level != 3 || is_long_mode(vcpu))
-			walker->inherited_ar &= walker->table[index];
-		walker->table_gfn = (walker->table[index] & PT_BASE_ADDR_MASK)
-			>> PAGE_SHIFT;
-		paddr = safe_gpa_to_hpa(vcpu, walker->table[index] & PT_BASE_ADDR_MASK);
-		kunmap_atomic(walker->table, KM_USER0);
-		walker->table = kmap_atomic(pfn_to_page(paddr >> PAGE_SHIFT),
-					    KM_USER0);
-		--walker->level;
-	}
-}
-
-/*
  * Fetch a shadow pte for a specific level in the paging hierarchy.
  */
 static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
@@ -153,6 +155,10 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 	hpa_t shadow_addr;
 	int level;
 	u64 *prev_shadow_ent = NULL;
+	pt_element_t *guest_ent = walker->ptep;
+
+	if (!is_present_pte(*guest_ent))
+		return NULL;
 
 	shadow_addr = vcpu->mmu.root_hpa;
 	level = vcpu->mmu.shadow_root_level;
@@ -160,7 +166,6 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 	for (; ; level--) {
 		u32 index = SHADOW_PT_INDEX(addr, level);
 		u64 *shadow_ent = ((u64 *)__va(shadow_addr)) + index;
-		pt_element_t *guest_ent;
 		u64 shadow_pte;
 
 		if (is_present_pte(*shadow_ent) || is_io_pte(*shadow_ent)) {
@@ -171,21 +176,6 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 			continue;
 		}
 
-		if (PTTYPE == 32 && level > PT32_ROOT_LEVEL) {
-			ASSERT(level == PT32E_ROOT_LEVEL);
-			guest_ent = FNAME(fetch_guest)(vcpu, walker,
-						       PT32_ROOT_LEVEL, addr);
-		} else
-			guest_ent = FNAME(fetch_guest)(vcpu, walker,
-						       level, addr);
-
-		if (!is_present_pte(*guest_ent))
-			return NULL;
-
-		/* Don't set accessed bit on PAE PDPTRs */
-		if (vcpu->mmu.root_level != 3 || walker->level != 3)
-			*guest_ent |= PT_ACCESSED_MASK;
-
 		if (level == PT_PAGE_TABLE_LEVEL) {
 
 			if (walker->level == PT_DIRECTORY_LEVEL) {
@@ -253,7 +243,7 @@ static int FNAME(fix_write_pf)(struct kv
 			*shadow_ent &= ~PT_USER_MASK;
 		}
 
-	guest_ent = FNAME(fetch_guest)(vcpu, walker, PT_PAGE_TABLE_LEVEL, addr);
+	guest_ent = walker->ptep;
 
 	if (!is_present_pte(*guest_ent)) {
 		*shadow_ent = 0;
@@ -296,7 +286,7 @@ static int FNAME(page_fault)(struct kvm_
 	 * Look up the shadow pte for the faulting address.
 	 */
 	for (;;) {
-		FNAME(init_walker)(&walker, vcpu);
+		FNAME(walk_addr)(&walker, vcpu, addr);
 		shadow_pte = FNAME(fetch)(vcpu, addr, &walker);
 		if (IS_ERR(shadow_pte)) {  /* must be -ENOMEM */
 			nonpaging_flush(vcpu);
@@ -357,9 +347,8 @@ static gpa_t FNAME(gva_to_gpa)(struct kv
 	pt_element_t guest_pte;
 	gpa_t gpa;
 
-	FNAME(init_walker)(&walker, vcpu);
-	guest_pte = *FNAME(fetch_guest)(vcpu, &walker, PT_PAGE_TABLE_LEVEL,
-					vaddr);
+	FNAME(walk_addr)(&walker, vcpu, vaddr);
+	guest_pte = *walker.ptep;
 	FNAME(release_walker)(&walker);
 
 	if (!is_present_pte(guest_pte))
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
