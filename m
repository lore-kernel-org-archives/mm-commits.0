Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285CF1804E
	for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2024 20:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713818083; cv=none; b=cu1wEpDpLaChdREBzB+/l3wCO4/sHjDinF0UBKHxU8iZi3lBMmuUsY4L+dtqPAGfOHu5Q/JTyH/mUsnqWZJw2iKiFPI1DP9JEpnCA5skaR8Q3pNuFqJ6ZJAFuEH8SxYXTmq+zJp/uq5fx//JLwR3FDkJ6Ig4I5jWO0XeBhVnQYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713818083; c=relaxed/simple;
	bh=6WenMaJmSMJs3vlzoEt8InPsfwrn4Dx2clkBbZ21gss=;
	h=Date:To:From:Subject:Message-Id; b=JEJZ9/JRO1UQe0qYPGLvf6bwr8aWZsvWyOUC1Qj1/Bf9fmi7FYE55a0HQ68OtFBwmvUeyTt2qj7JWaVg9rg9JfA0vkTnzDBNEffBxCosbDWBkBhdLWdJDO6z0FRHUBCtYfwiabZ6Yg84tNaChzWGztaDpvhL8LYSKsVwltDMxJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yFu8OxPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yFu8OxPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ED2C113CC;
	Mon, 22 Apr 2024 20:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713818082;
	bh=6WenMaJmSMJs3vlzoEt8InPsfwrn4Dx2clkBbZ21gss=;
	h=Date:To:From:Subject:From;
	b=yFu8OxPrbOsnYeY0GKjSX/amSNBKNuEb83j3RyKa9qNxTzGDPh0oysBsrJNuOHoe+
	 6RUQQWmxxVhSjIjY0/kabiWaURAcofknoXtZjV6hJaVhx7QLyly0gwvEksIumVxksA
	 q8YHpGB81f13Fkpz3btwq+qxH9Oe6xcbNlxn7XIo=
Date: Mon, 22 Apr 2024 13:34:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,jhubbard@nvidia.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch added to mm-unstable branch
Message-Id: <20240422203442.A1ED2C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch

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
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch
loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch

