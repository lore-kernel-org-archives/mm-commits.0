Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557AA45948
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 19:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758484443; cv=none; b=JCCi4+qPbbVTG8uXbUAN3UL6cCXQYjEAyk4AWWoatEVt841B9cARQeBAyiNEGzzbyBQ/QgqQ3IZW009rDVZoYMsTn+rU1FB+yKXkcLumPD1JWTnRVcD0f82E0cDFkqBB8C+2JrrP9EOqCXw8jDkPqi6/XIp+mtqhQvvCvZEEKUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758484443; c=relaxed/simple;
	bh=wsynotVcbz67gjGMpTChpp5xw15dtx6BSCvjfRB/mJA=;
	h=Date:To:From:Subject:Message-Id; b=DmWSmq592PuTLBgvM1WJJmXlkaEOANuUOEm6wVtB0GQk+joqAPsJARbPbLYV2y+MSmiCLg77avTmGJXhprrGLI2MGwK/6QBjD9/s3MD5R0KIZt2KzQXKNy8uRO//YjKIg2Ebv6II7NnN0nZHq7bhwx2cofzI2vLZXcxSOaOmbNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J8VjkUiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J8VjkUiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F28C4CEE7;
	Sun, 21 Sep 2025 19:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758484441;
	bh=wsynotVcbz67gjGMpTChpp5xw15dtx6BSCvjfRB/mJA=;
	h=Date:To:From:Subject:From;
	b=J8VjkUiMVrLjhryiy23W31QMnaoZSrM1b6v+UGQwtxv+ie1ZzvOPD/6XfSpt7bpV5
	 goFmfkdjudzgUlImoHsc04n7HLF70l6HRByGZDb9eYblXHTYIJiIkzH+PzADD5C0RI
	 WkcMCIfuNYggvWC7x7473hO98RicRy1oBLFBdCwQ=
Date: Sun, 21 Sep 2025 12:54:01 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,alexandru.elisei@arm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-cma-refuse-handing-out-non-contiguous-page-ranges-fix.patch removed from -mm tree
Message-Id: <20250921195401.C0F28C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-cma-refuse-handing-out-non-contiguous-page-ranges-fix
has been removed from the -mm tree.  Its filename was
     mm-cma-refuse-handing-out-non-contiguous-page-ranges-fix.patch

This patch was dropped because it was folded into mm-cma-refuse-handing-out-non-contiguous-page-ranges.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-cma-refuse-handing-out-non-contiguous-page-ranges-fix
Date: Tue, 9 Sep 2025 05:50:13 -0400

apparently we can have NUMMU configs with SPARSEMEM enabled

Link: https://lkml.kernel.org/r/6ec933b1-b3f7-41c0-95d8-e518bb87375e@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/util.c~mm-cma-refuse-handing-out-non-contiguous-page-ranges-fix
+++ a/mm/util.c
@@ -1280,6 +1280,7 @@ unsigned int folio_pte_batch(struct foli
 {
 	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, 0);
 }
+#endif /* CONFIG_MMU */
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 /**
@@ -1315,4 +1316,3 @@ bool page_range_contiguous(const struct
 	return true;
 }
 #endif
-#endif /* CONFIG_MMU */
_

Patches currently in -mm which might be from david@redhat.com are

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
selftests-mm-gup_tests-option-to-gup-all-pages-in-a-single-call.patch

