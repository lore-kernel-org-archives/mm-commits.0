From: akpm@osdl.org
Subject: - kvm-mmu-never-free-a-shadow-page-actively-serving-as-a-root.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:50 -0800
Message-ID: <200701070759.l077xoNP013096@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40934 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932475AbXAGH7z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Never free a shadow page actively serving as a root
has been removed from the -mm tree.  Its filename was
     kvm-mmu-never-free-a-shadow-page-actively-serving-as-a-root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
