Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32756219488
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019122; cv=none; b=Zv+uaNBfm1Pp5tg7Wp/MBvBXcuI6CIC660VyUInWZaHXNhcsL4gy7FZn0X9MmzqeHx3Xxy8dINNiQfEpUHO9Q055SuVXd10rLes5e2PlVZGJ0Ru6iyHvcFncP2H6GyBjjzH/g2ukUf8QU8lVjkRfkAvqW9t5VeKy48sK+2oHT6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019122; c=relaxed/simple;
	bh=6aigKG4U1QuAJ+R39C2cPJcfbJP+uhosm57r4yHrNeE=;
	h=Date:To:From:Subject:Message-Id; b=qKSFlJpEWIUwFAKcIq3mp7senlFVwxzXv6wEnu8lSBV5yDuym4lQwaQ50UDvZxmdnk2KTC9FLoxcK4uxf3hmO8nR/+Zzy87ghi57e/uwbRcv6vkoLJ/WKWiHV+CUnucIji1sGVxx/kV4jGBrvrPwIE+UVZvokF0x8WeYHCJO1Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YyGy1JM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YyGy1JM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DE7C4CECC;
	Thu,  7 Nov 2024 22:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019121;
	bh=6aigKG4U1QuAJ+R39C2cPJcfbJP+uhosm57r4yHrNeE=;
	h=Date:To:From:Subject:From;
	b=YyGy1JM2BSCaotw2rMPU41wwMckjcE+xu3GbDzr2xmx6eZqZ9mw39/cfXwCRhQpMr
	 6iKy8vRA0zm5bKl6ANpEHUqGHOeqmbvy7A+XBNtsV+tqPRq+cn6/bCyQ24I4Uw4TRo
	 RYpmFJYVBTMmGj3P+UP1k/jYe8/2+N8mKA/qk0po=
Date: Thu, 07 Nov 2024 14:38:41 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-references-to-page-index-in-huge_memoryc.patch removed from -mm tree
Message-Id: <20241107223841.A9DE7C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove references to page->index in huge_memory.c
has been removed from the -mm tree.  Its filename was
     mm-remove-references-to-page-index-in-huge_memoryc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3199,8 +3199,8 @@ static void __split_huge_page_tail(struc
 	/* ->mapping in first and second tail page is replaced by other uses */
 	VM_BUG_ON_PAGE(tail > 2 && page_tail->mapping != TAIL_MAPPING,
 			page_tail);
-	page_tail->mapping = head->mapping;
-	page_tail->index = head->index + tail;
+	new_folio->mapping = folio->mapping;
+	new_folio->index = folio->index + tail;
 
 	/*
 	 * page->private should not be set in tail pages. Fix up and warn once
@@ -3276,11 +3276,11 @@ static void __split_huge_page(struct pag
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
@@ -3288,12 +3288,12 @@ static void __split_huge_page(struct pag
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


