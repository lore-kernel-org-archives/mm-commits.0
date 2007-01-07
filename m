From: akpm@osdl.org
Subject: - kvm-mmu-handle-misaligned-accesses-to-write-protected-guest-page-tables.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:40 -0800
Message-ID: <200701070759.l077xefc013080@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40900 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466AbXAGH7o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Handle misaligned accesses to write protected guest page tables
has been removed from the -mm tree.  Its filename was
     kvm-mmu-handle-misaligned-accesses-to-write-protected-guest-page-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Handle misaligned accesses to write protected guest page tables
From: Avi Kivity <avi@qumranet.com>

A misaligned access affects two shadow ptes instead of just one.

Since a misaligned access is unlikely to occur on a real page table, just zap
the page out of existence, avoiding further trouble.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-handle-misaligned-accesses-to-write-protected-guest-page-tables drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-handle-misaligned-accesses-to-write-protected-guest-page-tables
+++ a/drivers/kvm/mmu.c
@@ -954,21 +954,36 @@ void kvm_mmu_pre_write(struct kvm_vcpu *
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm_mmu_page *page;
 	struct kvm_mmu_page *child;
-	struct hlist_node *node;
+	struct hlist_node *node, *n;
 	struct hlist_head *bucket;
 	unsigned index;
 	u64 *spte;
 	u64 pte;
 	unsigned offset = offset_in_page(gpa);
+	unsigned pte_size;
 	unsigned page_offset;
+	unsigned misaligned;
 	int level;
 
 	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
 	bucket = &vcpu->kvm->mmu_page_hash[index];
-	hlist_for_each_entry(page, node, bucket, hash_link) {
+	hlist_for_each_entry_safe(page, node, n, bucket, hash_link) {
 		if (page->gfn != gfn || page->role.metaphysical)
 			continue;
+		pte_size = page->role.glevels == PT32_ROOT_LEVEL ? 4 : 8;
+		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
+		if (misaligned) {
+			/*
+			 * Misaligned accesses are too much trouble to fix
+			 * up; also, they usually indicate a page is not used
+			 * as a page table.
+			 */
+			pgprintk("misaligned: gpa %llx bytes %d role %x\n",
+				 gpa, bytes, page->role.word);
+			kvm_mmu_zap_page(vcpu, page);
+			continue;
+		}
 		page_offset = offset;
 		level = page->role.level;
 		if (page->role.glevels == PT32_ROOT_LEVEL) {
_

Patches currently in -mm which might be from avi@qumranet.com are
