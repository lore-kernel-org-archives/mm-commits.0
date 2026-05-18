Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1142571DD
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 22:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779142915; cv=none; b=edRsctJnVuEOZXjtFzVihQ2XCgSvsebvR1rl9ZWRUU1rknhk+Gyz4kqbA2qMn4nk0r7YaXTWYTVjVWnKtUUXDXYFSraIhSHVHa9t1gn8d1r5+kCr1/4NxU6c+gscOm+zkdeJf2+br3zqQMYQH6Ed+pPJAB2NGat8Q+fOnHE0vqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779142915; c=relaxed/simple;
	bh=/qs0Rq7vuTbInpMCVgG72h/TaCZCRkNP3IPM9K2ttU4=;
	h=Date:To:From:Subject:Message-Id; b=lX16cL5+AmmX292TlrHnomQ/kfzTvKL79axS+BzaexvjVyZk6tWTDVUKQs3kxT865zXbYH4LqwrJ7c/kkhCfzRrB6B6SkXGUpTbo/n4lTYWw6eh7KInPxd3OxayFRecFn4G+DOYDPUVc4TSUZrp2YzNxQGqOsGIUdPOotVHPIGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b20Klft1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b20Klft1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826A0C2BCB7;
	Mon, 18 May 2026 22:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779142914;
	bh=/qs0Rq7vuTbInpMCVgG72h/TaCZCRkNP3IPM9K2ttU4=;
	h=Date:To:From:Subject:From;
	b=b20Klft1RTZvIYgzjS0UjKda/mJ39V0/sFlnTh0LvraEGfSYZOgXkXUaqwMWuPWWV
	 UfBU8My7BtSXR0kYuX1UADEtahv4tVjIHmM0U+O06GQDryGIDF01x5Hvd50QqizVjg
	 Mr1jtYIPpwwLtlZKxc0Zet45UhjGf8oc8nY1Yans=
Date: Mon, 18 May 2026 15:21:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-read_only_thp_for_fs-kconfig-option.patch added to mm-unstable branch
Message-Id: <20260518222154.826A0C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove READ_ONLY_THP_FOR_FS Kconfig option
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-read_only_thp_for_fs-kconfig-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-read_only_thp_for_fs-kconfig-option.patch

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
Subject: mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Sun, 17 May 2026 09:54:07 -0400

After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
support even without READ_ONLY_THP_FOR_FS enabled.  Remove the Kconfig
first so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits
remove mapping->nr_thps, which its safe guard mechanism relies on.

Link: https://lore.kernel.org/20260517135416.1434539-6-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
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

 mm/Kconfig |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/Kconfig~mm-remove-read_only_thp_for_fs-kconfig-option
+++ a/mm/Kconfig
@@ -936,17 +936,6 @@ config THP_SWAP
 
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
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

