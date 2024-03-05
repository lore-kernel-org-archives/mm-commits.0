Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D18C8C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600557; cv=none; b=bQowGjDQfZOCF46bASCpqLlxKEl5cjTctGmkMkyg4UEAl0CiyAft7ekrKEln55x765Cwj/uhvGyT9fimIQccZ110vGo+IjmY32vPjHTW/0z6QdU2Sd2MSWcHOTiSIFvALZmrhl5Rsj7xRmx0HsIvqrPGKAuWLPJWvSydzFjhXmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600557; c=relaxed/simple;
	bh=XgmAKDP23PWxN5srduZLwXgIUcXdP3fyYeQPVxVjwLw=;
	h=Date:To:From:Subject:Message-Id; b=MnAnnp7oAvDySvuFEbDfYjKAOQoueeMnFDTEWocwm5zWn9Hf72Pa9BTijE37YVD/tgnIi7M58ZK2AIKZc/OYMh3aE7tvD9INodVyMq9NX/g+qE9S4gx7MfjR6bvfFTJRkcZOuQIzCINuEocDoy3hNbiXd/embgDqQE+1v/wQJjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2JHGb26H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2JHGb26H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BF1C43394;
	Tue,  5 Mar 2024 01:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600556;
	bh=XgmAKDP23PWxN5srduZLwXgIUcXdP3fyYeQPVxVjwLw=;
	h=Date:To:From:Subject:From;
	b=2JHGb26HZ1jPom6OQ1zxDk9TUjPLGoGKDgJhTkc7bRN7CA0G1Nt4zOb+9KuwldRVq
	 JlmBiS1pi1ohApW7EmrjfgQ9vHnaxLLDXQ24ECYay0k8BzRmvbIzG3knO/kqDY6Ev1
	 kBLMvs5a0g2OebjxeG1yPp6Slzlq6FTiVPQJYIxI=
Date: Mon, 04 Mar 2024 17:02:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-total_mapcount.patch removed from -mm tree
Message-Id: <20240305010236.D5BF1C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove total_mapcount()
has been removed from the -mm tree.  Its filename was
     mm-remove-total_mapcount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: remove total_mapcount()
Date: Mon, 26 Feb 2024 15:13:24 +0100

All users of total_mapcount() are gone, let's remove it.

Link: https://lkml.kernel.org/r/20240226141324.278526-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-remove-total_mapcount
+++ a/include/linux/mm.h
@@ -1183,7 +1183,7 @@ static inline int is_vmalloc_or_module_a
  * How many times the entire folio is mapped as a single unit (eg by a
  * PMD or PUD entry).  This is probably not what you want, except for
  * debugging purposes - it does not include PTE-mapped sub-pages; look
- * at folio_mapcount() or page_mapcount() or total_mapcount() instead.
+ * at folio_mapcount() or page_mapcount() instead.
  */
 static inline int folio_entire_mapcount(struct folio *folio)
 {
@@ -1243,13 +1243,6 @@ static inline int folio_mapcount(struct
 	return folio_total_mapcount(folio);
 }
 
-static inline int total_mapcount(struct page *page)
-{
-	if (likely(!PageCompound(page)))
-		return atomic_read(&page->_mapcount) + 1;
-	return folio_total_mapcount(page_folio(page));
-}
-
 static inline bool folio_large_is_mapped(struct folio *folio)
 {
 	/*
_

Patches currently in -mm which might be from david@redhat.com are


