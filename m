Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529833AA4E9
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 22:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779142928; cv=none; b=ais3/fekZwZCDVFmkbXr/tAvyXP+4cArTMgO0wDeSx57GbwaGyRhNRsAy2BhMynr8Sq5v2bRh5xE2xWSSfT15O3Yhb08ekUim0/EgCaJktY1I9/n61Xdu9CIzxrDxcDrI68yUYvBHEk09g1Bn5LHphsuZEkxF/VOl020pFeZn24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779142928; c=relaxed/simple;
	bh=WB1AQGq6R6HpoC1WTSjS6RHNLuJYzt6l9qG5l0qJNuY=;
	h=Date:To:From:Subject:Message-Id; b=jNSYkv0vDEA8OpbysB+rRsrU+zTM9lkbXaVWqk82LrzxCHVByBglRwIAChrv5tL76Wwrhv/YUcPYMFa49X+Erty1HrIS0Nx4Rs3Cch0pp3a04PEK5k1yAOTpScWBn1Mqkzc1DCY/01/CtdgzIuSDSeZJdluJV59WUhqhC5ANnkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DrMYPp3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DrMYPp3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B1BC2BCB7;
	Mon, 18 May 2026 22:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779142928;
	bh=WB1AQGq6R6HpoC1WTSjS6RHNLuJYzt6l9qG5l0qJNuY=;
	h=Date:To:From:Subject:From;
	b=DrMYPp3O7zXbl31kVgQWZ7B76G5PD8V4f9BjFvamZiEwImsXfE5bXvp71GEMxpDnS
	 u+FfaHw/HGw3NpE7/XuPaSRW6X6/xE+IQjRq1fOmudBV4ZKASzXNhtTu4A0C8Oix5q
	 bfu+xzDPZnk0YPSY9cByoIrcMh5fFuw+as1aaTzM=
Date: Mon, 18 May 2026 15:22:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch added to mm-unstable branch
Message-Id: <20260518222208.26B1BC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
has been added to the -mm mm-unstable branch.  Its filename is
     fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch

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
Subject: fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
Date: Sun, 17 May 2026 09:54:12 -0400

READ_ONLY_THP_FOR_FS is no longer present, remove related comment.

Link: https://lore.kernel.org/20260517135416.1434539-11-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Sterba <dsterba@suse.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
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
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/defrag.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/btrfs/defrag.c~fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs
+++ a/fs/btrfs/defrag.c
@@ -860,9 +860,6 @@ again:
 		return folio;
 
 	/*
-	 * Since we can defragment files opened read-only, we can encounter
-	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
-	 *
 	 * The IO for such large folios is not fully tested, thus return
 	 * an error to reject such folios unless it's an experimental build.
 	 *
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

