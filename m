From: akpm@osdl.org
Subject: - kvm-mmu-remove-release_pt_page_64.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:38 -0800
Message-ID: <200701070759.l077xck0013077@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40913 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431AbXAGH7s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Remove release_pt_page_64()
has been removed from the -mm tree.  Its filename was
     kvm-mmu-remove-release_pt_page_64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Remove release_pt_page_64()
From: Avi Kivity <avi@qumranet.com>

Unused.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c |   29 -----------------------------
 1 file changed, 29 deletions(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-remove-release_pt_page_64 drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-remove-release_pt_page_64
+++ a/drivers/kvm/mmu.c
@@ -609,35 +609,6 @@ hpa_t gva_to_hpa(struct kvm_vcpu *vcpu, 
 	return gpa_to_hpa(vcpu, gpa);
 }
 
-
-static void release_pt_page_64(struct kvm_vcpu *vcpu, hpa_t page_hpa,
-			       int level)
-{
-	u64 *pos;
-	u64 *end;
-
-	ASSERT(vcpu);
-	ASSERT(VALID_PAGE(page_hpa));
-	ASSERT(level <= PT64_ROOT_LEVEL && level > 0);
-
-	for (pos = __va(page_hpa), end = pos + PT64_ENT_PER_PAGE;
-	     pos != end; pos++) {
-		u64 current_ent = *pos;
-
-		if (is_present_pte(current_ent)) {
-			if (level != 1)
-				release_pt_page_64(vcpu,
-						  current_ent &
-						  PT64_BASE_ADDR_MASK,
-						  level - 1);
-			else
-				rmap_remove(vcpu->kvm, pos);
-		}
-		*pos = 0;
-	}
-	kvm_mmu_free_page(vcpu, page_hpa);
-}
-
 static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
_

Patches currently in -mm which might be from avi@qumranet.com are
