Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EF67602D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101768; cv=none; b=EjyJu1Vjwp3RO5utA6QFSNVow7XCgCzRfVcSh9YmtVZJDFhxoIvAv0NOYFXsppZLLXqckpuK8hqiYDG5rc7pDkCsQE6SFcbiPhGFxYQ+BgJ6tgvy2fptegYEUYt7G3gh7j1JzyMTX9yLSApes8tuzCwBHlhvK51FSgMguc0AWs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101768; c=relaxed/simple;
	bh=uUckH6eQZsR5JJ0KxXidbFIOlfNGPqjYVSlTcwD8p2c=;
	h=Date:To:From:Subject:Message-Id; b=oGihKaFkTM1zabj99WXgr8yS5qVfHR10PfQcbgg7LJh2hm1n97HKaIff8Av0arhdibr/SY0TKGMQh1LoDwyzBpsMwuN/NW2ZI1Au3a1hgRlJXUiljjtW96tLTgNHj7ZQXWtabeKzuOYLlqJurzC75EmG4EHebOPLQrrqOZhMF4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QFJ8eQ0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QFJ8eQ0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A34C113CD;
	Fri, 26 Apr 2024 03:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101768;
	bh=uUckH6eQZsR5JJ0KxXidbFIOlfNGPqjYVSlTcwD8p2c=;
	h=Date:To:From:Subject:From;
	b=QFJ8eQ0yaC9QuVBlpnoMH0+6LzOsH3q2/OlZLQT1L+kxa1AAHOxntOjxxWii66EyE
	 /tsPa4HUBVT0EwmIVPwh9hASFPP3WuFnMqlSSrst3RbO0SvnAZRhfAjkoLc7oj5k+6
	 8ZsTY8lPWJ1eNvtRnjVG7PhojJL0v8fEnkx7q+qs=
Date: Thu, 25 Apr 2024 20:22:47 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch removed from -mm tree
Message-Id: <20240426032248.46A34C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: folio_likely_mapped_shared() kerneldoc fixup
has been removed from the -mm tree.  Its filename was
     mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch

This patch was dropped because it was folded into mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: folio_likely_mapped_shared() kerneldoc fixup
Date: Mon, 25 Mar 2024 09:23:03 +0100

Fixup "mm: convert folio_estimated_sharers() to
folio_likely_mapped_shared()".

Link: https://lkml.kernel.org/r/dd0ad9f2-2d7a-45f3-9ba3-979488c7dd27@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix
+++ a/include/linux/mm.h
@@ -2183,23 +2183,25 @@ static inline size_t folio_size(struct f
  * at most once into an MM, and they cannot be partially mapped.
  *
  * For other folios, the result can be fuzzy:
- * (a) For partially-mappable large folios (THP), the return value can wrongly
- *     indicate "mapped exclusively" (false negative) when the folio is
- *     only partially mapped into at least one MM.
- * (b) For pagecache folios (including hugetlb), the return value can wrongly
- *     indicate "mapped shared" (false positive) when two VMAs in the same MM
- *     cover the same file range.
- * (c) For (small) KSM folios, the return value can wrongly indicate "mapped
- *     shared" (false negative), when the folio is mapped multiple times into
- *     the same MM.
+ *    #. For partially-mappable large folios (THP), the return value can wrongly
+ *       indicate "mapped exclusively" (false negative) when the folio is
+ *       only partially mapped into at least one MM.
+ *    #. For pagecache folios (including hugetlb), the return value can wrongly
+ *       indicate "mapped shared" (false positive) when two VMAs in the same MM
+ *       cover the same file range.
+ *    #. For (small) KSM folios, the return value can wrongly indicate "mapped
+ *       shared" (false negative), when the folio is mapped multiple times into
+ *       the same MM.
  *
  * Further, this function only considers current page table mappings that
- * are tracked using the folio mapcount(s). It does not consider:
- * (1) If the folio might get mapped in the (near) future (e.g., swapcache,
- *     pagecache, temporary unmapping for migration).
- * (2) If the folio is mapped differently (VM_PFNMAP).
- * (3) If hugetlb page table sharing applies. Callers might want to check
- *     hugetlb_pmd_shared().
+ * are tracked using the folio mapcount(s).
+ *
+ * This function does not consider:
+ *    #. If the folio might get mapped in the (near) future (e.g., swapcache,
+ *       pagecache, temporary unmapping for migration).
+ *    #. If the folio is mapped differently (VM_PFNMAP).
+ *    #. If hugetlb page table sharing applies. Callers might want to check
+ *       hugetlb_pmd_shared().
  *
  * Return: Whether the folio is estimated to be mapped into more than one MM.
  */
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch
mm-remove-prot-parameter-from-move_pte.patch
mm-gup-consistently-name-gup-fast-functions.patch
mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch
mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch
drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again-fix.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios-fix.patch
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
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch
mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared.patch
loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch

