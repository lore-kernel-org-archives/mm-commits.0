Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062CF4014B8
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 16:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777479228; cv=none; b=uvlSYDMQJYZVjENlKqwlMNFzM57SiDPrdFHDvfIfm0TdlC1vPOSMnZ7l8HMjtnIOm8kTR0VW8jpYfiW4JfzkMcgL0U196WTkrFJ3qyd3VXax1wSA7K1PBTn9i53oAI1kDnvLiDag7ont3c8yzf42Y/m7qisC9CT1cHntd2603cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777479228; c=relaxed/simple;
	bh=MZFVIbiZn/PiZiqPilU6dIT/a2Z3v3vk2IYXt4uGgoU=;
	h=Date:To:From:Subject:Message-Id; b=onyZ01rtcsMxTkkMAerOHsGJ4QGt+W4j4apRfkNYLsN2/stxmTrKqAHyu/RrvSOgZDZyWMFsb7DK26OiVG+8kgG3Tv+yW5oFwMD1DDN3uRJ7T8lDacWWw277RTRLvZPkOLB8TzlpFPZBaY2Agyqr2G57eBSbVS66Tcyh46HLqlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=am+oYBnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="am+oYBnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C84C19425;
	Wed, 29 Apr 2026 16:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777479226;
	bh=MZFVIbiZn/PiZiqPilU6dIT/a2Z3v3vk2IYXt4uGgoU=;
	h=Date:To:From:Subject:From;
	b=am+oYBnrU9YVx8ZH+mOivG5wnTSf56C2etoJ2gbX72sADWnRK94MHsieylp/n7oMp
	 K1CaUXiTCC1raHSSdaZqznKl3A5AB3kcA15LtfJsgxYtxyKSPZ3h+mL2/1MH0vM6AO
	 7qHJFlUThr+g/E7u87ubm+8vgwLHVom7Ci5qdqcc=
Date: Wed, 29 Apr 2026 09:13:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch added to mm-new branch
Message-Id: <20260429161346.86C84C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: enable clean pagecache folio collapse for writable files
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch

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
Subject: mm/khugepaged: enable clean pagecache folio collapse for writable files
Date: Wed, 29 Apr 2026 11:35:36 -0400

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

Link: https://lore.kernel.org/20260429153538.727855-9-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
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
 mm/khugepaged.c  |    9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

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
@@ -2345,7 +2345,14 @@ static enum scan_result collapse_file(st
 				 * forcing writeback in loop.
 				 */
 				xas_unlock_irq(&xas);
-				filemap_flush(mapping);
+				/*
+				 * Only flush for read-only files. Writable
+				 * files can have their folios dirty at any
+				 * time; blindly flushing them would cause
+				 * undesirable system-wide writeback.
+				 */
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

