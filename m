Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543E91EBFF0
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 21:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743630652; cv=none; b=ss6aqljrnrrVa7bd47nK3LpODd5ifu2IG0fgE5PDDzbbW3u87xukgOTkeEcS/s2NvOvabDm2udYQUTtT48hCaYpbwKXFa+RI1LH9MUVL0JUeM4c9ve/NRn2fM7BrscnwtIiyQo+9ivkynbKVp8hH4rso5gvCpnFVjPDI8tUgGjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743630652; c=relaxed/simple;
	bh=s81QR0cB4UZYVVG/d+VHI4Z7krrJgdh8PErgT7s8naM=;
	h=Date:To:From:Subject:Message-Id; b=YtAOeGEv62Ru4PUvg30Toj6cLiPKIu/1XDyPg1SsRbDBm4x2RoTZ0WOLFD37qoDJVPD15w0NnhbFBO+v2IIikPeywsxIVuTmN3Z9TwhLbRytToOxAXoA2Y2Y/Q8SSCVmBNAbZhLKvhXMBjlc8hRINWGUVDVhi009U+j7w2Vu9IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h7WTufx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h7WTufx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C13C4CEDD;
	Wed,  2 Apr 2025 21:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743630651;
	bh=s81QR0cB4UZYVVG/d+VHI4Z7krrJgdh8PErgT7s8naM=;
	h=Date:To:From:Subject:From;
	b=h7WTufx0zCOE94v1YlT5MMGQf3cC2oBQKvxoJ0N7g7cDDAEPJZCYPpXzdvkl1jBko
	 s/786R3RScmhrOi8rljt9ieSQMPCjLkxHyr7cxf4XJRsdE40rDabxe0MZ6jfUdNuAC
	 ZYd/ijTR8PsrIm0FhxPeWNPU9QOaslbT3TzB040A=
Date: Wed, 02 Apr 2025 14:50:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-remove-readahead_page.patch added to mm-new branch
Message-Id: <20250402215051.B6C13C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: remove readahead_page()
has been added to the -mm mm-new branch.  Its filename is
     filemap-remove-readahead_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-remove-readahead_page.patch

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

filemap-remove-readahead_page.patch
mm-remove-offset_in_thp.patch
iov_iter-convert-iter_xarray_populate_pages-to-use-folios.patch
iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios.patch
filemap-remove-find_subpage.patch
filemap-convert-__readahead_batch-to-use-a-folio.patch
filemap-remove-readahead_page_batch.patch
mm-delete-thp_nr_pages.patch

