Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD181EBFF0
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 21:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743630654; cv=none; b=DEIaC360qP2KWNLBjC+Qo7TbTXdGkOXVzIEL3KTRrtF/1ORl/7c1lnEcd379dYWUsL0xBuE5YpavQt+2SdcgwcYnA+51XMzyXkUQRs/EoW+SjHR1ZwF/7ISVouGgEg+hRcmw3Sf6rRzoOGkSpflAFUNvca7/DaN7AzgVCeL9rTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743630654; c=relaxed/simple;
	bh=lCPsM0b+etcXDqqj//pGJG6IXjf8oEi322WXHl9FnsY=;
	h=Date:To:From:Subject:Message-Id; b=iA6i7vT1GY8CoHINtTvMCr670ZSJ9uTOf2RC6FEp2irsKJsIluwJg0bsdWbhQtvzRTPG3F+UWjKb8Cr8E01QxBtZp+dIUW70s4/wAhpl8Uk5lE5XRyzPqsm7Stqe/vvsK+tVUoOjS3s0GzVZXP2/kjf8i0y5YweOCu0yQGO9M1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gRmm0Y/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gRmm0Y/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221CCC4CEDD;
	Wed,  2 Apr 2025 21:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743630654;
	bh=lCPsM0b+etcXDqqj//pGJG6IXjf8oEi322WXHl9FnsY=;
	h=Date:To:From:Subject:From;
	b=gRmm0Y/wnFlr+t7r+R4id7WT9guHJ+7+jRCRPMswrtjgWTdwFC77C3x0Qye112c+k
	 qbA/MEQWtH46If3i+KxXqTktEfSj4qyEZ9UrFEZ9fjjN+dxGgXuMq6fqQ5dTurmIUs
	 aLT55wwdSlY7bvI7kWU4Zby92s9PxZ6kUxC4IIUc=
Date: Wed, 02 Apr 2025 14:50:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iov_iter-convert-iter_xarray_populate_pages-to-use-folios.patch added to mm-new branch
Message-Id: <20250402215054.221CCC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: iov_iter: convert iter_xarray_populate_pages() to use folios
has been added to the -mm mm-new branch.  Its filename is
     iov_iter-convert-iter_xarray_populate_pages-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iov_iter-convert-iter_xarray_populate_pages-to-use-folios.patch

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
Subject: iov_iter: convert iter_xarray_populate_pages() to use folios
Date: Wed, 2 Apr 2025 22:06:05 +0100

ITER_XARRAY is exclusively used with xarrays that contain folios, not
pages, so extract folio pointers from it, not page pointers.  Removes a
hidden call to compound_head() and a use of find_subpage().

Link: https://lkml.kernel.org/r/20250402210612.2444135-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/lib/iov_iter.c~iov_iter-convert-iter_xarray_populate_pages-to-use-folios
+++ a/lib/iov_iter.c
@@ -1059,22 +1059,22 @@ static ssize_t iter_xarray_populate_page
 					  pgoff_t index, unsigned int nr_pages)
 {
 	XA_STATE(xas, xa, index);
-	struct page *page;
+	struct folio *folio;
 	unsigned int ret = 0;
 
 	rcu_read_lock();
-	for (page = xas_load(&xas); page; page = xas_next(&xas)) {
-		if (xas_retry(&xas, page))
+	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
+		if (xas_retry(&xas, folio))
 			continue;
 
-		/* Has the page moved or been split? */
-		if (unlikely(page != xas_reload(&xas))) {
+		/* Has the folio moved or been split? */
+		if (unlikely(folio != xas_reload(&xas))) {
 			xas_reset(&xas);
 			continue;
 		}
 
-		pages[ret] = find_subpage(page, xas.xa_index);
-		get_page(pages[ret]);
+		pages[ret] = folio_file_page(folio, xas.xa_index);
+		folio_get(folio);
 		if (++ret == nr_pages)
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

