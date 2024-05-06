Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151DD28EB
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956335; cv=none; b=l8b/QEPXSTXuA68X/c5A+N5fRxIhqlcx3oYIaqq1cTW5Ux+cHEr3nhHNEcbuAPyUIqsnP2zuPu5nmwlVF7R//rFk3tmIQUff6skVfjEz2diuT2jtS2c3n3R7oqox+2hvpXD3WMN9wk50ZsdKPxht1uCGVm9zO5/HJejUDXR+NGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956335; c=relaxed/simple;
	bh=HAj68pfIIguJFnX4MfnVNV3C0SxU8B5N420TdWK/pEA=;
	h=Date:To:From:Subject:Message-Id; b=ES3KvV99MGZJIi+U36zzQyP5zEuRzlt0FDDl2jPfmWH2H7eCq/7RVTX0i/kt76Z83gC/PE+ujeseH6J/p3WNHpNrfpZXcDZHUSH+hPexwdt+9GTmU0z5tbH3pNx6m1zPJtMntOQWLulMpPRmQ20mKSuX7LkWQLuuHm3xZ1GFL4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UHiVLWhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UHiVLWhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C25C113CC;
	Mon,  6 May 2024 00:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956334;
	bh=HAj68pfIIguJFnX4MfnVNV3C0SxU8B5N420TdWK/pEA=;
	h=Date:To:From:Subject:From;
	b=UHiVLWhJR8f5WhcA6s2usD+RF/+wUJmf9pTU8zAI8R6BoSIxm6WLecKSDNCqVJlJx
	 tVEs5RhI36be0lDq3sbOFT2/5hEeo8ma9zBVfs5I0peJwC4JG+r4DTS/di+SCRtUmd
	 90mmS7TuUoXtb0vuMNhFxKqtCpb4rf5iklEITJoQ=
Date: Sun, 05 May 2024 17:45:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,jhubbard@nvidia.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch removed from -mm tree
Message-Id: <20240506004534.79C25C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch

This patch was dropped because it was folded into mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2
Date: Mon, 22 Apr 2024 21:42:17 +0200

* Also document concurrent removal from the page cache (likely we should
  return -EBUSY -- but likely it doesn't really matter).

* Reference fd4a7ac32918 in patch description

Link: https://lkml.kernel.org/r/20240422194217.442933-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2
+++ a/mm/huge_memory.c
@@ -2975,7 +2975,8 @@ bool can_split_folio(struct folio *folio
  *
  * Returns 0 if the huge page was split successfully.
  *
- * Returns -EAGAIN if the folio has unexpected reference (e.g., GUP).
+ * Returns -EAGAIN if the folio has unexpected reference (e.g., GUP) or if
+ * the folio was concurrently removed from the page cache.
  *
  * Returns -EBUSY when trying to split the huge zeropage, if the folio is
  * under writeback, if fs-specific folio metadata cannot currently be
_

Patches currently in -mm which might be from david@redhat.com are

drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch
mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch
mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch
mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch
mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch
sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch
mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch
mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch
trace-events-page_ref-trace-the-raw-page-mapcount-value.patch
xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch
mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch
documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch
mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch
mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch
fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch
fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch
mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared.patch
selftests-mm-cow-flag-vmsplice-hugetlb-tests-as-xfail.patch
mm-hugetlb-document-why-hugetlb-uses-folio_mapcount-for-cow-reuse-decisions.patch
selftests-mm-gup_longterm-test-unsharing-logic-when-r-o-pinning.patch

