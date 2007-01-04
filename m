From: akpm@osdl.org
Subject: + kvm-mmu-page-table-write-flood-protection.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:12:16 -0800
Message-ID: <200701041912.l04JCGgn028374@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:45018 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030186AbXADTMY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:12:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Page table write flood protection
has been added to the -mm tree.  Its filename is
     kvm-mmu-page-table-write-flood-protection.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kvm-fix-gfp_kernel-alloc-in-atomic-section-bug.patch
kvm-use-raw_smp_processor_id-instead-of-smp_processor_id-where-applicable.patch
kvm-recover-after-an-arch-module-load-failure.patch
kvm-improve-interrupt-response.patch
kvm-prevent-stale-bits-in-cr0-and-cr4.patch
kvm-mmu-implement-simple-reverse-mapping.patch
kvm-mmu-teach-the-page-table-walker-to-track-guest-page-table-gfns.patch
kvm-mmu-load-the-pae-pdptrs-on-cr3-change-like-the-processor-does.patch
kvm-mmu-fold-fetch_guest-into-init_walker.patch
kvm-mu-special-treatment-for-shadow-pae-root-pages.patch
kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode.patch
kvm-mmu-make-the-shadow-page-tables-also-special-case-pae.patch
kvm-mmu-make-kvm_mmu_alloc_page-return-a-kvm_mmu_page-pointer.patch
kvm-mmu-shadow-page-table-caching.patch
kvm-mmu-write-protect-guest-pages-when-a-shadow-is-created-for-them.patch
kvm-mmu-let-the-walker-extract-the-target-page-gfn-from-the-pte.patch
kvm-mmu-support-emulated-writes-into-ram.patch
kvm-mmu-zap-shadow-page-table-entries-on-writes-to-guest-page-tables.patch
kvm-mmu-if-emulating-an-instruction-fails-try-unprotecting-the-page.patch
kvm-mmu-implement-child-shadow-unlinking.patch
kvm-mmu-kvm_mmu_put_page-only-removes-one-link-to-the-page.patch
kvm-mmu-oom-handling.patch
kvm-mmu-remove-invlpg-interception.patch
kvm-mmu-remove-release_pt_page_64.patch
kvm-mmu-handle-misaligned-accesses-to-write-protected-guest-page-tables.patch
kvm-mmu-ove-is_empty_shadow_page-above-kvm_mmu_free_page.patch
kvm-mmu-ensure-freed-shadow-pages-are-clean.patch
kvm-mmu-if-an-empty-shadow-page-is-not-empty-report-more-info.patch
kvm-mmu-page-table-write-flood-protection.patch
kvm-mmu-never-free-a-shadow-page-actively-serving-as-a-root.patch
kvm-mmu-fix-cmpxchg8b-emulation.patch
kvm-mmu-treat-user-mode-faults-as-a-hint-that-a-page-is-no-longer-a-page-table.patch
kvm-mmu-free-pages-on-kvm-destruction.patch
kvm-mmu-replace-atomic-allocations-by-preallocated-objects.patch
kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace.patch
kvm-mmu-flush-guest-tlb-when-reducing-permissions-on-a-pte.patch
kvm-mmu-destroy-mmu-while-we-still-have-a-vcpu-left.patch
kvm-mmu-add-audit-code-to-check-mappings-etc-are-correct.patch
