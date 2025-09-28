Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD7D34BA4D
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085534; cv=none; b=kGlmtxaTZnDdqXcIoJN4pqVFsMFtups7PgMgpbYXaF8yuqBBQmGWm2v+JUjm+IFoJyafBxybshP66g4Qv6cx6gdgl30JRBc2FOEK0sIboUp1nSwH+Yw8L5yWxQln0Mk5GX6j7Ls9BobESTPb2m4zF27tYGUISitG381Ewyw77/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085534; c=relaxed/simple;
	bh=XsI5v+DUgu6t2oUznr+CDQuAe+vCqQKwJohQe27mA6A=;
	h=Date:To:From:Subject:Message-Id; b=HHNL/2GjpkKQk58AF+9PrLT5SPvF7fr3uvchYhu2XBqd+BRYBSGzhl2BN5WbGHd3mk0Ca5xno0I52Hu7Uk6+po1NmySjrb39MA/SQvDjb5gQN8rMT41hPDHzWlgVrUlF8pxYHAxgHFrcLeNflJZmrBmV9d61uLDQbz1yvkLHrus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l+3oT1zF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l+3oT1zF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F2FC4CEF0;
	Sun, 28 Sep 2025 18:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085534;
	bh=XsI5v+DUgu6t2oUznr+CDQuAe+vCqQKwJohQe27mA6A=;
	h=Date:To:From:Subject:From;
	b=l+3oT1zFuWoJScXqgwCbQEfRWXliQWKz27mW6BYS0sSRuP4FjXjEIHdOu8YmuwNfJ
	 q1mpuhe8ljGoRqD+ajgTcS7PCcX8XvTbjT8XaV24ggZZ8H+nLZwL3iIygX7VVQoADV
	 TdnrLL6+H1nBHSbTqH1nrUgRHwtat3nUOui1CJqQ=
Date: Sun, 28 Sep 2025 11:52:13 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-map-entire-large-folio-faultaround.patch removed from -mm tree
Message-Id: <20250928185214.81F2FC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: map entire large folio faultaround
has been removed from the -mm tree.  Its filename was
     mm-filemap-map-entire-large-folio-faultaround.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/filemap: map entire large folio faultaround
Date: Tue, 23 Sep 2025 12:07:10 +0100

Currently, kernel only maps part of large folio that fits into
start_pgoff/end_pgoff range.

Map entire folio where possible.  It will match finish_fault() behaviour
that user hits on cold page cache.

Mapping large folios at once will allow the rmap code to mlock it on add,
as it will recognize that it is fully mapped and mlocking is safe.

Link: https://lkml.kernel.org/r/20250923110711.690639-6-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/filemap.c~mm-filemap-map-entire-large-folio-faultaround
+++ a/mm/filemap.c
@@ -3670,6 +3670,21 @@ static vm_fault_t filemap_map_folio_rang
 	struct page *page = folio_page(folio, start);
 	unsigned int count = 0;
 	pte_t *old_ptep = vmf->pte;
+	unsigned long addr0;
+
+	/*
+	 * Map the large folio fully where possible.
+	 *
+	 * The folio must not cross VMA or page table boundary.
+	 */
+	addr0 = addr - start * PAGE_SIZE;
+	if (folio_within_vma(folio, vmf->vma) &&
+	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK)) {
+		vmf->pte -= start;
+		page -= start;
+		addr = addr0;
+		nr_pages = folio_nr_pages(folio);
+	}
 
 	do {
 		if (PageHWPoison(page + count))
_

Patches currently in -mm which might be from kas@kernel.org are


