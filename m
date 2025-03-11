Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A571DEFF3
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 05:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741670790; cv=none; b=oPgnB52LbThrQUpkkhGpz74tJ4h8bx82V44tciF6WHwc9MHIwuhmcklXiiTF1oaQx1zjZFaWGWmZ+klmwH79EeAG1LcSt0V3Uu5SUHEFt2Km4ABkorvKmGZujoVGPzwuy0K+RRlW9jvgPuRWRArLWn1QY92q1NCJZgmUIsDXDOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741670790; c=relaxed/simple;
	bh=s4y2Rt6JBzTcGErczjBRfqnALTcsLTiKJ6EUxvZkN8Y=;
	h=Date:To:From:Subject:Message-Id; b=UrUtZ6VAnwyoJ2VBO6TWLkWwUZIEN0dhADhtrz8lzRicO8L+3TdABwfjaEt05Sb9+Oc7ULjBx+rbhpH9q7EG2d/ICIrsRVX/XOePzMfVs5SuzOFNHGh/xaakGGgEgPEidyR2rwkcheulYmcqDwoddqRnd5p9dsdivHjTpiHvfrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t2BVox0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t2BVox0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD08C4CEE9;
	Tue, 11 Mar 2025 05:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741670789;
	bh=s4y2Rt6JBzTcGErczjBRfqnALTcsLTiKJ6EUxvZkN8Y=;
	h=Date:To:From:Subject:From;
	b=t2BVox0BzT8h8W9KsgWkF/L25JFo6rVcX94bRL7X/7OOkYwNdl5fLfujqRGm7YfVy
	 caAIQnrdF7/lhLtqHY5wZNU8U7QFhHLD770jjHMJGHox8F3jBRoo96X7UlYgMOMJGK
	 NDxRvWmeXtqbtayqsLM9sSNwvQImBb6yIeN0aGlA=
Date: Mon, 10 Mar 2025 22:26:28 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hare@suse.de,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-decline-to-manipulate-the-refcount-on-a-slab-page.patch added to mm-hotfixes-unstable branch
Message-Id: <20250311052629.8DD08C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: decline to manipulate the refcount on a slab page
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-decline-to-manipulate-the-refcount-on-a-slab-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-decline-to-manipulate-the-refcount-on-a-slab-page.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: decline to manipulate the refcount on a slab page
Date: Mon, 10 Mar 2025 14:35:24 +0000

Slab pages now have a refcount of 0, so nobody should be trying to
manipulate the refcount on them.  Doing so has little effect; the object
could be freed and reallocated to a different purpose, although the slab
itself would not be until the refcount was put making it behave rather
like TYPESAFE_BY_RCU.

Unfortunately, __iov_iter_get_pages_alloc() does take a refcount.  Fix
that to not change the refcount, and make put_page() silently not change
the refcount.  get_page() warns so that we can fix any other callers that
need to be changed.

Long-term, networking needs to stop taking a refcount on the pages that it
uses and rely on the caller to hold whatever references are necessary to
make the memory stable.  In the medium term, more page types are going to
hav a zero refcount, so we'll want to move get_page() and put_page() out
of line.

Link: https://lkml.kernel.org/r/20250310143544.1216127-1-willy@infradead.org
Fixes: 9aec2fb0fd5e (slab: allocate frozen pages)
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Hannes Reinecke <hare@suse.de>
Closes: https://lore.kernel.org/all/08c29e4b-2f71-4b6d-8046-27e407214d8c@suse.com/
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 +++++++-
 lib/iov_iter.c     |    8 ++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-decline-to-manipulate-the-refcount-on-a-slab-page
+++ a/include/linux/mm.h
@@ -1458,7 +1458,10 @@ static inline void folio_get(struct foli
 
 static inline void get_page(struct page *page)
 {
-	folio_get(page_folio(page));
+	struct folio *folio = page_folio(page);
+	if (WARN_ON_ONCE(folio_test_slab(folio)))
+		return;
+	folio_get(folio);
 }
 
 static inline __must_check bool try_get_page(struct page *page)
@@ -1552,6 +1555,9 @@ static inline void put_page(struct page
 {
 	struct folio *folio = page_folio(page);
 
+	if (folio_test_slab(folio))
+		return;
+
 	/*
 	 * For some devmap managed pages we need to catch refcount transition
 	 * from 2 to 1:
--- a/lib/iov_iter.c~mm-decline-to-manipulate-the-refcount-on-a-slab-page
+++ a/lib/iov_iter.c
@@ -1190,8 +1190,12 @@ static ssize_t __iov_iter_get_pages_allo
 		if (!n)
 			return -ENOMEM;
 		p = *pages;
-		for (int k = 0; k < n; k++)
-			get_page(p[k] = page + k);
+		for (int k = 0; k < n; k++) {
+			struct folio *folio = page_folio(page);
+			p[k] = page + k;
+			if (!folio_test_slab(folio))
+				folio_get(folio);
+		}
 		maxsize = min_t(size_t, maxsize, n * PAGE_SIZE - *start);
 		i->count -= maxsize;
 		i->iov_offset += maxsize;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-decline-to-manipulate-the-refcount-on-a-slab-page.patch
dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
fs-convert-block_commit_write-to-take-a-folio.patch
fs-remove-page_file_mapping.patch
fs-remove-folio_file_mapping.patch
mm-assert-the-folio-is-locked-in-folio_start_writeback.patch
hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch
hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch

