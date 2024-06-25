Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CD513D289
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291629; cv=none; b=pbNJk1p3BUsve6okh8qZqxJnCHS6706YSxStCHoFE1F32XEowQADnR8f4VTJkOS78HSitMi6HTZRRhV2NejCzMLSoRPKrudS9DwDneFrNrQJyfWEJAVP851fWqQBT/a9lEm7pSRk6ljTp8XEj3iMCCdQtXGxFU8ZvygVL2ffdKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291629; c=relaxed/simple;
	bh=2lgx5qo93aVQRXYkeczkOweH9KExaqAomzhrUy6ywp0=;
	h=Date:To:From:Subject:Message-Id; b=EHggOrtR1tjOoHlLjXWi3CivfNvMd0tm9QCW6XqBjKr1ec5bT7or1hMpTZQsmZASW5ciRLVkCtHQ3fWPjfXCP6Llve2eKAEjaNuKOiDqtKxUkF6gzy1SE6yDzUtqcu+7YteGDpMG0QQHvi1kbCn/4PGeRDiJ1MO95wUWy8u9I9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MyLUcHJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MyLUcHJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70B2C32789;
	Tue, 25 Jun 2024 05:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291628;
	bh=2lgx5qo93aVQRXYkeczkOweH9KExaqAomzhrUy6ywp0=;
	h=Date:To:From:Subject:From;
	b=MyLUcHJiZdiWaD1Z8/e4wrknExayy31VNY6ln7C+MO7uQ+77irtikuU1cOkAXZcc8
	 Odx5rwwbet4iG3A81r8KLtBF+BnT9MS4Xv7rMJ9Or+reamrQjYXM/EOQEnMKgqgYQb
	 69TTql9Vco11CU6ZESiwBWhGPfAF7ljjduq2BI7k=
Date: Mon, 24 Jun 2024 22:00:28 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-stop-setting-the-folio-error-flag.patch removed from -mm tree
Message-Id: <20240625050028.B70B2C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: stop setting the folio error flag
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-stop-setting-the-folio-error-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory-failure: stop setting the folio error flag
Date: Fri, 31 May 2024 04:29:25 +0100

Nobody checks the error flag any more, so setting it accomplishes nothing.
Remove the obsolete parts of this comment; it hasn't been true since
errseq_t was used to track writeback errors in 2017.

Link: https://lkml.kernel.org/r/20240531032938.2712870-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   29 -----------------------------
 1 file changed, 29 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-stop-setting-the-folio-error-flag
+++ a/mm/memory-failure.c
@@ -1112,7 +1112,6 @@ static int me_pagecache_dirty(struct pag
 	struct folio *folio = page_folio(p);
 	struct address_space *mapping = folio_mapping(folio);
 
-	SetPageError(p);
 	/* TBD: print more information about the file. */
 	if (mapping) {
 		/*
@@ -1120,34 +1119,6 @@ static int me_pagecache_dirty(struct pag
 		 * who check the mapping.
 		 * This way the application knows that something went
 		 * wrong with its dirty file data.
-		 *
-		 * There's one open issue:
-		 *
-		 * The EIO will be only reported on the next IO
-		 * operation and then cleared through the IO map.
-		 * Normally Linux has two mechanisms to pass IO error
-		 * first through the AS_EIO flag in the address space
-		 * and then through the PageError flag in the page.
-		 * Since we drop pages on memory failure handling the
-		 * only mechanism open to use is through AS_AIO.
-		 *
-		 * This has the disadvantage that it gets cleared on
-		 * the first operation that returns an error, while
-		 * the PageError bit is more sticky and only cleared
-		 * when the page is reread or dropped.  If an
-		 * application assumes it will always get error on
-		 * fsync, but does other operations on the fd before
-		 * and the page is dropped between then the error
-		 * will not be properly reported.
-		 *
-		 * This can already happen even without hwpoisoned
-		 * pages: first on metadata IO errors (which only
-		 * report through AS_EIO) or when the page is dropped
-		 * at the wrong time.
-		 *
-		 * So right now we assume that the application DTRT on
-		 * the first EIO, but we're not worse than other parts
-		 * of the kernel.
 		 */
 		mapping_set_error(mapping, -EIO);
 	}
_

Patches currently in -mm which might be from willy@infradead.org are


