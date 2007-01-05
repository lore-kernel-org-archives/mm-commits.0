From: akpm@osdl.org
Subject: + kvm-dont-set-guest-cr3-from-vmx_vcpu_setup.patch added to -mm tree
Date: Fri, 05 Jan 2007 01:22:49 -0800
Message-ID: <200701050922.l059MnLH015109@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38501 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965139AbXAEJXB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 04:23:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Don't set guest cr3 from vmx_vcpu_setup()
has been added to the -mm tree.  Its filename is
     kvm-dont-set-guest-cr3-from-vmx_vcpu_setup.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Don't set guest cr3 from vmx_vcpu_setup()
From: Avi Kivity <avi@qumranet.com>

It overwrites the right cr3 set from mmu setup.  Happens only with the test
harness.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/kvm/vmx.c~kvm-dont-set-guest-cr3-from-vmx_vcpu_setup drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-dont-set-guest-cr3-from-vmx_vcpu_setup
+++ a/drivers/kvm/vmx.c
@@ -1027,8 +1027,6 @@ static int vmx_vcpu_setup(struct kvm_vcp
 	vmcs_writel(GUEST_RIP, 0xfff0);
 	vmcs_writel(GUEST_RSP, 0);
 
-	vmcs_writel(GUEST_CR3, 0);
-
 	//todo: dr0 = dr1 = dr2 = dr3 = 0; dr6 = 0xffff0ff0
 	vmcs_writel(GUEST_DR7, 0x400);
 
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
