Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E075A1EBFF0
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 21:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743630660; cv=none; b=sj+XaZ139pDPYWH4GRHCuBq+jYy9vPNxKIo0n+fOEM8eu+nQUYnEjJ5QYzkQlavJPxen3VvY8xAVP9JeSai2j+3gIAHtlErmlb6n7A2FrdbjF3pZaNCbJNNA/u/fCMoapjoP8Yy62lGykpHDric/XPJl2ju5fmonigG+Kvwcixc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743630660; c=relaxed/simple;
	bh=bIjc7H5vwwKhrROE3wEbD8E1oDZWosy+RxxLE8I+4qM=;
	h=Date:To:From:Subject:Message-Id; b=ikOQJkHqbYQe47YiIKZlyAq6ADJb9DaogwKDarVMEXEKeDKFOxz0wFdzIUxQ9HLkBqKQRqGpswfWsx55qRmgDRgOG3xMgC5BazDDAqfpSpmzWNGgzRPLnh2d9hlhllbJzluvEUETxZ3wXFU50B12NK6e+XBZ906V7u4qum4Sy2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JKqcbEy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JKqcbEy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528A8C4CEDD;
	Wed,  2 Apr 2025 21:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743630659;
	bh=bIjc7H5vwwKhrROE3wEbD8E1oDZWosy+RxxLE8I+4qM=;
	h=Date:To:From:Subject:From;
	b=JKqcbEy8WdqpPbLg11+BGSmT3x5agYd+WkgzNjsvyG+ziniyZHJLXoN7wbpgQywyl
	 xeUH/MJm0/prDWr6VNJHRmELvDwMDL+H8gYitnMXPpXZQWCH4tEpoRlMvUEicZfPtD
	 qryeu8EGXCsT+7k3ytt0JgTf7pLDyuVCKjdvjjSs=
Date: Wed, 02 Apr 2025 14:50:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-remove-readahead_page_batch.patch added to mm-new branch
Message-Id: <20250402215059.528A8C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: remove readahead_page_batch()
has been added to the -mm mm-new branch.  Its filename is
     filemap-remove-readahead_page_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-remove-readahead_page_batch.patch

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
Subject: filemap: remove readahead_page_batch()
Date: Wed, 2 Apr 2025 22:06:09 +0100

This function has no more callers; delete it.

Link: https://lkml.kernel.org/r/20250402210612.2444135-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   14 --------------
 1 file changed, 14 deletions(-)

--- a/include/linux/pagemap.h~filemap-remove-readahead_page_batch
+++ a/include/linux/pagemap.h
@@ -1448,20 +1448,6 @@ static inline unsigned int __readahead_b
 }
 
 /**
- * readahead_page_batch - Get a batch of pages to read.
- * @rac: The current readahead request.
- * @array: An array of pointers to struct page.
- *
- * Context: The pages are locked and have an elevated refcount.  The caller
- * should decreases the refcount once the page has been submitted for I/O
- * and unlock the page once all I/O to that page has completed.
- * Return: The number of pages placed in the array.  0 indicates the request
- * is complete.
- */
-#define readahead_page_batch(rac, array)				\
-	__readahead_batch(rac, array, ARRAY_SIZE(array))
-
-/**
  * readahead_pos - The byte offset into the file of this readahead request.
  * @rac: The readahead request.
  */
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

