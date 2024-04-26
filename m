Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3FD80C16
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104160; cv=none; b=eRZabYmIeyY9XFEKvTu6m2HNSrp1N0XBFSGZMclxgsVFyXsQBJIbdwwUoLoxYIIiU/X63rfbAeMtX1eeCdQurLyU8Wpo7lDW8jyVP0xzP+vFwzvdYyU49Hdk/rIExQzZSpZoI06VQTkKTIK5p5pB7ghAYdmYj6kYFFgAw+6X2Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104160; c=relaxed/simple;
	bh=w/wC5LukYPtif9ycNoAFqbOLw/5k9IeOKW5NOVyVl/g=;
	h=Date:To:From:Subject:Message-Id; b=UAqEXoMCabFo7p3i91AAvWWClBi3WAhPUKlsNfigqXV1iHtVFlxgYU661W3Jkm24jhX7IpN7s98IlyEOhogaf4Cd9gqlIFL1p3H4m8yvsf4+06O89ikzLNe+MrTEw4sSXCqFDQpQTx56QbEbqcaSs6jIJiWaPZOipxUxFQJ+Qls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AIUal/0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AIUal/0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C107EC2BD11;
	Fri, 26 Apr 2024 04:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104159;
	bh=w/wC5LukYPtif9ycNoAFqbOLw/5k9IeOKW5NOVyVl/g=;
	h=Date:To:From:Subject:From;
	b=AIUal/0UWkmHi0RbulKqs8TWscxbhukqDv1ekmmIV297P9a1KlkQ8wf0pinimP+An
	 REA8Go4xf49x8/Aqjk9Zi5VBOwMhc71bZtFkxuinCjoM0II1v4X0dWBWH6lhRiMu37
	 L3FAnNyJtfyXE99oCd5IJE+CQcRNi4Du+VysYEpo=
Date: Thu, 25 Apr 2024 21:02:39 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch removed from -mm tree
Message-Id: <20240426040239.C107EC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use "GUP-fast" instead "fast GUP" in remaining comments
has been removed from the -mm tree.  Its filename was
     mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: use "GUP-fast" instead "fast GUP" in remaining comments
Date: Tue, 2 Apr 2024 14:55:16 +0200

Let's fixup the remaining comments to consistently call that thing
"GUP-fast".  With this change, we consistently call it "GUP-fast".

Link: https://lkml.kernel.org/r/20240402125516.223131-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c    |    2 +-
 mm/khugepaged.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-use-gup-fast-instead-fast-gup-in-remaining-comments
+++ a/mm/filemap.c
@@ -1810,7 +1810,7 @@ EXPORT_SYMBOL(page_cache_prev_miss);
  * C. Return the page to the page allocator
  *
  * This means that any page may have its reference count temporarily
- * increased by a speculative page cache (or fast GUP) lookup as it can
+ * increased by a speculative page cache (or GUP-fast) lookup as it can
  * be allocated by another user before the RCU grace period expires.
  * Because the refcount temporarily acquired here may end up being the
  * last refcount on the page, any page allocation must be freeable by
--- a/mm/khugepaged.c~mm-use-gup-fast-instead-fast-gup-in-remaining-comments
+++ a/mm/khugepaged.c
@@ -1153,7 +1153,7 @@ static int collapse_huge_page(struct mm_
 	 * huge and small TLB entries for the same virtual address to
 	 * avoid the risk of CPU bugs in that area.
 	 *
-	 * Parallel fast GUP is fine since fast GUP will back off when
+	 * Parallel GUP-fast is fine since GUP-fast will back off when
 	 * it detects PMD is changed.
 	 */
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
_

Patches currently in -mm which might be from david@redhat.com are

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

