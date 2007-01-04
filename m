From: akpm@osdl.org
Subject: + kvm-mmu-if-emulating-an-instruction-fails-try-unprotecting-the-page.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:11:56 -0800
Message-ID: <200701041911.l04JBuKd028324@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44984 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030186AbXADTMO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:12:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: If emulating an instruction fails, try unprotecting the page
has been added to the -mm tree.  Its filename is
     kvm-mmu-if-emulating-an-instruction-fails-try-unprotecting-the-page.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: If emulating an instruction fails, try unprotecting the page
From: Avi Kivity <avi@qumranet.com>

A page table may have been recycled into a regular page, and so any
instruction can be executed on it.  Unprotect the page and let the cpu do its
thing.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    1 
 drivers/kvm/kvm_main.c |    2 +
 drivers/kvm/mmu.c      |   58 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff -puN drivers/kvm/kvm.h~kvm-mmu-if-emulating-an-instruction-fails-try-unprotecting-the-page drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-mmu-if-emulating-an-instruction-fails-try-unprotecting-the-page
+++ a/drivers/kvm/kvm.h
@@ -450,6 +450,7 @@ unsigned long segment_base(u16 selector)
 
 void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes);
 void kvm_mmu_post_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes);
+int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 
 static inline struct page *_gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
diff -puN drivers/kvm/kvm_main.c~kvm-mmu-if-emulating-an-instruction-fails-try-unprotecting-the-page drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-mmu-if-emulating-an-instruction-fails-try-unprotecting-the-page
+++ a/drivers/kvm/kvm_main.c
@@ -1063,6 +1063,8 @@ int emulate_instruction(struct kvm_vcpu 
 	}
 
 	if (r) {
+		if (kvm_mmu_unprotect_page_virt(vcpu, cr2))
+			return EMULATE_DONE;
 		if (!vcpu->mmio_needed) {
 			report_emulation_failure(&emulate_ctxt);
 			return EMULATE_FAIL;
diff -puN drivers/kvm/mmu.c~kvm-mmu-if-emulating-an-instruction-fails-try-unprotecting-the-page drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-if-emulating-an-instruction-fails-try-unprotecting-the-page
+++ a/drivers/kvm/mmu.c
@@ -478,11 +478,62 @@ static struct kvm_mmu_page *kvm_mmu_get_
 	return page;
 }
 
+static void kvm_mmu_page_unlink_children(struct kvm_vcpu *vcpu,
+					 struct kvm_mmu_page *page)
+{
+	BUG();
+}
+
 static void kvm_mmu_put_page(struct kvm_vcpu *vcpu,
 			     struct kvm_mmu_page *page,
 			     u64 *parent_pte)
 {
 	mmu_page_remove_parent_pte(page, parent_pte);
+	if (page->role.level > PT_PAGE_TABLE_LEVEL)
+		kvm_mmu_page_unlink_children(vcpu, page);
+	hlist_del(&page->hash_link);
+	list_del(&page->link);
+	list_add(&page->link, &vcpu->free_pages);
+}
+
+static void kvm_mmu_zap_page(struct kvm_vcpu *vcpu,
+			     struct kvm_mmu_page *page)
+{
+	u64 *parent_pte;
+
+	while (page->multimapped || page->parent_pte) {
+		if (!page->multimapped)
+			parent_pte = page->parent_pte;
+		else {
+			struct kvm_pte_chain *chain;
+
+			chain = container_of(page->parent_ptes.first,
+					     struct kvm_pte_chain, link);
+			parent_pte = chain->parent_ptes[0];
+		}
+		kvm_mmu_put_page(vcpu, page, parent_pte);
+		*parent_pte = 0;
+	}
+}
+
+static int kvm_mmu_unprotect_page(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	unsigned index;
+	struct hlist_head *bucket;
+	struct kvm_mmu_page *page;
+	struct hlist_node *node, *n;
+	int r;
+
+	pgprintk("%s: looking for gfn %lx\n", __FUNCTION__, gfn);
+	r = 0;
+	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
+	bucket = &vcpu->kvm->mmu_page_hash[index];
+	hlist_for_each_entry_safe(page, node, n, bucket, hash_link)
+		if (page->gfn == gfn && !page->role.metaphysical) {
+			kvm_mmu_zap_page(vcpu, page);
+			r = 1;
+		}
+	return r;
 }
 
 static void page_header_update_slot(struct kvm *kvm, void *pte, gpa_t gpa)
@@ -1001,6 +1052,13 @@ void kvm_mmu_post_write(struct kvm_vcpu 
 {
 }
 
+int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
+{
+	gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, gva);
+
+	return kvm_mmu_unprotect_page(vcpu, gpa >> PAGE_SHIFT);
+}
+
 static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
 	while (!list_empty(&vcpu->free_pages)) {
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
