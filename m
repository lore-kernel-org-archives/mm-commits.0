Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F4521D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489989; cv=none; b=hDhEOO/fJGsYpc+zy++n5nXuIT+RcmMyJQRhv05DiN4NluRVvSnGxl7GtQYg6W+4bwixDHsPYybOKskRzyRWwo31pTs1u3CHKLcggaFtj4WLTz6Num91M6r38WMnkRv+FeOXiDBJ7sW8m0uwgQlbGsIg82S8YXTQHao908EcrY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489989; c=relaxed/simple;
	bh=77VrIafMjbaGsXN38RQa0XUBy0K9hb2UmH9mfxw6rN0=;
	h=Date:To:From:Subject:Message-Id; b=X8nPfwGH4rtDD47EYQnuGrt+sHRj/ec5QmV9d63HaXwYNXwjRdK5m00FBPuIHLsyRUFyX571KwIuc3t37pHTe44BqAgRN44wcwdMGU5qTrxh27V1ANAyRStgUltk2Hip07GjcWdoFF+fMCXbEmI8wSbyQdk9yiLpjb+Cx0rvstc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BnjTFgDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BnjTFgDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9B0C4CEE7;
	Sun, 21 Sep 2025 21:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489989;
	bh=77VrIafMjbaGsXN38RQa0XUBy0K9hb2UmH9mfxw6rN0=;
	h=Date:To:From:Subject:From;
	b=BnjTFgDyUD8Bne/Zvj434dDmR9twGfRdVgnodb/fEiVKQmEQSUX4rlUGkUOYScBP9
	 mCfYUHkkp0Ec6IObVkjtD6q3SrxH+ONFkMxa8CvCgSyQOSgEv6UlROUfyLuVYRIWFd
	 U4iUX6JiNFVMpMUDcLdnuHI49N27+w/l3d2c7wqM=
Date: Sun, 21 Sep 2025 14:26:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,simona@ffwll.ch,mripard@kernel.org,maarten.lankhorst@linux.intel.com,david@redhat.com,akpm@linux-foundation.org,airlied@gmail.com,aris@ruivo.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-folio-page-count-functions-return-unsigned.patch removed from -mm tree
Message-Id: <20250921212629.2D9B0C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make folio page count functions return unsigned
has been removed from the -mm tree.  Its filename was
     mm-make-folio-page-count-functions-return-unsigned.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aristeu Rozanski <aris@ruivo.org>
Subject: mm: make folio page count functions return unsigned
Date: Tue, 26 Aug 2025 11:37:21 -0400

As raised by Andrew [1], a folio/compound page never spans a negative
number of pages.  Consequently, let's use "unsigned long" instead of
"long" consistently for folio_nr_pages(), folio_large_nr_pages() and
compound_nr().

Using "unsigned long" as return value is fine, because even
"(long)-folio_nr_pages()" will keep on working as expected.  Using
"unsigned int" instead would actually break these use cases.

This patch takes the first step changing these to return unsigned long
(and making drm_gem_get_pages() use the new types instead of replacing
min()).

In the future, we might want to make more callers of these functions to
consistently use "unsigned long".


Link: https://lore.kernel.org/linux-mm/20250503182858.5a02729fcffd6d4723afcfc2@linux-foundation.org/
Link: https://lkml.kernel.org/r/20250826153721.GA23292@cathedrallabs.org
Link: https://lore.kernel.org/linux-mm/20250503182858.5a02729fcffd6d4723afcfc2@linux-foundation.org/ [1]
Signed-off-by: Aristeu Rozanski <aris@ruivo.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_gem.c |    4 ++--
 include/linux/mm.h        |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c~mm-make-folio-page-count-functions-return-unsigned
+++ a/drivers/gpu/drm/drm_gem.c
@@ -621,7 +621,7 @@ struct page **drm_gem_get_pages(struct d
 	struct page **pages;
 	struct folio *folio;
 	struct folio_batch fbatch;
-	long i, j, npages;
+	unsigned long i, j, npages;
 
 	if (WARN_ON(!obj->filp))
 		return ERR_PTR(-EINVAL);
@@ -645,7 +645,7 @@ struct page **drm_gem_get_pages(struct d
 
 	i = 0;
 	while (i < npages) {
-		long nr;
+		unsigned long nr;
 		folio = shmem_read_folio_gfp(mapping, i,
 				mapping_gfp_mask(mapping));
 		if (IS_ERR(folio))
--- a/include/linux/mm.h~mm-make-folio-page-count-functions-return-unsigned
+++ a/include/linux/mm.h
@@ -1018,12 +1018,12 @@ static inline unsigned int folio_large_o
 }
 
 #ifdef NR_PAGES_IN_LARGE_FOLIO
-static inline long folio_large_nr_pages(const struct folio *folio)
+static inline unsigned long folio_large_nr_pages(const struct folio *folio)
 {
 	return folio->_nr_pages;
 }
 #else
-static inline long folio_large_nr_pages(const struct folio *folio)
+static inline unsigned long folio_large_nr_pages(const struct folio *folio)
 {
 	return 1L << folio_large_order(folio);
 }
@@ -2062,7 +2062,7 @@ static inline void set_page_links(struct
  *
  * Return: A positive power of two.
  */
-static inline long folio_nr_pages(const struct folio *folio)
+static inline unsigned long folio_nr_pages(const struct folio *folio)
 {
 	if (!folio_test_large(folio))
 		return 1;
@@ -2097,7 +2097,7 @@ static inline long folio_nr_pages(const
  * page.  compound_nr() can be called on a tail page, and is defined to
  * return 1 in that case.
  */
-static inline long compound_nr(const struct page *page)
+static inline unsigned long compound_nr(const struct page *page)
 {
 	const struct folio *folio = (struct folio *)page;
 
_

Patches currently in -mm which might be from aris@ruivo.org are


