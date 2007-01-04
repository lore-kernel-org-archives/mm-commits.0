From: akpm@osdl.org
Subject: + kvm-mmu-never-free-a-shadow-page-actively-serving-as-a-root.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:12:18 -0800
Message-ID: <200701041912.l04JCIuY028378@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45034 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965096AbXADTMa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:12:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Never free a shadow page actively serving as a root
has been added to the -mm tree.  Its filename is
     kvm-mmu-never-free-a-shadow-page-actively-serving-as-a-root.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: Never free a shadow page actively serving as a root
From: Avi Kivity <avi@qumranet.com>

We always need cr3 to point to something valid, so if we detect that we're
freeing a root page, simply push it back to the top of the active list.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h |    1 +
 drivers/kvm/mmu.c |   20 ++++++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-mmu-never-free-a-shadow-page-actively-serving-as-a-root drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-mmu-never-free-a-shadow-page-actively-serving-as-a-root
+++ a/drivers/kvm/kvm.h
@@ -134,6 +134,7 @@ struct kvm_mmu_page {
 				    */
 	int global;              /* Set if all ptes in this page are global */
 	int multimapped;         /* More than one parent_pte? */
+	int root_count;          /* Currently serving as active root */
 	union {
 		u64 *parent_pte;               /* !multimapped */
 		struct hlist_head parent_ptes; /* multimapped, kvm_pte_chain */
diff -puN drivers/kvm/mmu.c~kvm-mmu-never-free-a-shadow-page-actively-serving-as-a-root drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-never-free-a-shadow-page-actively-serving-as-a-root
+++ a/drivers/kvm/mmu.c
@@ -550,8 +550,13 @@ static void kvm_mmu_zap_page(struct kvm_
 		*parent_pte = 0;
 	}
 	kvm_mmu_page_unlink_children(vcpu, page);
-	hlist_del(&page->hash_link);
-	kvm_mmu_free_page(vcpu, page->page_hpa);
+	if (!page->root_count) {
+		hlist_del(&page->hash_link);
+		kvm_mmu_free_page(vcpu, page->page_hpa);
+	} else {
+		list_del(&page->link);
+		list_add(&page->link, &vcpu->kvm->active_mmu_pages);
+	}
 }
 
 static int kvm_mmu_unprotect_page(struct kvm_vcpu *vcpu, gfn_t gfn)
@@ -667,12 +672,15 @@ static int nonpaging_map(struct kvm_vcpu
 static void mmu_free_roots(struct kvm_vcpu *vcpu)
 {
 	int i;
+	struct kvm_mmu_page *page;
 
 #ifdef CONFIG_X86_64
 	if (vcpu->mmu.shadow_root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->mmu.root_hpa;
 
 		ASSERT(VALID_PAGE(root));
+		page = page_header(root);
+		--page->root_count;
 		vcpu->mmu.root_hpa = INVALID_PAGE;
 		return;
 	}
@@ -682,6 +690,8 @@ static void mmu_free_roots(struct kvm_vc
 
 		ASSERT(VALID_PAGE(root));
 		root &= PT64_BASE_ADDR_MASK;
+		page = page_header(root);
+		--page->root_count;
 		vcpu->mmu.pae_root[i] = INVALID_PAGE;
 	}
 	vcpu->mmu.root_hpa = INVALID_PAGE;
@@ -691,6 +701,8 @@ static void mmu_alloc_roots(struct kvm_v
 {
 	int i;
 	gfn_t root_gfn;
+	struct kvm_mmu_page *page;
+
 	root_gfn = vcpu->cr3 >> PAGE_SHIFT;
 
 #ifdef CONFIG_X86_64
@@ -700,6 +712,8 @@ static void mmu_alloc_roots(struct kvm_v
 		ASSERT(!VALID_PAGE(root));
 		root = kvm_mmu_get_page(vcpu, root_gfn, 0,
 					PT64_ROOT_LEVEL, 0, NULL)->page_hpa;
+		page = page_header(root);
+		++page->root_count;
 		vcpu->mmu.root_hpa = root;
 		return;
 	}
@@ -715,6 +729,8 @@ static void mmu_alloc_roots(struct kvm_v
 		root = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
 					PT32_ROOT_LEVEL, !is_paging(vcpu),
 					NULL)->page_hpa;
+		page = page_header(root);
+		++page->root_count;
 		vcpu->mmu.pae_root[i] = root | PT_PRESENT_MASK;
 	}
 	vcpu->mmu.root_hpa = __pa(vcpu->mmu.pae_root);
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
