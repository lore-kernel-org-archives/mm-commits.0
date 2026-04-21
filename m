Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B193630B5;
	Tue, 21 Apr 2026 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776787446; cv=none; b=EfEc9kT3x5h2IOMCYnNRPYlrwIWNKBZJb6CU/CxsWOLSTr+d6iPezMtr81sr0TJfNSNxDe2M1PS02M8BWr37pjWsKLQ6sYVh1SBVMZfgyZoORHgCiSJavtai0wJKrk1RpzK+5tY92o+FdCMH6/T9Lr6AqaY0Yp7u7Y3iCr8sMlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776787446; c=relaxed/simple;
	bh=KsEQ1onQpEORvwjFh5CtOJ13soNipDt4Ky9XZ0A6d7A=;
	h=Date:To:From:Subject:Message-Id; b=rweDrqG4ID6j4Go69ei1Gw6fqBxDk3RdBBSjD/Xr6CcOq2LPB83Yxc0kQGv0CWcgnvAYodKUvcnjzit44Epms5FAMzf1e/w+T/sCnSQPr3nF5zr/xgkN1PjoXgyyOS/q4k+C2pCB1SrPz2yP9LqVRJ8dWLGkrzWfn/oJWDBxQ7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RV+rMqKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RV+rMqKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C55C2BCB3;
	Tue, 21 Apr 2026 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776787445;
	bh=KsEQ1onQpEORvwjFh5CtOJ13soNipDt4Ky9XZ0A6d7A=;
	h=Date:To:From:Subject:From;
	b=RV+rMqKgLttEH6fG5SrFKy/A0IelIbD/XMpXQYs6VIGg+qKMMW82FXW2abUMbyV1X
	 Kqx6XzJvITwrAkqMa97e+6vTJqg+eIpc4iVxqhOx7isl0PWKJ0GVoF7IeBfppi+2u4
	 7XSAwq9eQxjoGM4FYwvh1UVULA19cGhssVxEc4jw=
Date: Tue, 21 Apr 2026 09:04:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,surenb@google.com,stable@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,catalin.marinas@arm.com,broonie@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch added to mm-new branch
Message-Id: <20260421160405.24C55C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: fix initialization of tags of the huge zero folio with init_on_free
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/page_alloc: fix initialization of tags of the huge zero folio with init_on_free
Date: Tue, 21 Apr 2026 17:39:07 +0200

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

Invert the meaning of the tag_clear_highpages() return value to have
clearer semantics.

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

This code needs more cleanups; we'll tackle that next, like
decoupling __GFP_ZEROTAGS from __GFP_SKIP_KASAN.

Link: https://lore.kernel.org/20260421-zerotags-v2-1-05cb1035482e@kernel.org
Fixes: adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero folio")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/page.h |    2 +-
 arch/arm64/mm/fault.c         |   11 +++++++----
 include/linux/gfp_types.h     |   10 +++++-----
 include/linux/highmem.h       |    7 ++++---
 mm/page_alloc.c               |    8 ++++----
 5 files changed, 21 insertions(+), 17 deletions(-)

--- a/arch/arm64/include/asm/page.h~mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free
+++ a/arch/arm64/include/asm/page.h
@@ -33,7 +33,7 @@ struct folio *vma_alloc_zeroed_movable_f
 						unsigned long vaddr);
 #define vma_alloc_zeroed_movable_folio vma_alloc_zeroed_movable_folio
 
-bool tag_clear_highpages(struct page *to, int numpages);
+bool tag_clear_highpages(struct page *to, int numpages, bool clear_pages);
 #define __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
 
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
--- a/arch/arm64/mm/fault.c~mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free
+++ a/arch/arm64/mm/fault.c
@@ -1018,7 +1018,7 @@ struct folio *vma_alloc_zeroed_movable_f
 	return vma_alloc_folio(flags, 0, vma, vaddr);
 }
 
-bool tag_clear_highpages(struct page *page, int numpages)
+bool tag_clear_highpages(struct page *page, int numpages, bool clear_pages)
 {
 	/*
 	 * Check if MTE is supported and fall back to clear_highpage().
@@ -1026,13 +1026,16 @@ bool tag_clear_highpages(struct page *pa
 	 * post_alloc_hook() will invoke tag_clear_highpages().
 	 */
 	if (!system_supports_mte())
-		return false;
+		return clear_pages;
 
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
+	return false;
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
+ * %__GFP_ZEROTAGS zeroes memory tags at allocation time. Setting memory tags at
+ * the same time as zeroing memory (e.g., with __GPF_ZERO) has minimal
+ * additional performance impact. However, __GFP_ZEROTAGS also zeroes the tags
+ * even if memory is not getting zeroed at allocation time (e.g.,
+ * with init_on_free).
  *
  * %__GFP_SKIP_KASAN makes KASAN skip unpoisoning on page allocation.
  * Used for userspace and vmalloc pages; the latter are unpoisoned by
--- a/include/linux/highmem.h~mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free
+++ a/include/linux/highmem.h
@@ -347,10 +347,11 @@ static inline void clear_highpage_kasan_
 
 #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
 
-/* Return false to let people know we did not initialize the pages */
-static inline bool tag_clear_highpages(struct page *page, int numpages)
+/* Returns true if the caller has to initialize the pages */
+static inline bool tag_clear_highpages(struct page *page, int numpages,
+		bool clear_pages)
 {
-	return false;
+	return clear_pages;
 }
 
 #endif
--- a/mm/page_alloc.c~mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free
+++ a/mm/page_alloc.c
@@ -1808,9 +1808,9 @@ static inline bool should_skip_init(gfp_
 inline void post_alloc_hook(struct page *page, unsigned int order,
 				gfp_t gfp_flags)
 {
+	const bool zero_tags = gfp_flags & __GFP_ZEROTAGS;
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
-	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
 	int i;
 
 	set_page_private(page, 0);
@@ -1832,11 +1832,11 @@ inline void post_alloc_hook(struct page
 	 */
 
 	/*
-	 * If memory tags should be zeroed
-	 * (which happens only when memory should be initialized as well).
+	 * Clearing tags can efficiently clear the memory for us as well, if
+	 * required.
 	 */
 	if (zero_tags)
-		init = !tag_clear_highpages(page, 1 << order);
+		init = tag_clear_highpages(page, 1 << order, /* clear_pages= */init);
 
 	if (!should_skip_kasan_unpoison(gfp_flags) &&
 	    kasan_unpoison_pages(page, order, init)) {
_

Patches currently in -mm which might be from david@kernel.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch

