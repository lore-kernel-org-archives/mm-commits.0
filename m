From: akpm@osdl.org
Subject: - kvm-mmu-implement-child-shadow-unlinking.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:30 -0800
Message-ID: <200701070759.l077xUxN013060@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40883 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932460AbXAGH7f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Implement child shadow unlinking
has been removed from the -mm tree.  Its filename was
     kvm-mmu-implement-child-shadow-unlinking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 38 insertions(+), 4 deletions(-)

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
