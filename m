From: akpm@osdl.org
Subject: - kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:11 -0800
Message-ID: <200701070759.l077xBCM013016@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40845 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456AbXAGH7S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Use the guest pdptrs instead of mapping cr3 in pae mode
has been removed from the -mm tree.  Its filename was
     kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Use the guest pdptrs instead of mapping cr3 in pae mode
From: Avi Kivity <avi@qumranet.com>

This lets us not write protect a partial page, and is anyway what a real
processor does.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c    |    2 ++
 drivers/kvm/paging_tmpl.h |   28 ++++++++++++++++++----------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode
+++ a/drivers/kvm/kvm_main.c
@@ -1491,6 +1491,8 @@ static int kvm_dev_ioctl_set_sregs(struc
 
 	mmu_reset_needed |= vcpu->cr4 != sregs->cr4;
 	kvm_arch_ops->set_cr4(vcpu, sregs->cr4);
+	if (!is_long_mode(vcpu) && is_pae(vcpu))
+		load_pdptrs(vcpu, vcpu->cr3);
 
 	if (mmu_reset_needed)
 		kvm_mmu_reset_context(vcpu);
diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode
+++ a/drivers/kvm/paging_tmpl.h
@@ -67,18 +67,28 @@ static void FNAME(walk_addr)(struct gues
 	hpa_t hpa;
 	struct kvm_memory_slot *slot;
 	pt_element_t *ptep;
+	pt_element_t root;
 
 	walker->level = vcpu->mmu.root_level;
-	walker->table_gfn = (vcpu->cr3 & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
+	walker->table = NULL;
+	root = vcpu->cr3;
+#if PTTYPE == 64
+	if (!is_long_mode(vcpu)) {
+		walker->ptep = &vcpu->pdptrs[(addr >> 30) & 3];
+		root = *walker->ptep;
+		if (!(root & PT_PRESENT_MASK))
+			return;
+		--walker->level;
+	}
+#endif
+	walker->table_gfn = (root & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 	slot = gfn_to_memslot(vcpu->kvm, walker->table_gfn);
-	hpa = safe_gpa_to_hpa(vcpu, vcpu->cr3 & PT64_BASE_ADDR_MASK);
+	hpa = safe_gpa_to_hpa(vcpu, root & PT64_BASE_ADDR_MASK);
 	walker->table = kmap_atomic(pfn_to_page(hpa >> PAGE_SHIFT), KM_USER0);
 
 	ASSERT((!is_long_mode(vcpu) && is_pae(vcpu)) ||
 	       (vcpu->cr3 & ~(PAGE_MASK | CR3_FLAGS_MASK)) == 0);
 
-	walker->table = (pt_element_t *)( (unsigned long)walker->table |
-		(unsigned long)(vcpu->cr3 & ~(PAGE_MASK | CR3_FLAGS_MASK)) );
 	walker->inherited_ar = PT_USER_MASK | PT_WRITABLE_MASK;
 
 	for (;;) {
@@ -89,11 +99,8 @@ static void FNAME(walk_addr)(struct gues
 		ASSERT(((unsigned long)walker->table & PAGE_MASK) ==
 		       ((unsigned long)ptep & PAGE_MASK));
 
-		/* Don't set accessed bit on PAE PDPTRs */
-		if (vcpu->mmu.root_level != 3 || walker->level != 3)
-			if ((*ptep & (PT_PRESENT_MASK | PT_ACCESSED_MASK))
-			    == PT_PRESENT_MASK)
-				*ptep |= PT_ACCESSED_MASK;
+		if (is_present_pte(*ptep) && !(*ptep &  PT_ACCESSED_MASK))
+			*ptep |= PT_ACCESSED_MASK;
 
 		if (!is_present_pte(*ptep) ||
 		    walker->level == PT_PAGE_TABLE_LEVEL ||
@@ -116,7 +123,8 @@ static void FNAME(walk_addr)(struct gues
 
 static void FNAME(release_walker)(struct guest_walker *walker)
 {
-	kunmap_atomic(walker->table, KM_USER0);
+	if (walker->table)
+		kunmap_atomic(walker->table, KM_USER0);
 }
 
 static void FNAME(set_pte)(struct kvm_vcpu *vcpu, u64 guest_pte,
_

Patches currently in -mm which might be from avi@qumranet.com are
