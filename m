Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11FC1EBFF0
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 21:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743630656; cv=none; b=jHhC3bRcaHkZ6oIK1nYvsC5pJ5oTUEmKPU6pvXNqh0fU5wv4i+zylEBYKZIr2jt1Q2kLMKoFTOGUTyIme2WZtVPze0nmzXTuROmAGm69a477lfya5svKEoywyVJDeYyM3Ry0ec9+4taBytJNQ5No53VjNck6WMybSfKrd6F3M3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743630656; c=relaxed/simple;
	bh=4xVhVW/xEiBKptSFO1Q5/Qq2jvaVHSKZ50UZJQKZWI8=;
	h=Date:To:From:Subject:Message-Id; b=qk0QZf5EJfhVHB3Hw3vlWMkUUea07uR6ilL4ITv76xB09JpGNE7ANSQTAz/DsX5qTkRGofFl9QXWR76Sc6cimwJ4gsxMqLQc6sK56M2i6FGOjCPFvQB4Vz1zMgvv68p+Hv9aZ/Khda7g7ZZWAGa/ldhBEq8tR0WxaIMPw4uxcy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yzU4pb51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yzU4pb51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F23CC4CEDD;
	Wed,  2 Apr 2025 21:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743630655;
	bh=4xVhVW/xEiBKptSFO1Q5/Qq2jvaVHSKZ50UZJQKZWI8=;
	h=Date:To:From:Subject:From;
	b=yzU4pb51zQ0iAMjOe/CdPpEdH7FXNvx2NTJRGp84S7hxmmF8PdFOh83RgViInbcOI
	 s+rZKSFLKe+0G29U60tHRiDR0l84LbNgGxIC+e2XiTzHfoQmBueIGoDGnULRBT9OLc
	 gghQtxop0oukuwxRMUd7hJLOqtMWqljIq2weuCeI=
Date: Wed, 02 Apr 2025 14:50:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios.patch added to mm-new branch
Message-Id: <20250402215055.4F23CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: iov_iter: convert iov_iter_extract_xarray_pages() to use folios
has been added to the -mm mm-new branch.  Its filename is
     iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios.patch

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
Subject: iov_iter: convert iov_iter_extract_xarray_pages() to use folios
Date: Wed, 2 Apr 2025 22:06:06 +0100

ITER_XARRAY is exclusively used with xarrays that contain folios, not
pages, so extract folio pointers from it, not page pointers.  Removes a
use of find_subpage().

Link: https://lkml.kernel.org/r/20250402210612.2444135-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/lib/iov_iter.c~iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios
+++ a/lib/iov_iter.c
@@ -1650,11 +1650,11 @@ static ssize_t iov_iter_extract_xarray_p
 					     iov_iter_extraction_t extraction_flags,
 					     size_t *offset0)
 {
-	struct page *page, **p;
+	struct page **p;
+	struct folio *folio;
 	unsigned int nr = 0, offset;
 	loff_t pos = i->xarray_start + i->iov_offset;
-	pgoff_t index = pos >> PAGE_SHIFT;
-	XA_STATE(xas, i->xarray, index);
+	XA_STATE(xas, i->xarray, pos >> PAGE_SHIFT);
 
 	offset = pos & ~PAGE_MASK;
 	*offset0 = offset;
@@ -1665,17 +1665,17 @@ static ssize_t iov_iter_extract_xarray_p
 	p = *pages;
 
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
 
-		p[nr++] = find_subpage(page, xas.xa_index);
+		p[nr++] = folio_file_page(folio, xas.xa_index);
 		if (nr == maxpages)
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

