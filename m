From: akpm@osdl.org
Subject: - kvm-mmu-ove-is_empty_shadow_page-above-kvm_mmu_free_page.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:42 -0800
Message-ID: <200701070759.l077xgFF013083@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40908 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932471AbXAGH7q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: <ove is_empty_shadow_page() above kvm_mmu_free_page()
has been removed from the -mm tree.  Its filename was
     kvm-mmu-ove-is_empty_shadow_page-above-kvm_mmu_free_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: <ove is_empty_shadow_page() above kvm_mmu_free_page()
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-ove-is_empty_shadow_page-above-kvm_mmu_free_page drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-ove-is_empty_shadow_page-above-kvm_mmu_free_page
+++ a/drivers/kvm/mmu.c
@@ -303,16 +303,6 @@ static void rmap_write_protect(struct kv
 	}
 }
 
-static void kvm_mmu_free_page(struct kvm_vcpu *vcpu, hpa_t page_hpa)
-{
-	struct kvm_mmu_page *page_head = page_header(page_hpa);
-
-	list_del(&page_head->link);
-	page_head->page_hpa = page_hpa;
-	list_add(&page_head->link, &vcpu->free_pages);
-	++vcpu->kvm->n_free_mmu_pages;
-}
-
 static int is_empty_shadow_page(hpa_t page_hpa)
 {
 	u32 *pos;
@@ -324,6 +314,16 @@ static int is_empty_shadow_page(hpa_t pa
 	return 1;
 }
 
+static void kvm_mmu_free_page(struct kvm_vcpu *vcpu, hpa_t page_hpa)
+{
+	struct kvm_mmu_page *page_head = page_header(page_hpa);
+
+	list_del(&page_head->link);
+	page_head->page_hpa = page_hpa;
+	list_add(&page_head->link, &vcpu->free_pages);
+	++vcpu->kvm->n_free_mmu_pages;
+}
+
 static unsigned kvm_page_table_hashfn(gfn_t gfn)
 {
 	return gfn;
_

Patches currently in -mm which might be from avi@qumranet.com are
