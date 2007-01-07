From: akpm@osdl.org
Subject: - kvm-mmu-make-the-shadow-page-tables-also-special-case-pae.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:13 -0800
Message-ID: <200701070759.l077xDCs013019@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40848 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458AbXAGH7V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Make the shadow page tables also special-case pae
has been removed from the -mm tree.  Its filename was
     kvm-mmu-make-the-shadow-page-tables-also-special-case-pae.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Make the shadow page tables also special-case pae
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/paging_tmpl.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-make-the-shadow-page-tables-also-special-case-pae drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-make-the-shadow-page-tables-also-special-case-pae
+++ a/drivers/kvm/paging_tmpl.h
@@ -170,6 +170,11 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 
 	shadow_addr = vcpu->mmu.root_hpa;
 	level = vcpu->mmu.shadow_root_level;
+	if (level == PT32E_ROOT_LEVEL) {
+		shadow_addr = vcpu->mmu.pae_root[(addr >> 30) & 3];
+		shadow_addr &= PT64_BASE_ADDR_MASK;
+		--level;
+	}
 
 	for (; ; level--) {
 		u32 index = SHADOW_PT_INDEX(addr, level);
@@ -202,10 +207,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 		shadow_addr = kvm_mmu_alloc_page(vcpu, shadow_ent);
 		if (!VALID_PAGE(shadow_addr))
 			return ERR_PTR(-ENOMEM);
-		shadow_pte = shadow_addr | PT_PRESENT_MASK;
-		if (vcpu->mmu.root_level > 3 || level != 3)
-			shadow_pte |= PT_ACCESSED_MASK
-				| PT_WRITABLE_MASK | PT_USER_MASK;
+		shadow_pte = shadow_addr | PT_PRESENT_MASK | PT_ACCESSED_MASK
+			| PT_WRITABLE_MASK | PT_USER_MASK;
 		*shadow_ent = shadow_pte;
 		prev_shadow_ent = shadow_ent;
 	}
_

Patches currently in -mm which might be from avi@qumranet.com are
