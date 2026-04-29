Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D053FFADD
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 16:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777479195; cv=none; b=bqvYPgnad6t3+WVWHWsCcTZ2gFjMNPLy0HAehI+OrSFjx8W/b2FRRinPdpHbvf1G4zM12tCDRlq2RHb+VBNXziToD2K6wjIxyvlzfQTRlso5yLfm1qvvYao4t19P4FGOKIqtZfIv1Fd5VwPIX3qpN3EbxkUyze9mo3CNAzq9hoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777479195; c=relaxed/simple;
	bh=193mDcdArseZc0caGDYM+eQTQDdg5uX7Yoek6wUiTPc=;
	h=Date:To:From:Subject:Message-Id; b=dc0ALyb23UqTfjg4qF+iQlPQZtaAv+ioXENJWfL1cNfvXWtWUm2V4PaSvJhlDMY2AYtJ8Ft9GKBUara+s9LLviPHGlT725HJhvYaKtwfoRVx8lWH2Jr9PfgTBLySZMMhS2QnplqYi82VYvdMWhz1lDt2UO1q7IJowBtgpwwtk/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nYG+dVCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nYG+dVCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A74C2BCC4;
	Wed, 29 Apr 2026 16:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777479195;
	bh=193mDcdArseZc0caGDYM+eQTQDdg5uX7Yoek6wUiTPc=;
	h=Date:To:From:Subject:From;
	b=nYG+dVCSj9ew9rvRMDf7Eo3fmhci3tkttqaRxgy3HBLu9fu7Y0nw0BXW0vXxiFXjx
	 3vObHULZYG0Epw8i8wBndQ4IgkUDi1XDfuLqopCXH3eBm9KQCZnq7KNMmJtWm9ICSf
	 iEBu+6IpNI43knS9pFF0gD3webgCzgqW8zchg8nw=
Date: Wed, 29 Apr 2026 09:13:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-remove-read_only_thp_for_fs-check.patch added to mm-new branch
Message-Id: <20260429161315.51A74C2BCC4@smtp.kernel.org>
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
Date: Wed, 29 Apr 2026 11:29:11 -0400

Patch series "Remove CONFIG_READ_ONLY_THP_FOR_FS and enable file THP for
writable files", v5.

This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
file-backed THPs for FSes with large folio support (the supported orders
need to include PMD_ORDER) by default, including for writable files.


This patch (of 14):

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
 large folio FSes (read-only fd)  |     ✓     |       ✓       |      ✓     |
 large folio FSes (read-write fd) |     ✓     |       ✓       |      ✓*    |
 no large folio FSes              |     x     |       x       |      x     |

* khugepaged only collapses clean folios from writable files. Userspace
  must flush dirty folios explicitly before khugepaged can collapse them.
  MADV_COLLAPSE handles the flush automatically via its writeback-and-retry
  path. Collapsing writable MAP_PRIVATE pagecache folios is still not
  supported, since PMD THP CoW only faults in at PTE level to avoid long
  CoW latency, and file_backed_vma_is_retractable() prevents it.

This means no-large-folio FSes need to add large folio support (the
supported orders need to include PMD_ORDER), so that they can leverage
file THP creation.

To prevent breaking file THP support for large folio FSes,
1. first 4 patches enable the support, so that without READ_ONLY_THP_FOR_FS,
   file THP still works for large folio FSes,
2. Patch 5 removes READ_ONLY_THP_FOR_FS Kconfig,
3. patches 6-12 remove code related to READ_ONLY_THP_FOR_FS,
4. patches 13-14 enable clean pagecache folio collapse for writable files.


NOTE: collapsing writable MAP_PRIVATE pagecache folios is not supported,
since:
1. PMD THP CoW only faults in at PTE level to avoid long CoW latency,
2. the first check, due to 1, in file_backed_vma_is_retractable() prevents it.


Overview
========

1. collapse_file() checks for to-be-collapsed folio dirtiness after they
   are locked and unmapped to make sure no new write happens. Before,
   mapping->nr_thps and inode->i_writecount were used to cause read-only
   THP truncation before a fd becomes writable.

2. hugepage_enabled() is true for anon, shmem, and file-backed cases
   if the global khugepaged control is on, otherwise, khugepaged for
   file-backed case is turned off and anon and shmem depend on per-size
   control knobs.

3. collapse_file() from mm/khugepaged.c, instead of checking
   CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
   of struct address_space of the file is at least PMD_ORDER.

4. file_thp_enabled() checks mapping_max_folio_order() instead of
   CONFIG_READ_ONLY_THP_FOR_FS and no longer checks if the file is opened
   read-only. The dirty folio check after try_to_unmap() (Change 1)
   handles writable files correctly.

5. truncate_inode_partial_folio() calls folio_split() directly instead
   of the removed try_folio_split_to_order(), since large folios can
   only show up on a FS with large folio support.

6. nr_thps is removed from struct address_space, since it is no longer
   needed to drop all read-only THPs from a FS without large folio
   support when the fd becomes writable. Its related filemap_nr_thps*()
   are removed too.

7. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.

8. collapse_file() only calls filemap_flush() for read-only files.
   Blindly flushing dirty folios from writable files would cause
   undesirable system-wide writeback; userspace is expected to flush
   explicitly, or use MADV_COLLAPSE which handles it via its retry path.

9. Updated comments and selftests in various places.


This patch (of 14):

collapse_file() requires FSes supporting large folio with at least
PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. 
MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.

While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.

Add a helper function mapping_pmd_folio_support() for FSes supporting
large folio with at least PMD_ORDER.

Link: https://lore.kernel.org/20260429152924.727124-1-ziy@nvidia.com
Link: https://lore.kernel.org/20260429152924.727124-2-ziy@nvidia.com
Link: https://lore.kernel.org/all/20260323190644.1714379-1-ziy@nvidia.com/ [1]
Link: https://lore.kernel.org/all/20260327014255.2058916-1-ziy@nvidia.com/ [2]
Link: https://lore.kernel.org/all/20260413192030.3275825-1-ziy@nvidia.com/ [3]
Link: https://lore.kernel.org/all/20260418024429.4055056-1-ziy@nvidia.com/ [4]
Link: https://lore.kernel.org/all/20260424024915.28758-1-ziy@nvidia.com/ [5]
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
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   26 ++++++++++++++++++++++++++
 mm/khugepaged.c         |   10 ++++++++--
 2 files changed, 34 insertions(+), 2 deletions(-)

--- a/include/linux/pagemap.h~mm-khugepaged-remove-read_only_thp_for_fs-check
+++ a/include/linux/pagemap.h
@@ -513,6 +513,32 @@ static inline bool mapping_large_folio_s
 	return mapping_max_folio_order(mapping) > 0;
 }
 
+/**
+ * mapping_pmd_folio_support() - Check if a mapping support PMD-sized folio
+ * @mapping: The address_space
+ *
+ * Some file supports large folio but does not support as large as PMD order.
+ * If a PMD-sized pagecache folio is attempted to be created on a filesystem,
+ * this check needs to be performed first.
+ *
+ * Return: true - PMD-sized folio is supported, false - PMD-sized folio is not
+ * supported.
+ */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
+{
+	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
+	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
+
+	return mapping_max_folio_order(mapping) >= PMD_ORDER;
+}
+#else
+static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
+{
+	return false;
+}
+#endif
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
+	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
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
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

