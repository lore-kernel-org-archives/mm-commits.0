Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01201365
	for <mm-commits@vger.kernel.org>; Sat,  1 Jun 2024 00:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717201761; cv=none; b=KUTtSVvoyWDbWhNrjDBwxVpqLyhw6a+UIJ1LFUAKL26d65Auk21cQoDrzY+svcLqFB3p5jOZU0P8039wySQ205nCerwr03nVIhJMLtYHywC1msrDY4WJu4Q9eQKH7rkgTLuwQOg60R+KL6iLJcBsg0WWRJLY5Ox7dMw2EGeK3K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717201761; c=relaxed/simple;
	bh=c92ELgmUBcZz95j3LboHDV0nn6yaxC4KMnLmB5ZD3KM=;
	h=Date:To:From:Subject:Message-Id; b=OCzOherpJnvscKJv+XEUJk2WYRXly0lHyr704CZ/RPMaHF9HMg82VO6c0rsZiQqTSfKm/N8bqT667fXbMYWW+F4ML6L4agLZWlCo4R4fhzNxuCsdU5gOexBGvIy/y2b0rRpmVDHonVyZ3pHEa+F3txRCMb6fndoD1xRQLqUs3N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FMSUF7pA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FMSUF7pA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15A1C116B1;
	Sat,  1 Jun 2024 00:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717201760;
	bh=c92ELgmUBcZz95j3LboHDV0nn6yaxC4KMnLmB5ZD3KM=;
	h=Date:To:From:Subject:From;
	b=FMSUF7pA9Bf6NlYf9TKNLDYeNYajyVGYG9IvmasUHBTwTk3JztDHQRrkQsaxT+BIg
	 ftvG6zvlPyI/FSlot2SS/Yjzac2MN4E0EEz6l5SfDY907wMNSu74T3le4UOAs0Jf66
	 F6RQlHlTUZHx4Hs61OoAcEZg+fkrazn+ziCNIZa8=
Date: Fri, 31 May 2024 17:29:19 -0700
To: mm-commits@vger.kernel.org,linmiaohe@huawei.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-stop-setting-the-folio-error-flag.patch added to mm-unstable branch
Message-Id: <20240601002920.B15A1C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: stop setting the folio error flag
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-stop-setting-the-folio-error-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-stop-setting-the-folio-error-flag.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory-failure: stop setting the folio error flag
Date: Fri, 31 May 2024 04:29:25 +0100

Nobody checks the error flag any more, so setting it accomplishes nothing.
Remove the obsolete parts of this comment; it hasn't been true since
errseq_t was used to track writeback errors in 2017.

Link: https://lkml.kernel.org/r/20240531032938.2712870-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
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

mm-remove-page_mapping.patch
mm-memory-failure-stop-setting-the-folio-error-flag.patch

