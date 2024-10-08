Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4C2EC4
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 01:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352574; cv=none; b=kyuLkCI/aZmcOEspnmPaUQNLK+dKtjaMxLCX6HLGK2Rvg04r2iqSYvTf5SAavAHts0a6FCHkV0e2/5cnVrPKq6IU9HC77yNplONjbnEy+v51KJboubsoqRZMlY6LOqcWd5hTbbK8lJM4jYl5UKiq2KiEkX3trV323mLOLJ8jhoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352574; c=relaxed/simple;
	bh=2PHs0eQDq3VOvpQGTww58GkF9bMXnznP0/EsLQV6tyQ=;
	h=Date:To:From:Subject:Message-Id; b=Eo8RbRVNzB0ErDDit7U9fMKE+X4DlPTQmHuL/R6OzNrKbx/1oFIzNkbYJvkDjKxGZqd0ywNvQx1luFj5z+UtLe/qtjqYm6ipLmv8qlYRICb1iE9/t2kLK2wgAGTbu2Y7x54qryRZAJzllKz2yGIv0znz3OmF/i4HorKzcoOnVck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ncOzO8tL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ncOzO8tL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBCEC4CEC6;
	Tue,  8 Oct 2024 01:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728352574;
	bh=2PHs0eQDq3VOvpQGTww58GkF9bMXnznP0/EsLQV6tyQ=;
	h=Date:To:From:Subject:From;
	b=ncOzO8tLE7Wbu1ST8MSxhDfeisJMM0xgewlnFTZn95Hm6LyvzdK2CwV801Iq3AjDZ
	 MktYqqIjFxhU9HOegSVUD1n/4UM/9G6ZkNZ1i3x6JPoLJFVskP0hJxLvULdvGqkoEy
	 qngFlJ1byZDV/tD3tkeOga/sFoSmrM7oMij2wVr0=
Date: Mon, 07 Oct 2024 18:56:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-references-to-page-index-in-huge_memoryc.patch added to mm-unstable branch
Message-Id: <20241008015613.EEBCEC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove references to page->index in huge_memory.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-references-to-page-index-in-huge_memoryc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-references-to-page-index-in-huge_memoryc.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm: remove references to page->index in huge_memory.c
Date: Sat, 5 Oct 2024 21:01:17 +0100

We already have folios in all these places; it's just a matter of using
them instead of the pages.

Link: https://lkml.kernel.org/r/20241005200121.3231142-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/huge_memory.c~mm-remove-references-to-page-index-in-huge_memoryc
+++ a/mm/huge_memory.c
@@ -3137,8 +3137,8 @@ static void __split_huge_page_tail(struc
 	/* ->mapping in first and second tail page is replaced by other uses */
 	VM_BUG_ON_PAGE(tail > 2 && page_tail->mapping != TAIL_MAPPING,
 			page_tail);
-	page_tail->mapping = head->mapping;
-	page_tail->index = head->index + tail;
+	new_folio->mapping = folio->mapping;
+	new_folio->index = folio->index + tail;
 
 	/*
 	 * page->private should not be set in tail pages. Fix up and warn once
@@ -3214,11 +3214,11 @@ static void __split_huge_page(struct pag
 	ClearPageHasHWPoisoned(head);
 
 	for (i = nr - new_nr; i >= new_nr; i -= new_nr) {
+		struct folio *tail;
 		__split_huge_page_tail(folio, i, lruvec, list, new_order);
+		tail = page_folio(head + i);
 		/* Some pages can be beyond EOF: drop them from page cache */
-		if (head[i].index >= end) {
-			struct folio *tail = page_folio(head + i);
-
+		if (tail->index >= end) {
 			if (shmem_mapping(folio->mapping))
 				nr_dropped++;
 			else if (folio_test_clear_dirty(tail))
@@ -3226,12 +3226,12 @@ static void __split_huge_page(struct pag
 					inode_to_wb(folio->mapping->host));
 			__filemap_remove_folio(tail, NULL);
 			folio_put(tail);
-		} else if (!PageAnon(page)) {
-			__xa_store(&folio->mapping->i_pages, head[i].index,
-					head + i, 0);
+		} else if (!folio_test_anon(folio)) {
+			__xa_store(&folio->mapping->i_pages, tail->index,
+					tail, 0);
 		} else if (swap_cache) {
 			__xa_store(&swap_cache->i_pages, offset + i,
-					head + i, 0);
+					tail, 0);
 		}
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-add-pageanonnotksm-fix.patch
mm-remove-pageksm.patch
gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch

