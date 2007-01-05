From: akpm@osdl.org
Subject: + kvm-initialize-vcpu-kvm-a-little-earlier.patch added to -mm tree
Date: Fri, 05 Jan 2007 01:22:25 -0800
Message-ID: <200701050922.l059MPJP015100@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38483 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965137AbXAEJWh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 04:22:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Initialize vcpu->kvm a little earlier
has been added to the -mm tree.  Its filename is
     kvm-initialize-vcpu-kvm-a-little-earlier.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Initialize vcpu->kvm a little earlier
From: Avi Kivity <avi@qumranet.com>

Fixes oops on early close of /dev/kvm.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/kvm_main.c~kvm-initialize-vcpu-kvm-a-little-earlier drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-initialize-vcpu-kvm-a-little-earlier
+++ a/drivers/kvm/kvm_main.c
@@ -230,6 +230,7 @@ static int kvm_dev_open(struct inode *in
 		struct kvm_vcpu *vcpu = &kvm->vcpus[i];
 
 		mutex_init(&vcpu->mutex);
+		vcpu->kvm = kvm;
 		vcpu->mmu.root_hpa = INVALID_PAGE;
 		INIT_LIST_HEAD(&vcpu->free_pages);
 	}
@@ -530,7 +531,6 @@ static int kvm_dev_ioctl_create_vcpu(str
 	vcpu->guest_fx_image = vcpu->host_fx_image + FX_IMAGE_SIZE;
 
 	vcpu->cpu = -1;  /* First load will set up TR */
-	vcpu->kvm = kvm;
 	r = kvm_arch_ops->vcpu_create(vcpu);
 	if (r < 0)
 		goto out_free_vcpus;
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
kvm-improve-reporting-of-vmwrite-errors.patch
kvm-initialize-vcpu-kvm-a-little-earlier.patch
kvm-avoid-oom-on-cr3-switch.patch
kvm-add-missing-break.patch
kvm-dont-set-guest-cr3-from-vmx_vcpu_setup.patch
kvm-mmu-add-missing-dirty-bit.patch
kvm-make-loading-cr3-more-robust.patch
kvm-simplify-mmu_alloc_roots.patch
kvm-simplify-test-for-interrupt-window.patch
