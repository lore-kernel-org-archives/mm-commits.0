From: akpm@osdl.org
Subject: - kvm-mmu-zap-shadow-page-table-entries-on-writes-to-guest-page-tables.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:26 -0800
Message-ID: <200701070759.l077xQAK013054@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40875 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932460AbXAGH7c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Zap shadow page table entries on writes to guest page tables
has been removed from the -mm tree.  Its filename was
     kvm-mmu-zap-shadow-page-table-entries-on-writes-to-guest-page-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Zap shadow page table entries on writes to guest page tables
From: Avi Kivity <avi@qumranet.com>

Iterate over all shadow pages which correspond to a the given guest page table
and remove the mappings.

A subsequent page fault will reestablish the new mapping.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff -puN drivers/kvm/mmu.c~kvm-mmu-zap-shadow-page-table-entries-on-writes-to-guest-page-tables drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-zap-shadow-page-table-entries-on-writes-to-guest-page-tables
+++ a/drivers/kvm/mmu.c
@@ -958,7 +958,43 @@ int kvm_mmu_reset_context(struct kvm_vcp
 
 void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
 {
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *child;
+	struct hlist_node *node;
+	struct hlist_head *bucket;
+	unsigned index;
+	u64 *spte;
+	u64 pte;
+	unsigned offset = offset_in_page(gpa);
+	unsigned page_offset;
+	int level;
+
 	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
+	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
+	bucket = &vcpu->kvm->mmu_page_hash[index];
+	hlist_for_each_entry(page, node, bucket, hash_link) {
+		if (page->gfn != gfn || page->role.metaphysical)
+			continue;
+		page_offset = offset;
+		level = page->role.level;
+		if (page->role.glevels == PT32_ROOT_LEVEL) {
+			page_offset <<= 1;          /* 32->64 */
+			page_offset &= ~PAGE_MASK;
+		}
+		spte = __va(page->page_hpa);
+		spte += page_offset / sizeof(*spte);
+		pte = *spte;
+		if (is_present_pte(pte)) {
+			if (level == PT_PAGE_TABLE_LEVEL)
+				rmap_remove(vcpu->kvm, spte);
+			else {
+				child = page_header(pte & PT64_BASE_ADDR_MASK);
+				mmu_page_remove_parent_pte(child, spte);
+			}
+		}
+		*spte = 0;
+	}
 }
 
 void kvm_mmu_post_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
_

Patches currently in -mm which might be from avi@qumranet.com are
