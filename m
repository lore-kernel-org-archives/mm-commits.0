Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7633D7D9C;
	Tue, 21 Apr 2026 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776781048; cv=none; b=nZoqnDI6P23Vcx3oQOZd92SLSUYehBWgxU4/bf5MULlFfUQ532GHNS+MFp2rbX+BIO5NQa26pxurtdKPd1aim4jmheEIjqWogQ9+ClA25eZO+ynGj70ojz6V8rsRZ/MN1gW+X5cKh9Oc1NjZakvNffZXXZ7eN5EW8upfxGffBHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776781048; c=relaxed/simple;
	bh=Vf1of4GLySLD7oK8b9wZ1HKZdDzqGPC7zKIQYqW3yiU=;
	h=Date:To:From:Subject:Message-Id; b=UIAcUWitKA8cX4pL5HbuGn3VgA4vU6Nz+C7kWofwn0gTY1sMoU7O1qBZJnM65cVTCYEPRf/6CdAPTs3kFeMDmRqvwu5qoYbt8V7ntzMIvzVzBlxRg6ADN96rvweq66Sxy3i0IqECNc5ViL59NeULQQX2CzKtQLP7C2xB9ctl/84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Px83A7oa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Px83A7oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97262C2BCB0;
	Tue, 21 Apr 2026 14:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776781048;
	bh=Vf1of4GLySLD7oK8b9wZ1HKZdDzqGPC7zKIQYqW3yiU=;
	h=Date:To:From:Subject:From;
	b=Px83A7oa4COkMxHyjJ6jXJCxfm2Pt0qkwIAbY5optTFZvbPLW2SV894NylXF4FZyB
	 xb16JXJI9CL6om9y5wqhCiRzhb3BWLrML7Khqp08k9p9WNNsAc9Fl3+/wtjpyCC0Le
	 Ic/Eukm1uG4k2d5JBEW9tF8HcA+HwTUaz0RqElek=
Date: Tue, 21 Apr 2026 07:17:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,surenb@google.com,stable@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,catalin.marinas@arm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch removed from -mm tree
Message-Id: <20260421141727.97262C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: fix initialization of tags of the huge zero folio with init_on_free
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/page_alloc: fix initialization of tags of the huge zero folio with init_on_free
Date: Mon, 20 Apr 2026 23:16:46 +0200

__GFP_ZEROTAGS semantics are currently a bit weird, but effectively this
flag is only ever set alongside __GFP_ZERO and __GFP_SKIP_KASAN.

If we run with init_on_free, we will zero out pages during
__free_pages_prepare(), to skip zeroing on the allocation path.

However, when allocating with __GFP_ZEROTAG set, post_alloc_hook() will
consequently not only skip clearing page content, but also skip clearing
tag memory.

Not clearing tags through __GFP_ZEROTAGS is irrelevant for most pages that
will get mapped to user space through set_pte_at() later: set_pte_at() and
friends will detect that the tags have not been initialized yet
(PG_mte_tagged not set), and initialize them.

However, for the huge zero folio, which will be mapped through a PMD
marked as special, this initialization will not be performed, ending up
exposing whatever tags were still set for the pages.

The docs (Documentation/arch/arm64/memory-tagging-extension.rst) state
that allocation tags are set to 0 when a page is first mapped to user
space.  That no longer holds with the huge zero folio when init_on_free is
enabled.

Fix it by decoupling __GFP_ZEROTAGS from __GFP_ZERO, passing to
tag_clear_highpages() whether we want to also clear page content.

As we are touching the interface either way, just clean it up by only
calling it when HW tags are enabled, dropping the return value, and
dropping the common code stub.

Reproduced with the huge zero folio by modifying the check_buffer_fill
arm64/mte selftest to use a 2 MiB area, after making sure that pages have
a non-0 tag set when freeing (note that, during boot, we will not actually
initialize tags, but only set KASAN_TAG_KERNEL in the page flags).

	$ ./check_buffer_fill
	1..20
	...
	not ok 17 Check initial tags with private mapping, sync error mode and mmap memory
	not ok 18 Check initial tags with private mapping, sync error mode and mmap/mprotect memory
	...

This code needs more cleanups; we'll tackle that next, like decoupling
__GFP_ZEROTAGS from __GFP_SKIP_KASAN, moving all the KASAN magic into a
separate helper, and consolidating HW-tag handling.

Link: https://lore.kernel.org/20260420-zerotags-v1-1-3edc93e95bb4@kernel.org
Fixes: adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero folio")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/page.h |    3 ---
 arch/arm64/mm/fault.c         |   16 +++++-----------
 include/linux/gfp_types.h     |   10 +++++-----
 include/linux/highmem.h       |   10 +---------
 mm/page_alloc.c               |   12 +++++++-----
 5 files changed, 18 insertions(+), 33 deletions(-)

