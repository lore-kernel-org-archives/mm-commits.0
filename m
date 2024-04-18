Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129F217335B
	for <mm-commits@vger.kernel.org>; Thu, 18 Apr 2024 19:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713468439; cv=none; b=TzfOTVhrwXSErz55ZBVGPuhw50R2h2BzAXmN4tLbK8W+ryeSaDcOX/Pi1QtfEuTNqXpFWF9uDK6WtPokJncRIXiNbkGt8e6lXnVTYkURD4X9ItSfAVTY7r8p5EvDnt1Q1x0wE3CjxK6DHI49ZCcGUuon/zUozVnSEekvOY0zSTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713468439; c=relaxed/simple;
	bh=b40Kwu39GvXErFQfNQHp995uFmA1D1ZJA8TMU9PYEnA=;
	h=Date:To:From:Subject:Message-Id; b=sgQS/ydV4QzTBYrQqbS4mxSXbnyILrd7Ec4JWcfl0naAQK+JOqjfJ5wfXBDAROc4i0H6FOFoXofHZVnZDQUd3vsD/h7eIidgU9Nb2V/Bglq63vqSgD27qENg6UbJPXcA/JjMXNDxsuzkADvBr26OzhE9fNE79os3zhznqkJFFjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RMAppVE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RMAppVE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A457C113CC;
	Thu, 18 Apr 2024 19:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713468438;
	bh=b40Kwu39GvXErFQfNQHp995uFmA1D1ZJA8TMU9PYEnA=;
	h=Date:To:From:Subject:From;
	b=RMAppVE1NZSwh6CzIM1vo3aODFisYS5KF4SAjl3E7x0VEu2AEkqqoN93/WCRbn72O
	 U/a6W8mLDvJF+2j+2463ka2B9x6ehZL9019HZlh292be4H6pgrC9AsaNesnU8AYhE3
	 jWc0Y30KOjYZUcDq87IfIYSu1xR6QlCCizo6I/9I=
Date: Thu, 18 Apr 2024 12:27:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,jhubbard@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch added to mm-unstable branch
Message-Id: <20240418192718.9A457C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: improve split_huge_page_to_list_to_order() return value documentation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/huge_memory: improve split_huge_page_to_list_to_order() return value documentation
Date: Thu, 18 Apr 2024 17:18:34 +0200

The documentation is wrong and relying on it almost resulted in BUGs in
new callers: we return -EAGAIN on unexpected folio references, not -EBUSY.

Let's fix that and also document which other return values we can
currently see and why they could happen.

Link: https://lkml.kernel.org/r/20240418151834.216557-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation
+++ a/mm/huge_memory.c
@@ -2956,7 +2956,7 @@ bool can_split_folio(struct folio *folio
  *
  * 3) The folio must not be pinned. Any unexpected folio references, including
  *    GUP pins, will result in the folio not getting split; instead, the caller
- *    will receive an -EBUSY.
+ *    will receive an -EAGAIN.
  *
  * 4) @new_order > 1, usually. Splitting to order-1 anonymous folios is not
  *    supported for non-file-backed folios, because folio->_deferred_list, which
@@ -2975,8 +2975,15 @@ bool can_split_folio(struct folio *folio
  *
  * Returns 0 if the huge page was split successfully.
  *
- * Returns -EBUSY if @page's folio is pinned, or if the anon_vma disappeared
- * from under us.
+ * Returns -EAGAIN if the folio has unexpected reference (e.g., GUP).
+ *
+ * Returns -EBUSY when trying to split the huge zeropage, if the folio is
+ * under writeback, if fs-specific folio metadata cannot currently be
+ * released, or if some unexpected race happened (e.g., anon VMA disappeared,
+ * truncation).
+ *
+ * Returns -EINVAL when trying to split to an order that is incompatible
+ * with the folio. Splitting to order 0 is compatible with all folios.
  */
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 				     unsigned int new_order)
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
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
loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch

