Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636261E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010995; cv=none; b=pvaKA40mt5iZammxqH4GRtZ8KCrg8WBhYa6cLYXMdG1J9d8OteVVjiqmFFdZcXZtwnQS0x20xus4E5Qbuy5F//bzXZraVSLK9cjrRI6edA3evtHWMS5HVmW1l8C0lcNWTPBUzYM9LZFuwf23JszF1a2A7q5b0K7qgk6AIsMtAnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010995; c=relaxed/simple;
	bh=hQWGTQFciaUhgtQpJ5/LSKA/df62j0rHjrBP0TMlEs0=;
	h=Date:To:From:Subject:Message-Id; b=HE188fWIwr6MuPKK9X2WZwyYKn+70AWJKvb05KmZhTA4PtHJWLvsmFlpPBBZn9CKEUE2QzDIIVNPvdDOQ6xmqn6YUXafpLq9NHp9gu7ONsgVfCAcFhfvP1TcipRa+BTOvl3zSbagz3dYhIDTi7u8wrPGLQuyX8Gpo9RC8/5fFbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dljd2ECa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dljd2ECa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41DCC4CEEF;
	Mon, 12 May 2025 00:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010993;
	bh=hQWGTQFciaUhgtQpJ5/LSKA/df62j0rHjrBP0TMlEs0=;
	h=Date:To:From:Subject:From;
	b=Dljd2ECalt/TZDPq6BGminmGZB5PeFUsxB2Gmz/6zWEtSm3So7F1RFMptYHJBdvaI
	 i8wpsgs9/8baW+8MKPwDOkh/MY3sPdeSAqejMR3vt0YYrq+aytZ/FyFLQ3y89meXBs
	 dSi3LmIJ3ob+9MuI9I70jT9B/ihFGObIc3ugxCjU=
Date: Sun, 11 May 2025 17:49:53 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios.patch removed from -mm tree
Message-Id: <20250512004953.C41DCC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: iov_iter: convert iov_iter_extract_xarray_pages() to use folios
has been removed from the -mm tree.  Its filename was
     iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: iov_iter: convert iov_iter_extract_xarray_pages() to use folios
Date: Wed, 2 Apr 2025 22:06:06 +0100

ITER_XARRAY is exclusively used with xarrays that contain folios, not
pages, so extract folio pointers from it, not page pointers.  Removes a
use of find_subpage().

Link: https://lkml.kernel.org/r/20250402210612.2444135-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
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