--- a/arch/arm64/include/asm/page.h~mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free
+++ a/arch/arm64/include/asm/page.h
@@ -33,9 +33,6 @@ struct folio *vma_alloc_zeroed_movable_f
 						unsigned long vaddr);
 #define vma_alloc_zeroed_movable_folio vma_alloc_zeroed_movable_folio
 
-bool tag_clear_highpages(struct page *to, int numpages);
-#define __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
-
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 typedef struct page *pgtable_t;
--- a/arch/arm64/mm/fault.c~mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free
+++ a/arch/arm64/mm/fault.c
@@ -1018,21 +1018,15 @@ struct folio *vma_alloc_zeroed_movable_f
 	return vma_alloc_folio(flags, 0, vma, vaddr);
 }
 
-bool tag_clear_highpages(struct page *page, int numpages)
+void tag_clear_highpages(struct page *page, int numpages, bool clear_pages)
 {
-	/*
-	 * Check if MTE is supported and fall back to clear_highpage().
-	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
-	 * post_alloc_hook() will invoke tag_clear_highpages().
-	 */
-	if (!system_supports_mte())
-		return false;
-
 	/* Newly allocated pages, shouldn't have been tagged yet */
 	for (int i = 0; i < numpages; i++, page++) {
 		WARN_ON_ONCE(!try_page_mte_tagging(page));
-		mte_zero_clear_page_tags(page_address(page));
+		if (clear_pages)
+			mte_zero_clear_page_tags(page_address(page));
+		else
+			mte_clear_page_tags(page_address(page));
 		set_page_mte_tagged(page);
 	}
-	return true;
 }
--- a/include/linux/gfp_types.h~mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free
+++ a/include/linux/gfp_types.h
@@ -273,11 +273,11 @@ enum {
  *
  * %__GFP_ZERO returns a zeroed page on success.
  *
- * %__GFP_ZEROTAGS zeroes memory tags at allocation time if the memory itself
- * is being zeroed (either via __GFP_ZERO or via init_on_alloc, provided that
- * __GFP_SKIP_ZERO is not set). This flag is intended for optimization: setting
- * memory tags at the same time as zeroing memory has minimal additional
- * performance impact.
+ * %__GFP_ZEROTAGS zeroes memory tags at allocation time. This flag is intended
+ * for optimization: setting memory tags at the same time as zeroing memory
+ * (e.g., with __GPF_ZERO) has minimal additional performance impact. However,
+ * __GFP_ZEROTAGS also zeroes the tags even if memory is not getting zeroed at
+ * allocation time (e.g., with init_on_free).
  *
  * %__GFP_SKIP_KASAN makes KASAN skip unpoisoning on page allocation.
  * Used for userspace and vmalloc pages; the latter are unpoisoned by
--- a/include/linux/highmem.h~mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free
+++ a/include/linux/highmem.h
@@ -345,15 +345,7 @@ static inline void clear_highpage_kasan_
 	kunmap_local(kaddr);
 }
 
-#ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
-
-/* Return false to let people know we did not initialize the pages */
-static inline bool tag_clear_highpages(struct page *page, int numpages)
-{
-	return false;
-}
-
-#endif
+void tag_clear_highpages(struct page *to, int numpages, bool clear_pages);
 
 /*
  * If we pass in a base or tail page, we can zero up to PAGE_SIZE.
--- a/mm/page_alloc.c~mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free
+++ a/mm/page_alloc.c
@@ -1808,9 +1808,9 @@ static inline bool should_skip_init(gfp_
 inline void post_alloc_hook(struct page *page, unsigned int order,
 				gfp_t gfp_flags)
 {
+	const bool zero_tags = kasan_hw_tags_enabled() && (gfp_flags & __GFP_ZEROTAGS);
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
-	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
 	int i;
 
 	set_page_private(page, 0);
@@ -1832,11 +1832,13 @@ inline void post_alloc_hook(struct page
 	 */
 
 	/*
-	 * If memory tags should be zeroed
-	 * (which happens only when memory should be initialized as well).
+	 * Clearing tags can efficiently clear the memory for us as well, if
+	 * required.
 	 */
-	if (zero_tags)
-		init = !tag_clear_highpages(page, 1 << order);
+	if (zero_tags) {
+		tag_clear_highpages(page, 1 << order, /* clear_pages= */init);
+		init = false;
+	}
 
 	if (!should_skip_kasan_unpoison(gfp_flags) &&
 	    kasan_unpoison_pages(page, order, init)) {
_

Patches currently in -mm which might be from david@kernel.org are


