Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C0113B58D
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 21:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721771469; cv=none; b=c9SuUm6WYHFE4MnkrCFx5ADi6XEqRwF89YD8cUqAraKIOPMsEb292xKTGgBcCauNwh2funU09oLT5AgE/YCBTkUC2NoUDi/9JKTVZi3knDAbdUpP/xut6bOzTZ9OR5f8VaoL6o0b9ntMibjXWWn0JpRtn6aVBjqblh+BsjDkQDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721771469; c=relaxed/simple;
	bh=ttyLO3yfwonkmOZlLHPkq4qEBAoF4E6x1VuPujv+0Eg=;
	h=Date:To:From:Subject:Message-Id; b=L7hVgWNdVodp4nLq26/ONlZz+9DEHFbgWUp1FX2PiPGUTlzartF4hwtMrilzR0tu6KiWcvU5SX7KgY6VynX7LeKGthMymLfBDFS8VNTWpU+1byzeAE7lriN1w1wwrt4Bg4mz3k1nhczMs8dcUi+/FEUKaQxk4RSRoVTLvL1pEzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nNkdgHay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nNkdgHay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77A6C4AF09;
	Tue, 23 Jul 2024 21:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721771469;
	bh=ttyLO3yfwonkmOZlLHPkq4qEBAoF4E6x1VuPujv+0Eg=;
	h=Date:To:From:Subject:From;
	b=nNkdgHayxKlCMFzBAfbovVB2zvVCKaUZZxk6BACY7cXq8opEbmAwoeCzk2VK3U/FG
	 dGwkgUTEA/zlGIVBYVhd0X6DbL9VeVsgZ5mDud7sEP0bQxJhxC0yndh39+T04qwz7G
	 8XfOigaqrgF7YKMMNcdeCaI2HBMlpYK+UGJ1npZQ=
Date: Tue, 23 Jul 2024 14:51:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-references-to-page-index-in-huge_memoryc.patch added to mm-unstable branch
Message-Id: <20240723215109.A77A6C4AF09@smtp.kernel.org>
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
Date: Tue, 23 Jul 2024 16:35:00 +0100

We already have folios in all these places; it's just a matter of using
them instead of the pages.

Link: https://lkml.kernel.org/r/20240723153503.1669586-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/huge_memory.c~mm-remove-references-to-page-index-in-huge_memoryc
+++ a/mm/huge_memory.c
@@ -2862,8 +2862,8 @@ static void __split_huge_page_tail(struc
 	/* ->mapping in first and second tail page is replaced by other uses */
 	VM_BUG_ON_PAGE(tail > 2 && page_tail->mapping != TAIL_MAPPING,
 			page_tail);
-	page_tail->mapping = head->mapping;
-	page_tail->index = head->index + tail;
+	new_folio->mapping = folio->mapping;
+	new_folio->index = folio->index + tail;
 
 	/*
 	 * page->private should not be set in tail pages. Fix up and warn once
@@ -2939,11 +2939,11 @@ static void __split_huge_page(struct pag
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
@@ -2951,12 +2951,12 @@ static void __split_huge_page(struct pag
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

bootmem-stop-using-page-index.patch
mm-constify-page_address_in_vma.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-mass-constification-of-folio-page-pointers.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch

