Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D17E24C068
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 21:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757541387; cv=none; b=CAHo65NOIh4k4JTS1ukf7Dbl31rxeXRCzeXMxm169FuGCIOk8H/6/FBrErW5qOfKXLrdfhb9Az9/HvteraAdXjpIWOl5ev4dHIHjWcpcw7orfjXyMc5hlFkzOXGExLHlw0q7cYNt3aoPodB8WroFB7yhjl7pQrKpIsNtkwKwUzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757541387; c=relaxed/simple;
	bh=noR7KVsPmk0ITIepiGFWk74upJNmuBIyTGUphqYePe8=;
	h=Date:To:From:Subject:Message-Id; b=g5ZXSsguJW3BGc3oCmskSBw2oMG4M/42fTtQ4cDUGUs8YjLsOvd3beRnO67Tg4THHMKaPLdsaMAedmA+QKKMzH3i4HYh3olSSRy2hDv8xZy7OT6xFGAU6+NR+xAUUZmLy8clNMwYoQhp4cc04/jg08iRDPiE61cs158Kqo49apE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gDrhv6XX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gDrhv6XX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8205BC4CEEB;
	Wed, 10 Sep 2025 21:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757541386;
	bh=noR7KVsPmk0ITIepiGFWk74upJNmuBIyTGUphqYePe8=;
	h=Date:To:From:Subject:From;
	b=gDrhv6XXCBdttC/Yt9mAU9VSvFTiHaWoI0JRs0FAGogHAvJrwj1V457B49vf5nCy/
	 GpN6gePv+gK0GqUMz4/zIWWiK+1vGgxWmLOIzt8oJkEFgQmJQ1+rEqNlaCVDG2E50w
	 +8wFS1f+NUtn2s6RgxlZHRlYi5UNc+wEP9nV/qyE=
Date: Wed, 10 Sep 2025 14:56:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,simona@ffwll.ch,mripard@kernel.org,maarten.lankhorst@linux.intel.com,david@redhat.com,akpm@linux-foundation.org,airlied@gmail.com,aris@ruivo.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-folio-page-count-functions-return-unsigned.patch added to mm-new branch
Message-Id: <20250910215626.8205BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make folio page count functions return unsigned
has been added to the -mm mm-new branch.  Its filename is
     mm-make-folio-page-count-functions-return-unsigned.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-folio-page-count-functions-return-unsigned.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
@@ -1033,12 +1033,12 @@ static inline unsigned int folio_large_o
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
@@ -2078,7 +2078,7 @@ static inline void set_page_links(struct
  *
  * Return: A positive power of two.
  */
-static inline long folio_nr_pages(const struct folio *folio)
+static inline unsigned long folio_nr_pages(const struct folio *folio)
 {
 	if (!folio_test_large(folio))
 		return 1;
@@ -2113,7 +2113,7 @@ static inline long folio_nr_pages(const
  * page.  compound_nr() can be called on a tail page, and is defined to
  * return 1 in that case.
  */
-static inline long compound_nr(const struct page *page)
+static inline unsigned long compound_nr(const struct page *page)
 {
 	const struct folio *folio = (struct folio *)page;
 
_

Patches currently in -mm which might be from aris@ruivo.org are

mm-make-folio-page-count-functions-return-unsigned.patch

