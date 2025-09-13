Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAF82BE034
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757802194; cv=none; b=jxMEUuJIm22N48Swq6VeensO186Dbarg4qKxwdFyKQWiZw0FmB28ivKnu0tXfwNnZT3FyZBA0T2LpEMhsK6OajUx5Sz7dJh4UZlG3iO55DTBv9Oa8adADh+Cn1mpauoY5DJFnWfF04qRHqA5GoJlO4nvhXBSx2mcRgkZ3F/myBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757802194; c=relaxed/simple;
	bh=bTW9e4yhIfLUqHabkMBrplfzg7SrLWlOprQ1jfl4ISk=;
	h=Date:To:From:Subject:Message-Id; b=X86hlhTyhqJ0rQCZEpH1nwAWT36WKT6UYokErhnmCN9DGO97bmmBGhjhSiBGOnknN0PECq0mXzPfu9xVnO6/7lmS8+ojPoKpXvbPrhAEXJ+63hBCcE7eYrO9yTXlQG2K1zXhRSqgtaYZ/x3ETRiDST+jnKNI+7++VW1vBNZKHuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p6JD+zAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p6JD+zAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27C0C4CEEB;
	Sat, 13 Sep 2025 22:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757802193;
	bh=bTW9e4yhIfLUqHabkMBrplfzg7SrLWlOprQ1jfl4ISk=;
	h=Date:To:From:Subject:From;
	b=p6JD+zAczjkQpJRz/B0Jh/XzNa5DnwzQh24qFyowE63Rq0MsfoLYHVHubVXTED0pf
	 ZuX/oDUaHy3R73cOQLblcapuBVg4295yzZKM1U6jAlhV73OwBCQE40+QFQqU5y7TBq
	 G2vnWkEXvxxkEYsgkbSjLzp3sutO8Caf0VZ6S8Eo=
Date: Sat, 13 Sep 2025 15:23:13 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check-fix.patch removed from -mm tree
Message-Id: <20250913222313.B27C0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup: selftests/mm: use nr_pages instead of 1UL << order
has been removed from the -mm tree.  Its filename was
     selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check-fix.patch

This patch was dropped because it was folded into selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check.patch

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: fixup: selftests/mm: use nr_pages instead of 1UL << order
Date: Tue, 19 Aug 2025 12:52:13 -0400

reduce code duplication, per David

Link: https://lkml.kernel.org/r/F54782D6-65A3-4D35-AE03-8ADE636EE258@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check-fix
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -38,6 +38,7 @@ unsigned int pmd_order;
 static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 		int kpageflags_fd)
 {
+	const unsigned long nr_pages = 1UL << order;
 	unsigned long pfn_head;
 	uint64_t pfn_flags;
 	unsigned long pfn;
@@ -63,7 +64,7 @@ static bool is_backed_by_folio(char *vad
 	if (!(pfn_flags & KPF_THP))
 		return false;
 
-	pfn_head = pfn & ~((1 << order) - 1);
+	pfn_head = pfn & ~(nr_pages - 1);
 
 	if (pageflags_get(pfn_head, kpageflags_fd, &pfn_flags))
 		goto fail;
@@ -73,7 +74,7 @@ static bool is_backed_by_folio(char *vad
 		return false;
 
 	/* check all tail PFN flags */
-	for (i = 1; i < 1UL << order; i++) {
+	for (i = 1; i < nr_pages; i++) {
 		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
 			goto fail;
 		if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL)))
@@ -84,7 +85,7 @@ static bool is_backed_by_folio(char *vad
 	 * check the PFN after this folio, but if its flags cannot be obtained,
 	 * assume this folio has the expected order
 	 */
-	if (pageflags_get(pfn_head + (1UL << order), kpageflags_fd, &pfn_flags))
+	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
 		return true;
 
 	/* this folio is bigger than the given order */
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-add-new_order-and-offset-to-split_huge_pages-pr_debug.patch
selftests-mm-mark-all-functions-static-in-split_huge_page_testc.patch
selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check.patch
selftests-mm-add-check_after_split_folio_orders-helper.patch
selftests-mm-check-after-split-folio-orders-in-split_huge_page_test.patch

