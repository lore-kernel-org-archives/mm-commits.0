From: akpm@osdl.org
Subject: + kvm-mmu-let-the-walker-extract-the-target-page-gfn-from-the-pte.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:11:50 -0800
Message-ID: <200701041911.l04JBoYj028315@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44932 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965082AbXADTL7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:11:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Let the walker extract the target page gfn from the pte
has been added to the -mm tree.  Its filename is
     kvm-mmu-let-the-walker-extract-the-target-page-gfn-from-the-pte.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: Let the walker extract the target page gfn from the pte
From: Avi Kivity <avi@qumranet.com>

This fixes a problem where set_pte_common() looked for shadowed pages based on
the page directory gfn (a huge page) instead of the actual gfn being mapped.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c         |    7 +++---
 drivers/kvm/paging_tmpl.h |   41 +++++++++++++++++++++++-------------
 2 files changed, 31 insertions(+), 17 deletions(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-let-the-walker-extract-the-target-page-gfn-from-the-pte drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-let-the-walker-extract-the-target-page-gfn-from-the-pte
+++ a/drivers/kvm/mmu.c
@@ -752,7 +752,8 @@ static inline void set_pte_common(struct
 			     u64 *shadow_pte,
 			     gpa_t gaddr,
 			     int dirty,
-			     u64 access_bits)
+			     u64 access_bits,
+			     gfn_t gfn)
 {
 	hpa_t paddr;
 
@@ -779,10 +780,10 @@ static inline void set_pte_common(struct
 	if (access_bits & PT_WRITABLE_MASK) {
 		struct kvm_mmu_page *shadow;
 
-		shadow = kvm_mmu_lookup_page(vcpu, gaddr >> PAGE_SHIFT);
+		shadow = kvm_mmu_lookup_page(vcpu, gfn);
 		if (shadow) {
 			pgprintk("%s: found shadow page for %lx, marking ro\n",
-				 __FUNCTION__, (gfn_t)(gaddr >> PAGE_SHIFT));
+				 __FUNCTION__, gfn);
 			access_bits &= ~PT_WRITABLE_MASK;
 			*shadow_pte &= ~PT_WRITABLE_MASK;
 		}
diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-let-the-walker-extract-the-target-page-gfn-from-the-pte drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-let-the-walker-extract-the-target-page-gfn-from-the-pte
+++ a/drivers/kvm/paging_tmpl.h
@@ -62,6 +62,7 @@ struct guest_walker {
 	pt_element_t *table;
 	pt_element_t *ptep;
 	pt_element_t inherited_ar;
+	gfn_t gfn;
 };
 
 /*
@@ -113,12 +114,23 @@ static void FNAME(walk_addr)(struct gues
 		if (is_present_pte(*ptep) && !(*ptep &  PT_ACCESSED_MASK))
 			*ptep |= PT_ACCESSED_MASK;
 
-		if (!is_present_pte(*ptep) ||
-		    walker->level == PT_PAGE_TABLE_LEVEL ||
-		    (walker->level == PT_DIRECTORY_LEVEL &&
-		     (*ptep & PT_PAGE_SIZE_MASK) &&
-		     (PTTYPE == 64 || is_pse(vcpu))))
+		if (!is_present_pte(*ptep))
+			break;
+
+		if (walker->level == PT_PAGE_TABLE_LEVEL) {
+			walker->gfn = (*ptep & PT_BASE_ADDR_MASK)
+				>> PAGE_SHIFT;
+			break;
+		}
+
+		if (walker->level == PT_DIRECTORY_LEVEL
+		    && (*ptep & PT_PAGE_SIZE_MASK)
+		    && (PTTYPE == 64 || is_pse(vcpu))) {
+			walker->gfn = (*ptep & PT_DIR_BASE_ADDR_MASK)
+				>> PAGE_SHIFT;
+			walker->gfn += PT_INDEX(addr, PT_PAGE_TABLE_LEVEL);
 			break;
+		}
 
 		if (walker->level != 3 || is_long_mode(vcpu))
 			walker->inherited_ar &= walker->table[index];
@@ -143,30 +155,29 @@ static void FNAME(release_walker)(struct
 }
 
 static void FNAME(set_pte)(struct kvm_vcpu *vcpu, u64 guest_pte,
-			   u64 *shadow_pte, u64 access_bits)
+			   u64 *shadow_pte, u64 access_bits, gfn_t gfn)
 {
 	ASSERT(*shadow_pte == 0);
 	access_bits &= guest_pte;
 	*shadow_pte = (guest_pte & PT_PTE_COPY_MASK);
 	set_pte_common(vcpu, shadow_pte, guest_pte & PT_BASE_ADDR_MASK,
-		       guest_pte & PT_DIRTY_MASK, access_bits);
+		       guest_pte & PT_DIRTY_MASK, access_bits, gfn);
 }
 
 static void FNAME(set_pde)(struct kvm_vcpu *vcpu, u64 guest_pde,
-			   u64 *shadow_pte, u64 access_bits,
-			   int index)
+			   u64 *shadow_pte, u64 access_bits, gfn_t gfn)
 {
 	gpa_t gaddr;
 
 	ASSERT(*shadow_pte == 0);
 	access_bits &= guest_pde;
-	gaddr = (guest_pde & PT_DIR_BASE_ADDR_MASK) + PAGE_SIZE * index;
+	gaddr = (gpa_t)gfn << PAGE_SHIFT;
 	if (PTTYPE == 32 && is_cpuid_PSE36())
 		gaddr |= (guest_pde & PT32_DIR_PSE36_MASK) <<
 			(32 - PT32_DIR_PSE36_SHIFT);
 	*shadow_pte = guest_pde & PT_PTE_COPY_MASK;
 	set_pte_common(vcpu, shadow_pte, gaddr,
-		       guest_pde & PT_DIRTY_MASK, access_bits);
+		       guest_pde & PT_DIRTY_MASK, access_bits, gfn);
 }
 
 /*
@@ -214,10 +225,12 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 					*prev_shadow_ent |= PT_SHADOW_PS_MARK;
 				FNAME(set_pde)(vcpu, *guest_ent, shadow_ent,
 					       walker->inherited_ar,
-				          PT_INDEX(addr, PT_PAGE_TABLE_LEVEL));
+					       walker->gfn);
 			} else {
 				ASSERT(walker->level == PT_PAGE_TABLE_LEVEL);
-				FNAME(set_pte)(vcpu, *guest_ent, shadow_ent, walker->inherited_ar);
+				FNAME(set_pte)(vcpu, *guest_ent, shadow_ent,
+					       walker->inherited_ar,
+					       walker->gfn);
 			}
 			return shadow_ent;
 		}
@@ -291,7 +304,7 @@ static int FNAME(fix_write_pf)(struct kv
 		return 0;
 	}
 
-	gfn = (*guest_ent & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
+	gfn = walker->gfn;
 	if (kvm_mmu_lookup_page(vcpu, gfn)) {
 		pgprintk("%s: found shadow page for %lx, marking ro\n",
 			 __FUNCTION__, gfn);
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
