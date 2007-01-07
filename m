From: akpm@osdl.org
Subject: - kvm-mmu-teach-the-page-table-walker-to-track-guest-page-table-gfns.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:03 -0800
Message-ID: <200701070759.l077x32o013004@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40826 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbXAGH7K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Teach the page table walker to track guest page table gfns
has been removed from the -mm tree.  Its filename was
     kvm-mmu-teach-the-page-table-walker-to-track-guest-page-table-gfns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Teach the page table walker to track guest page table gfns
From: Avi Kivity <avi@qumranet.com>

Saving the table gfns removes the need to walk the guest and host page tables
in lockstep.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/paging_tmpl.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-teach-the-page-table-walker-to-track-guest-page-table-gfns drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-teach-the-page-table-walker-to-track-guest-page-table-gfns
+++ a/drivers/kvm/paging_tmpl.h
@@ -52,6 +52,7 @@
  */
 struct guest_walker {
 	int level;
+	gfn_t table_gfn;
 	pt_element_t *table;
 	pt_element_t inherited_ar;
 };
@@ -63,8 +64,8 @@ static void FNAME(init_walker)(struct gu
 	struct kvm_memory_slot *slot;
 
 	walker->level = vcpu->mmu.root_level;
-	slot = gfn_to_memslot(vcpu->kvm,
-			      (vcpu->cr3 & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
+	walker->table_gfn = (vcpu->cr3 & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
+	slot = gfn_to_memslot(vcpu->kvm, walker->table_gfn);
 	hpa = safe_gpa_to_hpa(vcpu, vcpu->cr3 & PT64_BASE_ADDR_MASK);
 	walker->table = kmap_atomic(pfn_to_page(hpa >> PAGE_SHIFT), KM_USER0);
 
@@ -133,6 +134,8 @@ static pt_element_t *FNAME(fetch_guest)(
 			return &walker->table[index];
 		if (walker->level != 3 || is_long_mode(vcpu))
 			walker->inherited_ar &= walker->table[index];
+		walker->table_gfn = (walker->table[index] & PT_BASE_ADDR_MASK)
+			>> PAGE_SHIFT;
 		paddr = safe_gpa_to_hpa(vcpu, walker->table[index] & PT_BASE_ADDR_MASK);
 		kunmap_atomic(walker->table, KM_USER0);
 		walker->table = kmap_atomic(pfn_to_page(paddr >> PAGE_SHIFT),
_

Patches currently in -mm which might be from avi@qumranet.com are
