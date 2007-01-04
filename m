From: akpm@osdl.org
Subject: + kvm-mmu-make-kvm_mmu_alloc_page-return-a-kvm_mmu_page-pointer.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:11:44 -0800
Message-ID: <200701041911.l04JBi6Y028302@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:44922 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030186AbXADTLz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:11:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Make kvm_mmu_alloc_page() return a kvm_mmu_page pointer
has been added to the -mm tree.  Its filename is
     kvm-mmu-make-kvm_mmu_alloc_page-return-a-kvm_mmu_page-pointer.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: Make kvm_mmu_alloc_page() return a kvm_mmu_page pointer
From: Avi Kivity <avi@qumranet.com>

This allows further manipulation on the shadow page table.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c         |   24 +++++++++++-------------
 drivers/kvm/paging_tmpl.h |    6 ++++--
 2 files changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-make-kvm_mmu_alloc_page-return-a-kvm_mmu_page-pointer drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-make-kvm_mmu_alloc_page-return-a-kvm_mmu_page-pointer
+++ a/drivers/kvm/mmu.c
@@ -292,12 +292,13 @@ static int is_empty_shadow_page(hpa_t pa
 	return 1;
 }
 
-static hpa_t kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, u64 *parent_pte)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
+					       u64 *parent_pte)
 {
 	struct kvm_mmu_page *page;
 
 	if (list_empty(&vcpu->free_pages))
-		return INVALID_PAGE;
+		return NULL;
 
 	page = list_entry(vcpu->free_pages.next, struct kvm_mmu_page, link);
 	list_del(&page->link);
@@ -306,7 +307,7 @@ static hpa_t kvm_mmu_alloc_page(struct k
 	page->slot_bitmap = 0;
 	page->global = 1;
 	page->parent_pte = parent_pte;
-	return page->page_hpa;
+	return page;
 }
 
 static void page_header_update_slot(struct kvm *kvm, void *pte, gpa_t gpa)
@@ -402,19 +403,16 @@ static int nonpaging_map(struct kvm_vcpu
 		}
 
 		if (table[index] == 0) {
-			hpa_t new_table = kvm_mmu_alloc_page(vcpu,
-							     &table[index]);
+			struct kvm_mmu_page *new_table;
 
-			if (!VALID_PAGE(new_table)) {
+			new_table = kvm_mmu_alloc_page(vcpu, &table[index]);
+			if (!new_table) {
 				pgprintk("nonpaging_map: ENOMEM\n");
 				return -ENOMEM;
 			}
 
-			if (level == PT32E_ROOT_LEVEL)
-				table[index] = new_table | PT_PRESENT_MASK;
-			else
-				table[index] = new_table | PT_PRESENT_MASK |
-						PT_WRITABLE_MASK | PT_USER_MASK;
+			table[index] = new_table->page_hpa | PT_PRESENT_MASK
+				| PT_WRITABLE_MASK | PT_USER_MASK;
 		}
 		table_addr = table[index] & PT64_BASE_ADDR_MASK;
 	}
@@ -454,7 +452,7 @@ static void mmu_alloc_roots(struct kvm_v
 		hpa_t root = vcpu->mmu.root_hpa;
 
 		ASSERT(!VALID_PAGE(root));
-		root = kvm_mmu_alloc_page(vcpu, NULL);
+		root = kvm_mmu_alloc_page(vcpu, NULL)->page_hpa;
 		vcpu->mmu.root_hpa = root;
 		return;
 	}
@@ -463,7 +461,7 @@ static void mmu_alloc_roots(struct kvm_v
 		hpa_t root = vcpu->mmu.pae_root[i];
 
 		ASSERT(!VALID_PAGE(root));
-		root = kvm_mmu_alloc_page(vcpu, NULL);
+		root = kvm_mmu_alloc_page(vcpu, NULL)->page_hpa;
 		vcpu->mmu.pae_root[i] = root | PT_PRESENT_MASK;
 	}
 	vcpu->mmu.root_hpa = __pa(vcpu->mmu.pae_root);
diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-make-kvm_mmu_alloc_page-return-a-kvm_mmu_page-pointer drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-make-kvm_mmu_alloc_page-return-a-kvm_mmu_page-pointer
+++ a/drivers/kvm/paging_tmpl.h
@@ -179,6 +179,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 	for (; ; level--) {
 		u32 index = SHADOW_PT_INDEX(addr, level);
 		u64 *shadow_ent = ((u64 *)__va(shadow_addr)) + index;
+		struct kvm_mmu_page *shadow_page;
 		u64 shadow_pte;
 
 		if (is_present_pte(*shadow_ent) || is_io_pte(*shadow_ent)) {
@@ -204,9 +205,10 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 			return shadow_ent;
 		}
 
-		shadow_addr = kvm_mmu_alloc_page(vcpu, shadow_ent);
-		if (!VALID_PAGE(shadow_addr))
+		shadow_page = kvm_mmu_alloc_page(vcpu, shadow_ent);
+		if (!shadow_page)
 			return ERR_PTR(-ENOMEM);
+		shadow_addr = shadow_page->page_hpa;
 		shadow_pte = shadow_addr | PT_PRESENT_MASK | PT_ACCESSED_MASK
 			| PT_WRITABLE_MASK | PT_USER_MASK;
 		*shadow_ent = shadow_pte;
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
