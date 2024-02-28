Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0690840869
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 18:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146749; cv=none; b=opmhU6A8Hxg2YUrmrGNjf7u1PQ45zR7lmeZq778oHq/wranSPOVLDO6kkeGYLAZhuFE6uHI3G8LxC+f+gFjY7EvgK0utXs04Io0WCMtYqHSyK9ZhRABznzqGxMjLGdZaTn2Yv+cO/jCZHZMcA3abkZ9hfyfK3teIcnYeNhrAqtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146749; c=relaxed/simple;
	bh=FTj+IKC23sdPuRh8JtTDWIFvMBxZx7cj5I3EmNliTZs=;
	h=Date:To:From:Subject:Message-Id; b=m5sOHoL4LwSrcSQ3hrB1wXPw1rxb4gGPQGyyxVV0i+YvKpJsqS5YEYpxrJwvIMU2wZ6Zuu2QOg8lG6Yf8Oyao06DXH7oa1OZorSHbqXzaswUHiM+Biw8Ux4ac/kJT+rm4MOCkKgU6Hmzvh5kmLG4VPm++p8VXIUeKnj8fZrmnEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LsgaA51O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LsgaA51O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DFDC433F1;
	Wed, 28 Feb 2024 18:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709146748;
	bh=FTj+IKC23sdPuRh8JtTDWIFvMBxZx7cj5I3EmNliTZs=;
	h=Date:To:From:Subject:From;
	b=LsgaA51OwHobJXCllX8brWfRrw5h/jO8qRGPvtwAUHX9dm5rv/hEZ36AeCO6BZPhj
	 Rga63cZYlwV6f0/ZWxj+l96LD3iYQkW58qMhtnV9hBPE2+y+tGPJ+yo4RPl3iwQDrJ
	 3XQ3VBgFJenTE2KYtBUkHvI1saiByEKcqWUBaUVQ=
Date: Wed, 28 Feb 2024 10:59:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch added to mm-unstable branch
Message-Id: <20240228185908.B7DFDC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageWaiters, PageSetWaiters and PageClearWaiters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageWaiters, PageSetWaiters and PageClearWaiters
Date: Tue, 27 Feb 2024 19:23:29 +0000

All callers have been converted to use folios.  This was the only user of
PF_ONLY_HEAD, so remove that too.

Link: https://lkml.kernel.org/r/20240227192337.757313-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters
+++ a/include/linux/page-flags.h
@@ -328,9 +328,6 @@ static unsigned long *folio_flags(struct
  *     for compound page all operations related to the page flag applied to
  *     head page.
  *
- * PF_ONLY_HEAD:
- *     for compound page, callers only ever operate on the head page.
- *
  * PF_NO_TAIL:
  *     modifications of the page flag must be done on small or head pages,
  *     checks can be done on tail pages too.
@@ -346,9 +343,6 @@ static unsigned long *folio_flags(struct
 		page; })
 #define PF_ANY(page, enforce)	PF_POISONED_CHECK(page)
 #define PF_HEAD(page, enforce)	PF_POISONED_CHECK(compound_head(page))
-#define PF_ONLY_HEAD(page, enforce) ({					\
-		VM_BUG_ON_PGFLAGS(PageTail(page), page);		\
-		PF_POISONED_CHECK(page); })
 #define PF_NO_TAIL(page, enforce) ({					\
 		VM_BUG_ON_PGFLAGS(enforce && PageTail(page), page);	\
 		PF_POISONED_CHECK(compound_head(page)); })
@@ -362,7 +356,6 @@ static unsigned long *folio_flags(struct
 /* Which page is the flag stored in */
 #define FOLIO_PF_ANY		0
 #define FOLIO_PF_HEAD		0
-#define FOLIO_PF_ONLY_HEAD	0
 #define FOLIO_PF_NO_TAIL	0
 #define FOLIO_PF_NO_COMPOUND	0
 #define FOLIO_PF_SECOND		1
@@ -488,7 +481,7 @@ static inline int TestClearPage##uname(s
 	TESTSETFLAG_FALSE(uname, lname) TESTCLEARFLAG_FALSE(uname, lname)
 
 __PAGEFLAG(Locked, locked, PF_NO_TAIL)
-PAGEFLAG(Waiters, waiters, PF_ONLY_HEAD)
+FOLIO_FLAG(waiters, FOLIO_HEAD_PAGE)
 PAGEFLAG(Error, error, PF_NO_TAIL) TESTCLEARFLAG(Error, error, PF_NO_TAIL)
 PAGEFLAG(Referenced, referenced, PF_HEAD)
 	TESTCLEARFLAG(Referenced, referenced, PF_HEAD)
@@ -1138,7 +1131,6 @@ static inline bool folio_has_private(str
 
 #undef PF_ANY
 #undef PF_HEAD
-#undef PF_ONLY_HEAD
 #undef PF_NO_TAIL
 #undef PF_NO_COMPOUND
 #undef PF_SECOND
_

Patches currently in -mm which might be from willy@infradead.org are

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch
mm-use-folio-more-widely-in-__split_huge_page.patch
mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch

