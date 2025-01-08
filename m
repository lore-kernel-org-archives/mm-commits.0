Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255751802AB
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736307352; cv=none; b=prcHQs1FqNABJHC8U2SljE5WrF80Ghe271KqrcECLVxAuwdUJRphh1VUl0QdrRL/Eq966nOS+cxBoTqshgULu0hBVQjAIk2qBibtgVk0Jdo3AlfnwQAKYE00epZSiThfvrsK6//6Q35xc/LH419jeEqrNFacRcE+z+TOHP6n55A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736307352; c=relaxed/simple;
	bh=8EjTesSQtbplBOVGHaVFYMdbd2QnTFN2SVu5YwccmhI=;
	h=Date:To:From:Subject:Message-Id; b=urit0tSw1FUs0fVY04sxl0i0lCqVxSJyOiRyC1op7TWpWZirqQo+NRf4oUOsPnJTHJVyH3TdqoGIiihyhbSk20omBg/djbTGWsfDeZRFckk/McmHY3+/8yYFaKJlFVEY90mvywzt+uaN6ktMCxFoB4pe6DwiVWZtFCCpuYsoZAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PBnNeyVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PBnNeyVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F883C4CED0;
	Wed,  8 Jan 2025 03:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736307351;
	bh=8EjTesSQtbplBOVGHaVFYMdbd2QnTFN2SVu5YwccmhI=;
	h=Date:To:From:Subject:From;
	b=PBnNeyVz2MDoqCwEwTHeKpt3m+3nXoS/SaErZ7OCkeu3SdiSM4//vCeoZPYExEVis
	 4QsNnJ7RTvYfHKPSFN7/Yi9YO482NyTP1ofQu5MHtQAE5leNdB/q+eaxGVHYjyV4X0
	 wpBDhri8VPB9ltW8j1RbPgjK9mvCq4kSGRvsZ2rQ=
Date: Tue, 07 Jan 2025 19:35:51 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-use-page_cache_sync_ra-to-kick-off-read-ahead.patch added to mm-unstable branch
Message-Id: <20250108033551.9F883C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: use page_cache_sync_ra() to kick off read-ahead
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-use-page_cache_sync_ra-to-kick-off-read-ahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-use-page_cache_sync_ra-to-kick-off-read-ahead.patch

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
From: Jens Axboe <axboe@kernel.dk>
Subject: mm/filemap: use page_cache_sync_ra() to kick off read-ahead
Date: Fri, 20 Dec 2024 08:47:40 -0700

Rather than use the page_cache_sync_readahead() helper, define our own
ractl and use page_cache_sync_ra() directly.  In preparation for needing
to modify ractl inside filemap_get_pages().

No functional changes in this patch.

Link: https://lkml.kernel.org/r/20241220154831.1086649-3-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~mm-filemap-use-page_cache_sync_ra-to-kick-off-read-ahead
+++ a/mm/filemap.c
@@ -2499,7 +2499,6 @@ static int filemap_get_pages(struct kioc
 {
 	struct file *filp = iocb->ki_filp;
 	struct address_space *mapping = filp->f_mapping;
-	struct file_ra_state *ra = &filp->f_ra;
 	pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
 	pgoff_t last_index;
 	struct folio *folio;
@@ -2514,12 +2513,13 @@ retry:
 
 	filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
 	if (!folio_batch_count(fbatch)) {
+		DEFINE_READAHEAD(ractl, filp, &filp->f_ra, mapping, index);
+
 		if (iocb->ki_flags & IOCB_NOIO)
 			return -EAGAIN;
 		if (iocb->ki_flags & IOCB_NOWAIT)
 			flags = memalloc_noio_save();
-		page_cache_sync_readahead(mapping, ra, filp, index,
-				last_index - index);
+		page_cache_sync_ra(&ractl, last_index - index);
 		if (iocb->ki_flags & IOCB_NOWAIT)
 			memalloc_noio_restore(flags);
 		filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
_

Patches currently in -mm which might be from axboe@kernel.dk are

mm-filemap-change-filemap_create_folio-to-take-a-struct-kiocb.patch
mm-filemap-use-page_cache_sync_ra-to-kick-off-read-ahead.patch
mm-readahead-add-folio-allocation-helper.patch
mm-add-pg_dropbehind-folio-flag.patch
mm-readahead-add-readahead_control-dropbehind-member.patch
mm-truncate-add-folio_unmap_invalidate-helper.patch
fs-add-rwf_dontcache-iocb-and-fop_dontcache-file_operations-flag.patch
mm-filemap-add-read-support-for-rwf_dontcache.patch
mm-filemap-drop-streaming-uncached-pages-when-writeback-completes.patch
mm-filemap-add-filemap_fdatawrite_range_kick-helper.patch
mm-call-filemap_fdatawrite_range_kick-after-iocb_dontcache-issue.patch
mm-add-fgp_dontcache-folio-creation-flag.patch

