From: akpm@osdl.org
Subject: + kvm-mmu-load-the-pae-pdptrs-on-cr3-change-like-the-processor-does.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:11:34 -0800
Message-ID: <200701041911.l04JBYQ8028281@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44925 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030184AbXADTL6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:11:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Load the pae pdptrs on cr3 change like the processor does
has been added to the -mm tree.  Its filename is
     kvm-mmu-load-the-pae-pdptrs-on-cr3-change-like-the-processor-does.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: Load the pae pdptrs on cr3 change like the processor does
From: Avi Kivity <avi@qumranet.com>

In pae mode, a load of cr3 loads the four third-level page table entries in
addition to cr3 itself.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   29 +++++++++++++++++++----------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-mmu-load-the-pae-pdptrs-on-cr3-change-like-the-processor-does drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-mmu-load-the-pae-pdptrs-on-cr3-change-like-the-processor-does
+++ a/drivers/kvm/kvm.h
@@ -185,6 +185,7 @@ struct kvm_vcpu {
 	unsigned long cr3;
 	unsigned long cr4;
 	unsigned long cr8;
+	u64 pdptrs[4]; /* pae */
 	u64 shadow_efer;
 	u64 apic_base;
 	int nmsrs;
diff -puN drivers/kvm/kvm_main.c~kvm-mmu-load-the-pae-pdptrs-on-cr3-change-like-the-processor-does drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-mmu-load-the-pae-pdptrs-on-cr3-change-like-the-processor-does
+++ a/drivers/kvm/kvm_main.c
@@ -298,14 +298,17 @@ static void inject_gp(struct kvm_vcpu *v
 	kvm_arch_ops->inject_gp(vcpu, 0);
 }
 
-static int pdptrs_have_reserved_bits_set(struct kvm_vcpu *vcpu,
-					 unsigned long cr3)
+/*
+ * Load the pae pdptrs.  Return true is they are all valid.
+ */
+static int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	gfn_t pdpt_gfn = cr3 >> PAGE_SHIFT;
-	unsigned offset = (cr3 & (PAGE_SIZE-1)) >> 5;
+	unsigned offset = ((cr3 & (PAGE_SIZE-1)) >> 5) << 2;
 	int i;
 	u64 pdpte;
 	u64 *pdpt;
+	int ret;
 	struct kvm_memory_slot *memslot;
 
 	spin_lock(&vcpu->kvm->lock);
@@ -313,16 +316,23 @@ static int pdptrs_have_reserved_bits_set
 	/* FIXME: !memslot - emulate? 0xff? */
 	pdpt = kmap_atomic(gfn_to_page(memslot, pdpt_gfn), KM_USER0);
 
+	ret = 1;
 	for (i = 0; i < 4; ++i) {
 		pdpte = pdpt[offset + i];
-		if ((pdpte & 1) && (pdpte & 0xfffffff0000001e6ull))
-			break;
+		if ((pdpte & 1) && (pdpte & 0xfffffff0000001e6ull)) {
+			ret = 0;
+			goto out;
+		}
 	}
 
+	for (i = 0; i < 4; ++i)
+		vcpu->pdptrs[i] = pdpt[offset + i];
+
+out:
 	kunmap_atomic(pdpt, KM_USER0);
 	spin_unlock(&vcpu->kvm->lock);
 
-	return i != 4;
+	return ret;
 }
 
 void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
@@ -368,8 +378,7 @@ void set_cr0(struct kvm_vcpu *vcpu, unsi
 			}
 		} else
 #endif
-		if (is_pae(vcpu) &&
-			    pdptrs_have_reserved_bits_set(vcpu, vcpu->cr3)) {
+		if (is_pae(vcpu) && !load_pdptrs(vcpu, vcpu->cr3)) {
 			printk(KERN_DEBUG "set_cr0: #GP, pdptrs "
 			       "reserved bits\n");
 			inject_gp(vcpu);
@@ -411,7 +420,7 @@ void set_cr4(struct kvm_vcpu *vcpu, unsi
 			return;
 		}
 	} else if (is_paging(vcpu) && !is_pae(vcpu) && (cr4 & CR4_PAE_MASK)
-		   && pdptrs_have_reserved_bits_set(vcpu, vcpu->cr3)) {
+		   && !load_pdptrs(vcpu, vcpu->cr3)) {
 		printk(KERN_DEBUG "set_cr4: #GP, pdptrs reserved bits\n");
 		inject_gp(vcpu);
 	}
@@ -443,7 +452,7 @@ void set_cr3(struct kvm_vcpu *vcpu, unsi
 			return;
 		}
 		if (is_paging(vcpu) && is_pae(vcpu) &&
-		    pdptrs_have_reserved_bits_set(vcpu, cr3)) {
+		    !load_pdptrs(vcpu, cr3)) {
 			printk(KERN_DEBUG "set_cr3: #GP, pdptrs "
 			       "reserved bits\n");
 			inject_gp(vcpu);
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
