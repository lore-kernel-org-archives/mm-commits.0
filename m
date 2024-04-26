Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCAA7603F
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103843; cv=none; b=szfmPV1t60lORb07XlB+vqKmKZrNbf/Qvb53DQMAnNkkuOVvOqGgTGXjLmIIdNjbQYVAk6lhHjpE1lmnkAzDMTeTAnI6ojfYMM7hORmJRES4B1Vl+Y9OVBOv2taNSR2GCCf26U8fMB4n+ro2wgIN9EaEd9HbtkRHLC3iXGexduA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103843; c=relaxed/simple;
	bh=G1fpgsSVuUhsAppUxrbT+WAT9eNeIxs62W99l9QBzoE=;
	h=Date:To:From:Subject:Message-Id; b=dl1drBZ7ZMv9ygZeuqU6s0TADEJicLG8mXhYI0VYY4mPl8Ak+GSmaFoxVxn4+FAy+V5cmeSTSAdy+D8Qa7Zt8oYgGqMVCACwNe7x3rVhOwaUb84BlQdXwR2MqaXDjAn2Wl963qkJb8Mx3tDLL7LWAknKzf3iHXVGcNKyCBAFoX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PbSCJtk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PbSCJtk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82ADC113CD;
	Fri, 26 Apr 2024 03:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103842;
	bh=G1fpgsSVuUhsAppUxrbT+WAT9eNeIxs62W99l9QBzoE=;
	h=Date:To:From:Subject:From;
	b=PbSCJtk/g44l2wf5oJdSWltJyh26WM6Yc2m+14eRjGBDW/hYxEL5ypwL18rMTf0T9
	 hOzEdN5OzYdD2iLBosoeRK8MSaukeYq3iCjEVQin1gEiTrwOSiVru+2K8RdSzyRTgg
	 DDTk6Mi3aQM2vVJAjINLXdspEFwXMrnd60ATfvoA=
Date: Thu, 25 Apr 2024 20:57:22 -0700
To: mm-commits@vger.kernel.org,jhubbard@nvidia.com,jgg@nvidia.com,hughd@google.com,djwong@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch removed from -mm tree
Message-Id: <20240426035722.D82ADC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: don't perform madvise VMA walk for MADV_POPULATE_(READ|WRITE)
has been removed from the -mm tree.  Its filename was
     mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/madvise: don't perform madvise VMA walk for MADV_POPULATE_(READ|WRITE)
Date: Thu, 14 Mar 2024 17:13:00 +0100

We changed faultin_page_range() to no longer consume a VMA, because
faultin_page_range() might internally release the mm lock to lookup
the VMA again -- required to cleanly handle VM_FAULT_RETRY. But
independent of that, __get_user_pages() will always lookup the VMA
itself.

Now that we let __get_user_pages() just handle VMA checks in a way that
is suitable for MADV_POPULATE_(READ|WRITE), the VMA walk in madvise()
is just overhead. So let's just call madvise_populate()
on the full range instead.

There is one change in behavior: madvise_walk_vmas() would skip any VMA
holes, and if everything succeeded, it would return -ENOMEM after
processing all VMAs.

However, for MADV_POPULATE_(READ|WRITE) it's unlikely for the caller to
notice any difference: -ENOMEM might either indicate that there were VMA
holes or that populating page tables failed because there was not enough
memory. So it's unlikely that user space will notice the difference, and
that special handling likely only makes sense for some other madvise()
actions.

Further, we'd already fail with -ENOMEM early in the past if looking up the
VMA after dropping the MM lock failed because of concurrent VMA
modifications. So let's just keep it simple and avoid the madvise VMA
walk, and consistently fail early if we find a VMA hole.

Link: https://lkml.kernel.org/r/20240314161300.382526-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/mm/madvise.c~mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite
+++ a/mm/madvise.c
@@ -901,26 +901,19 @@ static long madvise_dontneed_free(struct
 		return -EINVAL;
 }
 
-static long madvise_populate(struct vm_area_struct *vma,
-			     struct vm_area_struct **prev,
-			     unsigned long start, unsigned long end,
-			     int behavior)
+static long madvise_populate(struct mm_struct *mm, unsigned long start,
+		unsigned long end, int behavior)
 {
 	const bool write = behavior == MADV_POPULATE_WRITE;
-	struct mm_struct *mm = vma->vm_mm;
 	int locked = 1;
 	long pages;
 
-	*prev = vma;
-
 	while (start < end) {
 		/* Populate (prefault) page tables readable/writable. */
 		pages = faultin_page_range(mm, start, end, write, &locked);
 		if (!locked) {
 			mmap_read_lock(mm);
 			locked = 1;
-			*prev = NULL;
-			vma = NULL;
 		}
 		if (pages < 0) {
 			switch (pages) {
@@ -1021,9 +1014,6 @@ static int madvise_vma_behavior(struct v
 	case MADV_DONTNEED:
 	case MADV_DONTNEED_LOCKED:
 		return madvise_dontneed_free(vma, prev, start, end, behavior);
-	case MADV_POPULATE_READ:
-	case MADV_POPULATE_WRITE:
-		return madvise_populate(vma, prev, start, end, behavior);
 	case MADV_NORMAL:
 		new_flags = new_flags & ~VM_RAND_READ & ~VM_SEQ_READ;
 		break;
@@ -1425,8 +1415,16 @@ int do_madvise(struct mm_struct *mm, uns
 	end = start + len;
 
 	blk_start_plug(&plug);
-	error = madvise_walk_vmas(mm, start, end, behavior,
-			madvise_vma_behavior);
+	switch (behavior) {
+	case MADV_POPULATE_READ:
+	case MADV_POPULATE_WRITE:
+		error = madvise_populate(mm, start, end, behavior);
+		break;
+	default:
+		error = madvise_walk_vmas(mm, start, end, behavior,
+					  madvise_vma_behavior);
+		break;
+	}
 	blk_finish_plug(&plug);
 	if (write)
 		mmap_write_unlock(mm);
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

