Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0990630BF52
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 10:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777026665; cv=none; b=EXBv5iBxqhDPhFgSnuoqzZICAeujHy8sgzWdYNEvwwztEeGuKwhp7S1kyWuDGKAYthfL3CuiGo1oahHHMUZCEex0Aed+NROUi7kenkBb/iZ1x15S/FUI97eP8LJB1SBuZ3qZKAPYe/NQcvHIpaJzx4ol6USE/95Ts32LK6AsKY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777026665; c=relaxed/simple;
	bh=xXmLQW6t3aIOIG/L/7SU+g8qLHM/tyoykIL1rXWSUSw=;
	h=Date:To:From:Subject:Message-Id; b=Ve9DnoFi2q/r2pQGEuLSAUPOf1gLmO/DK0zM2hL5yyIepUHzL6OeXtSrBXbq8zESvYZYKdpo7E0Ja8TpO9DIAvgN6KVCYZdbMcj2BU37o4oezVV0jLlKBs9btPO2izrADXtPMdK1QGWqKf+oyV3OqEtZjcnYntaIn4RjVMizmHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XpVOgvX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XpVOgvX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CD9C19425;
	Fri, 24 Apr 2026 10:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777026664;
	bh=xXmLQW6t3aIOIG/L/7SU+g8qLHM/tyoykIL1rXWSUSw=;
	h=Date:To:From:Subject:From;
	b=XpVOgvX2gJ8lEQXjIRBtkuEB/6yTjJJzzRoRYQc/xQmjCAiPX2s5+cZU3wbGfm7zf
	 XFl1gG4o9IM9X/Fi0C20tyyefl1om5s4NVL1jwL4ysmQ4Hx4B2pP1Ez7MMJoyIfKvz
	 f9mw75ji4SADy/1JAaozjTHuHcGrTjGGDujzBqRE=
Date: Fri, 24 Apr 2026 03:31:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-read_only_thp_for_fs-kconfig-option.patch added to mm-new branch
Message-Id: <20260424103104.88CD9C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove READ_ONLY_THP_FOR_FS Kconfig option
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-read_only_thp_for_fs-kconfig-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-read_only_thp_for_fs-kconfig-option.patch

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
Subject: mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Thu, 23 Apr 2026 22:49:08 -0400

After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
support even without READ_ONLY_THP_FOR_FS enabled.  Remove the Kconfig
first so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits
remove mapping->nr_thps, which its safe guard mechanism relies on.

Link: https://lore.kernel.org/20260424024915.28758-6-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
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

 mm/Kconfig |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/Kconfig~mm-remove-read_only_thp_for_fs-kconfig-option
+++ a/mm/Kconfig
@@ -938,17 +938,6 @@ config THP_SWAP
 
 	  For selection by architectures with reasonable THP sizes.
 
-config READ_ONLY_THP_FOR_FS
-	bool "Read-only THP for filesystems (EXPERIMENTAL)"
-	depends on TRANSPARENT_HUGEPAGE
-
-	help
-	  Allow khugepaged to put read-only file-backed pages in THP.
-
-	  This is marked experimental because it is a new feature. Write
-	  support of file THPs will be developed in the next few release
-	  cycles.
-
 config NO_PAGE_MAPCOUNT
 	bool "No per-page mapcount (EXPERIMENTAL)"
 	help
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

