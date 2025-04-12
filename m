Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E1B134D4;
	Sat, 12 Apr 2025 00:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744417999; cv=none; b=ikOcaMzfHxHEXT5JsBcVCoLWAE3QhWBS0l0Wmljdjg0ZuGP3/+aYlCWmm6+VAF5tOCQD6OwDYfrnhBBwq3sabpmxOgFz3ZKM7UZHnPQ5qklPNVjCbYzNWSYf6Jh7QHGf2Q3CXwz2UMOAgJRIv8X3ZuVTXya6jLLJVcop2ZYcIz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744417999; c=relaxed/simple;
	bh=xGzU0X7SRCBDAJO5suzOf72w3/oxaM40udUpJZaDZCc=;
	h=Date:To:From:Subject:Message-Id; b=jZCWkjbAYBzLIXzLf8MypR36lwDgluUeLwKxbZUlGCb46y8aOni9eoXVEnMHKsAGh0eDwg+nkri4wunWIuW1Ef7fMU+Ob+qyYbmeeZUKBm4Dhk9Bb7wkeaT4c5eEL5tOsIdDxauDX771dT4AXTh0ipWq3LjoaXXetHQ0mg2d6ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nKi2sVtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nKi2sVtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE24C4CEE2;
	Sat, 12 Apr 2025 00:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744417998;
	bh=xGzU0X7SRCBDAJO5suzOf72w3/oxaM40udUpJZaDZCc=;
	h=Date:To:From:Subject:From;
	b=nKi2sVtJY6TUiDHb21x6fMpDtTeKluMNcY7WRt2+1wKaPpxpBwF1Hh3BIquz/GQ9s
	 v1FT0C9TY5SauaZRBXkkrZCQnRnSuF9MC/Cq3jYEGE1MP3W9UPU4lxBqC86neuh69D
	 jo7vkyZGWUXQcmxgEZPZh50CqL4xN+O75jZJKH3E=
Date: Fri, 11 Apr 2025 17:33:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-compaction-fix-bug-in-hugetlb-handling-pathway.patch removed from -mm tree
Message-Id: <20250412003318.BBE24C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/compaction: fix bug in hugetlb handling pathway
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-bug-in-hugetlb-handling-pathway.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/compaction: fix bug in hugetlb handling pathway
Date: Mon, 31 Mar 2025 19:10:24 -0700

The compaction code doesn't take references on pages until we're certain
we should attempt to handle it.

In the hugetlb case, isolate_or_dissolve_huge_page() may return -EBUSY
without taking a reference to the folio associated with our pfn.  If our
folio's refcount drops to 0, compound_nr() becomes unpredictable, making
low_pfn and nr_scanned unreliable.  The user-visible effect is minimal -
this should rarely happen (if ever).

Fix this by storing the folio statistics earlier on the stack (just like
the THP and Buddy cases).

Also revert commit 66fe1cf7f581 ("mm: compaction: use helper compound_nr
in isolate_migratepages_block") to make backporting easier.

Link: https://lkml.kernel.org/r/20250401021025.637333-1-vishal.moola@gmail.com
Fixes: 369fa227c219 ("mm: make alloc_contig_range handle free hugetlb pages")
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-fix-bug-in-hugetlb-handling-pathway
+++ a/mm/compaction.c
@@ -981,13 +981,13 @@ isolate_migratepages_block(struct compac
 		}
 
 		if (PageHuge(page)) {
+			const unsigned int order = compound_order(page);
 			/*
 			 * skip hugetlbfs if we are not compacting for pages
 			 * bigger than its order. THPs and other compound pages
 			 * are handled below.
 			 */
 			if (!cc->alloc_contig) {
-				const unsigned int order = compound_order(page);
 
 				if (order <= MAX_PAGE_ORDER) {
 					low_pfn += (1UL << order) - 1;
@@ -1011,8 +1011,8 @@ isolate_migratepages_block(struct compac
 				 /* Do not report -EBUSY down the chain */
 				if (ret == -EBUSY)
 					ret = 0;
-				low_pfn += compound_nr(page) - 1;
-				nr_scanned += compound_nr(page) - 1;
+				low_pfn += (1UL << order) - 1;
+				nr_scanned += (1UL << order) - 1;
 				goto isolate_fail;
 			}
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-compaction-use-folio-in-hugetlb-pathway.patch

