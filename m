Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453557FBB2
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104071; cv=none; b=talybfl2Br5C4Df/fXrrZVk6JVeedaeFhPMDUrzx7yt5qWlUq/vKH9z/BQ7aCNPBaWmSqowTLeKUDZT+rqIGAGJM004bpS92FiHnHRqzLkhbku4DmgWJBYKVDG8YSjQvf9r7ZbWjrIvgYh9nNtNVo3oFmhOGvxsp6weRoJas1w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104071; c=relaxed/simple;
	bh=Z06H0X32YFJgmZDFXUYyzkvrntxCdFze8FtMozSgpuI=;
	h=Date:To:From:Subject:Message-Id; b=KFochWTxSSM/jSaqCyvSIr4ts9ogFI+O2s/SWch2sNsa7qJ1FZ2YHOwq9I76ePR8lo6IoCq04+53/dRvRV/OH8FTKfbzFsxXvAIAVdakyi6L9ltYDKdaVaUD3xD9HMd+wxksdUixMcTL6ykK1hWtFdq4A5lQ6hi65TALpTKmoFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DbW6AoU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DbW6AoU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C591C113CD;
	Fri, 26 Apr 2024 04:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104071;
	bh=Z06H0X32YFJgmZDFXUYyzkvrntxCdFze8FtMozSgpuI=;
	h=Date:To:From:Subject:From;
	b=DbW6AoU5L2Cdub7tHuNXcIE5Ukf8cv5EWwyz3fD7fSLglBZ1JaDA0RIzYlwaa+xZx
	 M8BFcQczTYz3KD8Wpb94fRHO1kkXKX9uAsxpFJlxAYhIx0/K+NSGL+A/X+5fVXlTjg
	 ziMqYbjQ41keF9/m9WYP+UBbbDJDJjzMWycZhyUY=
Date: Thu, 25 Apr 2024 21:01:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,nathan@kernel.org,kernel@xen0n.name,jgg@nvidia.com,david@redhat.com,chenhuacai@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch removed from -mm tree
Message-Id: <20240426040111.1C591C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: allow anon exclusive check over hugetlb tail pages
has been removed from the -mm tree.  Its filename was
     mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: allow anon exclusive check over hugetlb tail pages
Date: Tue, 2 Apr 2024 21:32:47 -0400

PageAnonExclusive() used to forbid tail pages for hugetlbfs, as that used
to be called mostly in hugetlb specific paths and the head page was
guaranteed.

As we move forward towards merging hugetlb paths into generic mm, we may
start to pass in tail hugetlb pages (when with cont-pte/cont-pmd huge
pages) for such check.  Allow it to properly fetch the head, in which case
the anon-exclusiveness of the head will always represents the tail page.

There's already a sign of it when we look at the GUP-fast which already
contain the hugetlb processing altogether: we used to have a specific
commit 5805192c7b72 ("mm/gup: handle cont-PTE hugetlb pages correctly in
gup_must_unshare() via GUP-fast") covering that area.  Now with this more
generic change, that can also go away.

[akpm@linux-foundation.org: simplify PageAnonExclusive(), per Matthew]
  Link: https://lkml.kernel.org/r/Zg3u5Sh9EbbYPhaI@casper.infradead.org
Link: https://lkml.kernel.org/r/20240403013249.1418299-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    7 ++++++-
 mm/internal.h              |   10 ----------
 2 files changed, 6 insertions(+), 11 deletions(-)

--- a/include/linux/page-flags.h~mm-allow-anon-exclusive-check-over-hugetlb-tail-pages
+++ a/include/linux/page-flags.h
@@ -1095,7 +1095,12 @@ PAGEFLAG(Isolated, isolated, PF_ANY);
 static __always_inline int PageAnonExclusive(const struct page *page)
 {
 	VM_BUG_ON_PGFLAGS(!PageAnon(page), page);
-	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
+	/*
+	 * HugeTLB stores this information on the head page; THP keeps it per
+	 * page
+	 */
+	if (PageHuge(page))
+		page = compound_head(page);
 	return test_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
 
--- a/mm/internal.h~mm-allow-anon-exclusive-check-over-hugetlb-tail-pages
+++ a/mm/internal.h
@@ -1204,16 +1204,6 @@ static inline bool gup_must_unshare(stru
 		smp_rmb();
 
 	/*
-	 * During GUP-fast we might not get called on the head page for a
-	 * hugetlb page that is mapped using cont-PTE, because GUP-fast does
-	 * not work with the abstracted hugetlb PTEs that always point at the
-	 * head page. For hugetlb, PageAnonExclusive only applies on the head
-	 * page (as it cannot be partially COW-shared), so lookup the head page.
-	 */
-	if (unlikely(!PageHead(page) && PageHuge(page)))
-		page = compound_head(page);
-
-	/*
 	 * Note that PageKsm() pages cannot be exclusive, and consequently,
 	 * cannot get pinned.
 	 */
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

