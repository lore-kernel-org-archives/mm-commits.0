Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A194D153598
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010996; cv=none; b=Fjl2RrIwzJKlO7n2XfeeLL1zTavGOWPjMdev1vqLlZ/UURCCkGeg/+cIrQp5npUupq5cj8g7mbQxriVjAbhFvOp+6cC0wuKRZb8XlV8R1HQMO+Aw68C3tfD9RRiiExLeADx7JNdUmmlyPlIQXdUXCgm4FWrlxFG4v47XhzQZYGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010996; c=relaxed/simple;
	bh=ysNpDhwmir8tlQXjAyD1tHBSAfJ5WgG0MO7UxH0dkSs=;
	h=Date:To:From:Subject:Message-Id; b=TmihiwlgEG3e2bOwgfZUEISET9ZnI5EyR3f/+Ob2j9ptMty3ElPWqvfnEvxCT0NrjZeZiNXJM8rro/eSOkMsSgXPsA7rN6VLmmEZdXZKnrpP/7Fpzwp7upMMjM41r1WJZZSmr65MpeT9jv6Ax4wV6bnMXJWPfwlmHO7s8X0C/40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BpMu4wMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BpMu4wMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCEDC4CEE4;
	Mon, 12 May 2025 00:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010995;
	bh=ysNpDhwmir8tlQXjAyD1tHBSAfJ5WgG0MO7UxH0dkSs=;
	h=Date:To:From:Subject:From;
	b=BpMu4wMSC8u6arCqvCQ8GD8wJ22OR/vF4rgVrG5B0gyurr7VxqMq4BzmaUvjtwb/o
	 jTkRcfMOYbHuwS9vE1gWEYukUOVupLKssjelSHzgqFVW6gUuVzwu9TxzwPPQybC0eH
	 eAPhsQ8+0KbvXkPeRIJwLksIkPBk6vtPLg4jIA18=
Date: Sun, 11 May 2025 17:49:54 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-remove-find_subpage.patch removed from -mm tree
Message-Id: <20250512004955.1BCEDC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: remove find_subpage()
has been removed from the -mm tree.  Its filename was
     filemap-remove-find_subpage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: remove find_subpage()
Date: Wed, 2 Apr 2025 22:06:07 +0100

All users of this function now call folio_file_page() instead.  Delete it.

Link: https://lkml.kernel.org/r/20250402210612.2444135-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   13 -------------
 1 file changed, 13 deletions(-)

--- a/include/linux/pagemap.h~filemap-remove-find_subpage
+++ a/include/linux/pagemap.h
@@ -945,19 +945,6 @@ static inline bool folio_contains(struct
 	return index - folio_index(folio) < folio_nr_pages(folio);
 }
 
-/*
- * Given the page we found in the page cache, return the page corresponding
- * to this index in the file
- */
-static inline struct page *find_subpage(struct page *head, pgoff_t index)
-{
-	/* HugeTLBfs wants the head page regardless */
-	if (PageHuge(head))
-		return head;
-
-	return head + (index & (thp_nr_pages(head) - 1));
-}
-
 unsigned filemap_get_folios(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch);
 unsigned filemap_get_folios_contig(struct address_space *mapping,
_

Patches currently in -mm which might be from willy@infradead.org are


