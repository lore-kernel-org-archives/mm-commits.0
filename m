Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DC437FF73
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 22:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777154820; cv=none; b=KQpYTORZTXZJNzOQM09lxFPGJmw7mmS14Pee3HEbAORs0cwskbn+vzxlY1gvkuC1qCGqjgzSm09LDge5O6dQ3Ukl7Py2fYyiz/lQhFUg1xHSHPgA56O9T4VhSJOrdHKcKqCrgUjlmGzSrPw/8KizjLoV8k/KRnij+976uDIVZI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777154820; c=relaxed/simple;
	bh=i48wrfbfOg9p75Upc8XJ66Ea3zp7XZmuIazGUS1fn9A=;
	h=Date:To:From:Subject:Message-Id; b=Vynf+n9gYpESIxdnAI/8mxQQC0YEFfT2xvAxyZob0N56IkIFkkVW99oSWkPipFto+ky+/v0SD3TxeEuz1ZMMDG/tGghhxCGVIInFz6+I/dweXVo8s2HTIcQkH99Dj65pPCfNYT/bGB3cQ8tXlph645QVktyxqDkObUimzxGQM4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pl0Q+0QS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pl0Q+0QS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96886C2BCB0;
	Sat, 25 Apr 2026 22:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777154819;
	bh=i48wrfbfOg9p75Upc8XJ66Ea3zp7XZmuIazGUS1fn9A=;
	h=Date:To:From:Subject:From;
	b=Pl0Q+0QS4NQw6BTW2hG1urQ2SRuev8Sych3TsWu828IOshh5KHF8GbzK9ZsdCyetZ
	 M49NiICsxoSWCucoCn0O7KDC4Z/x6LjoHDciwSrFXkNAk2oJJc0Ambb3hytLBDmXA4
	 Y70c4+C0tGWJK7te2sgSvmWG15etKLxoGvkVOxro=
Date: Sat, 25 Apr 2026 15:06:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-read_only_thp_for_fs-kconfig-option.patch removed from -mm tree
Message-Id: <20260425220659.96886C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove READ_ONLY_THP_FOR_FS Kconfig option
has been removed from the -mm tree.  Its filename was
     mm-remove-read_only_thp_for_fs-kconfig-option.patch

This patch was dropped because an updated version will be issued

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

mm-fs-remove-filemap_nr_thps-functions-and-their-users.patch
fs-remove-nr_thps-from-struct-address_space.patch
mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch
mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch
fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch

