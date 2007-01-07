From: akpm@osdl.org
Subject: - kvm-mmu-page-table-write-flood-protection.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:48 -0800
Message-ID: <200701070759.l077xmup013092@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40930 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468AbXAGH7x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Page table write flood protection
has been removed from the -mm tree.  Its filename was
     kvm-mmu-page-table-write-flood-protection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Page table write flood protection
From: Avi Kivity <avi@qumranet.com>

In fork() (or when we protect a page that is no longer a page table), we can
experience floods of writes to a page, which have to be emulated.  This is
expensive.

So, if we detect such a flood, zap the page so subsequent writes can proceed
natively.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h |    3 +++
 drivers/kvm/mmu.c |   16 +++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/kvm.h~kvm-mmu-page-table-write-flood-protection drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-mmu-page-table-write-flood-protection
+++ a/drivers/kvm/kvm.h
@@ -238,6 +238,9 @@ struct kvm_vcpu {
 	struct kvm_mmu_page page_header_buf[KVM_NUM_MMU_PAGES];
 	struct kvm_mmu mmu;
 
+	gfn_t last_pt_write_gfn;
+	int   last_pt_write_count;
+
 	struct kvm_guest_debug guest_debug;
 
 	char fx_buf[FX_BUF_SIZE];
diff -puN drivers/kvm/mmu.c~kvm-mmu-page-table-write-flood-protection drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-page-table-write-flood-protection
+++ a/drivers/kvm/mmu.c
@@ -969,8 +969,17 @@ void kvm_mmu_pre_write(struct kvm_vcpu *
 	unsigned page_offset;
 	unsigned misaligned;
 	int level;
+	int flooded = 0;
 
 	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
+	if (gfn == vcpu->last_pt_write_gfn) {
+		++vcpu->last_pt_write_count;
+		if (vcpu->last_pt_write_count >= 3)
+			flooded = 1;
+	} else {
+		vcpu->last_pt_write_gfn = gfn;
+		vcpu->last_pt_write_count = 1;
+	}
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
 	bucket = &vcpu->kvm->mmu_page_hash[index];
 	hlist_for_each_entry_safe(page, node, n, bucket, hash_link) {
@@ -978,11 +987,16 @@ void kvm_mmu_pre_write(struct kvm_vcpu *
 			continue;
 		pte_size = page->role.glevels == PT32_ROOT_LEVEL ? 4 : 8;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
-		if (misaligned) {
+		if (misaligned || flooded) {
 			/*
 			 * Misaligned accesses are too much trouble to fix
 			 * up; also, they usually indicate a page is not used
 			 * as a page table.
+			 *
+			 * If we're seeing too many writes to a page,
+			 * it may no longer be a page table, or we may be
+			 * forking, in which case it is better to unmap the
+			 * page.
 			 */
 			pgprintk("misaligned: gpa %llx bytes %d role %x\n",
 				 gpa, bytes, page->role.word);
_

Patches currently in -mm which might be from avi@qumranet.com are
