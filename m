Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE8E2E36FA
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409750; cv=none; b=BoS7BGF4xR5TmJVG4VTIXCx6Yqy3OCAFV9B41C3qRAO6HmFlPBHjcFkfGiPlCMG0FDbpIEtI7i50WKxhq8uih1NqvKsbZCaxUy1NNcSXwQAgvU29rrODS7VE4Fi0E6Jnr37zRRR0BUAEdKA1mYkXmx01hvA02sJFXVRLfq1/4Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409750; c=relaxed/simple;
	bh=OCOi2kQJ377DHQoFn0GQjsM83w2tJgmBCxK+8UaVBjA=;
	h=Date:To:From:Subject:Message-Id; b=HzkIVKIniKcKWcp05Q3x9wxlHBYsmdEomWWJQC0hI5jjurFef0Q8Ixy4zxVRqKccD8rBi2ymGVkedKBV8GoKrkwKSjRyamzpxTbq6KqUV4kolh3zzAmnSoTJVN+x6Vs0hFr+MXOIa78DWreTU+gsR2D8S3fIwzZIAU8ouggPdeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m45NaYar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m45NaYar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B36C4CEED;
	Fri, 25 Jul 2025 02:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409750;
	bh=OCOi2kQJ377DHQoFn0GQjsM83w2tJgmBCxK+8UaVBjA=;
	h=Date:To:From:Subject:From;
	b=m45NaYarJ/uAt/Oo4Um7PCpAqHBHjoZFalZLaB2qPAUkp3GD1L2bKNbinxJoonbH3
	 gbpGbvvdWBwGL216b73leJMnu3hA8mP1nJCsXauqsiI7yKGEgyLBkPrUiFlD5Gpv6J
	 KpZopxIDG1MTGsgChRP54fZgKp04lydrpT3verAA=
Date: Thu, 24 Jul 2025 19:15:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-grab_cache_page.patch removed from -mm tree
Message-Id: <20250725021550.76B36C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove grab_cache_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-grab_cache_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove grab_cache_page()
Date: Mon, 21 Jul 2025 21:46:18 +0100

All callers have been converted to use filemap_grab_folio().

Link: https://lkml.kernel.org/r/20250721204619.163883-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-grab_cache_page
+++ a/include/linux/pagemap.h
@@ -878,7 +878,8 @@ static inline struct page *find_or_creat
  * @mapping: target address_space
  * @index: the page index
  *
- * Same as grab_cache_page(), but do not wait if the page is unavailable.
+ * Returns locked page at given index in given cache, creating it if
+ * needed, but do not wait if the page is locked or to reclaim memory.
  * This is intended for speculative data generators, where the data can
  * be regenerated if the page couldn't be grabbed.  This routine should
  * be safe to call while holding the lock for another page.
@@ -942,15 +943,6 @@ unsigned filemap_get_folios_contig(struc
 unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, xa_mark_t tag, struct folio_batch *fbatch);
 
-/*
- * Returns locked page at given index in given cache, creating it if needed.
- */
-static inline struct page *grab_cache_page(struct address_space *mapping,
-								pgoff_t index)
-{
-	return find_or_create_page(mapping, index, mapping_gfp_mask(mapping));
-}
-
 struct folio *read_cache_folio(struct address_space *, pgoff_t index,
 		filler_t *filler, struct file *file);
 struct folio *mapping_read_folio_gfp(struct address_space *, pgoff_t index,
_

Patches currently in -mm which might be from willy@infradead.org are


