From: akpm@osdl.org
Subject: - kvm-mmu-free-pages-on-kvm-destruction.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:56 -0800
Message-ID: <200701070759.l077xu6d013107@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40955 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476AbXAGIAA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:00:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Free pages on kvm destruction
has been removed from the -mm tree.  Its filename was
     kvm-mmu-free-pages-on-kvm-destruction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Free pages on kvm destruction
From: Avi Kivity <avi@qumranet.com>

Because mmu pages have attached rmap and parent pte chain structures, we need
to zap them before freeing so the attached structures are freed.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-free-pages-on-kvm-destruction drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-free-pages-on-kvm-destruction
+++ a/drivers/kvm/mmu.c
@@ -1065,9 +1065,14 @@ EXPORT_SYMBOL_GPL(kvm_mmu_free_some_page
 
 static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
-	while (!list_empty(&vcpu->free_pages)) {
-		struct kvm_mmu_page *page;
+	struct kvm_mmu_page *page;
 
+	while (!list_empty(&vcpu->kvm->active_mmu_pages)) {
+		page = container_of(vcpu->kvm->active_mmu_pages.next,
+				    struct kvm_mmu_page, link);
+		kvm_mmu_zap_page(vcpu, page);
+	}
+	while (!list_empty(&vcpu->free_pages)) {
 		page = list_entry(vcpu->free_pages.next,
 				  struct kvm_mmu_page, link);
 		list_del(&page->link);
_

Patches currently in -mm which might be from avi@qumranet.com are
