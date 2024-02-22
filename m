Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE8C71758
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 20:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708635416; cv=none; b=H3kkCdLIcgY3hk0nyZg5Xhsa8u+27CNSvu46a0tXRUZlW7Rxz5UB2a5cyevl4khl3PRiV3aPLQ+FeqXjiPH+v1MSbI+jQ5lJyIAggpcLvqybzzDZm5rxsljHESAkABL23nmyD+2N+MwCloA6nEtm4p6q8mKOAvLFKCb92XyU0X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708635416; c=relaxed/simple;
	bh=JjvxvgdzAt6M4/3xHkioBGPTBTXjwvLOibkN8yemvcA=;
	h=Date:To:From:Subject:Message-Id; b=eBsworPDeJEWQNoHI2qqb2lJa8bkQSs4kuGKCJzPSjLzYy/1gnZKwIVLNmUSGIq6uubXNb+Hkwu59U8BzlC0lM5kTT0ukaY+tQGi0Rq0DfNKOfYvprcTFjtJ25v1EllRCqny344/7W3mMlx+y6TgVQUtpXPu/rnGdkC5cwz/n74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ofqZwT7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ofqZwT7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5997AC433C7;
	Thu, 22 Feb 2024 20:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708635415;
	bh=JjvxvgdzAt6M4/3xHkioBGPTBTXjwvLOibkN8yemvcA=;
	h=Date:To:From:Subject:From;
	b=ofqZwT7cvywzpvzO8LwUOxIKQ62H0ohejmVP3+DMTRnd28DBWht9+u0b6HX3CckQU
	 jVHZp/EomxAJkhttcFT94GqbyQlDEuOtQbrEAEFYHKkTVadqkWUjS8RLjr601CSPvU
	 DFvSoJbRYQoykxGpXBNniJLXLEUx4g86SMbScidg=
Date: Thu, 22 Feb 2024 12:56:54 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-make-check_new_page-return-bool.patch added to mm-unstable branch
Message-Id: <20240222205655.5997AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: make check_new_page() return bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-make-check_new_page-return-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-make-check_new_page-return-bool.patch

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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/page_alloc: make check_new_page() return bool
Date: Thu, 22 Feb 2024 17:19:32 +0800

Make check_new_page() return bool like check_new_pages()

Link: https://lkml.kernel.org/r/20240222091932.54799-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-check_new_page-return-bool
+++ a/mm/page_alloc.c
@@ -1422,14 +1422,14 @@ static void check_new_page_bad(struct pa
 /*
  * This page is about to be returned from the page allocator
  */
-static int check_new_page(struct page *page)
+static bool check_new_page(struct page *page)
 {
 	if (likely(page_expected_state(page,
 				PAGE_FLAGS_CHECK_AT_PREP|__PG_HWPOISON)))
-		return 0;
+		return false;
 
 	check_new_page_bad(page);
-	return 1;
+	return true;
 }
 
 static inline bool check_new_pages(struct page *page, unsigned int order)
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-page_alloc-make-bad_range-return-bool.patch
mm-page_alloc-make-check_new_page-return-bool.patch

