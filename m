Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EC53803E9
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 22:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777154823; cv=none; b=VXMk0XAQ4PMyc3ug29KzoS48r67iaGM+rA32WvuA7xNGNOsTIc52/QbYMvECSf+D9cEiLyoyZEzRHUmXx38Xf9O6y/jt6f50Q5qwzfKaivc6Y1f9RW+Q+jUh/Hd1EL9j57iPMjZqDIk11fXz+tjlq2fCp0kDzFtUDGGVQcPxnKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777154823; c=relaxed/simple;
	bh=KHZXA88vQ+wsVN/mo2n2xf84MFYwhw9jvZEBYQdjLYc=;
	h=Date:To:From:Subject:Message-Id; b=HiVuTD9CXULUkp2iF7o3QRXlxnGzjx2tT4uqoyys41WudLv9Yta8PNIcmaFhjKzMGqsjF2W+ouq5vGAL8w76NigFbE1LRYBm5YwIqAGopySx2WbydAe41XxXhhSoAyfEYCGwJilgFWtqLSdJDM+H4XT/twOvoOB54D6AfQnMF0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GODgAiGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GODgAiGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF241C2BCB0;
	Sat, 25 Apr 2026 22:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777154823;
	bh=KHZXA88vQ+wsVN/mo2n2xf84MFYwhw9jvZEBYQdjLYc=;
	h=Date:To:From:Subject:From;
	b=GODgAiGtYHxXaG5+78dbLfIrcGzjwgP8N+6WMzYfrTv0aMHYFZYSiDaXCOERiHSrh
	 soCWx+uXzZH47Epfn++N13AW76sOFoaVwCNFAOYp2Kg+hBDd+plQxqHiVRKTNaOp4b
	 rSCesrZ5lYB/mNptTDs5eTt6cVqWKtvUAzN+Dj4s=
Date: Sat, 25 Apr 2026 15:07:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch removed from -mm tree
Message-Id: <20260425220703.AF241C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
Date: Thu, 23 Apr 2026 22:49:11 -0400

Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created
by a FS without large folio support.  The check is no longer needed.

Link: https://lore.kernel.org/20260424024915.28758-9-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs
+++ a/mm/huge_memory.c
@@ -3832,33 +3832,9 @@ int folio_check_splittable(struct folio
 	if (!folio->mapping && !folio_test_anon(folio))
 		return -EBUSY;
 
-	if (folio_test_anon(folio)) {
-		/* order-1 is not supported for anonymous THP. */
-		if (new_order == 1)
-			return -EINVAL;
-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-		    !mapping_large_folio_support(folio->mapping)) {
-			/*
-			 * We can always split a folio down to a single page
-			 * (new_order == 0) uniformly.
-			 *
-			 * For any other scenario
-			 *   a) uniform split targeting a large folio
-			 *      (new_order > 0)
-			 *   b) any non-uniform split
-			 * we must confirm that the file system supports large
-			 * folios.
-			 *
-			 * Note that we might still have THPs in such
-			 * mappings, which is created from khugepaged when
-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
-			 * case, the mapping does not actually support large
-			 * folios properly.
-			 */
-			return -EINVAL;
-		}
-	}
+	/* order-1 is not supported for anonymous THP. */
+	if (folio_test_anon(folio) && new_order == 1)
+		return -EINVAL;
 
 	/*
 	 * swapcache folio could only be split to order 0
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch
fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch

