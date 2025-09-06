Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CB7315D38
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 00:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757119621; cv=none; b=de0xu+Sj04i9ByfG4xgGBlLsbGYgspUW3oPlZUB7Ynu7bGqgbVvPQ64bsdMreB1fw6t2dgB0hcyRZ39gK9HapqRwLQVjgznY1LWLjObJ3boSUoICVSanI40TqEz7kBHWm3Vv3BzM20waykKE4RknjtbS4/WRK7SgEBoDNA+iy0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757119621; c=relaxed/simple;
	bh=AYqshsVd4VcFyoLZ1LSFke6W8I3pcH45fJoq43vYotY=;
	h=Date:To:From:Subject:Message-Id; b=uJxnKT/PMnYpJA189xvoIhbYtkexLNC8N1UekTu1Cuk4mjOZIhD1MaSg2nYSE+xIQxwShlESKy+0txi8fs3ZY7gbnsshZreNkJ/OApUAYwXoIYpJhzP6RPfafA5WuqOYFnWQeo1zjluJDSt2Z6RYEjv3i/qHDuFYJ55Fuj2kKdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dZVDIzdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dZVDIzdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF89C4CEF1;
	Sat,  6 Sep 2025 00:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757119620;
	bh=AYqshsVd4VcFyoLZ1LSFke6W8I3pcH45fJoq43vYotY=;
	h=Date:To:From:Subject:From;
	b=dZVDIzdYwrpRAzSr2rClni6xSpgyapWuQrLpajRNPZVS5Gyur3UmLUp9jWgPvqRvw
	 1jbtRjelReJfI2/WX/cIICdUhDu5cLujzkZx3aglpyLiYBDflX3/aIfX01ESyP+Ho/
	 92/d2ARY1Pb+GtU8YWkfVaZ21GuaN8DH/rCyto4I=
Date: Fri, 05 Sep 2025 17:47:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,lorenzo.stoakes@oracle.com,lkp@intel.com,kas@kernel.org,david@redhat.com,p.raghav@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + huge_memory-return-einval-in-folio-split-functions-when-thp-is-disabled.patch added to mm-new branch
Message-Id: <20250906004700.CDF89C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: huge_memory: return -EINVAL in folio split functions when THP is disabled
has been added to the -mm mm-new branch.  Its filename is
     huge_memory-return-einval-in-folio-split-functions-when-thp-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/huge_memory-return-einval-in-folio-split-functions-when-thp-is-disabled.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: huge_memory: return -EINVAL in folio split functions when THP is disabled
Date: Fri, 5 Sep 2025 17:00:12 +0200

split_huge_page_to_list_[to_order](), split_huge_page() and
try_folio_split() return 0 on success and error codes on failure.

When THP is disabled, these functions return 0 indicating success even
though an error code should be returned as it is not possible to split a
folio when THP is disabled.

Make all these functions return -EINVAL to indicate failure instead of 0. 
As large folios depend on CONFIG_THP, issue warning as this function
should not be called without a large folio.

Link: https://lkml.kernel.org/r/20250905150012.93714-1-kernel@pankajraghav.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509051753.riCeG7LC-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/huge_mm.h~huge_memory-return-einval-in-folio-split-functions-when-thp-is-disabled
+++ a/include/linux/huge_mm.h
@@ -588,22 +588,26 @@ static inline int
 split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
 {
-	return 0;
+	VM_WARN_ON_ONCE_PAGE(1, page);
+	return -EINVAL;
 }
 static inline int split_huge_page(struct page *page)
 {
-	return 0;
+	VM_WARN_ON_ONCE_PAGE(1, page);
+	return -EINVAL;
 }
 
 static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
-	return 0;
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 
 static inline int try_folio_split(struct folio *folio, struct page *page,
 		struct list_head *list)
 {
-	return 0;
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
_

Patches currently in -mm which might be from p.raghav@samsung.com are

mm-rename-huge_zero_page-to-huge_zero_folio.patch
mm-rename-mmf_huge_zero_page-to-mmf_huge_zero_folio.patch
mm-add-persistent-huge-zero-folio.patch
mm-add-largest_zero_folio-routine.patch
block-use-largest_zero_folio-in-__blkdev_issue_zero_pages.patch
huge_memory-return-einval-in-folio-split-functions-when-thp-is-disabled.patch

