Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FA8FBF6;
	Thu,  4 Jul 2024 05:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720071727; cv=none; b=DgUuikjLRBmI4cWG/I+SkD4pJWGjp2sy1iMuIg5+l5LayFHHi78yZQnk7NkP6uBjd9FccHXVBJvG1nBlFcFVmNn6GPVqPEQZkp38mGKRICUdXhfCu+YNzFe4/dVd42/sjs8BlgNgq3lTYn0xf++PUR/7ToMhVVHBY4aVEOsn7DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720071727; c=relaxed/simple;
	bh=K6NlnAw++8CqzztrBpFFMY0sfketZ8GxOkO2DfEWo4I=;
	h=Date:To:From:Subject:Message-Id; b=F1m5RCC3c6zuvhhNkO21GLWTVl/7vBOMymDTtsyLQLZAVATUc10/hwb265Yxya93wUiBBFbTXxyUA5ZFZ9wR5v7sh+Ir/L24GG8uSt1qgaYOfXf70jGYY/GCUMGFedf/NYA6ZnX9lnSADwdyoLjijofjy75Dz51eq9to1GUmueU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=myMjUefa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="myMjUefa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E602C3277B;
	Thu,  4 Jul 2024 05:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720071727;
	bh=K6NlnAw++8CqzztrBpFFMY0sfketZ8GxOkO2DfEWo4I=;
	h=Date:To:From:Subject:From;
	b=myMjUefa00IQAlQi+yuAmirNtIFH8ZJBUWjXbzmk1Rtpixp42bmrtBlk1dZyZg4c7
	 8sdy1Z//Xhc6qI+j/aKqZkI4W7ciSziRZRojLMoHi+LYRiY1pt1F7n/mmSBCQ92BaB
	 pcUFcqYiVseXWPdhDlIhurnIkQVakY9BgRL4kfU8=
Date: Wed, 03 Jul 2024 22:42:06 -0700
To: mm-commits@vger.kernel.org,zhenyzha@redhat.com,willy@infradead.org,william.kucharski@oracle.com,torvalds@linux-foundation.org,stable@vger.kernel.org,ryan.roberts@arm.com,hughd@google.com,djwong@kernel.org,ddutile@redhat.com,david@redhat.com,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-readahead-limit-page-cache-size-in-page_cache_ra_order.patch removed from -mm tree
Message-Id: <20240704054207.0E602C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/readahead: limit page cache size in page_cache_ra_order()
has been removed from the -mm tree.  Its filename was
     mm-readahead-limit-page-cache-size-in-page_cache_ra_order.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/readahead: limit page cache size in page_cache_ra_order()
Date: Thu, 27 Jun 2024 10:39:50 +1000

In page_cache_ra_order(), the maximal order of the page cache to be
allocated shouldn't be larger than MAX_PAGECACHE_ORDER.  Otherwise, it's
possible the large page cache can't be supported by xarray when the
corresponding xarray entry is split.

For example, HPAGE_PMD_ORDER is 13 on ARM64 when the base page size is
64KB.  The PMD-sized page cache can't be supported by xarray.

Link: https://lkml.kernel.org/r/20240627003953.1262512-3-gshan@redhat.com
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Zhenyu Zhang <zhenyzha@redhat.com>
Cc: <stable@vger.kernel.org>	[5.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/readahead.c~mm-readahead-limit-page-cache-size-in-page_cache_ra_order
+++ a/mm/readahead.c
@@ -503,11 +503,11 @@ void page_cache_ra_order(struct readahea
 
 	limit = min(limit, index + ra->size - 1);
 
-	if (new_order < MAX_PAGECACHE_ORDER) {
+	if (new_order < MAX_PAGECACHE_ORDER)
 		new_order += 2;
-		new_order = min_t(unsigned int, MAX_PAGECACHE_ORDER, new_order);
-		new_order = min_t(unsigned int, new_order, ilog2(ra->size));
-	}
+
+	new_order = min_t(unsigned int, MAX_PAGECACHE_ORDER, new_order);
+	new_order = min_t(unsigned int, new_order, ilog2(ra->size));
 
 	/* See comment in page_cache_ra_unbounded() */
 	nofs = memalloc_nofs_save();
_

Patches currently in -mm which might be from gshan@redhat.com are


