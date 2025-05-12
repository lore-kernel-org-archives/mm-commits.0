Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0792E13AA2E
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010991; cv=none; b=h7Z4jSHywl2+fU/DYl4ASyCTkJK+wgYmj+nZFTgJetVBj2hs0oUJ8UBMJRhhx8u7H0EdlsCclGAo5VfmKu9itlTUBkekmMEu2VoZDF5aEWdY55X1Op4UTDeeyg0/MeuAIH5yTTDuGb9f+VFOC7e0OalVhzmKIzhDmFUl1/6E40c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010991; c=relaxed/simple;
	bh=cBTemdzpAqvGPZZ08a5hrvfIIOCt0R1qAJ8/YqsgvvY=;
	h=Date:To:From:Subject:Message-Id; b=FH9g1DqLhE35WziWCnNcc3YFmjywdV1mSmJEDqTXR7j2g4dLK+UsQ8LHWao9b4Qwk39/nJN876ANGpVJ+H24yLnBh/1S/DxnKn9Ps/P7/cXsPVgKNBO56xVyRntuH9QP2Tg1NU4KDlnp3YDKnp96ddKUJEDiXE0JNy6uydUHYQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=il03XIq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="il03XIq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F6CC4CEE4;
	Mon, 12 May 2025 00:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010990;
	bh=cBTemdzpAqvGPZZ08a5hrvfIIOCt0R1qAJ8/YqsgvvY=;
	h=Date:To:From:Subject:From;
	b=il03XIq18UMZsyj5j5O7keDMjExo2OYnNwlttGn9XTUeE9JcaX+ey4T8eqsDoVYuI
	 a8EaLTd4rpzQ06e1nONdPdulj8rWYwZMC4KrlnIk3A9tY9tPh4I2GaF2fDpUKz6ALF
	 7sWzC9wVyCWLY6DmoieroOMfVZ0m3a9pSPlbaN/s=
Date: Sun, 11 May 2025 17:49:49 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-remove-readahead_page.patch removed from -mm tree
Message-Id: <20250512004950.65F6CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: remove readahead_page()
has been removed from the -mm tree.  Its filename was
     filemap-remove-readahead_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: remove readahead_page()
Date: Wed, 2 Apr 2025 22:06:03 +0100

Patch series "Misc folio patches for 6.16".

Remove a few APIs that we've converted everybody from using.  I also found
a few places that extract a page pointer from i_pages, which will be an
invalid thing to do when we separate pages from folios.


This patch (of 8):

All filesystems have now been converted to call readahead_folio() so we
can delete this wrapper.

Link: https://lkml.kernel.org/r/20250402210612.2444135-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20250402210612.2444135-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

--- a/include/linux/pagemap.h~filemap-remove-readahead_page
+++ a/include/linux/pagemap.h
@@ -1308,9 +1308,9 @@ static inline bool filemap_range_needs_w
  * struct readahead_control - Describes a readahead request.
  *
  * A readahead request is for consecutive pages.  Filesystems which
- * implement the ->readahead method should call readahead_page() or
- * readahead_page_batch() in a loop and attempt to start I/O against
- * each page in the request.
+ * implement the ->readahead method should call readahead_folio() or
+ * __readahead_batch() in a loop and attempt to start reads into each
+ * folio in the request.
  *
  * Most of the fields in this struct are private and should be accessed
  * by the functions below.
@@ -1416,22 +1416,6 @@ static inline struct folio *__readahead_
 }
 
 /**
- * readahead_page - Get the next page to read.
- * @ractl: The current readahead request.
- *
- * Context: The page is locked and has an elevated refcount.  The caller
- * should decreases the refcount once the page has been submitted for I/O
- * and unlock the page once all I/O to that page has completed.
- * Return: A pointer to the next page, or %NULL if we are done.
- */
-static inline struct page *readahead_page(struct readahead_control *ractl)
-{
-	struct folio *folio = __readahead_folio(ractl);
-
-	return &folio->page;
-}
-
-/**
  * readahead_folio - Get the next folio to read.
  * @ractl: The current readahead request.
  *
_

Patches currently in -mm which might be from willy@infradead.org are


