From: akpm@osdl.org
Subject: + kvm-mu-special-treatment-for-shadow-pae-root-pages.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:11:38 -0800
Message-ID: <200701041911.l04JBcDk028289@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44907 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965045AbXADTLt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:11:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MU: Special treatment for shadow pae root pages
has been added to the -mm tree.  Its filename is
     kvm-mu-special-treatment-for-shadow-pae-root-pages.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MU: Special treatment for shadow pae root pages
From: Avi Kivity <avi@qumranet.com>

Since we're not going to cache the pae-mode shadow root pages, allocate a
single pae shadow that will hold the four lower-level pages, which will act as
roots.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h |   17 ------
 drivers/kvm/mmu.c |  110 ++++++++++++++++++++++++++++++++------------
 2 files changed, 82 insertions(+), 45 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-mu-special-treatment-for-shadow-pae-root-pages drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-mu-special-treatment-for-shadow-pae-root-pages
+++ a/drivers/kvm/kvm.h
@@ -123,6 +123,8 @@ struct kvm_mmu {
 	hpa_t root_hpa;
 	int root_level;
 	int shadow_root_level;
+
+	u64 *pae_root;
 };
 
 struct kvm_guest_debug {
@@ -548,19 +550,4 @@ static inline u32 get_rdx_init_val(void)
 #define TSS_REDIRECTION_SIZE (256 / 8)
 #define RMODE_TSS_SIZE (TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
 
-#ifdef CONFIG_X86_64
-
-/*
- * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.  Therefore
- * we need to allocate shadow page tables in the first 4GB of memory, which
- * happens to fit the DMA32 zone.
- */
-#define GFP_KVM_MMU (GFP_KERNEL | __GFP_DMA32)
-
-#else
-
-#define GFP_KVM_MMU GFP_KERNEL
-
-#endif
-
 #endif
diff -puN drivers/kvm/mmu.c~kvm-mu-special-treatment-for-shadow-pae-root-pages drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mu-special-treatment-for-shadow-pae-root-pages
+++ a/drivers/kvm/mmu.c
@@ -420,19 +420,63 @@ static int nonpaging_map(struct kvm_vcpu
 	}
 }
 
+static void mmu_free_roots(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+#ifdef CONFIG_X86_64
+	if (vcpu->mmu.shadow_root_level == PT64_ROOT_LEVEL) {
+		hpa_t root = vcpu->mmu.root_hpa;
+
+		ASSERT(VALID_PAGE(root));
+		release_pt_page_64(vcpu, root, PT64_ROOT_LEVEL);
+		vcpu->mmu.root_hpa = INVALID_PAGE;
+		return;
+	}
+#endif
+	for (i = 0; i < 4; ++i) {
+		hpa_t root = vcpu->mmu.pae_root[i];
+
+		ASSERT(VALID_PAGE(root));
+		root &= PT64_BASE_ADDR_MASK;
+		release_pt_page_64(vcpu, root, PT32E_ROOT_LEVEL - 1);
+		vcpu->mmu.pae_root[i] = INVALID_PAGE;
+	}
+	vcpu->mmu.root_hpa = INVALID_PAGE;
+}
+
+static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+#ifdef CONFIG_X86_64
+	if (vcpu->mmu.shadow_root_level == PT64_ROOT_LEVEL) {
+		hpa_t root = vcpu->mmu.root_hpa;
+
+		ASSERT(!VALID_PAGE(root));
+		root = kvm_mmu_alloc_page(vcpu, NULL);
+		vcpu->mmu.root_hpa = root;
+		return;
+	}
+#endif
+	for (i = 0; i < 4; ++i) {
+		hpa_t root = vcpu->mmu.pae_root[i];
+
+		ASSERT(!VALID_PAGE(root));
+		root = kvm_mmu_alloc_page(vcpu, NULL);
+		vcpu->mmu.pae_root[i] = root | PT_PRESENT_MASK;
+	}
+	vcpu->mmu.root_hpa = __pa(vcpu->mmu.pae_root);
+}
+
 static void nonpaging_flush(struct kvm_vcpu *vcpu)
 {
 	hpa_t root = vcpu->mmu.root_hpa;
 
 	++kvm_stat.tlb_flush;
 	pgprintk("nonpaging_flush\n");
-	ASSERT(VALID_PAGE(root));
-	release_pt_page_64(vcpu, root, vcpu->mmu.shadow_root_level);
-	root = kvm_mmu_alloc_page(vcpu, NULL);
-	ASSERT(VALID_PAGE(root));
-	vcpu->mmu.root_hpa = root;
-	if (is_paging(vcpu))
-		root |= (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK));
+	mmu_free_roots(vcpu);
+	mmu_alloc_roots(vcpu);
 	kvm_arch_ops->set_cr3(vcpu, root);
 	kvm_arch_ops->tlb_flush(vcpu);
 }
@@ -475,13 +519,7 @@ static void nonpaging_inval_page(struct 
 
 static void nonpaging_free(struct kvm_vcpu *vcpu)
 {
-	hpa_t root;
-
-	ASSERT(vcpu);
-	root = vcpu->mmu.root_hpa;
-	if (VALID_PAGE(root))
-		release_pt_page_64(vcpu, root, vcpu->mmu.shadow_root_level);
-	vcpu->mmu.root_hpa = INVALID_PAGE;
+	mmu_free_roots(vcpu);
 }
 
 static int nonpaging_init_context(struct kvm_vcpu *vcpu)
@@ -495,7 +533,7 @@ static int nonpaging_init_context(struct
 	context->free = nonpaging_free;
 	context->root_level = PT32E_ROOT_LEVEL;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
-	context->root_hpa = kvm_mmu_alloc_page(vcpu, NULL);
+	mmu_alloc_roots(vcpu);
 	ASSERT(VALID_PAGE(context->root_hpa));
 	kvm_arch_ops->set_cr3(vcpu, context->root_hpa);
 	return 0;
@@ -647,7 +685,7 @@ static void paging_free(struct kvm_vcpu 
 #include "paging_tmpl.h"
 #undef PTTYPE
 
-static int paging64_init_context(struct kvm_vcpu *vcpu)
+static int paging64_init_context_common(struct kvm_vcpu *vcpu, int level)
 {
 	struct kvm_mmu *context = &vcpu->mmu;
 
@@ -657,15 +695,20 @@ static int paging64_init_context(struct 
 	context->inval_page = paging_inval_page;
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->free = paging_free;
-	context->root_level = PT64_ROOT_LEVEL;
-	context->shadow_root_level = PT64_ROOT_LEVEL;
-	context->root_hpa = kvm_mmu_alloc_page(vcpu, NULL);
+	context->root_level = level;
+	context->shadow_root_level = level;
+	mmu_alloc_roots(vcpu);
 	ASSERT(VALID_PAGE(context->root_hpa));
 	kvm_arch_ops->set_cr3(vcpu, context->root_hpa |
 		    (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK)));
 	return 0;
 }
 
+static int paging64_init_context(struct kvm_vcpu *vcpu)
+{
+	return paging64_init_context_common(vcpu, PT64_ROOT_LEVEL);
+}
+
 static int paging32_init_context(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *context = &vcpu->mmu;
@@ -677,7 +720,7 @@ static int paging32_init_context(struct 
 	context->free = paging_free;
 	context->root_level = PT32_ROOT_LEVEL;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
-	context->root_hpa = kvm_mmu_alloc_page(vcpu, NULL);
+	mmu_alloc_roots(vcpu);
 	ASSERT(VALID_PAGE(context->root_hpa));
 	kvm_arch_ops->set_cr3(vcpu, context->root_hpa |
 		    (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK)));
@@ -686,14 +729,7 @@ static int paging32_init_context(struct 
 
 static int paging32E_init_context(struct kvm_vcpu *vcpu)
 {
-	int ret;
-
-	if ((ret = paging64_init_context(vcpu)))
-		return ret;
-
-	vcpu->mmu.root_level = PT32E_ROOT_LEVEL;
-	vcpu->mmu.shadow_root_level = PT32E_ROOT_LEVEL;
-	return 0;
+	return paging64_init_context_common(vcpu, PT32E_ROOT_LEVEL);
 }
 
 static int init_kvm_mmu(struct kvm_vcpu *vcpu)
@@ -737,26 +773,40 @@ static void free_mmu_pages(struct kvm_vc
 		__free_page(pfn_to_page(page->page_hpa >> PAGE_SHIFT));
 		page->page_hpa = INVALID_PAGE;
 	}
+	free_page((unsigned long)vcpu->mmu.pae_root);
 }
 
 static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 {
+	struct page *page;
 	int i;
 
 	ASSERT(vcpu);
 
 	for (i = 0; i < KVM_NUM_MMU_PAGES; i++) {
-		struct page *page;
 		struct kvm_mmu_page *page_header = &vcpu->page_header_buf[i];
 
 		INIT_LIST_HEAD(&page_header->link);
-		if ((page = alloc_page(GFP_KVM_MMU)) == NULL)
+		if ((page = alloc_page(GFP_KERNEL)) == NULL)
 			goto error_1;
 		page->private = (unsigned long)page_header;
 		page_header->page_hpa = (hpa_t)page_to_pfn(page) << PAGE_SHIFT;
 		memset(__va(page_header->page_hpa), 0, PAGE_SIZE);
 		list_add(&page_header->link, &vcpu->free_pages);
 	}
+
+	/*
+	 * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.
+	 * Therefore we need to allocate shadow page tables in the first
+	 * 4GB of memory, which happens to fit the DMA32 zone.
+	 */
+	page = alloc_page(GFP_KERNEL | __GFP_DMA32);
+	if (!page)
+		goto error_1;
+	vcpu->mmu.pae_root = page_address(page);
+	for (i = 0; i < 4; ++i)
+		vcpu->mmu.pae_root[i] = INVALID_PAGE;
+
 	return 0;
 
 error_1:
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
