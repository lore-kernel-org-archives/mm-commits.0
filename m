Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B5F1E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010994; cv=none; b=eWR68LNuI3vHmk4X0WnyRrCPaNbkJuq1VR0TwHUgVUIx2Pv0W9xePqojHrsKRxqqs25dPJ58cW2RiLj24pWXh6+m0C3i7Xi22lI8Dr+426agCYvv2bvGx8H+Rm62ioMo4HLbBDNM6QVUUw4l25/t5E57EURua/OhRET+OEmnk9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010994; c=relaxed/simple;
	bh=3Z0gCtgT3wq+Dce7p+5iNYgJeZPWzQuQ44ZmjXlgMh8=;
	h=Date:To:From:Subject:Message-Id; b=ksGINRlcCcB4J1vP6H9tsT8evupmCjxbG0K7QmupNPMWHg00gDHI/NZL2Q73pcUbCpG57dWWrRyBburP+Vr4YAtLrJr9bJmMj4DJeuqcz0ScOiRDOATK9KcCdKaOKk+TYz3+CCuzi7dWhiIpexb1HJZYRr/vAPOsBNlqeM1fvP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vXSseSzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vXSseSzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F32C4CEE4;
	Mon, 12 May 2025 00:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010992;
	bh=3Z0gCtgT3wq+Dce7p+5iNYgJeZPWzQuQ44ZmjXlgMh8=;
	h=Date:To:From:Subject:From;
	b=vXSseSzEyL4kCq46XZxzLDfke6Q6mOfEQA1IbaPUKuUK36gnnLtre0k43Pj0JieW6
	 g3xot+nnUPuf+jvAXV4AXmum/PK9iov0HtGItPyRSQf04GzObihKx0m3HmYhfhwZ2g
	 33EFsc8f5VEYafbCplS/7HkWj9RL/YFJPsDlJoe4=
Date: Sun, 11 May 2025 17:49:52 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] iov_iter-convert-iter_xarray_populate_pages-to-use-folios.patch removed from -mm tree
Message-Id: <20250512004952.A6F32C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: iov_iter: convert iter_xarray_populate_pages() to use folios
has been removed from the -mm tree.  Its filename was
     iov_iter-convert-iter_xarray_populate_pages-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: iov_iter: convert iter_xarray_populate_pages() to use folios
Date: Wed, 2 Apr 2025 22:06:05 +0100

ITER_XARRAY is exclusively used with xarrays that contain folios, not
pages, so extract folio pointers from it, not page pointers.  Removes a
hidden call to compound_head() and a use of find_subpage().

Link: https://lkml.kernel.org/r/20250402210612.2444135-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
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


