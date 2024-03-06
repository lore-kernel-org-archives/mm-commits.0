Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00AC175AD
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759108; cv=none; b=byYMS0GYHopcdFAK+9Sd0d7hJsG+Ml9iv7Eoym9YnPwz+xI7Ip5OHajij2HN8AIz9nhYE6aSkQC95mIoQm+Z+Md/tpI70rCcU/gulaJTBMGQ5E1YJlZ7qHy070JF6aTQrFAfIyQtl0FmWvHejyKWzqcqFgQ1gngY/nCMdmcr394=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759108; c=relaxed/simple;
	bh=E8z8nU3zv/ZTnsMPtG8wDcEnY2qWNP0Zins3ScAlKes=;
	h=Date:To:From:Subject:Message-Id; b=fEehSQ3k6lyVl26kVJ3aIUt0dK1Br+OOQOlAHDcZJQCPU2OlwqrJGz5RVBahwvX1gaQPugYs5lXCU7Gn8VNTtkd4y0hHal8G5sqV+TEGl3+uh9G4DUgycTt4dczq8pCT6TBLAfuJqOXS3RE93ULa7w8M5o+H4H4gKFjQkXHYjt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kk/qwjU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kk/qwjU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F3DC433C7;
	Wed,  6 Mar 2024 21:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759108;
	bh=E8z8nU3zv/ZTnsMPtG8wDcEnY2qWNP0Zins3ScAlKes=;
	h=Date:To:From:Subject:From;
	b=kk/qwjU2Ai7rNFgWpvKmrb/3zHjNh1JvkCspfL2gGS6p6gjb4eW5HXCOQV1ZcNddz
	 HTuJXAVFvUDUJ8Hw+SDj9h12smFsA2mNuFZmsHfHH4FrLGxiGta8Aqrvkwod2phqO6
	 s4s2migMlK+XgSidvNSTHqUbEziCdfUpgyrl1JZ0=
Date: Wed, 06 Mar 2024 13:05:08 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-cast-from-page_to_nid.patch removed from -mm tree
Message-Id: <20240306210508.89F3DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove cast from page_to_nid()
has been removed from the -mm tree.  Its filename was
     mm-remove-cast-from-page_to_nid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove cast from page_to_nid()
Date: Tue, 27 Feb 2024 19:23:35 +0000

Now that PF_POISONED_CHECK() can take a const argument, we can drop
the cast.

Link: https://lkml.kernel.org/r/20240227192337.757313-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-remove-cast-from-page_to_nid
+++ a/include/linux/mm.h
@@ -1641,13 +1641,11 @@ static inline int page_zone_id(struct pa
 }
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
-extern int page_to_nid(const struct page *page);
+int page_to_nid(const struct page *page);
 #else
 static inline int page_to_nid(const struct page *page)
 {
-	struct page *p = (struct page *)page;
-
-	return (PF_POISONED_CHECK(p)->flags >> NODES_PGSHIFT) & NODES_MASK;
+	return (PF_POISONED_CHECK(page)->flags >> NODES_PGSHIFT) & NODES_MASK;
 }
 #endif
 
_

Patches currently in -mm which might be from willy@infradead.org are


