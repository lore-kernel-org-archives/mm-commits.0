Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39012571DD
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 22:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779142910; cv=none; b=KuNolaYITYN4qDZUArEXP5iOQCfHHRkfpFqSVfot6hSRMkJQXlJeoDjp6HeN2KR6CYsLNYPyERLrCVX3TUyU99XOQmW6oJlb6NzlwX1tF6rlVyVqf+eZla40RHbBKMjeiDdCP4L9mdjgboVBP/UoIi3rGmy22En10sAmD8x4MOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779142910; c=relaxed/simple;
	bh=GRPiNvoJrYTNHA4cN2RJtBH/ypDEvueZiCgQtkCI19g=;
	h=Date:To:From:Subject:Message-Id; b=jX/Ul7XdXmVasRPMbbrQXeCEHks95euQbksP7MYAT/5c9kTv+YrvIlScKsDEusQ/mYxGnpr96i9ndKPGxFpxlcPl53p1SCYlevPDZuYcCE2cFx/DokYoJS0cLVM1inpLTLAVCIzReYcCZBn4nhq88466B+3gI0bD6xjv3p53deQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=unb3IngP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="unb3IngP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B753C2BCB7;
	Mon, 18 May 2026 22:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779142909;
	bh=GRPiNvoJrYTNHA4cN2RJtBH/ypDEvueZiCgQtkCI19g=;
	h=Date:To:From:Subject:From;
	b=unb3IngPzCVBSxQwG52Zcso/C0mf56K+O9qbMbP45516DDc034HwKJqwYHkXnafRj
	 V2h/FpEbuf/GOuxiLHDoArJbis3Y2RH4h7uJod0UWfF+NtEW4GHw6nag7+7yU0CxGt
	 08HOXe+JyLFAS1zQZzvUBe2g7MkAePxJp6m/9Dl8=
Date: Mon, 18 May 2026 15:21:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch added to mm-unstable branch
Message-Id: <20260518222149.8B753C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch

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
Subject: mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Sun, 17 May 2026 09:54:05 -0400

Replace it with a check on the max folio order of the file's address space
mapping, making sure PMD folio is supported.  Keep the inode
open-for-write check, since even if collapse_file() now makes sure all
to-be-collapsed folios are clean and the created PMD file THP can be
handled by FSes properly, the filemap_flush() could perform undesirable
write back.

Link: https://lore.kernel.org/20260517135416.1434539-4-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled
+++ a/mm/huge_memory.c
@@ -86,9 +86,6 @@ static inline bool file_thp_enabled(stru
 {
 	struct inode *inode;
 
-	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
-		return false;
-
 	if (!vma->vm_file)
 		return false;
 
@@ -97,6 +94,9 @@ static inline bool file_thp_enabled(stru
 	if (IS_ANON_FILE(inode))
 		return false;
 
+	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
+		return false;
+
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
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

