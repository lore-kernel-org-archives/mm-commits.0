Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3286A1EBFF0
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 21:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743630657; cv=none; b=pZLV4erqLNHVGBRN0T+SMoH9lLDhIcxU+J9zLimuuJCCvVFzTVTLKTHEJUA4WwTuc9BFREODxl6snV2RFicQqznlVTsrsAS05041z+Jm45Jb8+IsMt52JA6ywQEm6kkGWTAyWeQqAJIHgKTinXofJLE0KUdeFp6ktJjHAEAAf34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743630657; c=relaxed/simple;
	bh=v1il+sq+g7lfltPCc87z8zFlvzqNaSxIHOVxyu3me2U=;
	h=Date:To:From:Subject:Message-Id; b=dmNEA8kGxiLbSV9YmjFWZjvYxswMdloBDaYxQTfgk3oynNWkz4Id/GGLfb+phEoV/nO6s0ep5CF+g5mo6hjWl34PODZSGDz07f6dA2olJJcQ+hI/eq0gmlNhBRiXEEA5ZEBbv2UsaqrQOwHmhq7ynZuvvmIzVJdBC61JNgqWa8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q6KvoUCH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q6KvoUCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01897C4CEDD;
	Wed,  2 Apr 2025 21:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743630657;
	bh=v1il+sq+g7lfltPCc87z8zFlvzqNaSxIHOVxyu3me2U=;
	h=Date:To:From:Subject:From;
	b=Q6KvoUCHQ0byD2R7pi7viiNyw7mW4DWi7/Z9LIDs+1KtXK2J8reJw/JExUmLv2qnZ
	 LQUZWVlxQA8lg6NNdRq1uNCPAbFEEQgutSXaGoTC0t1ZQ1J/5OpkMAnlgWxHxqbYgT
	 o2pP8UKWwFtJqWEyNAu2Z1yVTnkHT/xN1jWJsgfo=
Date: Wed, 02 Apr 2025 14:50:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-remove-find_subpage.patch added to mm-new branch
Message-Id: <20250402215057.01897C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: remove find_subpage()
has been added to the -mm mm-new branch.  Its filename is
     filemap-remove-find_subpage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-remove-find_subpage.patch

This patch will later appear in the mm-new branch at
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
Subject: filemap: remove find_subpage()
Date: Wed, 2 Apr 2025 22:06:07 +0100

All users of this function now call folio_file_page() instead.  Delete it.

Link: https://lkml.kernel.org/r/20250402210612.2444135-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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

filemap-remove-readahead_page.patch
mm-remove-offset_in_thp.patch
iov_iter-convert-iter_xarray_populate_pages-to-use-folios.patch
iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios.patch
filemap-remove-find_subpage.patch
filemap-convert-__readahead_batch-to-use-a-folio.patch
filemap-remove-readahead_page_batch.patch
mm-delete-thp_nr_pages.patch

