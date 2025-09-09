Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2187038DD3
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 00:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376592; cv=none; b=d9tNC6Z7iGQO+jq8P4KfUmS8uRdan+tnCLJBkp3Ldy7dNYFrzQcVZrTOxb/Dq1qU+IUf/71rfZpOfipd+oNphBDUo4OemmEp21xOgxi8+IgR5/52P53maluCASN7SOR08RUnKdQiNggREzMH+M1bcDLFV6vwAr0fg38bkqZ1zBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376592; c=relaxed/simple;
	bh=gF0Ef0b6fujrVveaR6B/RYG1ikDUrfw6dE6+dUQthKQ=;
	h=Date:To:From:Subject:Message-Id; b=FiD9wE2m+OW15WVcNPuI/QAUlaOsVysVJclZJ75hqO6HEFFEaiqoSWfL2mK0q3GAsMpik49lPAkP6li+XOwLcL91o4OU3hACPFy+m+kJMauwIEMRCEIqxK+XAC6LpkPIdoXMwH/jTMGopuz2km3wTH6vqlzP+WT3QYQ9zMdM91I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jsvZmwTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jsvZmwTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA564C4CEF1;
	Tue,  9 Sep 2025 00:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757376592;
	bh=gF0Ef0b6fujrVveaR6B/RYG1ikDUrfw6dE6+dUQthKQ=;
	h=Date:To:From:Subject:From;
	b=jsvZmwTP+KcHdkxCYvera0ZBLPt+9FkcGJLNyuJ26hRmEtJN7+Dk36b2NusquOwjK
	 Bfc+SWUOEXjk3eAImcyI3287luQxOiEIkmdsFD5yC6MeIS1kE0+kZq//krKxz/oDfv
	 PBbglhIn2FnXjtd5ZiKCyLkpKYbJQaOsiz2GwPWg=
Date: Mon, 08 Sep 2025 17:09:51 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,imbrenda@linux.ibm.com,borntraeger@de.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-fix-handling-of-errors-from-arch_make_folio_accessible-in-follow_page_pte.patch added to mm-new branch
Message-Id: <20250909000951.DA564C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: fix handling of errors from arch_make_folio_accessible() in follow_page_pte()
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-fix-handling-of-errors-from-arch_make_folio_accessible-in-follow_page_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-fix-handling-of-errors-from-arch_make_folio_accessible-in-follow_page_pte.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: fix handling of errors from arch_make_folio_accessible() in follow_page_pte()
Date: Mon, 8 Sep 2025 11:45:17 +0200

In case we call arch_make_folio_accessible() and it fails, we would
incorrectly return a value that is "!= 0" to the caller, indicating that
we pinned all requested pages and that the caller can keep going.

follow_page_pte() is not supposed to return error values, but instead "0"
on failure and "1" on success -- we'll clean that up separately.

In case we return "!= 0", the caller will just keep going pinning more
pages.  If we happen to pin a page afterwards, we're in trouble, because
we essentially skipped some pages in the requested range.

Staring at the arch_make_folio_accessible() implementation on s390x, I
assume it should actually never really fail unless something unexpected
happens (BUG?).  So let's not CC stable and just fix common code to do the
right thing.

Clean up the code a bit now that there is no reason to store the return
value of arch_make_folio_accessible().

