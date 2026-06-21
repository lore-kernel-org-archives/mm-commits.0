Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CE93655CF
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067107; cv=none; b=LqAD05YZe/1r55oa3KCwXTwgBCop4NCcHmkYIRRX5HgAlynDrdsMuDlnWCCzF7fgwA6B5vcmPFQ2/eVlGbgPy3pGf0Uz+v1afPI2SVfyGkTIt6PtgGAB1HBVUYWmGXOfBESHuv9XPVdI/QykjRz76v0mRc4l/tXWrZhblfCF1DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067107; c=relaxed/simple;
	bh=hLTbJ+TGg6IY7IP/brk84bIJjjTZaPShCsIVHsNInXA=;
	h=Date:To:From:Subject:Message-Id; b=goMw/NKF/m7TeeINs1Mlj5hScX6G4wqwYOvj8w23iDckqUjYQpx7AIewc67438JEm65zN2PJewvFYnkGlzOcjfSczI4Kfp5FVRPckIW5gaU5+iVperay+5QWzNlH27zRzS0S784tkdaa7CPgo4nSUP79WgGBQ/F37ZvmDCFfnAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DCuAZz/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DCuAZz/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B121F00A3A;
	Sun, 21 Jun 2026 18:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067106;
	bh=p5INevSBeZhjp3RUS77RwkbAbTNHoEqaquvvJQVtNs8=;
	h=Date:To:From:Subject;
	b=DCuAZz/x3iTmOWMA89fdHwgTiw2It6/jqsTlDF87o1i/rtedJfqdHAeFi+2ln8rRN
	 dZ2n9k3ifijUepqCkQNsZtvJX1TCW0U9gWuD3k+sLG2Y1OPYVn/ZiZuZNAlLCibp3f
	 vsbxcqJDQeDQ4rbyrxOKj0vdik1n0iHh6ZVBwiv4=
Date: Sun, 21 Jun 2026 11:38:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,songliubraving@fb.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jack@suse.cz,dsterba@suse.com,dev.jain@arm.com,david@kernel.org,clm@fb.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch removed from -mm tree
Message-Id: <20260621183826.A2B121F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
Date: Sun, 17 May 2026 09:54:10 -0400

Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created
by a FS without large folio support.  The check is no longer needed.

Link: https://lore.kernel.org/20260517135416.1434539-9-ziy@nvidia.com
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
@@ -3763,33 +3763,9 @@ int folio_check_splittable(struct folio
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


