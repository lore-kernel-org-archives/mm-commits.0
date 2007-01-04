From: akpm@osdl.org
Subject: + kvm-mmu-flush-guest-tlb-when-reducing-permissions-on-a-pte.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:12:30 -0800
Message-ID: <200701041912.l04JCUPB028400@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45049 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965100AbXADTMh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:12:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Flush guest tlb when reducing permissions on a pte
has been added to the -mm tree.  Its filename is
     kvm-mmu-flush-guest-tlb-when-reducing-permissions-on-a-pte.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: Flush guest tlb when reducing permissions on a pte
From: Avi Kivity <avi@qumranet.com>

If we reduce permissions on a pte, we must flush the cached copy of the pte
from the guest's tlb.

This is implemented at the moment by flushing the entire guest tlb, and can be
improved by flushing just the relevant virtual address, if it is known.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-flush-guest-tlb-when-reducing-permissions-on-a-pte drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-flush-guest-tlb-when-reducing-permissions-on-a-pte
+++ a/drivers/kvm/mmu.c
@@ -383,6 +383,7 @@ static void rmap_write_protect(struct kv
 		BUG_ON(!(*spte & PT_WRITABLE_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
 		rmap_remove(vcpu, spte);
+		kvm_arch_ops->tlb_flush(vcpu);
 		*spte &= ~(u64)PT_WRITABLE_MASK;
 	}
 }
@@ -594,6 +595,7 @@ static void kvm_mmu_page_unlink_children
 				rmap_remove(vcpu, &pt[i]);
 			pt[i] = 0;
 		}
+		kvm_arch_ops->tlb_flush(vcpu);
 		return;
 	}
 
@@ -927,7 +929,10 @@ static inline void set_pte_common(struct
 			pgprintk("%s: found shadow page for %lx, marking ro\n",
 				 __FUNCTION__, gfn);
 			access_bits &= ~PT_WRITABLE_MASK;
-			*shadow_pte &= ~PT_WRITABLE_MASK;
+			if (is_writeble_pte(*shadow_pte)) {
+				    *shadow_pte &= ~PT_WRITABLE_MASK;
+				    kvm_arch_ops->tlb_flush(vcpu);
+			}
 		}
 	}
 
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
