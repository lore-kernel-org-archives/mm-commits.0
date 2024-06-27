Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34CB2139CB
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 01:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719451513; cv=none; b=J3/p9zrbLnCvBPd6VmWcdFOj9XweNv5wEbaLqbhJ/o79SDaawbmlI34UmecLInpYWuXz+YzF1tXkdvo484qqKm+raUWRy9Q2LiHu2TkLCJR4ubuy+tOrvvxAKMtgMwqpwa8Ewuxi8SCOEspPlbCUdUHGT81QnIoGfr/HSEYOdL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719451513; c=relaxed/simple;
	bh=GhbipRfkFMklPCKpDNE99umqoZ3H3RYMB6d6p3W4IAc=;
	h=Date:To:From:Subject:Message-Id; b=o92HTJN022b79FWGQzPVaGf5paWI5DD2w1W7JmKeK22VwRDB0sBRzzR8NM9wpcZJnLJmfYconmQ2LjVhdjiFR18bpMdLrlwt9QudX3uDxWD+7yTkjB3P7EbMqDlHthURazJGaSRBP17xnw6EuzxODqmMnYXmtqraJBsulEzzj9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=erH6nzKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="erH6nzKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472F5C4AF07;
	Thu, 27 Jun 2024 01:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719451513;
	bh=GhbipRfkFMklPCKpDNE99umqoZ3H3RYMB6d6p3W4IAc=;
	h=Date:To:From:Subject:From;
	b=erH6nzKyXVyzmXzL2hi3a66vxlxhMSrxL62amfXGx5FDbBU6HQoaYuu5Ta+wGx3Y3
	 Y2WKM+GvFlXJYUKG6WuW8mVUWovEiHSvw/vtfzkUETwZJUd+cKzHa5o9zU2avnvSXa
	 ADMtOBiw5ee8iSpTGTF8bf1vT5m3N7iOiO4eim/0=
Date: Wed, 26 Jun 2024 18:25:12 -0700
To: mm-commits@vger.kernel.org,zhenyzha@redhat.com,willy@infradead.org,william.kucharski@oracle.com,torvalds@linux-foundation.org,stable@kernel.org,ryan.roberts@arm.com,hughd@google.com,djwong@kernel.org,ddutile@redhat.com,david@redhat.com,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-limit-page-cache-size-in-page_cache_ra_order.patch added to mm-hotfixes-unstable branch
Message-Id: <20240627012513.472F5C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: limit page cache size in page_cache_ra_order()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-readahead-limit-page-cache-size-in-page_cache_ra_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-limit-page-cache-size-in-page_cache_ra_order.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: <stable@kernel.org>	[5.18+]
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

mm-filemap-make-max_pagecache_order-acceptable-to-xarray.patch
mm-readahead-limit-page-cache-size-in-page_cache_ra_order.patch
mm-filemap-skip-to-create-pmd-sized-page-cache-if-needed.patch
mm-shmem-disable-pmd-sized-page-cache-if-needed.patch

