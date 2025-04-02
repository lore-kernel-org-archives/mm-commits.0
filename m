Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795491EBFF0
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 21:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743630658; cv=none; b=Xku/wp4hq4QdeLFJLJKKCmHh727i/yd7IQ58KohAwMF3mc8emUokcMM4o72z8aobXdCm3IPW9N7IuktZq/n3zRNtFoMAnT2VVycxRKbCFcdHZRhV6t1ekLAT4zXlqd/BGqP2mycKTJIRyc0uFhMjGOt+APov3giO04nfq1bUDWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743630658; c=relaxed/simple;
	bh=Bl6umFWGmCQoK/qT/Jaix2FxHn0ocHgZ83P6edCoNfw=;
	h=Date:To:From:Subject:Message-Id; b=qTUYR7m3uv8O0EWpp5n4eSZf0ww/m1zpVTxwXVa2x3JjRgDYswcctMo4mPJNehpB1uVKZuq/F7f8osPXl66Sk6oLqMISpC5WibsXyW1TcACfuCG5+LWIh6HpRw/0iNZONRVvLr/SjiZNlmWSpHq6jxEczjsK6olOa4iy8LMjCJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tSkEa4FV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tSkEa4FV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE20C4CEDD;
	Wed,  2 Apr 2025 21:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743630658;
	bh=Bl6umFWGmCQoK/qT/Jaix2FxHn0ocHgZ83P6edCoNfw=;
	h=Date:To:From:Subject:From;
	b=tSkEa4FVdCr7CI1V/RQdjPCd7B/XTk8+aMRI25o+qiWieaB+JPfqnsJ40UMKDbQSY
	 xatlWDgOJnHndmM4/0x8XpEkNS5vO89RZJ4mdy9PR/3f0TZqVyTkzeRWIIko8/dhbu
	 frxjaFzqNuPOL2d83KX71U4AKk+E2fhmKdl/edho=
Date: Wed, 02 Apr 2025 14:50:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-convert-__readahead_batch-to-use-a-folio.patch added to mm-new branch
Message-Id: <20250402215058.2CE20C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: convert __readahead_batch() to use a folio
has been added to the -mm mm-new branch.  Its filename is
     filemap-convert-__readahead_batch-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-convert-__readahead_batch-to-use-a-folio.patch

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
Subject: filemap: convert __readahead_batch() to use a folio
Date: Wed, 2 Apr 2025 22:06:08 +0100

Extract folios from i_mapping, not pages.  Removes a hidden call to
compound_head(), a use of thp_nr_pages() and an unnecessary assertion that
we didn't find a tail page in the page cache.

Link: https://lkml.kernel.org/r/20250402210612.2444135-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/include/linux/pagemap.h~filemap-convert-__readahead_batch-to-use-a-folio
+++ a/include/linux/pagemap.h
@@ -1424,7 +1424,7 @@ static inline unsigned int __readahead_b
 {
 	unsigned int i = 0;
 	XA_STATE(xas, &rac->mapping->i_pages, 0);
-	struct page *page;
+	struct folio *folio;
 
 	BUG_ON(rac->_batch_count > rac->_nr_pages);
 	rac->_nr_pages -= rac->_batch_count;
@@ -1433,13 +1433,12 @@ static inline unsigned int __readahead_b
 
 	xas_set(&xas, rac->_index);
 	rcu_read_lock();
-	xas_for_each(&xas, page, rac->_index + rac->_nr_pages - 1) {
-		if (xas_retry(&xas, page))
+	xas_for_each(&xas, folio, rac->_index + rac->_nr_pages - 1) {
+		if (xas_retry(&xas, folio))
 			continue;
-		VM_BUG_ON_PAGE(!PageLocked(page), page);
-		VM_BUG_ON_PAGE(PageTail(page), page);
-		array[i++] = page;
-		rac->_batch_count += thp_nr_pages(page);
+		VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+		array[i++] = folio_page(folio, 0);
+		rac->_batch_count += folio_nr_pages(folio);
 		if (i == array_sz)
 			break;
 	}
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

