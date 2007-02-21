From: akpm@linux-foundation.org
Subject: + kvm-mmu-add-missing-dirty-page-tracking-cases.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:49:29 -0800
Message-ID: <200702212049.l1LKnTLe025444@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44094 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161195AbXBUUtb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:49:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: mmu: add missing dirty page tracking cases
has been added to the -mm tree.  Its filename is
     kvm-mmu-add-missing-dirty-page-tracking-cases.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kvm-mmu-add-missing-dirty-page-tracking-cases.patch
kvm-move-virtualization-deactivation-from-cpu_dead.patch
kvm-cosmetics.patch
kvm-vmx-hack-set_cr0_no_modeswitch-to-actually-do.patch
kvm-use-array_size-macro-instead-of-manual-calculation.patch
kvm-use-page_private-set_page_private-apis.patch
kvm-add-msr-based-hypercall-api.patch
kvm-add-host-hypercall-support-for-vmx.patch
kvm-add-hypercall-host-support-for-svm.patch
kvm-wire-up-hypercall-handlers-to-a-central.patch
kvm-svm-init-cr0-with-the-wp-bit-set.patch
kvm-svm-intercept-smi-to-handle-it-at-host-level.patch
kvm-more-0-null-conversions.patch
