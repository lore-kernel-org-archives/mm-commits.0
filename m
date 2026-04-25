Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488822E040D
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 22:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777154817; cv=none; b=p+k+03QQ75KPnK04xAYBkcU+3cfUYU8MB3STPpOOTWMkxPv3jkleTRl5HaXw9azlIjdViWsaloCl/R/aXAjuwYg60SFnDzCUoPMsztDISTv8FrwZ7zTJaMGBT6WRifC3MdD14KP4Y62dSdXO0WB5/PBqJXvR1Mn0ZAD3qXVC4jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777154817; c=relaxed/simple;
	bh=SaeFq8ECjyrx+poaEHSWeKCSkA2PUCA20pmKrtSBaRU=;
	h=Date:To:From:Subject:Message-Id; b=ohfvarPPb11CSGiVOB+9G70JPCdSZUWUKIjM7mGo8UtkXvKAiQzDLLf22yZYLOI3ACam9p/EKoY3rJZLlUqKn8uwcNNu4adIXPPopDEyvTZqBRtUCztPv7ERfYyw3H7KFMetLIGow9SDkppU0aM4AARs98Bo7ekXqgK6t5vEGV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DtS8f6HD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DtS8f6HD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D255DC2BCB0;
	Sat, 25 Apr 2026 22:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777154816;
	bh=SaeFq8ECjyrx+poaEHSWeKCSkA2PUCA20pmKrtSBaRU=;
	h=Date:To:From:Subject:From;
	b=DtS8f6HDbk5ndWEqW4VXGml05KDl8nsnojW/7x/sPxLGm0NZLBh22rqmVtnNzmkOz
	 qZoPkCUhYK1DxV/wmmkULPyifYTato7uahJA8Jb8P0vYoMYs1MDj8mCsV/r+PVFSab
	 j44oA5Zr8d94D6/SM2LTSrhoLLyp6SxKrNScDo48=
Date: Sat, 25 Apr 2026 15:06:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch removed from -mm tree
Message-Id: <20260425220656.D255DC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Thu, 23 Apr 2026 22:49:06 -0400

Replace it with a check on the max folio order of the file's address space
mapping, making sure PMD THP is supported.  Also remove the read-only fd
check, since collapse_file() now makes sure all to-be-collapsed folios are
clean and the created PMD file THP can be handled by FSes properly.

Link: https://lore.kernel.org/20260424024915.28758-4-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
 
@@ -97,7 +94,10 @@ static inline bool file_thp_enabled(stru
 	if (IS_ANON_FILE(inode))
 		return false;
 
-	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
+	if (!mapping_pmd_thp_support(inode->i_mapping))
+		return false;
+
+	return S_ISREG(inode->i_mode);
 }
 
 /* If returns true, we are unable to access the VMA's folios. */
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch
mm-remove-read_only_thp_for_fs-kconfig-option.patch
mm-fs-remove-filemap_nr_thps-functions-and-their-users.patch
fs-remove-nr_thps-from-struct-address_space.patch
mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch
mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch
fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch

