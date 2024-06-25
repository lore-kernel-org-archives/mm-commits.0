Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E69148FE4
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340901; cv=none; b=sXA3a+QQsoRho7/4zx73UQMiNRPrW4CeqCu9+J8mAXxdMxBhlHI4UGB/uOwVjBGGXhvpB4KO28YbXVKj3MHSz14FhW7+1dIuHQWcpTofeMVLcsGHAKSENWNsZJ72+Rqu5dFLIacz6UNwicSBvUqRFp3sArU1gp0ssgSlQPpVCp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340901; c=relaxed/simple;
	bh=qxvucTzaREjOFayoRX0VUGAlXF6rgP3YbLnuTdFF+4Y=;
	h=Date:To:From:Subject:Message-Id; b=DaWi5iPBbNoQpUYvp/QsF3BLSl++FdfIAtu/5n3XvKHQ06I3sF50pjpqzvTx+w5TMu0OeXU2q+8lhCd8Zigld1AFAh9hXjA0tU9qDMpUMpQxUV007qrnbnzxxcdwWtPBPqzdEgPKeXdklimhXFmdXZXG/QZebBSHuEcThi/K5zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qUxVGPg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qUxVGPg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7FDC32782;
	Tue, 25 Jun 2024 18:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719340901;
	bh=qxvucTzaREjOFayoRX0VUGAlXF6rgP3YbLnuTdFF+4Y=;
	h=Date:To:From:Subject:From;
	b=qUxVGPg/Qcp5bc7Fw3e2o8UtqPRFs3gf4AMDrh7XACgl2WI1tTfewT4+uSiefxJuG
	 gDFt3ew3uaNaVf2AT1m2Rj5ojKGbyGbnqrZH/JT6Le7qrcICtzr7LqnKKmNTgdzX5O
	 x1soxOmOPARPE3qjY67K5rQlb2S+6eZKcrPVwm9w=
Date: Tue, 25 Jun 2024 11:41:40 -0700
To: mm-commits@vger.kernel.org,zhenyzha@redhat.com,willy@infradead.org,torvalds@linux-foundation.org,hughd@google.com,djwong@kernel.org,david@redhat.com,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-limit-page-cache-size-in-page_cache_ra_order.patch added to mm-unstable branch
Message-Id: <20240625184141.2F7FDC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: limit page cache size in page_cache_ra_order()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-readahead-limit-page-cache-size-in-page_cache_ra_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-limit-page-cache-size-in-page_cache_ra_order.patch

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
From: Gavin Shan <gshan@redhat.com>
Subject: mm/readahead: limit page cache size in page_cache_ra_order()
Date: Tue, 25 Jun 2024 19:06:45 +1000

In page_cache_ra_order(), the maximal order of the page cache to be
allocated shouldn't be larger than MAX_PAGECACHE_ORDER.  Otherwise, it's
possible the large page cache can't be supported by xarray when the
corresponding xarray entry is split.

For example, HPAGE_PMD_ORDER is 13 on ARM64 when the base page size is
64KB.  The PMD-sized page cache can't be supported by xarray.

Link: https://lkml.kernel.org/r/20240625090646.1194644-4-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zhenyu Zhang <zhenyzha@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/readahead.c~mm-readahead-limit-page-cache-size-in-page_cache_ra_order
+++ a/mm/readahead.c
@@ -449,11 +449,11 @@ void page_cache_ra_order(struct readahea
 
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

mm-filemap-make-max_pagecache_order-acceptable-to-xarray.patch
mm-filemap-skip-to-allocate-pmd-sized-folios-if-needed.patch
mm-readahead-limit-page-cache-size-in-page_cache_ra_order.patch
mm-shmem-disable-pmd-sized-page-cache-if-needed.patch

