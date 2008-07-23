From: akpm@linux-foundation.org
Subject: - hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-align-faulting-address-to-a-hugepage-boundary-before-unmapping.patch removed from -mm tree
Date: Wed, 23 Jul 2008 15:58:13 -0700
Message-ID: <200807232310.m6NNApK2016880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754398AbYGWXLK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:11:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, agl@us.ibm.com, apw@shadowen.org, hugh@veritas.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     Align faulting address to a hugepage boundary before unmapping
has been removed from the -mm tree.  Its filename was
     hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-align-faulting-address-to-a-hugepage-boundary-before-unmapping.patch

This patch was dropped because it was folded into hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Align faulting address to a hugepage boundary before unmapping
From: Mel Gorman <mel@csn.ul.ie>

When taking a fault for COW on a private mapping it is possible that the
parent will have to steal the original page from its children due to an
insufficient hugepage pool.  In this case, unmap_ref_private() is called
for the faulting address to unmap via unmap_hugepage_range(). This patch
ensures that the address used for unmapping is hugepage-aligned.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/hugetlb.c~hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-align-faulting-address-to-a-hugepage-boundary-before-unmapping mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-align-faulting-address-to-a-hugepage-boundary-before-unmapping
+++ a/mm/hugetlb.c
@@ -1042,6 +1042,7 @@ int unmap_ref_private(struct mm_struct *
 	 * vm_pgoff is in PAGE_SIZE units, hence the different calculation
 	 * from page cache lookup which is in HPAGE_SIZE units.
 	 */
+	address = address & huge_page_mask(hstate_vma(vma));
 	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT)
 		+ (vma->vm_pgoff >> PAGE_SHIFT);
 	mapping = (struct address_space *)page_private(page);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-align-faulting-address-to-a-hugepage-boundary-before-unmapping.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init.patch
mm-create-sys-kernel-mm.patch
mm-create-sys-kernel-mm-fix.patch
hugetlb-new-sysfs-interface-hugetlb-hang-off-of-sys-kernel-mm-rather-than-sys-kernel.patch
hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
hugetlb-fix-a-hugepage-reservation-check-for-map_shared.patch
hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages.patch
mm-add-alloc_pages_exact-and-free_pages_exact.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4.patch
memory-hotplug-add-sysfs-removable-attribute-for-hotplug-memory-remove.patch

