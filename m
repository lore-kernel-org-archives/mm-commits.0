From: akpm@osdl.org
Subject: + kvm-mmu-implement-child-shadow-unlinking.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:11:58 -0800
Message-ID: <200701041911.l04JBwNr028327@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:44961 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965088AbXADTMI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:12:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Implement child shadow unlinking
has been added to the -mm tree.  Its filename is
     kvm-mmu-implement-child-shadow-unlinking.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: Implement child shadow unlinking
From: Avi Kivity <avi@qumranet.com>

When removing a page table, we must maintain the parent_pte field all child
shadow page tables.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c |   42 ++++++++++++++++++++++++++++++++++++++----
 1 files changed, 38 insertions(+), 4 deletions(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-implement-child-shadow-unlinking drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-implement-child-shadow-unlinking
+++ a/drivers/kvm/mmu.c
@@ -402,12 +402,21 @@ static void mmu_page_remove_parent_pte(s
 				break;
 			if (pte_chain->parent_ptes[i] != parent_pte)
 				continue;
-			while (i + 1 < NR_PTE_CHAIN_ENTRIES) {
+			while (i + 1 < NR_PTE_CHAIN_ENTRIES
+				&& pte_chain->parent_ptes[i + 1]) {
 				pte_chain->parent_ptes[i]
 					= pte_chain->parent_ptes[i + 1];
 				++i;
 			}
 			pte_chain->parent_ptes[i] = NULL;
+			if (i == 0) {
+				hlist_del(&pte_chain->link);
+				kfree(pte_chain);
+				if (hlist_empty(&page->parent_ptes)) {
+					page->multimapped = 0;
+					page->parent_pte = NULL;
+				}
+			}
 			return;
 		}
 	BUG();
@@ -481,7 +490,30 @@ static struct kvm_mmu_page *kvm_mmu_get_
 static void kvm_mmu_page_unlink_children(struct kvm_vcpu *vcpu,
 					 struct kvm_mmu_page *page)
 {
-	BUG();
+	unsigned i;
+	u64 *pt;
+	u64 ent;
+
+	pt = __va(page->page_hpa);
+
+	if (page->role.level == PT_PAGE_TABLE_LEVEL) {
+		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
+			if (pt[i] & PT_PRESENT_MASK)
+				rmap_remove(vcpu->kvm, &pt[i]);
+			pt[i] = 0;
+		}
+		return;
+	}
+
+	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
+		ent = pt[i];
+
+		pt[i] = 0;
+		if (!(ent & PT_PRESENT_MASK))
+			continue;
+		ent &= PT64_BASE_ADDR_MASK;
+		mmu_page_remove_parent_pte(page_header(ent), &pt[i]);
+	}
 }
 
 static void kvm_mmu_put_page(struct kvm_vcpu *vcpu,
@@ -489,8 +521,7 @@ static void kvm_mmu_put_page(struct kvm_
 			     u64 *parent_pte)
 {
 	mmu_page_remove_parent_pte(page, parent_pte);
-	if (page->role.level > PT_PAGE_TABLE_LEVEL)
-		kvm_mmu_page_unlink_children(vcpu, page);
+	kvm_mmu_page_unlink_children(vcpu, page);
 	hlist_del(&page->hash_link);
 	list_del(&page->link);
 	list_add(&page->link, &vcpu->free_pages);
@@ -511,6 +542,7 @@ static void kvm_mmu_zap_page(struct kvm_
 					     struct kvm_pte_chain, link);
 			parent_pte = chain->parent_ptes[0];
 		}
+		BUG_ON(!parent_pte);
 		kvm_mmu_put_page(vcpu, page, parent_pte);
 		*parent_pte = 0;
 	}
@@ -530,6 +562,8 @@ static int kvm_mmu_unprotect_page(struct
 	bucket = &vcpu->kvm->mmu_page_hash[index];
 	hlist_for_each_entry_safe(page, node, n, bucket, hash_link)
 		if (page->gfn == gfn && !page->role.metaphysical) {
+			pgprintk("%s: gfn %lx role %x\n", __FUNCTION__, gfn,
+				 page->role.word);
 			kvm_mmu_zap_page(vcpu, page);
 			r = 1;
 		}
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
