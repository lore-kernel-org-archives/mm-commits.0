From: akpm@osdl.org
Subject: - kvm-mmu-kvm_mmu_put_page-only-removes-one-link-to-the-page.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:32 -0800
Message-ID: <200701070759.l077xWxJ013068@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40885 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461AbXAGH7h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: kvm_mmu_put_page() only removes one link to the page
has been removed from the -mm tree.  Its filename was
     kvm-mmu-kvm_mmu_put_page-only-removes-one-link-to-the-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: kvm_mmu_put_page() only removes one link to the page
From: Avi Kivity <avi@qumranet.com>

...  and so must not free it unconditionally.

Move the freeing to kvm_mmu_zap_page().

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-kvm_mmu_put_page-only-removes-one-link-to-the-page drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-kvm_mmu_put_page-only-removes-one-link-to-the-page
+++ a/drivers/kvm/mmu.c
@@ -521,10 +521,6 @@ static void kvm_mmu_put_page(struct kvm_
 			     u64 *parent_pte)
 {
 	mmu_page_remove_parent_pte(page, parent_pte);
-	kvm_mmu_page_unlink_children(vcpu, page);
-	hlist_del(&page->hash_link);
-	list_del(&page->link);
-	list_add(&page->link, &vcpu->free_pages);
 }
 
 static void kvm_mmu_zap_page(struct kvm_vcpu *vcpu,
@@ -546,6 +542,10 @@ static void kvm_mmu_zap_page(struct kvm_
 		kvm_mmu_put_page(vcpu, page, parent_pte);
 		*parent_pte = 0;
 	}
+	kvm_mmu_page_unlink_children(vcpu, page);
+	hlist_del(&page->hash_link);
+	list_del(&page->link);
+	list_add(&page->link, &vcpu->free_pages);
 }
 
 static int kvm_mmu_unprotect_page(struct kvm_vcpu *vcpu, gfn_t gfn)
_

Patches currently in -mm which might be from avi@qumranet.com are
