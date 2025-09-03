Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379D62E92B8
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 22:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756938224; cv=none; b=Opxh6tFAWYNuuyl95QwiGt6EcmtzLd8CABLO96VR7hI/1DTiQ27eH1L6t73qLbLV5YcxxoPLwn2empxGeO95m6OvbvN8F2LkIwVfVPeuWssk10uJ3p7rVXw0Jk+UZzbwQ6y8g9KbOvYp6cfq9O6HAS8Qzw/7YnesZubbgXNH0Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756938224; c=relaxed/simple;
	bh=mZIKv558XOjbafWKfRMAgy+qA4u2EK0eWpLDeZWITQ4=;
	h=Date:To:From:Subject:Message-Id; b=sFsu23FD3R5RrZV8aGMEkvi1Z+O+LMn+1Zo5zxzvNUO2eLttxHX0dsMxIXwgBfyGf6d/ayF2qU/wOI/GfI7Z0HEc6lvbfYOlN5xqkqNYPvAD3SQcD6gt1CZ/o7b/o7FBFIsR2rXRwP9pMsxm81clp3HMdedPtHLIwZrq7Nwpxv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LE5j9FXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LE5j9FXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73F2C4CEE7;
	Wed,  3 Sep 2025 22:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756938223;
	bh=mZIKv558XOjbafWKfRMAgy+qA4u2EK0eWpLDeZWITQ4=;
	h=Date:To:From:Subject:From;
	b=LE5j9FXfbO2XveVqvcermkQAnwumQ6JesAYh+OHql6aTL2mFuvR87/42LiWeDI09/
	 y8TwSPLTkshQdTnh1I7hb3OD042i5IoTw10BHXaN5EXnnXAa75Qy5kXrugJVzylC0i
	 XkAkmKmr72aQhcbWsBuyHfGvZF7GQUasZzxAR7Z8=
Date: Wed, 03 Sep 2025 15:23:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-split_huge_page_test-fix-occasional-is_backed_by_folio-wrong-results.patch added to mm-new branch
Message-Id: <20250903222343.D73F2C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: split_huge_page_test: fix occasional is_backed_by_folio() wrong results
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-split_huge_page_test-fix-occasional-is_backed_by_folio-wrong-results.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-split_huge_page_test-fix-occasional-is_backed_by_folio-wrong-results.patch

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
Subject: selftests/mm: split_huge_page_test: fix occasional is_backed_by_folio() wrong results
Date: Wed, 3 Sep 2025 09:02:52 +0200

Patch series "selftests/mm: split_huge_page_test: split_pte_mapped_thp
improvements", v2.

One fix for occasional failures I found while testing and a bunch of
cleanups that should make that test easier to digest.


This patch (of 2):

When checking for actual tail or head pages of a folio, we must make sure
that the KPF_COMPOUND_HEAD/KPF_COMPOUND_TAIL flag is paired with KPF_THP.

For example, if we have another large folio after our large folio in
physical memory, our "pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL)" would
trigger even though it's actually a head page of the next folio.

If is_backed_by_folio() returns a wrong result, split_pte_mapped_thp() can
fail with "Some THPs are missing during mremap".

Fix it by checking for head/tail pages of folios properly.  Add
folio_tail_flags/folio_head_flags to improve readability and use these
masks also when just testing for any compound page.

Link: https://lkml.kernel.org/r/20250903070253.34556-1-david@redhat.com
Link: https://lkml.kernel.org/r/20250903070253.34556-2-david@redhat.com
Fixes: 169b456b0162 ("selftests/mm: reimplement is_backed_by_thp() with more precise check")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   15 +++++-------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-split_huge_page_test-fix-occasional-is_backed_by_folio-wrong-results
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -44,6 +44,8 @@ int kpageflags_fd;
 static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 		int kpageflags_fd)
 {
+	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
+	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
 	const unsigned long nr_pages = 1UL << order;
 	unsigned long pfn_head;
 	uint64_t pfn_flags;
@@ -61,7 +63,7 @@ static bool is_backed_by_folio(char *vad
 
 	/* check for order-0 pages */
 	if (!order) {
-		if (pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))
+		if (pfn_flags & (folio_head_flags | folio_tail_flags))
 			return false;
 		return true;
 	}
@@ -76,14 +78,14 @@ static bool is_backed_by_folio(char *vad
 		goto fail;
 
 	/* head PFN has no compound_head flag set */
-	if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD)))
+	if ((pfn_flags & folio_head_flags) != folio_head_flags)
 		return false;
 
 	/* check all tail PFN flags */
 	for (i = 1; i < nr_pages; i++) {
 		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
 			goto fail;
-		if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL)))
+		if ((pfn_flags & folio_tail_flags) != folio_tail_flags)
 			return false;
 	}
 
@@ -94,11 +96,8 @@ static bool is_backed_by_folio(char *vad
 	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
 		return true;
 
-	/* this folio is bigger than the given order */
-	if (pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL))
-		return false;
-
-	return true;
+	/* If we find another tail page, then the folio is larger. */
+	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
 fail:
 	ksft_exit_fail_msg("Failed to get folio info\n");
 	return false;
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

