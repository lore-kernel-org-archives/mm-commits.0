Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2A822089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957103; cv=none; b=bkLUr9AnOzgiquaGE1e92QiQ3Uffb8/uF0b/Azj9IDSTouA9yBhlTjquzjzLEFFAdNKJl98cJN03jgfQm+g9uqiH7dz+/+iyLYr5ksykKnARd6x2Kmpo9AmSr4MsJvN6nyejjGGUjsZcwmSqp3TX8aRGeDO7wGlThw/tbVOrHZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957103; c=relaxed/simple;
	bh=O9WpvDeipG7b2MRaZdWOoZCjkBPAhnb7UbVlD0Cu1wE=;
	h=Date:To:From:Subject:Message-Id; b=YAFLltp6Xf+7H2oHZvt76sXKGQQ2qXn5s8Xc6/aQ3bXa+fAykL0uDjDk/nbEydPQZN8BBzGIj1AgALslEnDArhrvSbfPHyP0teEqFCv/X4d5fQRmkrzi+t0gPDQkzsw/OBmoFCQMNg5+0Hcjl13WEDBEyJd9/F3ELbjniRf+0cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AhBdQlX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AhBdQlX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715C3C113CC;
	Mon,  6 May 2024 00:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957103;
	bh=O9WpvDeipG7b2MRaZdWOoZCjkBPAhnb7UbVlD0Cu1wE=;
	h=Date:To:From:Subject:From;
	b=AhBdQlX9jZzUWdvf/5D9blfAgtgdGyX6y4jpc6PExeY6pc0YVbSVc0B83ojdJXLqS
	 tFMhqRzWXCK6sRoO+6jqgA5M7Nw8t6b7xrozX5Ny47JEOmtHvCd0TsfDd5IEbAl+Zf
	 b2LJXKCHautypHsD+JKIKOAdBqQRQWugueOOMwV4=
Date: Sun, 05 May 2024 17:58:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_ref_sub_return.patch removed from -mm tree
Message-Id: <20240506005823.715C3C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove page_ref_sub_return()
has been removed from the -mm tree.  Its filename was
     mm-remove-page_ref_sub_return.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove page_ref_sub_return()
Date: Wed, 24 Apr 2024 20:19:09 +0100

With all callers converted to folios, we can act directly on
folio->_refcount.

Link: https://lkml.kernel.org/r/20240424191914.361554-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ref.h |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/include/linux/page_ref.h~mm-remove-page_ref_sub_return
+++ a/include/linux/page_ref.h
@@ -139,20 +139,15 @@ static inline void folio_ref_sub(struct
 	page_ref_sub(&folio->page, nr);
 }
 
-static inline int page_ref_sub_return(struct page *page, int nr)
+static inline int folio_ref_sub_return(struct folio *folio, int nr)
 {
-	int ret = atomic_sub_return(nr, &page->_refcount);
+	int ret = atomic_sub_return(nr, &folio->_refcount);
 
 	if (page_ref_tracepoint_active(page_ref_mod_and_return))
-		__page_ref_mod_and_return(page, -nr, ret);
+		__page_ref_mod_and_return(&folio->page, -nr, ret);
 	return ret;
 }
 
-static inline int folio_ref_sub_return(struct folio *folio, int nr)
-{
-	return page_ref_sub_return(&folio->page, nr);
-}
-
 static inline void page_ref_inc(struct page *page)
 {
 	atomic_inc(&page->_refcount);
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

