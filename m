Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439F02857F0
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126305; cv=none; b=t7bbLBXAhLekEbE+jzrtFoRzf1yrOtcr+l2X8bL6gVQ+W1uv30oQWF3oAsRpi7JWLT/I/zDecBLc8CT1hFtLxJbDdqN/hofjHUoHbjrqIsXIeq1enzL2ULtI0y+eaaIJ9KE+QFnneV3lhD20Y9DY0HOHa+40itx742nLNYNw3Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126305; c=relaxed/simple;
	bh=x+9Qu6x2w9EKcNUczMOzxRljd/W246w/pTGjFUROOdI=;
	h=Date:To:From:Subject:Message-Id; b=ilx27bJD8Z9H0TYrtMi19R2OFgUEQ3VE732dXfCGi6PGe+iaNHbBhIsorm/XfPK2ezSUxvKhRZAfYhtEzFU0tH2RIuYjO83LRn59jYR5TQociELkVxyDpoyvfcojENIv9kqiCeD4fUPxN8WffGDIO736lXe2nZ8HRfj147pH57U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wcYQNl+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wcYQNl+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CADC4CEE3;
	Thu, 10 Jul 2025 05:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126304;
	bh=x+9Qu6x2w9EKcNUczMOzxRljd/W246w/pTGjFUROOdI=;
	h=Date:To:From:Subject:From;
	b=wcYQNl+/Fc3FLHu7qRZX+JGjy/0Zh53G0PrWIsZj9zpDXn5jUxME4NLB2yhutLD0c
	 onAPoYUp5VtK0qOVk72BABcB5cVH8f9mBwgDw1WsZIqcDz2+QHDbdgBbjdmdLEvmQe
	 /Zp+ksTR0YVOsg1GO0t3pw3dK/30ELpyFcOVn+Z8=
Date: Wed, 09 Jul 2025 22:45:04 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] highmem-remove-a-use-of-folio-page.patch removed from -mm tree
Message-Id: <20250710054504.C6CADC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: highmem: remove a use of folio->page
has been removed from the -mm tree.  Its filename was
     highmem-remove-a-use-of-folio-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: highmem: remove a use of folio->page
Date: Fri, 13 Jun 2025 20:48:23 +0100

Call folio_address() instead of page_address().

Link: https://lkml.kernel.org/r/20250613194825.3175276-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/highmem-internal.h~highmem-remove-a-use-of-folio-page
+++ a/include/linux/highmem-internal.h
@@ -195,7 +195,7 @@ static inline void *kmap_local_page_try_
 
 static inline void *kmap_local_folio(struct folio *folio, size_t offset)
 {
-	return page_address(&folio->page) + offset;
+	return folio_address(folio) + offset;
 }
 
 static inline void *kmap_local_page_prot(struct page *page, pgprot_t prot)
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

