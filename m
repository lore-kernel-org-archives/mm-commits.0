From: akpm@linux-foundation.org
Subject: - kvm-mmu-add-missing-dirty-page-tracking-cases.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:54:28 -0800
Message-ID: <200702282354.l1SNsSuN031195@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48489 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719AbXB1Xyc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:54:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: mmu: add missing dirty page tracking cases
has been removed from the -mm tree.  Its filename was
     kvm-mmu-add-missing-dirty-page-tracking-cases.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: mmu: add missing dirty page tracking cases
From: Avi Kivity <avi@qumranet.com>

We fail to mark a page dirty in three cases:

- setting the accessed bit in a pte
- setting the dirty bit in a pte
- emulating a write into a pagetable

This fix adds the missing cases.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/paging_tmpl.h |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-add-missing-dirty-page-tracking-cases drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-add-missing-dirty-page-tracking-cases
+++ a/drivers/kvm/paging_tmpl.h
@@ -128,8 +128,10 @@ static int FNAME(walk_addr)(struct guest
 			goto access_error;
 #endif
 
-		if (!(*ptep & PT_ACCESSED_MASK))
-			*ptep |= PT_ACCESSED_MASK; 	/* avoid rmw */
+		if (!(*ptep & PT_ACCESSED_MASK)) {
+			mark_page_dirty(vcpu->kvm, table_gfn);
+			*ptep |= PT_ACCESSED_MASK;
+		}
 
 		if (walker->level == PT_PAGE_TABLE_LEVEL) {
 			walker->gfn = (*ptep & PT_BASE_ADDR_MASK)
@@ -185,6 +187,12 @@ static void FNAME(release_walker)(struct
 		kunmap_atomic(walker->table, KM_USER0);
 }
 
+static void FNAME(mark_pagetable_dirty)(struct kvm *kvm,
+					struct guest_walker *walker)
+{
+	mark_page_dirty(kvm, walker->table_gfn[walker->level - 1]);
+}
+
 static void FNAME(set_pte)(struct kvm_vcpu *vcpu, u64 guest_pte,
 			   u64 *shadow_pte, u64 access_bits, gfn_t gfn)
 {
@@ -348,12 +356,15 @@ static int FNAME(fix_write_pf)(struct kv
 	} else if (kvm_mmu_lookup_page(vcpu, gfn)) {
 		pgprintk("%s: found shadow page for %lx, marking ro\n",
 			 __FUNCTION__, gfn);
+		mark_page_dirty(vcpu->kvm, gfn);
+		FNAME(mark_pagetable_dirty)(vcpu->kvm, walker);
 		*guest_ent |= PT_DIRTY_MASK;
 		*write_pt = 1;
 		return 0;
 	}
 	mark_page_dirty(vcpu->kvm, gfn);
 	*shadow_ent |= PT_WRITABLE_MASK;
+	FNAME(mark_pagetable_dirty)(vcpu->kvm, walker);
 	*guest_ent |= PT_DIRTY_MASK;
 	rmap_add(vcpu, shadow_ent);
 
_

Patches currently in -mm which might be from avi@qumranet.com are

git-kvm.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