Link: https://lkml.kernel.org/r/20250908094517.303409-1-david@redhat.com
Fixes: f28d43636d6f ("mm/gup/writeback: add callbacks for inaccessible pages")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/gup.c~mm-gup-fix-handling-of-errors-from-arch_make_folio_accessible-in-follow_page_pte
+++ a/mm/gup.c
@@ -2898,12 +2898,9 @@ static int gup_fast_pte_range(pmd_t pmd,
 		 * see Documentation/core-api/pin_user_pages.rst for
 		 * details.
 		 */
-		if (flags & FOLL_PIN) {
-			ret = arch_make_folio_accessible(folio);
-			if (ret) {
-				gup_put_folio(folio, 1, flags);
-				goto pte_unmap;
-			}
+		if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio)) {
+			gup_put_folio(folio, 1, flags);
+			goto pte_unmap;
 		}
 		folio_set_referenced(folio);
 		pages[*nr] = page;
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate-remove-migratepage_unmap.patch
mm-migrate-remove-migratepage_unmap-fix.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix.patch
mm-memory-factor-out-common-code-from-vm_normal_page_.patch
mm-introduce-and-use-vm_normal_page_pud.patch
mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch
prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage.patch
mm-huge_memory-convert-tva_flags-to-enum-tva_type.patch
mm-huge_memory-respect-madv_collapse-with-pr_thp_disable_except_advised.patch
mm-stop-making-sparsemem_vmemmap-user-selectable.patch
arm64-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch
s390-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch
x86-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch
wireguard-selftests-remove-config_sparsemem_vmemmap=y-from-qemu-kernel-config.patch
mm-page_alloc-reject-unreasonable-folio-compound-page-sizes-in-alloc_contig_range_noprof.patch
mm-memremap-reject-unreasonable-folio-compound-page-sizes-in-memremap_pages.patch
mm-hugetlb-check-for-unreasonable-folio-sizes-when-registering-hstate.patch
mm-mm_init-make-memmap_init_compound-look-more-like-prep_compound_page.patch
mm-sanity-check-maximum-folio-size-in-folio_set_order.patch
mm-limit-folio-compound-page-sizes-in-problematic-kernel-configs.patch
mm-simplify-folio_page-and-folio_page_idx.patch
mm-hugetlb-cleanup-hugetlb_folio_init_tail_vmemmap.patch
mm-mm-percpu-km-drop-nth_page-usage-within-single-allocation.patch
fs-hugetlbfs-remove-nth_page-usage-within-folio-in-adjust_range_hwpoison.patch
fs-hugetlbfs-cleanup-folio-in-adjust_range_hwpoison.patch
mm-pagewalk-drop-nth_page-usage-within-folio-in-folio_walk_start.patch
mm-gup-drop-nth_page-usage-within-folio-when-recording-subpages.patch
mm-gup-remove-record_subpages.patch
mm-gup-remove-record_subpages-fix.patch
io_uring-zcrx-remove-nth_page-usage-within-folio.patch
mips-mm-convert-__flush_dcache_pages-to-__flush_dcache_folio_pages.patch
mm-cma-refuse-handing-out-non-contiguous-page-ranges.patch
dma-remap-drop-nth_page-in-dma_common_contiguous_remap.patch
scatterlist-disallow-non-contigous-page-ranges-in-a-single-sg-entry.patch
ata-libata-sff-drop-nth_page-usage-within-sg-entry.patch
drm-i915-gem-drop-nth_page-usage-within-sg-entry.patch
mspro_block-drop-nth_page-usage-within-sg-entry.patch
memstick-drop-nth_page-usage-within-sg-entry.patch
mmc-drop-nth_page-usage-within-sg-entry.patch
scsi-scsi_lib-drop-nth_page-usage-within-sg-entry.patch
scsi-sg-drop-nth_page-usage-within-sg-entry.patch
vfio-pci-drop-nth_page-usage-within-sg-entry.patch
crypto-remove-nth_page-usage-within-sg-entry.patch
mm-gup-drop-nth_page-usage-in-unpin_user_page_range_dirty_lock.patch
kfence-drop-nth_page-usage.patch
block-update-comment-of-struct-bio_vec-regarding-nth_page.patch
mm-remove-nth_page.patch
selftests-mm-split_huge_page_test-fix-occasional-is_backed_by_folio-wrong-results.patch
selftests-mm-split_huge_page_test-cleanups-for-split_pte_mapped_thp-test.patch
mm-gup-fix-handling-of-errors-from-arch_make_folio_accessible-in-follow_page_pte.patch

