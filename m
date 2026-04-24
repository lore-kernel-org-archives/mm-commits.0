Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67053659EE
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 10:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777026655; cv=none; b=OyJ1YlbFEPowDjkUqoABXuXhjVQiY0Nc8Cly2PRhT+sFFoBJllOKCflJGHz9sj2rJUT3FgOKn9vskTerR1wmjX6YwWg9ZprwqzTvrH2vp32cCZZoRetakokcZ76vOaXpBTMAISeX6OL6q2imVJ/JMZUgdy1aXNkfMypTgGjGA1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777026655; c=relaxed/simple;
	bh=COQf+ZX7GkCLXjjPm7trbU+KELh2lXFG4vj2XWDYcuk=;
	h=Date:To:From:Subject:Message-Id; b=FfPQh5J97Cr0LSibmWTKJ5+n9E2H1hBxJYnCr9PeQEfYIeR0JRcBhsWaiQ2C9zSmojGTKMx3cSXv55RDwd3nu50Fp1/JGaRlTP9IgB5Vr7sWndoBW6/GE32bRK0NY7QrdWPMfWLkp74lRT2lgSjgcnPIoRPNyAWVexu1o4b3XS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YUpwrgFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YUpwrgFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63DAC19425;
	Fri, 24 Apr 2026 10:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777026654;
	bh=COQf+ZX7GkCLXjjPm7trbU+KELh2lXFG4vj2XWDYcuk=;
	h=Date:To:From:Subject:From;
	b=YUpwrgFYKPvvMwhCW82Xew2cvCuiy/iOxbf1pHdvXt9x1j9lSp2tp0YpZtvxFW7eq
	 CalFVkB33spgDD/meaVxwEVYKW7SxjS2Vdm/6dPV80pG6wsRkkG7uorWa8tKQg6+sC
	 oTmETquD4fUzQR4pBNIXTDkK5O1cQ3HeyVN26ICw=
Date: Fri, 24 Apr 2026 03:30:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-remove-read_only_thp_for_fs-check.patch added to mm-new branch
Message-Id: <20260424103054.B63DAC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-remove-read_only_thp_for_fs-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-remove-read_only_thp_for_fs-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Thu, 23 Apr 2026 22:49:04 -0400

Patch series "Remove read-only THP support for FSes without large folio
support", v4.

This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
read-only THPs for FSes with large folio support (the supported orders
need to include PMD_ORDER) by default.  It is on top of mm-new.

Before the patchset, the status of creating read-only THPs is below:

                            |    PF     | MADV_COLLAPSE | khugepaged |
                            |-----------|---------------|------------|
 large folio FSes only      |     ✓     |       x       |      x     |
 READ_ONLY_THP_FOR_FS only  |     x     |       ✓       |      ✓     |
 both                       |     ✓     |       ✓       |      ✓     |

where READ_ONLY_THP_FOR_FS implies no large folio FSes.


Now without READ_ONLY_THP_FOR_FS:

                           |    PF     | MADV_COLLAPSE | khugepaged |
                           |-----------|---------------|------------|
 large folio FSes          |     ✓     |       ✓       |      ✓     |
 no large folio FSes       |     x     |       x       |      x     |

This means no large folio FSes need to add large folio support (the
supported orders need to include PMD_ORDER), so that they can leverage
read-only THP creation function.

To prevent breaking read-only THP support for large folio FSes,
1. first 4 patches enables the support, so that without READ_ONLY_THP_FOR_FS,
   read-only THP still works for large folio FSes,
2. Patch 5 removes READ_ONLY_THP_FOR_FS Kconfig,
3. the rest of patches remove code related to READ_ONLY_THP_FOR_FS.

NOTE: collapsing writable MAP_PRIVATE pagecache folios is not supported,
since:
1. PMD THP CoW only faults in at PTE level to avoid long CoW latency,
2. the first check, due to 1, in file_backed_vma_is_retractable() prevents it.


The overview of the changes is:

1. collapse_file() checks for to-be-collapsed folio dirtiness after they
   are locked, unmapped to make sure no new write happens. Before,
   mapping->nr_thps and inode->i_writecount are used to cause read-only
   THP truncation before a fd becomes writable.

2. hugepage_enabled() is true for anon, shmem, and file-backed cases
   if the global khugepaged control is on, otherwise, khugepaged for
   file-backed case is turned off and anon and shmem depend on per-size
   control knobs.

3. collapse_file() from mm/khugepaged.c, instead of checking
   CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
   of struct address_space of the file is at least PMD_ORDER.

4. file_thp_enabled() also checks mapping_max_folio_order() instead and
   no longer checks if the input file is opened as read-only (Change 1
   handles read-write files).

5. truncate_inode_partial_folio() calls folio_split() directly instead
   of the removed try_folio_split_to_order(), since large folios can
   only show up on a FS with large folio support.

6. nr_thps is removed from struct address_space, since it is no longer
   needed to drop all read-only THPs from a FS without large folio
   support when the fd becomes writable. Its related filemap_nr_thps*()
   are removed too.

7. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.

8. Updated comments in various places.


This patch (of 12):

collapse_file() requires FSes supporting large folio with at least
PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. 
MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.

While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.

Add a helper function mapping_pmd_thp_support() for FSes supporting large
folio with at least PMD_ORDER.

Link: https://lore.kernel.org/20260424024915.28758-1-ziy@nvidia.com
Link: https://lore.kernel.org/20260424024915.28758-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    9 +++++++++
 mm/khugepaged.c         |   10 ++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

--- a/include/linux/pagemap.h~mm-khugepaged-remove-read_only_thp_for_fs-check
+++ a/include/linux/pagemap.h
@@ -513,6 +513,15 @@ static inline bool mapping_large_folio_s
 	return mapping_max_folio_order(mapping) > 0;
 }
 
+static inline bool mapping_pmd_thp_support(const struct address_space *mapping)
+{
+	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
+	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
+
+	return mapping_max_folio_order(mapping) >= PMD_ORDER;
+}
+
+
 /* Return the maximum folio size for this pagecache mapping, in bytes. */
 static inline size_t mapping_max_folio_size(const struct address_space *mapping)
 {
--- a/mm/khugepaged.c~mm-khugepaged-remove-read_only_thp_for_fs-check
+++ a/mm/khugepaged.c
@@ -2235,8 +2235,14 @@ static enum scan_result collapse_file(st
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
 
-	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
+	/*
+	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
+	 *
+	 * TODO: once shmem always calls mapping_set_large_folios() on its
+	 * mapping, the shmem check can be removed.
+	 */
+	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_thp_support(mapping));
+	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
 
 	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-khugepaged-remove-read_only_thp_for_fs-check.patch
mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch
mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch
mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch
mm-remove-read_only_thp_for_fs-kconfig-option.patch
mm-fs-remove-filemap_nr_thps-functions-and-their-users.patch
fs-remove-nr_thps-from-struct-address_space.patch
mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch
mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch
fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch

