From: akpm@osdl.org
Subject: + kvm-mmu-zap-shadow-page-table-entries-on-writes-to-guest-page-tables.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:11:54 -0800
Message-ID: <200701041911.l04JBsGl028321@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44937 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965081AbXADTMD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:12:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Zap shadow page table entries on writes to guest page tables
has been added to the -mm tree.  Its filename is
     kvm-mmu-zap-shadow-page-table-entries-on-writes-to-guest-page-tables.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: Zap shadow page table entries on writes to guest page tables
From: Avi Kivity <avi@qumranet.com>

Iterate over all shadow pages which correspond to a the given guest page table
and remove the mappings.

A subsequent page fault will reestablish the new mapping.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+)

diff -puN drivers/kvm/mmu.c~kvm-mmu-zap-shadow-page-table-entries-on-writes-to-guest-page-tables drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-zap-shadow-page-table-entries-on-writes-to-guest-page-tables
+++ a/drivers/kvm/mmu.c
@@ -958,7 +958,43 @@ int kvm_mmu_reset_context(struct kvm_vcp
 
 void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
 {
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *child;
+	struct hlist_node *node;
+	struct hlist_head *bucket;
+	unsigned index;
+	u64 *spte;
+	u64 pte;
+	unsigned offset = offset_in_page(gpa);
+	unsigned page_offset;
+	int level;
+
 	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
+	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
+	bucket = &vcpu->kvm->mmu_page_hash[index];
+	hlist_for_each_entry(page, node, bucket, hash_link) {
+		if (page->gfn != gfn || page->role.metaphysical)
+			continue;
+		page_offset = offset;
+		level = page->role.level;
+		if (page->role.glevels == PT32_ROOT_LEVEL) {
+			page_offset <<= 1;          /* 32->64 */
+			page_offset &= ~PAGE_MASK;
+		}
+		spte = __va(page->page_hpa);
+		spte += page_offset / sizeof(*spte);
+		pte = *spte;
+		if (is_present_pte(pte)) {
+			if (level == PT_PAGE_TABLE_LEVEL)
+				rmap_remove(vcpu->kvm, spte);
+			else {
+				child = page_header(pte & PT64_BASE_ADDR_MASK);
+				mmu_page_remove_parent_pte(child, spte);
+			}
+		}
+		*spte = 0;
+	}
 }
 
 void kvm_mmu_post_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
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
