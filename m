Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E31399D0B
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141573; cv=none; b=qGjvm7o8omKt1n2UMpoZSCRUcZlhXLAMT+nWud2D94MeDuu18KOURjWHoS/GzQLordYGYWWplo28HLMoTmYJGCUhheth2FG7GzhWzkYZGArrzvBh4lNdb/W6NVeATiPSh1ts2e7kUWfHIx4NlfS6vGZ5y8UKZr9AJBUlPuFwa94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141573; c=relaxed/simple;
	bh=5fwlz0sc9mZaFp6EIuq2IJZrA0Np+RjpD9b0gYkHueY=;
	h=Date:To:From:Subject:Message-Id; b=ZGR2kFQDlR7JWmi1oy/Sb+Yy2XcxeehY2IeM1FFb7YqRlUlv/wf9+cVizX3Fico9Dy3BxRUZ/6+Cnfa2wOhfysCEUo6Own9RGDrgnFyFNIhihq9ARisRQf0HC1eFMKjTJupVxzY6AO6ZQ3n0T4iRFq0GK+ZLM/DesSDGhtaYKgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=etJhIy1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="etJhIy1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D588C2BCB7;
	Mon, 18 May 2026 21:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141573;
	bh=5fwlz0sc9mZaFp6EIuq2IJZrA0Np+RjpD9b0gYkHueY=;
	h=Date:To:From:Subject:From;
	b=etJhIy1AlvP2BdP7n1DvOUsBQgmQoM77NLnaTaAC93OTK5JpwEJT7ApvEWxZtk9r7
	 dbtSzJTimkwKe6HAT8OuMofykenpawhm15hqha9VZ3NSd9XnaUXFZCDYrHYpowDUzX
	 1/xMhTXD35K9vV+ddZglqjdLNy8TOylOL4o1jO2M=
Date: Mon, 18 May 2026 14:59:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch removed from -mm tree
Message-Id: <20260518215933.0D588C2BCB7@smtp.kernel.org>
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
Date: Wed, 29 Apr 2026 11:35:31 -0400

Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created
by a FS without large folio support.  The check is no longer needed.

Link: https://lore.kernel.org/20260429153538.727855-4-ziy@nvidia.com
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
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs
+++ a/mm/huge_memory.c
@@ -3846,33 +3846,9 @@ int folio_check_splittable(struct folio
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
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

