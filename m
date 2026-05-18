Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA363ABD88
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 22:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779142935; cv=none; b=RuUt2RUk94ZgxeEqeXngEtU7QBoIKyYWhPZX6kfm1YJvJsHS/VE3Zx2DkXmzOJemAMoZ90+pY+OWBn4wRZOrsSHprZs2F5l08SElpmN/KvaKmmB7BnEONVQD6drth8o2aR/T7ruBBzhyjdBSaPd3dpGBrOSWOS4ygHPhukUN920=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779142935; c=relaxed/simple;
	bh=G5XJILAcw6TtW0t2K0tTLGTKR5u0JHwRPIYvUsa3Mos=;
	h=Date:To:From:Subject:Message-Id; b=OKgWXf0EEGjYrmavKqAH2ab+IiEugMKDc7SC9A7daluAXnkHkj8EUeM96gYJxRMMlQnIQakRQpmAgv3Cg8Pxcid6Gij9gnm/9tcpzmoIHvDMmCPylSIzsI8bxRJoaQrz5fLeq05cnIzkaAgzTpp1XP+XYmZFcxjOxciIpRb9vCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hLq4IAnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hLq4IAnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D57C2BCB7;
	Mon, 18 May 2026 22:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779142935;
	bh=G5XJILAcw6TtW0t2K0tTLGTKR5u0JHwRPIYvUsa3Mos=;
	h=Date:To:From:Subject:From;
	b=hLq4IAnYk67mhlerMeE8kOFjjgEkAx7ZdoJ1aiZNuQ41qTdatIJHbmsTZayq26VoF
	 lRvcllFOs6ER0PclOIpmiE28EO8EZbdSW4O5DeqpfrPMXcLaruwc0zs7yq65g1w9Dk
	 moMx8LiDETlCfTMD4vjbyW9mteZ4VLRB13QVJXC8=
Date: Mon, 18 May 2026 15:22:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch added to mm-unstable branch
Message-Id: <20260518222215.54D57C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: enable clean pagecache folio collapse for writable files
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/khugepaged: enable clean pagecache folio collapse for writable files
Date: Sun, 17 May 2026 09:54:15 -0400

collapse_file() is capable of collapsing pagecache folios from writable
files to PMD folios.  Now enable clean pagecache folio collapse in
addition to read-only pagecache folio collapse by removing the
inode_is_open_for_write() from file_thp_enabled() and only performing
filemap_flush() if the file is read-only.

This means userspace needs to explicitly flush the content of pagecache
folios before khugepaged can collapse the folios, or use
madvise(MADV_COLLAPSE), which does the flush in the retry.  The reason is
that blindly enabling dirty pagecache folio from writable files collapse
makes khugepaged flush these folios all the time.  It is undesirable to
cause system level pagecache flushes.

To properly support dirty pagecache folio collapse, filemap_flush() needs
to be avoided.  Potentially, merging associated buffer instead of dropping
it with filemap_release_folio() might be needed.

NOTE: this breaks khugepaged selftests for writable file pagecache
collapse, which is set to fail all the time.  The next commit fixes it.

Link: https://lore.kernel.org/20260517135416.1434539-14-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
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

 mm/huge_memory.c |    2 +-
 mm/khugepaged.c  |   15 +++++++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files
+++ a/mm/huge_memory.c
@@ -97,7 +97,7 @@ static inline bool file_thp_enabled(stru
 	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
 		return false;
 
-	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
+	return S_ISREG(inode->i_mode);
 }
 
 /* If returns true, we are unable to access the VMA's folios. */
--- a/mm/khugepaged.c~mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files
+++ a/mm/khugepaged.c
@@ -2342,18 +2342,21 @@ static enum scan_result collapse_file(st
 			} else if (folio_test_dirty(folio)) {
 				/*
 				 * This page is dirty because it hasn't
-				 * been flushed since first write. There
-				 * won't be new dirty pages.
+				 * been flushed since first write.
 				 *
-				 * Trigger async flush here and hope the
-				 * writeback is done when khugepaged
-				 * revisits this page.
+				 * Trigger async flush for read-only files and
+				 * hope the writeback is done when khugepaged
+				 * revisits this page. Writable files can have
+				 * their folios dirty at any time; blindly
+				 * flushing them would cause undesirable
+				 * system-wide writeback.
 				 *
 				 * This is a one-off situation. We are not
 				 * forcing writeback in loop.
 				 */
 				xas_unlock_irq(&xas);
-				filemap_flush(mapping);
+				if (!inode_is_open_for_write(mapping->host))
+					filemap_flush(mapping);
 				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 				goto xa_unlocked;
 			} else if (folio_test_writeback(folio)) {
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

