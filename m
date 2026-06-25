Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DCF8635D
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 02:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782353605; cv=none; b=IwhMEtn5sZKMNnPTnZuMYJHJDOqiK7tmXLAZoiiwMrjqswLnf7QrXI9HswXFxOWOlopqxg7lBYg3EfMVgT+Q4aUV4hrLCFNeQfltQHztlxHPIekAe35dUdB0nBrxUfjwMh59VjUeoV0OP5QOzJlWOB7NiGvesbkyXi6pyAQ7tDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782353605; c=relaxed/simple;
	bh=gA8wV9RdsMJZ1riZ1zpDhEsJ+wC85exmNV/YsabRE3c=;
	h=Date:To:From:Subject:Message-Id; b=W+TWlc2UHCHwWRMyWN9kMRAF8pbS+tmEqyY0endn9QpQNgffmbMmR82Jnp7e95OT2qJkUqBRsHzrxmDx6rVEbAqTX0TQfEk+gDafaE/ZIbc01Grx6XW46VySDeTzIh65cdeTv/rhSXor0OJzfgB8txzEuhYgLtpC6cBfRKszt9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QEvYY7tH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QEvYY7tH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E89B1F000E9;
	Thu, 25 Jun 2026 02:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782353603;
	bh=b6gAUN4tJ5Qzo5Ongr9Ec84vOo/SN/HAlTtTa6VtuCM=;
	h=Date:To:From:Subject;
	b=QEvYY7tHhI4KQRItBVPyu54pgb1yUXDHKuCJJyNIMYmZdFTbqztTRyZUgPoe3Y4eu
	 XrS3S+01E67ww9sel/H5NmJy8MmisiVRosCJ7M1UdeCtyA9aZoYAaUSEFND1j7KaQa
	 YCHuiGS/mssxbI0vh1XBWV1Za3UDq2sUsQcKvzDs=
Date: Wed, 24 Jun 2026 19:13:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,sj@kernel.org,david@kernel.org,chengming.zhou@linux.dev,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pagetranscompound.patch added to mm-new branch
Message-Id: <20260625021323.7E89B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageTransCompound()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-pagetranscompound.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pagetranscompound.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: remove PageTransCompound()
Date: Thu, 18 Jun 2026 19:35:23 +0800

Remove the last user of PageTransCompound() in ksm and get rid of
PageTransCompound().

Link: https://lore.kernel.org/20260618113523.3913307-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
Tested-by: Xu Xin <xu.xin16@zte.com.cn>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   14 --------------
 mm/ksm.c                   |   17 +++++++++--------
 2 files changed, 9 insertions(+), 22 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pagetranscompound
+++ a/include/linux/page-flags.h
@@ -879,20 +879,6 @@ FOLIO_FLAG_FALSE(partially_mapped)
 
 #define PG_head_mask ((1UL << PG_head))
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-/*
- * PageTransCompound returns true for both transparent huge pages
- * and hugetlbfs pages, so it should only be called when it's known
- * that hugetlbfs pages aren't involved.
- */
-static inline int PageTransCompound(const struct page *page)
-{
-	return PageCompound(page);
-}
-#else
-TESTPAGEFLAG_FALSE(TransCompound, transcompound)
-#endif
-
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
 /*
  * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
--- a/mm/ksm.c~mm-remove-pagetranscompound
+++ a/mm/ksm.c
@@ -2327,23 +2327,24 @@ static void cmp_and_merge_page(struct pa
 	tree_rmap_item =
 		unstable_tree_search_insert(rmap_item, page, &tree_page);
 	if (tree_rmap_item) {
+		struct folio *tree_folio;
 		bool split;
 
 		kfolio = try_to_merge_two_pages(rmap_item, page,
 						tree_rmap_item, tree_page);
+		tree_folio = page_folio(tree_page);
 		/*
-		 * If both pages we tried to merge belong to the same compound
-		 * page, then we actually ended up increasing the reference
-		 * count of the same compound page twice, and split_huge_page
-		 * failed.
+		 * If both pages we tried to merge belong to the same (large)
+		 * folio, then we actually ended up increasing the reference
+		 * count of the same folio twice, and split_huge_page failed.
+		 *
 		 * Here we set a flag if that happened, and we use it later to
-		 * try split_huge_page again. Since we call put_page right
+		 * try split_huge_page again. Since we call folio_put() right
 		 * afterwards, the reference count will be correct and
 		 * split_huge_page should succeed.
 		 */
-		split = PageTransCompound(page)
-			&& compound_head(page) == compound_head(tree_page);
-		put_page(tree_page);
+		split = folio == tree_folio;
+		folio_put(tree_folio);
 		if (kfolio) {
 			/*
 			 * The pages were successfully merged: insert new
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-pagetranscompound.patch

